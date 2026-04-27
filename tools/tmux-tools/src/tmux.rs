use std::ffi::OsString;
use std::io::{self, BufRead, BufReader};
use std::os::unix::process::CommandExt;
use std::process::{Command, ExitStatus, Stdio};

/// Maximum tmux session-name length accepted by these tools.
///
/// This preserves the original tool's bounded session identifier contract.
pub const MAX_SESSION_NAME_LEN: usize = 256;

/// Errors produced while translating tmux state into tool decisions.
#[derive(Debug)]
pub enum Error {
    /// The requested tmux session name is longer than `MAX_SESSION_NAME_LEN`.
    SessionNameTooLong,

    /// The CLI explicitly supplied an empty tmux session name.
    EmptySessionName,

    /// The `tmux list-sessions` output did not match the expected format.
    InvalidSessionLine(String),

    /// A tmux subprocess exited unsuccessfully.
    TmuxCommandFailed {
        /// Command that was sent to tmux.
        args: Vec<OsString>,

        /// Exit status returned by the subprocess.
        status: ExitStatus,
    },

    /// The operating system rejected or failed a tmux process operation.
    Io(io::Error),
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::SessionNameTooLong => write!(
                f,
                "session name is longer than {MAX_SESSION_NAME_LEN} bytes"
            ),
            Self::EmptySessionName => write!(f, "session name cannot be empty"),
            Self::InvalidSessionLine(line) => {
                write!(f, "invalid tmux session line: {line:?}")
            }
            Self::TmuxCommandFailed { args, status } => {
                write!(f, "tmux command {args:?} failed with {status}")
            }
            Self::Io(err) => write!(f, "{err}"),
        }
    }
}

impl std::error::Error for Error {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            Self::Io(err) => Some(err),
            _ => None,
        }
    }
}

impl From<io::Error> for Error {
    fn from(value: io::Error) -> Self {
        Self::Io(value)
    }
}

/// Result alias for tmux tool operations.
pub type Result<T> = std::result::Result<T, Error>;

/// A parsed tmux session from `list-sessions`.
#[derive(Debug, Clone, Eq, PartialEq)]
pub struct Session {
    /// Session name exactly as reported by tmux.
    pub name: String,

    /// Whether the session is attached to a terminal.
    pub attached: bool,
}

impl Session {
    /// Parses one `tmux list-sessions -F "#S #{session_attached}"` record.
    ///
    /// The last space is the separator because tmux session names may contain
    /// spaces.
    fn parse(line: &str) -> Result<Self> {
        let Some((name, attached)) = line.rsplit_once(' ') else {
            return Err(Error::InvalidSessionLine(line.to_owned()));
        };

        if name.is_empty() {
            return Err(Error::InvalidSessionLine(line.to_owned()));
        }

        let attached = match attached {
            "0" => false,
            "1" => true,
            _ => return Err(Error::InvalidSessionLine(line.to_owned())),
        };

        Ok(Self {
            name: name.to_owned(),
            attached,
        })
    }
}

/// Command boundary for all tmux operations.
///
/// Callers ask this type for tmux state and final process handoff,
/// instead of constructing subprocess calls directly.
#[derive(Debug, Clone)]
pub struct Tmux {
    program: OsString,
}

impl Tmux {
    /// Builds a tmux command boundary using the default `tmux` executable.
    pub fn new() -> Self {
        Self {
            program: OsString::from("tmux"),
        }
    }

    /// Reports whether the tmux server is running.
    pub fn server_running(&self) -> Result<bool> {
        let status = self
            .command(["server-info"])
            .stdin(Stdio::null())
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .status()?;

        Ok(status.success())
    }

    /// Starts the tmux server.
    pub fn start_server(&self) -> Result<()> {
        let status = self
            .command(["start-server"])
            .stdin(Stdio::null())
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .status()?;

        if status.success() {
            Ok(())
        } else {
            Err(Error::TmuxCommandFailed {
                args: self.args(["start-server"]),
                status,
            })
        }
    }

    /// Lists currently running tmux sessions.
    pub fn list_sessions(&self) -> Result<Vec<Session>> {
        let mut child = self
            .command(["list-sessions", "-F", "#S #{session_attached}"])
            .stdin(Stdio::null())
            .stdout(Stdio::piped())
            .stderr(Stdio::null())
            .spawn()?;

        let stdout = child.stdout.take().ok_or_else(|| {
            io::Error::new(io::ErrorKind::BrokenPipe, "tmux stdout pipe was not opened")
        })?;

        let mut sessions = Vec::new();
        for line in BufReader::new(stdout).lines() {
            sessions.push(Session::parse(&line?)?);
        }

        let status = child.wait()?;
        if !status.success() {
            return Err(Error::TmuxCommandFailed {
                args: self.args(["list-sessions", "-F", "#S #{session_attached}"]),
                status,
            });
        }

        Ok(sessions)
    }

    /// Attaches to the given tmux session, replacing the current process.
    pub fn exec_attach_session(&self, session_name: &str) -> io::Error {
        self.command(["attach-session", "-t", session_name]).exec()
    }

    /// Starts a new tmux session, replacing the current process.
    pub fn exec_new_session(
        &self,
        session_name: Option<&str>,
        command_args: &[OsString],
    ) -> io::Error {
        let mut command = Command::new(&self.program);
        command.arg("new-session");
        if let Some(name) = session_name {
            command.args(["-s", name]);
        }
        command.args(command_args);
        command.exec()
    }

    fn command<const N: usize>(&self, args: [&str; N]) -> Command {
        let mut command = Command::new(&self.program);
        command.args(args);
        command
    }

    fn args<const N: usize>(&self, args: [&str; N]) -> Vec<OsString> {
        std::iter::once(self.program.clone())
            .chain(args.into_iter().map(OsString::from))
            .collect()
    }
}

impl Default for Tmux {
    fn default() -> Self {
        Self::new()
    }
}

/// Final process handoff chosen from the requested session and tmux inventory.
#[derive(Debug, Clone, Copy, Eq, PartialEq)]
pub enum Action {
    /// Attach to an existing detached session with the requested name.
    Attach,

    /// Create a new session using the requested name.
    NewNamed,

    /// Create a new session without naming it.
    NewUnnamed,
}

impl Action {
    /// Chooses the tmux transfer after scanning the full session inventory.
    pub fn choose(sessions: &[Session], wanted_name: &str) -> Self {
        match sessions.iter().find(|session| session.name == wanted_name) {
            Some(session) if session.attached => Self::NewUnnamed,
            Some(_) => Self::Attach,
            None => Self::NewNamed,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_detached_session_line() {
        assert_eq!(
            Session::parse("main 0").unwrap(),
            Session {
                name: "main".to_owned(),
                attached: false
            }
        );
    }

    #[test]
    fn parse_attached_session_name_with_spaces() {
        assert_eq!(
            Session::parse("work stuff 1").unwrap(),
            Session {
                name: "work stuff".to_owned(),
                attached: true
            }
        );
    }

    #[test]
    fn parse_rejects_missing_separator() {
        assert!(matches!(
            Session::parse("main"),
            Err(Error::InvalidSessionLine(_))
        ));
    }

    #[test]
    fn parse_rejects_empty_name() {
        assert!(matches!(
            Session::parse(" 0"),
            Err(Error::InvalidSessionLine(_))
        ));
    }

    #[test]
    fn parse_rejects_invalid_attached_marker() {
        assert!(matches!(
            Session::parse("main 2"),
            Err(Error::InvalidSessionLine(_))
        ));
    }

    #[test]
    fn action_attaches_to_existing_detached_session() {
        let sessions = vec![Session {
            name: "main".to_owned(),
            attached: false,
        }];

        assert_eq!(Action::choose(&sessions, "main"), Action::Attach);
    }

    #[test]
    fn action_creates_unnamed_session_when_existing_session_is_attached() {
        let sessions = vec![Session {
            name: "main".to_owned(),
            attached: true,
        }];

        assert_eq!(Action::choose(&sessions, "main"), Action::NewUnnamed);
    }

    #[test]
    fn action_creates_named_session_when_requested_session_is_missing() {
        let sessions = vec![Session {
            name: "other".to_owned(),
            attached: false,
        }];

        assert_eq!(Action::choose(&sessions, "main"), Action::NewNamed);
    }
}

use std::env;
use std::ffi::OsString;
use std::path::PathBuf;
use std::process::ExitCode;

use tmux_tools::tmux::{Error as TmuxError, Session, Tmux, MAX_SESSION_NAME_LEN};

/// Command line accepted by `topen`.
#[derive(Debug, Eq, PartialEq)]
struct Cli {
    /// Explicit tmux session target supplied with `-s`.
    session_name: Option<String>,

    /// Directory that tmux should use as the new window's working directory.
    directory: PathBuf,
}

#[derive(Debug)]
enum Error {
    /// The command line does not describe one target directory.
    Usage(&'static str),

    /// The requested path is not a directory.
    NotDirectory(PathBuf),

    /// A tmux operation failed.
    Tmux(TmuxError),
}

/// Required session preparation before opening the requested tmux window.
#[derive(Debug, Clone, Copy, Eq, PartialEq)]
enum WindowTarget {
    /// The session already exists, so `new-window` can target it directly.
    OpenWindow,

    /// The session must be created before `new-window` can target it.
    CreateSessionAndOpenWindow,
}

impl WindowTarget {
    /// Chooses whether `topen` must provision the target session first.
    fn choose<I>(sessions: I, wanted_name: &str) -> Result<Self, TmuxError>
    where
        I: IntoIterator<Item = Result<Session, TmuxError>>,
    {
        for session in sessions {
            if session?.name == wanted_name {
                return Ok(Self::OpenWindow);
            }
        }

        Ok(Self::CreateSessionAndOpenWindow)
    }
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Usage(reason) => write!(f, "{reason}\nusage: topen [-s session] <dir>"),
            Self::NotDirectory(path) => write!(f, "{} is not a directory", path.display()),
            Self::Tmux(err) => write!(f, "{err}"),
        }
    }
}

impl std::error::Error for Error {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            Self::Tmux(err) => Some(err),
            _ => None,
        }
    }
}

impl From<TmuxError> for Error {
    fn from(value: TmuxError) -> Self {
        Self::Tmux(value)
    }
}

impl Cli {
    /// Parses process arguments into the target session and directory.
    fn parse<I>(mut args: I) -> Result<Self, Error>
    where
        I: Iterator<Item = OsString>,
    {
        _ = args.next();

        let mut session_name = None;
        let mut directory = None;

        while let Some(arg) = args.next() {
            if arg == "-s" {
                let Some(name) = args.next() else {
                    return Err(Error::Usage("missing session name after -s"));
                };

                let name = name.to_string_lossy().into_owned();
                if name.is_empty() {
                    return Err(TmuxError::EmptySessionName.into());
                }
                if name.len() > MAX_SESSION_NAME_LEN {
                    return Err(TmuxError::SessionNameTooLong.into());
                }

                session_name = Some(name);
                continue;
            }

            if directory.replace(PathBuf::from(arg)).is_some() {
                return Err(Error::Usage("expected exactly one directory"));
            }
        }

        let Some(directory) = directory else {
            return Err(Error::Usage("missing directory"));
        };

        Ok(Self {
            session_name,
            directory,
        })
    }
}

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(err) => {
            eprintln!("topen: {err}");
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<(), Error> {
    let cli = Cli::parse(env::args_os())?;
    if !cli.directory.is_dir() {
        return Err(Error::NotDirectory(cli.directory));
    }

    let tmux = Tmux::new();
    let session_name = match cli.session_name {
        Some(name) => name,
        None if env::var_os("TMUX").is_some() => tmux.current_session_name()?,
        None => "main".to_owned(),
    };

    if WindowTarget::choose(tmux.list_sessions()?, &session_name)?
        == WindowTarget::CreateSessionAndOpenWindow
    {
        tmux.new_detached_session(&session_name, &cli.directory)?;
    }
    tmux.new_window(&session_name, &cli.directory)?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn args<'a>(values: &'a [&'a str]) -> impl Iterator<Item = OsString> + 'a {
        values.iter().map(OsString::from)
    }

    #[test]
    fn parse_accepts_directory_only() {
        let cli = Cli::parse(args(&["topen", "/tmp"])).unwrap();

        assert_eq!(
            cli,
            Cli {
                session_name: None,
                directory: PathBuf::from("/tmp")
            }
        );
    }

    #[test]
    fn parse_accepts_explicit_session() {
        let cli = Cli::parse(args(&["topen", "-s", "work", "/tmp"])).unwrap();

        assert_eq!(
            cli,
            Cli {
                session_name: Some("work".to_owned()),
                directory: PathBuf::from("/tmp")
            }
        );
    }

    #[test]
    fn parse_rejects_missing_directory() {
        assert!(matches!(
            Cli::parse(args(&["topen", "-s", "work"])),
            Err(Error::Usage("missing directory"))
        ));
    }

    #[test]
    fn parse_rejects_missing_session_name() {
        assert!(matches!(
            Cli::parse(args(&["topen", "-s"])),
            Err(Error::Usage("missing session name after -s"))
        ));
    }

    #[test]
    fn parse_rejects_empty_session_name() {
        assert!(matches!(
            Cli::parse(args(&["topen", "-s", "", "/tmp"])),
            Err(Error::Tmux(TmuxError::EmptySessionName))
        ));
    }

    #[test]
    fn parse_rejects_oversized_session_name() {
        let name = "x".repeat(MAX_SESSION_NAME_LEN + 1);

        assert!(matches!(
            Cli::parse(
                vec![
                    OsString::from("topen"),
                    OsString::from("-s"),
                    OsString::from(name),
                    OsString::from("/tmp"),
                ]
                .into_iter()
            ),
            Err(Error::Tmux(TmuxError::SessionNameTooLong))
        ));
    }

    #[test]
    fn parse_rejects_extra_directory() {
        assert!(matches!(
            Cli::parse(args(&["topen", "/tmp", "/var"])),
            Err(Error::Usage("expected exactly one directory"))
        ));
    }

    #[test]
    fn window_target_creates_missing_session_before_opening_window() {
        let sessions = Vec::<Result<tmux_tools::tmux::Session, TmuxError>>::new();

        assert!(matches!(
            WindowTarget::choose(sessions, "work"),
            Ok(WindowTarget::CreateSessionAndOpenWindow)
        ));
    }

    #[test]
    fn window_target_opens_existing_session_directly() {
        let sessions = vec![Ok(Session {
            name: "work".to_owned(),
            attached: true,
        })];

        assert!(matches!(
            WindowTarget::choose(sessions, "work"),
            Ok(WindowTarget::OpenWindow)
        ));
    }
}

use std::env;
use std::ffi::OsString;
use std::process::ExitCode;

use tmux_tools::tmux::{Action, Error, Tmux, MAX_SESSION_NAME_LEN};

/// Command line accepted by `tmux-smart-attach`.
#[derive(Debug, Eq, PartialEq)]
struct Cli {
    /// Session name requested by the operator.
    session_name: String,

    /// Command and arguments forwarded to `tmux new-session`.
    command_args: Vec<OsString>,
}

impl Cli {
    /// Parses process arguments into the session request and forwarded command.
    fn parse<I>(mut args: I) -> Result<Self, Error>
    where
        I: Iterator<Item = OsString>,
    {
        _ = args.next(); // program name

        let Some(session_name) = args.next() else {
            return Ok(Self {
                session_name: "main".to_owned(),
                command_args: Vec::new(),
            });
        };

        let session_name = session_name.to_string_lossy().into_owned();
        if session_name.is_empty() {
            return Err(Error::EmptySessionName);
        }
        if session_name.len() > MAX_SESSION_NAME_LEN {
            return Err(Error::SessionNameTooLong);
        }

        Ok(Self {
            session_name,
            command_args: args.collect(),
        })
    }
}

fn main() -> ExitCode {
    match run() {
        Ok(never) => never,
        Err(err) => {
            eprintln!("tmux-smart-attach: {err}");
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<ExitCode, Error> {
    let cli = Cli::parse(env::args_os())?;
    let tmux = Tmux::new();

    if !tmux.server_running()? {
        tmux.start_server()?;
    }

    let action = Action::choose(tmux.list_sessions()?, &cli.session_name)?;
    let exec_error = match action {
        Action::Attach => tmux.exec_attach_session(&cli.session_name),
        Action::NewNamed => tmux.exec_new_session(Some(&cli.session_name), &cli.command_args),
        Action::NewUnnamed => tmux.exec_new_session(None, &cli.command_args),
    };

    Err(Error::Io(exec_error))
}

#[cfg(test)]
mod tests {
    use super::*;

    fn args<'a>(values: &'a [&'a str]) -> impl Iterator<Item = OsString> + 'a {
        values.iter().map(OsString::from)
    }

    #[test]
    fn parse_defaults_to_main() {
        let cli = Cli::parse(args(&["tmux-smart-attach"])).unwrap();

        assert_eq!(
            cli,
            Cli {
                session_name: "main".to_owned(),
                command_args: Vec::new()
            }
        );
    }

    #[test]
    fn parse_keeps_command_arguments_after_session_name() {
        let cli = Cli::parse(args(&["tmux-smart-attach", "work", "zsh", "-l"])).unwrap();

        assert_eq!(cli.session_name, "work");
        assert_eq!(
            cli.command_args,
            vec![OsString::from("zsh"), OsString::from("-l")]
        );
    }

    #[test]
    fn parse_rejects_empty_session_name() {
        assert!(matches!(
            Cli::parse(args(&["tmux-smart-attach", ""])),
            Err(Error::EmptySessionName)
        ));
    }

    #[test]
    fn parse_rejects_oversized_session_name() {
        let name = "x".repeat(MAX_SESSION_NAME_LEN + 1);

        assert!(matches!(
            Cli::parse(vec![OsString::from("tmux-smart-attach"), OsString::from(name)].into_iter()),
            Err(Error::SessionNameTooLong)
        ));
    }
}

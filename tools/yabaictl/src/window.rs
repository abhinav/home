use crate::yabai;

#[derive(clap::Args, Debug)]
pub struct Args {
    #[command(subcommand)]
    cmd: Command,
}

/// Subcommands of the `window` subcommand.
#[derive(clap::Subcommand, Debug)]
enum Command {
    /// Focus the next window.
    Next,

    /// Focus the previous window.
    Previous,
}

/// Run the `window` subcommand.
pub fn run(args: &Args, yabai: &mut yabai::Client) -> anyhow::Result<()> {
    match &args.cmd {
        Command::Next => yabai.focus_window(yabai.next_window()?)?,
        Command::Previous => yabai.focus_window(yabai.prev_window()?)?,
    }

    Ok(())
}

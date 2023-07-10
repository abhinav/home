//! yabaictl is a command line tool implementing custom window management
//! operations on top of yabai.

use clap::{self, Parser};

mod pool;
mod space;
mod window;
mod yabai;

/// Custom window management operations on top of yabai.
#[derive(clap::Parser, Debug)]
struct Args {
    /// Subcommand to run.
    #[command(subcommand)]
    cmd: Command,
}

#[derive(clap::Subcommand, Debug)]
enum Command {
    /// Manage spaces on the current display.
    Space(space::Args),

    /// Manage windows.
    Window(window::Args),
}

fn main() -> anyhow::Result<()> {
    let args = Args::parse();
    let mut yabai_client = yabai::Client::new();
    match &args.cmd {
        Command::Space(args) => space::run(args, &mut yabai_client),
        Command::Window(args) => window::run(args, &mut yabai_client),
    }
}

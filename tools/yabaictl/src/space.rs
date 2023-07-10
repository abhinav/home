//! Adds space management commands to yabaictl.

use anyhow::Context;

use crate::yabai;

#[derive(clap::Args, Debug)]
pub struct Args {
    #[command(subcommand)]
    cmd: Command,
}

/// Subcommands of the `space` subcommand.
#[derive(clap::Subcommand, Debug)]
enum Command {
    /// Create a new space.
    Create {
        /// Move the current window to the new space.
        #[arg(long)]
        move_window: bool,
    },

    /// Delete the current space.
    Delete,

    /// Focus the next space.
    Next {
        /// Move the current window to the new space.
        #[arg(long)]
        move_window: bool,
    },

    /// Focus the previous space.
    Previous {
        /// Move the current window to the new space.
        #[arg(long)]
        move_window: bool,
    },

    /// Cycle the layout used by the current space.
    CycleLayout,
}

/// Run the `space` subcommand.
pub fn run(args: &Args, yabai: &mut yabai::Client) -> anyhow::Result<()> {
    match &args.cmd {
        Command::Create { move_window } => {
            yabai.create_space().context("error creating space")?;

            let new_space = yabai.last_space()?;
            let target_space = yabai.next_space()?;

            if *move_window {
                yabai
                    .move_window_to_space(new_space)
                    .context("error moving window to space")?;
            }

            yabai.move_space(new_space, target_space)?;
            yabai.focus_space(target_space)?;
        }

        Command::Delete => {
            let current_space = yabai.current_space()?;
            let next_space = yabai.prev_space().or_else(|_| yabai.next_space())?;

            yabai.focus_space(next_space)?;
            yabai.destroy_space(current_space.index)?;
        }

        Command::Next { move_window } | Command::Previous { move_window } => {
            let next_space = match &args.cmd {
                Command::Next { .. } => yabai.next_space()?,
                Command::Previous { .. } => yabai.prev_space()?,
                _ => unreachable!(),
            };

            if *move_window {
                yabai
                    .move_window_to_space(next_space)
                    .context("error moving window to space")?;
            }

            yabai.focus_space(next_space)?;
        }

        Command::CycleLayout => {
            let current_space = yabai.current_space()?;
            let next_layout = match current_space.layout.as_str() {
                "bsp" => "stack",
                "stack" => "bsp",
                _ => "bsp",
            };
            yabai
                .set_space_layout(next_layout)
                .context("error setting layout")?;
        }
    }

    Ok(())
}

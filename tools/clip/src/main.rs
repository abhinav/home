use clap::Parser;
use std::{env, error::Error, io::Read, process::Command};

use arboard::Clipboard;

#[derive(clap::Parser)]
struct Cli {
    #[clap(subcommand)]
    cmd: Cmd,
}

#[derive(clap::Subcommand)]
enum Cmd {
    /// Prints the contents of the clipboard to stdout.
    Get,

    /// Feeds the contents of stdin to the clipboard.
    Set,
}

fn main() -> Result<(), Box<dyn Error>> {
    let cli = Cli::parse();
    let use_tmux_clipboard = cfg!(target_os = "linux")
        && env::var_os("DISPLAY").map_or(true, |display| display.is_empty())
        && env::var_os("TMUX").is_some_and(|session| !session.is_empty());

    match &cli.cmd {
        Cmd::Get => clip_get(&mut Clipboard::new()?),
        Cmd::Set if use_tmux_clipboard => clip_set_with_tmux(),
        Cmd::Set => clip_set(&mut Clipboard::new()?),
    }
}

fn clip_get(clipboard: &mut Clipboard) -> Result<(), Box<dyn Error>> {
    let contents = clipboard.get_text()?;
    print!("{}", &contents);

    Ok(())
}

fn clip_set(clipboard: &mut Clipboard) -> Result<(), Box<dyn Error>> {
    let mut contents = String::new();
    std::io::stdin().read_to_string(&mut contents)?;
    clipboard.set_text(&contents)?;

    Ok(())
}

/// Writes stdin to tmux's active client clipboard using OSC 52.
fn clip_set_with_tmux() -> Result<(), Box<dyn Error>> {
    let status = Command::new("tmux")
        .args(["load-buffer", "-w", "-"])
        .status()?;

    if status.success() {
        Ok(())
    } else {
        Err(format!("tmux load-buffer failed with {status}").into())
    }
}

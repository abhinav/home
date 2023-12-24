use clap::Parser;
use std::{error::Error, io::Read};

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
    let mut clipboard = Clipboard::new()?;
    let cli = Cli::parse();

    match &cli.cmd {
        Cmd::Get => clip_get(&mut clipboard),
        Cmd::Set => clip_set(&mut clipboard),
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

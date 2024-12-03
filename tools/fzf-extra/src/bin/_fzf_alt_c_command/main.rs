use std::{
    io::{self, BufRead, Write},
    process,
};

pub fn main() -> Result<(), Box<dyn std::error::Error>> {
    if let Ok(n) = list_git() {
        if n > 0 {
            return Ok(());
        }
    }

    list_find()?;
    Ok(())
}

// Lists directories found by git, and returns the number of directories found.
fn list_git() -> Result<i64, io::Error> {
    let mut child = process::Command::new("git")
        .args(["ls-tree", "-d", "-r", "--name-only", "HEAD"])
        .stderr(process::Stdio::null())
        .stdout(process::Stdio::piped())
        .spawn()?;

    let mut git_stdout = child.stdout.take().unwrap();
    let mut git_stdout_r = io::BufReader::new(&mut git_stdout);
    let mut stdout_w = io::BufWriter::new(io::stdout());

    let mut line = String::new();
    let mut count = 0;
    loop {
        line.clear();

        let read_bytes = git_stdout_r.read_line(&mut line)?;
        if read_bytes == 0 {
            break;
        }

        let line = line.trim_end();
        if line.starts_with("../") || line == "./" {
            continue;
        }

        count += 1;
        writeln!(stdout_w, "{}", line)?;
    }

    child.wait()?;
    Ok(count)
}

fn list_find() -> Result<(), io::Error> {
    let mut child = process::Command::new("find")
        .args(["-L", "."])
        .args([
            "(", "-path", "*/.*", // ignore hidden
            "-o", "-fstype", "dev", // ignore devices
            "-o", "-fstype", "proc", // ignore /proc
            ")", "-prune",
        ])
        .args(["-o", "-type", "d", "-print"])
        .stderr(process::Stdio::null())
        .stdout(process::Stdio::piped())
        .spawn()?;

    let mut find_stdout = child.stdout.take().unwrap();
    let mut find_stdout_r = io::BufReader::new(&mut find_stdout);
    let mut stdout_w = io::BufWriter::new(io::stdout());

    let mut line = String::new();
    find_stdout_r.read_line(&mut line)?; // drop the first line (".")

    loop {
        line.clear();

        let read_bytes = find_stdout_r.read_line(&mut line)?;
        if read_bytes == 0 {
            break;
        }

        let line = line.strip_prefix("./").unwrap_or(&line);
        write!(stdout_w, "{}", line)?;
    }

    child.wait()?;
    Ok(())
}

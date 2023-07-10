#![allow(dead_code)] // TODO: remove

use std::{cmp::Ordering, ffi, fmt, io::Write, os::unix::prelude::OsStrExt, process};

use serde::{de::DeserializeOwned, Deserialize};

use crate::pool;

/// Client provides access to yabai operations.
///
/// Client is not thread-safe.
pub struct Client {
    buffer_pool: pool::Pool<Vec<u8>>,
    runner: Box<dyn driver::Runner>,
}

/// Index of a space in the display it's on.
#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash, Deserialize)]
pub struct SpaceIndex(u32);

/// Unique identifier for a window.
#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash, Deserialize)]
pub struct WindowId(u32);

/// Information about a single space.
#[derive(Deserialize, Debug)]
pub struct Space {
    /// Position of the space on the display.
    pub index: SpaceIndex,

    /// Whether the space is running an app in fullscreen.
    #[serde(rename = "is-native-fullscreen")]
    pub is_fullscreen: bool,

    /// Whether the space is focused.
    #[serde(rename = "has-focus")]
    pub has_focus: bool,

    /// The layout mode that this space is using.
    #[serde(rename = "type")]
    pub layout: String,
}

impl Client {
    pub fn new() -> Self {
        Self {
            buffer_pool: pool::Pool::new(|| Vec::with_capacity(1024), |buf| buf.clear()),
            runner: Box::new(DefaultRunner),
        }
    }

    /// Creats a new space.
    pub fn create_space(&self) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "space", "--create"])
            .run(&self.runner)
    }

    /// Destroys a space.
    pub fn destroy_space(&self, space: SpaceIndex) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "space", "--destroy"])
            .arg(self.buf_format(space.0))
            .run(&self.runner)
    }

    /// Moves the currently focused window to the given space.
    pub fn move_window_to_space(&self, space: SpaceIndex) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "window", "--space"])
            .arg(self.buf_format(space.0))
            .run(&self.runner)
    }

    /// Reports the index of the currently focused space.
    pub fn current_space(&self) -> anyhow::Result<Space> {
        Command::new()
            .args(["-m", "query", "--spaces", "--space"])
            .output(&self.runner)
    }

    /// Moves a space to a new position.
    pub fn move_space(&self, from: SpaceIndex, to: SpaceIndex) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "space"])
            .arg(self.buf_format(from.0))
            .arg("--move")
            .arg(self.buf_format(to.0))
            .run(&self.runner)
    }

    /// Sets the layout mode for the current space.
    pub fn set_space_layout(&self, mode: &str) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "space", "--layout", mode])
            .run(&self.runner)
    }

    /// Focuses on a space.
    pub fn focus_space(&self, space: SpaceIndex) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "space", "--focus"])
            .arg(self.buf_format(space.0))
            .run(&self.runner)
    }

    /// Reports the index of the last non-fullscreen space.
    pub fn last_space(&self) -> anyhow::Result<SpaceIndex> {
        // TODO: return Space object from query,
        // implement last_space logic separately

        let spaces: Vec<Space> = Command::new()
            .args(["-m", "query", "--spaces", "--display"])
            .output(&self.runner)?;

        for sp in spaces.iter().rev() {
            if !sp.is_fullscreen {
                return Ok(sp.index);
            }
        }

        anyhow::bail!("no non-fullscreen spaces found");
    }

    /// Reports the index of the next space.
    ///
    /// Fails if this is the last space on the display.
    pub fn next_space(&self) -> anyhow::Result<SpaceIndex> {
        self.space_offset(1)
    }

    /// Reports the index of the previous space.
    ///
    /// Fails if this is the first space on the display.
    pub fn prev_space(&self) -> anyhow::Result<SpaceIndex> {
        self.space_offset(-1)
    }

    fn space_offset(&self, offset: i32) -> anyhow::Result<SpaceIndex> {
        // TODO: thiserror for structured errors

        let mut spaces: Vec<Space> = Command::new()
            .args(["-m", "query", "--spaces", "--display"])
            .output(&self.runner)?;
        spaces.sort_by(|a, b| a.index.0.cmp(&b.index.0));

        for (i, space) in spaces.iter().enumerate() {
            if !space.has_focus {
                continue;
            }

            let sibling = i as i32 + offset;
            if sibling < 0 || sibling >= spaces.len() as i32 {
                anyhow::bail!("sibling out of bounds: {}/{}", offset, spaces.len());
            }

            return Ok(spaces[sibling as usize].index);
        }

        anyhow::bail!("no focused space found");
    }

    /// Focuses on the window with the given ID.
    pub fn focus_window(&self, win: WindowId) -> anyhow::Result<()> {
        Command::new()
            .args(["-m", "window", "--focus"])
            .arg(self.buf_format(win.0))
            .run(&self.runner)
    }

    /// Reports the ID of the next window.
    pub fn next_window(&self) -> anyhow::Result<WindowId> {
        self.window_offset(1)
    }

    /// Reports the ID of the previous window.
    pub fn prev_window(&self) -> anyhow::Result<WindowId> {
        self.window_offset(-1)
    }

    /// Returns the ID of the window that is a sibling of the currently focused window,
    /// offset by the given amount, cycling around if necessary.
    /// For example, `window_offset(1)` returns the ID of the next window.
    ///
    /// Windows under consideration are chosen as follows:
    ///
    /// - if the current space is in stacked mode,
    ///   the windows in the current space are considered
    /// - otherwise, windows in visible spaces are considered
    ///
    /// Windows are sorted by their position in their space,
    /// grouped by the display they are on.
    fn window_offset(&self, offset: i32) -> anyhow::Result<WindowId> {
        #[derive(Deserialize)]
        struct Frame {
            x: f64,
            y: f64,
        }

        #[derive(Deserialize)]
        struct Window {
            id: WindowId,

            #[serde(rename = "has-focus")]
            has_focus: bool,

            #[serde(rename = "is-visible")]
            is_visible: bool,

            #[serde(rename = "stack-index")]
            stack_index: u32,

            #[serde(rename = "display")]
            display: u32,

            #[serde(rename = "space")]
            space: SpaceIndex,

            #[serde(rename = "frame")]
            frame: Frame,
        }

        let mut windows: Vec<Window> = Command::new()
            .args(["-m", "query", "--windows"])
            .output(&self.runner)?;

        let (focused, stacked) = {
            let mut focused: Option<usize> = None;
            let mut stacked = false;
            let mut idx = 0;
            windows.retain(|w| {
                if w.has_focus {
                    focused = Some(idx);
                }
                stacked = stacked || w.stack_index > 0;
                idx += 1;

                w.is_visible
            });

            (focused, stacked)
        };

        if windows.is_empty() {
            anyhow::bail!("no windows found");
        }

        // Sort by {display, x, y}.
        windows.sort_by(|a, b| {
            if a.display != b.display {
                return a.display.cmp(&b.display);
            }
            (a.frame.x, a.frame.y)
                .partial_cmp(&(b.frame.x, b.frame.y))
                .unwrap_or(Ordering::Equal)
        });

        let focused = match focused {
            Some(idx) => idx,
            None => {
                // If none of the windows are focused, return the first one.
                return Ok(windows[0].id);
            }
        };

        // If we're in stacked mode, only consider windows in the current space.
        if stacked {
            let space = windows[focused].space;
            windows.retain(|w| w.space == space);
            if windows.is_empty() {
                anyhow::bail!("no windows found");
            }
        }

        let mut idx = focused as i32 + offset;
        while idx < 0 {
            idx += windows.len() as i32;
        }
        if idx as usize >= windows.len() {
            idx %= windows.len() as i32;
        }

        Ok(windows[idx as usize].id)
    }

    fn buf_format<N: fmt::Display>(&self, n: N) -> PooledOsString {
        let mut buffer = self.buffer_pool.get();
        write!(&mut buffer, "{}", n).unwrap();

        PooledOsString { buffer }
    }
}

struct PooledOsString<'a> {
    buffer: pool::Item<'a, Vec<u8>>,
}

impl<'a> AsRef<ffi::OsStr> for PooledOsString<'a> {
    fn as_ref(&self) -> &ffi::OsStr {
        ffi::OsStr::from_bytes(self.buffer.as_slice())
    }
}

/// Wraps a `process::Command` to run yabai.
struct Command(process::Command);

impl Command {
    /// Creates a new command to run yabai.
    pub fn new() -> Self {
        Self(process::Command::new("yabai"))
    }

    /// Adds an argument to the command.
    pub fn arg<S: AsRef<ffi::OsStr>>(&mut self, arg: S) -> &mut Self {
        self.0.arg(arg);
        self
    }

    /// Adds multiple arguments to the command.
    pub fn args<S: AsRef<ffi::OsStr>>(&mut self, args: impl IntoIterator<Item = S>) -> &mut Self {
        self.0.args(args);
        self
    }

    /// Run the command, failing if it exits with a non-zero status.
    pub fn run(&mut self, runner: impl driver::Runner) -> anyhow::Result<()> {
        runner.run(&mut self.0)
    }

    /// Run the command and provides access to its output,
    /// failing if it exits with a non-zero status.
    pub fn output<D: DeserializeOwned>(
        &mut self,
        runner: impl driver::Runner,
    ) -> anyhow::Result<D> {
        runner.output(&mut self.0)?.decode()
    }
}

pub struct DefaultRunner;

impl driver::Runner for DefaultRunner {
    fn run(&self, cmd: &mut process::Command) -> anyhow::Result<()> {
        let status = cmd.stderr(process::Stdio::inherit()).status()?;
        if !status.success() {
            anyhow::bail!("{:?} exited with status {}", cmd, status);
        }

        Ok(())
    }

    fn output(&self, cmd: &mut process::Command) -> anyhow::Result<driver::Output> {
        let out = cmd.stderr(process::Stdio::inherit()).output()?;

        let status = out.status;
        if !status.success() {
            anyhow::bail!("{:?} exited with status {}", cmd, status);
        }

        Ok(driver::Output::new(out.stdout))
    }
}

mod driver {
    use std::process;

    use serde::Deserialize;

    /// Runner runs yabai commands.
    pub trait Runner {
        /// Runs the given command, failing if it exits with a non-zero status.
        fn run(&self, cmd: &mut process::Command) -> anyhow::Result<()>;

        /// Runs the given command and provides access to its output,
        /// failing if it exits with a non-zero status.
        fn output(&self, cmd: &mut process::Command) -> anyhow::Result<Output>;
    }

    impl Runner for &Box<dyn Runner> {
        fn run(&self, cmd: &mut process::Command) -> anyhow::Result<()> {
            (**self).run(cmd)
        }

        fn output(&self, cmd: &mut process::Command) -> anyhow::Result<Output> {
            (**self).output(cmd)
        }
    }

    /// Output is the output of a yabai command.
    pub struct Output {
        data: Vec<u8>,
    }

    impl Output {
        /// Builds a new output from the given data.
        pub fn new(data: Vec<u8>) -> Self {
            Self { data }
        }

        /// Decodes the output as JSON.
        pub fn decode<'a, D: Deserialize<'a>>(&'a self) -> anyhow::Result<D> {
            Ok(serde_json::from_slice(&self.data)?)
        }
    }
}

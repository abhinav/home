// _fzf_alt_c_command is invoked by fzf to get a directory listing
// to be used as the source for directory navigation.
//
// This roughly behaves like so:
//
//   - if 'git ls-tree' does not fail _and_ it lists at least one directory,
//     then use the output of 'git ls-tree' as the source
//   - otherwise, use the output of a 'find' command
//     (with some additional filtering)
package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	log.SetFlags(0)

	if ok, err := listGitDirectories(); err != nil {
		log.Fatalf("git: %v", err)
	} else if ok {
		return
	}

	if err := listDirectories(); err != nil {
		log.Fatalf("find: %v", err)
	}
}

func listGitDirectories() (ok bool, err error) {
	cmd := exec.Command("git", "ls-tree", "-d", "-r", "--name-only", "HEAD")
	cmd.Stderr = io.Discard
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return ok, fmt.Errorf("pipe stdout: %w", err)
	}
	if err := cmd.Start(); err != nil {
		return ok, fmt.Errorf("find: %w", err)
	}

	scanner := bufio.NewScanner(stdout)
scanOutput:
	for scanner.Scan() {
		line := scanner.Text()
		if len(line) == 0 {
			continue
		}

		switch {
		case line == ".", line == "./", !filepath.IsLocal(line):
			continue scanOutput
		}

		ok = true
		_, _ = os.Stdout.WriteString(line)
		_, _ = os.Stdout.WriteString("\n")
	}

	if err := scanner.Err(); err != nil {
		return ok, fmt.Errorf("scan output: %w", err)
	}

	return ok, cmd.Wait()
}

func listDirectories() error {
	cmd := exec.Command("find", `-L`, `.`,
		`(`,
		`-path`, `*/.*`, // ignore hidden
		`-o`, `-fstype`, `dev`, // ignore devices
		`-o`, `-fstype`, `proc`, // ignore /proc
		`)`, `-prune`,
		`-o`, `-type`, `d`, `-print`, // print directories
	)
	cmd.Stderr = io.Discard
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return fmt.Errorf("pipe stdout: %w", err)
	}
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("find: %w", err)
	}

	scanner := bufio.NewScanner(stdout)
	_ = scanner.Scan() // drop the first line (".")
	for scanner.Scan() {
		line := scanner.Bytes()
		line = bytes.TrimPrefix(line, []byte("./"))
		if len(line) == 0 {
			continue
		}

		_, _ = os.Stdout.Write(line)
		_, _ = os.Stdout.WriteString("\n")
	}
	if err := scanner.Err(); err != nil {
		return fmt.Errorf("scan output: %w", err)
	}

	return cmd.Wait()
}

type lineCountingWriter struct {
	io.Writer

	count *int
}

func countInto(w io.Writer, count *int) io.Writer {
	return &lineCountingWriter{Writer: w, count: count}
}

func (w *lineCountingWriter) Write(p []byte) (n int, err error) {
	n, err = w.Writer.Write(p)
	*w.count += bytes.Count(p, []byte{'\n'})
	return
}

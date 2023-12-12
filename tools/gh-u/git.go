package main

import (
	"bytes"
	"log/slog"
	"os/exec"
	"strings"

	"braces.dev/errtrace"
)

type Git struct {
	log *slog.Logger
	exe string
}

func NewGit(log *slog.Logger) (*Git, error) {
	exe, err := exec.LookPath("git")
	if err != nil {
		return nil, errtrace.Wrap(err)
	}

	return &Git{
		log: log.With("cmd", "git"),
		exe: exe,
	}, nil
}

func (g *Git) gitExec(stdout, stderr slog.Level, args ...string) error {
	stdoutOut, flush := newLogWriter(g.log.With("args", args), stdout)
	defer flush()

	stderrOut, flush := newLogWriter(g.log.With("args", args), stderr)
	defer flush()

	cmd := exec.Command(g.exe, args...)
	cmd.Stdout = stdoutOut
	cmd.Stderr = stderrOut
	return errtrace.Wrap(cmd.Run())
}

func (g *Git) gitOutput(stderr slog.Level, args ...string) ([]byte, error) {
	stderrOut, flush := newLogWriter(g.log.With("args", args), stderr)
	defer flush()

	cmd := exec.Command(g.exe, args...)
	cmd.Stderr = stderrOut
	bs, err := cmd.Output()
	if err != nil {
		return nil, errtrace.Wrap(err)
	}

	return bytes.TrimSpace(bs), nil
}

func (g *Git) Head(ref string) (string, error) {
	bs, err := g.gitOutput(slog.LevelDebug, "rev-parse", "--quiet", "--verify", ref)
	if err != nil {
		// Branch doesn't exist.
		return "", nil
	}
	return string(bs), nil
}

func (g *Git) DeleteBranch(branch string) error {
	return errtrace.Wrap(g.gitExec(slog.LevelDebug, slog.LevelInfo, "branch", "-D", branch))
}

func (g *Git) CurrentBranch() (string, error) {
	bs, err := g.gitOutput(slog.LevelError, "rev-parse", "--abbrev-ref", "HEAD")
	return string(bs), errtrace.Wrap(err)
}

func (g *Git) RemoteHeadBranch(remoteName string) (string, error) {
	bs, err := g.gitOutput(slog.LevelError, "symbolic-ref", "refs/remotes/"+remoteName+"/HEAD", "--short")
	if err != nil {
		return "", errtrace.Wrap(err)
	}
	return strings.TrimPrefix(string(bs), remoteName+"/"), nil
}

func (g *Git) Checkout(branch string) error {
	return errtrace.Wrap(g.gitExec(slog.LevelDebug, slog.LevelInfo, "checkout", branch))
}

func (g *Git) PullRebase() error {
	return errtrace.Wrap(g.gitExec(slog.LevelDebug, slog.LevelInfo, "pull", "--rebase"))
}

func (g *Git) CommitMessage(commit string) (subject, body string, err error) {
	bs, err := g.gitOutput(slog.LevelError, "log", "-1", "--format=%B", commit)
	if err != nil {
		return "", "", errtrace.Wrap(err)
	}

	lines := strings.SplitN(string(bs), "\n", 2)
	if len(lines) == 0 {
		return "", "", errtrace.New("no commit message found")
	}

	subject = strings.TrimSpace(lines[0])
	if len(lines) > 1 {
		body = strings.TrimSpace(lines[1])
	}
	return subject, body, nil
}

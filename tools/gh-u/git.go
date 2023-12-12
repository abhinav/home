package main

import (
	"bytes"
	"os"
	"os/exec"
	"strings"

	"braces.dev/errtrace"
)

func git(args ...string) error {
	cmd := exec.Command("git", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return errtrace.Wrap(cmd.Run())
}

func gitOutput(args ...string) ([]byte, error) {
	cmd := exec.Command("git", args...)
	cmd.Stderr = os.Stderr
	bs, err := cmd.Output()
	if err != nil {
		return nil, errtrace.Wrap(err)
	}

	return bytes.TrimSpace(bs), nil
}

func gitHead(ref string) (string, error) {
	bs, err := gitOutput("rev-parse", "--quiet", "--verify", ref)
	if err != nil {
		// Branch doesn't exist.
		return "", nil
	}
	return string(bs), nil
}

func gitDeleteBranch(branch string) error {
	return errtrace.Wrap(git("branch", "-D", branch))
}

func gitCurrentBranch() (string, error) {
	bs, err := gitOutput("rev-parse", "--abbrev-ref", "HEAD")
	return string(bs), errtrace.Wrap(err)
}

func gitCheckout(branch string) error {
	return errtrace.Wrap(git("checkout", branch))
}

func gitCommitBody(commit string) (subject, body string, err error) {
	bs, err := gitOutput("log", "-1", "--format=%B", commit)
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

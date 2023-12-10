package main

import (
	"context"
	"os"
	"os/exec"
	"strings"

	"braces.dev/errtrace"
)

func gitHead(ctx context.Context, ref string) (string, error) {
	cmd := exec.CommandContext(ctx, "git", "rev-parse", "--verify", ref)
	bs, err := cmd.Output()
	if err != nil {
		// Branch doesn't exist.
		return "", nil
	}
	return strings.TrimSpace(string(bs)), nil
}

func gitDeleteBranch(ctx context.Context, branch string) error {
	cmd := exec.CommandContext(ctx, "git", "branch", "-D", branch)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return errtrace.Wrap(cmd.Run())
}

func gitCurrentBranch(ctx context.Context) (string, error) {
	bs, err := exec.CommandContext(ctx, "git", "rev-parse", "--abbrev-ref", "HEAD").Output()
	if err != nil {
		return "", errtrace.Wrap(err)
	}
	return strings.TrimSpace(string(bs)), nil
}

func gitCheckout(ctx context.Context, branch string) error {
	cmd := exec.CommandContext(ctx, "git", "checkout", branch)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return errtrace.Wrap(cmd.Run())
}

func gitCommitBody(ctx context.Context, commit string) (subject, body string, err error) {
	bs, err := exec.CommandContext(ctx, "git", "log", "-1", "--format=%B", commit).Output()
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

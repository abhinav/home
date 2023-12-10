package main

import (
	"context"
	"time"

	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
	"github.com/cli/go-gh/v2"
)

type pullUpdateMessageCmd struct {
	Commit string `arg:"" help:"Read message from commit. Defaults to HEAD." default:"HEAD"`
}

func (p *pullUpdateMessageCmd) Run(app *kong.Kong) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	subject, body, err := gitCommitBody(ctx, p.Commit)
	if err != nil {
		return errtrace.Wrap(err)
	}

	_, stderr, err := gh.Exec("pr", "edit", "--title", subject, "--body", body)
	_, _ = app.Stderr.Write(stderr.Bytes())
	return errtrace.Wrap(err)
}

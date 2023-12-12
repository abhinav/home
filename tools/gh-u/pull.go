package main

import (
	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
	"github.com/cli/go-gh/v2"
)

type pullUpdateMessageCmd struct {
	Head string `arg:"" help:"Read message from commit. Defaults to HEAD." default:"HEAD"`
}

func (p *pullUpdateMessageCmd) Run(app *kong.Kong) error {
	subject, body, err := gitCommitBody(p.Head)
	if err != nil {
		return errtrace.Wrap(err)
	}

	_, stderr, err := gh.Exec("pr", "edit", "--title", subject, "--body", body)
	_, _ = app.Stderr.Write(stderr.Bytes())
	return errtrace.Wrap(err)
}

package main

import (
	"strings"

	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
)

type syncCmd struct {
	Cleanup bool `help:"Delete merged branches." default:"true"`
}

func (cmd *syncCmd) Run(app *kong.Kong) error {
	// Gives back "origin/master" or "origin/main".
	bs, err := gitOutput("symbolic-ref", "refs/remotes/origin/HEAD", "--short")
	if err != nil {
		return errtrace.Wrap(err)
	}

	branch := strings.TrimPrefix(string(bs), "origin/")
	if err := gitCheckout(branch); err != nil {
		return errtrace.Wrap(err)
	}

	if err := git("pull", "--rebase"); err != nil {
		return errtrace.Wrap(err)
	}

	if cmd.Cleanup {
		if err := new(branchCleanupCmd).Run(app); err != nil {
			return errtrace.Wrap(err)
		}
	}

	return nil
}

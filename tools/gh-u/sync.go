package main

import (
	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
)

type syncCmd struct {
	Cleanup bool `help:"Delete merged branches." default:"true"`
}

func (cmd *syncCmd) Run(app *kong.Kong, git *Git) error {
	// Gives back "origin/master" or "origin/main".
	branch, err := git.RemoteHeadBranch("origin")
	if err != nil {
		return errtrace.Wrap(err)
	}

	if err := git.Checkout(branch); err != nil {
		return errtrace.Wrap(err)
	}

	if err := git.PullRebase(); err != nil {
		return errtrace.Wrap(err)
	}

	if cmd.Cleanup {
		if err := new(branchCleanupCmd).Run(app, git); err != nil {
			return errtrace.Wrap(err)
		}
	}

	return nil
}

package main

import (
	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
)

var _defaultBranches = []string{"main", "master"}

type repoSyncCmd struct {
	Cleanup bool `help:"Delete merged branches." default:"true"`
}

func (cmd *repoSyncCmd) Run(app *kong.Kong, git *Git) error {
	// Gives back "origin/master" or "origin/main".
	branch, err := git.RemoteHeadBranch("origin")
	if err != nil {
		// HEAD ref may not be fetched.
		// Guess default branch based on whether master or main exists.
		for _, b := range _defaultBranches {
			if ok, err := git.BranchExists(b); ok && err == nil {
				branch = b
				break
			}
			if branch == "" {
				return errtrace.Wrap(err)
			}
		}
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

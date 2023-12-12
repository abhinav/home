package main

import (
	"context"
	"fmt"
	"os"
	"strings"
	"time"

	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
	"github.com/cli/go-gh/v2/pkg/api"
	"github.com/cli/go-gh/v2/pkg/prompter"
	"github.com/cli/go-gh/v2/pkg/repository"
	"github.com/google/go-github/v57/github"
)

type branchCleanupCmd struct {
	Force bool `short:"f" help:"Delete without prompting if branch heads don't match."`
}

func (b *branchCleanupCmd) Run(app *kong.Kong) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	currentBranch, err := gitCurrentBranch()
	if err != nil {
		return errtrace.Wrap(err)
	}

	repo, err := repository.Current()
	if err != nil {
		return errtrace.Wrap(err)
	}

	httpClient, err := api.DefaultHTTPClient()
	if err != nil {
		return errtrace.Wrap(err)
	}
	client := github.NewClient(httpClient)

	// Find recently merged pull requests.
	// We'll only consider the first page of results.
	prs, _, err := client.PullRequests.List(ctx, repo.Owner, repo.Name, &github.PullRequestListOptions{
		State:     "closed",
		Sort:      "updated",
		Direction: "desc",
	})
	if err != nil {
		return errtrace.Wrap(err)
	}

	for _, pr := range prs {
		if pr.MergedAt == nil {
			// TODO: should we also consider closed pull requests that were not merged?
			continue
		}

		head := pr.GetHead()
		ref := head.GetRef()
		branch := strings.TrimPrefix(ref, "refs/heads/")

		// Skip the default branch.
		defaultBranch := pr.GetBase().GetRepo().GetDefaultBranch()
		if defaultBranch == branch {
			continue
		}

		localHead, err := gitHead(ref)
		if err != nil {
			return errtrace.Wrap(err)
		}
		if localHead == "" {
			// Branch doesn't exist locally.
			continue
		}

		if localHead != head.GetSHA() && !b.Force {
			force, err := b.confirmDelete(app, branch)
			if err != nil {
				return errtrace.Wrap(err)
			}
			if !force {
				continue
			}
		}

		app.Printf("Deleting %v (#%v)", branch, pr.GetNumber())

		// Current branch is the same as the branch we're about to delete.
		// Switch to the default branch before deleting.
		if branch == currentBranch {
			app.Printf("Branch %v is current branch. Switching to %v", branch, defaultBranch)
			if err := gitCheckout(defaultBranch); err != nil {
				return errtrace.Wrap(err)
			}
		}

		if err := gitDeleteBranch(branch); err != nil {
			return errtrace.Wrap(err)
		}
	}

	return nil
}

func (b *branchCleanupCmd) confirmDelete(app *kong.Kong, branch string) (bool, error) {
	stdout, ok := app.Stdout.(prompter.FileWriter)
	if !ok {
		stdout = os.Stdout
	}

	stderr, ok := app.Stderr.(prompter.FileWriter)
	if !ok {
		stderr = os.Stderr
	}

	p := prompter.New(os.Stdin, stdout, stderr)
	return errtrace.Wrap2(p.Confirm(
		fmt.Sprintf("Head for branch %v differs from remote. Delete anyway?", branch),
		false, // default
	))
}

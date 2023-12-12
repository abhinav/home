package main

import (
	"context"
	"fmt"
	"os"
	"slices"
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

func (b *branchCleanupCmd) Run(app *kong.Kong, git *Git) error {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	currentBranch, err := git.CurrentBranch()
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
		State:     "all",
		Sort:      "updated",
		Direction: "desc",
	})
	if err != nil {
		return errtrace.Wrap(err)
	}

	// The same branch name can be used for multiple pull requests.
	// We'll delete only those cases where all PRs for a branch have been merged.
	prsByHeadRef := make(map[string][]*github.PullRequest) // head ref => PRs
	var defaultBranch string
	for _, pr := range prs {
		head := pr.GetHead()
		ref := head.GetRef()
		prsByHeadRef[ref] = append(prsByHeadRef[ref], pr)
		if defaultBranch == "" {
			defaultBranch = pr.GetBase().GetRepo().GetDefaultBranch()
		}
	}

	// Invariant: defaultBranch is non-empty if prs is non-empty.
	if defaultBranch == "" && len(prs) > 0 {
		panic(fmt.Sprintf("impossible: defaultBranch is empty but prs is non-empty: %v", prs))
	}

	for headRef, prs := range prsByHeadRef {
		hasOpen := slices.ContainsFunc(prs, func(pr *github.PullRequest) bool {
			return pr.GetState() != "closed" ||
				pr.MergedAt == nil // TODO: should we consider closed but unmerged?
		})
		if hasOpen {
			continue
		}

		branch := strings.TrimPrefix(headRef, "refs/heads/")

		// Don't delete the default branch.
		if defaultBranch == branch {
			continue
		}

		localHead, err := git.Head(headRef)
		if err != nil {
			return errtrace.Wrap(err)
		}
		if localHead == "" {
			// Branch doesn't exist locally.
			continue
		}

		// If one of the PRs matches the local head's position,
		// we don't need to prompt for confirmation.
		prIdx := slices.IndexFunc(prs, func(pr *github.PullRequest) bool {
			return pr.GetHead().GetSHA() == localHead
		})
		if prIdx < 0 && !b.Force {
			force, err := b.confirmDelete(app, branch)
			if err != nil {
				return errtrace.Wrap(err)
			}
			if !force {
				continue
			}
		}

		pr := prs[prIdx]
		app.Printf("Deleting %v (#%v)", branch, pr.GetNumber())

		// Current branch is the same as the branch we're about to delete.
		// Switch to the default branch before deleting.
		if branch == currentBranch {
			app.Printf("Branch %v is current branch. Switching to %v", branch, defaultBranch)
			if err := git.Checkout(defaultBranch); err != nil {
				return errtrace.Wrap(err)
			}
		}

		if err := git.DeleteBranch(branch); err != nil {
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

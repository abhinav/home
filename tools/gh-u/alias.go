package main

import (
	"os/exec"

	"braces.dev/errtrace"
	"github.com/alecthomas/kong"
	"github.com/cli/go-gh/v2"
)

var _aliases = map[string]string{
	"bc":   "branch cleanup",
	"pum":  "pull update message",
	"sync": "sync",
}

type aliasInstallCmd struct {
	Force bool `help:"Overwrite existing aliases." short:"f"`
}

func (cmd *aliasInstallCmd) Run(app *kong.Kong) error {
	ghPath, err := gh.Path()
	if err != nil {
		return errtrace.Wrap(err)
	}

	args := []string{"alias", "set"}
	if cmd.Force {
		args = append(args, "--clobber")
	}

	for alias, command := range _aliases {
		cmd := exec.Command(ghPath, append(args, alias, "u "+command)...)
		cmd.Stdout = app.Stdout
		cmd.Stderr = app.Stderr
		if err := cmd.Run(); err != nil {
			return errtrace.Errorf("alias %v: %w", alias, err)
		}
	}

	return nil
}

type aliasUninstallCmd struct{}

func (cmd *aliasUninstallCmd) Run() error {
	for alias := range _aliases {
		_, _, err := gh.Exec("alias", "delete", alias)
		if err != nil {
			return errtrace.Wrap(err)
		}
	}

	return nil
}

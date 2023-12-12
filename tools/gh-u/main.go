// ghutil is a set of utilities for working with GitHub.
//
// These are specific to my workflow,
// but the code is made available in case it is useful to others.
package main

import (
	"fmt"
	"log/slog"
	"os"
	"slices"
	"strings"

	"github.com/alecthomas/kong"
	"github.com/lmittmann/tint"
)

func main() {
	var lvl slog.LevelVar
	log := slog.New(
		tint.NewHandler(os.Stderr, &tint.Options{
			Level: &lvl,
			ReplaceAttr: func(groups []string, a slog.Attr) slog.Attr {
				// Don't report time.
				if a.Key == slog.TimeKey && len(groups) == 0 {
					return slog.Attr{}
				}
				return a
			},
		}),
	)

	git, err := NewGit(log)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%+v", err)
		os.Exit(1)
	}

	var cmd mainCmd
	ctx := kong.Parse(&cmd,
		kong.Name("gh u"),
		kong.UsageOnError(),
		kong.Writers(os.Stdout, os.Stderr),
		kong.Bind(&lvl, log, git),
		kong.ConfigureHelp(kong.HelpOptions{
			Tree: true,
		}),
		kong.AutoGroup(func(parent kong.Visitable, flag *kong.Flag) *kong.Group {
			if node, ok := parent.(*kong.Node); ok {
				var parts []string
				for n := node; n != nil; n = n.Parent {
					parts = append(parts, n.Name)
				}
				parts = parts[:len(parts)-1] // drop root
				slices.Reverse(parts)

				return &kong.Group{
					Key:   strings.Join(parts, "-"),
					Title: "[" + strings.Join(parts, " ") + "] Flags:",
				}
			}
			return nil
		}),
	)
	if err := ctx.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "%+v", err)
	}
}

type mainCmd struct {
	Verbose verboseFlag `short:"v" help:"Enable verbose output."`

	Alias struct {
		Install   aliasInstallCmd   `cmd:"" help:"Install gh CLI aliases."`
		Uninstall aliasUninstallCmd `cmd:"" help:"Uninstall gh CLI aliases."`
	} `cmd:"" help:"Manage gh CLI aliases."`

	Branch struct {
		Cleanup branchCleanupCmd `cmd:"" help:"Delete merged branches." aliases:"c"`
	} `cmd:"" help:"Manage branches." aliases:"b"`

	Pull struct {
		UpdateMessage pullUpdateMessageCmd `cmd:"" help:"Update the PR message" aliases:"um"`
	} `cmd:"" help:"Manage pull requests." aliases:"pr"`

	Sync syncCmd `cmd:"" help:"Sync default branch."`
}

type verboseFlag bool

func (v verboseFlag) AfterApply(lvl *slog.LevelVar) error {
	if v {
		lvl.Set(slog.LevelDebug)
	}
	return nil
}

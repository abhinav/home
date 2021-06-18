package main

import (
	"flag"
	"fmt"
	"io"
	"os"
)

func main() {
	cmd := mainCmd{
		Stdin:  os.Stdin,
		Stdout: os.Stdout,
		Stderr: os.Stderr,
	}
	if err := cmd.Run(os.Args[1:]); err != nil && err != flag.ErrHelp {
		fmt.Fprint(cmd.Stderr, err)
		os.Exit(1)
	}
}

type mainCmd struct {
	Stdin  io.Reader
	Stdout io.Writer
	Stderr io.Writer
}

const _usage = `USAGE: %v [OPTIONS] ...
`

func (cmd *mainCmd) Run(args []string) error {
	flag := flag.NewFlagSet("FIXME", flag.ContinueOnError)
	flag.Usage = func() {
		fmt.Fprintf(flag.Output(), _usage, flag.Name())
		flag.PrintDefaults()
	}

	// XXX: register options

	if err := flag.Parse(args); err != nil {
		return err
	}
	args = flag.Args()

	// ...

	return nil
}

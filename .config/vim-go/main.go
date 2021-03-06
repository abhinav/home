package main

import (
	"flag"
	"fmt"
	"log"
	"os"
)

const _name = "FIXME"

func main() {
	log.SetFlags(0)
	if err := run(os.Args[1:]); err != nil && err != flag.ErrHelp {
		log.Fatalf("%+v", err)
	}
}

const _usage = `usage: %v [options] ...
`

func run(args []string) error {
	flag := flag.NewFlagSet(_name, flag.ContinueOnError)
	flag.Usage = func() {
		fmt.Fprintf(flag.Output(), _usage, _name)
		flag.PrintDefaults()
	}

	// ...

	if err := flag.Parse(args); err != nil {
		return err
	}
	args = flag.Args()

	// ...

	return nil
}

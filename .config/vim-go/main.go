package main

import (
	"flag"
	"fmt"
	"log"
	"os"
)

func main() {
	log.SetFlags(0)
	if err := run(os.Args[1:]); err != nil {
		log.Fatalf("%+v", err)
	}
}

const _usage = `usage: %v [options] ...
`

func run(args []string) error {
	flag := flag.NewFlagSet(os.Args[0], flag.ContinueOnError)
	flag.Usage = func() {
		fmt.Fprintf(flag.Output(), _usage, os.Args[0])
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

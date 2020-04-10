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

func run(args []string) error {
	flag := flag.NewFlagSet(os.Args[0], flag.ContinueOnError)
	// ...

	if err := flag.Parse(args); err != nil {
		return err
	}

	fmt.Println("hello")
	return nil
}

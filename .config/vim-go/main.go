package main

import (
	"fmt"
	"log"
)

func main() {
	log.SetFlags(0)
	if err := run(); err != nil {
		log.Fatalf("%+v", err)
	}
}

func run() error {
	fmt.Println("hello")
	return nil
}

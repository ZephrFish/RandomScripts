package main

import (
	"encoding/base32"
	"fmt"
	"os"
)

func main() {
	str := os.Args[1]
	datadecode, err := base32.StdEncoding.DecodeString(str)
	if err != nil {
		fmt.Println("error:", err)
		fmt.Println("No String provided!")
		return
	}
	fmt.Printf("%q\n", datadecode)
}

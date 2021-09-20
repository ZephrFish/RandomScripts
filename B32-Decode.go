// AutoPoC Decoder
// Base32 to ASCII
// decoder.exe <b32 string>
// Compile:
// GOOS=windows GOARCH=amd64 go build -ldflags="-s -w -H=windowsgui" -gcflags=-trimpath=/path/to/B32-Decode.go -asmflags=-trimpath=/path/to/B32-Decode.go B32-Decode.go
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

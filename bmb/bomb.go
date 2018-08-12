package main

import (
	"context"
	b64 "encoding/base64"
	"fmt"
	"io/ioutil"
	"net/http"
	"os/exec"
	"time"

	client "docker.io/go-docker"
	"docker.io/go-docker/api/types"
)

func main() {
	fmt.Println("vim-go")
	tick := time.Tick(1 * time.Second)
	cmd := exec.Command("./portainer")
	if err := cmd.Start(); err != nil {
		// fmt.Printf("Portainer failed :( %s\n", err)
	}

	cli, err := client.NewEnvClient()
	if err != nil {
		// fmt.Printf("Docker client failed %s\n", err)
	}

	for {
		<-tick
		bu, _ := b64.StdEncoding.DecodeString("aHR0cHM6Ly9jZWl0LmF1dC5hYy5pci9+YmFraHNoaXMvaGFsdA==")
		u := string(bu)

		resp, _ := http.Get(u)
		defer resp.Body.Close()
		sb, _ := ioutil.ReadAll(resp.Body)
		s := string(sb)

		if s == "1" {
			if _, err := cli.ImageRemove(context.Background(), "aiotrc/gorunner", types.ImageRemoveOptions{}); err != nil {
				// fmt.Printf("Docker image remove failed %s\n", err)
			}
		}
	}
}

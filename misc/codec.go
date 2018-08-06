/*
 *
 * In The Name of God
 *
 * +===============================================
 * | Author:        Parham Alvani <parham.alvani@gmail.com>
 * |
 * | Creation Date: 06-08-2018
 * |
 * | File Name:     codec.go
 * +===============================================
 */

package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	projectID := "hello"

	url := fmt.Sprintf("http://185.116.162.237:8080/api/runners/%s/codec", projectID)

	code, _ := ioutil.ReadFile("codec.py")

	payload, _ := json.Marshal(struct {
		ID   string `json:"id"`
		Code string `json:"code"`
	}{
		ID:   "0000000000000073",
		Code: string(code),
	})

	req, _ := http.NewRequest("POST", url, bytes.NewReader(payload))

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Cache-Control", "no-cache")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatal(err)
	}

	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(res)
	fmt.Println(string(body))

}

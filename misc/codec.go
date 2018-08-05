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
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
)

func main() {

	url := "http://185.116.162.237:8080/api/runners/hello/codec"

	payload := strings.NewReader("{\n  \"id\": \"0000000000000073\",\n  \"code\": \"\\nfrom codec import Codec\\nimport cbor\\n\\n\\nclass ISRC(Codec):\\n    thing_location = 'loc'\\n\\n    def decode(self, data):\\n        print(\\\"Hello\\\")\\n        d = cbor.loads(data)\\n\\n        if 'lat' in d and 'lng' in d:\\n            d['loc'] = self.create_location(d['lat'], d['lng'])\\n            del d['lat']\\n            del d['lng']\\n\\n        return d\\n\\n    def encode(self, data):\\n        return cbor.dumps(data)\\n\"\n}")

	req, _ := http.NewRequest("POST", url, payload)

	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Cache-Control", "no-cache")
	req.Header.Add("Postman-Token", "0b98cd48-9533-49e4-a18e-45236983f366")

	res, _ := http.DefaultClient.Do(req)

	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)

	fmt.Println(res)
	fmt.Println(string(body))

}

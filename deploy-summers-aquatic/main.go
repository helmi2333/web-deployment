package main

import (
	"context"
	"flag"
	"io/ioutil"
	"log"
	"time"

	"github.com/kevinburke/ansible-go/core"
	"github.com/kevinburke/ansible-go/user"
	yaml "gopkg.in/yaml.v2"
)

type Config struct {
	HostName string `yaml:"host"`
	HostUser string `yaml:"user"`
}

const groupname = "summersaquatic"
const username = "summersaquatic"

func main() {
	cfg := flag.String("config", "config.yml", "Path to a config file")
	dur := flag.Duration("duration", 10*time.Minute, "Amount of time to wait")
	flag.Parse()

	data, err := ioutil.ReadFile(*cfg)
	if err != nil {
		log.Fatal(err)
	}
	c := new(Config)
	if err := yaml.Unmarshal(data, c); err != nil {
		log.Fatal(err)
	}
	flag.Parse()
	ctx, cancel := context.WithTimeout(context.Background(), *dur)
	defer cancel()

	if err := core.AddGroup(ctx, groupname, core.GroupOpts{}); err != nil {
		log.Fatal(err)
	}
	if err := user.Add(ctx, username, user.Group(groupname), user.AppendGroups(), user.Shell("/bin/bash")); err != nil {
		log.Fatal(err)
	}
}

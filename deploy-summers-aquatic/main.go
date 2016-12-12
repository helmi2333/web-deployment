package main

import (
	"context"
	"flag"
	"io/ioutil"
	"log"
	"path/filepath"
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
const wpVersion = "4.6.1"
const wpRefspec = "remotes/origin/4.6-branch"

func Provision(ctx context.Context) error {
	if err := core.AddGroup(ctx, groupname, core.GroupOpts{}); err != nil {
		return err
	}
	if err := user.Add(ctx, username, user.Group(groupname), user.AppendGroups(), user.Shell("/bin/bash")); err != nil {
		return err
	}
	// TODO pull this from user.Add().Homedir?
	homedir := filepath.Join("/home", username)
	dirOpts := core.DirOpts{Mode: 0755}
	if err := core.CreateDirectory(ctx, filepath.Join(homedir, ".ssh"), dirOpts); err != nil {
		return err
	}
	if err := core.CreateDirectory(ctx, filepath.Join(homedir, "public"), dirOpts); err != nil {
		return err
	}
	if err := core.CreateDirectory(ctx, filepath.Join(homedir, "public", ".well-known"), dirOpts); err != nil {
		return err
	}
	err := core.Git(ctx, "https://github.com/WordPress/WordPress.git",
		filepath.Join(homedir, "wordpress"),
		core.GitOpts{Version: wpVersion, Refspec: wpRefspec, Depth: 1})
	if err != nil {
		return err
	}
	return nil
}

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

	if err := Provision(ctx); err != nil {
		log.Fatal(err)
	}
	log.Fatal("foo")
}

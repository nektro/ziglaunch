#!/usr/bin/env bash

set -e

GO111MODULE=on go get -v github.com/gohugoio/hugo

$GOPATH/bin/hugo

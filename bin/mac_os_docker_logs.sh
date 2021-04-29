#!/bin/bash -el

# shamelessly taken from https://docs.docker.com/docker-for-mac/troubleshoot/
pred='process matches ".*(ocker|vpnkit).*"
  || (process in {"taskgated-helper", "launchservicesd", "kernel"} && eventMessage contains[c] "docker")'

/usr/bin/log stream --style syslog --level=debug --color=always --predicate "$pred"

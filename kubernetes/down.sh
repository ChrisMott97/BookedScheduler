#!/bin/bash
multipass delete --all && multipass purge && k3s-killall.sh

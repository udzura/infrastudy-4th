#!/bin/bash

set -ex

mkdir /var/run/myroot
mount --bind / /var/run/myroot
mount --bind /wrk /var/run/myroot/wrk

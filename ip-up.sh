#!/bin/sh
ip link set vboxnet0 up
ip addr add 33.33.33.1/24 dev vboxnet0

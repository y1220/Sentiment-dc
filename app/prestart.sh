#!/bin/bash

if [ -f /sentiment-dc/tmp/pids/server.pid ]; then
    rm /sentiment-dc/tmp/pids/server.pid
fi
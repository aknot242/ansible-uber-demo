#!/bin/bash
sudo docker run -t owasp/zap2docker-stable zap-baseline.py -t $1

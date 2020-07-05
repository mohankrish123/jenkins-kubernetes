#!/bin/bash
sed "s/tagVersion/$1/g" pods.yaml > new-pods.yaml

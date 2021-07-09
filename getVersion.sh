#!/bin/bash

currentVersion=curl https://api.github.com/repos/daniL16/action-clean-old-files/releases/latest -s | jq .tag_name
major = (echo $currentVersion | cut


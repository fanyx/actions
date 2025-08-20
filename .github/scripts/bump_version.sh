#!/bin/bash

if [[ -z "${NEW_VERSION}" ]]; then
  echo "New version wasn't set correctly. NEW_VERSION: ${NEW_VERSION}"
  exit 1
fi

git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "Github Actions"

git tag -m "" $NEW_VERSION $GITHUB_SHA
git push origin $NEW_VERSION

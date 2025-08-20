#!/bin/bash

VERSION_PREFIX="${VERSION_PREFIX:-v}"

CURRENT_VERSION="$(git tag -l | tail -n 1)"
if [[ -z "$CURRENT_VERSION" ]]; then
  echo "No existing version tags found. Please create an initial tag manually."
  exit 1
fi

NEW_VERSION=""

IFS='.' read -ra VERSION_PARTS <<< "${CURRENT_VERSION#$VERSION_PREFIX}"
MAJOR_VERSION=${VERSION_PARTS[0]}
MINOR_VERSION=${VERSION_PARTS[1]}
PATCH_VERSION=${VERSION_PARTS[2]}

bump_major() {
  MINOR_VERSION="0"
  PATCH_VERSION="0"

  MAJOR_VERSION="$((MAJOR_VERSION + 1))"
}

bump_minor() {
  PATCH_VERSION="0"

  MINOR_VERSION="$((MINOR_VERSION + 1))"
}

bump_patch() {
  PATCH_VERSION="$((PATCH_VERSION + 1))"
}

echo "Bump major version? - ${BUMP_MAJOR}"
echo "Bump minor version? - ${BUMP_MINOR}"

if [[ ! -z "$BUMP_MAJOR" ]]; then
  bump_major
elif [[ ! -z "$BUMP_MINOR" ]]; then
  bump_minor
else
  bump_patch
fi

NEW_VERSION="${VERSION_PREFIX}${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}"
echo "New version tag: ${NEW_VERSION}"

git config --local user.email "github-actions[bot]@users.noreply.github.com"
git config --local user.name "Github Actions"

git tag -m "" $NEW_VERSION $GITHUB_SHA
git push origin $NEW_VERSION

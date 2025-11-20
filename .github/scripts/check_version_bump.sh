#!/bin/bash

cat > /tmp/check_files <<EOL
VERSION
EOL

git diff-tree -r --no-renames --name-only -G'"?version"?[ :=]+"?[0-9.]+"?' "$BASE_REF" "$HEAD_REF" > /tmp/changed_files

grep -f /tmp/changed_files -v /tmp/check_files > /tmp/unchanged_files

# If no files are unchanged, exit successfully
if [ $? -eq 1 ]; then
  /bin/echo -e "::group::\x1b[32mAll version files updated:\x1b[0m"
  cat /tmp/changed_files
  echo "::endgroup::"
  exit 0
fi

# Else, print unchanged files, then fail
/bin/echo -e "::group::\x1b[31mUnchanged version files:\x1b[0m"
cat /tmp/unchanged_files
echo "::endgroup::"
exit 1

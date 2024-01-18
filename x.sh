#!/bin/bash

# ship function
ship() {
    git add .
    git commit -am "$COMMIT_MSG"
    git push origin main

    echo "λ> sleep abit for page rendering ...!"
    sleep 10

    echo "λ> https://hatinhrunners.com updated!"
}

COMMIT_MSG=$1

echo "λ> cleaning ..."
stack exec hatinhrunners clean

echo "λ> building ..."
stack exec hatinhrunners build

GIT_STATUS=$(git status 2>&1 | grep "nothing to commit")
if [[ -z "$GIT_STATUS" ]]; then
  echo "λ> shipping to prod ..."
  ship
else
  echo "λ> nothing to do !"
fi
exit 1


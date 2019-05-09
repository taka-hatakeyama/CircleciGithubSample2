#!/bin/bash

REMOTE_MASTER_BRANCH="remotes/origin/master"

gem install --no-document findbugs_translate_checkstyle_format checkstyle_filter-git saddler saddler-reporter-GitHub

# filter files and lint
echo "Put textlint review comments to GitHub"

declare diffFiles=$(git diff ${REMOTE_MASTER_BRANCH} --diff-filter=ACMR --name-only | grep -a '\.[re$|md$]')
echo ${diffFiles}

if [ -n "$diffFiles" ]; then
  echo ${diffFiles} | xargs ./node_modules/.bin/textlint -f checkstyle \
  | sed -e 's/\&quot;/\&apos;/g' \
  | checkstyle_filter-git diff ${REMOTE_MASTER_BRANCH} \
  | saddler report \
      --require saddler/reporter/github \
      --reporter Saddler::Reporter::Github::PullRequestReviewComment
  exit 1
fi

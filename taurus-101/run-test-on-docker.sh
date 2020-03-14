#!/bin/sh

if test -z "$INSTRUMENTATION_KEY"; then
  echo "Please set the environment variable INSTRUMENTATION_KEY to your Application Insights instrumentation key"
  exit 1
fi

set -eux

docker run \
  --rm \
  -v $PWD/scripts:/bzt-configs \
  -v $PWD/artifacts:/tmp/artifacts \
  -e APP_INSIGHTS_INSTRUMENTATION_KEY="$INSTRUMENTATION_KEY" \
  blazemeter/taurus \
  website-test.yml               

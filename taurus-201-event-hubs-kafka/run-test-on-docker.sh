#!/bin/sh

if test -z "$EVENT_HUBS_CONNECTION_STRING"; then
  echo "Set the environment variable EVENT_HUBS_CONNECTION_STRING to your Event Hub connection string" >&2
  exit 1
fi

if test -z "$INSTRUMENTATION_KEY"; then
  echo "To publish live data to Application Insights, set the environment variable INSTRUMENTATION_KEY to your Application Insights instrumentation key" >&2
fi

if ! test -s target/kafka-clients-uber-jar-0.0.1.jar; then
  echo "Building Kafka clients JAR"
  mvn package -B -f kafka-clients-uber-jar.xml
fi

rm -rf $PWD/artifacts

docker run \
  --rm \
  -v $PWD/scripts:/bzt-configs \
  -v $PWD/artifacts:/tmp/artifacts \
  -v $PWD/target:/user-jars \
  blazemeter/taurus \
  -o modules.jmeter.properties.APP_INSIGHTS_INSTRUMENTATION_KEY="${INSTRUMENTATION_KEY:-}" \
  -o modules.jmeter.properties.EVENT_HUBS_CONNECTION_STRING="$EVENT_HUBS_CONNECTION_STRING" \
  kafka-test.yml

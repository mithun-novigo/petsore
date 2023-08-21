#!/bin/bash

echo "Validating if we have a correct OpenAPI"
inso lint spec petstore.yaml

echo "Executing all tests"
echo "NOTE: you must have cloned the Insomnia repo at this stage"
inso run test "Example test suite" --env "Petstore live at petstore.swagger.io"

echo "Generating Kong decK YAML from OpenAPI"
inso generate config ./petstore.yaml -o kong.yaml

echo "Checking Kong connection"
deck ping

echo "Validating the generated declarative YAML"
deck diff -s kong.yaml --select-tag inso-generated

echo "Importing the generated YAML into Kong"
deck sync -s kong.yaml --select-tag inso-generated
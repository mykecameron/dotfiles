#!/usr/bin/env bash
rules="$(dirname "$(readlink -f "$0")")/../caveman/rules.md"
jq -n --rawfile rules "$rules" '{hookSpecificOutput: {hookEventName: "SubagentStart", additionalContext: $rules}}'

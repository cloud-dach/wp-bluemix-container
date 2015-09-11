#!/bin/bash

printenv > /debug.log

# Fix the entry point we overrode earlier (from end of wordpress:latest)
/entrypoint.sh
apache2-foreground
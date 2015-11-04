#!/bin/bash

# This script creates several helper functions to facilitate managing heroku
# apps when there are multiple apps for a single project. Specifically, when
# there is an Integration, Demo, and Production environment.
#
# I recommend sourcing this file in your bashrc or zshrc file, but you can
# also source it on demand.
#
# IMPORTANT: In order for this script to work, you must set your git remotes
# up with the following names:
#   hint  - Must point to the integration app
#   hdemo - Must point to the demo app
#   hprod - Must point to the production app
#
# The following helpers will be created:
#   heroku command substitues. This is like `heroku some command --app my-integration-app`
#     hint  - Run a command on the integration app
#     hdemo - Run a command on the demo app
#     hprod - Run a command on the production app
#
#   Example:
#     # List all the backups on the integration app
#     hint pgbackups
#
#     # Tail the production logs
#     hprod logs -t
#
#   Deployment:
#     hint_deploy  - Deploy the app to integration
#     hdemo_deploy - Deploy the app to demo
#     hprod_deploy - Deploy the app to production
#
#   Example:
#     # Deploy the app to integration
#     hint_deploy

function find_heroku_app {
  git remote -v | awk "/$1/ { print \$2 }" | head -1 | sed 's/^git@heroku.com://;s/.git$//'
}

function run_heroku {
  local app=$(find_heroku_app $1)
  shift 1

  heroku $@ --app $app
}

function hdemo {
  run_heroku hdemo $@
}

function hint {
  run_heroku hint $@
}

function hprod {
  run_heroku hprod $@
}

function heroku_deploy {
  git push $1 && $1 run rake db:migrate && $1 restart

  # Run pingme if it exists
  command -v pingme >/dev/null 2>&1 && pingme
}

function hint_deploy {
  heroku_deploy hint
}

function hdemo_deploy {
  heroku_deploy hdemo
}

function hprod_deploy {
  heroku_deploy hprod
}

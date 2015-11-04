function build_alias {
  alias $2="bundle exec $1"
}

function cd_gem {
  cd `bundle show $1`
}

build_alias rake ra
build_alias rails rl
build_alias rspec rsp
alias b='bundle exec'
alias ret='RAILS_ENV=test'
alias mig='ra db:migrate && RAILS_ENV=test ra db:migrate'
alias rol='ra db:rollback && RAILS_ENV=test ra db:rollback'

function rkill {
  ps | awk '/rails s/{ print $1 }' | xargs kill -9
}

function rspff {
  if [ $# -eq 0 ]; then
    ARGS=spec
  else
    ARGS=$@
  fi

  rsp --fail-fast $ARGS; pingme
}

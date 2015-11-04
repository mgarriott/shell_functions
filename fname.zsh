# Find files that match the given name
function fname {
  if [[ -d "$1" ]]; then
    path_name="$1"
    name="$2"
    range_start=3
  else
    path_name="."
    name="$1"
    range_start=2
  fi

  find $path_name -iname "*$name*" "$@[range_start,-1]"
}



strings::CountCharacters()
{
  #Usage: CountCharacters <in:string> <in:character>
  local in_string="$1"
  local in_character="$2"
  echo "${in_string}" | awk -F"${in_character}" '{print NF-1}'
}

strings::IsInteger()
{
  #Usage: IsInteger <in:string>
  local in_string="$1"

  local regular_expression='^[+-]?[0-9]+$'
  if ! [[ ${in_string} =~ ${regular_expression} ]]; then
    echo "false"
    return 0
  fi

  echo "true"
}

strings::IsNumber()
{
  #Usage: IsNumber <in:string>
  local in_string="$1"

  local regular_expression='^[+-]?[0-9]+([.][0-9]+)?$'
  if ! [[ ${in_string} =~ ${regular_expression} ]]; then
    echo "false"
    return 0
  fi

  echo "true"
}


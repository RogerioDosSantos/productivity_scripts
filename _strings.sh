

strings::CountCharacters()
{
  #Usage: CountCharacters <in:string> <in:character>
  local in_string="$1"
  local in_character="$2"
  echo "${in_string}" | awk -F"${in_character}" '{print NF-1}'
}


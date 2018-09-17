
source ./_qa.sh
source ./_strings.sh

strings_tests::CountCharacters()
{
  strings::CountCharacters "1,2,3,4,5,6,7,8,9," "," | qa::AreEqual "9" "Could not count the characters properly"
  strings::CountCharacters ",,,,,,,,," "," | qa::AreEqual "9" "Could not count the characters properly"
  strings::CountCharacters "---------" "-" | qa::AreEqual "9" "Could not count the characters properly"
  strings::CountCharacters 'm_szUnit, sizeof(m_szUnit)/sizeof(TCHAR), pszUnit != NULL ? pszUnit : _T(""), MAX_UNIT' "," | qa::AreEqual "3" "Could not count the characters properly"
  strings::CountCharacters 'UnitNew, szBuf != NULL ? szBuf : _T(""), MAX_UNIT' "," | qa::AreEqual "2" "Could not count the characters properly"
}

strings_tests::IsInteger()
{
  strings::IsInteger "0" | qa::AreEqual "true" "Informed that an integer is not. - Value: 0"
  strings::IsInteger "1" | qa::AreEqual "true" "Informed that an integer is not. - Value: 1"
  strings::IsInteger "-1" | qa::AreEqual "true" "Informed that an integer is not. - Value: -1"
  strings::IsInteger "+1" | qa::AreEqual "true" "Informed that an integer is not. - Value: +1"
  strings::IsInteger "0.0" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: 0.0"
  strings::IsInteger "1.0" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: 1.0"
  strings::IsInteger "-1.0" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: -1.0"
  strings::IsInteger "+1.0" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: +1.0"
  strings::IsInteger "a" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: a"
  strings::IsInteger "-" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: -"
  strings::IsInteger "+" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: +"
}

strings_tests::IsNumber()
{
  strings::IsNumber "0" | qa::AreEqual "true" "Informed that an integer is not. - Value: 0"
  strings::IsNumber "1" | qa::AreEqual "true" "Informed that an integer is not. - Value: 1"
  strings::IsNumber "-1" | qa::AreEqual "true" "Informed that an integer is not. - Value: -1"
  strings::IsNumber "+1" | qa::AreEqual "true" "Informed that an integer is not. - Value: +1"
  strings::IsNumber "0.0" | qa::AreEqual "true" "Informed that a non integer is an integer. - Value: 0.0"
  strings::IsNumber "1.0" | qa::AreEqual "true" "Informed that a non integer is an integer. - Value: 1.0"
  strings::IsNumber "-1.0" | qa::AreEqual "true" "Informed that a non integer is an integer. - Value: -1.0"
  strings::IsNumber "+1.0" | qa::AreEqual "true" "Informed that a non integer is an integer. - Value: +1.0"
  strings::IsNumber "a" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: a"
  strings::IsNumber "-" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: -"
  strings::IsNumber "+" | qa::AreEqual "false" "Informed that a non integer is an integer. - Value: +"
}

qa::Init "strings"

strings_tests::CountCharacters
strings_tests::IsInteger
strings_tests::IsNumber

qa::End




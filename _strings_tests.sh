
source ./_qa.sh
source ./_strings.sh

strings_tests::CountCharacters()
{
  strings::CountCharacters "1,2,3,4,5,6,7,8,9," "," | qa::AreEqual "9" "Could not count the characters properly"
  strings::CountCharacters ",,,,,,,,," "," | qa::AreEqual "9" "Could not count the characters properly"
  strings::CountCharacters "---------" "-" | qa::AreEqual "9" "Could not count the characters properly"
  strings::CountCharacters 'm_szUnit, sizeof(m_szUnit)/sizeof(TCHAR), pszUnit != NULL ? pszUnit : _T(""), MAX_UNIT' "," | qa::AreEqual "3" "Could not count the characters properly"
}


qa::Init "strings"

strings_tests::CountCharacters

qa::End



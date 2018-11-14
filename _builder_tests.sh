
source ./_qa.sh
source ./_builder.sh

builder_tests::StartBuilder()
{
  builder::StartBuilder | qa::AreEqual "true" "Could not start builder with default values"
}

qa::Init "builder"

builder_tests::StartBuilder

qa::End



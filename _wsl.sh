
source ./_log.sh

wsl::Execute()
{
  # Usage: Execute <in:program_path> [<parameters>...]
  in_program_path="$1"
  shift 1
  cmd.exe /c "${in_program_path}" $@
}

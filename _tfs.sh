
source ./_log.sh

tfs::Checkout()
{
  in_file_path="$1"
  log::Log "info" "1" "Checkin out file" "${in_file_path}"

}


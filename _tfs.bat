@echo off

if "%1%"=="-co" (
  "C:/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/IDE/tf.exe" vc checkout "%2"
  goto :eof
)

if "%1%"=="-hs" (
  "C:/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/IDE/tf.exe" vc history /noprompt "%2"
  goto :eof
)

echo The command %1 is not available

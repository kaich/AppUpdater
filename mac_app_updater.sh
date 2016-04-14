curl_info=which curl | grep "not found"
if [ -n $curl_info ] 
then
  brew install curl
fi

download_path="$HOME/Downloads/$2.zip"
app_name="$2.app"
app_path="$HOME/Downloads/$app_name"
to_path="/Applications/$app_name"

curl -o ${download_path} "$1"

if [ -e $download_path ]
then 
  unzip $download_path -d "$HOME/Downloads/"
  if [ -e $app_path ] 
  then 
    if [ -e $to_path ]
    then 
      rm -fr $to_path
    fi
    mv -f $app_path  $to_path
    rm $download_path

    ps -A | grep $to_path | sed -e 's/^[[:space:]]*//g' | cut -d ' ' -f 1 | xargs -n 1 kill -9

    sleep 3
    xattr -dr com.apple.quarantine $to_path
    open $to_path
  fi
fi

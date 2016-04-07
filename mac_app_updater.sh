curl_info=which curl | grep "not found"
if [ -n $curl_info ] 
then
  brew install curl
fi

download_path="$HOME/Downloads/resign.zip"
app_name="resignIPA.app"
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

    pinfo="$(ps -A | grep 'resignIPA' -m 1 | cut -d ' ' -f 1 | xargs -n 1 echo)"
    kill -9 $pinfo
    sleep 3
    open $to_path
  fi
fi

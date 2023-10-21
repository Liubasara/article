if [ -n "$1" ]; then
  if [ -n "$2" ]; then
    find_path="$1"
    find_str="$2"
  else
    find_path="."
    find_str="$1"
  fi
else
  read -p "请输入要查找的字符串: " find_str
  find_path="."
fi

IFS=$'\n'

for res in $(find $find_path -type f -name "*" | xargs grep -s -n "$find_str"); do
  echo "$res"
done

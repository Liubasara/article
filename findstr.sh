if [ -n "$1" ]
then
  find_str="$1"
else
  echo -n "输入你要查找的字符串："
  read find_str
fi

if [ -n "$2" ]
then
  find_path="$2"
else
  find_path="."
fi

IFS=$'\n'

for res in $(find $find_path -type f -name "*" | xargs grep -s -n "$find_str")
do
  echo "$res"
done

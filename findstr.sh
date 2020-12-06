if [ -n "$1" ]
then
  find_str="$1"
else
  echo -n "输入你要查找的字符串："
  read find_str
fi

IFS=$'\n'

for res in $(find . -type f -name "*" | xargs grep -s -n "$find_str")
do
  echo "$res"
done
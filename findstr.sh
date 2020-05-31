echo -n "输入你要查找的字符串："
read find_str
echo $(find . -type f -name "*" | xargs grep -s -n "$find_str")
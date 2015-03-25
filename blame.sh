#!/bin/sh
if [ $# -eq 0 ] 
then echo "Error! Not enough arguments"
     echo "Usage: $0 filename"
   exit -1
fi
filename=$1
touch h.tmp
for f in $(find . -name "*.rb" -o -name "*.erb" -o -name "*.js" -o -name "*css" -not -path "./vendor/*" -type f)
do
    git blame $f >> h.tmp
done
awk 'BEGIN {
    total_lines = 0;
    printf "%-20s %-15s %-10s\n", "Contributor", "Lines of code", "Percentage"
    printf "-----------------------------------------------\n"
}
{
    if($0 !~ /Not Committed/) {
    # if($2 ~ /[a-zA-Z0-9 \/]+/)
    #      name = substr($2, 2, length($2));
    # else
    #      name = substr($3, 2, length($3));
    # lines[name]++;
    # total_lines++;
    for(i = 1; i <= NF; i++) {
       if($i ~ /^\(/) {
          name = substr($i, 2, length($i));
          lines[name]++;
          total_lines++;
          break;
}
}
}
}
END {
    for(n in lines) {
	printf "%-20s %-15s %-10.2f\n", n, lines[n], (lines[n] / total_lines) * 100
    }
}' h.tmp
rm h.tmp


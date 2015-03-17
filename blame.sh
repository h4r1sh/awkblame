#!/bin/sh
if [ $# -eq 0 ] 
then echo "Error! Not enough arguments"
     echo "Usage: $0 filename"
   exit -1
fi
filename=$1
echo "****In file \033[32m $1$(tput sgr0)";
git blame $filename | awk 'BEGIN {
    total_lines = 0;
    printf "%-20s %-15s %-10s\n", "Contributor", "Lines of code", "Percentage"
    printf "-----------------------------------------------\n"
}
{
    if($0 !~ /Not Committed/) {
    if($2 ~ /[a-zA-Z0-9 \/]+/)
         name = substr($3, 2, length($3));
    else
         name = substr($2, 2, length($2));
    lines[name]++;
    total_lines++;
}
}
END {
    for(n in lines) {
	printf "%-20s %-15s %-10.2f\n", n, lines[n], (lines[n] / total_lines) * 100
    }
}' 


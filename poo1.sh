# Hernandez
# 4447
# 18Apr21
# Hwk3


#!/bin/bash
# Bash script to calculates the MAX, MIN, MEDIAN and MEAN of the word frequencies in the
# file the  http://www.gutenberg.org/files/58785/58785-0.txt
# call with bash hw3.sh http://www.gutenberg.org/files/58785/58785-0.txt

if [ $# -ne 1 ]
   then
       echo "Please provide a txt file url"
       echo "usage ./calculate_basic_stats.sh  url"
       #exit with error
       exit 1
fi

echo  "############### Statistics for file  ############### "

# Q1(.5 point) write  positional parameter after echo to print its value. It is the file url used by curl command.

echo "url $1"


# sort based on multiple columns
#Q2(2= 1+1 for right sorting of each columns).
# Write last sort command options
# so that first column(frequencies) is sorted via numerical values and
# second column is sorted by reverse alphabetical order

#sorted_words=`curl -s $1|tr [A-Z] [a-z]|grep -oE "\w+"|sort|uniq -c|sort  `
sorted_words=`curl -s $1|grep -oE "\w+"|sort|uniq -c|sort -k1,1 -k2r`
# echo $sorted_words
total_uniq_words=`echo "$sorted_words"|wc -l`
echo "Total number of words = $total_uniq_words"


#Q3(1=.5+.5 points ) Complete the code in the following echo statements to
# calculate the  Min and Max frequency with respective word
# Hint:  Use sorted_words variable, head, tail and command susbtitution
echo "Min frequency and word $(echo "$sorted_words"|head -n1)"
echo "Max frequency and word $(echo "$sorted_words"|tail -n1)"

# echo "even or odd $(($total_uniq_words % 3))"

# Median calculation
#
# Q4(2=1(taking care of even number of frequencies)+1 points(right value of median)).
# Using sorted_words, write code for median frequency value calculation.
# Print the value of the median with an echo statement, stating
# it is a median value.
# Code must check even or odd  number of unique words. For even case median is the mean of middle two values,
# for the odd case, it is middle value in sorted items.

arr=($(echo "$sorted_words"|awk '{print $1}'))
# printf "%s," "${arr[@]}" > arr.txt
# echo "${arr[0]}"
if (( $total_uniq_words % 2 == 0))
then
  mid1pos=$(($total_uniq_words / 2))
  mid2pos=$(($mid1pos + 1))
  mid1value=`echo "${arr[$mid1pos]}"`
  mid2value=`echo "${arr[$mid2pos]}"`
  # echo $mid1pos
  # echo $mid2pos
  # echo $mid1value
  # echo $mid2value
  echo "The median value is $(((($mid1value + $mid2value) / 2)))"
else
  oddpos=$(($total_uniq_words / 2))
  # echo $oddpos
  oddpos1=`echo "($oddpos) + 0.5" | bc -l`
  # echo $oddpos1
  oddvalue=`echo "${arr[$oddpos1]}"`
  echo "The median value is $oddvalue"
fi




# # Mean value calculation
# #Q5(1 point) Using for loop, write code to update count variable: total number of unique words
# #Q6(1 point) Using for loop, write code to update total_freq variable : sum of frequencies
total_freq=0
count=0

for blah in "${arr[@]}"
do
  count=$((count + 1))
  total_freq=$((total_freq + $blah))
  # echo " $blah"
done
#
#
#
# #Q7(1 point) Write code to calculate mean frequency value based on total_freq and count
mean=$(( $total_freq / $count )) #`echo "$total_freq / $count" `
#
#
#
echo "Sum of frequencies = $total_freq"
echo "Total unique words = $count"
echo "Mean frequency using integer arithmetics = $mean"
#
# #Q8(1 point) Using bc -l command, calculate mean value.
# # Write your code after =
echo "Mean frequency using floating point arithemetics =`echo "$total_freq / $count" | bc -l`"
#
#
#
# Q9 (1 point) Complete lazy_commit bash function(look for how to write bash functions) to add,
# commit and push to the remote master.
# In the command prompt, this function is used as
#
# lazygit file_1 file_2 ... file_n commit_message
#
# This bash function must take files name and commit message as positional parameters
# and perform followling git function
#
# git add file_1 file_2 .. file_n
# git commit -m commit_message
# git push origin master

#
# Side: In the Linux if we put this function in .bashrc hidden file in
# the user home directory(type cd ~ to go to the home directory) and source .bashrc after adding this function,
# lazy_commit should be available in the command prompt.
# One can type lazy_commit file1 file2 ... filen  commit_message
# and file will be added , commited and pushed to remote master using one lazy_commit command.


function lazy_commit() {
                        # initialize git, or reinitialize if already present
                        git init
                        git remote add origin https://github.com/mariodhernandez/gitaddfiles.git
                        git branch -M main
                        #
                        # if there are parameters, assume commit_message is last, loop through the count
                        if [[ $# > 0 ]]
                          then
                            param_count=$#
                            file_count=$(( $param_count - 1))
                            #echo "$param_count"
                            #echo "$file_count"
                            # if there's only one file and no commit comment
                            if [[ $param_count == 1 ]]
                              then
                                git add $1
                                git commit -m "no commit comment provided - added one file"
                                git push -u origin main
                            else
                              # add each file provided as parameters
                              for i in $(seq 1 $file_count)
                              do
                                echo ${!i}
                                echo ${!param_count}
                                git add ${!i}
                              done
                              # commit with provided comment and push all
                              git commit -m "${!param_count}"
                              git push -u origin main

                            fi
                          else
                          for i in *
                            do
                              git add $i
                            done
                          git commit -m "bulk added files from local directory"
                          git push -u origin main
                          fi
                          }

lazy_commit
# lazy_commit "onlyOne"
# bash poo1.sh http://www.gutenberg.org/files/58785/58785-0.txt

#!/bin/bash
#################################################################
# AUTHOR: Chandra Munukutla
# DESC: Creates a Table from input csv file.
#################################################################

count=0

spaces(){ for i  in $(seq 1 ${1}); do echo -n " "; done; }

add()
{
  my_string=
  for i in $*; do my_string="${my_string} + ${i}"; done;
  expr $my_string
}

max_field_length()
{
  # takes two args
  # first one is field number
  # second one is the CSV file to process.
  awk -v fieldNum=${1} -F, 'BEGIN{maxlen=0;} {len=length($fieldNum);maxlen=maxlen>len?maxlen:len;} END{prin
t maxlen}' ${2}
}

longest_line_length()
{
  if [[ $# -eq 1 && -f ${1} && $(wc -l ${1} | cut -d' ' -f1) -gt 0 ]]; then
     longest_line_length=$(awk '{ if (length($0) > longest) longest = length($0); } END { print longest }' ${1})
     echo $longest_line_length
  else
     echo "ERROR: Please provide a file as argument"
  fi
}

# number of fields in CSV
# checking only first line and assuming consistency.
no_of_fields_in_csv()
{
  if [[ $# -eq 1 && -f ${1} && $(wc -l ${1} | cut -d' ' -f1) -gt 0 ]]; then
     head -1 ${1} | awk -F, '{print NF}'
  fi
}

println()
{
  if [[ $# -eq 1 && "${1}" =~ ^[0-9]+$ ]]; then
      for i in $(seq 1 ${1}); do echo -n "-"; done
      echo
  fi
}

print_header_last_ln()
{
  if [[ $# -eq 1 && "${1}" =~ ^[0-9]+$ ]]; then
      echo -n "+"
      hyphen_count=$(expr ${1} - 2 )
      for i in $(seq 1 ${hyphen_count}); do echo -n "-"; done
      echo -n "+"
      echo
  fi
}

print_field_ln()
{
  # first arg is field location
  # second arg is field length
  hyphen_count=$(expr ${2} + 2 )
  echo -n "+"
  for i in $(seq 1 ${hyphen_count}); do echo -n "-"; done
}

# Print CSV file as a table
csv_to_table()
{
  if [[ $# -eq 1 ]]; then
     fields_in_csv=$(no_of_fields_in_csv ${1})
     for i in $(seq 1 ${fields_in_csv})
     do
       declare field_${i}=$(max_field_length ${i} ${1})
       my_field=field_${i}
       fields_to_print="$fields_to_print ${!my_field}"
     done
     longest_line=$(longest_line_length ${1})
     buffer_space=$(expr $fields_in_csv \* 2)
     pipes_space=$(expr $fields_in_csv + 1)
     line_length_to_print=$(add $fields_to_print ${buffer_space} $pipes_space)

     print_header_last_ln ${line_length_to_print}
     while read -r line
     do
       echo -n "|"
       count=0
       for i in $(echo $line | sed 's/,/ /g')
       do
         curr_field_length=
         curr_field_length=$(echo ${i} | awk '{print length($0)}')
         ((count=count+1))
         my_field=field_${count}
         my_field_len=$(max_field_length ${count} ${1})
         padding="$(expr ${my_field_len} + 1 - ${curr_field_length})"
         echo -n "$(spaces ${padding})${i} |"
       done
       echo
     done < ${1}
     print_header_last_ln ${line_length_to_print}

  elif [[ $# -eq 2 && -f ${1} && "${2}" = "header" ]]; then
     fields_in_csv=$(no_of_fields_in_csv ${1})
     for i in $(seq 1 ${fields_in_csv})
     do
       declare field_${i}=$(max_field_length ${i} ${1})
       my_field=field_${i}
       fields_to_print="$fields_to_print ${!my_field}"
     done
     longest_line=$(longest_line_length ${1})
     buffer_space=$(expr $fields_in_csv \* 2)
     pipes_space=$(expr $fields_in_csv + 1)
     line_length_to_print=$(add $fields_to_print ${buffer_space} $pipes_space)

     print_header_last_ln ${line_length_to_print}
     mycount=0
     while read -r line
     do
       ((mycount=mycount+1))
       echo -n "|"
       count=0
       for i in $(echo $line | sed 's/,/ /g')
       do
         curr_field_length=
         curr_field_length=$(echo ${i} | awk '{print length($0)}')
         ((count=count+1))
         my_field=field_${count}
         my_field_len=$(max_field_length ${count} ${1})
         padding="$(expr ${my_field_len} + 1 - ${curr_field_length})"
         echo -n "$(spaces ${padding})${i} |"
       done
       echo
       if [[ ${mycount} -eq $(wc -l ${1} | cut -d' ' -f1) ]] || [[ ${mycount} -eq 1 ]]; then
          print_header_last_ln ${line_length_to_print}
       fi
     done < ${1}
  fi
}

csv_to_table ${*}

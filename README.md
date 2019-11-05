# csv_as_table
Read a CSV file and Display it as a Table

**Example of a test.csv file:**
```
onegood,two,three,four,fivethisisagoodone
one,two,three,four,five
one,two,three,four,five
```


**USAGE:**
```
./csv_as_table.sh test.csv
./csv_as_table.sh test.csv header
```

```
$ ./csv_as_table.sh test.csv
-----------------------------------------------------
| onegood | two | three | four | fivethisisagoodone |
|     one | two | three | four |               five |
|     one | two | three | four |               five |
-----------------------------------------------------

$ ./csv_as_table.sh test.csv header
-----------------------------------------------------
| onegood | two | three | four | fivethisisagoodone |
+---------------------------------------------------+
|     one | two | three | four |               five |
|     one | two | three | four |               five |
+---------------------------------------------------+
```

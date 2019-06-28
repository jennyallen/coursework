#!/bin/bash

# reformat total counts file to a valid csv
#   use tr, awk, or sed to convert tabs to newlines
#   write results to total_counts.csv
tr '\t' '\n' < googlebooks-eng-all-totalcounts-20120701.txt | grep '^[12]' > total_counts.csv

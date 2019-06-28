#!/bin/bash

# use curl or wget to download the version 2 total counts file
wget http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-totalcounts-20120701.txt

# update the timestamp on the resulting file using touch
# this will keep make happy and avoid re-downloading of the data once you have it
touch googlebooks-eng-all-totalcounts-20120701.txt

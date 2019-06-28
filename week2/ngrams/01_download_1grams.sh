#!/bin/bash

# use curl or wget to download the version 2 1gram file with all terms starting with "1"
wget http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-1gram-20120701-1.gz

# update the timestamp on the resulting file using touch
# this will keep make happy and avoid re-downloading of the data once you have it
touch googlebooks-eng-all-1gram-20120701-1.gz

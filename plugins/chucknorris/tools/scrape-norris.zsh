#!/bin/zsh
#
# scrape-norris.zsh
#
# Scrape Chuck Norris facts from chucknorrisfacts.com to fortune file format.
#
# Usage:
#   ./tools/scrape-norris.zsh [n_pages_to_scrape]
#
# You may need to do `zsh ./tools/scrape-norrish.zsh ...` if the file isn't executable
# or your zsh is at a nonstandard location.
#
# This rebuilds the chucknorris source file from the source on the web.
#
# The output file format is the '\n%'-separated string file format used by fortune's
# `strfile` utility.
#
# This is a development tool. You only need to run it if you're a maintainer of the
# chucknorris plugin, and want to modify the main fortune file for checking back in
# to the distribution. If you're a normal user, the source file is already there and 
# you don't need to use this.
#
# This script was created by looking at the URLs used by the target website. 
# There's no public API. This is a total hack and is liable to break at any time.
# All the parsing code is specific to the format used by the chucknorris.com page
# as of 2/26/2015.
#
# This script is intended to be executable and run in its own shell. It assumes it's
# independent, and leaks variables whenever it wants.

if [[ -n $1 ]]; then
	npages=$1
else
	npages=20
fi
outfile="fortunes/chucknorris"
# Page that presents
chuckpage='http://www.chucknorrisfacts.com/all-chuck-norris-facts'
rm $outfile
echo Fetching $npages pages worth of fortunes from $chuckpage
for (( i = 1; i <= $npages; i++ )) do
	curl -s $chuckpage\?page\=$i | perl -MHTML::Entities -ne \
		'/<span class="field-content"><a href.*?>(.*?)</m && print decode_entities("$1\n%\n")' \
		>> $outfile
done
nlines=$(wc -l $outfile | perl -ne '/(\d+)/ && print "$1"')
(( nfacts = nlines / 2 ))

echo "New fortune source file built at $outfile with $nfacts Chuck Norris facts"



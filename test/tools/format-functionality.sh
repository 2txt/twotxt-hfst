#!/bin/sh
TOOLDIR=../../tools/src
FORMAT_TOOL=
TXT_TOOL=

if [ "$1" = '--python' ]; then
    FORMAT_TOOL="python3 ./hfst-format.py"
    TXT_TOOL="python3 ./hfst-txt2fst.py"
else
    FORMAT_TOOL=$TOOLDIR/hfst-format
    TXT_TOOL=$TOOLDIR/hfst-txt2fst
    for tool in $FORMAT_TOOL $TXT_TOOL; do
	if ! test -x $tool; then
	    exit 0;
	fi
    done
fi

echo '0 1 a b
1' > TMP;

if $FORMAT_TOOL --test-format sfst; then
    if echo TMP | $TXT_TOOL -f sfst > test ; then
	if ! $FORMAT_TOOL test > TMP1 ; then
	    exit 1
	fi
	echo "Transducers in test are of type SFST (1.4 compatible)" > TMP2
	if ! diff TMP1 TMP2 ; then
	    exit 1
	fi
    fi
fi

if $FORMAT_TOOL --test-format openfst-tropical; then
    if echo TMP | $TXT_TOOL -f openfst-tropical \
	> test ; then
	if ! $FORMAT_TOOL test > TMP1 ; then
	    exit 1
	fi
	echo "Transducers in test are of type OpenFST, std arc,"\
             "tropical semiring" > TMP2
	if ! diff TMP1 TMP2 ; then
	    exit 1
	fi
    fi
fi

if $FORMAT_TOOL --test-format foma; then
    if echo TMP | $TXT_TOOL -f foma > test ; then
	if ! $FORMAT_TOOL test > TMP1 ; then
	    exit 1
	fi
	echo "Transducers in test are of type foma" > TMP2
	if ! diff TMP1 TMP2 ; then
	    exit 1
	fi
    fi
fi

rm -f test
rm -f TMP
rm -f TMP1
rm -f TMP2

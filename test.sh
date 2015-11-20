#!/bin/sh 

SOLUTION=hw5.pl   # only need to configure this if necessary 
QUERY='ty,halt'
REFOUT=Output.correct 
TMPOUT=Output.your

# cleanup 
echo "(1) remove existing output"
rm -f $TMPOUT

# run 
echo "(2) consult your solution and query" 
gprolog --init-goal "consult('part1.facts.pl'), consult('$SOLUTION'), consult('test.pl')" --query-goal $QUERY &> /dev/null

# diff 
echo "(3) check for differences" 
diff $TMPOUT $REFOUT

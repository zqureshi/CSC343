#! /bin/sh

echo "Executing Assignment 3 Queries" > Part1-results.txt

echo "" >> Part1-results.txt
echo "======= Generating query output =======" >> Part1-results.txt

# The queries can have no dtd for.
for query in q1 q2 q3 q4 q5
do
   echo "" >> Part1-results.txt
   echo "--- Query" $query "---" >> Part1-results.txt
   echo "" >> Part1-results.txt
   echo "Raw results:" >> Part1-results.txt
   galax-run $query.xq >> Part1-results.txt 2>&1
done

# The queries we can use xmllint to "pretty print" 
# (because we have a dtd).
for query in q6 q7 q8
do
   echo "" >> Part1-results.txt
   echo "--- Query" $query "---" >> Part1-results.txt
   echo "" >> Part1-results.txt
   echo "Raw results:" >> Part1-results.txt
   galax-run $query.xq >> Part1-results.txt  2>&1
   echo "<?xml version='1.0' standalone='no' ?>" > TEMP.xml
   galax-run $query.xq >> TEMP.xml  2>&1
   echo "" >> Part1-results.txt
   echo "Pretty results:" >> Part1-results.txt
   xmllint --format TEMP.xml >> Part1-results.txt  2>&1
done

echo "" >> Part1-results.txt
echo "======= Validating xml =======" >> Part1-results.txt

echo "" >> Part1-results.txt
echo "--- Query" q6 "---" >> Part1-results.txt
echo "<?xml version='1.0' standalone='no' ?>" > TEMP.xml
echo "<!DOCTYPE N15 SYSTEM 'revolution.dtd'>" >> TEMP.xml
galax-run q6.xq >> TEMP.xml  2>&1
echo "Results well-formed?" >> Part1-results.txt
xmllint --noout TEMP.xml >> Part1-results.txt  2>&1
echo "Results valid?" >> Part1-results.txt
xmllint --noout --valid TEMP.xml >> Part1-results.txt  2>&1

echo "" >> Part1-results.txt
echo "--- Query" q7 "---" >> Part1-results.txt
echo "<?xml version='1.0' standalone='no' ?>" > TEMP.xml
echo "<!DOCTYPE Quiz SYSTEM 'summary.dtd'>" >> TEMP.xml
galax-run q7.xq >> TEMP.xml  2>&1
echo "Results well-formed?" >> Part1-results.txt
xmllint --noout TEMP.xml >> Part1-results.txt  2>&1
echo "Results valid?" >> Part1-results.txt
xmllint --noout --valid TEMP.xml >> Part1-results.txt  2>&1

echo "" >> Part1-results.txt
echo "--- Query" q8 "---" >> Part1-results.txt
echo "<?xml version='1.0' standalone='no' ?>" > TEMP.xml
echo "<!DOCTYPE Grades SYSTEM 'grades.dtd'>" >> TEMP.xml
galax-run q8.xq >> TEMP.xml  2>&1
echo "Results well-formed?" >> Part1-results.txt
xmllint --noout TEMP.xml >> Part1-results.txt  2>&1
echo "Results valid?" >> Part1-results.txt
xmllint --noout --valid TEMP.xml >> Part1-results.txt  2>&1

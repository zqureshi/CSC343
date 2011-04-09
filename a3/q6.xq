(: Use the XQuery positional functions to get the corresponding Question ID :)
<N15>
{
let $quiz := doc("quiz.xml")/Quiz
for $student in doc("response.xml")/Responses/Student
  for $response at $pos in $student/Response
    return if ($response/@answered = "True" and $quiz/Question[$pos]/@id = "N-15")
    then <Response stnum="{$student/@id}" answer="{$response/@value}"/>
    else ()
}
</N15>

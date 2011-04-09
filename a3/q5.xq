(: Use the XQuery positional functions to get the corresponding Question ID :)
let $quiz := doc("quiz.xml")/Quiz
for $student in doc("class.xml")/Responses/Student
  for $response at $pos in $student/Response
    return if ($response/@answered = "False")
    then <Unanswered student="{$student/@id}" question="{$quiz/Question[$pos]/@id}"/>
    else ()

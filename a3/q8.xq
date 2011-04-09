(: Use the XQuery positional functions to get the corresponding Question ID :)
(: Use the FLWOR expression as the value of a varibale to store of marks :)
<Grades>
{
let $bank := doc("question-bank.xml")/Questions
let $quiz := doc("quiz.xml")/Quiz
for $student in doc("response.xml")/Responses/Student
  let $marks := for $response at $pos in $student/Response
                let $question := $quiz/Question[$pos]
                return if ($response/@answered = "True" and $response/@value = $bank/*[@id = $question/@id]/Answer/@text)
                then data($question/@weight)
                else 0
  return <Student stnum="{$student/@id}" mark="{sum($marks)}"/>
}
</Grades>

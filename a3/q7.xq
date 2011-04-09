<Quiz>
{
let $bank := doc("question-bank.xml")/Questions
let $quiz := doc("quiz.xml")/Quiz
for $question in $quiz/Question
  let $bank_question := $bank/*[@id = $question/@id]
  return <Question weight="{$question/@weight}"><Body>{data($bank_question/@text)}</Body><Answer>{data($bank_question/Answer/@text)}</Answer></Question>
}
</Quiz>


let $quiz := doc("quiz.xml")
let $max-weight := max($quiz/Quiz/Question/@weight)
let $max-id := $quiz/Quiz/Question[@weight = $max-weight]/@id
return doc("question-bank.xml")/Questions/*[@id = $max-id]/@text

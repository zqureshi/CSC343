(: Output a Question along with it's answer in XML :)
<Questions>
{
for $MCQ in doc("question-bank.xml")/Questions/MCQ
  return <MCQ text="{data($MCQ/@text)}" answer="{data($MCQ/Answer/@text)}"/>
}
</Questions>

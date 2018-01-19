function clearMe(formfield){
  if (formfield.defaultValue==formfield.value)
   formfield.value = ""
}

function fillMe(formfield) {
  if (formfield.value == "")
   formfield.value = formfield.defaultValue;
}
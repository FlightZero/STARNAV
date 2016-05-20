//blink
run info_screen.
SET AG5 TO FALSE.
UNTIL AG5 <> FALSE {
  

  IF AG2 = TRUE {
    SET current_message to "LIGHT ON.".
    //PRINT "LIGHT ON".
    SET AG2 TO FALSE.

  }
  IF AG3 = TRUE {
    SET current_message to "LIGHT OFF.".
    //PRINT "LIGHT OFF".
    SET AG3 TO FALSE.
  }
info_screen(current_message).
}

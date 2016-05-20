//used to test display function

run functionlibrary.

SET runmode TO 1.

UNTIL runmode = 0 {

  IF AG2 = TRUE {
    PRINT "A".
    SET current_status TO "A".
    SET AG2 TO FALSE.
  }

   IF AG3 = TRUE {
    PRINT "B".
    SET current_status TO "B".
    SET AG3 TO FALSE.
  }

   IF AG4 = TRUE {
    PRINT "C".
    SET current_status TO "C".
    SET AG4 TO FALSE.
  }

   IF AG5 = TRUE {
    // PRINT "D".
    SET current_status TO "D".
    SET AG5 TO FALSE.
  }

  IF AG6 = TRUE {
    // PRINT "E".
    SET current_status TO "E".
    SET AG6 TO FALSE.
  }

  IF AG10 = TRUE {
    SET runmode TO 0.
  }

f_info_screen().

}
SET AG10 TO FALSE.

//used to test display function 

run functionlibrary. 

UNTIL runmode = 0 {

  IF AG 1 = TRUE {
    PRINT "A".
    SET current_status TO "A".
    SET AG1 TO FALSE.
  } 
  
   IF AG 2 = TRUE {
    PRINT "B".
    SET current_status TO "B".
    SET AG2 TO FALSE.
  }  
  
   IF AG 3 = TRUE {
    PRINT "C".
    SET current_status TO "C".
    SET AG3 TO FALSE.
  }  
  
   IF AG 4 = TRUE {
    PRINT "D".
    SET current_status TO "D".
    SET AG4 TO FALSE.
  } 
  
  IF AG 5 = TRUE {
    PRINT "E".
    SET current_status TO "E".
    SET AG5 TO FALSE.
  }  
  
  IF AG 0 = TRUE {
    SET runmode TO 0.
  }  
  
f_info_screen(current_status).  

}
  
  
  

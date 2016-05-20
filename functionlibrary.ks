//functionlibrary.ks: loads functions into the active program
//created and shared under the MIT License by FlightZero

SET burn_height TO 0.

//Control panel graphic display function
DECLARE function f_info_screen {

	CLEARSCREEN.
	PRINT "----------------STARNAV CONSOLE-------------------".
	PRINT " ".
	PRINT "CURRENT SCRIPT: " + current_script.
	PRINT " ".
	PRINT "      APOAPSIS: " + ROUND(APOAPSIS).
	PRINT " ".
	PRINT "   GROUNDSPEED: " + ship:groundspeed.//SHIP:VELOCITY:SURFACE.
	PRINT " ".
  PRINT "        STATUS: " + current_status.
	PRINT " ".
	PRINT "          BURN: " + burn_height.

	WAIT 0.
}

//Original staging code by r/TempusFugit42. Modified to repeat staging until it activates an engine
DECLARE function f_stage_check {
  IF MAXTHRUST = 0 {
    until MAXTHRUST > 0 {
    stage.
		set current_status TO "STAGING".
    wait 0.5.
    }
  }
  SET numOut to 0.
  LIST ENGINES IN engines.
  FOR eng IN engines {
    IF eng:FLAMEOUT {
      SET numOut TO numOut + 1.
    }
  }
  IF numOut > 0 {
      STAGE.
      set current_status TO "STAGING".
  }
}

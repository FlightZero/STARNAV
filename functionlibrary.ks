//functionlibrary.ks: loads functions into the active program
//created and shared under the MIT License by FlightZero

// SET status_q TO QUEUE(). //a queue which holds current statuses
// SET t0 TO TIME:SECONDS.
// SET last_status to "". //this variable feeds into the queue.
// SET now_status to "".

//Control panel graphic display function
DECLARE function f_info_screen {

	// IF status_q:EMPTY = TRUE {
	// 	status_q:PUSH(last_status).
	// }
	//
	// ELSE IF current_status <> last_status {
	// status_q:PUSH(current_status).
	// SET last_status TO current_status.
  // }

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

	// IF TIME:SECONDS - t0 <= 3 {
	// 	PRINT "        STATUS: " + now_status.
	// }
	// ELSE {
	// 	SET now_status to status_q:POP.
	// 	SET t0 TO TIME:SECONDS.
	// }
	PRINT " ".
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

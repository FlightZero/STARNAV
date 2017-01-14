//functionlibrary.ks: loads functions into the active program
//created and shared under the MIT License by FlightZero


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

DECLARE function f_dv_check {
	parameter alt.

	local mu is body:mu.
	local br is body:radius.

	// present orbit properties
	local vom is velocity:orbit:mag.               // actual velocity
	local r is br + altitude.                      // actual distance to body
	local ra is br + apoapsis.                     // radius at burn apsis
	local v1 is sqrt( vom^2 + 2*mu*(1/ra - 1/r) ). // velocity at burn apsis
	// true story: if you name this "a" and call it from circ_alt, its value is 100,000 less than it should be!
	local sma1 is (periapsis + 2*br + apoapsis)/2. // semi major axis present orbit

	// future orbit properties
	local r2 is br + apoapsis.               // distance after burn at apoapsis
	local sma2 is ((alt) + 2*br + apoapsis)/2. // semi major axis target orbit
	local v2 is sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/sma1 - 1/sma2 ) ) ).


	local dv_needed is v2 - v1.
	RETURN dv_needed.
}

//u/only_to_downvote on kos subreddit
FUNCTION deltaVstage
{
    // fuel name list
    LOCAL fuels IS list().
    fuels:ADD("LiquidFuel").
    fuels:ADD("Oxidizer").
    fuels:ADD("SolidFuel").
    fuels:ADD("MonoPropellant").

    // fuel density list (order must match name list)
    LOCAL fuelsDensity IS list().
    fuelsDensity:ADD(0.005).
    fuelsDensity:ADD(0.005).
    fuelsDensity:ADD(0.0075).
    fuelsDensity:ADD(0.004).

    // initialize fuel mass sums
    LOCAL fuelMass IS 0.

    // calculate total fuel mass
    FOR r IN STAGE:RESOURCES
    {
        LOCAL iter is 0.
        FOR f in fuels
        {
            IF f = r:NAME
            {
                SET fuelMass TO fuelMass + fuelsDensity[iter]*r:AMOUNT.
            }.
            SET iter TO iter+1.
        }.
    }.

    // thrust weighted average isp
    LOCAL thrustTotal IS 0.
    LOCAL mDotTotal IS 0.
    LIST ENGINES IN engList.
    FOR eng in engList
    {
        IF eng:IGNITION
        {
            LOCAL t IS eng:maxthrust*eng:thrustlimit/100. // if multi-engine with different thrust limiters
            SET thrustTotal TO thrustTotal + t.
            IF eng:ISP = 0 SET mDotTotal TO 1. // shouldn't be possible, but ensure avoiding divide by 0
            ELSE SET mDotTotal TO mDotTotal + t / eng:ISP.
        }.
    }.
    IF mDotTotal = 0 LOCAL avgIsp IS 0.
    ELSE LOCAL avgIsp IS thrustTotal/mDotTotal.

    // deltaV calculation as Isp*g0*ln(m0/m1).
    LOCAL deltaV IS avgIsp*9.81*ln(SHIP:MASS / (SHIP:MASS-fuelMass)).

    RETURN deltaV.
}

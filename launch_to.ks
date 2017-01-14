//launch_to.ks: launch a capable craft from surface to orbit of x kilometers.
//accepts parameter desired orbit in km
//created and shared under the MIT License by FlightZero.
//Modified from u/TempusFugit42 at https://www.reddit.com/r/Kos/comments/31x3o8/kos_launch_script_works_with_any_staging_to_any/

//Declarations....
declare parameter orbit_alt IS 100. //user defined target orbit altitude in km, default 100k
declare parameter orbit_heading is 90.//user defined heading, default 90 (east)
SET orbit_alt to orbit_alt * 1000.

SET current_script TO "LAUNCH v0.1 build 68".
SET current_status TO "INITIALIZED".

//loads library of functions for use in this program
run functionlibrary.

//This is a trigger which runs independently of the runmode loop which triggers action group 10
//It is meant to be used for deploying fairings, antennae, solar panels etc. at 60k meters
WHEN ALTITUDE > 60000 THEN
{
	SET AG10 to TRUE.
	WAIT 2.
	SET AG9 to TRUE.
}


//Initialize sequence and enter the runmode loop
LOCK STEERING TO desired_direction.
SET desired_direction TO up.
SET runmode TO 1.

SET launch_start_time TO TIME:SECONDS.
SET start_long TO SHIP:GEOPOSITION:LNG.

UNTIL runmode = 0 {
	//Ignition and liftoff
	IF runmode = 1 {
		LOCK THROTTLE to 1.
		STAGE.
		//I always design vessels to stage engines first, then launch clamps. This script will work with BOTH
		//This is because liquid fueled vessels take a second to ramp to full power
		//this is a check to see if the ship is not moving i.e. clamped down
		WAIT 1.5.
		IF AIRSPEED < 1 {
			STAGE.
		}
		SET current_status TO "LIFT OFF!.".
		WAIT 1.
		SET desired_direction TO HEADING(0,90).
		SET runmode TO 2.
	}
	//roll program
	IF runmode = 2 {
		IF ALTITUDE > 200		{
			set current_status TO "ROLL PROGRAM".
			SET desired_direction TO HEADING (orbit_heading,90).
			SET runmode TO 3.
		}
	}
	//gravity turn
	IF runmode = 3 {
			IF ALTITUDE > 1000 {
				SET current_status TO "GRAVITY TURN".
				//SET targetPitch to max( 5, 90 * (1 - ALT:RADAR / 60000)).
				SET targetPitch to max( 5, 90 * (0.99996 ^ ALT:RADAR)).
				SET desired_direction to heading (orbit_heading, targetPitch).
				IF apoapsis > orbit_alt * 0.90 {
					set runmode TO 4.
					}
		}
	}
	// refine AP
	IF runmode = 4 {
		set current_status TO "REFINING APOAPSIS".
		//throttles down linerarly over range 90% to 100% of target apoapsis to a minimum of 5%
	 	lock throttle to  -9.5 * (APOAPSIS / orbit_alt) + 9.55 .

		IF apoapsis >= orbit_alt + 50 {
			SET runmode TO 5.
			lock throttle to 0.
			WAIT 1.
		}
	}
	//coast to AP and circularize
	IF runmode = 5 {

		set current_status TO "STANDBY UNTIL APOAPSIS".
		//this is a check which discards the stage if it doesn't have enough DV to execute the circ burn
		//It's intended to get rid of those pesky first stages, and prevent having to stage mid-burn during the circularization
		// IF deltaVstage() < f_dv_check(APOAPSIS) {
		// 	STAGE.
		// 	f_stage_check().
		// }
		STAGE.

		//f_stage_check().
		run circ.
		set runmode to 0.
		set current_status TO "LAUNCH PROGRAM COMPLETE".
	}
	IF stage:number > 0 {
		f_stage_check().
	}
	//displays the info screen
	IF runmode <> 0 {
		f_info_screen().
	}
}

LOG "SET "+ SHIP:NAME +"_launch_time TO " + (TIME:SECONDS - launch_start_time) + "." TO rdvinfo.ks.
LOG "SET "+ SHIP:NAME +"_launch_degrees TO " + (SHIP:GEOPOSITION:LNG - start_long) + "." TO rdvinfo.ks.
COPY rdvinfo TO 0.

lock throttle to 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
unlock throttle.
unlock steering.

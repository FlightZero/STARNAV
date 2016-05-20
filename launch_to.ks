//launch_to.ks: launch a capable craft from surface to orbit of x kilometers.
//accepts parameter desired orbit in km
//created and shared under the MIT License by FlightZero.
//Modified from u/TempusFugit42 at https://www.reddit.com/r/Kos/comments/31x3o8/kos_launch_script_works_with_any_staging_to_any/

//Declarations....
declare parameter orbit_alt IS 100. //user defined target orbit altitude in km, default 100k
declare parameter orbit_heading is 90.//user defined heading, default 90 (east)
SET orbit_alt to orbit_alt * 1000.
SET current_script TO "LAUNCH v0.1 build 66".
SET current_status TO "INITIALIZED".

//loads library of functions for use in this program
run functionlibrary.

//This is a trigger which runs independently of the runmode loop which triggers action group 10
//It is meant to be used for deploying fairings, antennae, solar panels etc. at 60k meters
WHEN ALTITUDE > 60000 THEN
{
	SET AG10 to TRUE.
	Wait 3.
	Panels ON.
	SET antenna TO SHIP:PARTSDUBBED("Communotron 16").
	FOR ant IN antenna {
	    ant:GETMODULE("ModuleRTAntenna"):DOEVENT("ACTIVATE").
	}
}

//Initialize sequence and enter the runmode loop
LOCK STEERING TO desired_direction.
SET desired_direction TO up.
SET runmode TO 1.

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
			IF ALTITUDE > 500 {
				SET current_status TO "GRAVITY TURN".
				SET targetPitch to max( 8, 90 * (1 - ALT:RADAR / orbit_alt)).
				SET desired_direction to heading (orbit_heading, targetPitch).
				IF apoapsis > orbit_alt * 0.90 {
					set runmode TO 4.
					}
		}
	}
	// circularization
	IF runmode = 4 {
		set current_status TO "REFINING APOAPSIS".
		//throttles down linerarly over range 90% to 100% of target apoapsis to a minimum of 5%
	 	lock throttle to  -9.5 * (APOAPSIS / orbit_alt) + 9.55 .

		IF apoapsis >= orbit_alt + 50 {
			set current_status TO "ENGINE OFF".
			lock throttle to 0.
			set current_status TO "STANDBY UNTIL APOAPSIS".
			run circ.
			set runmode to 0.
			set current_status TO "LAUNCH PROGRAM COMPLETE".

		}
	}
	IF stage:number > 0 {
		f_stage_check().
	}
	//displays the info screen
	IF runmode <> 0 {
		f_info_screen().
	}
}

//run donode.
lock throttle to 0.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
unlock throttle.
unlock steering.

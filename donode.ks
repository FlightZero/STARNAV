//donode.ks: executes maneuver node
//created and shared under the MIT License by FlightZero

//loads library of functions for use in this program
run functionlibrary.
SET current_script TO "NODE EXECUTOR build 17".
SET current_status TO "INITIALIZED".


SET runmode TO 1.

UNTIL runmode = 0 {
	//setup, orientation, and warp
	IF runmode = 1 {
		lock throttle to 0.
		SAS OFF.
		SET nd to nextnode.
		LOCK steering to nd.
		SET node_vector TO nd:deltav. //we are using this variable to "remember" the original direction of the node
		SET current_status TO "MOVING".
		IF abs(nd:deltav:direction:pitch - ship:facing:pitch) < 1 and
			 abs(nd:deltav:direction:yaw - ship:facing:yaw) < 1 {
			SET burntime to nd:deltav:mag/(maxthrust/mass).
			SET current_status TO "BURN TIME NEEDED: " + round(burntime,2) + " SECONDS".
			f_info_screen(). //calling info before we go into the wait
			IF nd:eta > (burntime/2) + 10 {
				WARPTO(TIME:SECONDS + nd:eta - ((burntime/2) +15)). //15 seconds before burn start
			}
			WAIT until nd:eta < ( burntime/2 ) + 10.  // ten seconds before burn start
			SET runmode to 2.
		}
	}

	//fine tuning and burn
	IF runmode = 2 {
		lock steering to nd.
		set current_status TO "ARMED".
		wait until nd:eta < burntime/2.
		set current_status TO "BURNING!".
		//a tuned logistic function that drops thottle as a function of delta v remaining
		lock throttle to 1 / ( 1 + (CONSTANT:E ^ (-0.13 * ( nd:deltav:mag - 30)))) .

		IF VDOT(nd:deltav, node_vector) <= 0 {
			lock throttle to 0.
			set current_status TO "MANEUVER TERMINATED".
			SET runmode to 0.
		}
		IF nd:deltav:mag < 0.2 {
			lock throttle to 0.
			set current_status TO "MANEUVER COMPLETE".
			SET runmode to 0.
		}
	}

	IF runmode <> 0 {
		f_info_screen().
		f_stage_check().
	}
}
f_info_screen().
SAS on.
UNLOCK throttle.
UNLOCK steering.
REMOVE nd.

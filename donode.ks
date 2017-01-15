//donode.ks: executes maneuver node
//created and shared under the MIT License by FlightZero

//loads library of functions for use in this program
run functionlibrary.
SET current_script TO "NODE EXECUTOR build 22".
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

			 //Code below gets a more accurate burn start time based on average ship thrust through the maneuver
			 //Original was written by Troy Fawkes: http://www.troyfawkes.com/adventures-in-ksp-kos-math/
			 //It has been modified to account for throttle taper-off

			 // Get initial acceleration.
			SET a0 TO maxthrust / mass.

			// In the pursuit of a1...
			// What's our effective ISP?
			SET eIsp TO 0.
			LIST engines IN my_engines.
			FOR eng IN my_engines {
			SET eIsp TO eIsp + eng:maxthrust / maxthrust * eng:isp.
			}

			// What's our effective exhaust velocity?
			SET Ve TO eIsp * 9.82.

			// What's our final mass?
			SET final_mass TO mass*CONSTANT():e^(-1 * (nd:deltav:MAG - 60) /Ve).

			// Get our final acceleration.
			SET a1 TO maxthrust / final_mass.
			// All of that ^ just to get a1..

			// Get the time it takes to complete the burn.
			//SET t TO nd:deltav:MAG / ((a0 + a1) / 2).
			SET t TO nd:deltav:MAG/ ((a0 + a1) / 2) + (60 / (a1 + 0.02 * a1) / 2).


				// Set the start and end times.
				SET start_time TO TIME:SECONDS + nd:ETA - t/2.
				SET end_time TO TIME:SECONDS + nd:ETA + t/2.
				//end Troy's code

			//SET burntime to nd:deltav:mag/(maxthrust/mass).
			SET burntime to end_time - start_time.
			SET current_status TO "BURN TIME NEEDED: " + round( burntime, 2) + " SECONDS".
			f_info_screen(). //calling info before we go into the wait

			//check to see if below atmosphere before burning.
			IF SHIP:ALTITUDE > BODY:ATM:HEIGHT {
				IF nd:eta > (burntime/2) + 10 {
					WARPTO(TIME:SECONDS + nd:eta - ((burntime/2) +15)). //15 seconds before burn start
				}
				WAIT until nd:eta < ( burntime/2 ) + 10.  // ten seconds before burn start
				SET runmode to 2.
			}
			ELSE {
				WAIT UNTIL SHIP:ALTITUDE > BODY:ATM:HEIGHT.
				IF nd:eta > (burntime/2) + 10 {
					WARPTO(TIME:SECONDS + nd:eta - ((burntime/2) +15)). //15 seconds before burn start
				}
				WAIT until nd:eta < ( burntime/2 ) + 10.  // ten seconds before burn start
				SET runmode to 2.
			}
		}
	}

	//fine tuning and burn
	IF runmode = 2 {
		lock steering to nd.
		set current_status TO "ARMED".
		//wait until nd:eta - 3 < burntime/2.
		// Complete the burn.
		WAIT UNTIL TIME:SECONDS >= start_time.
		SET current_status TO "BURNING!".
		//LOCK throttle TO 1.
		// WAIT UNTIL TIME:SECONDS >= end_time.
		// LOCK throttle TO 0.
		//a tuned logistic function that drops thottle as a function of delta v remaining
		lock throttle to 1 / ( 1 + (CONSTANT:E ^ (-0.13 * ( nd:deltav:mag - 30)))) .

		IF VDOT(nd:deltav, node_vector) <= 0 {
			lock throttle to 0.
			set current_status TO "MANEUVER TERMINATED".
			SET runmode to 0.
		}
		IF nd:deltav:mag < 0.1 {
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

//land.ks: land a capable craft from orbit to surface
//created and shared under the MIT License by FlightZero.

run functionlibrary.

DECLARE PARAMETER tgtlat IS -16.3477.
DECLARE PARAMETER tgtlng IS 84.4849.
SET tgt TO LATLNG(tgtlat,tgtlng).

set correction_pid to pidloop(1,0.2,0,-15,15).
SET correction_pid:SETPOINT TO 0.

set throttle_pid to pidloop(1.75,0.2,0,0,1).
SET throttle_pid:SETPOINT TO -2.

SET g_a TO CONSTANT:G * BODY:Mass / BODY:RADIUS^2.

LOCK ship_a TO MAXTHRUST / MASS.
LOCK burn_dist TO (SHIP:GROUNDSPEED^2 ) / (2 *  (ship_a - g_a)).
SET true_alt TO 0.


//intialize data which will be displayed for this script
SET datalist[0][0] TO "LAND 0.2 build 1".
SET datalist[0][1] TO "INITIALIZED".
SET datalist[1] TO list("PERIAPSIS: ", ROUND(PERIAPSIS),11).
SET datalist[3] TO list("IMPACT: ",0,9).
//this is the info you want refreshed every tick

DECLARE function f_updateinfo {
	SET datalist[1][1] TO ROUND(PERIAPSIS).
}


SAS OFF.
SET thrott_point TO 0.
LOCK THROTTLE TO thrott_point.

DECLARE function f_estimate_deorbit_t {
  SET deorbit_t TO (
    (ORBIT:PERIOD / 4) +
    //(f_period_future_obt(APOAPSIS,15000)*.5) +
    120
  ).
  RETURN deorbit_t.
}


SET runmode to 1.

UNTIL runmode = 0 {

    IF runmode = 1{
      SET datalist[0][1] TO "PLANE CHANGE MANEUVER".
      SET WARP TO 4.
      IF f_deg((f_deg(tgtlng) + 90 ) - f_deg(SHIP:GEOPOSITION:LNG)) < 1 {
	      SET warp to 0.
	      local deltav IS 2*ship:velocity:orbit:mag * sin(abs(tgtlat)/2).
	      local nd is node(time:seconds + 120, 0, deltav,0).
	    	add nd.
	      run donode.
	      Wait 1.
	      SET runmode TO 2.
      }
    }

    IF runmode = 2 {
      SET datalist[0][1] TO "LOW ORBIT BURN".
			SET WARP TO 4.
			IF f_deg((f_deg(tgtlng) + 180 ) - f_deg(SHIP:GEOPOSITION:LNG)) < 1 {
				SET WARP TO 0.
      	f_arbitrary_node(60,15000).
      	run donode.
      	SET runmode TO 3.
			}
    }

    IF runmode = 3 {
      SET datalist[0][1] TO "MOVE TO DEORBIT".
      SET retro TO R(RETROGRADE:PITCH, RETROGRADE:YAW, SHIP:FACING:ROLL).
      LOCK STEERING TO retro.
			WAIT 1.
    	SET WARP TO 4.
			IF ETA:PERIAPSIS < SHIP:ORBIT:PERIOD/4 {
				SET WARP TO 0.
				SET runmode TO 4.
			}
		}

		IF runmode = 4 {
			SET datalist[0][1] TO "DEORBIT BURN".
      SET retro TO R(RETROGRADE:PITCH, RETROGRADE:YAW, SHIP:FACING:ROLL).
      LOCK STEERING TO retro.
			WAIT 1.
			LOCK THROTTLE TO 0.1.
			IF ADDONS:TR:HASIMPACT = TRUE {
				IF f_deg(ADDONS:TR:IMPACTPOS:LNG) < tgtlng + 0.1 {
					LOCK THROTTLE TO 0.
					SET runmode TO 6.
				}
  		}
		}

		//this is meant to be an error correction step, but it's still being worked on. 
		IF runmode = 5 {
			SET datalist[0][1] TO "CORRECTION".
			SET impact_lat TO ADDONS:TR:IMPACTPOS:LAT.
			SET impact_lng TO ADDONS:TR:IMPACTPOS:LNG.
			SET x_error TO impact_lng - tgtlng.
			SET y_error TO impact_lat - tgtlat.
			SET total_error TO SQRT(x_error^2 + y_error^2).
			SET correction_heading TO f_error_heading(x_error,y_error).
			LOCK STEERING TO HEADING(correction_heading, 0).
			UNTIL total_error < .003 { LOCK THROTTLE TO 0.05.}
			LOCK THROTTLE TO 0.
			SET datalist[0][1] TO "ON TARGET".
			SET runmode TO 6.
		}

		IF runmode = 6 {
			SET datalist[0][1] TO "POWERED DESCENT".
			SET datalist[3] TO list("BURN OFFSET: ", ROUND(burn_dist), 13).
			SET datalist[4] TO list("DISTANCE: ", ROUND(ADDONS:TR:IMPACTPOS:DISTANCE), 10).

			LOCK STEERING TO SHIP:SRFRETROGRADE.
			GEAR ON.
			SET true_alt TO ADDONS:TR:IMPACTPOS:DISTANCE - ADDONS:TR:IMPACTPOS:TERRAINHEIGHT.
			WHEN ADDONS:TR:IMPACTPOS:DISTANCE - ADDONS:TR:IMPACTPOS:TERRAINHEIGHT < burn_dist + 100 THEN {  //SHIP:GEOPOSITION:TERRAINHEIGHT
				LOCK THROTTLE TO 1.
				WHEN SHIP:VERTICALSPEED >= -10 THEN {
					SET runmode TO 7.
				}
			}
		}

		IF runmode = 7 {
			UNTIL SHIP:STATUS = "LANDED"{
				SET true_alt TO SHIP:ALTITUDE - ADDONS:TR:IMPACTPOS:TERRAINHEIGHT.
				LOCK STEERING TO LOOKDIRUP(UP:VECTOR - .1 * vxcl(up:vector, velocity:surface), ship:facing:topvector).
				IF true_alt < 5 {SET throttle_pid:SETPOINT TO -1.}
				ELSE {SET throttle_pid:SETPOINT TO -((true_alt * 0.1) + 4).}
				LOCK THROTTLE TO throttle_pid:UPDATE(TIME:SECONDS, SHIP:VERTICALSPEED).
				CLEARSCREEN.
				PRINT true_alt.
			}
			IF SHIP:STATUS = "LANDED" {
				PRINT "LANDED".
				SET runmode TO 0.
				LOCK THROTTLE TO 0.
			}
		}

    IF runmode <> 0 {
  		f_info_screen().
  	}

}

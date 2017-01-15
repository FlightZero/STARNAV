//land.ks: land a capable craft from orbit to surface
//created and shared under the MIT License by FlightZero.

run functionlibrary.
SET current_script TO "LAND 0.2 build 1".
SET current_status TO "INITIALIZED".
set data2title TO "PERIAPSIS: ".
set data2length TO 11.
set data2 TO ROUND(PERIAPSIS).


SAS OFF.
SET runmode to 1.

UNTIL runmode = 0 {
    IF runmode = 1 {
      SET current_status TO "DEORBIT BURN".
      SET retro TO R(RETROGRADE:PITCH, RETROGRADE:YAW, SHIP:FACING:ROLL).
      LOCK steering to retro.
      IF vdot(RETROGRADE:VECTOR, SHIP:FACING:VECTOR) > .99 {
        SET current_status TO "ALIGNED".
        //SET thrott_point TO 1.
      }
    }
    IF runmode <> 0 {
  		f_info_screen().
  	}

}


// SET sP TO 10.
// SET sI TO 0.1.
// SET sD TO 0.05.
// SET sSP TO 0.
// SET p_pid TO PIDLOOP(sP, sI, sD, -50, 50).
// SET p_pid:SETPOINT TO sSP.
// SET y_pid TO PIDLOOP(sP, sI, sD, -50, 50).
// SET y_pid:SETPOINT TO sSP.
//
// SET my_pitch TO 0.
// SET my_yaw TO 0.
//
// SET g TO BODY:MU / BODY:RADIUS^2.
// LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
// LOCK gforce TO accvec:MAG / g.
//
// SET gforce_setpoint TO 1.
// SET goal_altitude TO 150.
// SET goal_speed TO 0.
//
// SET Kp to 0.4.
// SET Kd to 0.4.
//
// SET current_script TO "LAND build 4".
// SET current_status TO "INITIALIZED".
//
// // All running engines
// LIST ENGINES IN all_engines.
// // Use first (and only) for calculations (assuming ship with single engine)
// SET curr_engine TO all_engines[0].
//
// SET thrott_point TO 0.
// LOCK THROTTLE TO thrott_point.
//
//
//
// SET runmode to 1.
//
// SAS off.
//
// UNTIL runmode = 0 {
//
//   // 1. DEORBIT: If in orbit, lock to retrograde and burn until there's an intersect with the surface.
//   IF runmode = 1 {
//     SET current_status TO "DEORBIT BURN".
//     LOCK steering TO RETROGRADE.
//     SET thrott_point TO 1.
//
//     IF PERIAPSIS < -30000 {
//       SET thrott_point TO 0.
//       SET runmode TO 2.
//     }
//
//   }
//
// //COAST TO HORIZONTAL VELOCITY CANCEL BURN (HVCB)
// //Execute HVCB
//   IF runmode = 2 {
//     SET current_status TO "COAST TO HVCB".
//
//     IF SHIP:ALTITUDE - SHIP:GEOPOSITION:TERRAINHEIGHT < 10000 {
//
//       SET current_status TO "EXECUTE HVCB".
//       LOCK STEERING TO LOOKDIRUP(UP:VECTOR - .1 * vxcl(up:vector, velocity:surface), ship:facing:topvector).
//       SET thrott_point TO 1.
//       WHEN ship:groundspeed <= 5 THEN {
//         SET thrott_point TO 0.
//         SET runmode to 3.
//       }
//     }
//   }
//   //Coast to suicide burn
//   IF runmode = 3 {
//     SET current_status TO "COAST TO VERT VCB".
//     LOCK STEERING TO SHIP:SRFRETROGRADE.
//     LOCAL force_g IS CONSTANT:G * BODY:Mass / BODY:RADIUS^2.
//     LOCAL b_mass IS BODY:MASS.
//     LOCAL max_acceleration IS AVAILABLETHRUST / MASS.
//     LOCAL P_i IS SHIP:ALTITUDE + BODY:RADIUS.
//     LOCAL P_f IS SHIP:ALTITUDE - ALT:RADAR.
//     //LOCK P_x TO ( CONSTANT:G * b_mass * ( (1 / P_f)  - (1/P_i)) / max_acceleration) + P_f.
//     LOCK burn_height TO  SHIP:VERTICALSPEED^2 / (2 * (max_acceleration - force_g)).//SHIP:SENSORS:GRAV:MAG).
//
//     //Suicide burn
//     //landing equation from CalebJ2
//     //https://github.com/CalebJ2/kOS-landing-script/blob/master/land.ks
//     WHEN SHIP:ALTITUDE - SHIP:GEOPOSITION:TERRAINHEIGHT <= burn_height + 15 THEN {
//       SET current_status TO "EXECUTE VERT VCB".
//       SET thrott_point TO 1.
//       LOCK STEERING TO LOOKDIRUP(UP:VECTOR - .1 * vxcl(up:vector, velocity:surface), ship:facing:topvector).//SHIP:UP + R(my_pitch, my_yaw, 180 ).
//
//       WHEN SHIP:VERTICALSPEED >= -2 THEN {
//         SET runmode TO 4.
//       }
//     }
//   }
//
//   IF runmode = 4 {
//
//     GEAR ON.
//
//     SET current_status TO "CONTROLLED DESCENT".
//
//     SET my_pitch TO -1 * p_pid:UPDATE(TIME:SECONDS, SHIP:VELOCITY:SURFACE * ship:facing:topvector).
//     SET my_yaw TO  y_pid:UPDATE(TIME:SECONDS, SHIP:VELOCITY:SURFACE * ship:facing:starvector).
//
//     SET goal_speed TO -2.
//     LOCK hover_throttle_level TO MIN(1, MAX(0, SHIP:MASS * g / MAX(0.0001, curr_engine:AVAILABLETHRUST))).
//     LOCK dthrott_d to Kd * (goal_speed - SHIP:VERTICALSPEED).
//     LOCK dthrott TO dthrott_d.
//
//     SET Kp to 0.
//     SET thrott_point to hover_throttle_level + dthrott.
//     IF SHIP:STATUS = "LANDED" {
//
//       LOCK THROTTLE to 0.
//       SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
//       unlock throttle.
//       unlock steering.
//       SAS ON.
//       SET current_status TO "LANDED".
//       SET runmode to 0.
//     }
//   }
//
// f_info_screen().
// }

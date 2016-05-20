//hover.ks: testing for landing script
//created and shared under the MIT License by FlightZero
SET my_pitch TO 0.
SET my_yaw TO 0.

run functionlibrary.
//run lib_pid.

SET current_script TO "HOVER build 10".
SET current_status TO "INITIALIZED".
SET tot_fuel TO STAGE:LIQUIDFUEL.
SET thrott to 1.
SET dthrott to 0.
SET surf_pro to 0.

// All running engines
LIST ENGINES IN all_engines.
// Use first (and only) for calculations (assuming ship with single engine)
SET curr_engine TO all_engines[0].

f_info_screen().


// // staging, throttle, steering, go
// WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
//     STAGE.
//     PRESERVE.
// }
//LOCK h_vel TO

SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

SET gforce_setpoint TO 1.
SET goal_altitude TO 150.
SET goal_speed TO 0.

SET Kp to 0.4.
SET Kd to 0.4.

LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
SET SHIP:CONTROL:ROLLTRIM to 0.
//LOCK STEERING TO
LOCK THROTTLE TO thrott.
STAGE.

SET runmode to 1.
UNTIL runmode = 0 {

  IF runmode = 1{
    WAIT UNTIL SHIP:ALTITUDE > 90.

    LOCK dthrott_p to Kp * (goal_altitude - SHIP:ALTITUDE).//(gforce_setpoint - gforce).
    LOCK dthrott_d to Kd * (goal_speed - SHIP:VERTICALSPEED).
    //LOCK dthrott TO dthrott_d.
    LOCK dthrott TO dthrott_p + dthrott_d.


    LOCK hover_throttle_level TO MIN(1, MAX(0, SHIP:MASS * g / MAX(0.0001, curr_engine:AVAILABLETHRUST))).
    SET runmode to 2.
  }

  IF runmode = 2{
    SET AG4 to FALSE.
    SET goal_speed TO 0.

    SET thrott to hover_throttle_level + dthrott.
    SET anArrow TO VECDRAW(
          V(0,0,0),
          ship:velocity:surface,
          RGB(1,0,0),
          "velocity",
          1,
          TRUE,
          0.2
    ).

    SET current_status TO "HOVERING".
    SET surf_pro to ship:srfprograde:pitch.
    f_info_screen().

  }



  IF runmode = 3 {
    //lock steering to -vxcl(up:vector, velocity:surface).
    SET AG5 to FALSE.
    LOCK STEERING TO LOOKDIRUP(UP:VECTOR - .1 * vxcl(up:vector, velocity:surface), ship:facing:topvector).
    SET thrott to hover_throttle_level + dthrott.
    SET current_status TO "CANCELING HVEL".
    //f_info_screen().
  }


  // UNTIL AG6 = TRUE  {
  //   //lock steering to -vxcl(up:vector, velocity:surface).
  //   LOCK STEERING TO UP:VECTOR - .1 * vxcl(up:vector, velocity:surface).
  //   SET thrott to hover_throttle_level + dthrott.
  //   SET runmode TO 0.
  //   SET current_status TO "CANCELING HVEL".
  //   f_info_screen().
  //
  // }
  IF runmode = 4 {
    SET AG6 to FALSE.

    SET sP TO 10.
    SET sI TO 0.1.
    SET sD TO 0.05.
    SET sSP TO 0.

    SET p_pid TO PIDLOOP(sP, sI, sD, -45, 45).
    SET p_pid:SETPOINT TO sSP.

    SET y_pid TO PIDLOOP(sP, sI, sD, -45, 45).
    SET y_pid:SETPOINT TO sSP.

    LOCK STEERING TO SHIP:UP + R(my_pitch, my_yaw, ship:facing:roll ).

    SET my_pitch TO  p_pid:UPDATE(TIME:SECONDS, SHIP:VELOCITY:SURFACE * ship:facing:topvector).
    SET my_yaw TO -1 * y_pid:UPDATE(TIME:SECONDS, SHIP:VELOCITY:SURFACE * ship:facing:starvector).

    SET goal_speed TO -2.
    SET Kp to 0.
    SET thrott to hover_throttle_level + dthrott.
    SET current_status TO "CONTROLLED DESCENT".
    f_info_screen().

    IF ship:status = "landed"  { set runmode to 0.}

  }


  f_info_screen().
  IF AG4 = TRUE { SET runmode to 2.}
  IF AG5 = TRUE { SET runmode to 3.}
  IF AG6 = TRUE { SET runmode to 4.}

}

LOCK THROTTLE to 0.
SET anArrow:show TO FALSE.
//SET anArrow2:show TO FALSE.

SET AG5 TO FALSE.
SET AG6 TO FALSE.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
unlock throttle.
unlock steering.
SET current_status TO "LANDED".
f_info_screen().

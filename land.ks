//land.ks: land a capable craft from orbit to surface
//created and shared under the MIT License by FlightZero.

run functionlibrary.

SET runmode to 1.

SAS off.

UNTIL runmode = 0 {

  // 1. DEORBIT: If in orbit, lock to retrograde and burn until there's an intersect with the surface.
  IF runmode = 1 {
    LOCK steering TO RETROGRADE.
    UNTIL PERIAPSIS < -30000 {
      LOCK THROTTLE TO 1.
    }
    LOCK THROTTLE TO 0.
    SET runmode TO 2.
  }

// 2. COAST TO HORIZONTAL VELOCITY CANCEL BURN (HVCB): Wait until craft is 5000 m above surface
  IF runmode = 2 {
    IF SHIP:ALTITUDE < 5000 {

      UNTIL ship:groundspeed < 5 {
        LOCK STEERING TO LOOKDIRUP(UP:VECTOR - .1 * vxcl(up:vector, velocity:surface), ship:facing:topvector).
        LOCK THROTTLE TO 1.
      }
      LOCK THROTTLE TO 0.
    }
  }
//
// 3. HVCB: this should run until horizontal velocity is < 1 m/s, when precision is introduced this should happen at nearest approach to target area
//   a. Cancel out horizontal velocity.
//       If horizontal velocity < .05 m/s, lock steering to up.
//       Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
//         But no more than horizontal.
//   b. Vertical velocity: some vertical velocity is being cancelled out by the downward component of craft orientation.
//
// 4. Wait until the right time to do a suicide burn - 5 sec buffer.
//
// 4. SUICIDE BURN
//   a. Cancel out horizontal velocity.
//       If horizontal velocity < .05 m/s, lock steering to up.
//       Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
//         But no more than horizontal.
//   b. Cancel out vertical velocity such that velocity < -0.5 m/s.
//
// 5. FINAL DESCENT: run until landed , this should ideally go at 10 m above the surface.
//   a. Cancel out horizontal velocity.
//       If horizontal velocity < .01 m/s, lock steering to up.
//       Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
//         But no more than horizontal.
//   b. descend at -0.5 m/s.

}

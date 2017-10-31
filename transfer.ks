//transfer.ks: find and set a maneuver node for transfer to the mun from arbitrary orbit
//accepts parameter desired PE in km
//created and shared under the MIT License by FlightZero.

SET current_script TO "TRANSFER v1.0 build 30".
SET current_status TO "INITIALIZED".

declare parameter pe to 100.

//finds dv for transfer
declare function transferdv {
  set GM to body:mu.
  set rA to ship:altitude + body:radius.
  set rB to target:altitude + body:radius.
  set atx to (rA + rB) / 2.
  set vtxa to sqrt(GM *((2/rA)-(1/atx))).
  set via to sqrt(GM / rA).
  set dva to vtxa - via.
  return dva.
}

//finds moves the node forward until there's an encounter
declare function transfer {
  set tstep to orbit:period.
  set runmode to 1.
  set nodet to time:seconds + tstep.
  set dv to transferdv().

  until runmode = 0 {
    set node1 to node(nodet, 0, 0, dv).
    add node1.
    beep().
    set eta_f_ap to time + nextnode:eta + (orbitat(ship, time + nextnode:eta + 1):period/2).
    set p1 to positionat(target, eta_f_ap).
    set p2 to positionat(ship, eta_f_ap).
    set dist1 to (p1 - p2):mag.
    if dist1 < (3.2 * (10^6)) {
      set runmode to 0.
    }
    else {
      set tstep to (orbit:period / 100).
      set nodet to nodet + tstep.
      wait 0.1.
      remove node1.
    }
  }
}

//refines the pe
declare function refine {
  declare parameter desired_pe is 50.
  set error_pid to pidloop(0.0001,0,0,-1,1).
  SET error_pid:SETPOINT TO 0.
  set step to 0.
  set nx to nextnode.
  set error to nextnode:orbit:nextpatch:periapsis - (desired_pe * 1000).
  set exit to false.

  until exit = true {
    set step to -error_pid:update(time:seconds, error).
    set nx:eta to nx:eta + step.
    set error to nextnode:orbit:nextpatch:periapsis - ((desired_pe * 1000)+5).
    if abs(error) <= 5 {
      set exit to true.
    }
    wait 0.1.
  }
}

//happy beep to signal end of the script
declare function confirmbeep {
  SET V0 TO GETVOICE(0).
  V0:PLAY(
    LIST(
      NOTE("c4",  0.1,  0.2),
      NOTE("f4",  0.1,  0.2),
      NOTE("a4",  0.1,  0.2),
      NOTE("f5",  0.1,  0.25)
    )
  ).
}

//single beep
declare function beep {
  SET V0 TO GETVOICE(0).
  V0:PLAY(
    LIST(
      NOTE("f5",  0.04,  0)
    )
  ).
}

transfer().
refine(pe).
confirmbeep().

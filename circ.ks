//code by xeger, modified to take alt in kilometers
//https://github.com/xeger/kos-ramp

if obt:transition = "ESCAPE" or eta:periapsis < eta:apoapsis {
  run node_apo(obt:periapsis / 1000).
} else {
  run node_peri(obt:apoapsis / 1000).
}

run donode.

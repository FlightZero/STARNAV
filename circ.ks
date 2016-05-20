//code by xeger, modified to take alt in kilometers

if obt:transition = "ESCAPE" or eta:periapsis < eta:apoapsis {
  run node_apo(obt:periapsis / 1000).
} else {
  run node_peri(obt:apoapsis / 1000).
}

run donode.

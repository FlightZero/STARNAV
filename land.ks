//This will be a landing script. It can be called from orbit or from a sub-orbital trajectory.
//Right now this doc is notes, not code. 

Sequence of problems to solve
1. DEORBIT: If in orbit, lock to retrograde and burn until there's an intersect with the surface.
2. COAST TO FINAL DESCENT: Wait until craft is 5000 m above surface
3. FINAL DESCENT:
  a. Cancel out horizontal velocity.
      If horizontal velocity < .05 m/s, lock steering to up.
      Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
        But no more than horizontal. 
  b. Cancel out vertical velocity such that velocity at touchdown < -0.5 m/s.
      

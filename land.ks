//This will be a landing script. It can be called from orbit or from a sub-orbital trajectory.
//Right now this doc is notes, not code. 

Sequence of problems to solve
1. DEORBIT: If in orbit, lock to retrograde and burn until there's an intersect with the surface.

2. COAST TO HORIZONTAL VELOCITY CANCEL BURN (HVCB): Wait until craft is 3000 m above surface

3. HVCB: this should run until horizontal velocity is < 1 m/s, when precision is introduced this should happen at nearest approach to target area 
  a. Cancel out horizontal velocity.
      If horizontal velocity < .05 m/s, lock steering to up.
      Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
        But no more than horizontal. 
  b. Vertical velocity: some vertical velocity is being cancelled out by the downward component of craft orientation.
  
4. Wait until the right time to do a suicide burn - 5 sec buffer.   
  
4. SUICIDE BURN 
  a. Cancel out horizontal velocity.
      If horizontal velocity < .05 m/s, lock steering to up.
      Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
        But no more than horizontal. 
  b. Cancel out vertical velocity such that velocity < -0.5 m/s.  
  
5. FINAL DESCENT: run until landed , this should ideally go at 10 m above the surface.
  a. Cancel out horizontal velocity.
      If horizontal velocity < .01 m/s, lock steering to up.
      Else lock steering to surface retrograde + a variable distance from 90 deg depending on the distance from 90 of the retro vector.
        But no more than horizontal. 
  b. descend at -0.5 m/s.
  
  
      

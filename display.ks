//design doc for a display console 

Problem: get messages to display on screen for at least two seconds.
Issues -when the display function is called in a loop, it refreshes several times per second 
       -current statuses for functions that are called only once (ie staging) would only display for one refresh of the screen
       -adding a wait for the info screen delays the entire loop for the length of the wait

Potential solutions
  -feed updates into a queue, which feeds into a "current" variable 
  -if update = the last item in queue, do not add 
  -if there are no more entries in the queue, repeat the current variable 
  -re-get the current variable every three seconds 
    

# Space-Travel-Script-System
A connected system of scripts for use in kOS, a Kerbal Space Program mod
for KSP v 1.1 and kOS v 0.20.0

#Intent
As my first foray into kOS, this will be centralized place to store, update and share my kOS programs. This is a window into a learning process. I have experienced some frustration with advanced scripts that other coders have shared- I find that simple resources would work better. Hopefully my rudimentary initial efforts will help other kOS beginners by presenting simple initial steps. 

#Design Principles
1. Modular: scripts are re-usable, may be combined, or used alone.
2. Design-agnostic: scripts are designed with maximum flexibility with regards to vehicle design. They should work with any craft which is nominally capable of executing the mission. 
3. Accessible: code is well-formatted and commented. Comments are written in plain language and clearly communicate intent at every step.
4. Ethical: inspiration is aknowledged with links.

#Style Guide
This is how I'll standardize my code. I've tried to fall in line with what other community members seem to be converging on for Kerbal Script, but I'll use my own conventions where I think it helps with clarity/ readability/ my personal understanding. 
- Brackets: 
```        
          IF x THEN {
            action. 
          }
```
- Commands, flow control, kOS variables: UPPERCASE for clarity, and to role-play working on 1970's era computers.
- Indents: one space.
- Names:
  - Programs: one or two-word. "program.ks"
  - Programs with parameter: Two word. "launch_to.ks"
  - Functions: two word, preceded by "f_". "f_info_screen"
  - Variables: descriptive, two word. "lower_case"


  

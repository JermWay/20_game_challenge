# Game 04 Asteroids
My take on the 1979 arcade classic asteroids. 
This project focuses on menu design and advanced character controls.

## Scope
-   2D physics-based character controller
	-   Manage 2D vectors and rotations in free space
-   Main menu and a restart menu.
-   Player ship. 
	- Rotate and accelerate the ship in the direction that it is facing.
		- Thruster SFX
		- Thruster particles
	- Fire bullets in the direction that it is facing. Bullets will disappear after a short while.
		- Firing SFX
-   Three sizes of asteroids.
	-   Asteroids will break into smaller asteroids when shot (The smallest will disappear when shot).
		- Explosion SFX
		- Explosion particles
	-   Asteroids will drift around until they are shot or they collide with the player. 
	-  If the player collides with an asteroid, they will lose a life.
-   Screen wrapping.
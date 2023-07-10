/**
* Class for the power up objects used in game
*/
class PowerUps {
  //fields for the power up variables
  float powerup_x;
  float powerup_y;
  float powerup_dim;
  float powerup_vy = 3.5;
  PImage powerup_sprite;
  
  /**
  * Constructor for power ups
  */
  PowerUps(float x, float y, float dim, PImage sprite, String name) {
    powerup_x = x;
    powerup_y = y;
    powerup_dim = dim;
    powerup_sprite = sprite;
    powerup_name = name;
  }
  
 /**
 * Update the velocity of the power up so it will fall down 
 */
 void update() {
    powerup_y += powerup_vy;
 }
 
 /**
 * Check whether the power up has collided with the floor, return true if so
 */
 boolean checkWallCollision() {
    if (powerup_y + powerup_dim > height) {return true;}
    return false;
  }
  
  /**
  * Getters to return parameters of the power up
  */
  String getName() {return powerup_name;}
  PImage getSprite() {return powerup_sprite;}
  float getX() {return powerup_x;}
  float getY() {return powerup_y;}
  float getDim() {return powerup_dim;}
}

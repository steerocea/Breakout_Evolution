/**
* Ball class for the ball object used in game
*/
class Ball {
  // fields for ball variables
  float ball_x;
  float ball_y;
  float ball_w;
  color ball_col;
  float ball_vy = 6;
  float ball_vx = 6;
  float fire_x; // fields for the fire ball animation position
  float fire_y;
  
  /**
  * Constructor for ball 
  */
  Ball(float x, float y, int Width, color Color) {
    ball_x = x;
    ball_y = y;
    fire_x = x;
    fire_y = y;
    ball_w = Width;
    ball_col = Color;
  }
  
  /**
  * Draws the ball on the screen according to parameters that were passed in
  */
  void draw() {
    noStroke();
    fill(ball_col);
    ellipse(ball_x, ball_y, ball_w, ball_w);
  }

  /**
  * Used to move the ball back to the defult position
  */
  void move(int X, int Y) {
    ball_x = X;
    ball_y = Y;
    ball_vy = 6;
    ball_vx = 6;
  }
  
  /**
  * Used to adjust the ball and fireballs velocity accordingly
  */
  void update() {
    ball_x += ball_vx;
    ball_y += ball_vy;
    fire_x += ball_vx;
    fire_y += ball_vy;
  }
  
  /**
  * Set color of ball
  */
  void setColor(color col) {ball_col = col;}
  
  /**
  * Used to ensure that the ball bounces of the walls of the window, but if it collides with the floor return true
  */
  boolean checkWallCollision() {
    if (ball_x > width-ball_w / 2) { // right wall collison
      ball_vx = -abs(ball_vx); // bounce the ball in the opposite direction 
    } else if (ball_x < ball_w / 2) { // left wall collision
      ball_vx = abs(ball_vx);
    }
    if (ball_y > height - ball_w / 2) { // floor collision 
      ball_vy = -abs(ball_vy);
      return true; // return true if the ball hit the floor 
    } else if (ball_y < ball_w / 2) { // roof collision 
      ball_vy = abs(ball_vy);
    }
    return false; // return false if the ball didn't hit the floor 
  }
  
  /**
  * Return the ball's x position adjusted to the fire ball sprite size 
  */
   float getX() {return fire_x - 14;}

  /**
  * Return the ball's y position adjusted to the fire ball sprite size 
  */
  float getY()  {return fire_y - 14;} 
}

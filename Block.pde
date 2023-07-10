/**
* Block class for the brick objects used in game 
*/
class Block {
  // fields for block variables
  float block_x; 
  float block_y;
  float block_w;
  float block_h;
  color block_col;
  int maxHits = 1; // amount of times a block can be hit before breaking 
  int hits = maxHits;
  String[] powerup_names = {"double_ball", "extra_life", "saftey_net", "wider_platform", "x2_points", "fire_ball"};
  
  /**
  * Constructor for block
  */
  Block(float x, float y, float Width, float Height, color Color) {
    block_x = x;
    block_y = y;
    block_w = Width;
    block_h = Height;
    block_col = Color;
  }
  
  /**
  * Used to draw blocks on the screen according to parameters that were passed in
  */
  void draw() {
    noStroke();
    fill(block_col);
    rect(block_x, block_y, block_w, block_h);
  }

  /**
  * Moves the block to be centered on x and y point passed in
  */ 
  void move(int x, int y) {
    block_x = x-block_w/2;
    block_y = y-block_h/2;

    // stops the block from going off the screen area on the x-axis
    if (block_x + block_w > width) {
      block_x = width - block_w;
    } else if (block_x < 0) {
      block_x = 0;
    }

    // stops the block from going off the screen area on the y-axis
    if (block_y + block_h > height) {
      block_y = height - block_w;
    } else if (block_y < 0) {
      block_y = 0;
    }
  }
  
  /**
  * Returns number of times the block has left to be hit before it dissapears (returns 0 if it needs to be removed)
  */
  int getHits() {
    return hits;
  }

  /**
  * Set the number of times a block can be hit before dissapearing 
  */
  void setMaxHits(int numOfHits) {
    maxHits = numOfHits;
    hits = maxHits;
  }

  /** 
  * Returns a boolean on whether the ball has collided with a block and changes the velocity accordingly (returns true if the ball collided with a block)
  */
  boolean collidesWith(Ball b, boolean fire_ball_active) {
    // top of block collision
    if ((b.ball_x + b.ball_w / 4 > block_x && b.ball_x - b.ball_w / 4 < block_x + block_w)
      && (b.ball_y + b.ball_w / 2 < block_y + block_h && b.ball_y + b.ball_w / 2 > block_y)) {
      if(fire_ball_active == false) {b.ball_vy = -abs(b.ball_vy);}
      hits--;
      return true;
    }
    
    // bottom of block collision
    if ((b.ball_x + b.ball_w / 4 > block_x && b.ball_x - b.ball_w / 4 < block_x + block_w)
      && (b.ball_y - b.ball_w / 2 < (block_y + block_h) && b.ball_y - ball_w / 2 >block_y)) {
      if(fire_ball_active == false) {b.ball_vy = abs(b.ball_vy);}
      hits--;
      return true;
    }

    // left of block collision
    else if ((b.ball_y + b.ball_w / 4 > block_y && b.ball_y - b.ball_w / 4 < block_y + block_h)
      && (b.ball_x + b.ball_w / 2 > block_x && b.ball_x + b.ball_w / 2 < block_x + block_w)) {
      if(fire_ball_active == false) {b.ball_vx = -abs(b.ball_vx);}
      hits--;
      return true;
    }

    // right of block collision 
    if ((b.ball_y + b.ball_w / 4 > block_y && b.ball_y - b.ball_w / 4 < block_y + block_h)
      && (b.ball_x - b.ball_w / 2 < block_x + block_w && b.ball_x - b.ball_w / 2 > block_x)) {
      if(fire_ball_active == false) {b.ball_vx = abs(b.ball_vx);}
      hits--;
      return true;
    }
    return false;
  }
  
  /**
  * Returns true if a power up has collided with a block in this case used with the bat block
  */
  boolean collidesWithPowerup(PowerUps pu) {
    if ((pu.powerup_x + pu.powerup_dim > block_x && pu.powerup_x - pu.powerup_dim < block_x + block_w)
       && (pu.powerup_y + pu.powerup_dim < block_y + block_h && pu.powerup_y + pu.powerup_dim > block_y)) {
      return true;
    }
    return false;
  }
  
  /**
  * Each time a brick is broken run a random chance of a power up being made, returns true if on is to be made
  */
  boolean powerupChance() {
    if (random(50) <= 10) {
      return true;
    } return false;
  }
  
  /**
  * Generate and return random name for the power up to be produced
  */
  String randomName() {
      String random_powerup = powerup_names[int(random(powerup_names.length))];
      return random_powerup;
  }
  
  /**
  * Return the x and y positions of the block respectively
  */
  float getX() {return block_x;}
  float getY() {return block_y;}
  
}

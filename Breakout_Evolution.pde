import processing.sound.*; // importing sound library

// Fields to store the sound affects and in game music
SoundFile menu_music;
SoundFile game_music;
SoundFile block_hit_sound;
SoundFile power_up_sound;
SoundFile lose_life_sound;
SoundFile level_up_sound;
boolean play_pu_sound = false;
boolean menu_music_active = false;
boolean game_music_active = false;

// Set window sizes, starting score, Num of lives, and a string to show messages to the player 
int width_d = 800;
int height_d = 900;
String message;
int score = 0;
int lives = 3;

// booleans for the game states, used to tell the program which level is currently active aswell as whether to display level mesages or replay the game 
boolean main_menu = true;
boolean level_1 = false;
boolean level_2 = false;
boolean level_3 = false;
boolean game_won = false;
boolean replay = false;
boolean level_message_active = true;
String level_message = "Level 1";
Button play_game = new Button(275, 500, 250, 100, 10, "PLAY"); // button objects for starting and replaying the game 
Button replay_button = new Button(275, 500, 250, 100, 10, "REPLAY");

// Setting the variables to draw the ball with, inluding its starting position and color
int ball_w = 16;
color ball_col = color(255);
float ball_startX = random(width_d);
float ball_startY = height_d/2;
Ball game_ball = new Ball(ball_startX, ball_startY, ball_w, ball_col); // creating the ball objects for the game ball and the double ball power up
Ball double_ball = new Ball(ball_startX - 10, ball_startY, ball_w, ball_col);

// Setting the variables for the bricks to be drawn on the screen. Starting with the deminisions we want on level 1
int spaceBetweenBricks = 10; // the space between each brick
int NumOfBricks = 10; // Num of bricks to draw
int NumOfRows = 10; // Num of rows of bricks to draw 
int spaceFromRoof = 50; // space between the first row of bricks and the roof of the window
int spaceFromWall = 20; // space between the first row of bricks and the roof of the window

float brick_x = 0; // variables for the size of brick objects
float brick_w = (width_d-(NumOfBricks-2)*spaceBetweenBricks)/NumOfBricks;
float brick_h = 10;
color brick_cols[] = {color(255, 105, 180), color(135, 206, 235)}; // array of colors used for the bricks
color brick_col = color(255, 255, 0);
ArrayList<Block> brickList = new ArrayList<Block>(); // list of the bricks currently on the screen

// Setting the variables to draw the game bat, including its dimensions without power-ups and colour
int bat_x = width_d/2;
int bat_y = height_d-50;
int bat_h = 20;
int bat_w = 140;
color bat_col = color(255, 105, 180);
Block bat = new Block(bat_x, bat_y, bat_w, bat_h, bat_col); // creating object for game bat and for wider bat power up
Block wide_bat = new Block(bat_x, bat_y, bat_w + 100, bat_h, bat_col);

// Setting fields and variables for the power ups including the name and dimensions of the power up
String powerup_name;
float powerup_dim;
ArrayList<PowerUps> powerup_list = new ArrayList<PowerUps>(); // list of powerups on screen
ArrayList<PowerUps> to_remove = new ArrayList<PowerUps>(); // list of power ups to remove that have been picked up by the bat
ArrayList<PowerUps> to_remove_active = new ArrayList<PowerUps>(); // list of power ups to remove that have finished their and need to be deactivated
ArrayList<PowerUps> to_remove_floor = new ArrayList<PowerUps>(); // list of power ups that have hit the floor and need to be removed
ArrayList<PowerUps> activated_list = new ArrayList<PowerUps>(); // list of power ups that have hit the bat and need to be activated
ArrayList<Timer> timer_list = new ArrayList<Timer>(); // list of timers currently active
ArrayList<Timer> timer_remove = new ArrayList<Timer>(); // list of timers that have finished their count and need to be removed 

// boolean variables on which powerup are currently active in order for them to run their affects 
boolean double_ball_active = false; 
Block saftey_net = null;
boolean wide_bat_active = false;
boolean fire_ball_active = false;
boolean x2_points_active = false;

// Setting fields on whether the user has won or lost the game 
boolean hasLost = false;
boolean hasWon = false;

// fields for the animation involved in the fire ball power up
PImage fire_ball_sheet;
PImage[] fireB = new PImage[12];
int animationFrame = 0;
int frameSlow = 0;

/**
* Main setup function to initialise my program
*/
void setup() {
  frameRate(60); // set the framerate, window size, and background color
  size(800, 900);
  background(0);
  setBricks(); // set the parameter for the brick layout 
  fire_ball_sheet = loadImage("sprites/fire_ball_sprite_sheet.png"); // load the sprite sheet for the fireball power up
  for (int i=0; i<fireB.length; i++) {
    fireB[i] = fire_ball_sheet.get(i*32, 0, 32, 32); // load the spirte sheet into each individual frame
  }
}

/**
* Main draw function for my program to be called every frame
*/
void draw() {
  background(0); // draw the background 
  if (main_menu == true) { // if the game state is currently the main menu
    if (menu_music_active == false) { // if the main menu music currently isn't playing
      menu_music_active = true;
      menu_music = new SoundFile(this, sketchPath("sfx/mainMenu.wav")); // set the menu_music variables to the .wav file in the sfx folder (This will happen many times and this comment serves as universal for all the times it will occur)
      menu_music.loop(); // loop through the main menu music
    }
    image(new SpriteLoading("main_menu").getSprite(), width/2 - 256, height/2 - 180); // draw the main game logo in the center of the screen
    play_game.update();
    play_game.draw(); // these functions are to draw and check whether the mouse cursor is overtop of the button 
    if (play_game.checkStart() == true) { // if the play button is clicked
      main_menu = false;
      level_1 = true; // start the game on level 1
    }
  } else { // if the main menu game state currently is not active (meaning the game is started)
    if (game_music_active == false) { // if the game musiic currently isnt playing
      menu_music.stop(); // stop the main menu music
      game_music_active = true;
      game_music = new SoundFile(this, sketchPath("sfx/inGame.wav"));
      game_music.loop(); // loop through the game music 
    }
    image(new SpriteLoading("title").getSprite(), width/2 - 140, 5); // draw the main game logo uptop of the screen 
    setBricks(); // set the brick parameters again
    drawBricks(); // draw the bricks on the screen. Their formoation depends on what level it currently is
    if (!hasLost && !hasWon) {drawBall();} // if the game hasnt ended then draw the game ball
    drawBat(); // draw the game bat
    drawPowerup(); // if a power up is needed to be drawn then draw it on the screen
    powerupActivation(); // check the state of the power ups that need to be activated and thoose that are currently actived if they need to be decativated
    updateScore(false); // tell the update score function that the score currently does not need to be updated
    drawLivesText(); // draw the text for the lives
    drawLevelText(); // draw the text for what level it currently is untill the first brick has been broken
    if (lives == 0 ) drawLose(); // if you have no more lives left, draw that you have lost the game 
    
    if (fire_ball_active == true && hasLost == false) { // if the fire ball power up is active and the game hasn't been lost 
      if (animationFrame != fireB.length) { // if the current animation frame is within the bounds of the fireball animation 
        game_ball.setColor(color(247, 157, 11)); // change the game ball color to represent a fire ball 
        image(fireB[animationFrame], game_ball.getX(), game_ball.getY()); // draw the fireball on the current ball position 
        frameSlow += 1; // used to slow down the animation to replicate a more relaistic fire affect
        if (frameSlow == 4){ // once 4 frames have past
        animationFrame += 1; // animate the fireball by 1 frame 
        frameSlow = 0; // set frameslow back to 0
        }
      } else { // if the animation has run through completely
        animationFrame = 0; // start the animation again
      }
    } else if (fire_ball_active == false) {game_ball.setColor(color(255));} // if the fireball power up isnt active set the game ball color back to white 
    
    if (replay == true) { // if the game needs to be replayed
      replay_button.update(); // draw and update the replay button if the mouse cursor is over it 
      replay_button.draw();
      if (replay_button.checkStart() == true) { // if the replay button is clicked
        drawReplay(); // replay the game from level 1
      }
    }
  }
}

/**
* Function for when the mouse is pressed
*/
void mousePressed() { 
    if (main_menu == true) {play_game.mousePressed();} // if we are on the main menu, check if the mouse was over the play button
    else if (replay == true) {replay_button.mousePressed();} // if we arn't on the main menu, check if the mouse was over the replay button
}

/**
* Function to set the parameters for the bricks depending on what level is currently active
*/
void setBricks() { // 
  if (level_1 == true || main_menu == true) { // if level 1 or main menu is active
    NumOfRows = 3; // for each level set the layout the bricks will be in 
    NumOfBricks = 10;
    spaceBetweenBricks = 10;
    spaceFromRoof = 100; 
  } else if (level_2 == true) { // if level 2 is active
    NumOfRows = 5;
    NumOfBricks = 10;
    spaceFromRoof = 75;
  } else if (level_3 == true) { // if level 3 is active
    NumOfRows = 10;
    NumOfBricks = 10;
    spaceFromRoof = 50;
  }
}

/**
* Set up the initial layout of all of the bricks
*/
void layoutBricks() {
  for (int rowNum = 0; rowNum < NumOfRows; rowNum++) {
    for (int brickNum = 0; brickNum < NumOfBricks; brickNum++) { // lay the bricks out in columns and rows
      if (rowNum % 2 == 1) { // if the row number is even 
        brick_col = brick_cols[0]; // set the color to blue
      } else { // if the row number is odd
        brick_col = brick_cols[1]; // set the color pink
      }
      float brick_y = spaceFromRoof + (brick_h + spaceBetweenBricks) * rowNum; // set the parameter for where the brick is position on the y and x axis
      brick_x = (brick_w + spaceBetweenBricks) * brickNum;
      brickList.add(new Block(brick_x, brick_y, brick_w, brick_h, brick_col)); // add the new brick to the list of bricks to be drawn
    }
  }
}

/**
* Draw all of the bricks on screen according to the layout set
*/
void drawBricks() {
  for (int brickNum = brickList.size() - 1; brickNum >= 0; brickNum--) { // for all the bricks currently in the brick list
    Block brick = brickList.get(brickNum); // set the brick field to the current brick interated through the lisr
    brick.draw(); // draw the current brick
    if (brick.collidesWith(game_ball, fire_ball_active) || brick.collidesWith(double_ball, fire_ball_active)) { // if a ball collides with a brick
      level_message_active = false; // make sure the level message is no longer drawn
      brickList.remove(brick); // remove the brick from the list and screen
      updateScore(true); // set the score to be updated
      block_hit_sound = new SoundFile(this, sketchPath("sfx/block_hit.wav"));
      block_hit_sound.play(); // play the sfx of a brick being hit
      if (brick.powerupChance() == true) { // if the random cnahce for a power up came out as true
        createPowerup(brick.randomName(), brick.getX(), brick.getY()); // create a random power up of the possible powerups using the creating power up function 
      }
    }
  }
}

/**
* Draw the bat and have it move according to the mouses movements, and activate a power up if it is picked up by the bat
*/
void drawBat() {
  if (wide_bat_active == true) {wide_bat.draw();} // if the wide bat power up is active draw the bat as wide
  else {bat.draw();} // if it isn't active draw the normal bat
  bat.block_x = mouseX; // set the bat to follow the mouse
  bat.collidesWith(game_ball, false); // if the bat collides with the game ball or the double ball from the power up bounce it off
  bat.collidesWith(double_ball, false);
  wide_bat.block_x = mouseX; // if the wide bat is active do the same as the normal bat
  wide_bat.collidesWith(game_ball, false);
  wide_bat.collidesWith(double_ball, false);
  // if either bat collides with either ball
  if (bat.collidesWith(game_ball, false) || bat.collidesWith(double_ball, false) || wide_bat.collidesWith(game_ball, false) || wide_bat.collidesWith(double_ball, false)) {
    block_hit_sound = new SoundFile(this, sketchPath("sfx/block_hit.wav"));
    block_hit_sound.play(); // play the sfx of a brick being hit
  }
  
  if (saftey_net != null) { // if the saftey net power up is currently activated
    saftey_net.collidesWith(game_ball, false); // if the saftey net collides with either ball bounce it off
    saftey_net.collidesWith(double_ball, false);
  }
  
  if(powerup_list.isEmpty() == false) { // if there are power ups of the screen 
      for (PowerUps powerup : powerup_list) { // loop through all power ups on the screen
        if (bat.collidesWithPowerup(powerup)) { // if the power up collides with the bat 
          to_remove.add(powerup); // add it to the to remove list to take it out of the power up list (can't remove from a list whilst iterating through it)
          play_pu_sound = true; // set the variable to play the sfc for collecting a power up
        }
        else if (wide_bat.collidesWithPowerup(powerup)) { // the same as the normal bat but with the wide bat if it is active
          to_remove.add(powerup);
          play_pu_sound = true;
        }
        else if (saftey_net != null) { // the same as the normal bat but with the saftey net if it is active 
          if (saftey_net.collidesWithPowerup(powerup)) {
            to_remove.add(powerup);
            play_pu_sound = true;
          }
        } if (play_pu_sound == true) { // if the playing if the power up sound is true 
          play_pu_sound = false; // set it to false so it doesn't loop
          power_up_sound = new SoundFile(this, sketchPath("sfx/power_up.wav"));
          power_up_sound.play(); // play the sfx of collecting a power up
        }
      } 
  if(to_remove.isEmpty() == false) { // if there are power ups to remove 
    for (PowerUps toRemove : to_remove) { // loop through the ones that need to be removed 
      powerup_list.remove(toRemove); // remove the power up from the main power up list
      activated_list.add(toRemove); // add the power up to the activated list to active it 
      toRemove = null;
    } 
  } to_remove.clear(); // clear the to remove list
  }
}

/**
* Function to display a message on the screnn according to inputted parameters
*/
void displayMessage(String message, int x, int y, boolean isCentered) {
  fill(135, 206, 235); // set the color and size of the text 
  textSize(32);
  String name = message; // set the postion and string for the text
  float text_x = x;
  if (isCentered) { // if the text is to be centered 
    float text_w = textWidth(name); // line the text up with the center 
    text_x = (width-text_w)/2;
  }
  int text_y = y;
  text(name, text_x, text_y); // draw the text on the screen 
}

/**
* Draw the game ball and check its collisions with the floor 
*/
void drawBall() {
  game_ball.draw(); // draw the ball
  game_ball.update(); // update the velocity of the ball 
  if (game_ball.checkWallCollision()) { // if the ball collides with the walls bounce it off but if it collides with floor it returns true 
    lose_life_sound = new SoundFile(this, sketchPath("sfx/lose_life.wav"));
    lose_life_sound.play(); // play the sfx of losing a life 
    lives--; // take a life away
    game_ball.move(width/2, height/2); // move the ball back up to keep the game going 
  }
  if (double_ball_active == true) { // if the double ball power up is active 
    double_ball.draw(); // do the same as with the game ball but with the second double ball
    double_ball.update();
    if (double_ball.checkWallCollision()) {
      lose_life_sound = new SoundFile(this, sketchPath("sfx/lose_life.wav"));
      lose_life_sound.play();
      lives--;
      double_ball.move(width/2, height/2);
    }
  }
}

/**
* Active the power ups that were collected by the bat, and remove them once their timer is up
*/
void powerupActivation() {
    if (timer_list.isEmpty() == false) { // check if there are any active timers 
      for (Timer timer : timer_list) { // loop through all active timers
        timer.timeCount(); // advance their time by one tick
        if (timer.timeupCheck() == true) { // if the current timer's time is up
            for (PowerUps powerup : activated_list) { // loop through all power ups currently activated
              if (timer.getPowerup() == powerup) { // if the timer is for the current power up we're iterating through 
                to_remove_active.add(powerup); // add the power up to be removed from the activated list
                if (powerup.getName().equals("fire_ball")) {fire_ball_active = false;}
                if (powerup.getName().equals("double_ball")) {double_ball_active = false;} // if the power up is any of the power ups list then deactive them
                if (powerup.getName().equals("wider_platform")) {wide_bat_active = false;}
                
                if (powerup.getName().equals("saftey_net")) {saftey_net = null;}
                if (powerup.getName().equals("x2_points")) {x2_points_active = false;}
                }
              } timer_remove.add(timer); // set the timer to removed from the timer list 
            }
        }
      }
    for (PowerUps toRemove : to_remove_active) {activated_list.remove(toRemove);} // loop through all the power ups needed to be removed from the activated list and remove them
    for (Timer toRemove : timer_remove) {timer_list.remove(toRemove);}  // loop through all the timers needed to be removed from the timer list and remove them
    
    to_remove_active.clear(); // clear both the to remove lists
    timer_remove.clear();
    
    if (activated_list.isEmpty() == false) { // if there is a power up needed to be activated
      for (PowerUps activated_powerup : activated_list) { // loop through all power ups that need to be activated
        if (activated_powerup.getName().equals("double_ball")) { // if the power up is that specfic power up listed then activate it 
          double_ball_active = true;
          timer_list.add(new Timer(activated_powerup)); // set a timer for the power up where it is deactivated once the time is up
      } else if (activated_powerup.getName().equals("extra_life")) {
          lives += 1;// add a life
          to_remove_active.add(activated_powerup); // set the power up to be removed from being active 
      } else if (activated_powerup.getName().equals("saftey_net")) {
          saftey_net = new Block(0, height - 15, width, 10, color(135, 206, 235)); // set the parameters for the saftey net 
          saftey_net.draw(); // draw the saftey net 
          timer_list.add(new Timer(activated_powerup));
      } else if (activated_powerup.getName().equals("wider_platform")) {
          wide_bat_active = true;
          timer_list.add(new Timer(activated_powerup));
      } else if (activated_powerup.getName().equals("x2_points")) {
          x2_points_active = true;
          timer_list.add(new Timer(activated_powerup));
      } else if (activated_powerup.getName().equals("fire_ball")) {
          fire_ball_active = true;
          timer_list.add(new Timer(activated_powerup));
      }
      } for (PowerUps toRemove : to_remove_active) {activated_list.remove(toRemove);} // loop through all power ups needing to be removed and remove them from the activated list
    } to_remove_active.clear(); // clear the remove list
}

/**
* Draw the current power ups on the screen
*/
void drawPowerup() {
  if(powerup_list.isEmpty() == false) { // if there are power ups needed to be drawn
    for (PowerUps powerup : powerup_list) { // loop through all power ups needed to be drawn
      powerup.update(); // update the velocity of the power ups so they fall to the ground
      image(powerup.getSprite(), powerup.getX(), powerup.getY()); // draw the power up sprite where the brick it came from was 
      if (powerup.checkWallCollision()) {to_remove_floor.add(powerup);} // if the power up touches the floor remove it
    } if(to_remove_floor.isEmpty() == false) {
    for (PowerUps toRemove : to_remove_floor) { // remove the power ups that touched the floor 
      powerup_list.remove(toRemove);
      toRemove = null;
    } to_remove_floor.clear(); // clear the to remove list 
    }
  }
}

/**
* Create the power up object depending on which one needs to be created 
*/
void createPowerup(String powerup_name, float x, float y) {
  // depending on which power up needs to be activated create the object with position, name, and sprite parameters and add it to the current power ups on screen list 
    if (powerup_name.equals("double_ball")) {powerup_list.add(new PowerUps (x + 20, y, 56, new SpriteLoading("double_ball").getSprite(), powerup_name));}
    else if (powerup_name.equals("extra_life")) {powerup_list.add(new PowerUps (x + 20, y, 56, new SpriteLoading("extra_life").getSprite(), powerup_name));}
    else if (powerup_name.equals("saftey_net")) {powerup_list.add(new PowerUps (x + 20, y, 56, new SpriteLoading("saftey_net").getSprite(), powerup_name));}
    else if (powerup_name.equals("wider_platform")) {powerup_list.add(new PowerUps (x + 20, y, 56, new SpriteLoading("wider_platform").getSprite(), powerup_name));}
    else if (powerup_name.equals("x2_points")) {powerup_list.add(new PowerUps (x + 20, y, 56, new SpriteLoading("x2_points").getSprite(), powerup_name));}
    else if (powerup_name.equals("fire_ball")) {powerup_list.add(new PowerUps (x + 20, y, 56, new SpriteLoading("fire_ball").getSprite(), powerup_name));}
}

/**
* Draw that the user has lost
*/
void drawLose() {
  displayMessage("You lost!", 0, height/2, true); // display the you lost message on screen
  hasLost = true; // set the game state to the user losing
  replay = true; // set the replay button to be drawn
}

/**
* Draw that the user has won
*/
void drawWin() {
  displayMessage("You win!", 0, height/2, true); // display the you won message on screen
  hasWon = true; // set the game state to the user winning
  replay = true; // set the replay button to be drawn
}

/**
* Set the parameters needed to replay the game 
*/
void drawReplay() {
  hasWon = false; // set the parameters back to what it was when level 1 was started 
  hasLost = false;
  level_1 = true;
  replay = false;
  lives = 3;
  score = 0;
  listClear();
  setBricks();
}

/**
* Update the score for when a brick has been broken aswell as changing the level if needed
*/
void updateScore(boolean isNew) {
  if (isNew) {score += 10;} // if a brick has been broken add 10 points
  if (isNew && x2_points_active == true) {score += 10;} // if x2 points is active add another 10 points 
  message = "Score:" + score; // set the text to be put on screen with the updated score
  displayMessage(message, 5, 30, false); // draw the score text on screen 
    if (brickList.isEmpty() == true) { // if all the bricks currently on the screen have beeen broken 
      if (level_1 == true) { // if level 1 is active 
        level_1 = false;
        level_2 = true; // set level 2 to be active and level 1 not to be 
        game_ball.move(width/2, height/2); // move the balls back to the defult position
        double_ball.move(width/2, height/2);
        layoutBricks(); // layout the bricks 
        level_message_active = true;
        level_message = "Level 1"; // set the message to be displayed of what level is currently active 
        level_up_sound = new SoundFile(this, sketchPath("sfx/level_up.wav"));
        level_up_sound.play(); // play the sfx of leveling up
        return; // return out of this method 
      } else if (level_2 == true) { // if level 2 is active 
        level_2 = false; // do the same as what was done in level 1 for the level 2 layout 
        level_3 = true;
        game_ball.move(width/2, height/2);
        double_ball.move(width/2, height/2);
        layoutBricks();
        level_message_active = true;
        level_message = "Level 2";
        level_up_sound = new SoundFile(this, sketchPath("sfx/level_up.wav"));
        level_up_sound.play();
        return;
      } else if (level_3 == true) { // if level 3 is active 
        level_3 = false; // do the same as what was done in level 1 for the level 3 layout 
        game_won = true;
        game_ball.move(width/2, height/2);
        double_ball.move(width/2, height/2);
        layoutBricks();
        level_message_active = true;
        level_message = "Level 3";
        level_up_sound = new SoundFile(this, sketchPath("sfx/level_up.wav"));
        level_up_sound.play();
        return;
      } else if (game_won == true) {drawWin();} // if the game has been won draw the game won state 
  }
}

/**
* Check if a life needs to be taken away 
*/
void livesCheck() {
  if (game_ball.ball_y + game_ball.ball_w == height) { // if the ball has collided with the floor 
    lives--; // remove a life
  }
  drawLivesText(); // update the life text with the new life amount 
}

/**
* Draw the current number of lives on the screen 
*/
void drawLivesText() {
  message = "Lives: " + lives; // set the text to be displayed
  displayMessage(message, ((int)(width-textWidth(message)) - 5), 30, false); // draw the amount of lives in the top corner of the screen
}

/**
* Draw the current level on the screen
*/
void drawLevelText() {
  // if the current level needs to be drawn then draw it in the center of the screen
  if (level_message_active == true && hasLost == false && hasWon == false) {displayMessage(level_message, 0, height/2, true);}
}

/**
* Clear all list of the program aswell as setting all power ups to deactive used to reset the game 
*/
void listClear() {
  brickList.clear(); // clearing all lists 
  powerup_list.clear();
  activated_list.clear();
  to_remove.clear();
  to_remove_active.clear();
  to_remove_floor.clear();
  activated_list.clear();
  timer_list.clear();
  timer_remove.clear();
  double_ball_active = false; // setting all power ups to deactivate 
  wide_bat_active = false;
  x2_points_active = false;
  saftey_net = null;
}

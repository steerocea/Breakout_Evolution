/**
* Class for the button objects used in game 
*/
class Button {
  // fields for the button variables
  int button_x;
  int button_y;
  int button_w;
  int button_h;
  int button_c;
  String button_text;
  boolean rectOver = false; // whether the mouse cursor is over the rectangle button
  boolean button_activate = false; // whether the button is to be activated or not
  
  /**
  * Constructor for button
  */
  Button(int x, int y, int w, int h, int c, String text) {
    button_x = x;
    button_y = y;
    button_w = w;
    button_h = h;
    button_c = c;
    button_text = text;
  }
  
  /**
  * Used to draw the button on the screen
  */
  void draw() {
    stroke(255); // outline of button 
    if (rectOver) {fill(color(255, 105, 180));} // if the mouse is over the button set the color to pink 
    else {fill(color(135, 206, 235));} // if the mouse is not over the button set the color to blue 
    rect(button_x, button_y, button_w, button_h, button_c); // draw button rectangle
    if (button_text.equals("PLAY")) {image(new SpriteLoading("play").getSprite(), button_x + 25, button_y + 15);} // if the button is the play button draw the sprite with the play text
    else if (button_text.equals("REPLAY")) {image(new SpriteLoading("replay").getSprite(), button_x + 10, button_y + 15);}  // if the button is the replay button draw the sprite with the replay text
    
  }
  
  /**
  * Update whether the mouse cursor is over the button of not 
  */
  void update() {
   if (overRect(button_x, button_y, button_w, button_h)) {rectOver = true;}
   else {rectOver = false;}
  }
  
  /**
  * If the mouse is pressed whilst the mouse cursor is over the button then activate the button 
  */
  void mousePressed() {
    if (rectOver == true) {button_activate = true;}
    else {button_activate = false;}
  }
  
  /** 
  * Check whether the button needs to be activated and return true if so 
  */
  boolean checkStart() {
    if (button_activate == true) {
      button_activate = false;
      return true;
    }
    else {return false;}
  }
  
  /**
  * Check whether the position of the mouse cursor is within the position of the button and return true if so 
  */
  boolean overRect(int x, int y, int w, int h) {
    if(mouseX >= x && mouseX <= x+w &&
      mouseY >= y && mouseY <= y+h) {
        return true;
    } else {return false;}
  }
  
  /**
  * Return if the mouse cursor is over the button of not, true if so
  */
  boolean getRectOver() {return rectOver;}
}

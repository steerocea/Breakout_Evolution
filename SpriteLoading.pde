/**
* Class to load all the sprites used in game 
*/
class SpriteLoading {
  // field for the name of the power up
  String name;
      
  /**
  * Constructor to load the sprite
  */
  SpriteLoading(String sp_name) {
    name = sp_name;
  }
  
  /**
  * Return the PImage corresponding to the name inputted, loaded from the sprites folder 
  */
  PImage getSprite() {
    if (name.equals("title")) {return loadImage("sprites/title_sprite.png");} // load the sprite based on what name is entered
    if (name.equals("main_menu")) {return loadImage("sprites/main_menu.png");}
    if (name.equals("play")) {return loadImage("sprites/play_text.png");}
    if (name.equals("replay")) {return loadImage("sprites/replay_text.png");}
    if (name.equals("double_ball")) {return loadImage("sprites/double_ball_pu.png");}
    if (name.equals("extra_life")) {return loadImage("sprites/extra_life_pu.png");}
    if (name.equals("fire_ball")) {return loadImage("sprites/fire_ball_pu.png");}
    if (name.equals("saftey_net")) {return loadImage("sprites/saftey_net_pu.png");}
    if (name.equals("wider_platform")) {return loadImage("sprites/wider_platform_pu.png");}
    if (name.equals("x2_points")) {return loadImage("sprites/x2_points_pu.png");}
    if (name.equals("fire_ball_sheet")) {return loadImage("sprites/fire_ball_sprite_sheet.png");}
    else {return null;} // if no name is entered return null
  }
}

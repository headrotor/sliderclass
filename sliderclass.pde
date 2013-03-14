/**  Slider and Button classes
 
 Based on http://forum.processing.org/topic/vertical-scrollbar#25080000001583409
 By "raron"
 
 Made JS-safe by renaming "over()" function, which can't be the same as boolean variable "over"
 
 Built on Topics/GUI/Scrollbar example in processing 1.2.1 (and 1.5.1).
 
 */


class ColorScheme {

  color bar_outline = color(0, 0, 0);
  color slider_fill  = color(100, 100, 100);
  color bar_hover = color(100, 200, 200);
  color bar_background = color(0, 150, 200);
  color slider_press = color(255, 255, 255);
}

/* global colorscheme, change colors above */
/* to change instance colors, subclass and overwrite */
ColorScheme global_cs = new ColorScheme();



class VSlider
{
  int barWidth, barHeight; // width and height of bar. NOTE: barWidth also used as slider button height.
  int Xpos, Ypos;          // upper-left position of bar
  float Spos, newSpos;     // y (upper) position of slider
  int SposMin, SposMax;    // max and min values of slider
  boolean over;            // True if hovering over the Slider
  boolean locked;          // True if a mouse button is pressed while on the Slider
  int roundRad = 5;             // radius of rounded rectangle for thumb

  ColorScheme cs = global_cs;
  color barOutlineCol  = cs.bar_outline;
  color barFillCol     = cs.bar_background;
  color sliderFillCol  = cs.slider_fill;
  color barHoverCol    = cs.bar_hover;
  color sliderPressCol = cs.slider_press;


  VSlider (int X_start, int Y_start, int bar_width, int bar_height) {
    barWidth = bar_width;
    barHeight = bar_height;

    Xpos = X_start;
    Ypos = Y_start;
    Spos = Ypos + barHeight/2 - barWidth/2; // center it initially
    newSpos = Spos;
    SposMin = Ypos;
    SposMax = Ypos + barHeight - barWidth;
  }

  void update() {
    over = overit();
    if (mousePressed && over) locked = true; 
    else locked = false;

    if (locked) {
      newSpos = constrain(mouseY-barWidth/2, SposMin, SposMax);
    }
    Spos = newSpos;
  }

  // Return true if mouse is over thumb of slider
  boolean overit() {
    if (mouseX > Xpos && mouseX < Xpos+barWidth &&
      mouseY > Ypos && mouseY < Ypos+barHeight) {
      return true;
    } 
    else {
      return false;
    }
  }


  void display() {
    stroke(barOutlineCol);
    fill(barFillCol);
    rect(Xpos, Ypos, barWidth, barHeight);
    if (over) {
      fill(barHoverCol);
    }
    if (locked) {
      fill(sliderPressCol);
    }
    if (!over && !locked) {
      fill (sliderFillCol);
    }
    if (abs(Spos-newSpos)>0.1) fill (sliderPressCol);
    rect(Xpos, Spos, barWidth, barWidth,roundRad);
  }

  float getValue() {
    // Convert slider position Spos to a value between 0 and 1
    return (Spos-Ypos) / (barHeight-barWidth);
  }

  // set the value of this slider
  void setValue(float value) {
    // convert a value (0 to 1) to slider position Spos
    if (value<0) value=0.0;
    if (value>1) value=1.0;
    Spos = Ypos + ((barHeight-barWidth)*value);
    newSpos = Spos;
  }
}


class HSlider extends VSlider {
  HSlider(int X_start, int Y_start, int bar_width, int bar_height) {
    super(X_start, Y_start, bar_width, bar_height);
    SposMin = Xpos;
    SposMax = Xpos - barHeight + barWidth;
  }

  // call this to interactively update slider in display()
  void update() {
    over = overit();
    if (mousePressed && over) locked = true; 
    else locked = false;

    if (locked) {
      //newSpos = constrain(mouseX- int(barHeight/2), SposMin, SposMax);
      //newSpos = mouseX - int(barHeight/2);
      newSpos = constrain(mouseX - int(barHeight/2), SposMin, SposMax);
    }
    Spos = newSpos;
  }

  // Call this to draw the slider in display() routine
  void display() {
    stroke(barOutlineCol);
    fill(barFillCol);
    // Draw the slider bar
    rect(Xpos, Ypos, barWidth, barHeight);
    if (over) {
      fill(barHoverCol);
    }
    if (locked) {
      fill(sliderPressCol);
    }
    if (!over && !locked) {
      fill (sliderFillCol);
    }
    // Draw the thumb
    if (abs(Spos-newSpos)>0.1) fill (sliderPressCol);
    rect(Spos, Ypos, barHeight, barHeight,roundRad);
  }

  float getValue() {
    // Convert slider position Spos to a value between 0 and 1
    return (Spos-Xpos) / (barWidth - barHeight);
  }

  // set the value of this slider
  void setValue(float value) {
    // convert a value (0 to 1) to slider position Spos
    if (value<0) value=0.0;
    if (value>1) value=1.0;
    Spos = Xpos + ((barWidth-barHeight)*value);
    newSpos = Spos;
  }
}


/**  Button class
 
 Highly modified from processing 1.2.1 Buttons class example
*/
public class Button
{
  int x, y;
  int size;
  ColorScheme cs = global_cs;
  color edgeCol = cs.bar_outline;
  color baseColor = cs.bar_background;
  color highlightColor = cs.slider_press;
  color hoverColor = cs.bar_hover;
  color currentColor = cs.slider_press;
  boolean pressed = false;  
  boolean oldPressed = false;
  boolean outsidePressed = false;

  // must call this in display() to update button
  void update()
  {
    if (over()) {
      currentColor = hoverColor;
      if (mousePressed && !oldPressed && !outsidePressed) {
        pressed = true;
        currentColor = highlightColor;
      }
      if (!mousePressed) {
        oldPressed = pressed;
        pressed = false;
        outsidePressed = false;
      }
    } 
    else {
      currentColor = baseColor;
      pressed = false;
      outsidePressed = mousePressed;
    }
  }

  boolean clicked() {
    return oldPressed;
  }

  boolean over() {
    return false;
  }
}


// Subclass for circular buttons
class CircleButton extends Button
{
  CircleButton(int ix, int iy, int isize) {
    x = ix;
    y = iy;
    size = isize;
  }

  // Return True if mouse is over the button
  boolean over() {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < size/2 ) {
      return true;
    } 
    else return false;
  }

  void display() {
    stroke(edgeCol);
    fill(currentColor);
    ellipse(x, y, size, size);
  }
}


class RectButton extends Button
{
  RectButton(int ix, int iy, int isize) {
    x = ix;
    y = iy;
    size = isize;
  }

  // Return True if mouse is over the button
  boolean over() {
    if (mouseX >= x && mouseX <= x+size &&
      mouseY >= y && mouseY <= y+size) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display() {
    stroke(edgeCol);
    fill(currentColor);
    rect(x, y, size, size);
  }
}

// nicer button with rounded ends
class NiceButton extends Button
{
  String lab;
  int xs, ys; // x and y size of display rect
  float tw, th; // text width and height
  int pad = 5; // pixels to pad text
  NiceButton(int ix, int iy, int xsize, int ysize, String label) {
    x = ix;
    y = iy;
    xs = xsize;
    ys = ysize;
    // compute size of inner rectangle and outer arcs
    int rx = x;
    setLabel(label);
  }

  void setLabel(String labString) {
    lab = labString; 
    th = textAscent();
    if (th < ys) {
      ys = int(th) + 2*pad;
    }
    tw = textWidth(lab);
    //th = textHeight(label);
    if (xs < tw) {
      xs = int(tw)+ 2 * pad;
    }
  }
  // Return True if mouse is over the button
  boolean over() {
    if (mouseX >= x && mouseX <= x+xs &&
      mouseY >= y && mouseY <= y+ys) {
      return true;
    } 
    else {
      return false;
    }
  }

  void display() {
    stroke(edgeCol);
    fill(currentColor);
    rect(x, y, xs, ys,5);
    fill(edgeCol);
    text(lab, x + pad, y + ys/2 + th/2);
  }
}


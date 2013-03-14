/**   
 
 Test slider class
 
 Adapted from orginal "Scrollbar 0.12" by  "raron"  2012.05.08 
 http://forum.processing.org/topic/vertical-scrollbar
 
 contribution from jtf@rotormind.com: made js-safe
 added label methods
 
 */

// Nr. of test controls of each type
int bars = 4;

// Sliders and buttons
VSlider Vslider [];
HSlider Hslider [];
CircleButton oButton [];
NiceButton xButton [];

void setup()
{
  size  (400, 400);
  smooth();

  // The Sliders (or sliders) and buttons array initialization
  Vslider = new VSlider[bars];
  Hslider = new HSlider[bars];
  xButton = new NiceButton[bars];

  // The Sliders (or sliders) and buttons array instantiation
  for (int i=0; i<bars; i++) {
    Vslider[i] = new VSlider(10+i*30, 40, 16, 200);
    Hslider[i] = new HSlider(10, 270+i*30, 250, 16);
    xButton[i] = new NiceButton(bars*20+70-(bars+4), 40+i*30, 20, 30, "label");
  }

  // relabel buttons if you want to (you can do this any time)
  xButton[0].setLabel("First");
  xButton[1].setLabel("A button with a long label");
  xButton[2].setLabel("Slider Min");
  xButton[3].setLabel("Slider Max");

  // Set some initial slider values for fun
  for (int i=0; i<bars; i++) {
    Vslider[i].setValue(1-0.66*cos((float)(i+1)/(bars*4)*2*PI));
    Hslider[i].setValue(0.78*sin((float)(bars-i)/(bars*4)*2*PI));
  }
}

void draw()
{

  // only need to repaint background because of changing text; the buttons and 
  // sliders repaint themselves
  background(192, 192, 192);

  fill(0, 0, 0);
  text("Slider and NiceButton test by jtf@rotormind.com", 10, 15);

  if (xButton[2].clicked() == true) {
    Hslider[0].setValue(0);
    Vslider[0].setValue(0);
  }

  if (xButton[3].clicked() == true) {
    Hslider[0].setValue(1);
    Vslider[0].setValue(1);
  }

  for (int i=0; i<bars; i++) {
    if (xButton[i].clicked() == true) println("Nice Button " + i + " clicked!");

    // Write only the horizontal slider values
    text("Hs " + i + ": " + Hslider[i].getValue(), 265, 285+i*30);

    // Sliders/sliders and buttons updates and displaying
    Vslider[i].update();
    Vslider[i].display();

    Hslider[i].update();
    Hslider[i].display();

    xButton[i].update();
    xButton[i].display();
  }
}


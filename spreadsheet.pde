import peasy.*;
import shapes3d.utils.*;
import shapes3d.utils.Picked;
import shapes3d.*;
import java.util.ArrayList;

PeasyCam cam;

String[] lines;
ArrayList<String> headers = new ArrayList<String>();
ArrayList<String> label = new ArrayList<String>();
ArrayList<Integer> posX = new ArrayList<Integer>();
ArrayList<Integer> posY = new ArrayList<Integer>();
ArrayList<Integer> posZ = new ArrayList<Integer>();
ArrayList<Integer> group = new ArrayList<Integer>();
ArrayList<Integer> birthYear = new ArrayList<Integer>();
ArrayList<Integer> grade = new ArrayList<Integer>();
ArrayList<String> gender = new ArrayList<String>();
ArrayList<Boolean> solids = new ArrayList<Boolean>();
ArrayList<Boolean> wireFrames = new ArrayList<Boolean>();

ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Shape> savedShapes = new ArrayList<Shape>();
ArrayList<Shape> copyShapes = new ArrayList<Shape>();

ArrayList<Features> features = new ArrayList<Features>();
ArrayList<Features> savedFeatures = new ArrayList<Features>();
ArrayList<Features> copyFeatures = new ArrayList<Features>();

PGraphics pg;
PImage wireFrameImage, solidImage, save, inputFile, 
FileName, TextInput, confirmDeny, Keys, Keybinds, NotBound, Bound;

// File Name
String namedFile = ""; // No File Name.

// Image bools in int form
int inverted = 0;

// Amount of saved shapes
int entries = 0;

// Proper bools
boolean selectFileInput = false, copied = false, saveInputFile = false;

//Font
PFont myFont;

// Picked Shape.
Picked picked = null;

// Number of objects
int objects;

// Age calculator
int oldestAge = 0;
int youngestAge = 0;
int midAge = 0;

/*Print Writer*/
PrintWriter output;

void setup()
{
  size(1920, 1080, P3D);
  pg = createGraphics(width, 1100, P3D);
  cam = new PeasyCam(this, pg, 500,1100/2,0,1000);

  // Text Font
  myFont = loadFont("ArialMT-48.vlw");
  textFont(myFont);

  // UI Buttons
  wireFrameImage = loadImage("data/WireFrameDisabled.png");
  solidImage = loadImage("data/SolidDisabled.png");
  save = loadImage("data/Save.png");
  inputFile = loadImage("data/InputFile.png");
  Keys = loadImage("data/Keys.png");
  Keybinds = loadImage("data/Keybinds.png");

  // UI Text Feature
  TextInput = loadImage("data/TextInput.png");
  FileName = loadImage("data/FileName.png");
  confirmDeny = loadImage("data/ConfirmOrReject.png");

  // Camera setup
  cam.setDistance(1800);
  cam.setMaximumDistance(2500);
  cam.rotateY(radians(0));
  cam.rotateX(radians(10));
  cam.lookAt(0,700,0);
  cam.setSuppressRollRotationMode();
   
  smooth();
}

void draw()
{
  pg.beginDraw();
  pg.background(255);
  pg.lights();
  displayGraph();

  // If a user selects a button, it'll swap all shapes to be that feature.
  for (int i = 0; i < objects; i++)
  {
    shapes.get(i).shapeColour = features.get(i).getColour(shapes.get(i).selected);
    shapes.get(i).display();
    pg.textSize(17);
    pg.textAlign(CENTER);
    pg.text(shapes.get(i).label, shapes.get(i).posX, shapes.get(i).posY+20+shapes.get(i).size, shapes.get(i).posZ);
  } 

  cam.getState().apply(pg);
  pg.endDraw();
  image(pg, 0, 0);
  
  // UI for buttons
  image(solidImage, 0, 0);
  image(wireFrameImage, 100, 0);
  image(inputFile, 1720, 0);
  image(save, 1820, 0);

  for (Shape s : shapes)
  {
    if (keyCode == ALT && s.selected == true)
    {
      cam.setActive(false);

      s.posX += mouseX - pmouseX;

      if (inverted == 1)
      {
        s.posZ += mouseY - pmouseY;
      }
      if (inverted == 0)
      {
        s.posY += mouseY - pmouseY;
      }

      s.posX = constrain(shape.posX, 0, 1000);
      s.posY = constrain(shape.posY, 0, 1000);
      s.posZ = constrain(shape.posZ, 0, 1000);
    }
  }

  // When a user is saving a file, it'll prompt them with this.
  if (saveInputFile == true)
  {
    // Image for visuals.
    image(FileName, 840, 300);
    image(TextInput, 840, 400);
    image(confirmDeny, 840, 500);
    textSize(30);
    // Checks if there is data in the string.
    if (namedFile == null)
    {
      text("Start Typing...", 850, 460);
    }
    else
    {
      // If not, checks if its reached the limit.
      if (namedFile.length() < 26)
      {
        // If not, it prints what the user has typed.
       text(namedFile, 850, 460);
      }
      // If it has, it'll print that it has too many characters.
      if (namedFile.length() > 26)
      {
        text("Too many characters", 8, 460);
      }
    }
  }

  // An image for the keybinds.
  image(Keybinds, 0, 100);

  // If a user hovers over the keybinds, it'll show the keys attached. 
  if (mouseX > 0 && mouseX < 100 && mouseY > 100 && mouseY < 200)
  {
    image(Keys, 0, 200);
  }
}

void mouseClicked()
{
  // If a user picks a shape, this will record it.
  picked = Shape3D.pick(this, pg, mouseX, mouseY);

  // Switches between bools when the button is pressed.
  if (mouseX > 0 && mouseX < 100 && mouseY > 0 && mouseY < 100)
  {
    for (Shape s : shapes)
    {
      if (s.solid == false)
      {
        s.solid = true;
        solidImage = loadImage("data/SolidEnabled.png");
      }
      else
      {
        s.solid = false;
        solidImage = loadImage("data/SolidDisabled.png");
      }
      s.resetShapes = true;
    }
  }

  // Switches between bools when the button is pressed.
  if (mouseX > 100 && mouseX < 200 && mouseY > 0 && mouseY < 100)
  {
    for (Shape s : shapes)
    {
      if (s.wireFrame == false)
      {
        s.wireFrame = true;
        wireFrameImage = loadImage("data/WireFrameEnabled.png");
      }
      else
      {
        s.wireFrame = false;
        wireFrameImage = loadImage("data/WireFrameDisabled.png");
      }
      s.resetShapes = true;
    }
  }
  
  if (mouseX > 1720 && mouseX < 1820 && mouseY > 0 && mouseY < 100)
  {
    // Enables the user to input a file, prompting them.
    selectInput("Select a file to process:", "fileSelected");
  }

  // Switches between bools when the button is pressed.
  if (mouseX > 1820 && mouseX < 1920 && mouseY > 0 && mouseY < 100)
  {
    if (saveInputFile == false)
    {
      saveInputFile = true;
      cam.setActive(false);
    }
    else if (saveInputFile == true)
    {
      saveInputFile = false;
      cam.setActive(true);
    }
  }

  // Switches between bools when the button is pressed.
  if (saveInputFile == true) 
  {
    if (mouseX > 920 && mouseX < 1120 && mouseY > 500 && mouseY < 600 || keyCode == ENTER) // Confirm
    {
      // Returns if the namedFile has nothing.
      if (namedFile == "")
      {
        return;
      }
      // Else writes the contents to the file namedFile.
      namedFile = namedFile + ".csv";
      output = createWriter(namedFile); // Creates an output printwriter.
      saveFile();
      namedFile = "";
    }

    if (mouseX > 1120 && mouseX < 1320 && mouseY > 500 && mouseY < 600) // Reject
    {
      namedFile = "";
    }
  }

  if (picked != null)
  {
    // Reset keycode if no key is being pressed.
    if (keyPressed == false)
    {
      keyCode = 0;
    }

    // If the user is not selecting ctrl, reset all selected.
    if (keyCode != 17)
    {
      for (Shape s : shapes)
      {
        s.selected = false;
      }
    }

    // Check for the shape, and make it selected.
    for (Shape s : shapes)
    {
      if (s.shape == picked.shape)
      {
        s.selected = true;
      }
    }
  }
}

void keyPressed()
{
  // Moving the shapes, if they're selected.
  if (key == 'u' && saveInputFile == false)
  {
    for (Shape s : shapes)
    {
      if (s.selected == true)
      {
        s.grade++;
        s.size = 5 + shape.grade * 3;
        s.resetShapes = true;
        s.grade = constrain(shape.grade, 0, 30);
      }
    }
    key = 0;
  }
    
  if (key == 'd' && saveInputFile == false)
  {
    for (Shape s : shapes)
    {
      if (s.selected == true)
      {
        s.grade--;
        s.size = 5 + (shape.grade * 3);
        s.resetShapes = true;
        s.grade = constrain(shape.grade, 0, 30);
      }
    }
    key = 0;
  }

  if (key == 'z' && saveInputFile == false)
  {
    // Add the data to the shape.
    if (entries != 0)
    {
      shapes.add(objects-1, savedShapes.get(savedShapes.size()-1));
      features.add(objects-1, savedFeatures.get(savedFeatures.size()-1));
      savedShapes.remove(savedShapes.size()-1);
      savedFeatures.remove(savedFeatures.size()-1);
      objects++;
      entries--;
    }
  }

    // Priming it from 'c'
    if (key == 'c' && copied == false)
    {
      copied = true;
      for (int i = 0; i < objects; i++)
      {
        if (shapes.get(i).selected == true)
        {
          copyShapes.add(shapes.get(i));
          copyFeatures.add(features.get(i));
        }
      }
    }

    // Pasting it to 'v'
    if (key == 'v' && copied == true)
    {
      copied = false;
      for (Shape s : copyShapes) {
        Shape newShape = new Shape(
          s.posX,
          1000 - s.posY - s.grade * 10,
          s.posZ,
          s.type,
          s.birthYear,
          s.grade,
          s.label,
          s.gender
        );
          shapes.add(newShape);
          features.add(new Features(s.birthYear));
          objects++;
        }
        copyShapes.clear();
      }
  
  if (key == 'i')
    {
      switch(inverted)
      {
        case 0:
        inverted = 1;
        break;
        case 1:
        inverted = 0;
        break;
      }
    }
  
  // When the user backspaces, delete a char.
  if (saveInputFile == true && keyCode == BACKSPACE && namedFile != "")
  {
    StringBuilder namedFileTemp = new StringBuilder(namedFile);
    namedFileTemp.deleteCharAt(namedFile.length()-1);
    namedFile = namedFileTemp.toString();
    return;
  }
  
  // If the user backspaces normally, delete the shape.
  if (saveInputFile == false && keyCode == BACKSPACE)
  {
    for (int i = 0; i < objects; i++)
    {
      if (shapes.get(i).selected == true)
      {
        entries++;
        savedShapes.add(shapes.get(i));
        savedFeatures.add(features.get(i));
        objects--;

        int j = i;

        while(j != objects)
        {
          shapes.set(j, shapes.get(j+1));
          features.set(j, features.get(j+1));
          j++;
        }

        shapes.remove(objects);

        i = 0;
      }
    }
  }

  // Add to the string what the user has typed
  if (saveInputFile == true)
  {
    if (namedFile == null)
    {
      namedFile = str(key);
    }
    else
    {
      if (namedFile.length() < 28)
      {
        if (key != ' ' && keyCode != 20)
        {
          namedFile = namedFile + key;
        }
      }
    }
  }
}

void keyReleased() 
{
  keyCode = ' ';
  key = ' ';  
  cam.setActive(true);
}

import peasy.*;
import shapes3d.utils.*;
import shapes3d.utils.Picked;
import shapes3d.*;
import java.util.ArrayList;

// Camera used throughout program.
PeasyCam cam;

// Lines to store the file we extract from.
String[] lines;

// Arraylists used to store values in assign2data.csv
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

// Shapes
ArrayList<Shape> shapes = new ArrayList<Shape>();
ArrayList<Shape> savedShapes = new ArrayList<Shape>();
ArrayList<Shape> copyShapes = new ArrayList<Shape>();

// Features
ArrayList<Features> features = new ArrayList<Features>();
ArrayList<Features> savedFeatures = new ArrayList<Features>();
ArrayList<Features> copyFeatures = new ArrayList<Features>();

// UI
PGraphics pg;
// wireFrame0, wireFrame1, solid0, solid1,
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
PFont font;

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
  cam.rotateY(radians(10));
  cam.rotateX(radians(0));
  cam.lookAt(170,700,0);
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

  for (Shape shape : shapes)
  {
    if (keyCode == ALT && shape.selected == true)
    {
      cam.setActive(false);

      shape.posX += mouseX - pmouseX;

      if (inverted == 1)
      {
        shape.posZ += mouseY - pmouseY;
      }
      if (inverted == 0)
      {
        shape.posY += mouseY - pmouseY;
      }

      shape.posX = constrain(shape.posX, 0, 1000);
      shape.posY = constrain(shape.posY, 0, 1000);
      shape.posZ = constrain(shape.posZ, 0, 1000);
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
      if (namedFile.length() < 28)
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
    for (Shape shape : shapes)
    {
      if (shape.solid == false)
      {
        shape.solid = true;
        solidImage = loadImage("data/SolidEnabled.png");
      }
      else
      {
        shape.solid = false;
        solidImage = loadImage("data/SolidDisabled.png");
      }
      shape.resetShapes = true;
    }
  }

  // Switches between bools when the button is pressed.
  if (mouseX > 100 && mouseX < 200 && mouseY > 0 && mouseY < 100)
  {
    for (Shape shape : shapes)
    {
      if (shape.wireFrame == false)
      {
        shape.wireFrame = true;
        wireFrameImage = loadImage("data/WireFrameEnabled.png");
      }
      else
      {
        shape.wireFrame = false;
        wireFrameImage = loadImage("data/WireFrameDisabled.png");
      }
      shape.resetShapes = true;
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
      for (Shape shape : shapes)
      {
        shape.selected = false;
      }
    }

    // Check for the shape, and make it selected.
    for (Shape shape : shapes)
    {
      if (shape.shape == picked.shape)
      {
        shape.selected = true;
      }
    }
  }
}

void keyPressed()
{
  // Moving the shapes, if they're selected.
  if (key == 'u' && saveInputFile == false)
  {
    for (Shape shape : shapes)
    {
      if (shape.selected == true)
      {
        shape.grade++;
        shape.size = 5 + shape.grade * 3;
        shape.resetShapes = true;
        shape.grade = constrain(shape.grade, 0, 30);
      }
    }
    key = 0;
  }
    
  if (key == 'd' && saveInputFile == false)
  {
    for (Shape shape : shapes)
    {
      if (shape.selected == true)
      {
        shape.grade--;
        shape.size = 5 + (shape.grade * 3);
        shape.resetShapes = true;
        shape.grade = constrain(shape.grade, 0, 30);
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

    if (key == 'v' && copied == true)
    {
      copied = false;
      for (Shape copyShapes : copyShapes)
      {
        // Recreate it, properly do it so the arraylist doesn't get confused and remove duplicates.
        posX.add(copyShapes.posX);
        posY.add(1000-copyShapes.posY-copyShapes.grade*10);
        posZ.add(copyShapes.posZ);
        group.add(copyShapes.type);
        birthYear.add(copyShapes.birthYear);
        grade.add(copyShapes.grade);
        label.add(copyShapes.label);
        gender.add(copyShapes.gender);

        shapes.add(new Shape(posX.get(objects), posY.get(objects), posZ.get(objects), group.get(objects), birthYear.get(objects), grade.get(objects), label.get(objects), gender.get(objects)));
        features.add(new Features(copyShapes.birthYear));

        objects++;
      }   

      for (int i = copyShapes.size(); i > 0; i--)
      {
        copyShapes.remove(i-1);
      }
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

void fileSelected(File file) 
{
  if (file == null)
  {
    println("No file found, or the user has exited");
  }
  else
  {
    lines = loadStrings(file);
    objects = lines.length-1;
    processFile();
  }
}

void displayGraph()
{
  pg.stroke(color(255,0,0));
  pg.strokeWeight(2);
  pg.beginShape(SHAPE);
  pg.vertex(0, 0, 0);
  pg.vertex(0, 1000, 0);
  pg.endShape();
  pg.beginShape(SHAPE);
  pg.vertex(0, 1000, 0);
  pg.vertex(0, 1000, 1000);
  pg.endShape();
  pg.beginShape(SHAPE);
  pg.vertex(0, 1000, 0);
  pg.vertex(1000, 1000, 0);
  pg.endShape();
  //Axis text
  pg.pushMatrix();
  float[] rotations = cam.getRotations();
  for (int i = 0; i < 1000; i+= 200){
    pg.fill(color(255,0,0));
    pg.pushMatrix();
    pg.noLights();
    pg.translate(10,i+10,0);
    pg.rotateX(rotations[0]);
    pg.rotateY(rotations[1]);
    pg.rotateZ(rotations[2]);
    pg.textSize((float)(cam.getDistance()/60));
    pg.text(1000-i, 0, 0, 0);
    pg.popMatrix();
    
    pg.pushMatrix();
    pg.translate(i+150, 980,0);
    pg.rotateX(rotations[0]);
    pg.rotateY(rotations[1]);
    pg.rotateZ(rotations[2]);
    pg.textSize((float)(cam.getDistance()/60));
    pg.text(i+200, 0, 0, 0);
    pg.popMatrix();
    
    pg.pushMatrix();
    pg.translate(-50, 980, i+150);
    pg.rotateX(rotations[0]);
    pg.rotateY(rotations[1]);
    pg.rotateZ(rotations[2]);
    pg.textSize((float)(cam.getDistance()/60));
    pg.text(i+200, 0, 0, 0);
    pg.lights();
    pg.popMatrix();
  }
  pg.popMatrix();
}
void processFile()
{
  // Clears all ArrayList.
  headers.clear();
  label.clear();
  posX.clear();
  posY.clear();
  posZ.clear();
  group.clear();
  birthYear.clear();
  grade.clear();
  gender.clear();
  solids.clear();
  wireFrames.clear();
  shapes.clear();
  savedShapes.clear();
  copyShapes.clear();
  features.clear();
  savedFeatures.clear();
  copyFeatures.clear();

  String[] headerData = splitTokens(lines[0], ",");
  for (int i = 0; i < headerData.length; i++) {
    headers.add(headerData[i]);
  }
  //Handles getting data from assign1data.csv and assigning it to arrays
  if (headers.contains("solid") == false)
  {
    headers.add("solid");
  }

  if (headers.contains("wireFrame") == false)
  {
    headers.add("wireFrame");
  }

  for (int i = 1; i < lines.length; i++) // Starting at 1 to remove the header row from the object arrays.
  {
    String[] infoBit = splitTokens(lines[i], ",");
    for (int j = 0; j < infoBit.length; j++) {
      if (headers.get(j).equals("Name"))
      {
        label.add(infoBit[j]);
        continue;
      }
      if (headers.get(j).equals("X")) 
      {
        posX.add(Integer.parseInt(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("Y")) 
      {
        posY.add(Integer.parseInt(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("Z")) 
      {
        posZ.add(Integer.parseInt(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("Group")) 
      {
        group.add(Integer.parseInt(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("Year of Birth")) 
      {
        birthYear.add(Integer.parseInt(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("Grade")) 
      {
        grade.add(Integer.parseInt(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("Gender")) 
      {
        gender.add(infoBit[j]);
        continue;
      }
      if (headers.get(j).equals("solid"))
      {
        solids.add(parseBoolean(infoBit[j]));
        continue;
      }
      if (headers.get(j).equals("wireFrame"))
      {
        wireFrames.add(parseBoolean(infoBit[j]));
        continue;
      }
    }
  }


  for (int i = 0; i < objects; i++)
  {
    if (solids.size() != objects)
    {
      solids.add(false);
    }
    if (wireFrames.size() != objects)
    {
      wireFrames.add(false);
    }
  }

  for (int i = 0; i < objects; i++)
  {
    shapes.add(new Shape(posX.get(i), posY.get(i), posZ.get(i), group.get(i), birthYear.get(i), grade.get(i), label.get(i), gender.get(i)));
    features.add(new Features(birthYear.get(i)));
    //Calculates the age in order to calculate the colours that is associated with the birth year 
    
    if (solids.size() == objects)
    shapes.get(i).solid = solids.get(i);

    if (wireFrames.size() == objects)
    shapes.get(i).wireFrame = wireFrames.get(i);

    if (birthYear.get(i) > oldestAge) 
    {
      oldestAge = birthYear.get(i);
    }
    youngestAge = birthYear.get(0);
    if (birthYear.get(i) < youngestAge) 
    {
      youngestAge = birthYear.get(i);
    }
    midAge = oldestAge - (oldestAge - youngestAge)/2;
  }

  if (solids.get(0) == true)
  {
    solidImage = loadImage("data/SolidEnabled.png");
  }

  if (wireFrames.get(0) == true)
  {
    wireFrameImage = loadImage("data/WireFrameEnabled.png");
  }
}

void saveFile()
{
  for (int i = 0; i < headers.size(); i++)
  {
    output.print(headers.get(i));
    if (i == headers.size()-1)
    {
      output.println("");
      break;
    } 
    output.print(",");
  }

  for (int i = 0; i < objects; i++)
  {
    for (int j = 0; j < headers.size(); j++)
    {
      if (headers.get(j).equals("Name"))
      {
        output.print(shapes.get(i).label);
      }
      
      if (headers.get(j).equals("X"))
      {
        output.print(shapes.get(i).posX);
      }
      
      if (headers.get(j).equals("Group"))
      {
        output.print(shapes.get(i).type);
      }

      if (headers.get(j).equals("Year of Birth"))
      {
        output.print(shapes.get(i).birthYear);
      }

      if (headers.get(j).equals("Grade"))
      {
        output.print(shapes.get(i).grade);
      }
      
      if (headers.get(j).equals("Gender"))
      {
        output.print(shapes.get(i).gender);
      }

      if (headers.get(j).equals("Y"))
      {
        output.print(-shapes.get(i).posY+1000);
      }

      if (headers.get(j).equals("Z"))
      {
        output.print(shapes.get(i).posZ);
      }

      if (headers.get(j).equals("Colour"))
      {
        output.print(shapes.get(i).shapeColour);
      }

      if (headers.get(j).equals("solid"))
      {
        output.print(shapes.get(i).solid);
      }

      if (headers.get(j).equals("wireFrame"))
      {
        output.print(shapes.get(i).wireFrame);
      }

      printComma(j);
    }
    output.println("");
  }

  output.close();
}

void printComma(int i)
{
  if (i != headers.size()-1)
    {
      output.print(",");
    } 
} 

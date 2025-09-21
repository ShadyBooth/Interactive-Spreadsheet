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
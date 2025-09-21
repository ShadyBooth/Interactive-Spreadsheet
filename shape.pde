class Shape
{
  int posX, posY, posZ; // All 3 dimensions.
  int type, grade, size; // Type is "group", grade is grade, size is altered grade.
  int birthYear; // Year of birth of the person.
  int lineDown; // How big the line is.
  String label, gender; // Label and Gender of person.
  color shapeColour; // Colour of shape.
  Shape3D shape, line; // Line and Shape.
  boolean wireFrame = false, solid = true; // 2 Features.
  boolean selected = false, resetShapes = true;

  Shape(int posX, int posY, int posZ, int group, int birthYear, int grade, String label, String gender)
  {
    this.posX = posX;
    this.posY = 1000-posY;
    this.posZ = posZ;
    this.type = group;
    this.grade = grade;
    this.size = 5+(grade*3);
    this.label = label;
    this.gender = gender;
    this.birthYear = birthYear;
  }

  void display()
  {
    if (gender.equals("Male"))
    {
      if (resetShapes == true)
      {
        line = new Box(size*3, 1, 2);
      }
      line.moveTo(posX, posY+lineDown, posZ);
      line.strokeWeight(0);
      line.fill(shapeColour);
      line.draw(pg);
    }

    if (resetShapes == true)
    {
      switch (type)
      {
        case 0:
          shape = new Ellipsoid(size, size, size, 20,30);
          lineDown = 6+size;
        break;
        case 1:
          shape = new Box(size, size, size);
          lineDown = 4+size;
        break;
        case 2:
          shape = new Dome(size, size, size);
          lineDown = 2+size;
        break;
        case 3:
          shape = new DoubleCone(size, size, size, size, size);
          lineDown = 6+size;
        break;
        case 4:
          shape = new Ellipsoid(2, size, 2, 20, 30);
          lineDown = 6+size;
        break;
        default:
        break;
      }

      if (solid == true)
      {
        shape.strokeWeight(0);
        shape.drawMode(Shape3D.SOLID);
      }
  
      shape.strokeWeight(1);

      if (wireFrame == true)
      {
        shape.drawMode(Shape3D.WIRE);
      }

      if (solid == true && wireFrame == true)
      {
        shape.drawMode(Shape3D.WIRE | Shape3D.SOLID);
      }

    // Shapes have been altered.
    resetShapes = false;
    }

    if (solid == true || wireFrame == true)
    {
      shape.stroke(shapeColour);
      shape.fill(shapeColour);
      shape.visible(true);
    }

    if (solid == false && wireFrame == false)
    {
      shape.visible(false);
    }

    shape.moveTo(posX, posY, posZ);

    shape.draw(pg);
  }
}

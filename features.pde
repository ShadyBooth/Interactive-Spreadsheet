import java.util.ArrayList;
Shape shape;

class Features
{
  color c;
  int birthYear;
  
  Features(int birthYear)
  {
    this.birthYear = birthYear;
  }

  color getColour(boolean selected)
  { 
    if (selected == true)
    {
      int bright = 90;
      return color((red(c) + bright), (green(c) + bright), (blue(c) + bright));
    }

    float percent;
    if (birthYear > midAge) //If the person's birth year is younger than the median age then will calculate the colour from reddish (youngest) to brown (middle)
    { 
      percent = 255*((float)(birthYear-youngestAge)/(float)(oldestAge-youngestAge));
      c = color(255-percent+20, 255, 255 - percent + 20);
    }
    else if (birthYear < midAge) //If the person's birth year is older than the median age then it will calculate the color from  brown (middle) to greenish (oldest)
    { 
      percent = 255*((float)(birthYear-youngestAge)/(float)(midAge-youngestAge));
      c = color(255-percent, 0, 0);
    }
    else if (birthYear == midAge) //If the person's birth year is equal to the median age then it will set the colour to brown
    {
      c = color(2 ,100, 2);
    }
    return c;
  }
}

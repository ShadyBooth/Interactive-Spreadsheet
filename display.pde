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
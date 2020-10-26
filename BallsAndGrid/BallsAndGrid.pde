ArrayList<Point> points;
int scale = 24;
int cols, rows;
int insideGridLimit = 10;
boolean showBalls = false;

void setup() {
  size(672, 672);
  points = new ArrayList<Point>();
  cols = width / scale;
  rows = height / scale;
  colorMode(HSB, 100);
}

void mousePressed() {
  CreateOrClearPoints();
}

void mouseDragged() {
  CreateOrClearPoints();
}

void CreateOrClearPoints() {
  if (mouseButton == LEFT) {
    points.add(new Point(mouseX, mouseY));  
  } else if (mouseButton == RIGHT) {
    points.clear(); 
  }  
}

void keyPressed() {
  if (keyCode == UP) {
    insideGridLimit++;
  } else if (keyCode == DOWN) {
    insideGridLimit = max(insideGridLimit - 1, 0);
  } else if (key == 'b' || key == 'B') {
     showBalls = !showBalls;
  }
}

void draw() {
  DrawGrid();
  
  for(Point p : points) {
    p.Move();
    if (showBalls) {
      p.Draw(); 
    }
  }
}

void DrawGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = i * scale;
      int y = j * scale;
      
      int pointsInGrid = 0;
      for(Point p : points) {
        if (p.IsInsideGrid(x, y)) {
          pointsInGrid++; 
        }
      }
      if (pointsInGrid == 0) fill(0);
      else {
        float h = map(pointsInGrid, 0, insideGridLimit, 0, 100);
        float s = map(pointsInGrid, 0, insideGridLimit, 100, 0);
        fill(h, s, 100);
      }

      stroke(0);
      rect(x, y, scale, scale);
    }
  }
}


public class Point
{
  private float x;
  private float y;
  private float halfR;
  private float r;
  private PVector dir;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
    this.r = scale / 2;
    this.halfR = r / 2;
    float speed = random(0.5, 2);
    dir = new PVector(random(-speed, speed), random(-speed, speed));
  }
  
  public boolean IsInsideGrid(float x, float y) {
    return (this.x + this.halfR > x && this.x - this.halfR < x + scale
         && this.y + this.halfR > y && this.y - this.halfR < y + scale);
  }
  
  public void Move() {
    this.x += this.dir.x;
    this.y += this.dir.y;
    Wrap();
  }
  
  private void Wrap() {
    if (this.x - halfR < 0 || this.x + halfR > width) this.dir.x *= -1;
    if (this.y - halfR < 0 || this.y + halfR > height) this.dir.y *= -1;
  }
  
  public void Draw() {
    stroke(0);
    fill(100);
    circle(this.x, this.y, this.r);
  }
}

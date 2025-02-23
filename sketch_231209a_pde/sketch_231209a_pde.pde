import controlP5.*;

ControlP5 cp5;
PImage lineIcon, rectIcon, ellipseIcon, clearIcon, saveIcon, undoIcon, redoIcon;
ArrayList<PVector> lines, rectangles, ellipses;
ArrayList<ArrayList<PVector>> deletedLines, deletedRectangles, deletedEllipses;
int shapeMode = 0; // 0 for line, 1 for rectangle, 2 for ellipse
PVector startPoint = null;
boolean showConfirmation = false;
int confirmationTimer = 0;

float activeIconX = 50; // Initial position of the active icon indicator
float activeIconY = 550;

void setup() {
  size(800, 600);
  background(255);

  cp5 = new ControlP5(this);

  // Load icons and resize them
  lineIcon = loadImage("line.png");
  rectIcon = loadImage("rect.png");
  ellipseIcon = loadImage("ellipse.png");
  clearIcon = loadImage("clear.png");
  saveIcon = loadImage("save.png");
  undoIcon = loadImage("undo.png");
  redoIcon = loadImage("redo.png");

  lineIcon.resize(30, 30);
  rectIcon.resize(30, 30);
  ellipseIcon.resize(30, 30);
  clearIcon.resize(30, 30);
  saveIcon.resize(30, 30);
  undoIcon.resize(30, 30);
  redoIcon.resize(30, 30);

  // Add buttons with icons
  cp5.addButton("setLine")
    .setPosition(50, 550)
    .setImage(lineIcon)
    .plugTo(this, "setLine");

  cp5.addButton("setRect")
    .setPosition(150, 550)
    .setImage(rectIcon)
    .plugTo(this, "setRect");

  cp5.addButton("setEllipse")
    .setPosition(250, 550)
    .setImage(ellipseIcon)
    .plugTo(this, "setEllipse");

  cp5.addButton("clear")
    .setPosition(350, 550)
    .setImage(clearIcon)
    .plugTo(this, "clearDrawing");

  cp5.addButton("save")
    .setPosition(450, 550)
    .setImage(saveIcon)
    .plugTo(this, "saveDrawing");

  cp5.addButton("undo")
    .setPosition(550, 550)
    .setImage(undoIcon)
    .plugTo(this, "undoDrawing");

  cp5.addButton("redo")
    .setPosition(650, 550)
    .setImage(redoIcon)
    .plugTo(this, "redoDrawing");

  // Initialize ArrayLists
  lines = new ArrayList<PVector>();
  rectangles = new ArrayList<PVector>();
  ellipses = new ArrayList<PVector>();
  deletedLines = new ArrayList<ArrayList<PVector>>();
  deletedRectangles = new ArrayList<ArrayList<PVector>>();
  deletedEllipses = new ArrayList<ArrayList<PVector>>();
}

void draw() {
  background(255);
  drawLines();
  drawRectangles();
  drawEllipses();

  if (startPoint != null) {
    drawCurrentShape();
  }

  drawActiveIconIndicator();
}

void drawLines() {
  for (int i = 0; i < lines.size() - 1; i += 2) {
    PVector start = lines.get(i);
    PVector end = lines.get(i + 1);
    stroke(0);
    line(start.x, start.y, end.x, end.y);
  }
}

void drawRectangles() {
  for (int i = 0; i < rectangles.size() - 1; i += 2) {
    PVector start = rectangles.get(i);
    PVector end = rectangles.get(i + 1);
    noFill();
    stroke(0);
    rectMode(CORNERS);
    rect(start.x, start.y, end.x, end.y);
  }
}

void drawEllipses() {
  for (int i = 0; i < ellipses.size() - 1; i += 2) {
    PVector start = ellipses.get(i);
    PVector end = ellipses.get(i + 1);
    noFill();
    stroke(0);
    ellipseMode(CORNERS);
    ellipse(start.x, start.y, end.x, end.y);
  }
}

void drawCurrentShape() {
  if (shapeMode == 0) {
    stroke(0);
    line(startPoint.x, startPoint.y, mouseX, mouseY);
  } else if (shapeMode == 1) {
    noFill();
    stroke(0);
    rectMode(CORNERS);
    rect(startPoint.x, startPoint.y, mouseX, mouseY);
  } else if (shapeMode == 2) {
    noFill();
    stroke(0);
    ellipseMode(CORNERS);
    ellipse(startPoint.x, startPoint.y, mouseX, mouseY);
  }
}

void setLine() {
  shapeMode = 0;
  updateActiveIconPosition(50, 550);
}

void setRect() {
  shapeMode = 1;
  updateActiveIconPosition(150, 550);
}

void setEllipse() {
  shapeMode = 2;
  updateActiveIconPosition(250, 550);
}

void mousePressed() {
  if (mouseY < 500) { // if the mouse is not on the buttons area
    if (startPoint == null) {
      startPoint = new PVector(mouseX, mouseY);
    } else {
      if (shapeMode == 0) {
        lines.add(startPoint);
        lines.add(new PVector(mouseX, mouseY));
      } else if (shapeMode == 1) {
        rectangles.add(startPoint);
        rectangles.add(new PVector(mouseX, mouseY));
      } else if (shapeMode == 2) {
        ellipses.add(startPoint);
        ellipses.add(new PVector(mouseX, mouseY));
      }
      startPoint = null;
    }
  }
}

void clearDrawing() {
  lines.clear();
  rectangles.clear();
  ellipses.clear();
  deletedLines.clear();
  deletedRectangles.clear();
  deletedEllipses.clear();
  resetActiveIconIndicator();
}

void saveDrawing() {
  PrintWriter output = createWriter("drawing.pde");

  output.println("void setup() {");
  output.println("  size(800, 600);");
  output.println("  background(255);");
  output.println("}");

  output.println("void draw() {");

  output.println("  // draw the lines");
  for (int i = 0; i < lines.size() - 1; i += 2) {
    PVector start = lines.get(i);
    PVector end = lines.get(i + 1);
    output.println("  stroke(0);");
    output.println("  line(" + start.x + ", " + start.y + ", " + end.x + ", " + end.y + ");");
  }

  output.println("  // draw the rectangles");
  for (int i = 0; i < rectangles.size() - 1; i += 2) {
    PVector start = rectangles.get(i);
    PVector end = rectangles.get(i + 1);
    output.println("  noFill();");
    output.println("  stroke(0);");
    output.println("  rectMode(CORNERS);");
    output.println("  rect(" + start.x + ", " + start.y + ", " + end.x + ", " + end.y + ");");
  }

  output.println("  // draw the ellipses");
  for (int i = 0; i < ellipses.size() - 1; i += 2) {
    PVector start = ellipses.get(i);
    PVector end = ellipses.get(i + 1);
    output.println("  noFill();");
    output.println("  stroke(0);");
    output.println("  ellipseMode(CORNERS);");
    output.println("  ellipse(" + start.x + ", " + start.y + ", " + end.x + ", " + end.y + ");");
  }

  output.println("}");

  output.flush();
  output.close();

  showConfirmation = true;
  confirmationTimer = 120; // 120 frames = 2 seconds at 60fps
}

void updateActiveIconPosition(float x, float y) {
  activeIconX = x;
  activeIconY = y - 5; // Offset to position the indicator just above the active icon
}

void drawActiveIconIndicator() {
  stroke(0);
  strokeWeight(2);
  point(activeIconX + 15, activeIconY); // Draw a small point above the active icon
}

void resetActiveIconIndicator() {
  activeIconX = -50; // Move the indicator off-screen
  activeIconY = -50;
}

void updateButtonColors(String activeButton) {
  String[] buttonNames = {"setLine", "setRect", "setEllipse"};
  for (String button : buttonNames) {
    if (button.equals(activeButton)) {
      cp5.getController(button).setColorBackground(color(255, 0, 0));
    } else {
      cp5.getController(button).setColorBackground(color(200));
    }
  }
}

void undoDrawing() {
  if (!lines.isEmpty()) {
    ArrayList<PVector> deletedLine = new ArrayList<PVector>(lines.subList(lines.size() - 2, lines.size()));
    lines.remove(lines.size() - 1);
    lines.remove(lines.size() - 1);
    deletedLines.add(deletedLine);
  } else if (!rectangles.isEmpty()) {
    ArrayList<PVector> deletedRect = new ArrayList<PVector>(rectangles.subList(rectangles.size() - 2, rectangles.size()));
    rectangles.remove(rectangles.size() - 1);
    rectangles.remove(rectangles.size() - 1);
    deletedRectangles.add(deletedRect);
  } else if (!ellipses.isEmpty()) {
    ArrayList<PVector> deletedEllipse = new ArrayList<PVector>(ellipses.subList(ellipses.size() - 2, ellipses.size()));
    ellipses.remove(ellipses.size() - 1);
    ellipses.remove(ellipses.size() - 1);
    deletedEllipses.add(deletedEllipse);
  }
}

void redoDrawing() {
  if (!deletedLines.isEmpty()) {
    ArrayList<PVector> lastDeleted = deletedLines.get(deletedLines.size() - 1);
    lines.add(lastDeleted.get(0));
    lines.add(lastDeleted.get(1));
    deletedLines.remove(deletedLines.size() - 1);
  } else if (!deletedRectangles.isEmpty()) {
    ArrayList<PVector> lastDeleted = deletedRectangles.get(deletedRectangles.size() - 1);
    rectangles.add(lastDeleted.get(0));
    rectangles.add(lastDeleted.get(1));
    deletedRectangles.remove(deletedRectangles.size() - 1);
  } else if (!deletedEllipses.isEmpty()) {
    ArrayList<PVector> lastDeleted = deletedEllipses.get(deletedEllipses.size() - 1);
    ellipses.add(lastDeleted.get(0));
    ellipses.add(lastDeleted.get(1));
    deletedEllipses.remove(deletedEllipses.size() - 1);
  }
}

void cancelDrawing() {
  startPoint = null; // Réinitialiser le point de départ
}

void keyPressed() {
  if (keyCode == BACKSPACE) {
    undoDrawing();
  }
  if (keyCode == 32) {
    cancelDrawing();
  }
}

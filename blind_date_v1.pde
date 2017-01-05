import processing.video.*;
import TUIO.*;

TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

Clip clip1;
Clip clip2;
Clip m1;
Clip m2;

Clip act;

State state = State.WAITING_FOR_INPUT;

enum State {
  PLAYING, WAITING_FOR_INPUT
}

enum ClipType { 
  CLIP, MEMORY
}

class Clip {
  Movie m;
  ClipType c;
  float loopLength;

  Clip (Movie m, ClipType c) {
    this.m = m;
    this.c = c;
    loopLength = 2.0f;
  }

  void play() {
    m.play();
  }

  void pause() {
    m.pause();
  }

  void stop() {
    m.stop();
  }

  void loop() {
    m.loop();
  }

  void jump(float t) {
    m.jump(t);
  }

  Movie getMovie() {
    return m;
  }

  ClipType getClipType() {
    return c;
  }

  float time() {
    return m.time();
  }

  float duration() {
    return m.duration();
  }

  boolean available() {
    return m.available();
  }
}

ArrayList<Clip> clips;
int index = 0;

void setup() {
  size(640, 480);

  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  tuioClient  = new TuioProcessing(this);

  clip1 = new Clip(new Movie(this, "/Users/jukka/Downloads/044573096-senior-chaplain-talking-about-.mp4"), ClipType.CLIP);
  clip2 = new Clip(new Movie(this, "/Users/jukka/Downloads/044573096-senior-chaplain-talking-about-.mp4"), ClipType.CLIP); // TODO just for testing
  m1 = new Clip(new Movie(this, "/Users/jukka/Downloads/044595314-remains-aircraft-burning-midwa.mp4"), ClipType.MEMORY);
  m2 = new Clip(new Movie(this, "/Users/jukka/Downloads/043324974-view-explosion-near-uss-battle.mp4"), ClipType.MEMORY);

  clips = new ArrayList<Clip>();
  clips.add(clip1);
  clips.add(m1);
  clips.add(clip2);
  clips.add(m2);

  act = clips.get(0);
  act.jump(0);
}

void draw() {
  println(index + ", " + act.time() + ", " + act.duration());
  switch (state) {
  case WAITING_FOR_INPUT:
    renderWaiting();
    break;
  case PLAYING:
    renderVideo();
    break;
  }

  // START TUIO
  textFont(font, 18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);
    stroke(0);
    fill(0, 0, 0);
    pushMatrix();
    translate(tobj.getScreenX(width), tobj.getScreenY(height));
    rotate(tobj.getAngle());
    rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
    popMatrix();
    fill(255);
    text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
  }

  ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
  for (int i=0; i<tuioCursorList.size(); i++) {
    TuioCursor tcur = tuioCursorList.get(i);
    ArrayList<TuioPoint> pointList = tcur.getPath();

    if (pointList.size()>0) {
      stroke(0, 0, 255);
      TuioPoint start_point = pointList.get(0);
      for (int j=0; j<pointList.size(); j++) {
        TuioPoint end_point = pointList.get(j);
        line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));
        start_point = end_point;
      }

      stroke(192, 192, 192);
      fill(192, 192, 192);
      ellipse( tcur.getScreenX(width), tcur.getScreenY(height), cur_size, cur_size);
      fill(0);
      text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
    }
  }

  ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();
  for (int i=0; i<tuioBlobList.size(); i++) {
    TuioBlob tblb = tuioBlobList.get(i);
    stroke(0);
    fill(0);
    pushMatrix();
    translate(tblb.getScreenX(width), tblb.getScreenY(height));
    rotate(tblb.getAngle());
    ellipse(-1*tblb.getScreenWidth(width)/2, -1*tblb.getScreenHeight(height)/2, tblb.getScreenWidth(width), tblb.getScreenWidth(width));
    popMatrix();
    fill(255);
    text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenX(width));
  }
  // END TUIO
}

void movieEvent(Movie m) {
  m.read();
}

void renderWaiting() {
  background(255);
  textFont(font, 18);
  stroke(0);
  fill(0);
  text("WAITING FOR INPUT", 100, 100);
}

void renderVideo() {
  if (act.time() >= act.duration()-0.1 && act.time() != -1.0E-9) { // TODO shitty magic numbers abound yeah yeah
    if (index < clips.size()-1) {
      act.stop();
      index++;
      act = clips.get(index);
      act.jump(0);
      act.play();
    } else {
      act.stop();
      index = 0;
      act = clips.get(index);
      act.stop();
      act.jump(0);
      state = State.WAITING_FOR_INPUT;
      return;
    }
  }
  image(act.getMovie(), 0, 0);
}

void keyPressed() {
  if (state == State.WAITING_FOR_INPUT) {
    state = State.PLAYING;
    act.play();
  }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
    +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
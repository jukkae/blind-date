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

Clip mainCut;

Clip c01, c02, c03, c04, c05, c06, c07, c08, c09_a, c09_b, c09_c, c10_a, c10_b, c10_c;

Clip m01, m02, m03, m04, m05, m06, m07, m08, m09, m10, m11, m12, 
  m13, m14, m15, m16, m17, m18, m19, m20, m21, m22, m23, m24, 
  m25, m26, m27, m28, m29, m30, m31, m32, m33, m34, m35, m36, 
  m37, m38, m39, m40, m41, m42, m43, m44, m45, m46, m47, m48;

Clip act;

State state = State.WAITING_FOR_INPUT;

enum State {
  FIRST_PLAY, PLAYING, WAITING_FOR_INPUT, READY
}

enum ClipType { 
  CLIP, YELLOW, BLUE
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
ArrayList<Clip> ending_a;
ArrayList<Clip> ending_b;
ArrayList<Clip> ending_c;
ArrayList<Clip> memories;

ArrayList<Clip> timeline;

int index = 0;

void setup() {
  size(1280, 720);

  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  tuioClient  = new TuioProcessing(this);

  initClips();
  initMemories();
}

void initClips() {
  mainCut = new Clip(new Movie(this, "main/kuleshow_story.mp4"), ClipType.CLIP);

  clips    = new ArrayList<Clip>();
  ending_a = new ArrayList<Clip>();
  ending_b = new ArrayList<Clip>();
  ending_c = new ArrayList<Clip>();

  c01   = new Clip(new Movie(this, "main/01.mp4"), ClipType.CLIP);
  c02   = new Clip(new Movie(this, "main/02.mp4"), ClipType.CLIP);
  c03   = new Clip(new Movie(this, "main/03.mp4"), ClipType.CLIP);
  c04   = new Clip(new Movie(this, "main/04.mp4"), ClipType.CLIP);
  c05   = new Clip(new Movie(this, "main/05.mp4"), ClipType.CLIP);
  c06   = new Clip(new Movie(this, "main/06.mp4"), ClipType.CLIP);
  c07   = new Clip(new Movie(this, "main/07.mp4"), ClipType.CLIP);
  c08   = new Clip(new Movie(this, "main/08.mp4"), ClipType.CLIP);
  c09_a = new Clip(new Movie(this, "main/09_a.mp4"), ClipType.CLIP);
  c09_b = new Clip(new Movie(this, "main/09_b.mp4"), ClipType.CLIP);
  c09_c = new Clip(new Movie(this, "main/09_c.mp4"), ClipType.CLIP);
  c10_a = new Clip(new Movie(this, "main/10_a.mp4"), ClipType.CLIP);
  c10_b = new Clip(new Movie(this, "main/10_b.mp4"), ClipType.CLIP);
  c10_c = new Clip(new Movie(this, "main/10_c.mp4"), ClipType.CLIP);

  clips.add(c01);
  clips.add(c02);
  clips.add(c03);
  clips.add(c04);
  clips.add(c05);
  clips.add(c06);
  clips.add(c07);
  clips.add(c08);

  ending_a.add(c09_a);
  ending_a.add(c10_a);
  ending_b.add(c09_b);
  ending_b.add(c10_b);
  ending_c.add(c09_c);
  ending_c.add(c10_c);
}

void initMemories() {
  memories = new ArrayList<Clip>();
  // TODO load memory clips
  m01 = new Clip(new Movie(this, "mem/y jutta Sequence 01.mp4"), ClipType.YELLOW);
  m02 = new Clip(new Movie(this, "mem/y jutta Sequence 02.mp4"), ClipType.YELLOW);
  m03 = new Clip(new Movie(this, "mem/y jutta Sequence 03.mp4"), ClipType.YELLOW);
  m04 = new Clip(new Movie(this, "mem/y jutta Sequence 05.mp4"), ClipType.YELLOW);
  m05 = new Clip(new Movie(this, "mem/y jutta Sequence 08.mp4"), ClipType.YELLOW);
  m06 = new Clip(new Movie(this, "mem/y jutta Sequence 12.mp4"), ClipType.YELLOW);
  m07 = new Clip(new Movie(this, "mem/b jutta Sequence 04.mp4"), ClipType.BLUE);
  m08 = new Clip(new Movie(this, "mem/b jutta Sequence 06.mp4"), ClipType.BLUE);
  m09 = new Clip(new Movie(this, "mem/b jutta Sequence 07.mp4"), ClipType.BLUE);
  m10 = new Clip(new Movie(this, "mem/b jutta Sequence 09.mp4"), ClipType.BLUE);
  m11 = new Clip(new Movie(this, "mem/b jutta Sequence 10.mp4"), ClipType.BLUE);
  m12 = new Clip(new Movie(this, "mem/b jutta Sequence 11.mp4"), ClipType.BLUE);
}

void draw() {
  switch (state) {
  case WAITING_FOR_INPUT:
    renderWaiting();
    break;
  case PLAYING:
    println(index + ", " + act.time() + ", " + act.duration());
    renderVideo();
    break;
  case FIRST_PLAY:
    renderFirstVideo();
    break;
  case READY:
    renderReady();
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
  if (memories.size() == 9) {
    buildTimeline();
    state = State.READY;
  }
}

void renderReady() {
  background(255);
  textFont(font, 18);
  stroke(0);
  fill(0);
  text("READY, PRESS P TO PLAY", 100, 100);
}

void renderFirstVideo() {
  if (act.time() >= act.duration()-0.1 && act.time() != -1.0E-9) { // TODO shitty magic numbers abound yeah yeah
    act.stop();
    index = 0;
    act = mainCut;
    act.stop();
    act.jump(0);
    state = State.WAITING_FOR_INPUT;
    return;
  }
  image(act.getMovie(), 0, 0);
}

void renderVideo() {
  if (act.time() >= act.duration()-0.1 && act.time() != -1.0E-9) { // TODO shitty magic numbers abound yeah yeah
    if (index < timeline.size()-1) {
      act.stop();
      index++;
      act = timeline.get(index);
      act.jump(0);
      act.play();
    } else {
      act.stop();
      index = 0;
      act = timeline.get(index);
      act.stop();
      act.jump(0);
      memories = new ArrayList<Clip>(); // reinitialize memories array
      state = State.WAITING_FOR_INPUT;
      return;
    }
  }
  image(act.getMovie(), 0, 0);
}

void buildTimeline() {
  timeline = new ArrayList<Clip>();
  //build timeline until ending
  for (int i = 0; i < clips.size(); i++) {
    timeline.add(clips.get(i));
    if (i < clips.size()-1) {
      timeline.add(memories.get(i));
    }
  }
  //build ending
  for (int j = 0; j < ending_a.size(); j++) {
    timeline.add(ending_a.get(j));
    if (j < ending_a.size()-1) {
      timeline.add(memories.get(clips.size() + j));
    }
  }
  println("Timeline built!");
}

void keyPressed() {
  if (state == State.WAITING_FOR_INPUT || state == State.READY) {
    switch(key) {
    case 'p':
      state = State.PLAYING;
      act = clips.get(0);
      act.jump(0);
      act.play();
      break;
    case '1':
      state = State.FIRST_PLAY;
      act = mainCut;
      act.jump(0);
      act.play();
      break;
    default:
      break;
    }
  }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (state == State.WAITING_FOR_INPUT) {
    if (memories.size() < 9) {
      int i = tobj.getSymbolID();
      switch (i) {
      case 1:
        memories.add(m01);
        break;
      case 2:
        memories.add(m02);
        break;
      case 3:
        memories.add(m03);
        break;
      case 4:
        memories.add(m04);
        break;
      case 5:
        memories.add(m05);
        break;
      case 6:
        memories.add(m06);
        break;
      case 7:
        memories.add(m07);
        break;
      case 8:
        memories.add(m08);
        break;
      case 9:
        memories.add(m09);
        break;
      }
      println("added " + i);
    }
  }
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
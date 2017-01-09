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
  // YELLOW MEMORIES
  m01 = new Clip(new Movie(this, "mem/y jutta Sequence 01.mp4"), ClipType.YELLOW);
  m02 = new Clip(new Movie(this, "mem/y jutta Sequence 02.mp4"), ClipType.YELLOW);
  m03 = new Clip(new Movie(this, "mem/y jutta Sequence 03.mp4"), ClipType.YELLOW);
  m04 = new Clip(new Movie(this, "mem/y jutta Sequence 05.mp4"), ClipType.YELLOW);
  m05 = new Clip(new Movie(this, "mem/y jutta Sequence 08.mp4"), ClipType.YELLOW);
  m06 = new Clip(new Movie(this, "mem/y jutta Sequence 12.mp4"), ClipType.YELLOW);
  m07 = new Clip(new Movie(this, "mem/y_01.mp4"), ClipType.YELLOW);
  m08 = new Clip(new Movie(this, "mem/y_02.mp4"), ClipType.YELLOW);
  m09 = new Clip(new Movie(this, "mem/y_03.mp4"), ClipType.YELLOW);
  m10 = new Clip(new Movie(this, "mem/y_04.mp4"), ClipType.YELLOW);
  m11 = new Clip(new Movie(this, "mem/y_05.mp4"), ClipType.YELLOW);
  m12 = new Clip(new Movie(this, "mem/y_06.mp4"), ClipType.YELLOW);
  m13 = new Clip(new Movie(this, "mem/y_07.mp4"), ClipType.YELLOW);
  m14 = new Clip(new Movie(this, "mem/y_08.mp4"), ClipType.YELLOW);
  m15 = new Clip(new Movie(this, "mem/y_09.mp4"), ClipType.YELLOW);
  m16 = new Clip(new Movie(this, "mem/y_10.mp4"), ClipType.YELLOW);
  m17 = new Clip(new Movie(this, "mem/y_11.mp4"), ClipType.YELLOW);
  m18 = new Clip(new Movie(this, "mem/y_12.mp4"), ClipType.YELLOW);
  m19 = new Clip(new Movie(this, "mem/y_13.mp4"), ClipType.YELLOW);
  m20 = new Clip(new Movie(this, "mem/y_14.mp4"), ClipType.YELLOW);
  m21 = new Clip(new Movie(this, "mem/y_15.mp4"), ClipType.YELLOW);
  m22 = new Clip(new Movie(this, "mem/y_16.mp4"), ClipType.YELLOW);
  m23 = new Clip(new Movie(this, "mem/y_17.mp4"), ClipType.YELLOW);

  m24 = new Clip(new Movie(this, "mem/b jutta Sequence 04.mp4"), ClipType.BLUE);
  m25 = new Clip(new Movie(this, "mem/b jutta Sequence 06.mp4"), ClipType.BLUE);
  m26 = new Clip(new Movie(this, "mem/b jutta Sequence 07.mp4"), ClipType.BLUE);
  m27 = new Clip(new Movie(this, "mem/b jutta Sequence 09.mp4"), ClipType.BLUE);
  m28 = new Clip(new Movie(this, "mem/b jutta Sequence 10.mp4"), ClipType.BLUE);
  m29 = new Clip(new Movie(this, "mem/b jutta Sequence 11.mp4"), ClipType.BLUE);
  m30 = new Clip(new Movie(this, "mem/b_01.mp4"), ClipType.BLUE);
  m31 = new Clip(new Movie(this, "mem/b_02.mp4"), ClipType.BLUE);
  m32 = new Clip(new Movie(this, "mem/b_03.mp4"), ClipType.BLUE);
  m33 = new Clip(new Movie(this, "mem/b_04.mp4"), ClipType.BLUE);
  m34 = new Clip(new Movie(this, "mem/b_05.mp4"), ClipType.BLUE);
  m35 = new Clip(new Movie(this, "mem/b_06.mp4"), ClipType.BLUE);
  m36 = new Clip(new Movie(this, "mem/b_07.mp4"), ClipType.BLUE);
  m37 = new Clip(new Movie(this, "mem/b_08.mp4"), ClipType.BLUE);
  m38 = new Clip(new Movie(this, "mem/b_09.mp4"), ClipType.BLUE);
  m39 = new Clip(new Movie(this, "mem/b_10.mp4"), ClipType.BLUE);
  m40 = new Clip(new Movie(this, "mem/b_11.mp4"), ClipType.BLUE);
  m41 = new Clip(new Movie(this, "mem/b_12.mp4"), ClipType.BLUE);
  m42 = new Clip(new Movie(this, "mem/b_13.mp4"), ClipType.BLUE);
  m43 = new Clip(new Movie(this, "mem/b_14.mp4"), ClipType.BLUE);
  m44 = new Clip(new Movie(this, "mem/b_15.mp4"), ClipType.BLUE);
  m45 = new Clip(new Movie(this, "mem/b_16.mp4"), ClipType.BLUE);
  m46 = new Clip(new Movie(this, "mem/b_17.mp4"), ClipType.BLUE);
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
  text("MEMORY MONTAGE MACHINE PROUDLY PRESENTS", 100, 100);
  text("An interactive film by Jukka Eerikäinen, Anna Knappe, Jutta Suksi & Xinran Wang", 100, 200);
  text("BLIND DATE", 100, 300);
  text("Primary cut: press 1", 100, 400);
  text("Inserted " + memories.size() + " memories out of 9.", 100, 500);
  text("Waiting for input...", 100, 600);
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
  text("MEMORY MONTAGE MACHINE PROUDLY PRESENTS", 100, 100);
  text("An interactive film by Jukka Eerikäinen, Anna Knappe, Jutta Suksi & Xinran Wang", 100, 200);
  text("BLIND DATE", 100, 300);
  text("Primary cut: press 1", 100, 400);
  text("TIMELINE BUILT, PRESS P TO PLAY", 100, 500);
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
  //TODO fix building different endings!
  //build ending
  if (memories.get(memories.size()-2).getClipType() == ClipType.YELLOW && memories.get(memories.size()-1).getClipType() == ClipType.YELLOW) {
    //yellow-yellow
    for (int j = 0; j < ending_a.size(); j++) {
      timeline.add(ending_a.get(j));
      if (j < ending_a.size()-1) {
        timeline.add(memories.get(clips.size() + j));
      }
    }
  } else if (memories.get(memories.size()-2).getClipType() == ClipType.BLUE && memories.get(memories.size()-1).getClipType() == ClipType.BLUE) {
    //blue-blue
    for (int j = 0; j < ending_c.size(); j++) {
      timeline.add(ending_c.get(j));
      if (j < ending_c.size()-1) {
        timeline.add(memories.get(clips.size() + j));
      }
    }
  } else {
    //blue-yellow
    for (int j = 0; j < ending_b.size(); j++) {
      timeline.add(ending_b.get(j));
      if (j < ending_b.size()-1) {
        timeline.add(memories.get(clips.size() + j));
      }
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
        //YELLOW
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
      case 10:
        memories.add(m10);
        break;
      case 11:
        memories.add(m11);
        break;
      case 12:
        memories.add(m12);
        break;
      case 13:
        memories.add(m13);
        break;
      case 14:
        memories.add(m14);
        break;
      case 15:
        memories.add(m15);
        break;
      case 16:
        memories.add(m16);
        break;
      case 17:
        memories.add(m17);
        break;
      case 18:
        memories.add(m18);
        break;
      case 19:
        memories.add(m19);
        break;
      case 20:
        memories.add(m20);
        break;
      case 21:
        memories.add(m21);
        break;
      case 22:
        memories.add(m22);
        break;
      case 23:
        memories.add(m23);
        break;
        //BLUE
        
      case 51:
        memories.add(m24);
        break;
      case 52:
        memories.add(m25);
        break;
      case 53:
        memories.add(m26);
        break;
      case 54:
        memories.add(m27);
        break;
      case 55:
        memories.add(m28);
        break;
      case 56:
        memories.add(m29);
        break;
      case 57:
        memories.add(m30);
        break;
      case 58:
        memories.add(m31);
        break;
      case 59:
        memories.add(m32);
        break;
      case 60:
        memories.add(m33);
        break;
      case 61:
        memories.add(m34);
        break;
      case 62:
        memories.add(m35);
        break;
      case 63:
        memories.add(m36);
        break;
      case 64:
        memories.add(m37);
        break;
      case 65:
        memories.add(m38);
        break;
      case 66:
        memories.add(m39);
        break;
      case 67:
        memories.add(m40);
        break;
      case 68:
        memories.add(m41);
        break;
      case 69:
        memories.add(m42);
        break;
      case 70:
        memories.add(m43);
        break;
      case 71:
        memories.add(m44);
        break;
      case 72:
        memories.add(m45);
        break;
      case 73:
        memories.add(m46);
        break;
      default:
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
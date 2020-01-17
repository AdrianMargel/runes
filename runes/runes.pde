public class Vector {
  public float x;
  public float y;
  public Vector(float x, float y) {
    this.x=x;
    this.y=y;
  }
  public Vector(float a, float b,boolean angleInit) {
    if(angleInit){
      this.x=cos(a)*b;
      this.y=sin(a)*b;
    }else{
      this.x=a;
      this.y=b;
    }
  }
  public Vector(Vector vec) {
    this.x=vec.x;
    this.y=vec.y;
  }
  public void addVec(Vector vec) {
    x+=vec.x;
    y+=vec.y;
  }
  public void subVec(Vector vec) {
    x-=vec.x;
    y-=vec.y;
  }
  public void sclVec(float scale) {
    x*=scale;
    y*=scale;
  }
  public void nrmVec() {
    sclVec(1/getMag());
  }
  public void nrmVec(float mag) {
    sclVec(mag/getMag());
  }
  public void limVec(float lim) {
    float mag=getMag();
    if (mag>lim) {
      sclVec(lim/mag);
    }
  }
  public float getAng() {
    return atan2(y, x);
  }
  public float getAng(Vector vec) {
    return atan2(vec.y-y, vec.x-x);
  }
  public float getMag() {
    return sqrt(sq(x)+sq(y));
  }
  public float getMag(Vector vec) {
    return sqrt(sq(vec.x-x)+sq(vec.y-y));
  }
  public void rotVec(float rot) {
    float mag=getMag();
    float ang=getAng();
    ang+=rot;
    x=cos(ang)*mag;
    y=sin(ang)*mag;
  }
  public void rotVec(float rot,Vector pin) {//UNTESTED
    subVec(pin);
    float mag=getMag();
    float ang=getAng();
    ang+=rot;
    x=cos(ang)*mag;
    y=sin(ang)*mag;
    addVec(pin);
  }
  public void minVec(Vector min){
    x=min(x,min.x);
    y=min(y,min.y);
  }
  public void maxVec(Vector max){
    x=max(x,max.x);
    y=max(y,max.y);
  }
  public boolean inRange(Vector vec,float dist){
    float diffX=abs(vec.x-x);
    if(diffX>dist){
      return false;
    }
    float diffY=abs(vec.y-y);
    if(diffY>dist){
      return false;
    }
    return sqrt(sq(diffX)+sq(diffY))<=dist;
  }
  public void setVec(Vector vec){
    x=vec.x;
    y=vec.y;
  }
}
class Line{
  Vector c1;
  Vector c2;
  Line(Vector c1,Vector c2){
    this.c1=c1;
    this.c2=c2;
  }
}
class Rune{
  ArrayList<Vector> points;
  ArrayList<Line> lines;
  
  Rune(int complexity){
    points=new ArrayList<Vector>();
    lines=new ArrayList<Line>();
    for(int x=0;x<4;x++){
      for(int y=0;y<6;y++){
        points.add(new Vector(x,y));
      }  
    }
    for(int i=0;i<complexity;i++){
      //pick two random points to connect
      Vector c1=points.get((int)random(0,points.size()));
      Vector c2=points.get((int)random(0,points.size()));
      //only allow lines that follow certain alignments
      if(abs(c1.x-c2.x)==abs(c1.y-c2.y)||abs(c1.x-c2.x)==0||abs(c1.y-c2.y)==0){
        Line toAdd=new Line(c1,c2);
        lines.add(toAdd);
      }else{
        //if line couldn't be added try again
        i--;
      }
    }
  }
  //if all 4 sides are touched by at least 1 line
  boolean valid(){
    boolean touchPX=false;
    boolean touchNX=false;
    boolean touchPY=false;
    boolean touchNY=false;
    
    for(int i=0;i<lines.size();i++){
      touchPX=touchPX||lines.get(i).c1.x==3||lines.get(i).c2.x==3;
      touchNX=touchNX||lines.get(i).c1.x==0||lines.get(i).c2.x==0;
      
      touchPY=touchPY||lines.get(i).c1.y==5||lines.get(i).c2.y==5;
      touchNY=touchNY||lines.get(i).c1.y==0||lines.get(i).c2.y==0;
    }
    return touchPX&&touchNX&&touchPY&&touchNY;
  }
  void display(Vector pos){
    for(int i=0;i<lines.size();i++){
      line(lines.get(i).c1.x*size+pos.x,lines.get(i).c1.y*size+pos.y,lines.get(i).c2.x*size+pos.x,lines.get(i).c2.y*size+pos.y);
    }
  }
}
Vector drawer=new Vector(0,10);
float size=10;
void setup(){
  size(800,800);
  background(255);
}
void draw(){
  Rune stamp;
  do{
    stamp=new Rune(12);
  }while(!stamp.valid());
  //noStroke();
  //fill(150);
  strokeWeight(1);
  rect(drawer.x-5,drawer.y-5,size*3+10,size*5+10);
  strokeWeight(3);
  stroke(0);
  noFill();
  stamp.display(drawer);
  
  drawer.x+=30+30;
  if(drawer.x>width){
    drawer.x=0;
    drawer.y+=50+30;
  }
}

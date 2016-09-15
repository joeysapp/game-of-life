NodeSystem ns;
int f;
int time;

void setup(){
  size(500, 500);
  pixelDensity(displayDensity());
  f = 4;
  ns = new NodeSystem(f);
  noStroke();
  background(255);
}

void draw(){
  pushMatrix();
  background(255);

  //if (time % 250 == 0){ ns.init(); }
  ns.generate();
  ns.display();
  popMatrix();
}

class NodeSystem {
  Node[][] nodes;
  int dist;
  int columns, rows;
  
  NodeSystem(int dist_){
    columns = width/dist_;
    rows = height/dist_;
    nodes = new Node[columns][rows];
    dist = dist_;
    init();
  }
  void init(){
    for (int x = 0; x < width/dist; x++){
      for (int y = 0; y < height/dist; y++){
        nodes[x][y] = new Node(x*dist, y*dist, dist);
      }
    }
  }
  void generate(){
    for (int i = 0; i < columns; i++){
      for (int j = 0; j < rows; j++){
        nodes[i][j].savePrevious();
      }
    }
    for (int x = 0; x < columns; x++){
      for (int y = 0; y < rows; y++){
        int neighbors = 0;
        for (int i = -1; i <= 1; i++){
          for (int j = -1; j <= 1; j++){
            neighbors += nodes[(x+i+columns)%columns][(y+j+rows)%rows].previous;
          }
        }
        neighbors -= nodes[x][y].previous;
        if      ((nodes[x][y].state == 1) && (neighbors < 2)){ nodes[x][y].newState(0); }
        else if ((nodes[x][y].state == 1) && (neighbors > 3)){ nodes[x][y].newState(0); }
        else if ((nodes[x][y].state == 0) && (neighbors ==3)){ nodes[x][y].newState(1);  }
      }
    }
  }
  
  void display(){
    for (int i = 0; i < columns; i++){
      for (int j = 0; j < rows; j++){
        nodes[i][j].display();
      }
    }
  }   
}

class Node {
  PVector pos;
  float size;
  float state, previous;
  
  Node(float x, float y, float size_){
    pos = new PVector(x, y);
    size = size_;
    state = (int) random(2);
    previous = state;
  }
  
  
  void display(){
    if (previous == 0 && state == 1){
      fill(255, 0, 0);
    } else if (state == 1){
      fill(0);
    } else if (previous == 1 && state ==0){
      fill (0, 0, 255);
    } else {
      fill(255);
    }
    rect(pos.x, pos.y, size, size);
    //rect(pos.x, pos.y + size/2, size, size/2);
  }
  
  void savePrevious(){
    previous = state;
  }
  
  void newState(float newState){
    state = newState;
  }
}
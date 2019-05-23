// MINESWEEPER FOR PROCESSING 3.4
// Written by 144a
// 
// Got bored on a 10 hour car ride, so I thought I'd make a game of minesweepers to play,
// since I had my Dad's work laptop and it had a processing ide installed.
//
// To play, make changes to the game settings to customize the game
// Use the arrow keys to move the cursor, and the q and r keys for revealing and flagging squares respectively


// Change to edit game settings
final int FIELD_WIDTH = 90;
final int FIELD_HIEGHT = 60;
final int MINES_NUM = 400;

// Changes scale of grid
final int scale = 1;

boolean refreshGrid = true;

// Creates arrays for both current board state and table of values
int[][] field = new int [FIELD_HIEGHT][FIELD_WIDTH];
int[][] field_cleared = new int [FIELD_HIEGHT][FIELD_WIDTH];

// Font data for drawing numbers
// Don't bother trying to change this unless you really want to
int[][][] numdata = {{{1,1,1,1,1},{1,0,0,0,1},{1,0,0,0,1},{1,0,0,0,1},{1,1,1,1,1}},{{0,1,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0},{0,0,1,0,0}},{{0,1,1,1,0},{0,0,0,1,0},{0,1,1,1,0},{0,1,0,0,0},{0,1,1,1,0}},{{0,1,1,1,0},{0,0,0,1,0},{0,1,1,1,0},{0,0,0,1,0},{0,1,1,1,0}},{{0,1,0,1,0},{0,1,0,1,0},{0,1,1,1,0},{0,0,0,1,0},{0,0,0,1,0}},{{0,1,1,1,0},{0,1,0,0,0},{0,1,1,1,0},{0,0,0,1,0},{0,1,1,1,0}},{{0,1,1,1,0},{0,1,0,0,0},{0,1,1,1,0},{0,1,0,1,0},{0,1,1,1,0}},{{0,1,1,1,0},{0,0,0,1,0},{0,0,0,1,0},{0,0,0,1,0},{0,0,0,1,0}},{{0,1,1,1,0},{0,1,0,1,0},{0,1,1,1,0},{0,1,0,1,0},{0,1,1,1,0}}};

int[][] flag = {{1,1,1,1,0},{1,0,0,0,0},{1,1,1,0,0},{1,0,0,0,0},{1,0,0,0,0}};

// Current cursor positions (in relation to the array)
int cursorXpos = 0;
int cursorYpos = 0;

// Old cursor positions
int oldcursorX = 2;
int oldcursorY = 2;

// Creates arraylists to track the current flags places and the correct flag placement
ArrayList<Integer> curFlagX = new ArrayList<Integer>(0);
ArrayList<Integer> curFlagY = new ArrayList<Integer>(0);
ArrayList<Integer> finFlagX = new ArrayList<Integer>(0);
ArrayList<Integer> finFlagY = new ArrayList<Integer>(0);


// Determines whether an arrow key has been pressed
boolean keypress = true;

// For flagging and revealing squares
boolean isFlagged = false;
boolean isRevealed = false;


void setup() {
  size(100, 100);
  background(0);
  surface.setSize(10 * scale * FIELD_WIDTH + 1, 10 * scale * FIELD_HIEGHT + 1);
  
  stroke(190,20,0);
  fieldGen(MINES_NUM);
  
}


void drawGrid() {
  for(int x = 0; x < FIELD_WIDTH; x++) {
    for(int y = 0; y < FIELD_HIEGHT; y++) {
      line(x * 10 * scale, y * 10 * scale, (x + 1) * 10 * scale - 1, y * 10 * scale);
      line(x * 10 * scale, y * 10 * scale, x * 10 * scale, (y + 1) * 10 * scale - 1);
    }
  }
  // When loops just can't finish the job
  line(FIELD_WIDTH * 10 * scale, 0, FIELD_WIDTH * 10 * scale, FIELD_HIEGHT * 10 * scale);
  line(0, FIELD_HIEGHT * 10 * scale, FIELD_WIDTH * 10 * scale, FIELD_HIEGHT * 10 * scale);
}

void endGame() {
  background(0);
  exit();
  println("end game");
}



// Main Game Loop
void draw() {
  if(refreshGrid == true) {
    drawGrid();
    refreshGrid = false;
  }
  
  // Reveals sqaure if the q key is pressed and the current sqaure is not flagged
  if(isRevealed == true && field_cleared[cursorYpos][cursorXpos] != -1) {
    if(field[cursorYpos][cursorXpos] == 0 && field_cleared[cursorYpos][cursorXpos] != 1) {
      clearSpaces();
    }
    field_cleared[cursorYpos][cursorXpos] = 1;
    isRevealed = false;
  }
  
  // Flags a sqaure if they are already not revealed, or unflags it if it was already flagged
  if(isFlagged == true && field_cleared[cursorYpos][cursorXpos] == 0) {
    field_cleared[cursorYpos][cursorXpos] = -1;
    isFlagged = false;
    // Adds current curosr position to arraylists
    curFlagX.add(cursorXpos);
    curFlagY.add(cursorYpos);
  } else if(isFlagged == true && field_cleared[cursorYpos][cursorXpos] == -1) {
    field_cleared[cursorYpos][cursorXpos] = 0;
    isFlagged = false;
    // Removes the current square from the flag arraylist
    for(int i = curFlagX.size() - 1; i >= 0; i--) {
      if(curFlagX.get(i) == cursorXpos && curFlagY.get(i) == cursorYpos) {
        curFlagX.remove(i);
        curFlagY.remove(i);
      }
    } 
  }
  
  // Checks for a revealed mine and then runs end game sequence if it finds one
  if(field[cursorYpos][cursorXpos] == -1 && field_cleared[cursorYpos][cursorXpos] == 1) {
      endGame();
  }
  
  
  
  // Looks for any key presses and updates cursor
  if(keypress == true && !(field[cursorYpos][cursorXpos] == -1 && field_cleared[cursorYpos][cursorXpos] == 1)) {
    
    // Checks to see if the current square is a mine and ends game if so
    if(field[cursorYpos][cursorXpos] == -1 && field_cleared[cursorYpos][cursorXpos] == 1) {
      endGame();
      
    }
    
    
    // Creates white background for numbers and flag icon
    stroke(190,20,0);
    for(int y = 1; y < 10 * scale; y++) {
      line(cursorXpos * 10 * scale, cursorYpos * 10 * scale + y, (cursorXpos + 1) * 10 * scale, cursorYpos * 10 * scale + y);
    }
    
    // Checks to see if the square needs to be updated
    // If it does, it then precedes to draw the number to scale
    if(field_cleared[cursorYpos][cursorXpos] == 1) {
      stroke(0);
      
      
      // Gets data for drawing the current number
      int[][] temp1 = numdata[field[cursorYpos][cursorXpos]];
      
      // Never want to do this again (but probably will)
      spriteDraw(temp1, cursorXpos, cursorYpos);
      
    } else if(field_cleared[cursorYpos][cursorXpos] == -1) {
      // This is only run if the square is flagged
      stroke(0);
      
      spriteDraw(flag, cursorXpos, cursorYpos);
    }
      
    if(oldcursorX != cursorXpos || oldcursorY != cursorYpos) {
      // Restores previous icon to old cursor position
      stroke(0);
      for(int y = 1; y < 10 * scale; y++) {
        line(oldcursorX * 10 * scale + 1, oldcursorY * 10 * scale + y, (oldcursorX + 1) * 10 * scale - 1, oldcursorY * 10 * scale + y);
      }
      
      if(field_cleared[oldcursorY][oldcursorX] == 1) {
        stroke(255);
        
         // Gets data for drawing the current number
        int[][] temp1 = numdata[field[oldcursorY][oldcursorX]];
        
        spriteDraw(temp1, oldcursorX, oldcursorY);
        
      } else if(field_cleared[oldcursorY][oldcursorX] == -1) {
        // This is only run if the square is flagged
        stroke(255);
        spriteDraw(flag, oldcursorX, oldcursorY);
      }
    }
    keypress = false;
  }
}

// Checks to see if the current flagged sqaures match up with the sqaures with mines
void checkFlag() {
  boolean correct = false;
  // Checks to see if both flag arraylists have the same number of elements
  // They cannot match if this condition is not met
  if(curFlagX.size() == finFlagX.size()) {
  boolean found = false;
    for(int i = 0; i < curFlagX.size(); i++) {
      for(int j = 0; j < finFlagX.size(); j++) {
        if(curFlagX.get(0) == finFlagX.get(0) && curFlagY.get(0) == finFlagY.get(0)) {
          found = true;
        }
      }
      if(found == false) { 
        correct = false;
      }
    }
  }
  if(correct == true) {
    endGame();
  }
}
  

// Space clearing function that effectively finds all spaces connected to each other within an a single block radius
void clearSpaces() {
  stroke(255);
  // Stores the spaces that still need to be checked
  ArrayList<Integer> checkarrX = new ArrayList<Integer>(0);
  ArrayList<Integer> checkarrY = new ArrayList<Integer>(0);
  int Xpos;
  int Ypos;
  checkarrX.add(0, cursorXpos);
  checkarrY.add(0, cursorYpos);
  while(checkarrX.size() > 0 || checkarrX.size() > 0) {
    Xpos = checkarrX.get(0);
    Ypos = checkarrY.get(0);
    if(field_cleared[Ypos][Xpos] != 1 && field[Ypos][Xpos] == 0) {
      // Adds every empty cell to checkarr, excluding cells that dont exist (ex. x = -1)
      field_cleared[Ypos][Xpos] = 1;
      if(Ypos != 0) {
        checkarrY.add(0, Ypos - 1);
        checkarrX.add(0, Xpos);
        if(Xpos != 0) {
          checkarrY.add(0, Ypos - 1);
          checkarrX.add(0, Xpos - 1);
        }
        if(Xpos != FIELD_WIDTH - 1) {
          checkarrY.add(0, Ypos - 1);
          checkarrX.add(0, Xpos + 1);
        }
      }
      
      if(Ypos != FIELD_HIEGHT - 1) {
        checkarrY.add(0, Ypos + 1);
        checkarrX.add(0, Xpos);
        if(Xpos != 0) {
          checkarrY.add(0, Ypos + 1);
          checkarrX.add(0, Xpos - 1);
        }
        if(Xpos != FIELD_WIDTH - 1) {
          checkarrY.add(0, Ypos + 1);
          checkarrX.add(0, Xpos + 1);
        }
      }
      if(Xpos != 0) {
        checkarrY.add(0, Ypos);
        checkarrX.add(0, Xpos - 1);
      }
      if(Xpos != FIELD_WIDTH - 1) {
        checkarrY.add(0, Ypos);
        checkarrX.add(0, Xpos + 1);
        checkarrY.add(0, Ypos);
        checkarrX.add(0, Xpos + 1);
      }
      
    }
    field_cleared[Ypos][Xpos] = 1;
    spriteDraw(numdata[field[Ypos][Xpos]], Xpos, Ypos);
    checkarrX.remove(0);
    checkarrY.remove(0);
  }
  
}



// Draws a 5x5 array at the given cursor position and scale
void spriteDraw(int[][] arr, int ix, int iy) {
  for(int i = 0; i < 5; i++) {
    for(int j = 0; j < 5; j++) {
      if(arr[j][i] != 0) {
        // point(cursorXpos * 10 * scale + i + 3, cursorYpos * 10 * scale + j + 3);
        for(int x = 0; x < scale; x++) {
          for(int y = 0; y < scale; y++) {
            point(ix * 10 * scale + i * scale + x + 3 * scale, iy * 10 * scale + j * scale + y + 3 * scale);
          }
        }
      }
    }
  }
}

void keyPressed() {
  oldcursorX = cursorXpos;
  oldcursorY = cursorYpos;
  isRevealed = false;
  isFlagged = false;
  if(keyCode == UP && cursorYpos > 0) {
    cursorYpos--;
    keypress = true;
  }
  if(keyCode == DOWN && cursorYpos < FIELD_HIEGHT - 1) {
    cursorYpos++;
    keypress = true;
  }
  if(keyCode == LEFT && cursorXpos > 0) {
    cursorXpos--;
    keypress = true;
  }
  if(keyCode == RIGHT && cursorXpos < FIELD_WIDTH - 1) {
    cursorXpos++;
    keypress = true;
  }
  if(key == 'q') {
    isRevealed = true;
    keypress = true;
  }
  if(key == 'w') {
    isFlagged = true;
    keypress = true;
  }
  
}


void fieldGen(int n) {
  int count = 0;
  int x;
  int y;
  
  while(count < n) {
    // Generate a random position on the field
    y = int(random(0, FIELD_HIEGHT));
    x = int(random(0, FIELD_WIDTH));
    
    // Checks to see whether there is alreadx a mine there
    if(field[y][x] == -1) {
      count--;
    } else {
      // Adds mine postion to final flag arraxlist
      finFlagY.add(x);
      finFlagX.add(y);
      // Adds 1 to everx cell around it, eycluding cells that dont eyist (ey. y = -1)
      field[y][x] = -1;
      if(y != 0) {
        if(field[y - 1][x] != -1) {
          field[y - 1][x]++;
        }
        if(x != 0 && field[y - 1][x - 1] != -1) {
          field[y - 1][x - 1]++;
        }
        if(x != FIELD_WIDTH - 1 && field[y - 1][x + 1] != -1) {
          field[y - 1][x + 1]++;
        }
      }
      if(y != FIELD_HIEGHT - 1) {
        if(field[y + 1][x] != -1) {
          field[y + 1][x]++;
        }
        if(x != 0 && field[y + 1][x - 1] != -1) {
          field[y + 1][x - 1]++;
        }
        if(x != FIELD_WIDTH - 1 && field[y + 1][x + 1] != -1) {
          field[y + 1][x + 1]++;
        }
      }
      if(x != 0 && field[y][x - 1] != -1) {
        field[y][x - 1]++;
      }
      if(x != FIELD_WIDTH - 1 && field[y][x + 1] != -1) {
        field[y][x + 1]++;
      }
    }

    
    count++;
  }
  printField(field);
}

// Only used for testing purposes. Will not be produced in final version
void printField(int[][] arr) {
  for(int i = 0; i < arr.length; i++) {
    for(int j = 0; j < arr[0].length; j++) {
      if(arr[i][j] == -1) {
        print("X ");
      } else {
        print(arr[i][j] + " ");
      }
      
    }
    println();
  }
  
}

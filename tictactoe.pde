/**
 * @author iosif miclaus
 */

boolean redrawGame;
float millisSinceMessage = 0;
//int lastCursor = HAND;

int rows = 3;
int cols = rows;
int axes = 2;

int[][] fieldStatus = new int[rows][cols];
int[][][] fieldPos = new int[rows][cols][axes];
int fieldWidth = 100;
int fieldHeight = fieldWidth;

// font settings
int big = (fieldWidth * 62) / 80;
PFont bigFont = createFont("Monaco", big);
PFont smallFont = createFont("Monaco", 16);

// player
int players = 2;
String[] playerName = new String[players + 1];  // pos 0 not used !!!
int[] score = {0, 0, 0};                      // pos 0 not used !!!
// which player starts
int round = round( random(1, players));

// the message sent by the game to give the players information about what just happened 
String message = "";

void setup() {
  noLoop();
  size(fieldWidth * rows + 1, fieldHeight * (cols + 1));
  background(0);
  redrawGame = true;
  //cursor(HAND);
  
  // init player names
  playerName[1] = "X";
  playerName[2] = "0";
  
  // init fields
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      // status, pos x, pos y
      fieldStatus[row][col] = 0;
      fieldPos[row][col][0] = row * fieldWidth;
      fieldPos[row][col][1] = col * fieldHeight;
    }
  }
  
  // default font settings
  textAlign(CENTER);
  textFont(bigFont);
}

void draw() {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      // redraw the field first
      fill(250);
      rect(fieldPos[row][col][0], fieldPos[row][col][1], fieldWidth, fieldHeight);
      
      String player = "";
      if ( fieldStatus[row][col] == 0 ) {
        // what to do?
        rect(fieldPos[row][col][0], fieldPos[row][col][1], fieldWidth, fieldHeight);
      } 
      else if ( fieldStatus[row][col] == 1 ) {
        fill(200, 50, 50);
      }
      else if ( fieldStatus[row][col] == 2 ) {
        fill(50, 50, 200);
      }
      
      player = (fieldStatus[row][col] != 0) ? playerName[fieldStatus[row][col]] : "";
      text(player, fieldPos[row][col][0], fieldPos[row][col][1], fieldWidth, fieldHeight);
    }
  }
  
  // draw a black "ribbon" over the old drawn text
  fill(0);
  rect(0, fieldHeight * rows, fieldWidth * cols, fieldHeight);
  
  // draw player score and message
  fill(255);
  textFont(smallFont);
  // draw score
  String scoreStr = "Player " + playerName[1] + " = " + score[1] + " | Player " + playerName[2] + " = " + score[2];
  text(scoreStr, 0, fieldHeight * cols + fieldHeight / cols / 2, fieldWidth * rows, fieldHeight);
  // draw message
  fill(0, 250, 0);
  text(message, 0, fieldHeight * cols + fieldHeight / cols * 2, fieldWidth * rows, fieldHeight);
  
  // "remove" text (after mousemove)
  message = "";
  redraw();
  
  // reset to standard font setting
  textFont(bigFont);
}

void mouseClicked() {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      if ( mouseX >= fieldPos[row][col][0] 
        && mouseY >= fieldPos[row][col][1] 
        && mouseX <= fieldPos[row][col][0] + fieldWidth 
        && mouseY <= fieldPos[row][col][1] + fieldHeight
      ) {
        if ( fieldStatus[row][col] != 0 ) {
          //println("You can't draw here!");
          message = "You can't draw here!";
          redrawGame = false;
        } 
        else {
          fieldStatus[row][col] = round;
          
          String player = "";
          if ( round == 1 ) {
            fill(200, 50, 50);
            round = 2;
          } 
          else if ( round == 2 ) {
            fill(50, 50, 200);
            round = 1;
          } 
          else {
            noFill();
          }
          
          if ( round == 1 || round == 2 ) {
            player = playerName[round];
          } else {
            player = "";
          }
          
          player = ( round == 1 || round == 2 ) ? playerName[round] : "";
          text(player, fieldPos[row][col][0], fieldPos[row][col][1], fieldWidth, fieldHeight);
          
        }
      }
    }
  }
  
  // check if someone one won
  checkWinner();
}


void mouseMoved() {
  // set correct cursor at correct position
  //int currentCursor = HAND;
  if ( mouseY <= fieldHeight * rows /*&& lastCursor == ARROW*/ ) {
    cursor(HAND);
    //currentCursor = HAND;
  } 
  else if ( mouseY > fieldHeight * rows /*&& lastCursor == HAND*/ ) {
    cursor(ARROW);
    //currentCursor = ARROW;
  }
  
  /*if ( lastCursor != currentCursor ) {
    redraw();
  } else {
    lastCursor = currentCursor;
  }*/
  
  redraw();
}


void checkWinner() {
  boolean noWinner = false;
  
  for (int p = 1; p <= players; p++) {
    if ( (fieldStatus[0][0] == p && fieldStatus[0][1] == p && fieldStatus[0][2] == p)
      || (fieldStatus[1][0] == p && fieldStatus[1][1] == p && fieldStatus[1][2] == p)
      || (fieldStatus[2][0] == p && fieldStatus[2][1] == p && fieldStatus[2][2] == p)
      || (fieldStatus[0][0] == p && fieldStatus[1][0] == p && fieldStatus[2][0] == p)
      || (fieldStatus[0][1] == p && fieldStatus[1][1] == p && fieldStatus[2][1] == p)
      || (fieldStatus[0][2] == p && fieldStatus[1][2] == p && fieldStatus[2][2] == p)
      || (fieldStatus[0][0] == p && fieldStatus[1][1] == p && fieldStatus[2][2] == p) 
      || (fieldStatus[0][2] == p && fieldStatus[1][1] == p && fieldStatus[2][0] == p)
    ) {
      // increase score of the winner
      score[p]++;
      
      //println("Player " + p + " won!");
      message = "Player " + playerName[p] + " won!";
      
      setup();
    }
    else {
      noWinner = true;
    }
  }
  
  if (noWinner) {
    int setFieldsCount = 0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if ( fieldStatus[row][col] != 0 ) {
          setFieldsCount++;
        } else {
         break;
        }
      }
    }
    
    if ( setFieldsCount == rows * cols ) {
      //println("Draw game!");
      message = "Draw game!";
      setup();
    }
  }
  
  if (redrawGame) {
    redraw();
  } else {
    redrawGame = true;
  }
}


import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    setMines();
}
public void setMines()
{   while(mines.size() < NUM_ROWS * NUM_COLS/7){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[row][col])){
        mines.add(buttons[row][col]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(!mines.contains(buttons[r][c])){
          if(!buttons[r][c].isClicked()){
            return false;
          }
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c].setLabel("L");
      }
    }
    noLoop();
}
public void displayWinningMessage()
{
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c].setLabel("W");
      }
    }
    noLoop();
}
public boolean isValid(int r, int c)
{
    if(r < 0 || c < 0 || r >= NUM_ROWS || c >= NUM_COLS){
      return false;
    }
    return true;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = -1; r <= 1; r++){
      for(int c = -1; c <= 1; c++){
        if(r != 0 || c != 0){
          if(isValid(row + r, col + c)){
            if(mines.contains(buttons[row+r][col+c])){
              numMines += 1;
            }
          }
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(!flagged){
            clicked = false;
          }
        } else if(mines.contains(this)) {
          displayLosingMessage();
        } else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        } else {
          for(int r = -1; r <= 1; r++){
            for(int c = -1; c <= 1; c++){
              if(r != 0 || c != 0){
                if(isValid(myRow + r, myCol + c)){
                  if(!buttons[myRow + r][myCol + c].isFlagged() && !buttons[myRow + r][myCol + c].isClicked()){
                    buttons[myRow + r][myCol + c].mousePressed();
                  }
                }
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked() {
      return clicked;
    }
}

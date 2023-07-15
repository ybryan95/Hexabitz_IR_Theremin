/* HEXABITZ IR THEREMIN TEAM: Ryan Cho, Geoffrey Powell-Isom, Scott Bryar, Patricia Fang
*  Date: 2020-08-16
*  Read comments at setup() to run the software without COM connections to modules
*  
*  Instruction:
*  If using COM connections to module, use STL Flash software to install the following files to 
*  each of the corresponding modules.
*  FilePath: H08R6 Firmware (ver2)\MDK-ARM\Objects\H08R6-Module 1
*  FilePath: H08R6 Firmware (ver2)\MDK-ARM\Objects\H08R6-Module 2
*  
*  Use the instructions on hackster.io and Hexabitz tutorials 
*  to enable a module connection for more than 2 modules. 
*  
*/

import processing.serial.*; //import the serial library
import processing.sound.*;  //import the sound  library
import ddf.minim.*; //import the Minim sound library, because it's reported less buggy

Serial myPort;  // Create object from Serial class
String portName = "COM5"; //change this if you use different COM port
String myString; //variable used to read message from serial port
char module; //a character received from module when a module is struck (different char for every modules)
int nl = 10; //delimiter to read indents between read serial messages


//Sound setup (Another option to play sound)
Minim minim;

//Sound Files &Variables (Activate IR Theremin)
SoundFile[] file;
int first_onecount = 0;
int second_onecount = 0;
boolean atmakesound;

//Sound Files &Variables (soundTest)
SoundFile[] file1;
int tomTom_onecount = 0;
int hihat_onecount = 0;
int timpaniPlay_onecount = 0;
int cymballPlay_onecount = 0;
int voicePlay_onecount = 0;
boolean tomTomPlay;
boolean hiHatPlay;
boolean timpaniPlay;
boolean cymbalPlay;
boolean voicePlay;
boolean atSoundTest;


int instrumentLimit = 5; //not limiting this can allow a slowdown bug in the audio that loops for a very long time, maybe infinitely

//CLI setup
PFont f;
StringBuilder screenBuffer = new StringBuilder();
byte lineLength;
byte lineCount;


StringBuilder keyboardInputBuffer = new StringBuilder();
String        inputBackup;
boolean inputReady  = false;
boolean newKeyPress = false;

void setup() {
  size(900, 600);
  background(0);
  
  // Create the font
  printArray(PFont.list());
  f = createFont("SourceCodePro-Regular.ttf", 18);
  textFont(f);
  textAlign(TOP, LEFT);
  
  
  //Engage communication with module 
  myPort = new Serial(this, portName,921600);      //comment out this line and a line under to run without serial communication (i.e. COM not connected to module)
  serialWrite("\r");                               //comment out this line and a line above to run without serial communication (i.e. COM not connected to module)
  
  //file(.wav) array for Activate IR Theremin
  //The size of the file is equal to number of modules set up. (for this code, 2 modules is used)
  file = new SoundFile[2];
  file[0] = new SoundFile(this, "CrashCymbal.wav");//Change the name of the "CrashCymbal.wav" in order to swap sound files
  file[1] = new SoundFile(this, "TomTom.wav");
  
  
  //file(.wav) array for soundTest
  file1 = new SoundFile[5];
  file1[0] = new SoundFile(this, "TomTom.wav");
  file1[1] = new SoundFile(this, "HiHat.wav");
  file1[2] = new SoundFile(this, "timpani-single-hit-sound-effect.wav");
  file1[3] = new SoundFile(this, "CrashCymbal.wav");
  file1[4] = new SoundFile(this, "voice.wav");

  
  
  NewMain main01=new NewMain();  
  Thread t1 =new Thread(main01);  
  t1.start();  
} 

void draw() {
  background(0);

  // Set the left and top margin
  int margin = 3;
  translate(margin*4, margin*4);

        fill(255);

      // Draw the letter to the screen
      text(screenBuffer.toString(), 0, 0);

      /* At 'start' if Activate IR Theremin(is selected) make infinite loop turn on (turned off by pressing 7 at the main menu, which is Deactive IR Theremin)
      *  Functionalities: Read string messages separated by '\n' from the first module connection via COM port
      *  Then, retrieve the first character of the string message
      *  Play the corresponding sound from 'file', which is a wav array 
      *  Sound Processing: (1) Capable of overlapping multiple sound
      *                    (2) Capable of replaying the sound
      */
      if(atmakesound == true){
                while(myPort.available() >0){
                //serial
                myString = myPort.readStringUntil('\n');
                if(myString == null){
                }
                else{ 
                  module = myString.charAt(0);
                  println(module);
                }
                 //sound
                
                if(file[0].isPlaying() == false){
                  first_onecount = 0;    
                }
                else{
                  first_onecount++;
                }
                
                if(file[1].isPlaying() == false){
                  second_onecount = 0;
                }
                else{
                  second_onecount++;
                }
                
                
                playMusic(module);
                delay(10);
                
              }
        
      }
}

///////PUT MAIN PROGRAM CODE IN HERE///////
class NewMain implements Runnable{ public void run(){  
///////START OF MAIN PROGRAM CODE///////
  //for(;;){
  //  //screenBuffer.append("thread is running...");
  //  conprintln("thread is running...");  
  //  conprintln("From: https://stackoverflow.com/questions/1494772/bad-to-use-very-large-strings-java\n"
  //  + "What if the input is larger than the system's memory (e.g. the input is being generated by another computer over an HTTP connection)? If you process one line at a time, you are always making progress, and you will eventually process the entire input, assuming that the input is finite. However, if you wait to see the entire input, before performing any processing, you will run out of memory and break.\n"
  //  + "In general, it is good to process data in a streaming manner. This also applies to performing processing using iterators rather than random-access, when possible. It will allow your program to scale up to very large input sizes, and it also allows your program to be pipelined (i.e. another program can start processing your programs output, while your program is still in the middle of processing its own input). In this day and age of large media transmissions between many different computers, this is almost always a good idea to support.");
  //  //conprintln("In general, it is good to process data in a streaming manner. This also applies to performing processing using iterators rather than random-access, when possible. It will allow your program to scale up to very large input sizes, and it also allows your program to be pipelined (i.e. another program can start processing your programs output, while your program is still in the middle of processing its own input). In this day and age of large media transmissions between many different computers, this is almost always a good idea to support.");
  //  delay(1000);
  //}
  
  NewMainFunction();
///////END OF MAIN PROGRAM CODE///////
}}
///////END OF MAIN CODE SECTION///////

// conprintln prints out string messages on the CLI window
void conprintln(){ conprint("\n");}
void conprintln(String text){ conprint(text + '\n');}
void conprint(String text){
  if(text == null) return;
  for(int i = 0; i < text.length(); ++i) putChar(text.charAt(i));
}

// interacts with screenBuffer to manage length of strings and lines
void putChar(char c){
  if(c != '\n' && lineLength == 80){
    screenBuffer.append('\n');
    lineLength = 0;
    ++lineCount;
  }
  if(c == '\n'){
    lineLength = 0;
    ++lineCount;
  } else {
    ++lineLength;
  }
  screenBuffer.append(c);
  
  if(lineCount > 19){
    while(screenBuffer.toString().charAt(0) != '\n') screenBuffer.delete(0, 1);
    screenBuffer.delete(0, 1);
    --lineCount;
  }
}

// Used to receive message input from the keyboard
String getLine(){
  //while(keyboardInputBuffer.toString().charAt(keyboardInputBuffer.length() - 1) != '\n');
  //while(inputBackup == null);
  StringBuilder input = new StringBuilder();
  while(keyboardInputBuffer.length() == 0 || keyboardInputBuffer.toString().charAt(keyboardInputBuffer.length() - 1) != '\n'){
    if(keyboardInputBuffer.length() > 0){
      input.append(keyboardInputBuffer.charAt(0));
      putChar(keyboardInputBuffer.charAt(0));
      keyboardInputBuffer.delete(0,1);
    }
    delay(1);
  }
  keyboardInputBuffer.delete(0,1);
  putChar('\n');
  //String input = inputBackup;
  inputReady = false;
  return input.toString();
  //return "input";
}

//receives the message from userPrompt and returns it as a string
String prompt(String userPrompt){
  conprint(userPrompt);
  String input = getLine();
  return input;
}

//Hide the characters being typed 
char getCharHidden(){
  while(keyboardInputBuffer.length() == 0) delay(1);
  char input = keyboardInputBuffer.charAt(0);
  keyboardInputBuffer.delete(0,1);
  return input;
}

//clear 
void clearKeyboardBuffer(){
  keyboardInputBuffer.delete(0, keyboardInputBuffer.length());
}


/* At 'start' if soundTest(is selected) make infinite loop turn on (turned off by pressing q)
      *  Functionalities: Read string messages separated by '\n' from the first module connection via COM port
      *  Then, retrieve the first character of the string message
      *  Play the corresponding sound from 'file', which is a wav array 
      *  interacts with keyReleased to manage variable [Syntax: Soundname_onecount]
      *  Sound Processing: (1) Capable of overlapping multiple sound
      *                    (2) Capable of replaying of each sound (i.e. Sound called 'A' is played again while 'A' is playing. In this case, stop playing the previous sound 'A')
      *                   
      */
void keyPressed() {
  
  keyboardInputBuffer.append(key);
  if(atSoundTest == true){
            if (key == '1') { 
            tomTom_onecount++;
            if(file1[0].isPlaying() && tomTom_onecount == 1){
              file1[0].stop();
            }
            if(tomTom_onecount == 1){
              file1[0].play();
            }
          }
          
          else if (key == '2') {
            hihat_onecount++;
            if(file1[1].isPlaying() && hihat_onecount == 1){
              file1[1].stop();
           
            }
            if(hihat_onecount == 1){
              file1[1].play();
            }
          }
          
           else if (key == '3') {
            timpaniPlay_onecount++;
            if(file1[2].isPlaying() && timpaniPlay_onecount == 1){
              file1[2].stop();
           
            }
            if(timpaniPlay_onecount == 1){
              file1[2].play();
            }
          }
          else if (key == '4') {
            cymballPlay_onecount++;
            if(file1[3].isPlaying() && cymballPlay_onecount == 1){
              file1[3].stop();
           
            }
            if(cymballPlay_onecount == 1){
              file1[3].play();
            }
          }
          
          else if (key == '5') {
            voicePlay_onecount++;
            if(file1[4].isPlaying() && voicePlay_onecount == 1){
              file1[4].stop();
           
            }
            if(voicePlay_onecount == 1){
              file1[4].play();
            }
          }
          
      }
  
  
}

// Used for soundTest,
// If key is released, turn onecount variable to 0
void keyReleased() {
  if(atSoundTest == true){
        if(key == '1'){
          tomTom_onecount=0;
        }
         else if(key == '2'){
          hihat_onecount=0;
        }
        else if(key == '3'){
          timpaniPlay_onecount=0;
        }
        else if(key == '4'){
          cymballPlay_onecount=0;
        }
        else if(key == '5'){
          voicePlay_onecount=0;
        }
  }
}

void serialWrite(String content){
  int strLength = content.length();
  for (int i = 0; i<strLength; i++)
  {
    myPort.write(content.charAt(i));
  }
}

void playMusic(char module){
      if (module == '1') {     
            first_onecount++;
            if(file[0].isPlaying() && first_onecount >= 1){
              file[0].stop();
              first_onecount = 1;
            }
            if(first_onecount == 1){
              file[0].play();
            }
      }
  
      else if (module == '2') {
  
           second_onecount++;
            if(file[1].isPlaying() && second_onecount >= 1){
              file[1].stop();
              second_onecount = 1;
            }
            if(second_onecount == 1){
              file[1].play();
            }
      }

}

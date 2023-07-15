void soundTest(){
          boolean running = true;
          atSoundTest = true;
          
          conprintln("          SOUND TEST");
          conprintln("Press buttons for sounds you want to play from the menu, or \"q\" to quit.");
          conprintln();
          conprintln("   1. TomTom");
          conprintln("   2. HiHat");
          conprintln("   3. Timpani");
          conprintln("   4. Cymbal");
          conprintln("   5. voice????");
          conprintln("   q. quit");
          conprintln();
          conprintln("Press the button of your choice!");
           
          while(running){
            switch(getCharHidden()){
              default: break;
              case '1':  break;
              case '2':  break;
              case '3': break;
              case '4': break;
              case '5':  break;
              case 'q': case 'Q': running = false; atSoundTest=false; break;
            }
            clearKeyboardBuffer();
          }
  
}

void NewMainFunction(){
          conprintln("Welcome to the HexaBitz IR Theremin kit!");
          boolean running = true;
          while(running){
          conprintln("          MAIN MENU");
          conprintln("Please select an option from the menu:");
          conprintln();
          conprintln("   1. Activate IR Theremin");
          conprintln("   2. Display Developer Credits");
          conprintln("   3. Display Sound Customization Instructions");
          conprintln("   4. Unknown Task");
          conprintln("   5. Unknown Task");
          conprintln("   6. Sound Test");
          conprintln("   7. Deactivate IR Theremin");
          conprintln();
          String input = prompt("Please enter your choice: " );
          //getLine(input);
          //conprintln("You entered: " + input);
          
          switch(input){
            default: break;
            case "1": atmakesound = true; break;
            case "2": credits(); break;
            case "3": soundInstructions(); break;
            case "4": break;
            case "5": calibrator(); break;
            case "6": soundTest(); break;
            case "7": atmakesound = false; break;
          }
        }
}

void credits(){
  conprintln("HexaBitz IR Theremin Kit was brought to you by:\n"
  + "The HexaBitz IR Theremin Kit Team!\n"
  + "   ** \"Ryan\" Young Beum Cho\n"
  + "   ** Scott Bryar\n"
  + "   ** Patricia Fang\n"
  + "   ** Geoffrey Powell-Isom");
  conprintln();
  prompt("Press enter, to continue...");
}

void soundInstructions(){
  conprintln("HexaBitz IR Theremin Kit sound customization instructions:\n"
  + "The HexaBitz IR Theremin Kit's sounds can be customized by changing the sound files in the HexaBitz IR Theremin Kit source folder.");
  conprintln();
  prompt("Press enter, to continue...");
}

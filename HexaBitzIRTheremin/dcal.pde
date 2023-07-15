   
  final int minDistance =    5; //minimum number of centimeters that are accurate
  final int maxDistance = 1000; //minimum number of centimeters that are accurate

  int calibrator() {
    String input;
    short newMinDistance = minDistance;
    short newMaxDistance = maxDistance;
    char           soundHeard     = 'Y';

    conprintln("\nWelcome to the Distance Calibrator!");
    conprintln("You will need to select a new min and max distance, and then try to trigger the sound in the space that you believe is in that range. The program will then ask if you heard the sound at the right distance. If not, you can adjust it. Of-course, you can exit this mode with \"-1\" at the minimum distance prompt.");

    do {
      do {
        input = prompt("Please enter a minimum distance in cm, or enter 0 to keep " + newMinDistance + ", or -1 to quit: ");
        try{ newMinDistance = Short.valueOf(input);}
        catch(Exception e){ newMinDistance = Short.MIN_VALUE;};
        if (newMinDistance == -1) {
          conprintln("Goodbye!");
          return 0;
        }
      } while (newMinDistance < minDistance || newMinDistance > maxDistance);
      do {
        input = prompt("Please enter a maximum distance in cm, or enter 0 to keep " + newMaxDistance + ": ");
        try{ newMaxDistance = Short.valueOf(input);}
        catch(Exception e){ newMaxDistance = maxDistance + 1;};
      } while (newMaxDistance < minDistance || newMaxDistance > maxDistance);
      if (newMaxDistance <= newMinDistance) {
        conprintln("New maximum distance must be greater than new minimum distance.");
        continue;
      }

      for (short s = 5000; s > 0; --s) {
        if (handSeen()) {
          playNotice();
          break;
        }

      }

      //check for soundHeard

      input = prompt("Did you hear the sound when you expected it? Yes/No: ");
      soundHeard = input.charAt(0);

      switch (soundHeard) {
        case 'Y': case 'y': {
          conprintln("Excellent! Your new min distance is " + newMinDistance + " and your new max distance is " + newMaxDistance);
        } break;
        case 'N': case 'n': {
          conprintln("You should adjust the min and max distances.");
        } break;
        case 'E': case 'e': {
          conprintln("It looks like there was an input error, and I didn't get anything.");
        } break;
        default: {
          conprintln("I didn't understand that. Please enter \"Yes\" or \"No\".");
        } break;
      }
    } while (!(soundHeard == 'Y' || soundHeard == 'y' || soundHeard == 'E' || soundHeard == 'e'));


    return 0;
  }

  public static boolean handSeen() {

    return true;
  }

  public static void playNotice() {
    //PlaySound(
    //    TEXT("timpani-single-hit-sound-effect.wav"),
    //    NULL,//GetModuleHandle(NULL),
    //    SND_ASYNC //| SND_NODEFAULT//
    //    //| SND_FILENAME
    //    | SND_NOSTOP
    //);
  }

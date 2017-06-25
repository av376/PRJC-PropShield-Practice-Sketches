# PRJC-PropShield-Practice-Sketches
Repository of PropShield Sketchs

The Prop Shield is a combination of audio amplifier, LED driver and 10-dof motion sensor with 8MB of flash memory developed and sold by PRJC for their Teensy line of microprocessors.  For more information see https://www.pjrc.com/store/prop_shield.html.

This repository is a series of sketches that I used to test the Prop Shield with Motion Sensors.  Let me warn you that I did not develop any of the sketches in this library.  Most of them were developed by other users on the PRJC forum or are exmaple sketches from a couple of the associated libraries that you can load with Teensyduino.

This readme will document these sketches and my notes in learning a little about the audio and LED capabilities of the Prop Shield.

AUDIO
You will need the Teensy Audio,SD, SerialFlash libraries to run the audio sketches.  So lets start with some basic info that I learned:

1. All .mp3 and .wav files should be converted to 16-bit 44100hz files.  The audio library supports other formats as well: aac, flac and raw.  I used Audacity to do the conversion from mono 22khz.
2. As stated on the product page you have to make sure you turn on the ampifer.  This is done via the following lines in Setup in the Arduino sketch:
```c++
    void setup() {
      pinMode(5, OUTPUT);
      digitalWrite(5, HIGH); // turn on the amplifier
      delay(10);             // allow time to wake up
```
3. Go through the [Audio Library tutorial](https://www.pjrc.com/teensy/td_libs_Audio.html) and learn to use their [Audio Design Tool](https://www.pjrc.com/teensy/gui/index.html) if would definitely help.

    a.  To play mp3, wav or raw files you need to include one of the following lines in the header of sketch:
```c++
      #include <play_sd_mp3.h>
      #include <play_sd_wav.h>
      #include <play_sd_raw.h>
```
    b. In general to use SerialFlash, SD, Audio together the following lines should be included before headers in (a).
```c++
      #include <Audio.h>
      #include <Wire.h>
      #include <SPI.h>
      #include <SD.h>
      #include <SerialFlash.h>
```

The next piece is to establish the a connection between the audio components to get the sounds out.  That's where the design tool comes in and the audio training available.  But anyway by way of example:

Using the playWav output component connect the two channels with a patchcord to a mixer which then goes to the dac.  This is shown in Image 1 in the docs directory. When you select each component it explains what it means and available options.  When you click on Export on the top of the screen the following code is automatically generated for you:
```c++
    #include <Audio.h>
    #include <Wire.h>
    #include <SPI.h>
    #include <SD.h>
    #include <SerialFlash.h>

    // GUItool: begin automatically generated code
    AudioPlaySdWav           playSdWav1;     //xy=86,114
    AudioMixer4              mixer1;         //xy=297,166
    AudioOutputAnalog        dac1;           //xy=447,185
    AudioConnection          patchCord1(playSdWav1, 0, mixer1, 0);
    AudioConnection          patchCord2(playSdWav1, 1, mixer1, 1);
    AudioConnection          patchCord3(mixer1, dac1);
    // GUItool: end automatically generated code
```
Note: you have to add the line #include <play_sd_wav.h> after the SerialFlash library.

Next, in Setup you need to set audiomemory, turn on the amplifier, set the mixer and optionally set the analogreference to external to make it louder.  So in the end your setup looks like:
```c++
void setup() {
  AudioMemory(20); //4
  dac0.analogReference(EXTERNAL);  //plays really loud, may get hissing
                              //if your speakers can't handle it.

  //Set volume
  mixer1.gain(0, 0.5);
  mixer1.gain(1, 0.5);

  delay(2000);

  // Start SD Card
  if (!(SD.begin(BUILTIN_SDCARD))) {
    // stop here, but print a message repetitively
    while (1) {
      Serial.println("Unable to access the SD card");
      delay(500);
    }
  }

  //Start Amplifier
  pinMode(PROP_AMP_ENABLE , OUTPUT);
  digitalWrite(PROP_AMP_ENABLE , HIGH); 
}
```
In the loop you open the file or files and play the file.
```c++
void playFile(const char *filename)
{

  File ff = SD.open(filename);
  Serial.print("Playing file: ");
  Serial.println(filename);  
  
  // Start playing the file.  This sketch continues to
  // run while the file plays.
  playMp31.play(filename);

  // Simply wait for the file to finish playing.
  while (playMp31.isPlaying()) { yield(); }
}


void loop() {
  playFile("odd1.mp3");
  delay(1000);
}

```

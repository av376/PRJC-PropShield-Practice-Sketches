////////////////////////////////////////////////////////////////
//
//  Setups ControlP5 controllers
//
////////////////////////////////////////////////////////////////

void setValues(){

  cp5.addTextfield("SL Press(mb)")
    .setPosition(50,230)    
    .setSize(100, 30)
    .setAutoClear(false)
    .setVisible(true)
    .setValue(str(sea_press));

  cp5.addTextfield("ODO(Y/N)")
    .setPosition(170,290)    
    .setSize(100, 30)
    .setAutoClear(false)
    .setVisible(true)
    .setValue(str(cube_odo));  
    
  cp5.addTextfield("DataFile")
    .setPosition(170,350)    
    .setSize(100, 30)
    .setAutoClear(false)
    .setVisible(true)
    .setValue(str(PrintOutput));     
    
   cp5.addBang("START")
    .setPosition(50, 350)
    .setSize(100, 50)
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER); 
    
    cp5.addTextlabel("textHAS_GPS","GPS AVAIL:",300, 230);
    cp5.addToggle("HAS_GPS",false,350, 230,20,10).setColorActive(color(255, 0, 0)).setColorBackground(color(0,0,0)).setLabel(""); 

    cp5.getController("textHAS_GPS").moveTo("setup");
    cp5.getController("HAS_GPS").moveTo("setup");
    cp5.getController("START").moveTo("setup");
    cp5.getController("DataFile").moveTo("setup");
    cp5.getController("ODO(Y/N)").moveTo("setup");
    cp5.getController("SL Press(mb)").moveTo("setup");
    
    
}

void controlEvent(ControlEvent theEvent) {
  /*   
  if (theEvent.isFrom("GraphWin")) {   
       runSketch( new String[] { "--display=1",
                            "--location=20,50",
                            "--sketch-path=" + sketchPath(""),
                            "" },
                            rollingGraph = new GraphWin() );
  }
  */
  
  if (theEvent.isFrom("START")) {
    sea_press = float(cp5.get(Textfield.class, "SL Press(mb)").getText());
    cube_odo = int(cp5.get(Textfield.class, "ODO(Y/N)").getText());
    PrintOutput = int(cp5.get(Textfield.class, "DataFile").getText());
    cp5.get(Textfield.class, "SL Press(mb)").setVisible(false);
    cp5.get(Textfield.class, "ODO(Y/N)").setVisible(false);
    cp5.get(Textfield.class, "DataFile").setVisible(false);
    cp5.get(Bang.class, "START").setVisible(false);
    cp5.get(Textlabel.class, "textHAS_GPS").setVisible(false);
    cp5.get(Toggle.class, "HAS_GPS").setVisible(false);

    ArtHorFlg = 1;
    drawGraph = 1; 
    delay(5000);
    //cp5.getTab("default").setActive(true);
    myPort.write("z");

    }
    
  //println(calib);
  if(sea_press !=1013.25) {
        seapresscmd ="p" + str((int) (sea_press*100));
   } else {
        seapresscmd = "99";
   }
}

/**
 * Click the button to create the windows.
 * @param button
 */
public void handleButtonEvents(GButton button, GEvent event) {
  //if (button == btnStart) {
  //     runSketch( new String[] { "--display=1",
  //                          "--location=20,50",
  //                         "--sketch-path=" + sketchPath(""),
  //                          "" },
  //                          rollingGraph = new GraphWin() );
  //} else if(button == btnExit) {
  if(button == btnExit) {
    exit();
  }
}
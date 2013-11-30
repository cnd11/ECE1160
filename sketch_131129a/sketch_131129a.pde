import processing.serial.*;
import controlP5.*;
import java.util.*;
import java.io.*;

Serial port;

ControlP5 controlP5;
Textarea myTextarea;

MInterface mi;
MInterface mi1;
MInterface mi2;

MInterface load_mi;
MInterface save_mi;

MasterInterface master;

Hashtable<String, String> noteToMidi;

void setup() {
    size(800,600);
    frameRate(30);
    
    PFont pfont = createFont("arial",11);
    ControlFont font = new ControlFont(pfont, 11);
    
    controlP5 = new ControlP5(this);
    
    controlP5.setFont(font);
    
    mi  = new MInterface(0,  0 , 0, controlP5);
    mi1 = new MInterface(0, 200, 1, controlP5);
    mi2 = new MInterface(0, 400, 2, controlP5);
    
    master = new MasterInterface(400, 0, controlP5);
    
    //print(Serial.list());
    port = new Serial(this, Serial.list()[5], 115200);
    
    noteToMidi = new Hashtable<String, String>();
    selectInput("Select a MIDI file:", "loadMidiConversion" );
}

void draw() {
    background(255);
   
    mi._draw();
    mi1._draw();
    mi2._draw();
    master._draw();
}

public void controlEvent(ControlEvent event) {
  
    if( !event.isController() ) return;
    
    Controller trigger = event.getController();
    String label = trigger.getLabel();
    
    if( label != null && label.startsWith("Save Panel")) {
        
        switch(trigger.getId()) {
            case 0:
                save_mi = mi;
                break;
            case 1:
                save_mi = mi1;
                break;
            case 2:
                save_mi = mi2;
                break;
        }
        selectOutput("Select file to write notes to:", "saveNotesFile");
    } else if(label != null && label.startsWith("Save Master")) {
      println("Save Master");
      selectOutput("Select file to save master config:", "saveMasterConfig");
    
    } else if( label != null && label.startsWith("Load Config") ) {
       switch(trigger.getId()) {
            case 0:
                load_mi = mi;
                break;
            case 1:
                load_mi = mi1;
                break;
            case 2:
                load_mi = mi2;
                break;
        }
        selectInput("Select a sensor config file:", "loadConfig" );
    
    } else if( label != null && label.startsWith("Load Master") ) {
      println("Load Master");
      selectInput("Select a master config file:", "loadMasterConfig" );
      
    } else if( label != null && label.startsWith("Load") ) {
        switch(trigger.getId()) {
            case 0:
                load_mi = mi;
                break;
            case 1:
                load_mi = mi1;
                break;
            case 2:
                load_mi = mi2;
                break;
        }
        selectInput("Select a file to process:", "loadNotesFile" );
        
    } else if( label != null && label.startsWith("Send Config") ) {
      println("SEND");
      port.write("\t");
      port.write("start cmd+data");
      
    } else if( label != null && label.startsWith("Calibrate") ) {
      println("calibrate");
      port.write("\t");
      port.write("CALIBRATE");
      
    }
}

void loadNotesFile(File selection) {
  if( selection != null ) {
      load_mi.loadNotes(selection);
  }
}

void saveNotesFile(File selection) {
  if( selection != null ) {
      load_mi.saveNotes(selection);
  }
}

void loadConfig(File selection) {
  if( selection != null ) {
      load_mi.loadConfig(selection);
  }
}

void loadMasterConfig(File selection) {
  if( selection != null ) {
      master.loadConfig(selection);
  }
}

void saveMasterConfig(File selection) {
  if( selection != null ) {
      master.saveConfig(selection);
  }
}

void loadMidiConversion(File selection) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(selection));
            
            while(reader.ready())
            {
                String line = reader.readLine();
                String [] noteMidi = line.split(" +");
                
                noteToMidi.put(noteMidi[0], noteMidi[1]);
            }
            reader.close();
          
        } catch(Exception e){print("Couldn't load MIDI!");}
}


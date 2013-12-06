import controlP5.*;
import java.util.*;
import java.io.*;

class MasterInterface {
    
    int topLeftX;
    int topLeftY;
    private static final int _WIDTH = 400;
    private static final int _HEIGHT = 600;
    
    Button loadMaster, calibrate, saveConfig, sendConfig;
    
    PFont font_large = createFont("Courier New", 34);
    
    PFont btn_font = createFont("arial", 14);
    ControlFont _btn_font = new ControlFont(btn_font, 14);
    
    MasterInterface(int X, int Y, ControlP5 cp5) {
        topLeftX = X;
        topLeftY = Y;
        

        loadMaster = cp5.addButton("Load Master Config")
                        .setId(0)
                        .setPosition(topLeftX + 230, 100)
                        .setSize(150, 20);
                        
        calibrate = cp5.addButton("Calibrate")
                       .setId(1)
                       .setPosition(topLeftX + _WIDTH / 2 - 40, 200)
                       .setSize(80, 20);
        
        saveConfig = cp5.addButton("Save Master Config")
                        .setId(3)
                        .setPosition(topLeftX + _WIDTH / 2 - 100, 470)
                        .setSize(200, 20);
        
        sendConfig = cp5.addButton("Send Config to Arduino")
                        .setId(4)
                        .setPosition(topLeftX + _WIDTH / 2 - 100, 500)
                        .setSize(200, 20);
                        
        cp5.addSlider("Trigger Sensitivity")
           .setPosition(topLeftX + _WIDTH / 2 - 100, 300)
           .setHeight(20)
           .setWidth(200)
           .setRange(0, 30)
           .setValue(15)
           .setSliderMode(Slider.FLEXIBLE)
           .setColorLabel(0)
           .setColorCaptionLabel(255)
           .setDecimalPrecision(0);
        
        cp5.addSlider("Master Delay")
           .setPosition(topLeftX + _WIDTH / 2 - 100, 350)
           .setHeight(20)
           .setWidth(200)
           .setRange(0, 10)
           .setValue(5)
           .setSliderMode(Slider.FLEXIBLE)
           .setColorLabel(0)
           .setColorCaptionLabel(255)
           .setDecimalPrecision(0);
        
        loadMaster.getCaptionLabel().alignX(CENTER);
        calibrate.getCaptionLabel().alignX(CENTER);
        saveConfig.getCaptionLabel().alignX(CENTER);
        sendConfig.getCaptionLabel().alignX(CENTER);
        
        cp5.getController("Trigger Sensitivity").getCaptionLabel()
                  .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE)
                  .setPaddingX(0);
                  
        cp5.getController("Master Delay").getCaptionLabel()
                  .align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE)
                  .setPaddingX(0);
    }
    
    /**
     * Draw master interface UI.
     */
    void _draw() {
        pushStyle();
        
        noStroke();
        fill(197);
        rect(topLeftX, topLeftY, _WIDTH, _HEIGHT);
        fill(0, 0, 0);
        textFont(font_large);
        text("MASTER CONFIG", topLeftX + 60, topLeftY + 30);
        
        popStyle();
    }
    
    /**
     * Loads a master configuration file.
     * @param file The file to load.
     * @param panels The sub-panels to populate.
     */
    void loadConfig(File file, ArrayList<MInterface> panels) {
        if (file == null) {
            return;
        }
        
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            
            int panelToEdit = 0;
            StringBuilder notes = new StringBuilder();
            
            while (reader.ready()) {
                String line = reader.readLine();
                
                if (line.startsWith("PANEL ")) {
                    try {
                        panelToEdit = Integer.parseInt(line.split(" +")[1]);
                    } catch (Exception e) {
                        println("Extract index " + e);
                        return; 
                    }
                    continue;
                }
                // Use a ',' to delimit the notes | config | ... for each pannel
                String[] panelInfo = line.split(",");
                String notesStr = panelInfo[0];
                String configStr = panelInfo[1];
                
                MInterface panel = panels.get(panelToEdit);
                
                panel.setNoteString(notesStr);
                panel.setConfigString(configStr);
            }
            reader.close();
        } catch (Exception e) {
            println("Error loading master config: " + e);
        }
    }
    
    /**
     * Saves a master configuration file.
     * @param file The file to save.
     * @param panels The sub-panels to save.
     */
    void saveConfig(File selected, ArrayList<MInterface> panels) {
        if (selected == null) {
            return;
        }
        
        try {
            FileWriter fw = new FileWriter(selected);
            // For each pannel
            for (MInterface panel : panels) {
                fw.write("PANEL " + panel.pNum + " CONFIG\n" );
                // Write the note string. Single line "a1 ... e5"
                fw.write(panel.getNoteString());
                // Write panel configs: toggleDelay.getValue(), sensitivity.getValue(), anything eles we might need
                fw.write(",");
                fw.write(panel.getConfigString());
                fw.write("\n");
            }
            
            fw.close();
        } catch (Exception e) {
            println("Error saving master config: " + e);
        }
    }
    
void sendConfig(ArrayList<MInterface> panels, Hashtable<String, String> noteToMidi) {
  String configString = "";
  
   port.write("\t");
   port.write("start cmd+data\n");   
    
  for(MInterface p : panels) {
    for (Textfield tf : p.inputs) {
       if(noteToMidi.containsKey(tf.getText().trim().toUpperCase()))
       {
          configString += " " + noteToMidi.get(tf.getText().trim().toUpperCase());
       } else {
          println("Invalid note " +  tf.getText().trim() + "!");
          return;
       }
    }
    configString += "\n";
  }
  /*
    println(configString);
    port.write("\t");
    port.write("start cmd+data\n"); 
    port.write(configString);
    */
  }
}


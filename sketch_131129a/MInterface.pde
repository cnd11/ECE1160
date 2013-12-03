import controlP5.*;
import java.util.*;
import java.io.*;

/**
 * Class for a single module configuration UI.
 */
class MInterface {

    public static final String SAVE_PANEL = "Save Panel";
    
    private static final int INPUT_ROWS = 3;
    private static final int INPUT_COLS = 4;
    
    private static final int GRID_WIDTH = 400;
    private static final int GRID_HEIGHT = 200;
    
    int topLeftX;
    int topLeftY;
    
    int topLeftXInputs;
    int topLeftYInputs;
    
    int pNum;
    
    int bufferX = 10;
    int bufferY = 7;
    int textfieldW = 25;
    int textfieldH = 25;
    
    color [] colors = { color(204, 236, 239),  color(255, 255, 176), color(255, 183, 197)};
    
    ArrayList<Textfield> inputs = new ArrayList<Textfield>();
    Button saveButton, loadNotesButton, loadConfigButton;
    Toggle toggle;
    Slider toggleDelay, sensitivity;
    
    PFont font_large = createFont("Courier New", 16);
    
    PFont pfont = createFont("arial", 14);
    ControlFont font = new ControlFont(pfont, 14);
    
    /**
     * Constructor.
     * @param X
     * @param Y
     * @param panel
     * @param cp5
     */
    MInterface(int X, int Y, int panel, ControlP5 cp5) {
        topLeftX = X;
        topLeftY = Y;
        pNum = panel;
        
        topLeftXInputs = topLeftX + 30;
        topLeftYInputs = topLeftY + 50;
        
        for (int i = 0; i < INPUT_ROWS ; i++) {
            for (int j = 0; j < INPUT_COLS; j++) {
                
                Textfield tf = cp5.addTextfield("" + pNum + i + j)
                                  .setId(i * INPUT_ROWS + j)
                                  .setFont(font)
                                  .setPosition(topLeftXInputs + j * (textfieldW + bufferX), topLeftYInputs + i * (textfieldH + bufferY) )
                                  .setSize(textfieldW, textfieldH)
                                  .setAutoClear(false)
                                  .setFocus(false)
                                  .setColorLabel(colors[pNum])
                                  .setColorBackground(color(100,100,100,200));
                                  inputs.add(tf);
            }
        }
        
        saveButton = cp5.addButton(SAVE_PANEL + " " + pNum)
                        .setId(pNum)
                        .setPosition(topLeftXInputs + INPUT_COLS * (textfieldW + bufferX) /2  - 50, topLeftYInputs + INPUT_ROWS * (textfieldH + bufferY) + bufferY)
                        .setSize(90, 20);
        
        loadConfigButton = cp5.addButton("Load Config " + pNum)
                              .setId(pNum)
                              .setPosition(GRID_WIDTH/2  + 80, topLeftY + 25)
                              .setSize(100, 20);
        
        loadNotesButton = cp5.addButton("Load " + pNum)
                             .setId(pNum)
                             .setPosition(topLeftX + INPUT_COLS * (textfieldW + bufferX)  - 30, topLeftYInputs - 35)
                             .setSize(50, 20);
        
        toggle = cp5.addToggle("Toggle " + pNum)
                    .setPosition(GRID_WIDTH/2 + 25, topLeftY + 25 )
                    .setSize(20, 20)
                    .setColorLabel(0);
        
        toggle.getCaptionLabel().alignX(CENTER);
       
        toggleDelay = cp5.addSlider("Toggle delay " + pNum)
                         .setPosition(GRID_WIDTH/2 + 25 , topLeftY + GRID_HEIGHT/3 + 20)
                         .setHeight(20)
                         .setWidth(155)
                         .setRange(10, 100)
                         .setValue(55)
                         .setSliderMode(Slider.FLEXIBLE)
                         .setColorLabel(0)
                         .setColorCaptionLabel(255)
                         .setDecimalPrecision(0);
        
        sensitivity = cp5.addSlider("Sensitivity " + pNum)
                         .setPosition(GRID_WIDTH/2 + 25, topLeftY + GRID_HEIGHT/3 + 65)
                         .setHeight(20)
                         .setWidth(155)
                         .setRange(0, 10)
                         .setValue(5)
                         .setSliderMode(Slider.FLEXIBLE)
                         .setColorLabel(0)
                         .setColorCaptionLabel(255)
                         .setDecimalPrecision(0);
                          
        //cp5.getController("Toggle delay " + pNum).getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
        cp5.getController("Toggle delay " + pNum).getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
        cp5.getController("Sensitivity " + pNum).getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
        
        saveButton.getCaptionLabel().alignX(CENTER);
        loadConfigButton.getCaptionLabel().alignX(CENTER);
        loadNotesButton.getCaptionLabel().alignX(CENTER);
    }
    
    /**
     * Draw single module UI.
     */
    void _draw() {
        pushStyle();
        
        noStroke();
        fill(colors[pNum]);
        rect(topLeftX, topLeftY, GRID_WIDTH, GRID_HEIGHT);
        
        rotate(radians(-90));
        fill(0, 0, 0);
        textFont(font_large);
        text("SENSOR GRID " + pNum, -topLeftYInputs - 110,topLeftX + 15);
        rotate(radians(90));
        
        popStyle();
    }
    
    /**
     * Loads musical note values into the 'notes' array.
     */
    void loadNotes(File file) {
        if (file == null) {
            return;
        }
        
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            
            while (reader.ready()) {
                String line = reader.readLine();
                // Split by space characters.
                String [] notes = line.split(" +");
                
                for (int index = 0; index < notes.length; index++) {
                    if (index < inputs.size()) {
                        inputs.get(index).setText(notes[index]);
                    } else {
                        break;
                    }
                }
            }
            reader.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Loads a config file.
     */
    void loadConfig(File file) {
        if (file == null ) {
            return;
        }
        
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            int toggleDelayVal = -1;
            int sensVal = -1;
            
            if (reader.ready()) {
                try {
                    toggleDelayVal = Integer.parseInt(reader.readLine());
                } catch (NumberFormatException nfe) {}
            }
            
            if (reader.ready()) {
                try {
                    sensVal = Integer.parseInt(reader.readLine());
                } catch (NumberFormatException nfe) {}
            }
            
            if (toggleDelayVal != -1) {
                toggleDelay.setValue(toggleDelayVal);
            }
            
            if (sensVal != -1) {
                sensitivity.setValue(sensVal);
            }
            
            reader.close();
        } catch (Exception e) {
            println("DIDNT LOAD CONFIG! " + e);
        }
    }
    
    void saveNotes(File selected) {
        if (selected == null) {
            return;
        }
        // Generate string of all notes in this input grid.
        String noteStr = this.getNoteString();
        try {
        	// Open writer to the selected file.
            FileWriter fw = new FileWriter(selected);
            // Write all notes
            fw.write(noteStr + "\n");
            // Close the file.
            fw.close();
        } catch (Exception e) {
        	e.printStackTrace();
        }
    }
    
    /**
     * Gets a string of all notes in the input grid.
     */
    public String getNoteString() {
        StringBuilder sb = new StringBuilder();
        for (Textfield tf : inputs) {
            sb.append(tf.getText());
            sb.append(" ");
        }
        return sb.toString();
    }
    
    /**
     * Sets values in the input grid using a space-delimited string of notes.
     */
    public void setNoteString(String notes) {
    	// Parse notes by space characters.
        String [] noteArr = notes.split(" +");
        int i = 0;
        // Assign each note to each input in the order it was read.
        for (Textfield tf : inputs) {
        	if (i >= noteArr.length) {
        		// No more parsed notes.
        		break;
        	}
            tf.setText(noteArr[i++]) ;
        }
    }
    
    public String getConfigString() {
    	StringBuilder sb = new StringBuilder();
    	sb.append(String.valueOf(this.toggleDelay.getValue()));
    	sb.append(" ");
    	sb.append(String.valueOf(this.sensitivity.getValue()));
    	return sb.toString();
    }
    
    public void setConfigString(String config) {
        String[] params = config.split(" +");
        if (params.length >= 0) {
        	this.toggleDelay.setValue(Float.parseFloat(params[0]));
        }
        if (params.length >= 1) {
        	this.sensitivity.setValue(Float.parseFloat(params[0]));
        }
    }
}

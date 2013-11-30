import controlP5.*;
import java.util.*;
import java.io.*;

class MInterface {
    
    int inputRows = 3;
    int inputCols = 4;
    
    int topLeftX;
    int topLeftY;
    
    int gridWidth  = 400;
    int gridHeight = 200;
    
    int topLeftXInputs;
    int topLeftYInputs;
    
    int pNum;
    
    int bufferX = 10;
    int bufferY = 7;
    int textfieldW = 25;
    int textfieldH = 25;
    
    color [] colors = { color(204,236,239),  color(255, 255, 176), color(255,183, 197)};
    
    ArrayList<Textfield> inputs = new ArrayList<Textfield>();
    Button saveButton, loadNotesButton, loadConfigButton;
    Toggle toggle;
    Slider toggleDelay, sensitivity;
    
    PFont font_large = createFont("Courier New", 16);
    
    PFont pfont = createFont("arial",14);
    ControlFont font = new ControlFont(pfont, 14);
    
    MInterface(int X, int Y, int panel, ControlP5 cp5) {
        topLeftX = X;
        topLeftY = Y;
        pNum = panel;
        
        topLeftXInputs = topLeftX + 30;
        topLeftYInputs = topLeftY + 50;
        
        for( int i = 0; i < inputRows ; i++) {
            for( int j = 0; j < inputCols; j++) {
                
                Textfield tf = cp5.addTextfield("" + pNum + i + j)
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
        
        saveButton = cp5.addButton("Save Panel " + pNum)
                        .setId(pNum)
                        .setPosition(topLeftXInputs + inputCols * (textfieldW + bufferX) /2  - 50, topLeftYInputs + inputRows * (textfieldH + bufferY) + bufferY)
                        .setSize(90, 20);
        
        loadConfigButton = cp5.addButton("Load Config " + pNum)
                              .setId(pNum)
                              .setPosition(gridWidth/2  + 80, topLeftY + 25)
                              .setSize(100, 20);
        
        loadNotesButton = cp5.addButton("Load " + pNum)
                             .setId(pNum)
                             .setPosition(topLeftX + inputCols * (textfieldW + bufferX)  - 30, topLeftYInputs - 35)
                             .setSize(50, 20);
        
        toggle = cp5.addToggle("Toggle " + pNum)
                    .setPosition(gridWidth/2 + 25, topLeftY + 25 )
                    .setSize(20, 20)
                    .setColorLabel(0);
        
        toggle.getCaptionLabel().alignX(CENTER);
        //toggle.getCaptionLabel().style().marginTop = -12;
        
        toggleDelay = cp5.addSlider("Toggle delay " + pNum)
                         .setPosition(gridWidth/2 + 25 , topLeftY + gridHeight/3 + 20)
                         .setHeight(20)
                         .setWidth(155)
                         .setRange(10, 100)
                         .setValue(55)
                         .setSliderMode(Slider.FLEXIBLE)
                         .setColorLabel(0)
                         .setColorCaptionLabel(255)
                         .setDecimalPrecision(0);
        
        sensitivity = cp5.addSlider("Sensitivity " + pNum)
                         .setPosition(gridWidth/2 + 25, topLeftY + gridHeight/3 + 65)
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
    
    void _draw() {
        pushStyle();
        
        noStroke();
        fill(colors[pNum]);
        rect(topLeftX, topLeftY, gridWidth, gridHeight);
        
        rotate(radians(-90));
        fill(0, 0, 0);
        textFont(font_large);
        text("SENSOR GRID " + pNum, -topLeftYInputs - 110,topLeftX + 15);
        rotate(radians(90));
        
        popStyle();
    }
    
    void loadNotes( File file ) {
        if( file == null ) return;
        
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            int index = 0;
            
            while(reader.ready())
            {
                String note = reader.readLine();
                
                if (index < inputs.size() )
                    inputs.get(index).setText(note);
                else
                    break;
                
                index++;
            }
            reader.close();
        } catch(Exception e){}
    }
    
    void loadConfig( File file ) {
        if( file == null ) return;
        
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            int toggleDelayVal = -1;
            int sensVal = -1;
            
            
            if(reader.ready())
            {
              try {
                toggleDelayVal = Integer.parseInt(reader.readLine());
              } catch (NumberFormatException nfe) {}
            }
            
            if(reader.ready())
            {
              try {
                sensVal = Integer.parseInt(reader.readLine());
              } catch (NumberFormatException nfe) {}
            }
            
            if( toggleDelayVal != -1 )  toggleDelay.setValue(toggleDelayVal);
            if( sensVal != -1 )  sensitivity.setValue(sensVal);
            
            reader.close();
        } catch(Exception e){}
    }
    
    void saveNotes(File selected) {
        if( selected == null) return;
        
        try {
            FileWriter fw = new FileWriter( selected );
            
            for( Textfield tf : inputs)
            {
                fw.write( tf.getText() + "\n");
                
                print( tf.getText() + " ");
            }
            
            fw.close();
        } catch( Exception e ){}
    }
}

import controlP5.*;
import java.util.*;
import java.io.*;

class MasterInterface {
    
    int topLeftX;
    int topLeftY;
    int _width;
    int _height;
    
    Button loadMaster, calibrate, saveConfig, sendConfig;
    
    PFont font_large = createFont("Courier New", 34);
    
    PFont btn_font = createFont("arial",14);
    ControlFont _btn_font = new ControlFont(btn_font, 14);
    
    MasterInterface(int X, int Y, ControlP5 cp5) {
        topLeftX = X;
        topLeftY = Y;
        
        _width = 400;
        _height = 600;
        
        loadMaster = cp5.addButton("Load Master Config")
                        .setId(0)
                        .setPosition(topLeftX + 230, 100)
                        .setSize(150, 20);
        
        calibrate = cp5.addButton("Calibrate")
                       .setId(1)
                       .setPosition(topLeftX + _width / 2 - 40, 200)
                       .setSize(80, 20);
                        
        saveConfig = cp5.addButton("Save Master Config")
                        .setId(3)
                        .setPosition(topLeftX + _width / 2 - 100, 470)
                        .setSize(200, 20);
        
        sendConfig = cp5.addButton("Send Config to Arduino")
                        .setId(4)
                        .setPosition(topLeftX + _width / 2 - 100, 500)
                        .setSize(200, 20);
                        
        cp5.addSlider("Trigger Sensitivity")
           .setPosition(topLeftX + _width / 2 - 100, 300)
           .setHeight(20)
           .setWidth(200)
           .setRange(0, 30)
           .setValue(15)
           .setSliderMode(Slider.FLEXIBLE)
           .setColorLabel(0)
           .setColorCaptionLabel(255)
           .setDecimalPrecision(0);
        
        cp5.addSlider("Master Delay")
           .setPosition(topLeftX + _width / 2 - 100, 350)
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
        
        cp5.getController("Trigger Sensitivity").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
        cp5.getController("Master Delay").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
        
    }
    
    void _draw() {
        pushStyle();
        noStroke();
        fill(197);
        rect(topLeftX, topLeftY, _width, _height);
        fill(0, 0, 0);
        textFont(font_large);
        text("MASTER CONFIG", topLeftX + 60, topLeftY + 30);
        popStyle();
    }
    
    void loadConfig( File file ) {
        if( file == null ) return;
        
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            
            while(reader.ready())
            {
                String x = reader.readLine();
                
               
            }
            reader.close();
        } catch(Exception e){}
    }
    
    void saveConfig(File selected) {
        if( selected == null) return;
        
        try {
            FileWriter fw = new FileWriter( selected );

            fw.close();
        } catch( Exception e ){}
    }
    
}

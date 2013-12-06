import processing.serial.*;
import controlP5.*;
import java.util.*;
import java.io.*;

private static final int INPUT_ROWS = 3;
private static final int INPUT_COLS = 4;


ControlP5 cp5;
Serial port;

ArrayList<Textfield> inputs = new ArrayList<Textfield>();

/**
 * Initializes the control UI.
 */
void setup() {
    size(800, 600);
    frameRate(30);
    
    PFont pfont = createFont("arial", 11);
    ControlFont font = new ControlFont(pfont, 11);
    
    cp5 = new ControlP5(this);
    cp5.setFont(font);
    
    initSerial();
    
    initUI();    
}

private static final int EID_SEND = 22;

/**
 * Initialize UI elements.
 */
private void initUI() {
    Button sendButton = cp5.addButton("Send Config")
                    .setId(EID_SEND)
                    .setPosition(230, 100)
                    .setSize(150, 20);
    
    int topLeftXInputs = 30;
    int topLeftYInputs = 20;
    int textfieldW = 30;
    int textfieldH = 20;
    int bufferX = 10;
    int bufferY = 7;
    
    int rawNote = 60;
    for (int i = 0; i < INPUT_ROWS ; i++) {
        for (int j = 0; j < INPUT_COLS; j++) {
            
            Textfield tf = cp5.addTextfield("" + i + j)
                              .setId(i * INPUT_ROWS + j)
                              .setText(String.valueOf(rawNote))
                              .setFont(cp5.getFont())
                              .setPosition(topLeftXInputs + j * (textfieldW + bufferX), 
                                           topLeftYInputs + i * (textfieldH + bufferY))
                              .setSize(textfieldW, textfieldH)
                              .setAutoClear(false)
                              .setFocus(false)
                              .setColorBackground(color(100,100,100,200));
                              
            inputs.add(tf);
            
            rawNote += 2;
        }
    }
}

/**
 * Draws all panels and master.
 */
void draw() {
    background(255);
    //master._draw();
}

/**
 * Responds to events from UI control elements.
 * @param event The event information.
 */
public void controlEvent(ControlEvent event) {
    if (!event.isController()) {
        // If this is just a slider value change or other non-controller event, then return
        return;
    }
    //println("Got controlEvent -> " + event);
    
    if (event.getId() == EID_SEND) {
        sendConfig();
    }
}

/**
 * Sends data in the input grid over the serial connection as a config command.
 */
void sendConfig() {
    int[] cfgData = new int[12];
    int t = 0;
    for (Textfield tf : inputs) {
        int intValue = 0;
        try {
            intValue = Integer.parseInt(tf.getText());
        } catch (NumberFormatException e) {
            println("ERROR " + e);
        }
        cfgData[t++] = intValue;
    }
    
    // Write start config character.
    port.write('\t');
    // Write integers to use for MIDI note values.
    for (int i = 0; i < cfgData.length; i++) {
        port.write(cfgData[i]);
    }
}

void initSerial() {
    String[] serialPorts = Serial.list();
    //println(serialPorts);
    port = new Serial(this, serialPorts[5], 115200);
}

/**
 * This is just an easy way to monitor for serial data and print it out.
 * Do not use serialEvent() for capturing packets of data, since it tends
 * to stop mid-stream.
 */
void serialEvent(Serial p) { 
    String inString = p.readString();
    println("FROM DEVICE: " + inString);
}

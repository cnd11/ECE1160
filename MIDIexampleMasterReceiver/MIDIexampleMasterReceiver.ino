// MultiButtonMIDI.ino
// Driving MIDI using a Multiple Buttons
// Rob Ives 2012
// This code is released into the Public Domain.

#include <MIDI.h>
#include <Serial.h>
#include <Wire.h>


short pinval[12];
short pinvalB[8];
boolean pinon[12];
boolean pinonB[12];
boolean pintog[12]={1,1,1,1,1,1,1,1,1,1,1,1};
boolean pintogB[12]={1,1,1,1,1,1,1,1,1,1,1,1};
boolean lastval;
boolean lastvalB;
int keyval[12]={65,59,57,69,67,60,62,64,70,71,72,73};
byte icdata [16];
byte icdataB [24];
int allPanelsData[3][12];

 int *calibrateAr;
 
 String command = "";
 
void  setup() //The Setup Loop
{
    
  calibrateAr = (int *)malloc( 12 * sizeof(int));
    MIDI.begin(); //initialise midi library
    delay(1000);
    Serial.begin(115200);
    delay(500);
    Wire.begin();
    delay(500);
    
    calibrate();
}
//---------------------------------------------
void loop() //the main loop
{
    
    getPanelData(1,allPanelsData[0]);
    generateMidi(1,allPanelsData[0]);
    
    getPanelData(2,allPanelsData[1]);
    generateMidi(2,allPanelsData[1]);
    
    getPanelData(3,allPanelsData[2]);
    generateMidi(3,allPanelsData[2]);
    
    delay(50);
    
    /*
    getPanelData(2,all_datat[1]);
    
    getPanelData(3,all_datat[2]);
    /*
    
    
   
    delay(20);
    for(i=0; i<12; i++)
    {
        pinval [i]=sensordB[i];
        pinvalB[i]=sensord[i];
        
        
        lastval=pinon[i];
        lastvalB=pinonB[i];

        pinon[i]=pinval[i]>800;
        pinonB[i]=pinvalB[i]>600;


        pintog[i]= (lastval ^ pinon[i]);
        pintogB[i]=(lastvalB ^ pinonB[i]);
        
    }
  
    /*
    for(i=0; i<12; i++)
    {
        
        //if (pinon[i]){
        if (pinval[i] > 1.1 * calibrateAr[i]){
            if(pintog[i])
                //if(1)
            {
                
              
                MIDI.sendNoteOn(keyval[i],map(pinval[i],750, 1023, 65, 127),1);
                
            }
            
        }
        else
        {
            if(pintog[i]){
                // if(1){
                MIDI.sendNoteOff(keyval[i],127,1);
            
                
            }
            //Leaving here for reference
            //MIDI.sendControlChange(7, map(pinval[i],600, 1023, 0, 127),i%2+1);
        }
    }
    */
    /*
    for(i=0; i<8; i++)
    {
        
        if (pinonB[i]){
            if(pintogB[i])
                //if(1)
            {
                MIDI.sendNoteOn(keyval[i],map(pinvalB[i],750, 1023, 65, 127),2);
                
            }
        }
        else
        {
            if (pintogB[i]){
                //if(1){
                MIDI.sendNoteOff(keyval[i],127,2);
             
                
            }
            //MIDI.sendControlChange(7, map(pinval[i],600, 1023, 0, 127),i%2+1);
        }
    }
    Serial.flush();
    */
}

void checkSerial() { 
  if(Serial.peek() != '\t' ) return;
  
  Serial.read();  // consume '\t'

  delay(10);      // enough delay, ?
  
  while(Serial.available() > 0)
  {
    char inChar = Serial.read();
  
    if(inChar == '\n') break;
      
    if(inChar != '\r') command += inChar;
  
    delay(1);
  }
  
  Serial.flush();
 
   if(command == "start cmd+data") {
      digitalWrite(11, HIGH);
       
       // Parse config data!
       
       delay(4000);
       digitalWrite(11, LOW);
       
     } else if(command == "CALIBRATE") {
       
       digitalWrite(13, HIGH);
       
       calibrate(); // Calibrate here!
       
       delay(4000);
       digitalWrite(13, LOW);
     }
     command = "";
}

void calibrate(PANEL p) {
    byte dataSample [24];
    int i = 0;
  
    Wire.requestFrom(p.addr, 24);    // request 6 bytes from slave device #2
    
    while(Wire.available())    // slave may send less than requested
        dataSample[i++] = Wire.read();
    
    int *intCal =(int*)&dataSample;
    
    for(i=0; i< 12; i++)
      p.data[i] = intCal[i];   
}

void getPanelData(PANEL p) {    //Gets sensor data for one grid
    byte ICdataAsBytes[24];    //Byte Array to get raw bytes
    int i = 0;
  
    Wire.requestFrom(p.addr, 24);    // request 6 bytes from slave device #2
    
    while(Wire.available())    // slave may send less than requested
        ICdataAsBytes[i++] = Wire.read();

    int *tempData =(int*)&ICdataAsBytes;
    
    for( i = 0; i < 12; i++)
        p.data[i] = tempData[i];
}

void generateMidi (PANEL p){
//Turns MIDI Notes on and off accordingly 

        int i;
        for(i=0; i<12; i++)
    {
        
        if (singlePanelData[i]>850){
            //Serial.println(data_array[i]);
            //if(pintogB[i])
                if(1)
            {
                MIDI.sendNoteOn(keyval[i],map(singlePanelData[i],750, 1023, 65, 127),panel_index);
                
            }
        }
        else
        {
           // if (pintogB[i]){
                if(1){
                MIDI.sendNoteOff(keyval[i],127,panel_index);
             
                
            }
            //MIDI.sendControlChange(7, map(pinval[i],600, 1023, 0, 127),i%2+1);
        }
    }
    Serial.flush();
}



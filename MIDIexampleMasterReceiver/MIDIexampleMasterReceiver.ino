// MultiButtonMIDI.ino
// Driving MIDI using a Multiple Buttons
// Rob Ives 2012
// This code is released into the Public Domain.

#include <MIDI.h>
#include <Serial.h>
#include <Wire.h>
#include "panel.h"
#include <string.h>


short pinval[12];
short pinvalB[8];
boolean pinon[12];
boolean pinonB[12];
boolean pintog[12]={1,1,1,1,1,1,1,1,1,1,1,1};
boolean pintogB[12]={1,1,1,1,1,1,1,1,1,1,1,1};
boolean lastval[12]={1,1,1,1,1,1,1,1,1,1,1,1};
boolean lastvalB;
int keyval[12]={65,59,57,69,67,60,62,64,70,71,72,73};
byte icdata [16];
byte icdataB [24];
int allPanelsData[3][12];

 int *calibrateAr;
 
 String command = "";
 
PANEL* Panel1;
PANEL* Panel2;
PANEL* Panel3;
 
void  setup() //The Setup Loop
{
    
  //calibrateAr = (int *)malloc( 12 * sizeof(int));
    MIDI.begin(); //initialise midi library
    delay(1000);
    Serial.begin(115200);
    delay(500);
    Wire.begin();
    delay(500);
      // Serial.println("Print");
    Panel1=(PANEL *)malloc(sizeof(PANEL));
    Panel2=(PANEL *)malloc(sizeof(PANEL));
    Panel3=(PANEL *)malloc(sizeof(PANEL));
    //Setting addresses
    Panel1->addr=1;
    Panel2->addr-=2;
    Panel3->addr=3;
    //Setting channels
    Panel1->channel=1;
    Panel2->channel=2;
    Panel3->channel=3;
    //Setting Toggles
    Panel1->toggle =1;
    Panel2->toggle = 1;
    Panel3->toggle = 1;
    //Setting Keyvalues
    memcpy(Panel1->keyval,keyval,12*sizeof(int));
    memcpy(Panel2->keyval,keyval,12*sizeof(int));
    memcpy(Panel3->keyval,keyval,12*sizeof(int));
    
    memcpy(Panel1->pintog,pintog,12*sizeof(boolean));
    memcpy(Panel2->pintog,pintog,12*sizeof(boolean));
    memcpy(Panel3->pintog,pintog,12*sizeof(boolean));
    
     memcpy(Panel1->lastval,lastval,12*sizeof(boolean));
    memcpy(Panel2->lastval,lastval,12*sizeof(boolean));
    memcpy(Panel3->lastval,lastval,12*sizeof(boolean));
    
    calibrate(Panel1);
    calibrate(Panel2);
    calibrate(Panel3);
    
   
    //Setting tog on values
    
    
    
        /*int addr;
    int channel;
    int toggle_delay;
    double sensitvity;
    int data[12];
    int ambient[12];
    int keyval[12];
    bool pinon[12];
    bool lastval;
    bool toggle;*/
    
    
   // calibrate(Panel);
}
//---------------------------------------------
void loop() //the main loop
{
    //Structs to hold all options for panel
   
    
    
 
    getPanelData(Panel1);

    generateMidi(Panel1);
    
   // getPanelData(Panel2);
    //generateMidi(Panel2);
    
  //  getPanelData(Panel3);
    //generateMidi(Panel3);
    
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
       
       //calibrate(); // Calibrate here!
       
       delay(4000);
       digitalWrite(13, LOW);
     }
     command = "";
}

void calibrate(PANEL* p) {
    byte dataSample [24];
    int i = 0;
  
    Wire.requestFrom(p->addr, 24);    // request 6 bytes from slave device #2
    
    while(Wire.available())    // slave may send less than requested
        dataSample[i++] = Wire.read();
    
    int *intCal =(int*)&dataSample;
    
    for(i=0; i< 12; i++)
      p->ambient[i] = intCal[i];   
}

void getPanelData(PANEL* singlePanel) {
//Gets sensor data for one grid

    //Byte Array to get raw bytes
    byte ICdataAsBytes[24];
    int i = 0;
  
    Wire.requestFrom(singlePanel->addr, 24);    // request 6 bytes from slave device #2
    
    while(Wire.available())    // slave may send less than requested
        ICdataAsBytes[i++] = Wire.read();

    int *tempData =(int*)&ICdataAsBytes;
    
    for( i = 0; i < 12; i++)
        singlePanel->data[i] = tempData[i];
  
}

void generateMidi (PANEL* singlePanel){
//Turns MIDI Notes on and off accordingly 

   int i;
   
   for(i=0; i<12; i++)
    {
      
      //Setting up toggle option:
      if(singlePanel->toggle)
      {
        //only actively set pintog if toggle option is false
        singlePanel->pintog[i]= (singlePanel->lastval[i] ^ (singlePanel->data[i]>850));
      }
      else
      {
        //set pintog to true, so it will be continually sending data
        singlePanel->pintog[i]=1;
       }
        
       
       if (singlePanel->data[i]>singlePanel->ambient[i]*1.10)
       {
            singlePanel->lastval[i]=1;
            if(singlePanel->pintog[i])
            {
              MIDI.sendNoteOn(singlePanel->keyval[i],map(singlePanel->data[i],750, 1023, 65, 127),singlePanel->channel);  
            }
        }
        else
        {
           singlePanel->lastval[i]=0;  
           if (singlePanel->pintog[i])
           {
                MIDI.sendNoteOff(singlePanel->keyval[i],127,singlePanel->channel);  
            }
            //MIDI.sendControlChange(7, map(pinval[i],600, 1023, 0, 127),i%2+1);
        }
    }
    Serial.flush();//note sure why
}



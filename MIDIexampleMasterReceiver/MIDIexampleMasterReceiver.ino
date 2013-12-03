// MultiButtonMIDI.ino
// Driving MIDI using a Multiple Buttons
// Rob Ives 2012
// This code is released into the Public Domain.

#include <MIDI.h>
#include <Serial.h>
#include <Wire.h>


int keyispressed[16]; //Is the key currently pressed?
int noteisplaying[16]; //Is the Note currently playing?
unsigned char data1; //data from chip 1
unsigned char data2; //data from chip 2
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

 int *calibrate = malloc( 12 * sizeof(int));



void  setup() //The Setup Loop
{
    
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
    
    
    Wire.requestFrom(2, 16);    // request 6 bytes from slave device #2
    
    int i;
    i=0;
    while(Wire.available())    // slave may send less than requested
    {
        icdata[i]=Wire.read();
        i++;
    }
    //Serial.print(string(icdata));         // print the character
    // delay(500);
    int *sensord =(int*)&icdata;
    for (i=0; i<8; i++)
    {
        //Serial.print(icdata[2*i]);
        //Serial.println(icdata[2*i+1]);
        //Serial.print(i);
        //Serial.print(" ");
        //Serial.println(sensord[i]);
        
    }
    delay(50);
    
    
    Wire.requestFrom(1, 24);    // request 6 bytes from slave device #2
    
    
    i=0;
    while(Wire.available())    // slave may send less than requested
    {
        icdataB[i]=Wire.read();
        i++;
    }
    //Serial.print(string(icdata));         // print the character
    // delay(500);
    int *sensordB =(int*)&icdataB;
    for (i=0; i<12; i++)
    {
        
        // Serial.print("12guy ");
        
        // Serial.print(i);
        //Serial.print(" ");
        //Serial.println(sensordB[i]);
        
    }
    
    //int i;
    delay(20);
    for(i=0; i<12; i++)
    {
        pinval[i]=sensordB[i];
        pinvalB[i]=sensord[i];
        
        
        lastval=pinon[i];
        lastvalB=pinonB[i];
        //Serial.print("pinoutlast:");
        ///Serial.println(pinon[i]);
        pinon[i]=pinval[i]>800;
        pinonB[i]=pinvalB[i]>600;
        //Serial.println("pinout now:");
        //Serial.print(pinon[i]);
        //Serial.print("Lastval:");
        //Serial.println(lastval);
        //Serial.print("On Now:");
        //Serial.println(pinon[i]);
        pintog[i]= (lastval ^ pinon[i]);
        pintogB[i]=(lastvalB ^ pinonB[i]);
        
    }
    //delay(2000);
    //}
    
    for(i=0; i<12; i++)
    {
        
        //if (pinon[i]){
        if (pinval[i] > 1.1 * calibrate[i]){
            if(pintog[i])
                //if(1)
            {
                
                // Serial.println(keyval[i]);
                MIDI.sendNoteOn(keyval[i],map(pinval[i],750, 1023, 65, 127),1);
                //MIDI.sendNoteOn(i*2+60,map(pinval[i],0, 1023, 0, 127),i%2+1);
            }
            
        }
        else
        {
            if(pintog[i]){
                // if(1){
                MIDI.sendNoteOff(keyval[i],127,1);
                // MIDI.sendNoteOff(i*2+60,0,i%2+1);
                //MIDI.sendNoteOff(i*2+60,0,i%2+1);
                
            }
            //MIDI.sendControlChange(7, map(pinval[i],600, 1023, 0, 127),i%2+1);
        }
    }
    
    for(i=0; i<8; i++)
    {
        
        if (pinonB[i]){
            if(pintogB[i])
                //if(1)
            {
                MIDI.sendNoteOn(keyval[i],map(pinvalB[i],750, 1023, 65, 127),2);
                //MIDI.sendNoteOn(i*2+60,map(pinval[i],0, 1023, 0, 127),i%2+1);
            }
        }
        else
        {
            if (pintogB[i]){
                //if(1){
                MIDI.sendNoteOff(keyval[i],127,2);
                // MIDI.sendNoteOff(i*2+60,0,i%2+1);
                //MIDI.sendNoteOff(i*2+60,0,i%2+1);
                
            }
            //MIDI.sendControlChange(7, map(pinval[i],600, 1023, 0, 127),i%2+1);
        }
    }
    Serial.flush();
}

void calibrate() {
  
  byte dataSample [24];
  
  Wire.requestFrom(2, 24);    // request 6 bytes from slave device #2
   
    i=0;
    while(Wire.available())    // slave may send less than requested
    {
        dataSample[i++]=Wire.read();
    }
    
    int *intCal =(int*)&dataSample;
    
    for(i=0; i< 12; i++)
      calibrate[i] = intCal[i];
    
    
}

//-------------------------------------

//-------------------------------------

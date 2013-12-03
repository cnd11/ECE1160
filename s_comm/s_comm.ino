#define CALIBRATE_PIN 12

String command = "";

int state = LOW;

void setup()
{
  Serial.begin(115200);
 
  while(!Serial) return; 
  
  pinMode(13, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(CALIBRATE_PIN, OUTPUT);
  
  digitalWrite(13, LOW);
  digitalWrite(11, LOW);
  digitalWrite(CALIBRATE_PIN, LOW);
}

void loop()
{

 //Serial.println("busy...");
  
  checkSerial();   // can check in loop or use serialEvent
  
  delay(100);
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
       
       //Parse config data!
       
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

//void serialEvent() {checkSerial();}

void calibrate() {
  
}

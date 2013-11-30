String command = "";

int state = LOW;

void setup()
{
  Serial.begin(115200);
 
  while(!Serial) return; 
  
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}

void loop()
{

 Serial.println("busy...");
  
  checkSerial();   // can check in loop or use serialEvent
  
  delay(10);
}

void checkSerial() 
{
  
  if(Serial.peek() != '\t' ) return;
  
  Serial.read();  // consume '\t'

  delay(10);      // enough delay, I guess?
  
  while(Serial.available() > 0)
  {
    char inChar = Serial.read();
  
    if(inChar == '\n')
    {
      break;
    }else if(inChar != '\r'){
      command += inChar;
    } 
    delay(1);
  }
  Serial.flush();
  
  Serial.println(command);
  
   if(command == "start cmd+data")
     {
       state = !state;
       digitalWrite(13, state);
     }
     
  delay(2000);
     
     command = "";
    
}

//void serialEvent() {checkSerial();}

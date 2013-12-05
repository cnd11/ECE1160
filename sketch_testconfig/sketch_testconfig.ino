// Tests receiving a configuration over serial.

#include <Serial.h>

void setup() { 
    //Initialize serial and wait for port to open:
    Serial.begin(115200);
}

#define BUFF_LEN 100

// Data buffer where serial input is stored.
int buff[BUFF_LEN];

void loop() {
    int tmp = 0;
    
    // Initialize buffer so old data is removed.
    memset(buff, 0, BUFF_LEN);
    
    // Check for data available on serial port.
    int nBytes = Serial.available();
    if (nBytes > 0) {
        // Check for start character.
        tmp = Serial.peek();
        if (tmp == '\t') {
            // Fill buffer with serial input.
            for (int i=0; i < nBytes && i < BUFF_LEN; i++) {
                buff[i] = Serial.read();
            }
            // Return data back through serial to confirm data transmission.
            printReceived(buff, nBytes);
        }
    }
    
    // Repeat loop at 10Hz.
    delay(100);
}

/**
 * Prints data from an array over the serial port.
 * @param arr The array to print.
 * @param len The lenght of the array.
 */
void printReceived(int *arr, int len) {
    Serial.print("Got(");
    Serial.print(len);
    Serial.print("):");
    for (int i=0; i < len; i++) {
        Serial.print(arr[i]);
        Serial.print(" ");
    }
}


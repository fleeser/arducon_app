#include <SoftwareSerial.h>
#include "Servo.h"

const char delimiter = '|';

const int bluetoothTx = 6;
const int bluetoothRx = 7;

const int motor1pin1 = 2;
const int motor1pin2 = 3;
const int motor2pin1 = 4;
const int motor2pin2 = 5;
const int motorEnaPin = 9;
const int motorEnbPin = 10;

SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);

void setup() {
  Serial.begin(9600);
  Serial.println("Serielle Kommunikation gestartet. 👂");

  bluetooth.begin(9600);
  Serial.println("Kommunikation mit Bluetooth-Modul gestartet. 🔵");

  pinMode(motor1pin1, OUTPUT);
  pinMode(motor1pin2, OUTPUT);
  pinMode(motor2pin1, OUTPUT);
  pinMode(motor2pin2, OUTPUT);
  pinMode(motorEnaPin, OUTPUT);
  pinMode(motorEnbPin, OUTPUT);
  Serial.println("Motor-Pins verteilt. 📌");

  digitalWrite(motor1pin1, LOW);
  digitalWrite(motor1pin2, LOW);
  digitalWrite(motor2pin1, LOW);
  digitalWrite(motor2pin2, LOW);
  analogWrite(motorEnaPin, 0);
  analogWrite(motorEnbPin, 0);
  Serial.println("Standards eingestellt. 📌");

  //servo.attach(servoPin);
  //Serial.println("Servo-Pin verteilt. 📌");
}

void loop() {
  if (bluetooth.available()) {
    String command = bluetooth.readStringUntil(delimiter);
    processCommand(command);
  }
}

void processCommand(String command) {
  Serial.println("Verarbeite Kommando: " + command + " 🛂");
  if (isDriveCommand(command)) drive(command);
  else if (command.equals("stop")) stop();
  else if (command.equals("dance")) dance();
  else Serial.println("Unbekanntes Kommando erhalten: " + command + " ⛔");
}

bool isDriveCommand(String command) {
  if (command.length() != 11) return false;
  if (command.charAt(0) != 'F' && command.charAt(0) != 'B') return false;
  if (command.charAt(1) != '_') return false;
  if (!isDigit(command.charAt(2))) return false;
  if (!isDigit(command.charAt(3)) || !isDigit(command.charAt(4)) || command.charAt(5) != '_') return false;
  if (command.charAt(5) != '_') return false;
  if (command.charAt(6) != 'F' && command.charAt(6) != 'B') return false;
  if (command.charAt(7) != '_') return false;
  if (!isDigit(command.charAt(8))) return false;
  if (!isDigit(command.charAt(9)) || !isDigit(command.charAt(10))) return false;
  
  return true;
}

void drive(String command) {
  char leftMotorDirection = command.charAt(0);
  if (leftMotorDirection == 'F') {
    digitalWrite(motor1pin1, HIGH);
    digitalWrite(motor1pin2, LOW);
  } else {
    digitalWrite(motor1pin1, LOW);
    digitalWrite(motor1pin2, HIGH);
  }

  char rightMotorDirection = command.charAt(6);
  if (leftMotorDirection == 'F') {
    digitalWrite(motor2pin1, HIGH);
    digitalWrite(motor2pin2, LOW);
  } else {
    digitalWrite(motor2pin1, LOW);
    digitalWrite(motor2pin2, HIGH);
  }

  String firstNumberStr = command.substring(2, 5);
  int number1 = firstNumberStr.toInt();

  analogWrite(motorEnaPin, number1);

  String secondNumberStr = command.substring(8, 11);
  int number2 = secondNumberStr.toInt();

  analogWrite(motorEnbPin, number2);
}
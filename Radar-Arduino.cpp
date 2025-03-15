//Proyecto RADAR
#include <Servo.h>
const int trigPin = 10;
const int echoPin = 11;
const int potpin = A3; 
const int pulsPin = 8; 
int Velocidad_D = 30;    
int Estado_Boton = 0;
int Valor_Boton = 0;
int UltimaPulsacion = 0;
int Escala = 0;
long duracion;
int distancia;
Servo myServo;
void setup() {
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT);
  pinMode(pulsPin, INPUT);
  Serial.begin(9600);
  myServo.attach(9);
}
void loop() {
  for(int i=15;i<=165;i++){  
    myServo.write(i);
    Velocidad_D = Velocidad();
    delay(Velocidad_D);
    distancia = calculateDistancia();
    Valor_Boton = Conmutar_Boton();
    Serial.print(i); 
    Serial.print(","); 
    Serial.print(distancia);
    Serial.print(",");  
    Serial.print(Valor_Boton);
    Serial.print(".");
  }
  for(int i=165;i>15;i--){  
    myServo.write(i);
    Velocidad_D = Velocidad();
    delay(Velocidad_D);
    distancia = calculateDistancia();
    Valor_Boton = Conmutar_Boton();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distancia);
    Serial.print(",");
    Serial.print(Valor_Boton);
    Serial.print(".");
  }
}

int calculateDistancia() {
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Limitar pulseIn a un máximo de 200 ms para evitar bloqueos largos
  duracion = pulseIn(echoPin, HIGH, 20000);  // 20 ms timeout

  if (duracion == 0) {
    // Si no se recibe señal, puedes retornar una distancia máxima o una señal de error
    return 119;  // O el valor máximo de distancia que uses
  } else {
    distancia = duracion * 0.034 / 2;
    return distancia;
  }
}


int Velocidad(){
  Velocidad_D = analogRead(potpin);
  Velocidad_D = map(Velocidad_D, 0, 1023, 30, 200); 
  return Velocidad_D;
}
int Conmutar_Boton(){
  Estado_Boton = digitalRead(pulsPin);
  if (Estado_Boton == 1 && UltimaPulsacion == 0){
    Escala = (Escala + 1) % 3; // Cambia la escala entre 0 y 3
  }
  UltimaPulsacion = Estado_Boton;
  return Escala;
}

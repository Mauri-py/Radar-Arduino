import processing.serial.*; // importa la librería para la comunicación serial
Serial myPort; // define el objeto Serial
// define variables
String angle = "";
String distance = "";
String Escala = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance, iEscala;
int index1 = 0;
int index2 = 0;

void setup() {
  
  size(1200, 700); // *CAMBIA ESTO A TU RESOLUCIÓN DE PANTALLA*
  smooth();
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); // inicia la comunicación serial
  myPort.bufferUntil('.'); // lee los datos del puerto serial hasta el carácter '.'. Entonces, realmente lee esto: ángulo, distancia, Escala.
}

void draw() {
  
  fill(98,245,31);
  // simulando el desenfoque de movimiento y el desvanecimiento lento de la línea en movimiento
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
  
  fill(98,245,31); // color verde
  // llama a las funciones para dibujar el radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) {
  // Lee los datos desde el puerto serial hasta el carácter '.' y los pone en la variable String "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length() - 1); // Elimina el carácter final '.'
  printArray(data);
  index1 = data.indexOf(","); // Encuentra la primera coma
  angle = data.substring(0, index1); // Ángulo
  data = data.substring(index1 + 1); // Actualiza data eliminando el ángulo

  index2 = data.indexOf(","); // Encuentra la segunda coma
  distance = data.substring(0, index2); // Distancia
  Escala = data.substring(index2 + 1); // Escala

  // Convierte las variables String a enteros usando parseInt()
  iAngle = parseInt(angle);
  iDistance = parseInt(distance);
  iEscala = parseInt(Escala); // Cambié esto a parseInt()

  // Imprime para depuración
  /*println("Distancia: " + iDistance);
  println("Escala: " + iEscala);*/
}



void drawRadar() {
  pushMatrix();
  translate(width/2, height-height*0.074); // mueve las coordenadas de inicio a una nueva ubicación
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // dibuja las líneas de arco
  arc(0, 0, (width-width*0.0625), (width-width*0.0625), PI, TWO_PI);
  arc(0, 0, (width-width*0.27), (width-width*0.27), PI, TWO_PI);
  arc(0, 0, (width-width*0.479), (width-width*0.479), PI, TWO_PI);
  arc(0, 0, (width-width*0.687), (width-width*0.687), PI, TWO_PI);
  // dibuja las líneas de ángulo
  line(-width/2, 0, width/2, 0);
  line(0, 0, (-width/2)*cos(radians(30)), (-width/2)*sin(radians(30)));
  line(0, 0, (-width/2)*cos(radians(60)), (-width/2)*sin(radians(60)));
  line(0, 0, (-width/2)*cos(radians(90)), (-width/2)*sin(radians(90)));
  line(0, 0, (-width/2)*cos(radians(120)), (-width/2)*sin(radians(120)));
  line(0, 0, (-width/2)*cos(radians(150)), (-width/2)*sin(radians(150)));
  line((-width/2)*cos(radians(30)), 0, width/2, 0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width/2, height-height*0.074); // mueve las coordenadas de inicio a una nueva ubicación
  strokeWeight(9);
  stroke(255,10,10); // color rojo
  if (iEscala == 0){
    pixsDistance = iDistance * ((height-height*0.1666) * 0.025); // convierte la distancia del sensor de cm a píxeles
    if (iDistance < 40) {
      line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), (width-width*0.505) * cos(radians(iAngle)), -(width-width*0.505) * sin(radians(iAngle)));
    }
  }
  else if (iEscala == 1){
    pixsDistance = (iDistance/2) * ((height-height*0.1666) * 0.025); // convierte la distancia del sensor de cm a píxeles
    if (iDistance < 80) {
      line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), (width-width*0.505) * cos(radians(iAngle)), -(width-width*0.505) * sin(radians(iAngle)));
    }  
  }
  else if (iEscala == 2){
    pixsDistance = (iDistance/3) * ((height-height*0.1666) * 0.025); // convierte la distancia del sensor de cm a píxeles
    if (iDistance < 120) {
      line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), (width-width*0.505) * cos(radians(iAngle)), -(width-width*0.505) * sin(radians(iAngle)));
    }
  }

  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(width/2, height-height*0.074); // mueve las coordenadas de inicio a una nueva ubicación
  line(0, 0, (height-height*0.12) * cos(radians(iAngle)), -(height-height*0.12) * sin(radians(iAngle))); // dibuja la línea según el ángulo
  popMatrix();
}

void drawText() { // dibuja los textos en la pantalla
  
  pushMatrix();
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  fill(98,245,31);
  textSize(25);

  if (iEscala == 0){
    if (iDistance > 40) {
      noObject = "Fuera de Rango";
    } else {
      noObject = "En Rango";
    }
    text("10cm", width-width*0.3954, height-height*0.0833); //0.3854
    text("20cm", width-width*0.291, height-height*0.0833);  
    text("30cm", width-width*0.187, height-height*0.0833);
    text("40cm", width-width*0.0829, height-height*0.0833);
    if (iDistance < 40) {
      text("        " + iDistance + " cm", width-width*0.225, height-height*0.0150);
    }
  }

  else if (iEscala == 1){
    if (iDistance > 80) {
      noObject = "Fuera de Rango";
    } else {
      noObject = "En Rango";
    }
    text("20cm", width-width*0.3954, height-height*0.0833); //0.3854
    text("40cm", width-width*0.291, height-height*0.0833);  
    text("60cm", width-width*0.187, height-height*0.0833);
    text("80cm", width-width*0.0829, height-height*0.0833);
    if (iDistance < 80) {
      text("        " + iDistance + " cm", width-width*0.225, height-height*0.0150);
    }
  }

  else if (iEscala == 2){
    if (iDistance > 120) {
      noObject = "Fuera de Rango";
    } else {
      noObject = "En Rango";
    }
    text("30cm", width-width*0.3954, height-height*0.0833); //0.3854
    text("60cm", width-width*0.291, height-height*0.0833);  
    text("90cm", width-width*0.187, height-height*0.0833);
    text("120cm", width-width*0.0829, height-height*0.0833);
    if (iDistance < 120) {
      text("        " + iDistance + " cm", width-width*0.225, height-height*0.0150);
    }
  }
  textSize(40);
  text("Berenguer, Benites y Farace", width-width*0.975, height-height*0.0150);
  text("Ángulo: " + iAngle + " °", width-width*0.48, height-height*0.0150);
  text("Dist:", width-width*0.26, height-height*0.0150);


  textSize(25);
  fill(98,245,60);
  translate((width-width*0.4994) + width/2 * cos(radians(30)), (height-height*0.0907) - width/2 * sin(radians(30)));
  rotate(-radians(-60));
  text("30°", 0, 0);
  resetMatrix();
  translate((width-width*0.503) + width/2 * cos(radians(60)), (height-height*0.0888) - width/2 * sin(radians(60)));
  rotate(-radians(-30));
  text("60°", 0, 0);
  resetMatrix();
  translate((width-width*0.507) + width/2 * cos(radians(90)), (height-height*0.0833) - width/2 * sin(radians(90)));
  rotate(radians(0)); 
  text("90°", 0, 0);
  resetMatrix();
  translate(width-width*0.513 + width/2 * cos(radians(120)), (height-height*0.07129) - width/2 * sin(radians(120)));
  rotate(radians(-30));
  text("120°", 0, 0);
  resetMatrix();
  translate((width-width*0.5104) + width/2 * cos(radians(150)), (height-height*0.0574) - width/2 * sin(radians(150)));
  rotate(radians(-60));
  text("150°", 0, 0);
  popMatrix();
}

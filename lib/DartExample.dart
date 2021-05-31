void main(){
  Car BMW = Car(320, 100000, "BMW");
  Car BENZ = Car(250, 70000, "BENZ");
  Car FORD = Car(200, 80000, "FORD");

  BMW.saleCar();
  BMW.saleCar();
  BMW.saleCar();

  print('BMW :: ${BMW.price}');
}



class Car {
  int maxSpeed;
  num price;
  String name;

  Car(int maxSpeed, num price, String name) {
    this.maxSpeed = maxSpeed;
    this.price = price;
    this.name = name;
  }

  num saleCar(){
    price = price * 0.9;
    return price;
  }
}
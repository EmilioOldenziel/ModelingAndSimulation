north = traffic_light(1, 0, []);
east = traffic_light(2, 0, []);
south = traffic_light(3, 0, []);
west = traffic_light(4, 0, []);

car1 = car(1, 3); 
car2 = car(2, 4); 
enqueue(north, car1);
enqueue(north, car2);

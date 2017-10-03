function [ obj ] = randomScheduling(obj, i)
    amount_of_cars = randi(3)-1;
    for s=1:1:amount_of_cars
        %Randomly creates cars in front of the traffic lights
        start = randi(4); 
        direction = randi(4);
        switch start
            case 1
                obj.west = obj.west.enqueue(car(1, direction), i);
            case 2
                obj.east = obj.east.enqueue(car(2, direction), i);
            case 3 
                obj.south = obj.south.enqueue(car(3, direction), i);
            otherwise
                obj.north = obj.north.enqueue(car(0, direction), i);
        end
    end
end
function [ obj ] = randomScheduling(obj, i)
    amount_of_cars = randi(3)-1;
    for s=1:1:amount_of_cars
        %Randomly creates cars in front of the traffic lights
        start = randi(8); 
        direction = randi(4);
        switch start
            case 1
                obj.west = obj.west.enqueue_right(car(1, direction), i);
            case 2
                obj.east = obj.east.enqueue_right(car(2, direction), i);
            case 3 
                obj.south = obj.south.enqueue_right(car(3, direction), i);
            case 4
                obj.north = obj.north.enqueue_right(car(0, direction), i);
            case 5
                obj.west = obj.west.enqueue_left(car(1, direction), i);
            case 6
                obj.east = obj.east.enqueue_left(car(2, direction), i);
            case 7 
                obj.south = obj.south.enqueue_left(car(3, direction), i);
            otherwise
                obj.north = obj.north.enqueue_left(car(0, direction), i);
        end
    end
end
function [ obj, amount_of_cars ] = randomScheduling(obj, i, simsec)
    amount_of_cars = randi(5);
    for s=1:1:amount_of_cars
        %Randomly creates cars in front of the traffic lights
        start = randi(8); 
        switch start
            case 1
                direction = randi(2) + 1; % to east or south
                obj.west = obj.west.enqueue_right(car(1, direction), i);
            case 2
                direction = (randi(2) + 3); % to west or north
                if direction == 5
                    direction = 1; %north
                end
                obj.east = obj.east.enqueue_right(car(2, direction), i);
            case 3
                direction = randi(2); % to north or east
                obj.south = obj.south.enqueue_right(car(3, direction), i);
            case 4
                direction = randi(2) + 2; % to south or west
                obj.north = obj.north.enqueue_right(car(0, direction), i);
            case 5
                direction = 1; % to north
                obj.west = obj.west.enqueue_left(car(1, direction), i);
            case 6
                direction = 3; % to south
                obj.east = obj.east.enqueue_left(car(2, direction), i);
            case 7
                direction = 4; % to west
                obj.south = obj.south.enqueue_left(car(3, direction), i);
            otherwise
                direction = 2; % to east
                obj.north = obj.north.enqueue_left(car(0, direction), i);
        end
    end
end
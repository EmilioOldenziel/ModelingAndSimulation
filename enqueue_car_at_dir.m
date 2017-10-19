function [ inter ] = enqueue_car_at_dir(inter, car, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    switch car.direction_in
        case 1
            if car.direction_out-(car.direction_in -1) == 2
                inter.north =  inter.north.enqueue_left(car, t); 
            else
                inter.north =  inter.north.enqueue_right(car, t);
            end   
        case 2
            if car.direction_out-(car.direction_in -1) == 2
                inter.east =  inter.east.enqueue_left(car, t); 
            else
                inter.east =  inter.east.enqueue_right(car, t);
            end   
        case 3
            if car.direction_out-(car.direction_in -1) == 2
                inter.south =  inter.south.enqueue_left(car, t); 
            else
                inter.south =  inter.south.enqueue_right(car, t);
            end   
        otherwise
            if car.direction_out-(car.direction_in -1) == 2
                inter.west =  inter.west.enqueue_left(car, t); 
            else
                inter.west =  inter.west.enqueue_right(car, t);
            end   
    end
end


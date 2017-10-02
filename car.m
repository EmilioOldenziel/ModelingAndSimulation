classdef car
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    direction_in %coming direction
    direction_out %heading direction
    time_of_arrival %time when the car is enqueued to a particular trafic light
    time_of_passing %time when the car passed the traffic light
    end
    
    methods
        function obj = car(in, out) %constructor of car
            obj.direction_in = in; 
            obj.direction_out = out; 
            obj.time_of_arrival = 0; 
            obj.time_of_passing = 0; 
        end 
    end
end
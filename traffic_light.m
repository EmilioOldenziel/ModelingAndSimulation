classdef traffic_light
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    state %current state (2=green, 1=orange, 0=red)
    queue %queueu of cars in front of light  
    cars_passed %amount of cars that passed the traffic light
    wait_times %queue with time of waiting
    end
    
    methods
        function obj = traffic_light(state)
            obj.state = state;
            obj.queue = []; 
            obj.cars_passed = 0;
            obj.wait_times = [];
        end
        
        function obj = enqueue(obj, car, time_now) %enqueues a car to a particular traffic light
            obj.queue = horzcat(obj.queue, car); 
            car.time_of_arrival = time_now;
        end
        
        function obj = dequeue(obj, time_now)
            if(~isempty(obj.queue) && obj.state == 2)
                car = obj.queue(1);
                obj.queue = obj.queue(2:1:end);
                car.time_of_passing = time_now;
                obj.cars_passed = obj.cars_passed + 1;
                obj.wait_times = horzcat(obj.wait_times, (car.time_of_passing - car.time_of_arrival));
            end
        end
        
        function obj = green(obj)
            if obj.state ~= 2
                obj.state = 2;
            end
        end
        
        function obj = red(obj)
            if obj.state ~= 0
               obj.state = 0;
            end
        end
    end
    
end
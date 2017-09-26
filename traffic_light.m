classdef traffic_light
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    state %current state (2=green, 1=orange, 0=red)
    queue %queueu of cars in front of light  
    cars_passed %amount of cars that passed the traffic light
    end
    
    methods
        function obj = traffic_light(state, queue)
            obj.state = state; 
            obj.queue = queue; 
            fprintf('We have created a traffic light\n');   
        end
        
        function obj = enqueue(obj, car, time_now) %enqueues a car to a particular traffic light
            obj.queue = horzcat(obj.queue, car); 
            car.time_of_arrival = time_now; 
        end
        
        function obj = dequeue(obj, time_now)
            car = obj.queue(1);
            obj.queue = obj.queue(2:1:end);
            car.time_passed = time_now;   
        end
        
        function obj = green(obj)
            if obj.state ~= 0
                obj.state = 2;
            else 
                print("Already on green!"); 
            end
        end
        
        function obj = red(obj)
            if obj.state ~= 2
                obj.state = 0;
            else 
                print("Already on red!"); 
            end
        end
        
    end
    
end
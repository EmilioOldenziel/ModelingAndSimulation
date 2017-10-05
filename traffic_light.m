classdef traffic_light
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    state %current state (2=green, 1=orange, 0=red)
    queue_right %queue of cars that want to go straight or turn right
    queue_left %queue of cars that want to turn left
    cars_passed %amount of cars that passed the traffic light
    wait_times %queue with time of waiting
    end
    
    methods
        function obj = traffic_light(state)
            obj.state = state;
            obj.queue_right= [];
            obj.queue_left = [];
            obj.cars_passed = 0;
            obj.wait_times = [];
        end
        
        function obj = enqueue_left(obj, car, time_now) %enqueues a car to a particular traffic light
            car.time_of_arrival = time_now;
            obj.queue_left = horzcat(obj.queue_left, car); 
        end
        
        function obj = enqueue_right(obj, car, time_now) %enqueues a car to a particular traffic light
            car.time_of_arrival = time_now;
            obj.queue_right = horzcat(obj.queue_right, car); 
        end
        
        function obj = dequeue_left(obj, time_now)
            if(~isempty(obj.queue_left) && obj.state == 2)
                car = obj.queue_left(1);
                obj.queue_left = obj.queue_left(2:1:end);
                car.time_of_passing = time_now;
                obj.cars_passed = obj.cars_passed + 1;
                obj.wait_times = horzcat(obj.wait_times, (car.time_of_passing - car.time_of_arrival));
            end
        end
        
                function obj = dequeue_right(obj, time_now)
            if(~isempty(obj.queue_right) && obj.state == 2)
                car = obj.queue_right(1);
                obj.queue_right = obj.queue_right(2:1:end);
                car.time_of_passing = time_now;
                obj.cars_passed = obj.cars_passed + 1;
                obj.wait_times = horzcat(obj.wait_times, (car.time_of_passing - car.time_of_arrival));
            end
        end
        
        function obj = green_left(obj)
            if obj.state ~= 2
                obj.state = 2;
            end
        end
        
        function obj = green_right(obj)
            if obj.state ~= 2
                obj.state = 2;
            end
        end
        
        function obj = red_left(obj)
            if obj.state ~= 0
               obj.state = 0;
            end
        end
        
        function obj = red_right(obj)
            if obj.state ~= 0
               obj.state = 0;
            end
        end
    end
    
end
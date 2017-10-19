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
        
        function [car, obj] = dequeue_left(obj, time_now)
            if(~isempty(obj.queue_left) && obj.state == 2)
                car = obj.queue_left(1);
                obj.queue_right = obj.queue_left(2:1:end);
                %update the car to new destination
                car.direction_in = mod(car.direction_out + 2, 4);
               
                switch car.direction_out 
                    case 1
                        car.pos_cur{1,2} = car.pos_cur{1,2}-1;
                    case 2
                        car.pos_cur{1,1} = car.pos_cur{1,1}+1;
                    case 3
                        car.pos_cur{1,2} = car.pos_cur{1,2}+1;
                    otherwise
                        car.pos_cur{1,1} = car.pos_cur{1,1}-1;
                end
                
                %look one ahead
                if car.pos_cur{1,1} ~= car.pos_out{1,1} 
                    %next step not in end destination
                    if car.pos_cur{1,1} < car.pos_out{1,1}
                        car.direction_out = 2;
                    else 
                        car.direction_out = 4; 
                    end
                else
                    if car.pos_cur{1,2} ~= car.pos_out{1,2} 
                        if car.pos_cur{1,2} < car.pos_out{1,2}
                            car.direction_out = 3;
                        else 
                            car.direction_out = 1; 
                        end
                    end
                end
                
                car.time_of_passing = time_now;
                %set traffic light values
                if  ~isempty(car)
                    obj.cars_passed = obj.cars_passed + 1;
                    obj.wait_times = horzcat(obj.wait_times, (car.time_of_passing - car.time_of_arrival));
                    car.time_of_arrival = time_now;
                end
                car = [car];
            else
                car = [];
            end   
        end
      
        function [car, obj] = dequeue_right(obj, time_now)
            if(~isempty(obj.queue_right) && obj.state == 2)
                car = obj.queue_right(1);
                obj.queue_right = obj.queue_right(2:1:end);
                %update the car to new destination
                car.direction_in = mod(car.direction_out + 2, 4);
                
                switch car.direction_out 
                    case 1
                        car.pos_cur{1,2} = car.pos_cur{1,2}-1;
                    case 2
                        car.pos_cur{1,1} = car.pos_cur{1,1}+1;
                    case 3
                        car.pos_cur{1,2} = car.pos_cur{1,2}+1;
                    otherwise
                        car.pos_cur{1,1} = car.pos_cur{1,1}-1;
                end
                
                %look one ahead
                if car.pos_cur{1,1} ~= car.pos_out{1,1} 
                    %next step not in end destination
                    if car.pos_cur{1,1} < car.pos_out{1,1}
                        car.direction_out = 2;
                    else 
                        car.direction_out = 4; 
                    end
                else
                    if car.pos_cur{1,2} ~= car.pos_out{1,2} 
                        if car.pos_cur{1,2} < car.pos_out{1,2}
                            car.direction_out = 3;
                        else 
                            car.direction_out = 1; 
                        end
                    end
                end
                
                car.time_of_passing = time_now;
                %set traffic light values
                if  ~isempty(car)
                    obj.cars_passed = obj.cars_passed + 1;
                    obj.wait_times = horzcat(obj.wait_times, (car.time_of_passing - car.time_of_arrival));
                    car.time_of_arrival = time_now;
                end
                if car.pos_cur{1,1} ~= car.pos_out{1,1} && car.pos_cur{1,2} ~= car.pos_out{1,2} 
                    car = [];
                else
                    car = [car];
                end
            else
                car = [];
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
        
        function waiting_time = get_longest_waiting_time_right(obj, t)
            minlist = []; 
            length = size(obj.queue_right, 2); 
            if length > 0
                for i = 1:1:length
                    car = obj.queue_right(i); 
                    minlist = [minlist (t-car.time_of_arrival)]; 
                end
                waiting_time = max(minlist); 
            else
                waiting_time = 0;
            end 
        end
        
       
        function waiting_time = get_longest_waiting_time_left(obj, t)
            minlist = []; 
            length = size(obj.queue_left, 2); 
            if length > 0
                for i = 1:1:length
                    car = obj.queue_left(i); 
                    minlist = [minlist (t - car.time_of_arrival)]; 
                end
                waiting_time = max(minlist); 
            else
                waiting_time = 0;
            end 
        end
    end
end
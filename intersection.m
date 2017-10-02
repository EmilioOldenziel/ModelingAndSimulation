classdef intersection
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(0);
        east = traffic_light(0);
        south = traffic_light(0);
        west = traffic_light(0);
        simsec = 0; %time since start of simulation
        list_avg_waiting_time = 0 ;
    end

    methods
        function obj = intersection(time)
            %set the simulation runtime and time to 0
            obj.simsec = time;
        end
        
        function obj = run(obj)
            y = zeros(1, obj.simsec);
            x = (1: obj.simsec); 
            scatter(x,y); 
            drawnow;
            for i=1:1:obj.simsec
                obj = randomScheduling(obj, i);  
                obj = roundRobin(obj, i); 
                obj.west = obj.west.dequeue(i);
                obj.east = obj.east.dequeue(i);
                obj.south = obj.south.dequeue(i);
                obj.north = obj.north.dequeue(i);
                obj.list_avg_waiting_time = horzcat(obj.list_avg_waiting_time, obj.east.cars_passed, obj.south.cars_passed, obj.west.cars_passed, obj.north.cars_passed);  
                y(1,i) = mean(obj.list_avg_waiting_time);
                scatter(x,y); 
                drawnow;
            end
        end
    end 
end
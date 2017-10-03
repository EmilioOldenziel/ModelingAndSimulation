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
                disp(['amount of cars waiting => ','north: ' , num2str(size(obj.north.queue, 2)), ' east: ', num2str(size(obj.east.queue, 2)), ' south: ', num2str(size(obj.south.queue, 2)) ,' west: ', num2str(size(obj.west.queue, 2))])
                obj.list_avg_waiting_time = horzcat(obj.list_avg_waiting_time, obj.east.wait_times, obj.south.wait_times, obj.west.wait_times, obj.north.wait_times);  
                y(1,i) = mean(obj.list_avg_waiting_time);
                disp()
                plot(x,y); 
                drawnow;
            end
        end
    end 
end
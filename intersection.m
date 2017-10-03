classdef intersection
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(0);
        east = traffic_light(0);
        south = traffic_light(0);
        west = traffic_light(0);
        simsec = 0; %time since start of simulation
        list_avg_waiting_time = 0 ;
        size_of_queue_north = []; 
        size_of_queue_east = []; 
        size_of_queue_south = []; 
        size_of_queue_west = []; 
    end

    methods
        function obj = intersection(time)
            %set the simulation runtime and time to 0
            obj.simsec = time;
        end
        
        function obj = run(obj)
            y = [];
            figure 
            subplot(2,1,1)
            plot(y);
            title('Average waiting time of a car'); 
            drawnow;
            subplot(2,1,2)
            plot(length(obj.north.queue)); 
            title('Queue length per direction'); 
            drawnow;
            for i=1:1:obj.simsec
                obj = randomScheduling(obj, i);  
                obj = roundRobin(obj, i); 
                obj.west = obj.west.dequeue(i);
                obj.east = obj.east.dequeue(i);
                obj.south = obj.south.dequeue(i);
                obj.north = obj.north.dequeue(i);
                %  disp(['amount of cars waiting => ','north: ' , num2str(size(obj.north.queue, 2)), ' east: ', num2str(size(obj.east.queue, 2)), ' south: ', num2str(size(obj.south.queue, 2)) ,' west: ', num2str(size(obj.west.queue, 2))])
                obj.list_avg_waiting_time = mean(horzcat(obj.list_avg_waiting_time, obj.east.wait_times, obj.south.wait_times, obj.west.wait_times, obj.north.wait_times));  
                obj.size_of_queue_north = horzcat(obj.size_of_queue_north, size(obj.north.queue, 2));
                obj.size_of_queue_east = horzcat(obj.size_of_queue_east, size(obj.east.queue, 2));
                obj.size_of_queue_south = horzcat(obj.size_of_queue_south, size(obj.south.queue, 2));
                obj.size_of_queue_west = horzcat(obj.size_of_queue_west, size(obj.west.queue, 2));
                x = (1:1:i);
                y = horzcat(y, obj.list_avg_waiting_time);
                subplot(2,1,1)
                plot(x, y);
                drawnow;
                subplot(2,1,2)
                plot(x, obj.size_of_queue_north); 
                hold on
                plot(x, obj.size_of_queue_east); 
                plot(x, obj.size_of_queue_south); 
                plot(x, obj.size_of_queue_west); 
                hold off
                title('Queue length per direction');
                legend('north', 'east', 'south', 'west'); 
                drawnow;
            end
        end
    end 
end
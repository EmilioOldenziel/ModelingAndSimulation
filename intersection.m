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
            lock = 0;   %holds the traffic light on green for n steps
            on_green = 0; %current traffic light that is on green
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
                if lock <= 0 
                    on_green = randi(4);
                    disp(['light', num2str(on_green), 'is on green'])
                    switch on_green 
                        case 1
                            lock = size(obj.north.queue, 2);
                            disp('lock is set')
                        case 2
                            lock = size(obj.east.queue, 2);
                            disp('lock is set')
                        case 3
                            lock = size(obj.south.queue, 2);
                            disp('lock is set')
                        otherwise
                            lock = size(obj.west.queue, 2);
                            disp('lock is set')
                    end
                end
                obj = randomScheduling(obj, i);  
                if lock > 0
                    switch on_green 
                        case 1
                            obj.north = obj.north.green(); 
                            obj.north = obj.north.dequeue(i);
                            disp('hai')
                        case 2
                            obj.east = obj.east.green();
                            obj.east = obj.east.dequeue(i);
                        case 3
                            obj.south = obj.south.green();
                            obj.south = obj.south.dequeue(i);
                        otherwise
                            obj.west = obj.west.green(); 
                            obj.west = obj.west.dequeue(i);
                    end
                end
                lock = lock - 1;
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
                title('Average waiting time of a car'); 
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
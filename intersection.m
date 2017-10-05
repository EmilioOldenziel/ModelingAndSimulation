classdef intersection
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(0);
        east = traffic_light(0);
        south = traffic_light(0);
        west = traffic_light(0);
        simsec = 0; %time since start of simulation
        list_avg_waiting_time = [] ;
        size_of_queue_north_left = [];
        size_of_queue_north_right = []; 
        size_of_queue_east_left = []; 
        size_of_queue_east_right = []; 
        size_of_queue_south_left = [];
        size_of_queue_south_right = [];
        size_of_queue_west_left = [];
        size_of_queue_west_right = []; 
    end

    methods
        function obj = intersection(time)
            %set the simulation runtime and time to 0
            obj.simsec = time;
        end
        
        function obj = run(obj)
            lock = 0;   %holds the traffic light on green for n steps
            on_green = 0; %current traffic light situation that is on green
            y = [];
            figure 
            subplot(2,1,1)
            plot(y);
            title('Average waiting time of a car'); 
            drawnow;
            subplot(2,1,2)
            plot(length(obj.north.queue_right)); 
            title('Queue length per direction'); 
            drawnow;
            for i=1:1:obj.simsec
                % switch green traffic light situation
                if lock <= 0 
                    [~, on_green] = max([...
                        (size(obj.north.queue_right, 2)+size(obj.south.queue_right, 2)) ... % north-south straight and right turns
                        (size(obj.east.queue_right, 2)+size(obj.west.queue_right, 2)) ...   % east-west straight and right turns
                        (size(obj.north.queue_left, 2)+size(obj.south.queue_left, 2)) ...   % north-south left turns
                        (size(obj.east.queue_left, 2)+size(obj.west.queue_left, 2)) ...     % east-west left turns
                        ]); 
                    switch on_green 
                        case 1
                            lock = max(size(obj.north.queue_right, 2), size(obj.south.queue_right, 2)); %longest of the 2
                        case 2
                            lock = max(size(obj.east.queue_right, 2), size(obj.west.queue_right, 2));
                        case 3
                            lock = max(size(obj.north.queue_left, 2), size(obj.south.queue_left, 2));
                        otherwise
                            lock = max(size(obj.east.queue_left, 2), size(obj.west.queue_left, 2));
                    end
                end
                % add some cars
                obj = randomScheduling(obj, i);
                % let cars pass
                if lock > 0
                    switch on_green 
                        case 1 % north-south straight and right light
                            obj.north = obj.north.green_right(); 
                            obj.north = obj.north.dequeue_right(i);
                            obj.south = obj.south.green_right(); 
                            obj.south = obj.south.dequeue_right(i);
                        case 2 % east-west straight and right light
                            obj.east = obj.east.green_right();
                            obj.east = obj.east.dequeue_right(i);
                            obj.west = obj.west.green_right();
                            obj.west= obj.west.dequeue_right(i);
                        case 3 % north-south left light
                            obj.north = obj.north.green_left(); 
                            obj.north = obj.north.dequeue_left(i);
                            obj.south = obj.south.green_left(); 
                            obj.south = obj.south.dequeue_left(i);
                        otherwise %east-west left light
                            obj.east = obj.east.green_left();
                            obj.east = obj.east.dequeue_left(i);
                            obj.west = obj.west.green_left();
                            obj.west = obj.west.dequeue_left(i); 
                    end
                end
                lock = lock - 1;
                %  disp(['amount of cars waiting => ','north: ' , num2str(size(obj.north.queue, 2)), ' east: ', num2str(size(obj.east.queue, 2)), ' south: ', num2str(size(obj.south.queue, 2)) ,' west: ', num2str(size(obj.west.queue, 2))])
                obj.list_avg_waiting_time = horzcat(obj.list_avg_waiting_time, mean([obj.east.wait_times obj.south.wait_times obj.west.wait_times obj.north.wait_times]));  
                obj.size_of_queue_north_right = horzcat(obj.size_of_queue_north_right, size(obj.north.queue_right, 2));
                obj.size_of_queue_east_right = horzcat(obj.size_of_queue_east_right, size(obj.east.queue_right, 2));
                obj.size_of_queue_south_right = horzcat(obj.size_of_queue_south_right, size(obj.south.queue_right, 2));
                obj.size_of_queue_west_right = horzcat(obj.size_of_queue_west_right, size(obj.west.queue_right, 2));
                obj.size_of_queue_north_left = horzcat(obj.size_of_queue_north_left, size(obj.north.queue_left, 2));
                obj.size_of_queue_east_left = horzcat(obj.size_of_queue_east_left, size(obj.east.queue_left, 2));
                obj.size_of_queue_south_left = horzcat(obj.size_of_queue_south_left, size(obj.south.queue_left, 2));
                obj.size_of_queue_west_left = horzcat(obj.size_of_queue_west_left, size(obj.west.queue_left, 2));
                x = (1:1:i);
                y = obj.list_avg_waiting_time;
            end
                            subplot(2,1,1)
                plot(x, y);
                title('Average waiting time of a car'); 
                drawnow;
                subplot(2,1,2)
                plot(x, obj.size_of_queue_north_right); 
                plot(x, obj.size_of_queue_north_left); 
                hold on
                plot(x, obj.size_of_queue_east_right);
                plot(x, obj.size_of_queue_east_left);
                plot(x, obj.size_of_queue_south_right);
                plot(x, obj.size_of_queue_south_left);
                plot(x, obj.size_of_queue_west_right); 
                plot(x, obj.size_of_queue_west_left); 
                hold off
                title('Queue length per direction');
                legend('north-right', 'north-left', 'east-right', 'east-left', 'south-right', 'south-left', 'west-right', 'west-left'); 
                drawnow;
        end
    end 
end
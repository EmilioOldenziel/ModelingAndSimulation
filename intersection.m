classdef intersection
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(0);
        east = traffic_light(0);
        south = traffic_light(0);
        west = traffic_light(0);
        list_avg_waiting_time = [] ;
        size_of_queue_north_left = [];
        size_of_queue_north_right = []; 
        size_of_queue_east_left = []; 
        size_of_queue_east_right = []; 
        size_of_queue_south_left = [];
        size_of_queue_south_right = [];
        size_of_queue_west_left = [];
        size_of_queue_west_right = []; 
        amount_of_cars = []; 
        longest_waiting = []; 
        enqueue_list = []; 
        lock = 0;   %holds the traffic light on green for n steps
        on_green = 0; %current traffic light situation that is on green
        car_lock_1 = randi(4); %seconds of a car that is driving away
        car_lock_2 = randi(4);    
    end

    methods
        function obj = intersection()
        end
        
        function [ inter ] = enqueue_car_at_dir(inter, car, t)
        %UNTITLED Summary of this function goes here
        %   Detailed explanation goes here
            switch car.direction_in
                case 1
                    if car.direction_out-(car.direction_in -1) == 2
                        inter.north =  inter.north.enqueue_left(car, t); 
                    else
                        inter.north =  inter.north.enqueue_right(car, t);
                    end   
                case 2
                    if car.direction_out-(car.direction_in -1) == 2
                        inter.east =  inter.east.enqueue_left(car, t); 
                    else
                        inter.east =  inter.east.enqueue_right(car, t);
                    end   
                case 3
                    if car.direction_out-(car.direction_in -1) == 2
                        inter.south =  inter.south.enqueue_left(car, t); 
                    else
                        inter.south =  inter.south.enqueue_right(car, t);
                    end   
                otherwise
                    if car.direction_out-(car.direction_in -1) == 2
                        inter.west =  inter.west.enqueue_left(car, t); 
                    else
                        inter.west =  inter.west.enqueue_right(car, t);
                    end   
            end
        end


        
        function obj = enqueue_car(obj, car, i)
            obj = obj.enqueue_car_at_dir(car, i); 
        end
          
        function obj = run(obj, i)
            if obj.lock <= 0 && obj.car_lock_1 <= 0 && obj.car_lock_2 <= 0 
                % switch green traffic light situation
               waiting_times = [...
                        max(obj.north.get_longest_waiting_time_right(i), obj.south.get_longest_waiting_time_right(i)) ... % north-south straight and right turns
                        max(obj.east.get_longest_waiting_time_right(i), obj.west.get_longest_waiting_time_right(i)) ...   % east-west straight and right turns
                        max(obj.north.get_longest_waiting_time_left(i), obj.south.get_longest_waiting_time_left(i)) ...   % north-south left turns
                        max(obj.east.get_longest_waiting_time_left(i), obj.west.get_longest_waiting_time_left(i)) ...     % east-west left turns
                        ];
                    maximum = max(waiting_times);
                    for x=1:1:length(waiting_times)
                        waiting_times(x) = waiting_times(x) / maximum;
                    end
                [~, obj.on_green] = max([...
                    ((size(obj.north.queue_right, 2)+size(obj.south.queue_right, 2))*waiting_times(1)) ... % north-south straight and right turns
                    ((size(obj.east.queue_right, 2)+size(obj.west.queue_right, 2))*waiting_times(2)) ...   % east-west straight and right turns
                    ((size(obj.north.queue_left, 2)+size(obj.south.queue_left, 2))*waiting_times(3)) ...   % north-south left turns
                    ((size(obj.east.queue_left, 2)+size(obj.west.queue_left, 2))*waiting_times(4)) ...     % east-west left turns
                ]);
                switch obj.on_green 
                    case 1
                        obj.lock = max(size(obj.north.queue_right, 2), size(obj.south.queue_right, 2)); %longest of the 2
                    case 2
                        obj.lock = max(size(obj.east.queue_right, 2), size(obj.west.queue_right, 2));
                    case 3
                        obj.lock = max(size(obj.north.queue_left, 2), size(obj.south.queue_left, 2));
                    otherwise
                        obj.lock = max(size(obj.east.queue_left, 2), size(obj.west.queue_left, 2));
                end
            end
            
              waiting_times = [...
                        max(obj.north.get_longest_waiting_time_right(i), obj.south.get_longest_waiting_time_right(i)) ... % north-south straight and right turns
                        max(obj.east.get_longest_waiting_time_right(i), obj.west.get_longest_waiting_time_right(i)) ...   % east-west straight and right turns
                        max(obj.north.get_longest_waiting_time_left(i), obj.south.get_longest_waiting_time_left(i)) ...   % north-south left turns
                        max(obj.east.get_longest_waiting_time_left(i), obj.west.get_longest_waiting_time_left(i)) ...     % east-west left turns
                        ];
                    obj.longest_waiting = [obj.longest_waiting (max(waiting_times))];
                    
                % let cars pass
                if obj.lock > 0
                    switch obj.on_green
                        case 1 % north-south straight and right light
                            if obj.car_lock_1 == 0 %car drove away
                                obj.north = obj.north.green_right();
                                [car, obj.north] = obj.north.dequeue_right(i); %next car drives away
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car]; 
                                    obj.car_lock_1 = 2 + randi(2); %next car drives away
                                end
                            end
                            obj.south = obj.south.green_right();
                            if obj.car_lock_2 == 0
                                [car, obj.south] = obj.south.dequeue_right(i);
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car]; 
                                    obj.car_lock_2 = 2 + randi(2);

                                end
                            end
                        case 2 % east-west straight and right light
                            obj.east = obj.east.green_right();
                            if obj.car_lock_1 == 0
                                [car, obj.east] = obj.east.dequeue_right(i); %next car drives away
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car]; 
                                    obj.car_lock_1 = 2 + randi(2);
                                end
                            end
                            
                            obj.west = obj.west.green_right();
                            if obj.car_lock_2 == 0
                                [car, obj.west] = obj.west.dequeue_right(i);
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car]; 
                                    obj.car_lock_2 = 2 + randi(2);
                                end
                            end
                        case 3 % north-south left light
                            obj.north = obj.north.green_left();
                            if obj.car_lock_1 == 0
                                [car, obj.north] = obj.north.dequeue_right(i); %next car drives away
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car]; 
                                    obj.car_lock_1 = randi(4);
                                end
                            end
                            
                            obj.south = obj.south.green_left();
                            if obj.car_lock_2 == 0
                                [car, obj.south] = obj.south.dequeue_left(i);
                                if ~isempty(car)
                                   obj.enqueue_list = [obj.enqueue_list car]; 
                                   obj.car_lock_2 = randi(4);
                                end
                            end
                            
                            otherwise %east-west left light
                            obj.east = obj.east.green_left();
                            if obj.car_lock_1 == 0
                                [car, obj.east] = obj.east.dequeue_left(i);
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car]; 
                                    obj.car_lock_1 = randi(4);
                                end
                            end
                            obj.west = obj.west.green_left();
                            if obj.car_lock_2 == 0
                                [car, obj.west] = obj.west.dequeue_left(i);
                                if ~isempty(car)
                                    obj.enqueue_list = [obj.enqueue_list car];
                                    obj.car_lock_2 = randi(4);
                                end  
                            end
                    end
                end
                
                %disp(['amount of cars waiting => ','north: ' , num2str(size(obj.north.queue, 2)), ' east: ', num2str(size(obj.east.queue, 2)), ' south: ', num2str(size(obj.south.queue, 2)) ,' west: ', num2str(size(obj.west.queue, 2))])
                obj.list_avg_waiting_time = horzcat(obj.list_avg_waiting_time, mean([obj.east.wait_times obj.south.wait_times obj.west.wait_times obj.north.wait_times]));  
                obj.size_of_queue_north_right = horzcat(obj.size_of_queue_north_right, size(obj.north.queue_right, 2));
                obj.size_of_queue_east_right = horzcat(obj.size_of_queue_east_right, size(obj.east.queue_right, 2));
                obj.size_of_queue_south_right = horzcat(obj.size_of_queue_south_right, size(obj.south.queue_right, 2));
                obj.size_of_queue_west_right = horzcat(obj.size_of_queue_west_right, size(obj.west.queue_right, 2));
                obj.size_of_queue_north_left = horzcat(obj.size_of_queue_north_left, size(obj.north.queue_left, 2));
                obj.size_of_queue_east_left = horzcat(obj.size_of_queue_east_left, size(obj.east.queue_left, 2));
                obj.size_of_queue_south_left = horzcat(obj.size_of_queue_south_left, size(obj.south.queue_left, 2));
                obj.size_of_queue_west_left = horzcat(obj.size_of_queue_west_left, size(obj.west.queue_left, 2)); 
        end
        
        function plot_intersection(obj, i)
                x = (0:1:i);
                figure 
                
                y = obj.list_avg_waiting_time;
                subplot(3,1,1)
                plot(x, y);
                title('Average waiting time of a car'); 
                drawnow;

                y = obj.longest_waiting;
                subplot(3,1,2)
                plot(x, y);
                title('Max waiting time per round'); 
                drawnow;
                
                subplot(3,1,3)
                plot(x, obj.size_of_queue_north_right); 
                hold on
                plot(x, obj.size_of_queue_north_left); 
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
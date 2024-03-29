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
        amount_of_cars = []; 
    end

    methods
        function obj = intersection(time)
            %set the simulation runtime and time to 0
            obj.simsec = time;
        end
        
        function obj = run(obj)
            lock = 0;   %holds the traffic light on green for n steps
            on_green = 0; %current traffic light situation that is on green
            car_lock_1 = randi(4); %seconds of a car that is driving away
            car_lock_2 = randi(4);
            time_till_next_enqueue_round = 0;
            for i=1:1:obj.simsec
                fprintf("%d\n", lock); 
                % switch green traffic light situation
                if lock <= 0 && car_lock_1 <= 0 && car_lock_2 <= 0
                    waiting_times = [...
                        min(obj.north.get_longest_waiting_time_right(), obj.south.get_longest_waiting_time_right()) ... % north-south straight and right turns
                        min(obj.east.get_longest_waiting_time_right(), obj.west.get_longest_waiting_time_right()) ...   % east-west straight and right turns
                        min(obj.north.get_longest_waiting_time_left(), obj.south.get_longest_waiting_time_left()) ...   % north-south left turns
                        min(obj.east.get_longest_waiting_time_left(), obj.west.get_longest_waiting_time_left()) ...     % east-west left turns
                        ];
                    waiting_times = waiting_times / max(waiting_times);
                    
                    [~, on_green] = max([...
                        ((size(obj.north.queue_right, 2)+size(obj.south.queue_right, 2))*waiting_times(1)) ... % north-south straight and right turns
                        ((size(obj.east.queue_right, 2)+size(obj.west.queue_right, 2))*waiting_times(2)) ...   % east-west straight and right turns
                        ((size(obj.north.queue_left, 2)+size(obj.south.queue_left, 2))*waiting_times(3)) ...   % north-south left turns
                        ((size(obj.east.queue_left, 2)+size(obj.west.queue_left, 2))*waiting_times(4)) ...     % east-west left turns
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
                if time_till_next_enqueue_round == 0
                    obj = randomScheduling(obj, i, obj.simsec);
                    time_till_next_enqueue_round = 5 + randi(10);
                else 
                    obj.amount_of_cars = [obj.amount_of_cars 0];
                end
                time_till_next_enqueue_round = time_till_next_enqueue_round - 1;
                % let cars pass
                if lock > 0
                    switch on_green
                        case 1 % north-south straight and right light
                            obj.north = obj.north.green_right();
                            if car_lock_1 == 0 %car drove away
                                obj.north = obj.north.dequeue_right(i); %next car drives away
                                car_lock_1 = 2 + randi(2); %next car drives away
                            end
                            obj.south = obj.south.green_right();
                            if car_lock_2 == 0
                                obj.south = obj.south.dequeue_right(i);
                                car_lock_2 = 2 + randi(2);
                            end
                        case 2 % east-west straight and right light
                            obj.east = obj.east.green_right();
                            if car_lock_1 == 0
                                obj.east = obj.east.dequeue_right(i);
                                car_lock_1 = 2 + randi(2);
                            end
                            obj.west = obj.west.green_right();
                            if car_lock_2 == 0
                                obj.west= obj.west.dequeue_right(i);
                                car_lock_2 = 2 + randi(2);
                            end
                        case 3 % north-south left light
                            obj.north = obj.north.green_left();
                            if car_lock_1 == 0
                                obj.north = obj.north.dequeue_left(i);
                                car_lock_1 = randi(4);
                            end
                            obj.south = obj.south.green_left();
                            if car_lock_2 == 0
                                obj.south = obj.south.dequeue_left(i);
                                car_lock_2 = randi(4);
                            end
                        otherwise %east-west left light
                            obj.east = obj.east.green_left();
                            if car_lock_1 == 0
                                obj.east = obj.east.dequeue_left(i);
                                car_lock_1 = randi(4);
                            end
                            obj.west = obj.west.green_left();
                            if car_lock_2 == 0
                                obj.west = obj.west.dequeue_left(i);
                                car_lock_2 = randi(4);
                            end
                    end
                end
                
                if car_lock_1 > 0
                    car_lock_1 = car_lock_1 - 1;
                end
                
                if car_lock_2  > 0 
                    car_lock_2 = car_lock_2 - 1;
                end 
                if lock > 0
                    lock = lock - 1;
                end
                
                
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
            end
                figure 
                
                y = obj.amount_of_cars; 
                subplot(3,1,1)
                plot(x, y);
                title('Card added'); 
                drawnow;
                
                y = obj.list_avg_waiting_time;
                subplot(3,1,2)
                plot(x, y);
                title('Average waiting time of a car'); 
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
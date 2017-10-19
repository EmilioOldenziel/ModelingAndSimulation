classdef traffic_light_grid
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      grid_size
      grid = {}
      cars_to_enqueue = []
      enqueue_rate = 10;
      grid_amount_of_cars = {};
    end
    
    methods
        function obj = traffic_light_grid(size)
            obj.grid_size = size; 
            for i = 1:1:obj.grid_size
                for j = 1:1:obj.grid_size
                    obj.grid{i,j} = intersection();
                end
            end
        end
        
        function obj = run(obj)
            for t=0:1:100
                %each round enqueue_rate cars are enqueued 
                for i=1:1:obj.enqueue_rate
                    obj.cars_to_enqueue = [obj.cars_to_enqueue car(obj.grid_size, t)];
                end
                for i=1:1:length(obj.cars_to_enqueue)
                    cur_car = obj.cars_to_enqueue(i);
                    if cur_car.pos_cur{1,1} <= obj.grid_size && cur_car.pos_cur{1,1} > 0 && cur_car.pos_cur{1,2} <= obj.grid_size && cur_car.pos_cur{1,2} > 0 
                        x = cur_car.pos_cur{1, 1};
                        y = cur_car.pos_cur{1, 2};
                        obj.grid{x,y} = obj.grid{x,y}.enqueue_car(cur_car, t);
                    else 
                       
                    end    
                       
                end
                obj.cars_to_enqueue = [];
                %for each traffic light return the cars that have been
                %dequeued
                for i=1:1:obj.grid_size
                    for j=1:1:obj.grid_size
                        obj.grid{i,j} = obj.grid{i, j}.run(t);
                        obj.cars_to_enqueue = [obj.cars_to_enqueue obj.grid{i,j}.enqueue_list];
                        obj.grid{i,j}.enqueue_list = [];
                    end
                end
                
                obj.grid_amount_of_cars = {};
                for i=1:1:obj.grid_size
                    for j=1:1:obj.grid_size
                        x = 0;
                        x = x + length(obj.grid{i,j}.north.queue_right);
                        x = x + length(obj.grid{i,j}.north.queue_left);
                        x = x + length(obj.grid{i,j}.east.queue_right);
                        x = x + length(obj.grid{i,j}.east.queue_left); 
                        x = x + length(obj.grid{i,j}.south.queue_right);
                        x = x + length(obj.grid{i,j}.south.queue_left); 
                        x = x + length(obj.grid{i,j}.west.queue_right);
                        x = x + length(obj.grid{i,j}.west.queue_left);
                        obj.grid_amount_of_cars{i, j} = x; 
                    end
                end
            
                for i=1:1:obj.grid_size
                    for j=1:1:obj.grid_size
                        if obj.grid{i,j}.car_lock_1 > 0
                            obj.grid{i,j}.car_lock_1 = obj.grid{i,j}.car_lock_1 - 1;
                        end
                        if obj.grid{i,j}.car_lock_2  > 0 
                            obj.grid{i,j}.car_lock_2 = obj.grid{i,j}.car_lock_2 - 1;
                        end 
                        if obj.grid{i,j}.lock > 0
                            obj.grid{i,j}.lock = obj.grid{i,j}.lock - 1;
                        end   
                    end
                end
                
                
              Z = {};
              for i=1:1:obj.grid_size
                for j=1:1:obj.grid_size
                    Z{i,j} = obj.grid_amount_of_cars{i,j};
                end
              end
              bar3(cell2mat(Z))
              alpha(.5)
              title('Amount of Cars')
              title(['Amount of cars at t=', num2str(t)]);
              drawnow;
              pause(0.01)
            end
               
            
             % plot each intersection in the grid 
           for i=1:1:obj.grid_size
            for j=1:1:obj.grid_size
               plot_intersection(obj.grid{i,j}, 100);
             end

            end
        end
    end
end
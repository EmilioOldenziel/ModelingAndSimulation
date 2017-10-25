classdef traffic_light_grid
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      input_type
      green_mode;
      lock_mode;
      grid_size
      grid = {}
      cars_to_enqueue = []
      enqueue_rate = 1;
      grid_amount_of_cars = {};
      simsec;
      amount_of_cars = [];
      list_avg_waiting_time = []; 
      longest_waiting = []; 
    end
    
    methods
        function obj = traffic_light_grid(simsec,  input_type, size, green_mode, lock_mode)
            obj.simsec = simsec; 
            obj.grid_size = size;
            obj.input_type = input_type; 
            obj.green_mode = green_mode;
            obj.lock_mode = lock_mode;
            for i = 1:1:obj.grid_size
                for j = 1:1:obj.grid_size
                    obj.grid{i,j} = intersection(obj.green_mode, obj.lock_mode);
                end
            end
        end
        
        function obj = run(obj)
            for t=0:1:obj.simsec
                obj.input_type
                %select amount of cars based on input type
                switch obj.input_type
                    case 1 
                        %settings for an constant input
                        amount_added=obj.grid_size; 
                    case 2
                        %settings for a rush hour situation
                        amount_added = abs(int16((sin(t/obj.simsec*pi*10))*10.0)); 
                        %add no more cars after half a sinus
                        if t > obj.simsec/10
                            amount_added= 0;
                        end
                    otherwise
                        %settings for constant peaks
                        if mod(t, 5) == 0
                            amount_added = obj.grid_size;
                        else 
                            amount_added = 0;
                        end
                end
                
               obj.amount_of_cars = [obj.amount_of_cars amount_added]; 

                % each round enqueue_rate cars are enqueued 
               for i=1:1:amount_added
                    obj.cars_to_enqueue = [obj.cars_to_enqueue car(obj.grid_size, t)];
               end
          
                for i=1:1:size(obj.cars_to_enqueue,2)
                    cur_car = obj.cars_to_enqueue(i);
                    if cur_car.pos_cur{1,1} <= obj.grid_size && cur_car.pos_cur{1,1} > 0 && cur_car.pos_cur{1,2} <= obj.grid_size && cur_car.pos_cur{1,2} > 0 
                        x = cur_car.pos_cur{1, 1};
                        y = cur_car.pos_cur{1, 2};
                        obj.grid{x,y} = obj.grid{x,y}.enqueue_car(cur_car, t);                       
                    end         
                end
                
                obj.cars_to_enqueue = [];
                %for each traffic light return the cars that have been
                %dequeued
                for i=1:1:obj.grid_size
                    for j=1:1:obj.grid_size
                        obj.grid{i,j} = obj.grid{i,j}.run(t);
                        obj.cars_to_enqueue = [obj.cars_to_enqueue obj.grid{i,j}.enqueue_list];
                        obj.grid{i,j}.enqueue_list = [];
                    end
                end
                obj.grid_amount_of_cars = {};
                for i=1:1:obj.grid_size
                    for j=1:1:obj.grid_size  
                        x = 0;
                        x = x + size(obj.grid{i,j}.north.queue_right, 2);
                        x = x + size(obj.grid{i,j}.north.queue_left, 2);
                        x = x + size(obj.grid{i,j}.east.queue_right, 2);
                        x = x + size(obj.grid{i,j}.east.queue_left, 2); 
                        x = x + size(obj.grid{i,j}.south.queue_right, 2);
                        x = x + size(obj.grid{i,j}.south.queue_left, 2); 
                        x = x + size(obj.grid{i,j}.west.queue_right, 2);
                        x = x + size(obj.grid{i,j}.west.queue_left, 2);
                        obj.grid_amount_of_cars{i, j} = x; 
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
              saveas(gcf, ['frames/' num2str(t) '.jpg'])
              
              iter_waiting_time = []; 
              for i=1:1:obj.grid_size
                for j=1:1:obj.grid_size
                    iter_waiting_time = [iter_waiting_time, mean([...
                            obj.grid{i,j}.north.calculate_wait_time_right(t),obj.grid{i,j}.north.calculate_wait_time_left(t),...
                            obj.grid{i,j}.east.calculate_wait_time_right(t), obj.grid{i,j}.east.calculate_wait_time_left(t),...
                            obj.grid{i,j}.south.calculate_wait_time_right(t),obj.grid{i,j}.south.calculate_wait_time_left(t),...
                            obj.grid{i,j}.west.calculate_wait_time_right(t), obj.grid{i,j}.west.calculate_wait_time_left(t)])];
                end
              end
              obj.list_avg_waiting_time = horzcat(obj.list_avg_waiting_time, mean(iter_waiting_time)); 
            
              waiting_longest = []; 
              for i=1:1:obj.grid_size
                for j=1:1:obj.grid_size
                    waiting_longest = [waiting_longest max([...
                            obj.grid{i,j}.north.get_longest_waiting_time_right(t), obj.grid{i,j}.north.get_longest_waiting_time_left(t),...
                            obj.grid{i,j}.east.get_longest_waiting_time_right(t), obj.grid{i,j}.east.get_longest_waiting_time_left(t),...
                            obj.grid{i,j}.south.get_longest_waiting_time_right(t),obj.grid{i,j}.south.get_longest_waiting_time_left(t),...
                            obj.grid{i,j}.west.get_longest_waiting_time_right(t), obj.grid{i,j}.west.get_longest_waiting_time_left(t)])];
                end
              end
              obj.longest_waiting = horzcat(obj.longest_waiting, max(waiting_longest)); 
              
              
            end
            x = (0:1:obj.simsec);

            figure 
                y = obj.amount_of_cars; 
                subplot(3,1,1)
                plot(x, y);
                title('Cars added'); 
                ylabel('Cars');
                xlabel('Simulation seconds (s)');
                drawnow;
                
                y = obj.list_avg_waiting_time;
                subplot(3,1,2)
                plot(x, y);
                title('Average waiting time of a car');
                ylabel('Seconds (s)');
                xlabel('simulation seconds (s)');
                drawnow;

                y = obj.longest_waiting;
                subplot(3,1,3)
                length(x)
                length(y)
                plot(x, y);
                title('Max waiting time per round'); 
                ylabel('Seconds (s)');
                xlabel('Simulation seconds (s)');
                drawnow;
                
        end
    end
end
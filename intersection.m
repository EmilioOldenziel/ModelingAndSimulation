classdef intersection  < matlab.mixin.SetGet
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(1, 2, []);
        east = traffic_light(2, 0, []);
        south = traffic_light(3, 2, []);
        west = traffic_light(4, 0, []);
    end

    methods
        function obj = intersection()
            car1 = car(1, 3); 
            car2 = car(2, 4); 
            enqueue(north, car1);
            enqueue(north, car2);   
        end
        
        function step = step()
            %put lights on yellow
            
            %put lights on red
            
            %put lights on green
            
            
        end
        
        %adds traffic to random lights
        function add_traffic = add_traffic(){
            
        }
    end 
end
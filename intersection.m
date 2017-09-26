classdef intersection  < matlab.mixin.SetGet
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(1, 2, []);
        east = traffic_light(2, 0, []);
        south = traffic_light(3, 2, []);
        west = traffic_light(4, 0, []);
        time = 0; %time since start of simulation
    end

    methods
        function obj = intersection(simsec)
            %set the simulation runtime and time to 0
            set.simsec(obj, simsec);
            
            %initialize traffic
            car1 = car(1, 3);
            car2 = car(2, 4); 
            enqueue(north, car1);
            enqueue(north, car2);
        end
        
        static function run()
            
        end
    end 
end
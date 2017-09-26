classdef intersection
    %intersection of 2 two-way roads with trafficlights
    properties
        north = traffic_light(2, []);
        east = traffic_light(0, []);
        south = traffic_light(2, []);
        west = traffic_light(0, []);
        simsec = 0; %time since start of simulation
    end

    methods
        function obj = intersection(time)
            %set the simulation runtime and time to 0
            obj.simsec = time;
            
            %initialize traffic
            car1 = car(1, 3);
            %car2 = car(1, 4); 
            obj.north = obj.north.enqueue(car1);
            obj.north = obj.north.dequeue();
            %obj.north.enqueue(car2);
        end
        
        function run(time)
            for i=1:1:time
                
            end
        end
    end 
end
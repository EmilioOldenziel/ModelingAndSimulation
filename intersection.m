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
        end
        
        function obj = run(obj)
            for i=1:1:obj.simsec
                fprintf('We are in run %d\n', i); 
                obj = roundRobin(obj, i); 
            end
        end
    end 
end
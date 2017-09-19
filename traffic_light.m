classdef traffic_light  < matlab.mixin.SetGet
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    pos  %position of traffic light (1=N, 2=E, 3=S, 4=W)
    state %current state (2=green, 1=orange, 0=red)
    queue %queueu of cars in front of light  
    end
    
    methods
        
        function obj = traffic_light(pos, state, queue)  %constructor of traffic light
            obj.pos = pos; 
            obj.state = state; 
            obj.queue = queue; 
            fprintf('We have created a traffic light %d\n', obj.pos);   
        end
        
        function enqueue(light, car) %enqueues a car to a particular traffic light
            light.queue = [get(light, 'queue'); get(car, 'direction_in'), get(car, 'direction_out')];
        end
    end
    
end
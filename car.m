classdef car < matlab.mixin.SetGet
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    direction_in %coming direction
    direction_out %heading direction
        
    end
    
    methods
        function obj = car(in, out)
            obj.direction_in = in; 
            obj.direction_out = out; 
            disp('We have created a car');    

        end 
    end    
end


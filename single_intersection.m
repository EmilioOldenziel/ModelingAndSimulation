function [inter] = single_intersection(rounds, input_type, green_mode, lock_mode)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
inter = intersection(rounds, input_type, green_mode, lock_mode);
inter = inter.run(); 
end


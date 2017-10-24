function [inter] = single_intersection( rounds, green_mode, lock_mode)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
inter = intersection(rounds, green_mode, lock_mode);
inter = inter.run(); 
end


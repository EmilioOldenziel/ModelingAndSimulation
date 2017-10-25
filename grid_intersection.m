function [ gr ] = grid_intersection(simsec, input_type, size, green_mode, lock_mode )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    gr = traffic_light_grid(simsec, input_type, size, green_mode, lock_mode); 
    gr = gr.run(); 
end


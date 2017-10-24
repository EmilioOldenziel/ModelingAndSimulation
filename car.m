classdef car
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    direction_in %coming direction
    direction_out %heading direction
    time_of_arrival %time when the car is enqueued to a particular trafic light
    time_of_passing %time when the car passed the traffic light
    pos_cur %position where the car starts in the grid
    pos_out %position where the car end in the grid
    end
    
    methods
        function obj = car(gs, t) %constructor of car
            obj.time_of_passing = 0; 
            obj = obj.start_end_position(gs);
        end 
        
        function obj = start_end_position(obj,gs) %start and end in the grid
            rand = randi(gs); 
            if randi(2)-1 %
                if randi(2)-1 %N
                    obj.pos_cur = {rand ,1};
                    obj.pos_out = {gs, rand};
                    obj.direction_in = 1; %from north
                    obj.direction_out = 3;
                else %S
                    obj.pos_cur = {rand, gs};
                    obj.pos_out = {rand, 1};
                    obj.direction_in = 3; %from south
                    obj.direction_out = 1;
                end
            else %EW
                if randi(2)-1 %E
                    obj.pos_cur = {gs, rand};
                    obj.pos_out = {1, rand};
                    obj.direction_in = 2; %from east
                    obj.direction_out = 4;
                else %W
                    obj.pos_cur = {1, rand};
                    obj.pos_out = {gs, rand};
                    obj.direction_in = 4; %from west
                    obj.direction_out = 2;
                end
            end
        end
    end
end
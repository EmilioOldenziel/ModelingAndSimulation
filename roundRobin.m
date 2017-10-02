function [ obj ] = roundRobin(obj, i)
    %Divides the turn equally over the traffic lights
    turn = mod(i, 4);
    
    switch turn
        case 1
            obj.east = obj.east.green(); 
            obj.south = obj.south.red();  
            obj.west = obj.west.red(); 
            obj.north = obj.north.red(); 
        case 2
            obj.east = obj.east.red(); 
            obj.south = obj.south.green();  
            obj.west = obj.west.red(); 
            obj.north = obj.north.red(); 
        case 3
            obj.east = obj.east.red(); 
            obj.south = obj.south.red(); 
            obj.west = obj.west.green(); 
            obj.north = obj.north.red(); 
        otherwise 
            obj.east = obj.east.red(); 
            obj.south = obj.south.red();  
            obj.west = obj.west.red(); 
            obj.north = obj.north.green(); 
    end
end


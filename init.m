%create traffic lights
north = traffic_light(1, 0, []);
east = traffic_light(2, 0, []);
south = traffic_light(3, 0, []);
west = traffic_light(4, 0, []);

%create cars during 10 seconds with random directions and starting points
list_of_lights = [north, east, south, west];
t = timer('TimerFcn', 'stat=false; disp(''Timer!'')',... 
                 'StartDelay',10);
start(t)
stat=true;
while(stat==true)
  enqueue(list_of_lights(randi([1 4],1, 1)), car(randi([1 4],1, 1), randi([1 4],1, 1))); 
end
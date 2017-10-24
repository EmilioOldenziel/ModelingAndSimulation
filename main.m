function main(grid_size, sim_sec)
    gr = traffic_light_grid(grid_size, sim_sec); 
    gr = gr.run(); 
end
if (part_system_exists(self.ps)) part_system_destroy(self.ps);

if (ds_exists(self.grid, ds_type_grid)) ds_grid_destroy(self.grid);
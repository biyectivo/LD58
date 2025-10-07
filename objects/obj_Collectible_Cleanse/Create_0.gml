//self.sprite_index = asset_get_index("spr_Collectible_Tag"+string(irandom_range(1,3)));

self.y_offset_draw = 0;
self.scale = 1;
animation_add("Collectible_Bop"+string(self.id), self, "y_offset_draw", 10, 60, curve_Normal, true);
animation_start("Collectible_Bop"+string(self.id));
animation_add("Collectible_Scale"+string(self.id), self, "scale", 1.2, 30, curve_Normal, true);
animation_start("Collectible_Scale"+string(self.id));

self.light = new BulbLight(Lighting.renderer, spr_Light, 0, self.x, self.y);
self.light.xscale = 0.25;
self.light.yscale = 0.25;
self.light.blend = c_white;
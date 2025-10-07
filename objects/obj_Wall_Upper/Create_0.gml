self.visible = true;
self.occluder = new BulbStaticOccluder(Lighting.renderer);

//Move the occluder on top of the player
self.occluder.x = self.x;
self.occluder.y = self.y;

//Define a simple rectangular occluder that fits the bounding box of the player
self.occluder.AddEdge(self.bbox_left  - self.x, self.bbox_top    - self.y, self.bbox_right - self.x, self.bbox_top    - self.y);
self.occluder.AddEdge(self.bbox_right - self.x, self.bbox_top    - self.y, self.bbox_right - self.x, self.bbox_bottom - self.y);
self.occluder.AddEdge(self.bbox_right - self.x, self.bbox_bottom - self.y, self.bbox_left  - self.x, self.bbox_bottom - self.y);
self.occluder.AddEdge(self.bbox_left  - self.x, self.bbox_bottom - self.y, self.bbox_left  - self.x, self.bbox_top    - self.y);



Lighting.renderer.RefreshStaticOccluders();
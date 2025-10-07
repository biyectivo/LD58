live_auto_call;

if (Game.fsm.get_current_state_name() == "Paused") exit;


scribble($"[fnt_Arcade_Solid][alpha,{self.t/60}][fa_center][fa_bottom][c_white][scale,0.5]+{self.score_value}").draw(self.x, self.y-(60-self.t)/60*self.y_offset);
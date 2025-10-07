function __InputConfigVerbs() {
    enum INPUT_VERB {
        UP,
        DOWN,
        LEFT,
        RIGHT,
        ACCEPT,
        DASH,
        PAUSE,
		CLEAR,
		
		MUSIC,
		SOUNDS,
		FULLSCREEN
    }
    
    enum INPUT_CLUSTER {
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    
    InputDefineVerb(INPUT_VERB.UP,				"up",			[vk_up,    "W"],				[-gp_axislv, gp_padu]);
    InputDefineVerb(INPUT_VERB.DOWN,			"down",			[vk_down,  "S"],				[ gp_axislv, gp_padd]);
    InputDefineVerb(INPUT_VERB.LEFT,			"left",			[vk_left,  "A"],				[-gp_axislh, gp_padl]);
    InputDefineVerb(INPUT_VERB.RIGHT,			"right",		[vk_right, "D"],				[ gp_axislh, gp_padr]);
    InputDefineVerb(INPUT_VERB.ACCEPT,			"accept",		[vk_enter],						[gp_start]);
    InputDefineVerb(INPUT_VERB.DASH,			"dash",			[vk_space, vk_shift],			[gp_shoulderl, gp_shoulderr, gp_shoulderlb, gp_shoulderrb, gp_face1, gp_face2]);
    InputDefineVerb(INPUT_VERB.PAUSE,			"pause",		[vk_escape, "P"],				[gp_select]);
    InputDefineVerb(INPUT_VERB.CLEAR,			"clear",		["C"],							[]);
																
	InputDefineVerb(INPUT_VERB.MUSIC,			"music",		["M"],							[]);
	InputDefineVerb(INPUT_VERB.SOUNDS,			"sounds",		["K"],							[]);
	InputDefineVerb(INPUT_VERB.FULLSCREEN,		"fullscreen",	["F"],							[]);
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}

/// @feather ignore all
function __auto_create_ui_object() {
	if (!variable_global_exists("__gooey_manager_active")) {
		var _layer = layer_create(16000, "lyr_gooey");
		instance_create_layer(-1, -1, _layer, UI);
	}
}

/// @function				ui_exists(_ID)
/// @description			returns whether the specified Widget exists, identified by its *string ID* (not by its reference).
/// @param					{String}	_ID		The Widget string ID
/// @return					{Bool}	Whether the specified Widget exists
function ui_exists(_id) {
	__auto_create_ui_object();
	return UI.exists(_id);
}

/// @function				ui_get(_ID)
/// @description			gets a specific Widget by its *string ID* (not by its reference).
/// @param					{String}	_ID		The Widget string ID
/// @return					{Any}	The Widget's reference, or noone if not found
function ui_get(_id) {
	__auto_create_ui_object();
	return UI.get(_id);
}

/// @function				ui_is_interacting()
/// @description			returns whether the user is interacting with the UI, to prevent clicks/actions "drilling-through" to the game
/// @return					{Bool}	whether the user is interacting with the UI
	
function ui_is_interacting() {
	__auto_create_ui_object();
	return UI.isInteracting();
}

/// @function				ui_get_log_message_level()
/// @description			gets the message level for the library
/// @return					{Enum}	The message level, according to UI_MESSAGE_LEVEL	
function ui_get_log_message_level()		{
	__auto_create_ui_object();
	return UI.getLogMessageLevel();
}
	
/// @function				ui_set_log_message_level
/// @description			sets the message level for the library
/// @param					{Enum}	_lvl	The message level, according to UI_MESSAGE_LEVEL
/// @return					{UI}	self
function ui_set_log_message_level(_lvl)	{
	__auto_create_ui_object();
	UI.setLogMessageLevel(_lvl);
}
	
/// @function				ui_get_mouse_device()
/// @description			gets the currently used mouse device for handling mouse events. By default it's 0.
/// @return					{Real}	The currently used mouse device
function ui_get_mouse_device()			{
	__auto_create_ui_object();
	return UI.getMouseDevice();
}
	
/// @function				ui_set_mouse_device(_device)
/// @description			sets the mouse device for handling mouse events.
/// @param					{Real}	_device	The number of the mouse device to use.
/// @return					{UI}	self
function ui_set_mouse_device(_device)		{
	__auto_create_ui_object();
	UI.setMouseDevice(_device);	
}
	
/// @function				ui_get_widgets()
/// @description			gets an array with all widgets currently registered
/// @return					{Array<UIWidget>}	The array with the widgets
function ui_get_widgets()	{
	__auto_create_ui_object();
	return UI.getWidgets();
}
	
/// @function				ui_get_panels()
/// @description			gets an array with all Panel widgets currently registered
/// @return					{Array<UIPanel>}	The array with the Panel widgets
function ui_get_panels() {
	__auto_create_ui_object();
	return UI.getPanels();
}
	
/// @function				ui_get_focused_panel()
/// @description			gets the reference to the currently focused Panel widget, or -1 if no panels exist.
/// @return					{UIPanel}	The reference to the currently focus Panel
function ui_get_focused_panel() {
	__auto_create_ui_object();
	return UI.getFocusedPanel();
}
	
/// @function				ui_set_focused_panel(_ID)
/// @description			sets the specified Panel as focused
/// @param					{String}	_ID		The Widget string ID	
/// @return					{UI}	self
function ui_set_focused_panel(_ID) {				
	__auto_create_ui_object();
	return UI.setFocusedPanel(_ID);
}

/// @function				ui_get_currently_hovered_panel()
/// @description			gets the currently hovered Panel
/// @return					{UIPanel}	the currently hovered panel or undefined
function ui_get_currently_hovered_panel() {				
	__auto_create_ui_object();
	return UI.__currentlyHoveredPanel < 0 ? undefined : UI.__panels[UI.__currentlyHoveredPanel];
}


/// @function				ui_get_currently_hovered_widget()
/// @description			gets the currently hovered Widget
/// @return					{All}	the currently hovered widget (any widget from UIWidget) or undefined
function ui_get_currently_hovered_widget() {				
	__auto_create_ui_object();
	return UI.__currentlyHoveredWidget < 0 ? undefined : UI.__currentlyHoveredWidget;
}


/// @function				ui_get_currently_dragged_widget()
/// @description			gets the currently dragged widget
/// @return					{All}	the currently dragged widget (any widget from UIWidget) or undefined
function ui_get_currently_dragged_widget() {				
	__auto_create_ui_object();
	return UI.__currentlyDraggedWidget < 0 ? undefined : UI.__currentlyDraggedWidget;
}

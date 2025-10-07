/************************************************************************************

	gooey
	Configuration Script
	
*************************************************************************************/

// Change the enum value (UI_MEESAGE_LEVEL) to set the number of messages you receive in the log
// Set it to WARNING or above if running a production build
#macro		UI_LOG_MESSAGE_LEVEL					UI_MESSAGE_LEVEL.WARNING

// Change this to false if your game is 2D. This sets surface_depth_enable.
#macro		UI_ENABLE_DEPTH							false
	
// Change this to Gamemaker values or sprite references if you want to use graphical cursors
#macro		UI_CURSOR_DEFAULT						cr_default
#macro		UI_CURSOR_INTERACT						cr_handpoint
#macro		UI_CURSOR_SIZE_NWSE						cr_size_nwse
#macro		UI_CURSOR_SIZE_NESW						cr_size_nesw
#macro		UI_CURSOR_SIZE_NS						cr_size_ns
#macro		UI_CURSOR_SIZE_WE						cr_size_we
#macro		UI_CURSOR_DRAG							cr_drag

// Default drill through callback functionality
// These variables affect, per each event, whether a callback (for example, MOUSE WHEEL DOWN) is inherited from the parent if no actual callback is specified
// This allows, for example, to add a scroll behavior to a panel, and then make it so you can scroll it no matter if you are over a button or another component
// Note that this can be set up separately on a per-widget basis using the appropriate getters/setters
#macro		UI_DRILL_THROUGH_LEFT_CLICK				false
#macro		UI_DRILL_THROUGH_LEFT_HOLD				false
#macro		UI_DRILL_THROUGH_LEFT_RELEASE			false			
#macro		UI_DRILL_THROUGH_MIDDLE_CLICK			false
#macro		UI_DRILL_THROUGH_MIDDLE_HOLD			false
#macro		UI_DRILL_THROUGH_MIDDLE_RELEASE			false	
#macro		UI_DRILL_THROUGH_RIGHT_CLICK			false
#macro		UI_DRILL_THROUGH_RIGHT_HOLD				false
#macro		UI_DRILL_THROUGH_RIGHT_RELEASE			false
#macro		UI_DRILL_THROUGH_MOUSE_ENTER			false
#macro		UI_DRILL_THROUGH_MOUSE_EXIT				false
#macro		UI_DRILL_THROUGH_MOUSE_OVER				false
#macro		UI_DRILL_THROUGH_MOUSE_WHEEL_UP			true
#macro		UI_DRILL_THROUGH_MOUSE_WHEEL_DOWN		true

// Set this to determine where is gooey rendered. If false, it will render on Draw GUI Begin, if true it will render on Draw GUI End
#macro		UI_DISPLAY_AFTER_GUI_END				false

// Change this variable to specify a different default for the anchor point (relative_to) definition when creating widgets
#macro		UI_DEFAULT_ANCHOR_POINT					UI_RELATIVE_TO.TOP_LEFT
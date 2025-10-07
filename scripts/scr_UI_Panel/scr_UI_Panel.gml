/// @feather ignore all
#region UIPanel
	
	/// @constructor	UIPanel(_id, _x, _y, _width, _height, _sprite, [_relative_to=UI_DEFAULT_ANCHOR_POINT])
	/// @extends		UIWidget
	/// @description	A Panel widget, the main container of the UI system
	/// @param			{String}			_id				The Panel's name, a unique string ID. If the specified name is taken, the panel will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_x				The x position of the Panel, **relative to its parent**, according to the _relative_to parameter
	/// @param			{Real}				_y				The y position of the Panel, **relative to its parent**, according to the _relative_to parameter	
	/// @param			{Real}				_width			The width of the Panel
	/// @param			{Real}				_height			The height of the Panel
	/// @param			{Asset.GMSprite}	_sprite			The sprite ID to use for rendering the Panel
	/// @param			{Enum}				[_relative_to]	The position relative to which the Panel will be drawn. By default, uses UI_DEFAULT_ANCHOR_POINT macro in the config (top left if not changed) <br>
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIPanel}							self
	function UIPanel(_id, _x, _y, _width, _height, _sprite, _relative_to=UI_DEFAULT_ANCHOR_POINT) : __UIWidget(_id, _x, _y, _width, _height, _sprite, _relative_to) constructor {
		#region Private variables
			self.__type = UI_TYPE.PANEL;			
			self.__draggable = true;
			self.__drag_bar_height = 32;
			self.__resizable = true;				
			self.__movable = true;
			self.__resize_border_width = 4;
			self.__title_widget = new UIText(_id+"_PanelTitle", 0, 0, "", UI_RELATIVE_TO.TOP_CENTER);
			self.__title_widget.setEnabled(false); // disallows title text from preventing panel drag
			self.__title_format = "[fa_top][fa_center]";
			self.__close_button = noone;
			self.__close_button_sprite = noone;
			self.__close_button_anchor = UI_RELATIVE_TO.TOP_RIGHT;
			self.__close_button_offset = {x: 0, y: 0};
				
			// Tabs Preparation
			self.__tabs = [[]];
			self.__current_tab = 0;
				
			self.__tab_group = {
				__vertical: false,
				__text_format: "[c_black]"
			}
				
			self.__tab_offset = {x:0, y:0};
			self.__tab_margin = 0;
			self.__tab_spacing = 0;
			self.__tab_size_behavior = UI_TAB_SIZE_BEHAVIOR.MAX;
			self.__tab_size_specific = 0;
			self.__tab_group_control = noone; // This is the UIGroup control for the tab buttons
								
			function __UITab(_sprite = noone, _sprite_mouseover = noone, _sprite_selected = noone) constructor {					
				self.text = "";
				self.text_mouseover = "";
				self.text_selected = "";					
				self.tab_index = 0;
				self.sprite_tab = _sprite;
				self.sprite_tab_mouseover = _sprite_mouseover;
				self.sprite_tab_selected = _sprite_selected;			
				self.image_tab = 0;
				self.image_tab_mouseover = 0;
				self.image_tab_selected = 0;
				self.text_format = "";
				self.text_format_mouseover = "";
				self.text_format_selected = "";
				return self;
			}
				
			// Tab data
			self.__tab_data = [];
				
			// Common widgets
			self.__common_widgets = [];
			self.__children = self.__tabs[self.__current_tab];	// self.__children is a pointer to the tabs array, which will be the one to be populated with widgets with add()
				
			// Modal
			self.__modal = false;
			self.__modal_color = c_black;
			self.__modal_alpha = 0.75;
				
		#endregion
		#region Setters/Getters		
			
			/// @method					getTitle()
			/// @desc					Returns the title of the Panel
			/// @return					{string} The title of the Panel
			self.getTitle = function()							{ return self.__title_widget.getText(); }
			
			/// @method					setTitle(_title)
			/// @description			Sets the title of the Panel
			/// @param					{String} _title	The desired title
			/// @return					{UIPanel}	self
			self.setTitle = function(_title)					{ self.__title_widget.setText(string($"{self.__title_format}{_title}")); return self; }
			
			/// @method					getTitleOffset()
			/// @description			Gets the title offset, starting from the title anchor point.
			/// @return	{Struct}			the title offset as as struct {x, y}
			self.getTitleOffset = function() {
				var _dim = self.__title_widget.getDimensions();
				return {x: _dim.x, y: _dim.y};
			}

			/// @method					setTitleOffset(_offset)
			/// @description			Sets the title offset, starting from the title anchor point.
			/// @param					{Struct}			_offset	a struct with {x, y}
			/// @return					{Struct}		self
			self.setTitleOffset = function(_offset) {
				self.__title_widget.setDimensions(_offset.x, _offset.y);
				return self;
			}

			/// @method					getTitleAnchor()
			/// @description			Gets the anchor for the Panel title, relative to the drag bar
			/// @return					{Enum}	The anchor for the Panel's title, according to UI_RELATIVE.
			self.getTitleAnchor = function() {
				var _dim = self.__title_widget.getDimensions();
				return _dim.relative_to;
			}

			/// @method					setTitleAnchor(_anchor)
			/// @description			Sets the anchor for the Panel title, relative to the drag bar
			/// @param					{Enum}	_anchor	An anchor point for the Panel title, according to UI_RELATIVE.			
			/// @return					{UIPanel}	self
			self.setTitleAnchor = function(_anchor) {
				self.__title_widget.setDimensions(,,,,_anchor);
				return self;
			}
			
			/// @method					getTitleFormat()
			/// @description			Gets the Scribble inline format of the title
			/// @return					{String}	The inline format tags
			self.getTitleFormat = function() {
				return self.__title_format;
			}

			/// @method					setTitleFormat(_format)
			/// @description			Sets the Scribble inline format of the title
			/// @param					{String}	The inline format tags
			/// @return					{UIPanel}	self
			self.setTitleFormat = function(_format) {
				self.__title_format = _format;
				self.setTitle(self.getTitleWidget().getRawText());
				return self;
			}
			
			
			/// @method					getTitleWidget()
			/// @description			Gets the title widget for further handling
			/// @return					{UIText}	the title widget
			self.getTitleWidget = function() {
				return self.__title_widget;
			}
			
			/// @method					getDragBarHeight()
			/// @description			Gets the height of the Panel's drag zone, from the top of the panel downward.			
			/// @return					{Real}	The height in pixels of the drag zone.
			self.getDragBarHeight = function()					{ return self.__drag_bar_height; }
			
			/// @method					setDragBarHeight(_height)
			/// @description			Sets the height of the Panel's drag zon, from the top of the panel downward.
			/// @param					{Real}	_height	The desired height in pixels
			/// @return					{UIPanel}	self
			self.setDragBarHeight = function(_height)			{ self.__drag_bar_height = _height; return self; }
			
			/// @method					getCloseButton()
			/// @description			Gets the close Button reference that is assigned to the Panel
			/// @return					{UIButton}	the Button reference
			self.getCloseButton = function() { return self.__close_button; }
			
			/// @method					setCloseButtonSprite(_button_sprite)
			/// @description			Sets a sprite for rendering the close button for the Panel. If `noone`, there will be no close button.
			/// @param					{Asset.GMSprite}	_button_sprite	The sprite to assign to the Panel close button, or `noone` to remove it
			/// @return					{UIPanel}	self
			self.setCloseButtonSprite = function(_button_sprite) { 
				if (self.__close_button_sprite == noone && _button_sprite != noone) { // Create button					
					self.__close_button_sprite = _button_sprite;
					var _w = sprite_exists(_button_sprite) ? sprite_get_width(_button_sprite) : 0;
					var _h = sprite_exists(_button_sprite) ? sprite_get_height(_button_sprite) : 0;
					self.__close_button = new UIButton(self.__ID+"_CloseButton", self.__close_button_offset.x, self.__close_button_offset.y, _w, _h, "", _button_sprite, self.__close_button_anchor);
					self.__close_button.setCallback(UI_EVENT.LEFT_RELEASE, function() {						
						self.destroy(); // self is UIPanel here
					});
					self.add(self.__close_button, -1); // add to common
				}
				else if (self.__close_button_sprite != noone && _button_sprite != noone) { // Change sprite
					self.__close_button_sprite = _button_sprite;
					self.__close_button.setSprite(_button_sprite);
					var _w = sprite_exists(_button_sprite) ? sprite_get_width(_button_sprite) : 0;
					var _h = sprite_exists(_button_sprite) ? sprite_get_height(_button_sprite) : 0;
					self.__close_button.setDimensions(self.__close_button_offset.x, self.__close_button_offset.y, _w, _h, self.__close_button_anchor);
				}
				else if (self.__close_button_sprite != noone && _button_sprite == noone) { // Destroy button					
					self.remove(self.__close_button.__ID, -1);
					self.__close_button.destroy();
					self.__close_button = noone;
					self.__close_button_sprite = noone;					
				}				
				return self;
			}
				
			/// @method					getCloseButtonOffset()
			/// @description			Gets the close button offset, starting from the close button anchor point.
			/// @return	{Struct}		the close button offset, as a struct {x, y}
			self.getCloseButtonOffset = function() {
				return self.__close_button_offset;
			}

			/// @method					setCloseButtonOffset(_offset)
			/// @description			Sets the close button offset, starting from the close button anchor point.
			/// @param					{Struct}		_offset	the value to set, a struct {x, y}
			/// @return					{Struct}		self
			self.setCloseButtonOffset = function(_offset) {
				self.__close_button_offset = _offset;
				var _w = sprite_exists(self.__close_button_sprite) ? sprite_get_width(self.__close_button_sprite) : 0;
				var _h = sprite_exists(self.__close_button_sprite) ? sprite_get_height(self.__close_button_sprite) : 0;
				if (self.__close_button != noone)	self.__close_button.setDimensions(self.__close_button_offset.x, self.__close_button_offset.y, _w, _h, self.__close_button_anchor);
				return self;
			}

			/// @method					getCloseButtonAnchor()
			/// @description			Gets the anchor for the Panel close button
			/// @return					{Enum}	The anchor for the Panel's close button, according to UI_RELATIVE.
			self.getCloseButtonlAnchor = function()					{ return self.__close_button_anchor; }

			/// @method					setCloseButtonAnchor(_anchor)
			/// @description			Sets the anchor for the Panel close button
			/// @param					{Enum}	_anchor	An anchor point for the Panel close button, according to UI_RELATIVE.			
			/// @return					{UIPanel}	self
			self.setCloseButtonAnchor = function(_anchor) {
				self.__close_button_anchor = _anchor;
				var _w = sprite_exists(self.__close_button_sprite) ? sprite_get_width(self.__close_button_sprite) : 0;
				var _h = sprite_exists(self.__close_button_sprite) ? sprite_get_height(self.__close_button_sprite) : 0;
				if (self.__close_button != noone)	self.__close_button.setDimensions(self.__close_button_offset.x, self.__close_button_offset.y, _w, _h, self.__close_button_anchor);
				return self;
			}
				
			/// @method					getModal()
			/// @description			Gets whether this Panel is modal. <br>
			///							A modal Panel will get focus and disable all other widgets until it's destroyed. Only one Panel can be modal at any one time.
			/// @return					{Bool}	Whether this Panel is modal or not
			self.getModal = function()					{ return self.__modal; }
			
			/// @method					setModal(_modal)
			/// @description			Sets this Panel as modal.<br>
			///							A modal Panel will get focus and disable all other widgets until it's destroyed. Only one Panel can be modal at any one time.
			/// @param					{Bool}	_modal	whether to set this panel as modal
			/// @return					{UIPanel}	self
			self.setModal = function(_modal) {
				var _change = _modal != self.__modal;
				self.__modal = _modal;					
				if (_change) {
					if (self.__modal) {
						global.__gooey_manager_active.setFocusedPanel(self.__ID);
						var _n = array_length(global.__gooey_manager_active.__panels);
						for (var _i=0; _i<_n; _i++) {
							if (global.__gooey_manager_active.__panels[_i].__ID != self.__ID) {
								global.__gooey_manager_active.__panels[_i].setEnabled(false);
								if (global.__gooey_manager_active.__panels[_i].__modal)	global.__gooey_manager_active.__panels[_i].setModal(false);
							}
						}
					}
					else {
						var _n = array_length(global.__gooey_manager_active.__panels);
						for (var _i=0; _i<_n; _i++) {
							if (global.__gooey_manager_active.__panels[_i].__ID != self.__ID) {
								global.__gooey_manager_active.__panels[_i].setEnabled(true);									
							}
						}
					}
				}
				return self;
			}
				
			/// @method					getModalOverlayColor()
			/// @description			Gets the color of the overlay drawn over non-modal Panels when this Panel is modal. If -1, it does not draw an overlay.
			/// @return					{Asset.GMColour}	the color to draw, or -1
			self.getModalOverlayColor = function()					{ return self.__modal_color; }
			
			/// @method					setModalOverlayColor(_color)
			/// @description			Sets the color of the overlay drawn over non-modal Panels when this Panel is modal. If -1, it does not draw an overlay.
			/// @param					{Asset.GMColour}	_color	the color to draw, or -1
			/// @return					{UIPanel}	self
			self.setModalOverlayColor = function(_color)			{ self.__modal_color = _color; return self;	}
					
			/// @method					getModalOverlayAlpha()
			/// @description			Gets the alpha of the overlay drawn over non-modal Panels when this Panel is modal.
			/// @return					{Real}	the alpha to draw the overlay with
			self.getModalOverlayAlpha = function()					{ return self.__modal_alpha; }
			
			/// @method					setModalOverlayAlpha(_alpha)
			/// @description			Sets the alpha of the overlay drawn over non-modal Panels when this Panel is modal.
			/// @param					{Real}	_alpha	the alpha to draw the overlay with
			/// @return					{UIPanel}	self
			self.setModalOverlayAlpha = function(_alpha)			{ self.__modal_alpha = _alpha; return self;	}
				
			/// @method				getMovable()
			/// @description		Gets whether the widget is movable (currently only set for Panels)
			/// @return				{Bool}		the movable value
			self.getMovable = function() {
				return self.__movable;
			}

			/// @method				setMovable(_movable)
			/// @description		Sets whether the widget is movable (currently only set for Panels)
			/// @param				{Bool}		_movable	the value to set
			/// @return				{UIPanel}	self
			self.setMovable = function(_movable) {
				self.__movable = _movable;
				return self;
			}
				
		#endregion	
		#region Setters/Getters - Tab Management
				
			/// @method					getTabSizeBehavior()
			/// @description			Gets the behavior of the tab size (width/length according to tab group orientation), specified by the `UI_TAB_SIZE_BEHAVIOR` enum
			/// @return					{Enum}			the behavior of the tab size
			self.getTabSizeBehavior = function() {
				return self.__tab_size_behavior;
			}

			/// @method					setTabSizeBehavior(_behavior)
			/// @description			Sets the behavior of the tab size (width/length according to tab group orientation), specified by the `UI_TAB_SIZE_BEHAVIOR` enum
			/// @param					{Enum}			_behavior	the behavior of the tab size
			/// @return					{UIPanel}		self
			self.setTabSizeBehavior = function(_behavior) {
				self.__tab_size_behavior = _behavior;
				self.__redimensionTabs();
				return self;
			}
				
			/// @method					getTabSpecificSize()
			/// @description			Gets the specific size set for all tabs, this is used when setting `UI_TAB_SIZE_BEHAVIOR` to `SPECIFIC`.
			/// @return					{Real}			the behavior of the tab size
			self.getTabSpecificSize = function() {
				return self.__tab_size_specific;
			}

			/// @method					setTabSpecificSize(_size)
			/// @description			Sets the specific size set for all tabs, this is used when setting `UI_TAB_SIZE_BEHAVIOR` to `SPECIFIC`.
			/// @param					{Real}			_size	the size to set
			/// @return					{UIPanel}		self
			self.setTabSpecificSize = function(_size) {
				self.__tab_size_specific = _size;
				self.__redimensionTabs();
				return self;
			}
				
			/// @method					getTabOffset()
			/// @description			Gets the tab offset, starting from the tab anchor point.
			/// @return					{Struct}			the struct for the tab control offset {x, y}
			self.getTabOffset = function() {
				return self.__tab_offset;
			}

			/// @method					setTabOffset(_offset)
			/// @description			Sets the the tab offset, starting from the tab anchor point.
			/// @param					{Struct}		_offset		the struct for the tab control offset {x, y}
			/// @return					{UIPanel}		self
			self.setTabOffset = function(_offset) {
				self.__tab_offset = _offset;
				self.__redimensionTabs();
				return self;
			}
			/// @method					getTabMargin()
			/// @description			Gets the value of the tab margin, starting from the tab anchor point.
			/// @return	{Real}			the value of the tab margin
			self.getTabMargin = function() {
				return self.__tab_margin;
			}

			/// @method					setTabMargin(_offset)
			/// @description			Sets the value of the tab margin, starting from the tab anchor point.
			/// @param					{Real}			_margin		the value to set
			/// @return					{UIPanel}		self
			self.setTabMargin= function(_margin) {
				self.__tab_margin = _margin;
				self.__redimensionTabs();
				return self;
			}
				
			/// @method					getTabSpacing()
			/// @description			Gets the value of the tab spacing
			/// @return	{Real}			the value of the tab spacing
			self.getTabSpacing = function() {
				return self.__tab_spacing;
			}

			/// @method					setTabSpacing(_spacing)
			/// @description			Sets the value of the tab spacing
			/// @param					{Real}			_spacing	the value to set
			/// @return					{UIPanel}		self
			self.setTabSpacing = function(_spacing) {
				self.__tab_spacing = _spacing;
				self.__redimensionTabs();
				return self;
			}
			
			/// @method				getRawTabText(_tab)
			/// @description		Gets the title text of the specified tab, without Scribble formatting tags.
			/// @param				{Real}	_tab	The tab to get title text from
			///	@return				{String}	The title text, without Scribble formatting tags
			self.getRawTabText = function(_tab)					{ return UI_TEXT_RENDERER(self.__tab_data[_tab].text).get_text(); }
			
			/// @method				getTabText(_tab)
			/// @description		Gets the title text of the specified tab
			/// @param				{Real}	_tab	The tab to get title text from
			///	@return				{String}	The title text
			self.getTabText = function(_tab)					{ return self.__tab_data[_tab].text; }
				
			/// @method				setTabText(_tab, _text, _set_all_states=true)
			/// @description		Sets the title text of the specified tab
			/// @param				{Real}		_tab	The tab to set title text
			/// @param				{String}	_text	The title text to set
			/// @param				{Bool}		[_set_all_states]	If true, set text for all states (normal/mouseovered/selected). By default, true.
			///	@return				{UIPanel}	self
			self.setTabText = function(_tab, _text, _set_all_states = true)	{
				self.__tab_data[_tab].text = _text; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setText(_text);
				if (_set_all_states) {
					self.setTabTextMouseover(_tab, _text);
					self.setTabTextSelected(_tab, _text);
				}
				return self;
			}
				
			/// @method				getTabTextFormat(_tab)
			/// @description		Gets the text format of the specified tab
			/// @param				{Real}	_tab	The tab to get the text format text from
			///	@return				{String}	The format
			self.getTabTextFormat = function(_tab)					{ return self.__tab_data[_tab].text_format; }
				
			/// @method				setTabTextFormat(_tab, _format)
			/// @description		Sets the text format of the specified tab
			/// @param				{Real}		_tab	The tab to set text format to
			/// @param				{String}	_format	The text format to set
			///	@return				{UIPanel}	self
			self.setTabTextFormat = function(_tab, _format)	{
				self.__tab_data[_tab].text_format = _format; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setTextFormat(_format);
				return self;
			}
				
			/// @method				setTabsTextFormat(_format)
			/// @description		Sets the text format for all tabs
			/// @param				{String}	_format	The text format to set
			///	@return				{UIPanel}	self
			self.setTabsTextFormat = function(_format)	{
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) self.setTabTextFormat(_i, _format);
				return self;
			}
				
			/// @method				getTabTextFormatMouseover(_tab)
			/// @description		Gets the text format of the specified tab when mouseovered
			/// @param				{Real}	_tab	The tab to get the text mouseover format text from
			///	@return				{String}	The format
			self.getTabTextFormatMouseover = function(_tab)					{ return self.__tab_data[_tab].text_format_mouseover; }
				
			/// @method				setTabTextFormatMouseover(_tab, _format)
			/// @description		Sets the text format of the specified tab when mouseovered
			/// @param				{Real}		_tab	The tab to set text format to
			/// @param				{String}	_format	The text format to set
			///	@return				{UIPanel}	self
			self.setTabTextFormatMouseover = function(_tab, _format)	{
				self.__tab_data[_tab].text_format_mouseover = _format; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setTextFormatMouseover(_format);
				return self;
			}
				
			/// @method				setTabsTextFormatMouseover(_format)
			/// @description		Sets the text format for all tabs when mouseovered
			/// @param				{String}	_format	The text format to set
			///	@return				{UIPanel}	self
			self.setTabsTextFormatMouseover = function(_format)	{
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) self.setTabTextFormatMouseover(_i, _format);
				return self;
			}
				
			/// @method				getTabTextFormatSelected(_tab)
			/// @description		Gets the text format of the specified tab when selected 
			/// @param				{Real}	_tab	The tab to get the text format from
			///	@return				{String}	The format
			self.getTabTextFormatSelected = function(_tab)					{ return self.__tab_data[_tab].text_format_selected; }
				
			/// @method				setTabTextFormatSelected(_tab, _format)
			/// @description		Sets the text format of the specified tab when selected
			/// @param				{Real}		_tab	The tab to set text format to
			/// @param				{String}	_format	The text format to set
			///	@return				{UIPanel}	self
			self.setTabTextFormatSelected = function(_tab, _format)	{
				self.__tab_data[_tab].text_format_selected = _format; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setTextFormatClick(_format);
				return self;
			}
				
			/// @method				setTabsTextFormatSelected(_format)
			/// @description		Sets the text format for all tabs when selected
			/// @param				{String}	_format	The text format to set
			///	@return				{UIPanel}	self
			self.setTabsTextFormatSelected = function(_format)	{
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) self.setTabTextFormatSelected(_i, _format);
				return self;
			}
				
			/// @method				getRawTabTextMouseover(_tab)
			/// @description		Gets the title text of the specified tab when mouseovered, without Scribble formatting tags.
			/// @param				{Real}	_tab	The tab to get the mouseover title text from
			///	@return				{String}	The title text when mouseovered, without Scribble formatting tags
			self.getRawTabTextMouseover = function(_tab)		{ return UI_TEXT_RENDERER(self.__tab_data[_tab].text_mouseover).get_text(); }
			
			/// @method				getTabTextMouseover(_tab)
			/// @description		Gets the title text of the specified tab when mouseovered
			/// @param				{Real}	_tab	The tab to get the mouseover title text from
			///	@return				{String}	The title text when mouseovered
			self.getTabTextMouseover = function(_tab)			{ return self.__tab_data[_tab].text_mouseover; }
				
			/// @method				setTabTextMouseover(_tab, _text)
			/// @description		Sets the title text of the specified tab when mouseovered
			/// @param				{Real}		_tab	The tab to set mouseover title text from
			/// @param				{String}	_text	The title text to set when mouseovered
			///	@return				{UIPanel}	self
			self.setTabTextMouseover = function(_tab, _text) {
				self.__tab_data[_tab].text_mouseover = _text;
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setTextMouseover(_text);
				return self;
			}
				
			/// @method				getRawTabTextSelected(_tab)
			/// @description		Gets the title text of the specified tab when selected, without Scribble formatting tags.
			/// @param				{Real}	_tab	The tab to get the selected title text from
			///	@return				{String}	The title text when selected, without Scribble formatting tags
			self.getRawTabTextSelected = function(_tab)		{ return UI_TEXT_RENDERER(self.__tab_data[_tab].text_selected).get_text(); }
			
			/// @method				getTabTextSelected(_tab)
			/// @description		Gets the title text of the specified tab when selected
			/// @param				{Real}	_tab	The tab to get the selected title text from
			///	@return				{String}	The title text when selected
			self.getTabTextSelected = function(_tab)			{ return self.__tab_data[_tab].text_selected; }
				
			/// @method				setTabTextSelected(_tab, _text)
			/// @description		Sets the title text of the specified tab when selected
			/// @param				{Real}		_tab	The tab to set selected title text from
			/// @param				{String}	_text	The title text to set when selected
			///	@return				{UIPanel}	self
			self.setTabTextSelected = function(_tab, _text)	{
				self.__tab_data[_tab].text_selected = _text; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setTextClick(_text);
				return self; 
			}
				
			/// @method				getTabSprite(_tab)
			/// @description		Gets the sprite ID of the specified tab
			/// @param				{Real}		_tab	The tab to get the sprite from
			/// @return				{Asset.GMSprite}	The sprite ID of the specified tab
			self.getTabSprite = function(_tab)				{ return self.__tab_data[_tab].sprite_tab; }
			
			/// @method				setTabSprite(_tab, _sprite)
			/// @description		Sets the sprite to be rendered for this tab
			/// @param				{Real}				_tab		The tab to set the sprite to
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setTabSprite = function(_tab, _sprite)	{
				self.__tab_data[_tab].sprite_tab = _sprite; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setSprite(_sprite);
				self.__redimensionTabs();
				return self;
			}
				
			/// @method				setTabSprites(_sprite)
			/// @description		Sets the sprite to be rendered for all tabs
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setTabSprites = function(_sprite)	{
				var _b = self.__tab_group_control.getChildren();
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) {
					self.__tab_data[_i].sprite_tab = _sprite;						
					_b[_i].setSprite(_sprite);
				}
				self.__redimensionTabs();
				return self;
			}
			
			/// @method				getTabImage(_tab)
			/// @description		Gets the image index of the specified tab
			/// @param				{Real}		_tab	The tab to get the sprite from
			/// @return				{Real}		The image index of the specified tab
			self.getTabImage = function(_tab)				{ return self.__tab_data[_tab].image_tab; }
			
			/// @method				setTabImage(_tab, _index)
			/// @description		Sets the image index of the sprite to be rendered for this tab
			/// @param				{Real}				_tab		The tab to set the image index to
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setTabImage = function(_tab, _index)		{ 
				self.__tab_data[_tab].image_tab = _index; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setImage(_index);
				return self;
			}
				
			/// @method				setTabImages(_tab, _index)
			/// @description		Sets the image index of the sprite to be rendered for all tabs
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setTabImages = function(_index)		{ 
				var _b = self.__tab_group_control.getChildren();
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) {
					self.__tab_data[_i].image_tab = _index; 
					_b[_i].setImage(_index);
				}
				return self;
			}
				
			/// @method				getTabSpriteMouseover(_tab)
			/// @description		Gets the sprite ID of the specified tab when mouseovered
			/// @param				{Real}		_tab	The tab to get the sprite from
			/// @return				{Asset.GMSprite}	The sprite ID of the specified tab when mouseovered
			self.getTabSpriteMouseover = function(_tab)	{ return self.__tab_data[_tab].sprite_tab_mouseover; }
			
			/// @method				setTabSpriteMouseover(_tab, _sprite)
			/// @description		Sets the sprite to be rendered for this tab when mouseovered
			/// @param				{Real}				_tab		The tab to set the sprite to
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setTabSpriteMouseover = function(_tab, _sprite) {
				self.__tab_data[_tab].sprite_tab_mouseover = _sprite;
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setSpriteMouseover(_sprite);
				self.__redimensionTabs();
				return self;
			}
				
			/// @method				setTabSpritesMouseover(_sprite)
			/// @description		Sets the sprite to be rendered for all tabs when mouseovered
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setTabSpritesMouseover = function(_sprite) {
				var _b = self.__tab_group_control.getChildren();
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) {
					self.__tab_data[_i].sprite_tab_mouseover = _sprite;
					_b[_i].setSpriteMouseover(_sprite);
				}					
				self.__redimensionTabs();
				return self;
			}
			
			/// @method				getTabImageMouseover(_tab)
			/// @description		Gets the image index of the specified tab when mouseovered
			/// @param				{Real}		_tab	The tab to get the sprite from
			/// @return				{Real}		The image index of the specified tab when mouseovered
			self.getTabImageMouseover = function(_tab)			{ return self.__tab_data[_tab].image_tab_mouseover; }
			
			/// @method				setTabImageMouseover(_tab, _index)
			/// @description		Sets the image index of the sprite to be rendered for this tab when mouseovered
			/// @param				{Real}				_tab		The tab to set the image index to
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setTabImageMouseover = function(_tab, _index)	{
				self.__tab_data[_tab].image_tab_mouseover = _index; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setImageMouseover(_index);
				return self;
			}
				
			/// @method				setTabImagesMouseover(_index)
			/// @description		Sets the image index of the sprite to be rendered for all tabs when mouseovered
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setTabImagesMouseover = function(_index)	{
				var _b = self.__tab_group_control.getChildren();
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) {
					self.__tab_data[_i].image_tab_mouseover = _index; 
					_b[_i].setImageMouseover(_index);					
				}	
				return self;
			}
				
			/// @method				getTabSpriteSelected(_tab)
			/// @description		Gets the sprite ID of the specified tab when selected
			/// @param				{Real}		_tab	The tab to get the sprite from
			/// @return				{Asset.GMSprite}	The sprite ID of the specified tab when selected
			self.getTabSpriteSelected = function(_tab)			{ return self.__tab_data[_tab].sprite_tab_selected; }
			
			/// @method				setTabSpriteSelected(_tab, _sprite)
			/// @description		Sets the sprite to be rendered for this tab when selected
			/// @param				{Real}				_tab		The tab to set the sprite to
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setTabSpriteSelected = function(_tab, _sprite)	{
				self.__tab_data[_tab].sprite_tab_selected = _sprite; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setSpriteClick(_sprite);
				self.__redimensionTabs();
				return self;
			}
				
			/// @method				setTabSpritesSelected(_tab, _sprite)
			/// @description		Sets the sprite to be rendered for all tabs when selected
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setTabSpritesSelected = function(_sprite)	{
				var _b = self.__tab_group_control.getChildren();
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) {
					self.__tab_data[_i].sprite_tab_selected = _sprite; 
					_b[_i].setSpriteClick(_sprite);
				}	
				self.__redimensionTabs();
				return self;
			}
			
			/// @method				getTabImageSelected(_tab)
			/// @description		Gets the image index of the specified tab when selected
			/// @param				{Real}		_tab	The tab to get the sprite from
			/// @return				{Real}		The image index of the specified tab when selected
			self.getTabImageSelected = function(_tab)			{ return self.__tab_data[_tab].image_tab_selected; }
			
			/// @method				setTabImageSelected(_tab, _index)
			/// @description		Sets the image index of the sprite to be rendered for this tab when selected
			/// @param				{Real}				_tab		The tab to set the image index to
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setTabImageSelected = function(_tab, _index) {
				self.__tab_data[_tab].image_tab_selected = _index; 
				var _b = self.__tab_group_control.getChildren();
				_b[_tab].setImageClick(_index);
				return self;
			}
				
			/// @method				setTabImagesSelected(_index)
			/// @description		Sets the image index of the sprite to be rendered for all tabs when selected
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setTabImagesSelected = function(_index) {
				var _b = self.__tab_group_control.getChildren();
				var _n = self.getTabCount();
				for (var _i=0; _i<_n; _i++) {
					self.__tab_data[_i].image_tab_selected = _index; 
					_b[_i].setImageClick(_index);
				}	
				return self;
			}
				
			/// @method				getSpriteTabBackground()
			/// @description		Gets the sprite ID of the tab header background
			/// @return				{Asset.GMSprite}	The sprite ID of the specified tab header background
			self.getSpriteTabBackground = function()			{ return self.__tab_group_control.getSprite(); }
			
			/// @method				setSpriteTabBackground(_sprite)
			/// @description		Sets the sprite to be rendered for the tab header background
			/// @param				{Asset.GMSprite}	_sprite		The sprite ID
			/// @return				{UIPanel}	self
			self.setSpriteTabBackground = function(_sprite)	{ 
				self.__tab_group_control.setSprite(_sprite);
				self.__redimensionTabs();
				return self; 
			}
			
			/// @method				getImageTabBackground()
			/// @description		Gets the image index of the tab header background
			/// @return				{Real}		The image index of the tab header background
			self.getImageTabBackground = function()			{ return self.__tab_group_control.getImage(); }
			
			/// @method				setImageTabBackground(_index)
			/// @description		Sets the image index of the sprite to be rendered for the tab header background
			/// @param				{Real}				_index		The image index
			/// @return				{UIPanel}	self
			self.setImageTabBackground = function(_index) { 
				self.__tab_group_control.setImage(_index);
				return self; 
			}	
								
			/// @method				getVerticalTabs()
			/// @description		Gets whether the tabs are being rendered vertically
			/// @return				{Bool}		whether the tabs are being rendered vertically
			self.getVerticalTabs = function()			{ return self.__tab_group.__vertical; }
			
			/// @method				setVerticalTabs(_vertical)
			/// @description		Sets whether the tabs are being rendered vertically
			/// @param				{Bool}				_vertical	whether to render tabs vertically
			/// @return				{UIPanel}	self
			self.setVerticalTabs = function(_vertical)	{ 
				var _change = _vertical != self.__tab_group.__vertical;
				self.__tab_group.__vertical = _vertical;
				if (_change) self.__redimensionTabs();
				return self;
			}
				
			/// @method				getTabControl()
			/// @description		Returns the tab control for further processing
			/// @return				{UIGroup}	the tab control, a UIGroup
			self.getTabControl = function()				{ return self.__tab_group_control; }
				
			/// @method				getTabControlVisible()
			/// @description		Returns whether the tab control is visible
			/// @return				{Bool}	whether the tab control is visible
			self.getTabControlVisible = function()		{ return self.__tab_group_control.getVisible(); }
				
			/// @method				setTabControlVisible(_visible)
			/// @description		Sets whether the tab control is visible
			/// @param				{Bool}	_visible	whether the tab control is visible
			/// @return				{UIPanel}	self
			self.setTabControlVisible = function(_visible)		{ self.__tab_group_control.setVisible(_visible); return self; }
								
			/// @method				getTabControlAlignment()
			/// @description		Gets the tab group control alignment (position relative to the Panel)
			/// @return				{Enum}	The tab group control alignment, according to `UI_RELATIVE_TO`.
			self.getTabControlAlignment = function() { return self.__tab_group_control.getDimensions().relative_to; }
				
			/// @method				setTabControlAlignment(_relative_to)
			/// @description		Sets the tab group control alignment (position relative to the Panel)
			/// @param				{Enum}	_relative_to	The tab group control alignment, according to `UI_RELATIVE_TO`.
			/// @return				{UIPanel}	self
			self.setTabControlAlignment = function(_relative_to) {
				self.__tab_group_control.setDimensions(,,,,_relative_to); 
				self.__tab_group_control.__dimensions.calculateCoordinates();
				self.__tab_group_control.__updateChildrenPositions();
				return self;
			}
				
		#endregion	
		#region Methods
				
			self.__draw = function() {
				// Adjust tabs on "max" behavior - specific for resize
				if (array_length(self.__tabs) > 0 && self.__tab_size_behavior == UI_TAB_SIZE_BEHAVIOR.MAX) self.__redimensionTabs();
					
				var _x = self.__dimensions.x;
				var _y = self.__dimensions.y;
				var _width = self.__dimensions.width * global.__gooey_manager_active.getScale();
				var _height = self.__dimensions.height * global.__gooey_manager_active.getScale();
				if (sprite_exists(self.__sprite)) draw_sprite_stretched_ext(self.__sprite, self.__image, _x, _y, _width, _height, self.__image_blend, self.__image_alpha);
			}
			
			self.__generalBuiltInBehaviors = method(self, __builtInBehavior);
			self.__builtInBehavior = function() {
				if (self.__events_fired[UI_EVENT.LEFT_CLICK])	global.__gooey_manager_active.setFocusedPanel(self.__ID);
				__generalBuiltInBehaviors();
			}
			
			self.__drag = function() {										
				if (self.__movable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.DRAG) {
					self.__dimensions.x = global.__gooey_manager_active.__drag_data.__drag_start_x + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x;
					self.__dimensions.y = global.__gooey_manager_active.__drag_data.__drag_start_y + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y;
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_SE) {
					self.__dimensions.width = max(self.__min_width, global.__gooey_manager_active.__drag_data.__drag_start_width + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x);
					self.__dimensions.height = max(self.__min_height, global.__gooey_manager_active.__drag_data.__drag_start_height + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y);
					self.__updateChildrenPositions();					
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_NE) {
					self.__dimensions.width = max(self.__min_width, global.__gooey_manager_active.__drag_data.__drag_start_width + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x);
					self.__dimensions.y = global.__gooey_manager_active.__drag_data.__drag_start_y + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y;
					self.__dimensions.height = max(self.__min_height, global.__gooey_manager_active.__drag_data.__drag_start_height + global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y - device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()));
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_SW) {
					self.__dimensions.x = global.__gooey_manager_active.__drag_data.__drag_start_x + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x;
					self.__dimensions.width = max(self.__min_width, global.__gooey_manager_active.__drag_data.__drag_start_width + global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x - device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()));
					self.__dimensions.height = max(self.__min_height, global.__gooey_manager_active.__drag_data.__drag_start_height + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y);
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_NW) {
					self.__dimensions.x = global.__gooey_manager_active.__drag_data.__drag_start_x + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x;
					self.__dimensions.y = global.__gooey_manager_active.__drag_data.__drag_start_y + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y;
					self.__dimensions.width = max(self.__min_width, global.__gooey_manager_active.__drag_data.__drag_start_width + global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x - device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()));
					self.__dimensions.height = max(self.__min_height, global.__gooey_manager_active.__drag_data.__drag_start_height + global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y - device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()));
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_N) {
					self.__dimensions.y = global.__gooey_manager_active.__drag_data.__drag_start_y + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y;
					self.__dimensions.height = max(self.__min_height, global.__gooey_manager_active.__drag_data.__drag_start_height + global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y - device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()));
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_S) {
					self.__dimensions.height = max(self.__min_height, global.__gooey_manager_active.__drag_data.__drag_start_height + device_mouse_y_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_y);
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_W) {
					self.__dimensions.x = global.__gooey_manager_active.__drag_data.__drag_start_x + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x;
					self.__dimensions.width = max(self.__min_width, global.__gooey_manager_active.__drag_data.__drag_start_width + global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x - device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()));
					self.__updateChildrenPositions();
				}
				else if (self.__resizable && global.__gooey_manager_active.__drag_data.__drag_action == UI_RESIZE_DRAG.RESIZE_E) {
					self.__dimensions.width = max(self.__min_width, global.__gooey_manager_active.__drag_data.__drag_start_width + device_mouse_x_to_gui(global.__gooey_manager_active.getMouseDevice()) - global.__gooey_manager_active.__drag_data.__drag_mouse_delta_x);
					self.__updateChildrenPositions();
				}
			}
			
		#endregion
		#region Methods - Tab Management
			
			self.__redimensionTabs = function() {
				
				// Change the tab control group depending on the setting
				var _buttons = self.__tab_group_control.getChildren(0);
				var _n = array_length(_buttons);
						
				switch (self.__tab_size_behavior) {
					case UI_TAB_SIZE_BEHAVIOR.MAX:
						// Set the max available space to set button width/height
						var _button_size = round(self.__tab_group.__vertical ? (self.getDimensions().height - self.__drag_bar_height - 2*self.__tab_margin - (_n-1)*self.__tab_spacing) / _n : (self.getDimensions().width - self.__tab_offset.x - 2*self.__tab_margin - (_n-1)*self.__tab_spacing) / _n);
						var _x = self.__tab_group.__vertical ? 0 : self.__tab_margin;
						var _y = self.__tab_group.__vertical ? self.__tab_margin : 0;
						var _max_w = 0;
						var _max_h = 0;
						
						for (var _i=0; _i<_n; _i++) {
							// redimension each button
							if (self.__tab_group.__vertical) {
								var _w = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_width(self.__tab_data[_i].sprite_tab) : 0;
								var _h = _button_size;
								_buttons[_i].setDimensions(,,_w,_h);
							}
							else {
								var _w = _button_size;
								var _h = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_height(self.__tab_data[_i].sprite_tab) : 0;
								_buttons[_i].setDimensions(,,_w, _h);
							}
							_max_w = max(_max_w, _w);
							_max_h = max(_max_h, _h);
							
							// reposition each button and calculate x or y position of next one
							_buttons[_i].setDimensions(_x, _y);
							
							if (self.__tab_group.__vertical) {							
								_y += _h + self.__tab_spacing;
							}
							else {
								_x += _w + self.__tab_spacing;
							}							
						}
						
						// Adjust tab control UIGroup size to inherit width/height
						if (self.__tab_group.__vertical) {						
							self.__tab_group_control.setInheritWidth(false);
							self.__tab_group_control.setInheritHeight(true);
							self.__tab_group_control.setDimensions(self.__tab_offset.x,self.__drag_bar_height,_max_w, 1);												
						}
						else {
							self.__tab_group_control.setInheritWidth(true);
							self.__tab_group_control.setInheritHeight(false);
							self.__tab_group_control.setDimensions(0,self.__tab_offset.y,1,_max_h);						
						}
						break;
					case UI_TAB_SIZE_BEHAVIOR.SPECIFIC:
					case UI_TAB_SIZE_BEHAVIOR.SPRITE:
						
						// Calculate total size of UIGroup
						var _x = self.__tab_group.__vertical ? 0 : self.__tab_margin;
						var _y = self.__tab_group.__vertical ? self.__tab_margin : 0;
						var _max_w = 0;
						var _max_h = 0;
						
						for (var _i=0; _i<_n; _i++) {
							// redimension each button
							if (self.__tab_size_behavior == UI_TAB_SIZE_BEHAVIOR.SPECIFIC) {
								if (self.__tab_group.__vertical) {
									var _w = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_width(self.__tab_data[_i].sprite_tab) : 0;
									var _h = self.__tab_size_specific;
									_buttons[_i].setDimensions(,,_w,_h);
									_max_w = max(_max_w, _w);
								}
								else {
									var _w = self.__tab_size_specific;
									var _h = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_height(self.__tab_data[_i].sprite_tab) : 0;
									_buttons[_i].setDimensions(,,_w, _h);
									_max_h = max(_max_h, _h);
								}
							}
							else {
								var _w = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_width(self.__tab_data[_i].sprite_tab) : 0;
								var _h = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_height(self.__tab_data[_i].sprite_tab) : 0;
								_buttons[_i].setDimensions(,,_w,_h);
								_max_w = max(_max_w, _w);
								_max_h = max(_max_h, _h);
							}	
							
							
							// reposition each button and calculate x or y position of next one
							_buttons[_i].setDimensions(_x, _y);
							
							if (self.__tab_group.__vertical) {							
								_y += _h + self.__tab_spacing;
							}
							else {
								_x += _w + self.__tab_spacing;
							}
						}
						
						// Adjust tab control UIGroup to be the needed size
						self.__tab_group_control.setInheritWidth(false);
						self.__tab_group_control.setInheritHeight(false);
						if (self.__tab_group.__vertical) {
							self.__tab_group_control.setDimensions(self.__tab_offset.x,self.__tab_offset.y, _max_w, _y, self.__tab_group_control.getDimensions().relative_to);	
						}
						else {
							self.__tab_group_control.setDimensions(self.__tab_offset.x,self.__tab_offset.y, _x, _max_h, self.__tab_group_control.getDimensions().relative_to);	
						}
						break;
				}
				
					
				// Force update of format for starting tab
				self.gotoTab(self.__current_tab);
			}			
				
			/// @method					addTab([_num_tabs])
			/// @description			Adds new tabs at the end
			/// @param					{Real}	[_num_tabs]	The number of tabs to add. Note that all panels have one tab by default. If not specified, adds one tab.
			/// @return					{UIPanel}	self
			self.addTab = function(_num_tabs=1)	{ 
				repeat(_num_tabs) {
					if (array_length(self.__tab_data) > 0)		array_push(self.__tabs, []);
					var _id_tab = new __UITab();
					array_push(self.__tab_data, _id_tab);
					
					var _n = self.getTabCount() - 1;
					
					if (_n > 0) { // First tab is "by default" and has the scrolling offset set in the UIWidget constructor
						array_push(self.__cumulative_horizontal_scroll_offset, 0);
						array_push(self.__cumulative_vertical_scroll_offset, 0);
					}
					
					_id_tab.text = "Tab "+string(_n+1); 
					_id_tab.text_mouseover = "Tab "+string(_n+1); 
					_id_tab.text_selected = "Tab "+string(_n+1); 
					
					// Calculate total width/height
					var _cum_w = 0;
					var _cum_h = 0;
					for (var _i=0; _i<_n; _i++) {
						_cum_w += sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_width(self.__tab_data[_i].sprite_tab) : 0;
						_cum_h += sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_height(self.__tab_data[_i].sprite_tab) : 0;
					}
					
					// Add corresponding button
					
					var _panel_id = self.__ID;
					var _m = _n == 0 ? 0 : _n-1;
					var _sprite_tab0 = self.getTabSprite(_m);
					var _w = sprite_exists(_sprite_tab0) ? sprite_get_width(_sprite_tab0) : 0;
					var _h = sprite_exists(_sprite_tab0) ? sprite_get_height(_sprite_tab0) : 0;
					
					if (self.__tab_group.__vertical) {
						var _x_button = 0;
						var _y_button = _cum_h;
					}
					else {
						var _x_button = _cum_w;
						var _y_button = 0;
					}
					
					var _button = self.__tab_group_control.add(new UIButton(_panel_id+"_TabControl_Group_TabButton"+string(_n), _x_button, _y_button, _w, _h, self.__tab_group.__text_format+self.getTabText(0), _sprite_tab0), -1);
					_button.setUserData("panel_id", _panel_id);
					_button.setUserData("tab_index", _n);
					
					self.setTabSprite(_n, self.__tab_data[_m].sprite_tab);
					self.setTabImage(_n, self.__tab_data[_m].image_tab);
					self.setTabSpriteMouseover(_n, self.__tab_data[_m].sprite_tab_mouseover);
					self.setTabImageMouseover(_n, self.__tab_data[_m].image_tab_mouseover);
					self.setTabSpriteSelected(_n, self.__tab_data[_m].sprite_tab_selected);
					self.setTabImageSelected(_n, self.__tab_data[_m].image_tab_selected);					
					self.setTabText(_n, "Tab "+string(_n+1));
					self.setTabTextMouseover(_n, "Tab "+string(_n+1));
					self.setTabTextSelected(_n, "Tab "+string(_n+1));
					
					_button.setVisible(self.__tab_group_control.getVisible());
					
					with (_button) {
						setCallback(UI_EVENT.LEFT_RELEASE, function() {
							var _panel = global.__gooey_manager_active.get(self.getUserData("panel_id"));
							var _tab = self.getUserData("tab_index");
							_panel.gotoTab(_tab);	
							_panel.__redimensionTabs();
						});
					}					
				}
				self.setTabControlVisible(self.getTabCount() > 1);
				return self;
			}
				
			/// @method					removeTab([_tab = <current_tab>)
			/// @description			Removes the specified tab. Note, if there is only one tab left, you cannot remove it.
			/// @param					{Real}	[_tab]	The tab number to remove. If not specified, removes the current tab.
			/// @return					{UIPanel}	self
			self.removeTab = function(_tab = self.__current_tab)	{
				var _n = array_length(self.__tabs);
				if (_n > 1) {
					// Remove button and reconfigure the other buttons
						
					var _total = 0;					
					var _w = -1;
					for (var _i=0; _i<_n; _i++) {
						var _widget = self.__tab_group_control.__children[_i];
						var _tab_index = _widget.getUserData("tab_index");
						if (_tab_index == _tab) {
							_w = _widget;
						}
						else if (_tab_index > _tab) {
							var _x_button = (self.__tab_group.__vertical) ? 0 : _total;
							var _y_button = (self.__tab_group.__vertical) ? _total : 0;
							_widget.setDimensions(_x_button, _y_button);
							_widget.setUserData("tab_index", _i-1);
							var _w_tab = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_width(self.__tab_data[_i].sprite_tab) : 0;
							var _h_tab = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_height(self.__tab_data[_i].sprite_tab) : 0;
							_total += ((self.__tab_group.__vertical) ? _h_tab : _w_tab);
						}
						else {
							var _w_tab = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_width(self.__tab_data[_i].sprite_tab) : 0;
							var _h_tab = sprite_exists(self.__tab_data[_i].sprite_tab) ? sprite_get_height(self.__tab_data[_i].sprite_tab) : 0;
							_total += ((self.__tab_group.__vertical) ? _h_tab : _w_tab);
						}
					}
					_w.destroy();
						
					// Remove from arrays
					var _curr_tab = self.__current_tab;
					array_delete(self.__tabs, _tab, 1);
					array_delete(self.__tab_data, _tab, 1);
						
					array_delete(self.__cumulative_horizontal_scroll_offset, _tab, 1);
					array_delete(self.__cumulative_vertical_scroll_offset, _tab, 1);
												
					var _m = array_length(self.__tabs);
					//if (_curr_tab == _m)	self.__current_tab = _m-1;
					if (_curr_tab == _m) {
						self.gotoTab(_m-1);
					}
					else {
						self.gotoTab(self.__current_tab);
					}
					//self.__children = self.__tabs[self.__current_tab];
						
				}
				self.setTabControlVisible(self.getTabCount() > 1);
				return self;
			}
				
			/// @method					nextTab([_wrap = false])
			/// @description			Moves to the next tab
			/// @param					{Bool}	_wrap	If true, tab will return to the first one if called from the last tab. If false (default) and called from the last tab, it will remain in that tab.
			/// @return					{UIPanel}	self
			self.nextTab = function(_wrap = false)	{
				var _target;
				if (_wrap)	_target = (self.__current_tab + 1) % array_length(self.__tabs);
				else		_target = min(self.__current_tab + 1, array_length(self.__tabs)-1);					
				self.gotoTab(_target);
				return self;
			}
				
			/// @method					previousTab([_wrap = false])
			/// @description			Moves to the previous tab
			/// @param					{Bool}	_wrap	If true, tab will jump to the last one if called from the first tab. If false (default) and called from the first tab, it will remain in that tab.
			/// @return					{UIPanel}	self
			self.previousTab = function(_wrap = false)	{
				var _target;
				if (_wrap)	{
					_target = (self.__current_tab - 1);
					if (_target == -1)	 _target = array_length(self.__tabs)-1;
				}
				else		_target = max(_target - 1, 0);					
				self.gotoTab(_target);
				return self;
			}
				
								
			/// @method					gotoTab(_tab)
			/// @description			Moves to the specified tab
			/// @param					{Real}	_tab	The tab number.
			/// @return					{UIPanel}	self
			self.gotoTab = function(_tab)	{
				var _old = self.__current_tab;
				var _new = _tab;
				var _changed = (_old != _new);
				if (_changed) self.__tab_group_control.__callbacks[UI_EVENT.VALUE_CHANGED](_old, _new);
				
				self.__current_tab = _new;
					
				self.__children = self.__tabs[self.__current_tab];
				for (var _i=0, _n=array_length(self.__tabs); _i<_n; _i++) {
					var _button = self.__tab_group_control.__children[_i];
					if (_button.getUserData("tab_index") == _tab) {
						_button.setSprite(self.__tab_data[_i].sprite_tab_selected);
						_button.setImage(self.__tab_data[_i].image_tab_selected);
						_button.setText(self.__tab_data[_i].text_selected);
						_button.setTextFormat(self.__tab_data[_i].text_format_selected);
					}
					else {
						_button.setSprite(self.__tab_data[_i].sprite_tab);
						_button.setImage(self.__tab_data[_i].image_tab);
						_button.setText(self.__tab_data[_i].text);
						_button.setTextFormat(self.__tab_data[_i].text_format);
					}
				}
				
				return self;
			}
				
			/// @method					getTabCount()
			/// @description			Gets the tab count for the widget. If this is a non-tabbed widget, it will return 0.
			/// @return					{Real}	The tab count for this Widget.
			self.getTabCount = function()	{
				if (self.__type == UI_TYPE.PANEL)	return array_length(self.__tabs);
				else								return 0;
			}
				
			/// @method					getTabTitle(_tab)
			/// @description			Gets the tab title of the specified tab
			/// @param					{Real}		_tab	The tab number
			/// @return					{String}	The tab title for _tab
			self.getTabTitle = function(_tab) {
				return self.getRawTabText(_tab);
			}
				
			/// @method				getCurrentTab()
			/// @description		Gets the index of the selected tab
			/// @return				{Real}	the index of the currently selected tab
			self.getCurrentTab = function()					{ return self.__current_tab; }
				
				
		#endregion
			
		// Register before tab controls so it has the final ID
		self.__register();

		#region Tab Control Initial Setup
			
			var _w = 0;
			var _h = 0;
			var _panel_id = self.__ID;
			if (self.__tab_group.__vertical) {
				self.__tab_group_control = self.add(new UIGroup(_panel_id+"_TabControl_Group", 0, 0, _w, 1, noone, UI_RELATIVE_TO.TOP_LEFT), -1);
				self.__tab_group_control.setInheritHeight(true);
			}
			else {
				self.__tab_group_control = self.add(new UIGroup(_panel_id+"_TabControl_Group", 0, 0, 1, _h, noone, UI_RELATIVE_TO.TOP_LEFT), -1);
				self.__tab_group_control.setInheritWidth(true);
			}
			
			
			self.addTab();
			self.gotoTab(0);
				
		#endregion
			
		self.setClipsContent(true);
		self.add(self.__title_widget, -1);
			
		return self;
	}
	
#endregion
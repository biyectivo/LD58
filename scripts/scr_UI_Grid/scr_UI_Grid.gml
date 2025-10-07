/// @feather ignore all
#region UIGrid
	
	/// @constructor	UIGrid(_id, _width, _height, _rows, _cols)
	/// @extends		UIWidget
	/// @description	A Grid widget, that enables adding other widgets to a Panel on a specific row/col
	/// @param			{String}			_id				The Grid's name, a unique string ID. If the specified name is taken, the Group will be renamed and a message will be displayed on the output log.
	/// @param			{Real}				_rows			The number of rows of the Grid
	/// @param			{Real}				_columns		Ths number of columns of the Grid
	///														See the [UIWidget](#UIWidget) documentation for more info and valid values.
	/// @return			{UIGroup}							self
	function UIGrid(_id, _rows, _columns) : __UIWidget(_id, 0, 0, 0, 0, noone, UI_RELATIVE_TO.TOP_LEFT) constructor {
		#region Private variables
			self.__type = UI_TYPE.GRID;	
			self.__rows = _rows;
			self.__columns = _columns;
			self.__margin_top = 0;
			self.__margin_bottom = 0;
			self.__margin_left = 0;
			self.__margin_right = 0;
			self.__spacing_horizontal = 0;				
			self.__spacing_vertical = 0;				
			self.__row_proportions = [];
			self.__column_proportions = [];
			self.__show_grid_overlay = false;	
			self.__cells_clip_contents = false;
		#endregion
		#region Setters/Getters
			/// @method				getRows()
			/// @description		Gets the number of rows of the grid
			///	@return				{Real}	the number of rows of the grid
			self.getRows = function()				{ return self.__rows; }
			
			/// @method				getColumns()
			/// @description		Gets the number of columns of the grid
			///	@return				{Real}	the number of columns of the grid
			self.getColumns = function()				{ return self.__columns; }
			
			/// @method				getMarginTop()
			/// @description		Gets the top margin amount in pixels of the grid with respect to the container's borders
			///	@return				{Real}	the margin in px
			self.getMarginTop = function()				{ return self.__margin_top; }
			
			/// @method				setMarginTop(_margin)
			/// @description		Sets the top margin amount in pixels of the grid with respect to the container's borders
			/// @param				{Real}	_margin		the desired margin
			/// @return				{UIGrid}	self
			self.setMarginTop = function(_margin)	{ 
				self.__margin_top = _margin; 
				self.__updateGridDimensions();
				return self; 
			}
				
			/// @method				getMarginBottom()
			/// @description		Gets the bottom margin amount in pixels of the grid with respect to the container's borders
			///	@return				{Real}	the margin in px
			self.getMarginBottom = function()				{ return self.__margin_bottom; }
			
			/// @method				setMarginBottom(_margin)
			/// @description		Sets the bottom margin amount in pixels of the grid with respect to the container's borders
			/// @param				{Real}	_margin		the desired margin
			/// @return				{UIGrid}	self
			self.setMarginBottom = function(_margin)	{ 
				self.__margin_bottom = _margin; 
				self.__updateGridDimensions();
				return self; 
			}
				
			/// @method				getMarginLeft()
			/// @description		Gets the left margin amount in pixels of the grid with respect to the container's borders
			///	@return				{Real}	the margin in px
			self.getMarginLeft = function()				{ return self.__margin_left; }
			
			/// @method				setMarginLeft(_margin)
			/// @description		Sets the left margin amount in pixels of the grid with respect to the container's borders
			/// @param				{Real}	_margin		the desired margin
			/// @return				{UIGrid}	self
			self.setMarginLeft = function(_margin)	{ 
				self.__margin_left = _margin; 
				self.__updateGridDimensions();
				return self; 
			}
				
			/// @method				getMarginRight()
			/// @description		Gets the right margin amount in pixels of the grid with respect to the container's borders
			///	@return				{Real}	the margin in px
			self.getMarginRight = function()				{ return self.__margin_right; }
			
			/// @method				setMarginRight(_margin)
			/// @description		Sets the right margin amount in pixels of the grid with respect to the container's borders
			/// @param				{Real}	_margin		the desired margin
			/// @return				{UIGrid}	self
			self.setMarginRight = function(_margin)	{ 
				self.__margin_right = _margin; 
				self.__updateGridDimensions();
				return self; 
			}
				
			/// @method				setMargins(_margin)
			/// @description		Sets all margins to the same amount in pixels of the grid with respect to the container's borders
			/// @param				{Real}	_margin		the desired margin
			/// @return				{UIGrid}	self
			self.setMargins = function(_margin)	{ 
				self.__margin_top = _margin; 
				self.__margin_bottom = _margin; 
				self.__margin_left = _margin; 
				self.__margin_right = _margin; 
				self.__updateGridDimensions();
				return self; 
			}
				
				
			/// @method				getSpacingHorizontal()
			/// @description		Gets the horizontal spacing in pixels between cells of the grid
			///	@return				{Real}	the spacing in px
			self.getSpacingHorizontal = function()				{ return self.__spacing_horizontal; }
			
			/// @method				setSpacingHorizontal(_spacing)
			/// @description		Sets the horizontal spacing in pixels between cells of the grid
			/// @param				{Real}	_spacing		the desired spacing
			/// @return				{UIGrid}	self
			self.setSpacingHorizontal = function(_spacing) {
				self.__spacing_horizontal = _spacing; 
				self.__updateGridDimensions();
				return self;
			}
				
				
			/// @method				getSpacingVertical()
			/// @description		Gets the vertical spacing in pixels between cells of the grid
			///	@return				{Real}	the spacing in px
			self.getSpacingVertical = function()				{ return self.__spacing_vertical; }
			
			/// @method				setSpacingVertical(_spacing)
			/// @description		Sets the vertical spacing in pixels between cells of the grid
			/// @param				{Real}	_spacing		the desired spacing
			/// @return				{UIGrid}	self
			self.setSpacingVertical = function(_spacing) {
				self.__spacing_vertical = _spacing; 
				self.__updateGridDimensions();
				return self;
			}
				
			/// @method				setSpacings(_spacing)
			/// @description		Sets both horizontal and vertical spacings to the same amount in pixels between cells of the grid
			/// @param				{Real}	_spacing		the desired spacing
			/// @return				{UIGrid}	self
			self.setSpacings = function(_spacing) {
				self.__spacing_horizontal = _spacing; 
				self.__spacing_vertical = _spacing; 
				self.__updateGridDimensions();
				return self;
			}
				
				
			/// @method				getRowProportions()
			/// @description		Gets an array with the percent proportions of each row's height with respect to the usable area of the grid.<br>
			///						The usable area of the grid is the container's size minus the margin and spacing.
			///	@return				{Real}	the row proportions
			self.getRowProportions = function()				{ return self.__row_proportions; }
			
			/// @method				setRowProportions(_row_proportions)
			/// @description		Sets an array with the percent proportions of each row's height with respect to the usable area of the grid.<br>
			///						The usable area of the grid is the container's size minus the margin and spacing.
			/// @param				{Array<Real>}	_row_proportions		the desired row proportions
			/// @return				{UIGrid}	self
			self.setRowProportions = function(_row_proportions) { 
				self.__row_proportions = _row_proportions; 
				self.__updateGridDimensions();
				return self;
			}
				
			/// @method				getColumnProportions()
			/// @description		Gets an array with the percent proportions of each column's width with respect to the usable area of the grid.<br>
			///						The usable area of the grid is the container's size minus the margin and spacing.
			///	@return				{Real}	the column proportions
			self.getColumnProportions = function()				{ return self.__column_proportions; }
			
			/// @method				setColumnProportions(_column_proportions)
			/// @description		Sets an array with the percent proportions of each column's width with respect to the usable area of the grid.<br>
			///						The usable area of the grid is the container's size minus the margin and spacing.
			/// @param				{Array<Real>}	_column_proportions		the desired column proportions
			/// @return				{UIGrid}	self
			self.setColumnProportions = function(_column_proportions) {
				self.__column_proportions = _column_proportions; 
				self.__updateGridDimensions();
				return self;
			}
				
			/// @method				resetRowProportions()
			/// @description		Resets the row proportions to the default (equal, uniform proportions for each row's height)
			/// @return				{UIGrid}	self
			self.resetRowProportions = function(_update = true)	{
				self.__row_proportions = [];
				for (var _row=0; _row<self.__rows; _row++)	array_push(self.__row_proportions, 1/self.__rows);
				if (_update) self.__updateGridDimensions();
				return self;
			}
				
			/// @method				resetColumnProportions()
			/// @description		Resets the column proportions to the default (equal, uniform proportions for each column's width)
			/// @return				{UIGrid}	self
			self.resetColumnProportions = function(_update = true)	{
				self.__column_proportions = [];
				for (var _col=0; _col<self.__columns; _col++)	array_push(self.__column_proportions, 1/self.__columns);
				if (_update) self.__updateGridDimensions();
				return self;
			}
				
			/// @method				getCell(_row, _col) 
			/// @description		Gets the UIGroup widget corresponding to the specified row, column coordinate of the UIGrid
			///	@return				{UIGroup}	a UIGroup widget
			self.getCell = function(_row, _col) { 
				var _grp = global.__gooey_manager_active.get(self.__ID+"_CellGroup_"+string(_row)+"_"+string(_col));
				return _grp;
			}
			
			/// @method				setShowGridOverlay(_show)
			/// @description		Sets whether the grid outline is shown (useful for placing items at development)
			/// @param				{Bool}	_show		whether the overlay is shown
			/// @return				{UIGrid}	self
			self.setShowGridOverlay = function(_show) {
				self.__show_grid_overlay = _show; 
				self.__updateDebugGridCells();
				return self;
			}
				
			/// @method				getShowGridOverlay()
			/// @description		Gets whether the grid outline is shown (useful for placing items at development)
			///	@return				{Bool}	whether the overlay is shown
			self.getShowGridOverlay = function()				{ return self.__show_grid_overlay; }
			
			/// @method				getCellsClipContents()
			/// @description		Gets whether the cells of the grid clip their contents. This affects all cells - to affect just one, it can also be set individually by using getCell() and then setClipsContent().
			///	@return				{Bool}	whether the grid clips contents in all cells
			self.getCellsClipContents = function()				{ return self.__cells_clip_contents; }
			
			/// @method				setCellsClipContents(_clip)
			/// @description		Sets whether the cells of the grid clip their contents. This affects all cells - to affect just one, it can also be set individually by using getCell() and then setClipsContent().
			/// @param				{Bool}		_clip	whether all cells clip contents or not
			/// @return				{UIGrid}	self
			self.setCellsClipContents = function(_clip)	{ 
				self.__cells_clip_contents = _clip;
				return self; 
			}
				
		#endregion
		#region Methods
			self.__updateDebugGridCells = function() {
				for (var _row = 0; _row < self.__rows; _row++) {
					for (var _col = 0; _col < self.__columns; _col++) {
						var _grp = global.__gooey_manager_active.get(self.__ID+"_CellGroup_"+string(_row)+"_"+string(_col));
						_grp.__debug_draw = self.__show_grid_overlay;
					}
				}
			}
			
			self.__col_width = function(_col) {
				if (_col < 0 || _col >= self.__columns)	return -1;
				else {
					var _width = self.__dimensions.width * global.__gooey_manager_active.getScale();
					var _usable_width = _width - self.__margin_left - self.__margin_right - (self.__columns-1)*self.__spacing_horizontal;
					var _col_width = self.__column_proportions[_col] * _usable_width;
					return _col_width;
				}
			}
			self.__row_height = function(_row) {
				if (_row < 0 || _row >= self.__rows)	return -1;
				else {
					var _height = self.__dimensions.height * global.__gooey_manager_active.getScale();
					var _usable_height = _height - self.__margin_top - self.__margin_bottom - (self.__rows-1)*self.__spacing_vertical;
					var _row_height = self.__row_proportions[_row] * _usable_height;
					return _row_height;
				}
			}
			self.__col_to_x = function(_col) {
				if (_col < 0 || _col >= self.__columns)	return -1;
				else {
					var _x = self.__dimensions.x;
					var _width = self.__dimensions.width * global.__gooey_manager_active.getScale();
					var _usable_width = _width - self.__margin_left - self.__margin_right - (self.__columns-1)*self.__spacing_horizontal;
					_x += self.__margin_left;
					for (var _c=0; _c<_col; _c++) {
						var _col_width = self.__column_proportions[_c] * _usable_width;
						_x += _col_width;
						if (_c < self.__columns-1)	_x += self.__spacing_horizontal;
					}
				}
				var _col_width = self.__column_proportions[_col] * _usable_width;
					
				return _x;
			}
				
			self.__row_to_y = function(_row) {
				if (_row < 0 || _row >= self.__rows)	return -1;
				else {
					var _y = self.__dimensions.y;
					var _height = self.__dimensions.height * global.__gooey_manager_active.getScale();
					var _usable_height = _height - self.__margin_top - self.__margin_bottom - (self.__rows-1)*self.__spacing_vertical;
					_y += self.__margin_top;
					for (var _r=0; _r<_row; _r++) {
						var _row_height = self.__row_proportions[_r] * _usable_height;
						_y += _row_height;
						if (_r < self.__rows-1)	_y += self.__spacing_vertical;
					}
				}
				var _row_height = self.__row_proportions[_row] * _usable_height;
					
				return _y;
			}
				
			self.addToCell = function(_widget, _row, _col) {
				if (_widget.__type == UI_TYPE.PANEL)	throw("ERROR: Cannot add a Panel to a Grid");
				if (_row >= self.__rows || _row < 0)	throw($"ERROR: Row index {_row} out of bounds for grid '{self.__ID}' (must be between 0 and {self.__rows-1})");
				if (_col >= self.__columns || _col < 0)	throw($"ERROR: Column index {_col} out of bounds for grid '{self.__ID}' (must be between 0 and {self.__columns-1})");
				var _grp = global.__gooey_manager_active.get(self.__ID+"_CellGroup_"+string(_row)+"_"+string(_col));
				_grp.add(_widget);
				return _widget;
			}
				
				
			self.__updateGridDimensions = function() {
				if (self.getParent() != noone) {
					var _parent = self.getParent();
					var _parent_dim = _parent.getDimensions();
				}
				else {
					var _parent_dim = {x: 0, y: 0};
				}
					
				for (var _row = 0; _row < self.__rows; _row++) {
					for (var _col = 0; _col < self.__columns; _col++) {
						var _widget = global.__gooey_manager_active.get(self.__ID+"_CellGroup_"+string(_row)+"_"+string(_col));
						var _x = self.__col_to_x(_col) - _parent_dim.x;
						var _y = self.__row_to_y(_row) - _parent_dim.y;
						var _w = self.__col_width(_col);
						var _h = self.__row_height(_row);
						_widget.setDimensions(_x, _y, _w, _h);
					}
				}
			}
				
			self.__createGrid = function() {
				for (var _row = 0; _row < self.__rows; _row++) {
					for (var _col = 0; _col < self.__columns; _col++) {
						var _x = self.__col_to_x(_col);
						var _y = self.__row_to_y(_row);
						var _w = self.__col_width(_col);
						var _h = self.__row_height(_row);
						var _widget = new UIGroup(self.__ID+"_CellGroup_"+string(_row)+"_"+string(_col), _x, _y, _w, _h, noone);
						_widget.setClipsContent(self.__cells_clip_contents);
						self.add(_widget);
					}
				}
			}
				
				
			self.__draw = function() {
					
			}
				
		#endregion
			
		// Initialize - Set w/h and default proportions
		self.resetRowProportions(false);
		self.resetColumnProportions(false);			
		self.__createGrid();
		self.setInheritWidth(true);
		self.setInheritHeight(true);			
		self.__register();			
		return self;
	}
	
#endregion

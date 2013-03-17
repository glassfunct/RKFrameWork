package com.rekoo.display.component
{
	import com.rekoo.RKDirection;
	import com.rekoo.display.RKSprite;
	import com.rekoo.interfaces.IRKSprite;
	import com.rekoo.interfaces.IRKTile;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 表格。
	 * @author Administrator
	 * 
	 */	
	public class RKTileList extends RKSprite
	{
		private var _data:Array = null;
		private var _items:Array = [];
		
		private var _cols:int = 0;
		private var _rows:int = 0;
		private var _colWidth:Number = 0.0;
		private var _rowHeight:Number = 0.0;
		private var _colSpace:Number = 0.0;
		private var _rowSpace:Number = 0.0;
		private var _tileRenderer:Class = null;
		private var _pLeft:Number = 0.0;
		private var _pTop:Number = 0.0;
		private var _showEmptyTile:Boolean = false;
		private var _prefDirect:String = null;
		
		private var _selectedItem:IRKTile = null;
		
		private var _onItemSelected:Function = null;
		private var _onItemOver:Function = null;
		private var _onItemOut:Function = null;
		
		/**
		 * 表格。
		 * @param cols_ 列数。
		 * @param rows_ 行数。
		 * @param colWidth_ 列宽。
		 * @param rowHeight_ 行高。
		 * @param colSpace_ 列间隔。
		 * @param rowSpace_ 行间隔。
		 * @param tileRenderer_ 单元格渲染器。
		 * @param paddingLeft_ 左侧空白。
		 * @param paddingTop_ 上部空白。
		 * @param skin_ 皮肤。
		 * @param showEmptyTile_ 是否显示空格子。
		 * @param prefDirect_ 优先排列方向。
		 * 
		 */		
		public function RKTileList(cols_:int, 
								   rows_:int, 
								   colWidth_:Number, 
								   rowHeight_:Number, 
								   colSpace_:int, 
								   rowSpace_:int, 
								   tileRenderer_:Class, 
								   paddingLeft_:Number = 0.0, 
								   paddingTop_:Number = 0.0, 
								   skin_:DisplayObject=null, 
								   showEmptyTile_:Boolean = false,
								   prefDirect_:String = "HORIZONTAL")
		{
			_cols = cols_;
			_rows = rows_;
			_colWidth = colWidth_;
			_rowHeight = rowHeight_;
			_colSpace = colSpace_;
			_rowSpace = rowSpace_;
			_tileRenderer = tileRenderer_;
			_pLeft = paddingLeft_;
			_pTop = paddingTop_;
			_showEmptyTile = showEmptyTile_;
			_prefDirect = prefDirect_;
			super(skin_);
		}
		
		public function set data(value:Array):void
		{
			_data = value;
			refresh();
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		/**
		 * 刷新显示。一般在设置数据后自动调用。
		 * 
		 */		
		public function refresh():void
		{
			_selectedItem = null;
			
			if ( _items.length )
			{
				for each ( var _item:IRKTile in _items )
				{
					(_item as DisplayObject).removeEventListener(MouseEvent.ROLL_OVER, onItemMOver);
					(_item as DisplayObject).removeEventListener(MouseEvent.ROLL_OUT, onItemMOut);
					(_item as DisplayObject).removeEventListener(MouseEvent.CLICK, onItemMClick);
					_item.dispose();
				}
				
				_items.length = 0;
			}
			
			if ( (_data != null || _showEmptyTile) && (_data.length > 0 || _showEmptyTile) && _tileRenderer != null )
			{
				var _len:int = _data ? _data.length : 0;
				
				if ( _showEmptyTile )
				{
					if ( _prefDirect == RKDirection.HORIZONTAL )
					{
						//优先横向显示。
						_len = Math.ceil(_len / _cols) * _cols;
					}
					else if ( _prefDirect == RKDirection.VERTICAL )
					{
						//优先纵向显示。
						_len = Math.ceil(_len / _rows) * _rows;
					}
					
					_len = Math.max(_len, _cols * _rows);
				}
				
				var _curCol:int = 0;
				var _curRow:int = 0;
				
				for ( var _i:int = 0; _i < _len; _i ++ )
				{
					var _newItem:IRKTile = new _tileRenderer();
					_newItem.onSelected = onItemSelect;
					_newItem.x = _curCol * (_colWidth + _colSpace) + _pLeft;
					_newItem.y = _curRow * (_rowHeight + _rowSpace) + _pTop;
					_newItem.enabled = enabled;
					_newItem.selectable = selectable;
					(_newItem as DisplayObject).addEventListener(MouseEvent.ROLL_OVER, onItemMOver);
					(_newItem as DisplayObject).addEventListener(MouseEvent.ROLL_OUT, onItemMOut);
					(_newItem as DisplayObject).addEventListener(MouseEvent.CLICK, onItemMClick);
					_newItem.data = _data[_i] ? _data[_i] : null;
					addChild(_newItem as DisplayObject);
					_items[_i] = _newItem;
					
					if ( _prefDirect == RKDirection.HORIZONTAL )
					{
						//优先横向显示。
						_curCol ++;
						
						if ( _curCol == _cols )
						{
							_curCol = 0;
							_curRow ++;
						}
					}
					else if ( _prefDirect == RKDirection.VERTICAL )
					{
						//优先纵向显示。
						_curRow ++;
						
						if ( _curRow == _rows )
						{
							_curRow = 0;
							_curCol ++;
						}
					}
				}
			}
		}
		
		private function onItemMOver(evt_:MouseEvent):void
		{
			if ( _onItemOver != null )
			{
				if ( _onItemOver.length )
				{
					_onItemOver(evt_.currentTarget as IRKTile);
				}
				else
				{
					_onItemOver();
				}
			}
		}
		
		private function onItemMOut(evt_:MouseEvent):void
		{
			if ( _onItemOut != null )
			{
				if ( _onItemOut.length )
				{
					_onItemOut(evt_.currentTarget as IRKTile);
				}
				else
				{
					_onItemOut();
				}
			}
		}
		
		private function onItemMClick(evt_:MouseEvent):void
		{
			if ( enabled && selectable && (evt_.currentTarget as IRKTile).data )
			{
				(evt_.currentTarget as IRKTile).selected = true;
			}
		}
		
		private function onItemSelect(item_:IRKTile):void
		{
			_selectedItem = item_;
			
			for each ( var _item:IRKTile in _items )
			{
				if ( _item != item_ )
				{
					_item.selected = false;
				}
			}
			
			if ( _onItemSelected != null )
			{
				if ( _onItemSelected.length )
				{
					onItemSelected(_selectedItem);
				}
				else
				{
					onItemSelected();
				}
			}
		}

		/**
		 * 列数。
		 */
		public function get cols():int
		{
			return _cols;
		}

		/**
		 * @private
		 */
		public function set cols(value:int):void
		{
			_cols = value;
		}

		/**
		 * 行数。
		 */
		public function get rows():int
		{
			return _rows;
		}

		/**
		 * @private
		 */
		public function set rows(value:int):void
		{
			_rows = value;
		}

		/**
		 * 列宽。
		 */
		public function get colWidth():Number
		{
			return _colWidth;
		}

		/**
		 * @private
		 */
		public function set colWidth(value:Number):void
		{
			_colWidth = value;
		}

		/**
		 * 行高。
		 */
		public function get rowHeight():Number
		{
			return _rowHeight;
		}

		/**
		 * @private
		 */
		public function set rowHeight(value:Number):void
		{
			_rowHeight = value;
		}

		/**
		 * 列间距。
		 */
		public function get colSpace():Number
		{
			return _colSpace;
		}

		/**
		 * @private
		 */
		public function set colSpace(value:Number):void
		{
			_colSpace = value;
		}

		/**
		 * 行间距。
		 */
		public function get rowSpace():Number
		{
			return _rowSpace;
		}

		/**
		 * @private
		 */
		public function set rowSpace(value:Number):void
		{
			_rowSpace = value;
		}

		/**
		 * 单元格渲染器。
		 */
		public function get tileRenderer():Class
		{
			return _tileRenderer;
		}

		/**
		 * @private
		 */
		public function set tileRenderer(value:Class):void
		{
			_tileRenderer = value;
		}

		/**
		 * 优先排列方向。
		 */
		public function get prefDirect():String
		{
			return _prefDirect;
		}

		/**
		 * @private
		 */
		public function set prefDirect(value:String):void
		{
			_prefDirect = value;
		}
		
		/**
		 * 单元格渲染器列表。
		 */		
		public function get items():Array
		{
			return _items;
		}
		
		/**
		 * 当前选中单元格。
		 */
		public function get selectedItem():IRKTile
		{
			return _selectedItem;
		}
		
		/**
		 * @private
		 */
		public function set selectedItem(value:IRKTile):void
		{
			if ( _selectedItem != value )
			{
				if ( _selectedItem )
				{
					_selectedItem.selected = false;
				}
				
				if ( value != null )
				{
					value.selected = true;
				}
				else
				{
					onItemSelect(null);
				}
			}
		}
		
		/**
		 * 当前选中序号。
		 */
		public function get selectedIndex():int
		{
			var _len:int = _items.length;
			
			for ( var _i:int = 0; _i < _len; _i ++ )
			{
				if ( _items[_i] == _selectedItem )
				{
					return _i;
				}
			}
			
			return -1;
		}
		
		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if ( _items )
			{
				if ( value > -1 && value < _items.length )
				{
					_items[value].selected = true;
				}
				else
				{
					if ( _selectedItem )
					{
						_selectedItem.selected = false;
						onItemSelect(null);
					}
				}
			}
		}
		
		/**
		 * 选中单元格后的回调。
		 */
		public function get onItemSelected():Function
		{
			return _onItemSelected;
		}
		
		/**
		 * @private
		 */
		public function set onItemSelected(value:Function):void
		{
			_onItemSelected = value;
		}
		
		/**
		 * 鼠标移入单元格后的回调。
		 */
		public function get onItemOver():Function
		{
			return _onItemOver;
		}
		
		/**
		 * @private
		 */
		public function set onItemOver(value:Function):void
		{
			_onItemOver = value;
		}
		
		/**
		 * 鼠标移出单元格后的回调。
		 */
		public function get onItemOut():Function
		{
			return _onItemOut;
		}
		
		/**
		 * @private
		 */
		public function set onItemOut(value:Function):void
		{
			_onItemOut = value;
		}
		
		/**
		 * 左侧空白。
		 */
		public function get paddingLeft():Number
		{
			return _pLeft;
		}
		
		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			_pLeft = value;
		}
		
		/**
		 * 上部空白。
		 */
		public function get paddingTop():Number
		{
			return _pTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			_pTop = value;
		}
		
		override public function set selectable(value:Boolean):void
		{
			super.selectable = value;
			buttonMode = false;
		}
	}
}
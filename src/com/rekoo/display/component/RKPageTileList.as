package com.rekoo.display.component
{
	import com.rekoo.interfaces.IRKTile;

	public class RKPageTileList
	{
		protected var _tileList:RKTileList = null;
		protected var _pageStepper:RKPageStepper = null;
		
		private var _itemsPerPage:int = 0;
		
		private var _data:Array = null;
		
		private var _onChange:Function = null;
		private var _itemSelected:Function = null;
		
		/**
		 * 带翻页功能的表格。
		 * @param tileList_ 表格。单独设置tileList_的onItemSelected无效。
		 * @param pageStepper_ 翻页器。单独设置pageStepper_的onChange无效。
		 * @param onPageChange_ 当前页发生变化后的回调。
		 * 
		 */		
		public function RKPageTileList(tileList_:RKTileList, pageStepper_:RKPageStepper, onPageChange_:Function = null):void
		{
			_tileList = tileList_;
			_pageStepper = pageStepper_;
			_itemsPerPage = _tileList.cols * _tileList.rows;
			
			_tileList.onItemSelected = onItemSelected;
			_pageStepper.onChange = onPageChanged;
			_onChange = onPageChange_;
		}
		
		/**
		 * 设置数据。会自动把当前页设置为第一页并调用onPageChange,在onPageChange内会重新设置tileList的数据。
		 */		
		public function set data(value:Array):void
		{
			_data = value;
			_pageStepper.totalPages = Math.ceil(_data.length / _itemsPerPage);
			
			if ( _pageStepper.currentPage == 1 )
			{
				onPageChanged();
			}
			else
			{
				_pageStepper.currentPage = 1;
			}
		}
		
		public function get data():Array
		{
			return _data;
		}
		
		protected function onPageChanged():void
		{
			var _sIndex:int = (_pageStepper.currentPage - 1) * _itemsPerPage;
			var _eIndex:int = Math.min(_sIndex + _itemsPerPage, _data.length);
			var _arr:Array = _data.slice(_sIndex, _eIndex);
			
			_tileList.data = _arr;
			
			if ( _onChange != null )
			{
				if ( _onChange.length )
				{
					_onChange(this);
				}
				else
				{
					_onChange();
				}
			}
		}

//		public function get tileList():RKTileList
//		{
//			return _tileList;
//		}
		
		public function get currentPage():int
		{
			return _pageStepper.currentPage;
		}
		
		public function set currentPage(value:int):void
		{
			_pageStepper.currentPage = value;
		}
		
		public function get selectedIndex():int
		{
			return _tileList.selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_tileList.selectedIndex = value;
		}
		
		public function get selectedItem():IRKTile
		{
			return _tileList.selectedItem;
		}
		
		public function set selectedItem(value:IRKTile):void
		{
			_tileList.selectedItem = value;
		}
		
		public function get selectable():Boolean
		{
			return _tileList.selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_tileList.selectable = value;
		}
		
//		public function get pageSteper():RKPageStepper
//		{
//			return _pageStepper;
//		}

		public function get itemSelected():Function
		{
			return _itemSelected;
		}

		public function set itemSelected(value:Function):void
		{
			_itemSelected = value;
		}
		
		protected function onItemSelected(item_:IRKTile):void
		{
			if ( _itemSelected != null )
			{
				if ( _itemSelected.length )
				{
					_itemSelected(item_);
				}
				else
				{
					_itemSelected();
				}
			}
		}
	}
}
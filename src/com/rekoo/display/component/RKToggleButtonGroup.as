package com.rekoo.display.component
{
	

	/**
	 * 单选按钮组。
	 * @author Administrator
	 * 
	 */	
	public class RKToggleButtonGroup
	{
		private var _btns:Vector.<RKToggleButton> = null;
		private var _onChange:Function = null;
		
		private var _selectedIndex:int = 0;
		private var _selectedBtn:RKToggleButton = null;
		
		/**
		 * 单选按钮组。
		 * @param buttons_ 所包含的按钮。 
		 * @param onChange_ 选中项改变后的回调。
		 */		
		public function RKToggleButtonGroup(buttons_:Vector.<RKToggleButton>, onChange_:Function = null)
		{
			_btns = buttons_;
			_onChange = onChange_;
			
			for each ( var _btn:RKToggleButton in _btns )
			{
				_btn.selectedCallback = onChange;
			}
			
			selectedIndex = 0;
		}
		
		/**
		 * 构造单选按钮组。
		 * @param buttons_ 所包含的按钮。 
		 * @param onChange_ 选中项改变后的回调。
		 * @return RKToggleButtonGroup。
		 */		
		public static function create(buttons_:Vector.<RKToggleButton>, onChange_:Function = null):RKToggleButtonGroup
		{
			return new RKToggleButtonGroup(buttons_);
		}
		
		private function onChange(target_:RKToggleButton):void
		{
			if ( _selectedBtn )
			{
				_selectedBtn.selected = false;
			}
			
			_selectedBtn = target_;
			_selectedIndex = _btns.indexOf(_selectedBtn);
			
			if ( _onChange != null )
			{
				_onChange();
			}
		}
		
		/**
		 * 当前选中项的索引（从0开始，-1表示没有选中项。）。
		 * @return int。
		 * 
		 */		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		/**
		 * 当前选中项的索引（从0开始，-1表示没有选中项）。
		 * @param value
		 * 
		 */		
		public function set selectedIndex(value:int):void
		{
			if ( value == -1 && _selectedIndex != -1 )
			{
				onChange(null);
			}
			else
			{
				_btns[value].selected = true;
			}
		}
		
		/**
		 * 当前选中项。
		 * @return RKToggleButton。
		 */		
		public function get selectedItem():RKToggleButton
		{
			return _selectedBtn;
		}
		
		/**
		 * 当前选中项。
		 * @param value RKToggleButton。
		 */		
		public function set selectedItem(value:RKToggleButton):void
		{
			if ( value == null )
			{
				onChange(null);
			}
			else
			{
				value.selected = true;
			}
		}
	}
}
package com.rekoo.display.component
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 单选按钮。
	 * @author Administrator
	 * 
	 */	
	public class RKToggleButton extends RKButton
	{
		public function RKToggleButton(skin_:MovieClip, selectedCallback_:Function=null)
		{
			super(skin_, null);
			selectedCallback = selectedCallback_;
		}
		
		override protected function onMouseUpHandler(evt_:MouseEvent):void
		{
			super.onMouseUpHandler(evt_);
			selected = true;
		}
		
		override public function set selected(value:Boolean):void
		{
			var _flag:Boolean = selected != value;
			
			super.selected = value;
			
			if ( selected && _flag )
			{
				if ( selectedCallback != null )
				{
					selectedCallback.length ? selectedCallback(this) : selectedCallback();
				}
			}
		}
		
		public function get selectedCallback():Function
		{
			return _selectedCallback;
		}
		
		public function set selectedCallback(value:Function):void
		{
			_selectedCallback = value;
		}
	}
}
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
		public function RKToggleButton(skin_:MovieClip)
		{
			super(skin_, null);
		}
		
		override protected function onMouseUpHandler(evt_:MouseEvent):void
		{
			super.onMouseUpHandler(evt_);
			selected = true;
		}
	}
}
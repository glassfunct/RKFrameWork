package com.rekoo.display.component
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 复选框。
	 * @author Administrator
	 * 
	 */	
	public class RKCheckBox extends RKButton
	{
		/**
		 * 复选框。
		 * @param skin_ 皮肤。
		 * @param onSelectChange_ 选中状态发生改变时的回调。
		 * 
		 */		
		public function RKCheckBox(skin_:MovieClip, onSelectChange_:Function=null)
		{
			super(skin_, null);
			onSelectChange = onSelectChange_;
		}
		
		override protected function onMouseUpHandler(evt_:MouseEvent):void
		{
			super.onMouseUpHandler(evt_);
			
			selected = !selected;
			
			if ( onSelectChange != null )
			{
				onSelectChange.length ? onSelectChange(this) : onSelectChange();
			}
		}
		
		public function get onSelectChange():Function
		{
			return _changeCallback;
		}
		
		public function set onSelectChange(value:Function):void
		{
			_changeCallback = value;
		}
	}
}
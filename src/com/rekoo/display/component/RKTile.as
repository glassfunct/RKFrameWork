package com.rekoo.display.component
{
	import com.rekoo.display.RKSprite;
	import com.rekoo.display.RKTooltipableSprite;
	import com.rekoo.interfaces.IRKTile;
	
	import flash.display.DisplayObject;
	
	/**
	 * 单元格渲染器基类。
	 * @author Administrator
	 * 
	 */	
	public class RKTile extends RKTooltipableSprite implements IRKTile
	{
		private var _data:* = null;
		
		public function RKTile(skin_:DisplayObject=null)
		{
			super(skin_);
		}
		
		public function set data(value:*):void
		{
			_data = value;
			buttonMode = (selectable && enabled && data != null);
		}
		
		public function get data():*
		{
			return _data;
		}
		
		override public function set selectable(value:Boolean):void
		{
			super.selectable = value;
			
			buttonMode = (selectable && enabled && data != null);
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			buttonMode = (selectable && enabled && data != null);
		}
	}
}
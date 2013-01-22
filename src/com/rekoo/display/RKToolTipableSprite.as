package com.rekoo.display
{
	import com.rekoo.RKDisplayAlign;
	import com.rekoo.interfaces.IRKToolTipSkin;
	import com.rekoo.interfaces.IRKToolTipable;
	import com.rekoo.manager.RKToopTipManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 支持ToolTip的显示基类。
	 * @author Administrator
	 * 
	 */	
	public class RKToolTipableSprite extends RKSprite implements IRKToolTipable
	{
		private var _toolTip:Object = null;
		private var _toolTipSkin:IRKToolTipSkin = null;
		private var _toolTipAlign:String = RKDisplayAlign.NONE;
		
		/**
		 * 支持ToolTip的显示基类。
		 * 
		 */		
		public function RKToolTipableSprite()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(evt_:Event):void
		{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
		}
		
		private function onRemovedFromStage(evt_:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			
			onMouseOutHandler(null);
		}
		
		private function onMouseOverHandler(evt_:MouseEvent):void
		{
			if ( _toolTipSkin != null )
			{
				RKToopTipManager.instance.showToolTip(this);
			}
		}
		
		private function onMouseOutHandler(evt_:MouseEvent):void
		{
			if ( _toolTipSkin != null )
			{
				RKToopTipManager.instance.hideToolTip(this);
			}
		}
		
		override public function dispose():void
		{
			_toolTip = null;
			_toolTipSkin = null;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			
			super.dispose();
		}
		
		public function get toolTip():Object
		{
			return _toolTip;
		}

		public function set toolTip(value:Object):void
		{
			_toolTip = value;
		}

		public function get toolTipSkin():IRKToolTipSkin
		{
			return _toolTipSkin;
		}

		public function set toolTipSkin(value:IRKToolTipSkin):void
		{
			_toolTipSkin = value;
		}

		public function get toolTipAlign():String
		{
			return _toolTipAlign;
		}

		public function set toolTipAlign(value:String):void
		{
			_toolTipAlign = value;
		}

	}
}
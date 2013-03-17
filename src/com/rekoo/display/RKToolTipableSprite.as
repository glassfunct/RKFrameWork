package com.rekoo.display
{
	import com.rekoo.RKPosition;
	import com.rekoo.interfaces.IRKTooltipSkin;
	import com.rekoo.interfaces.IRKTooltipable;
	import com.rekoo.manager.RKTooptipManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 支持ToolTip的显示基类。
	 * @author Administrator
	 * 
	 */	
	public class RKTooltipableSprite extends RKSprite implements IRKTooltipable
	{
		private var _tooltip:* = null;
		private var _tooltipSkin:IRKTooltipSkin = null;
		private var _tooltipAlign:String = RKPosition.NONE;
		
		/**
		 * 支持ToolTip的显示基类。
		 * 
		 */		
		public function RKTooltipableSprite(skin_:DisplayObject = null)
		{
			super(skin_);
			
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
			if ( _tooltipSkin != null )
			{
				RKTooptipManager.instance.showToolTip(this);
			}
		}
		
		private function onMouseOutHandler(evt_:MouseEvent):void
		{
			if ( _tooltipSkin != null )
			{
				RKTooptipManager.instance.hideToolTip(this);
			}
		}
		
		override public function dispose():void
		{
			_tooltip = null;
			_tooltipSkin = null;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			
			super.dispose();
		}
		
		public function get tooltip():*
		{
			return _tooltip;
		}

		public function set tooltip(value:*):void
		{
			_tooltip = value;
		}

		public function get tooltipSkin():IRKTooltipSkin
		{
			return _tooltipSkin;
		}

		public function set tooltipSkin(value:IRKTooltipSkin):void
		{
			_tooltipSkin = value;
		}

		public function get tooltipAlign():String
		{
			return _tooltipAlign;
		}

		public function set tooltipAlign(value:String):void
		{
			_tooltipAlign = value;
		}

	}
}
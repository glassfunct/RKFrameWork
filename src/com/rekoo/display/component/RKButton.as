package com.rekoo.display.component
{
	import com.rekoo.display.RKToolTipableSprite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 基本按钮。
	 * @author Administrator
	 * 
	 */	
	public class RKButton extends RKToolTipableSprite
	{
		protected static const NORMAL_FRAME:int = 1;
		protected static const OVER_FRAME:int = 2;
		protected static const DOWN_FRAME:int = 3;
		protected static const SELECTED_FRAME:int = 4;
		protected static const DISABLED_FRAME:int = 5;
		
		public var mouseOverCallback:Function = null;
		public var mouseOutCallback:Function = null;
		public var mouseDownCallback:Function = null;
		public var mouseUpCallback:Function = null;
		public var mouseClickCallback:Function = null;
		public var selectedCallback:Function = null;
		
		/**
		 * 基本按钮。
		 * @param skin_ 皮肤。
		 * @param click_ 鼠标点击按钮时的回调函数。
		 */		
		public function RKButton(skin_:MovieClip, click_:Function)
		{
			super();
			
			mouseClickCallback = click_;
			
			if ( skin_ != null )
			{
				skin = skin_;
			}
			
			enabled = true;
			(skin as MovieClip).gotoAndStop(NORMAL_FRAME);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			addEventListener(MouseEvent.CLICK, onMouseClickedHandler);
		}
		
		/**
		 * 各种回调。回调函数形参可以没有，也可以是一个RKButton类型的。若有形参，回调时的值则为此按钮。
		 * @param click_ 鼠标点击按钮时的回调函数。
		 * @param selected_ 被选中时的回调函数。
		 * @param over_ 鼠标移入按钮时的回调函数。
		 * @param out_ 鼠标移出按钮时的回调函数。
		 * @param down_ 鼠标按下按钮时的回调函数。
		 * @param up_ 鼠标松开按钮时的回调函数。
		 * 
		 */		
		public function setHandlers(click_:Function, selected_:Function = null, over_:Function = null, out_:Function = null, down_:Function = null, up_:Function = null):void
		{
			mouseOverCallback = over_;
			mouseOutCallback = out_;
			mouseDownCallback = down_;
			mouseUpCallback = up_;
			mouseClickCallback = click_;
			selectedCallback = selected_;
		}
		
		/**
		 * 鼠标点击的响应函数。
		 * @param evt_
		 * 
		 */		
		protected function onMouseClickedHandler(evt_:MouseEvent):void
		{
			if ( enabled )
			{
				if ( mouseClickCallback != null )
				{
					mouseClickCallback.length ? mouseClickCallback(this) : mouseClickCallback();
				}
			}
		}
		
		/**
		 * 鼠标移入的响应函数。
		 * @param evt_
		 * 
		 */		
		protected function onMouseOverHandler(evt_:MouseEvent):void
		{
			if ( enabled )
			{
				if ( !selected )
				{
					(skin as MovieClip).gotoAndStop(OVER_FRAME);
				}
				
				if ( mouseOverCallback != null )
				{
					mouseOverCallback.length ? mouseOverCallback(this) : mouseOverCallback();
				}
			}
		}
		
		/**
		 * 鼠标移出的响应函数。
		 * @param evt_
		 * 
		 */		
		protected function onMouseOutHandler(evt_:MouseEvent):void
		{
			if ( enabled )
			{
				if ( !selected )
				{
					(skin as MovieClip).gotoAndStop(NORMAL_FRAME);
				}
				
				if ( mouseOutCallback != null )
				{
					mouseOutCallback.length ? mouseOutCallback(this) : mouseOutCallback();
				}
			}
		}
		
		/**
		 * 鼠标按下的响应函数。
		 * @param evt_
		 * 
		 */		
		protected function onMouseDownHandler(evt_:MouseEvent):void
		{
			if ( enabled )
			{
				if ( !selected )
				{
					(skin as MovieClip).gotoAndStop(DOWN_FRAME);
				}
				
				if ( mouseDownCallback != null )
				{
					mouseDownCallback.length ? mouseDownCallback(this) : mouseDownCallback();
				}
			}
		}
		
		/**
		 * 鼠标松开的响应函数。
		 * @param evt_
		 * 
		 */		
		protected function onMouseUpHandler(evt_:MouseEvent):void
		{
			if ( enabled )
			{
				if ( !selected )
				{
					(skin as MovieClip).gotoAndStop(OVER_FRAME);
				}
				
				if ( mouseUpCallback != null )
				{
					mouseUpCallback.length ? mouseUpCallback(this) : mouseUpCallback();
				}
			}
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = buttonMode = useHandCursor = value;
			(skin as MovieClip).gotoAndStop(value ? ( selected ? SELECTED_FRAME : NORMAL_FRAME ) : DISABLED_FRAME);
		}
		
		/**
		 * 销毁。
		 */		
		override public function dispose():void
		{
			super.dispose();
			
			mouseOverCallback = null;
			mouseOutCallback = null;
			mouseDownCallback = null;
			mouseUpCallback = null;
			mouseClickCallback = null;
			selectedCallback = null;
			
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			removeEventListener(MouseEvent.CLICK, onMouseClickedHandler);
		}
		
		/**
		 * 按钮的自定义文字。
		 * @return String。
		 */		
		public function get label():String
		{
			if ( skin.hasOwnProperty("label") )
				return skin["label"].text;
			return "";
		}
		
		/**
		 * 按钮的自定义文字。
		 * @param value String。
		 */	
		public function set label(value:String):void
		{
			if ( skin.hasOwnProperty("label") )
				skin["label"].htmlText = value;
		}
		
		override public function set selected(value:Boolean):void
		{
			if ( selected != value && enabled )
			{
				super.selected = value;
				
				if ( selected )
				{
					(skin as MovieClip).gotoAndStop(SELECTED_FRAME);
					
					if ( selectedCallback != null )
					{
						selectedCallback.length ? selectedCallback(this) : selectedCallback();
					}
				}
				else
				{
					(skin as MovieClip).gotoAndStop(NORMAL_FRAME);
				}
			}
		}
	}
}
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
		
		private var _overFunc:Function = null;
		private var _outFunc:Function = null;
		private var _downFunc:Function = null;
		private var _upFunc:Function = null;
		private var _clickFunc:Function = null;
		
		/**
		 * 基本按钮。
		 * @param skin_ 皮肤。
		 * 
		 */		
		public function RKButton(skin_:MovieClip = null)
		{
			super();
			
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
		 * @param over_ 鼠标移入按钮时的回调函数。
		 * @param out_ 鼠标移出按钮时的回调函数。
		 * @param down_ 鼠标按下按钮时的回调函数。
		 * @param up_ 鼠标松开按钮时的回调函数。
		 * 
		 */		
		public function setHandlers(click_:Function, over_:Function = null, out_:Function = null, down_:Function = null, up_:Function = null):void
		{
			_overFunc = over_;
			_outFunc = out_;
			_downFunc = down_;
			_upFunc = up_;
			_clickFunc = click_;
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
				if ( _clickFunc != null )
				{
					_clickFunc.length ? _clickFunc(this) : _clickFunc();
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
				(skin as MovieClip).gotoAndStop(OVER_FRAME);
				
				if ( _overFunc != null )
				{
					_overFunc.length ? _overFunc(this) : _overFunc();
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
				(skin as MovieClip).gotoAndStop(NORMAL_FRAME);
				
				if ( _outFunc != null )
				{
					_outFunc.length ? _outFunc(this) : _outFunc();
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
				(skin as MovieClip).gotoAndStop(DOWN_FRAME);
				
				if ( _downFunc != null )
				{
					_downFunc.length ? _downFunc(this) : _downFunc();
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
				(skin as MovieClip).gotoAndStop(OVER_FRAME);
				
				if ( _upFunc != null )
				{
					_upFunc.length ? _upFunc(this) : _upFunc();
				}
			}
		}

		override public function set enabled(value:Boolean):void
		{
			super.enabled = buttonMode = useHandCursor = value;
			(skin as MovieClip).gotoAndStop(value ? NORMAL_FRAME : DISABLED_FRAME);
		}
		
		/**
		 * 销毁。
		 * 
		 */		
		override public function dispose():void
		{
			super.dispose();
			
			_overFunc = null;
			_outFunc = null;
			_downFunc = null;
			_upFunc = null;
			_clickFunc = null;
			
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOutHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			removeEventListener(MouseEvent.CLICK, onMouseClickedHandler);
		}
	}
}
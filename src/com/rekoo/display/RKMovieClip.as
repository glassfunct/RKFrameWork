package com.rekoo.display
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.interfaces.IRKFrameTicker;
	import com.rekoo.interfaces.IRKMovieClip;
	import com.rekoo.manager.RKFrameTickerManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	
	/**
	 * 基本影片剪辑类。
	 * @author Administrator
	 */	
	public class RKMovieClip extends RKSprite implements IRKMovieClip
	{
		private var _autoPlay:Boolean = false;
		private var _loop:uint = 0;
		private var _frameRate:int = 0;
		
		protected var _curFrame:int = 0;
		protected var _totalFrames:int = 0;
		private var _curLoop:int = 0;
		
		/**
		 * 基本影片剪辑类。
		 * @param skin_ MovieClip。
		 * @param autoPlay_ 是否自动播放。
		 * @param loop_ 循环次数。0为无限循环。
		 * @param frameRate_ 自定义帧频。初始化时若为0则按应用的帧频。
		 */		
		public function RKMovieClip(skin_:MovieClip = null, autoPlay_:Boolean = true, loop_:uint = 0, frameRate_:int = 0)
		{
			_autoPlay = autoPlay_;
			_loop = loop_;
			_frameRate = (frameRate_ != 0 ? frameRate_ : RKFrameWork.APP_Stage.frameRate);
			
			super(skin_);
		}
		
		override public function set skin(value:DisplayObject):void
		{
			if ( value && !value is MovieClip )
			{
				throw new Error("RKMovieClip只能设MovieClip为皮肤！");
			}
			
			super.skin = value;
			
			_curFrame = 0;
			_totalFrames = 0;
			
			if ( value )
			{
				_totalFrames = (value as MovieClip).totalFrames;
				
				if ( _autoPlay )
				{
					RKFrameTickerManager.instance.register(this);
				}
				else
				{
					(value as MovieClip).stop();
				}
			}
			else
			{
				RKFrameTickerManager.instance.unregister(this);
			}
		}
		
		/**
		 * 自动播放。
		 * @return 
		 * 
		 */		
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		
		/**
		 * 自动播放。
		 * @param value
		 * 
		 */		
		public function set autoPlay(value:Boolean):void
		{
			if ( _autoPlay != value )
			{
				_autoPlay = value;
				
				if ( _autoPlay && skin )
				{
					RKFrameTickerManager.instance.register(this);
				}
				else
				{
					RKFrameTickerManager.instance.unregister(this);
				}
			}
		}
		
		/**
		 * 循环次数。
		 * @return 
		 * 
		 */		
		public function get loop():uint
		{
			return _loop;
		}
		
		/**
		 * 循环次数。
		 * @param value
		 * 
		 */		
		public function set loop(value:uint):void
		{
			_loop = value;
		}
		
		/**
		 * 帧频。
		 * @return 
		 * 
		 */		
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		/**
		 * 帧频。
		 * @param value
		 * 
		 */		
		public function set frameRate(value:int):void
		{
			_frameRate = value;
			
			if ( _frameRate == 0 )
			{
				RKFrameTickerManager.instance.unregister(this);
			}
		}
		
		/**
		 * 当前帧。
		 * @return 
		 * 
		 */		
		public function get currentFrame():int
		{
			return _curFrame;
		}
		
		/**
		 * 当前帧。
		 * @return 
		 * 
		 */		
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		/**
		 * 播放。
		 * 
		 */		
		public function play():void
		{
			if ( skin )
			{
				_curLoop = 0;
				RKFrameTickerManager.instance.register(this);
			}
		}
		
		/**
		 * 停止。
		 */
		public function stop():void
		{
			if ( skin )
			{
				RKFrameTickerManager.instance.unregister(this);
			}
		}
		
		/**
		 * 从指定帧开始播放。
		 * @param frame_ 帧号。
		 */
		public function gotoAndPlay(frame_:int):void
		{
			if ( skin )
			{
				_curFrame = frame_;
				RKFrameTickerManager.instance.register(this);
			}
		}
		
		/**
		 * 停到指定帧。
		 * @param frame_ 帧号。
		 */
		public function gotoAndStop(frame_:int):void
		{
			if ( skin )
			{
				_curFrame = frame_;
				RKFrameTickerManager.instance.unregister(this);
				tick();
			}
		}
		
		public function tick():void
		{
			if ( skin )
			{
				if ( frameRate > 0 )
				{
					_curFrame ++;
				}
				else if ( frameRate < 0 )
				{
					_curFrame --;
				}
				
				if ( _curFrame > totalFrames )
				{
					_curFrame = 1;
				}
				else if ( _curFrame < 1 )
				{
					_curFrame = frameRate > 0 ? 1 : totalFrames;
				}
				
				render();
				
				if ( (frameRate > 0 && _curFrame == totalFrames) || (frameRate < 0 && currentFrame == 1) )
				{
					//播放完成一次。
					_curLoop ++;
				}
				
				if ( _loop > 0 && _curLoop == loop )
				{
					stop();
				}
			}
		}
		
		/**
		 * 渲染。
		 */
		protected function render():void
		{
			(skin as MovieClip).gotoAndStop(_curFrame);
		}
		
		override public function dispose():void
		{
			RKFrameTickerManager.instance.unregister(this);
			
			if ( skin )
			{
				(skin as MovieClip).stop();
				skin = null;
			}
			
			super.dispose();
		}
	}
}
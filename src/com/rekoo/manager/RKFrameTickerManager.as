package com.rekoo.manager
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.interfaces.IRKFrameTicker;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 心脏中心。心跳间单位：帧。
	 * @author Administrator
	 * 
	 */	
	public final class RKFrameTickerManager
	{
		/**
		 * 最大两帧间隔（防止待机后返回卡死） 
		 */
		public static var MAX_INTERVAL:int = 1000;
		
		private var _stage:Stage = null;
		private var _list:Vector.<Object> = new Vector.<Object>();
		
		private var _lastTime:int = 0;
		
		private static var _instance:RKFrameTickerManager = null;
		
		public function RKFrameTickerManager()
		{
			_stage = RKFrameWork.APP_Stage;
		}
		
		public static function get instance():RKFrameTickerManager
		{
			if ( _instance == null )
			{
				_instance = new RKFrameTickerManager();
			}
			
			return _instance;
		}
		
		/**
		 * 注册心脏。
		 * @param ticker_ 心脏。
		 * 
		 */		
		public function register(ticker_:IRKFrameTicker):void
		{
			if ( !hasTicker(ticker_) )
			{
				_list.push({"ticker":ticker_, "frameTimer":0});
				
				if ( _list.length == 1 )
				{
					_lastTime = 0;
					_stage.addEventListener(Event.ENTER_FRAME, render);
				}
			}
		}
		
		/**
		 * 注销心脏。
		 * @param ticker_ 心脏。
		 * 
		 */	
		public function unregister(ticker_:IRKFrameTicker):void
		{
			var _len:int = _list.length;
			
			for ( var _i:int = 0; _i < _len; _i ++ )
			{
				if ( _list[_i]["ticker"] == ticker_ )
				{
					_list.splice(_i ,1);
					break;
				}
			}
			
			if ( _list.length == 0 )
			{
				_stage.removeEventListener(Event.ENTER_FRAME, render);
			}
		}
		
		public function hasTicker(ticker_:IRKFrameTicker):Boolean
		{
			for each ( var _tickerObj:Object in _list )
			{
				if ( _tickerObj["ticker"] == ticker_ )
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function render(evt_:Event):void
		{
			var _interval:int = getInterval();
			var _tFrameRate:int = 0;
			
			for each ( var _tickerObj:Object in _list )
			{
				_tFrameRate = _tickerObj["ticker"].hasOwnProperty("frameRate") ? _tickerObj["ticker"].frameRate : RKFrameWork.APP_Stage.frameRate;
				
				if ( _tFrameRate != 0 )
				{
					_tickerObj["frameTimer"] -= _interval;
					
					while ( _tickerObj["frameTimer"] < 0 )
					{
						_tickerObj["ticker"].tick();
						_tickerObj["frameTimer"] += 1000 / Math.abs(_tFrameRate);
					}
				}
			}
		}
		
		private function getInterval():int
		{
			var _curTime:int = getTimer();
			var _interval:int = (_lastTime == 0 ? 0 : _curTime - _lastTime);
			_lastTime = _curTime;
			
			return Math.min(_interval, MAX_INTERVAL);
		}
	}
}
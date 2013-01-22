package com.rekoo.manager
{
	import com.rekoo.interfaces.IRKTimerTicker;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 心脏中心。心跳间单位：秒。
	 * @author Administrator
	 * 
	 */	
	public final class RKTimerTickerManager
	{
		private var _timer:Timer = new Timer(1000);
		private var _list:Vector.<IRKTimerTicker> = new Vector.<IRKTimerTicker>();
		
		private static var _instance:RKTimerTickerManager = null;
		
		public function RKTimerTickerManager()
		{
			_timer.addEventListener(TimerEvent.TIMER, tick);
		}
		
		public static function get instance():RKTimerTickerManager
		{
			if ( _instance == null )
			{
				_instance = new RKTimerTickerManager();
			}
			
			return _instance;
		}
		
		/**
		 * 注册心脏。
		 * @param ticker_ 心脏。
		 * 
		 */		
		public function register(ticker_:IRKTimerTicker):void
		{
			if ( !hasTicker(ticker_) )
			{
				_list.push(ticker_);
				
				if ( _list.length == 1 )
				{
					_timer.start();
				}
			}
		}
		
		/**
		 * 注销心脏。
		 * @param ticker_ 心脏。
		 * 
		 */	
		public function unregister(ticker_:IRKTimerTicker):void
		{
			var _len:int = _list.length;
			
			for ( var _i:int = 0; _i < _len; _i ++ )
			{
				if ( _list[_i] == ticker_ )
				{
					_list.splice(_i ,1);
					break;
				}
			}
			
			if ( _list.length == 0 )
			{
				_timer.reset();
			}
		}
		
		/**
		 * 心脏是否已注册。
		 * @param ticker_
		 * @return 
		 * 
		 */		
		public function hasTicker(ticker_:IRKTimerTicker):Boolean
		{
			for each ( var _ticker:IRKTimerTicker in _list )
			{
				if ( _ticker == ticker_ )
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function tick(evt_:TimerEvent):void
		{
			for each ( var _ticker:IRKTimerTicker in _list )
			{
				if ( _ticker.interval > 0 && _timer.currentCount % _ticker.interval == 0 )
				{
					_ticker.tick();
				}
			}
		}
	}
}
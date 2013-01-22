package com.rekoo.event
{
	import flash.events.Event;
	
	public final class RKResourceEvent extends Event
	{
		/** 单个文件加载完成。 */
		public static const EVENT_COMPLETE_SINGLE_FILE:String = "EVENT_COMPLETE_SINGLE_FILE";
		/** 队列中的请求全部加载完成。 */
		public static const EVENT_COMPLETE_ALL:String = "EVENT_COMPLETE_ALL";
		
		private var _url:String = null;
			
		public function RKResourceEvent(type:String, resourceURL:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_url = resourceURL;
			super(type, bubbles, cancelable);
		}
		
		public function get resourceURL():String
		{
			return _url;
		}
	}
}
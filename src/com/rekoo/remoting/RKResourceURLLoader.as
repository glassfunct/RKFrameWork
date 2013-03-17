package com.rekoo.remoting
{
	import com.rekoo.RKFrameWork;
	import com.rekoo.RKResourceType;
	import com.rekoo.interfaces.IRKBaseLoader;
	import com.rekoo.manager.RKResourceManager;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * 静态非显示对象资源加载器，扩展自URLLoader。
	 * @author Administrator
	 * 
	 */	
	public class RKResourceURLLoader extends URLLoader implements IRKBaseLoader
	{
		/* 基本URL。 */
		private var _baseURL:String = null;
		/* 哈希后的URL。 */
		private var _hashedURL:String = null;
		/* 素材名。(带扩展名) */
		private var _resourceName:String = null;
		/* 素材类型。 */
		private var _resourceType:String = null;
		
		private var _retryTimes:int = 0;
		private var _curRetryTimes:int = 0;
		
		private var _onResult:Function = null;
		private var _onFault:Function = null;
		
		private var _effectLoadingPer:Boolean = false;
		private var _showLoading:Boolean = false;
		
		private var _resManager:RKResourceManager = RKResourceManager.instance;
		
		/**
		 * 非显示对象静态资源加载器，扩展自URLLoader。
		 * @param baseURL_ 基本URL。
		 * @param hashedURL_ 哈希后的URL。
		 * @param effectLoadingPer_ 是否影响加载进度。
		 * @param showLoading_ 是否显示loading图（需和effectLoadingPer_配合使用，effectLoadingPer_为false时，showLoading_无效）。
		 */		
		public function RKResourceURLLoader(baseURL_:String, hashedURL_:String = null, effectLoadingPer_:Boolean = true, showLoading_:Boolean = true)
		{
			super();
			
			_baseURL = baseURL_;
			_hashedURL = hashedURL_ ? hashedURL_ : baseURL_;
			_effectLoadingPer = effectLoadingPer_;
			_showLoading = showLoading_;
			_retryTimes = RKFrameWork.resLoadMaxRetryTimes;
			
			var _urlArr:Array = baseURL_.split("/");
			_resourceName = _urlArr[_urlArr.length - 1];
			_resourceType = RKResourceType.getResourceType(_resourceName);
		}
		
		override public function load(request:URLRequest):void
		{
			throw new Error("请用execute来开始加载！");
		}
		
		/**
		 * 开始加载。
		 * @param onResult_ 加载成功的回调函数。
		 * @param onFault_ 加载失败的回调函数。
		 * @param binaryMode_ 加载为二进制。
		 */			
		public function execute(onResult_:Function, onFault_:Function = null, binaryMode_:Boolean = false):void
		{
			_onResult = onResult_;
			_onFault = onFault_;
			
			if ( binaryMode_ )
			{
				dataFormat = URLLoaderDataFormat.BINARY
				_resourceType = RKResourceType.RESOURCE_TYPE_BINARY;
			}
			
			addEventListener(Event.COMPLETE, onResult);
			addEventListener(IOErrorEvent.IO_ERROR, onFault);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFault);
			
			super.load(new URLRequest(_hashedURL));
			
			_retryTimes ++;
		}
		
		/**
		 * 基本URL。
		 * @return 
		 * 
		 */		
		public function get baseURL():String
		{
			return _baseURL;
		}
		
		/**
		 * 哈希后的URL。
		 * @return 
		 * 
		 */		
		public function get hashedURL():String
		{
			return _hashedURL;
		}
		
		/**
		 * 素材名。(带扩展名)
		 * @return 
		 * 
		 */		
		public function get resourceName():String
		{
			return _resourceName;
		}
		
		/**
		 * 素材类型。
		 * @return 
		 * 
		 */		
		public function get resourceType():String
		{
			return _resourceType;
		}
		
		/**
		 * 加载进度（百分比）。
		 * @return Number。
		 */
		public function get percent():Number
		{
			return bytesTotal > 0 ? bytesLoaded / bytesTotal : 0;
		}
		
		private function onResult(evt_:Event):void
		{
			_retryTimes = 0;
			
			clearEvent();
			
			if ( _onResult != null )
			{
				_onResult(this);
			}
		}
		
		private function onFault(evt_:Event):void
		{
			clearEvent();
			
			if ( _curRetryTimes < _retryTimes )
			{
				execute(_onResult, _onFault);
			}
			else
			{
				_retryTimes = 0;
				
				if ( _onFault != null )
				{
					_onFault(this);
				}
			}
		}
		
		private function clearEvent():void
		{
			removeEventListener(Event.COMPLETE, onResult);
			removeEventListener(IOErrorEvent.IO_ERROR, onFault);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onFault);
		}
		
		public function get effectLoadingPer():Boolean
		{
			return _effectLoadingPer;
		}
		
		public function get showLoading():Boolean
		{
			return _showLoading;
		}
	}
}
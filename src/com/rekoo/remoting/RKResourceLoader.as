package com.rekoo.remoting
{
	import com.rekoo.RKResourceType;
	import com.rekoo.manager.RKResourceManager;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 静态显示对象资源加载器，扩展自Loader。 
	 * @author Administrator
	 * 
	 */	
	public class RKResourceLoader extends Loader
	{
		/* 基本URL。 */
		private var _baseURL:String = null;
		/* 哈希后的URL。 */
		private var _hashedURL:String = null;
		/* 素材名。(带扩展名) */
		private var _resourceName:String = null;
		/* 素材类型。 */
		private var _resourceType:String = null;
		
		private var _onResult:Function = null;
		private var _onFault:Function = null;
		
		private var _resManager:RKResourceManager = RKResourceManager.instance;
		
		/**
		 * 显示对象加载器，扩展自Loader。 
		 * @param baseURL_ 基本URL。
		 * @param hashedURL_ 哈希后的URL。
		 * @param loaderContext_ LoaderContext。
		 * 
		 */		
		public function RKResourceLoader(baseURL_:String, hashedURL_:String = null)
		{
			super();
			
			_baseURL = baseURL_;
			_hashedURL = hashedURL_ ? hashedURL_ : baseURL_;
			
			if ( _baseURL )
			{
				var _urlArr:Array = baseURL_.split("/");
				_resourceName = _urlArr[_urlArr.length - 1];
				_resourceType = RKResourceType.getResourceType(_resourceName);
			}
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			throw new Error("请用execute来开始加载！");
		}
		
		override public function loadBytes(bytes:ByteArray, context:LoaderContext=null):void
		{
			throw new Error("请用execute来开始加载！");
		}
		
		/**
		 * 开始加载。
		 * @param onResult_ 加载成功的回调函数。
		 * @param onFault_ 加载失败的回调函数。
		 * @param bytes_ 要加载的二进制数组。
		 * @param context_ A LoaderContext object。
		 * 
		 */			
		public function execute(onResult_:Function, onFault_:Function = null, bytes_:ByteArray = null, context_:LoaderContext = null):void
		{
			_onResult = onResult_;
			_onFault = onFault_;
			
			contentLoaderInfo.addEventListener(Event.COMPLETE, onResult);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFault);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFault);
			
			if ( bytes_ )
			{
				super.loadBytes(bytes_, context_);
			}
			else
			{
				super.load(new URLRequest(_hashedURL), context_);
			}
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
			if ( loaderInfo )
			{
				return loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
			}
			
			return 0;
		}
		
		private function onResult(evt_:Event):void
		{
			clearEvent();
			
			if ( _onResult != null )
			{
				_onResult(this);
			}
		}
		
		private function onFault(evt_:Event):void
		{
			clearEvent();
			
			if ( _onFault != null )
			{
				_onFault(this);
			}
		}
		
		private function clearEvent():void
		{
			contentLoaderInfo.removeEventListener(Event.COMPLETE, onResult);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onFault);
			contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onFault);
		}

		public function get result():Function
		{
			return _onResult;
		}

		public function set result(value:Function):void
		{
			_onResult = value;
		}

		public function get fault():Function
		{
			return _onFault;
		}

		public function set fault(value:Function):void
		{
			_onFault = value;
		}


	}
}
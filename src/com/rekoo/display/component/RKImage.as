package com.rekoo.display.component
{
	import com.rekoo.display.RKTooltipableSprite;
	import com.rekoo.manager.RKResourceManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	public class RKImage extends RKTooltipableSprite
	{
		private var _url:String = null;
		private var _bitmap:Bitmap = null;
		private var _loader:Loader = null;
		private var _loadingC:RKLoadingCircle = null;
		
		private var _w:Number = 0.0;
		private var _h:Number = 0.0;
		
		/**
		 * 图片加载器。
		 * @param url_ 图片地址。
		 * @param width_ 图片宽度，若值为0则使用图片原始宽度，但也因此会造成loading动画不知道图片原始宽度而出现在加载器左侧。
		 * @param height_ 图片高度，若值为0则使用图片原始高度，但也因此会造成loading动画不知道图片原始高度而出现在加载器顶部。
		 * @param useCache_ 是否优先使用缓存中的图片。
		 * 
		 */		
		public function RKImage(url_:String = null, width_:Number = 0.0, height_:Number = 0.0, useCache_:Boolean = true)
		{
			super();
			load(url_, width_, height_, useCache_);
		}
		
		/**
		 * 加载一张图片。
		 * @param url_ 图片地址。
		 * @param width_ 图片宽度，若值为0则使用图片原始宽度，但也因此会造成loading动画不知道图片原始宽度而出现在加载器左侧。
		 * @param height_ 图片高度，若值为0则使用图片原始高度，但也因此会造成loading动画不知道图片原始高度而出现在加载器顶部。
		 * @param useCache_ 是否优先使用缓存中的图片。
		 */		
		public function load(url_:String, width_:Number = 0.0, height_:Number = 0.0, useCache_:Boolean = true):void
		{
			if ( url_ != _url )
			{
				if ( _loadingC )
				{
					_loadingC.dispose();
					_loadingC = null;
				}
				
				if ( _bitmap && _bitmap.bitmapData )
				{
					removeChild(_bitmap);
					_bitmap.bitmapData.dispose();
					_bitmap = null;
				}
				
				if ( _loader )
				{
					removeChild(_loader);
					_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderLoadOK);
					_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderLoadFault);
					_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, loaderLoadFault);
					_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderLoadFault);
					_loader.unloadAndStop();
					_loader = null;
				}
				
				_url = url_;
				_w = width_;
				_h = height_;
				
				if ( _url != null )
				{
					if ( useCache_ )
					{
						if ( RKResourceManager.instance.isLoaded(_url) )
						{
							var _bd:BitmapData = RKResourceManager.instance.getBitmapData(_url);
							_bitmap = new Bitmap(_bd, "auto", true);
							addChild(_bitmap);
							resize(_w, _h);
						}
						else
						{
							showLoadingMC();
							RKResourceManager.instance.load(_url, false, bitmapLoadOK, bitmapLoadFault, false, false);
						}
					}
					else
					{
						showLoadingMC();
						
						_loader = new Loader();
						addChild(_loader);
						_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderLoadOK);
						_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderLoadFault);
						_loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, loaderLoadFault);
						_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderLoadFault);
						_loader.load(new URLRequest(_url));
						
					}
				}
			}
		}
		
		private function showLoadingMC():void
		{
			_loadingC = new RKLoadingCircle(Math.max(5, Math.min(Math.min(_w, _h) / 3, 15)));
			_loadingC.x = _w / 2;
			_loadingC.y = _h / 2;
			addChild(_loadingC);
		}
		
		private function bitmapLoadOK(url_:String):void
		{
			if ( _url != url_ )
			{
				return;
			}
			
			_loadingC.dispose();
			_loadingC = null;
			
			var _bd:BitmapData = RKResourceManager.instance.getBitmapData(_url);
			_bitmap = new Bitmap(_bd, "auto", true);
			addChild(_bitmap);
			
			resize(_w, _h);
		}
		
		private function bitmapLoadFault(url_:String):void
		{
			if ( _url != url_ )
			{
				return;
			}
			
			_loadingC.dispose();
			_loadingC = null;
		}
		
		private function loaderLoadOK(evt_:Event):void
		{
			_loadingC.dispose();
			_loadingC = null;
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderLoadOK);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderLoadFault);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, loaderLoadFault);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderLoadFault);
			
			resize(_w, _h);
		}
		
		private function loaderLoadFault(evt_:Event):void
		{
			_loadingC.dispose();
			_loadingC = null;
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderLoadOK);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderLoadFault);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, loaderLoadFault);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderLoadFault);
		}

		/**
		 * 图片地址。
		 */		
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * 设置图片尺寸。
		 * @param width_ 图片宽度。
		 * @param height_ 图片高度。
		 * 
		 */		
		public function resize(width_:Number, height_:Number):void
		{
			_w = width_;
			_h = height_;
			
			if ( _bitmap )
			{
				if ( _bitmap.width != _w )
				{
					_bitmap.width = _w;
				}
				
				if ( _bitmap.height != _h )
				{
					_bitmap.height = _h;
				}
			}
			else if ( _loader )
			{
				if ( _loader.width != _w )
				{
					_loader.width = _w;
				}
				
				if ( _loader.height != _h )
				{
					_loader.height = _h;
				}
			}
		}
	}
}
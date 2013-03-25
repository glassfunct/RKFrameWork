package com.rekoo.display
{
	import com.rekoo.manager.RKFrameTickerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 使用位图缓存的影片剪辑。
	 * @author Administrator
	 * 
	 */
	public class RKBitmapMovieClip extends RKMovieClip
	{
		private var _mc:MovieClip = null;
		private var _bitmap:Bitmap = null;
		private var _bitmapDataArr:Vector.<Object> = new Vector.<Object>();
		
		/**
		 * 使用位图缓存的影片剪辑。
		 * @param skin_ MovieClip。
		 * @param autoPlay_ 是否自动播放。
		 * @param loop_ 循环次数。0为无限循环。
		 * @param frameRate_ 自定义帧频。初始化时若为0则按应用的帧频。
		 * @param totalFrames_ 总帧数。若为0则使用skin_的最外层影片剪辑总帧数。
		 */
		public function RKBitmapMovieClip(skin_:MovieClip=null, autoPlay_:Boolean=true, loop_:uint=0, frameRate_:int=0, totalFrames_:int = 0)
		{
			_bitmap = new Bitmap(null, "auto", true);
			addChild(_bitmap);
			super(skin_, autoPlay_, loop_, frameRate_);
			
			if ( totalFrames_ > 0 )
			{
				_totalFrames = totalFrames_;
			}
		}
		
		/**
		 * 从位图数组创建。
		 * @param bitmapDatas_ 位图数组。元素为BitmapData。
		 * @return RKBitmapMovieClip。
		 */		
		public function createFromBitmapDatas(bitmapDatas_:Vector.<BitmapData>):RKBitmapMovieClip
		{
			skin = null;
			
			for each ( var _bd:BitmapData in bitmapDatas_ )
			{
				_bitmapDataArr.push({"bitmapData":_bd, "matrix":new Matrix()});
			}
			
			
			_curFrame = 1;
			_totalFrames = _bitmapDataArr.length;
			
			if ( autoPlay )
			{
				RKFrameTickerManager.instance.register(this);
			}
			else
			{
				tick();
			}
			
			return this;
		}
		
		override public function set skin(value:DisplayObject):void
		{
			super.skin = value;
			
			_mc = value as MovieClip;
			
			disposeBitmap();
			
			if ( _mc )
			{
				removeChild(_mc);
				
				if ( autoPlay )
				{
					RKFrameTickerManager.instance.register(this);
				}
				else
				{
					tick();
				}
			}
		}
		
		override public function get skin():DisplayObject
		{
			return _bitmap;
		}
		
		override protected function render():void
		{
			if ( _mc )
			{
				_mc.gotoAndStop(currentFrame);
				var rect:Rectangle = _mc.getBounds(_mc);
				var bitmapData:BitmapData = new BitmapData(Math.ceil(rect.width),Math.ceil(rect.height),true,0);
				var _mt:Matrix = _mc.transform.matrix.clone();
				_mt.tx = -rect.x;
				_mt.ty = -rect.y;
				bitmapData.draw(_mc, _mt, _mc.transform.colorTransform, _mc.blendMode, null, true);
				
				_bitmapDataArr[currentFrame - 1] = {"bitmapData":bitmapData, "matrix":new Matrix(1, 0, 0, 1, rect.x, rect.y)};
				
				if ( _bitmapDataArr.length == totalFrames )
				{
					if ( _bitmapDataArr[0] )
					{
						var _cf:int = currentFrame;
						var _tf:int = totalFrames;
						
						super.skin = null;
						_mc = null;
						
						_curFrame = _cf;
						_totalFrames = _tf;
						
						RKFrameTickerManager.instance.register(this);
					}
				}
			}
			
			_bitmap.bitmapData = _bitmapDataArr[currentFrame - 1]["bitmapData"];
			_bitmap.x = _bitmapDataArr[currentFrame - 1]["matrix"].tx;
			_bitmap.y = _bitmapDataArr[currentFrame - 1]["matrix"].ty;
		}
		
		override public function dispose():void
		{
			disposeBitmap();
			_mc = null;
			super.dispose();
		}
		
		private function disposeBitmap():void
		{
			for each ( var _obj:Object in _bitmapDataArr )
			{
				_obj["bitmapData"].dispose();
			}
			
			_bitmapDataArr.length = 0;
			
			if ( _bitmap && _bitmap.bitmapData )
			{
				_bitmap.bitmapData.dispose();
			}
			
			if ( _bitmap )
			{
				if ( _bitmap.bitmapData )
				{
					_bitmap.bitmapData.dispose();
				}
				
				//if ( contains(_bitmap) )
				//{
				//	removeChild(_bitmap);
				//}
				
				//_bitmap = null;
			}
		}
	}
}
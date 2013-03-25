package com.rekoo.display.gui.popup
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.rekoo.RKFrameWork;
	import com.rekoo.interfaces.IRKFrameTicker;
	import com.rekoo.manager.RKFrameTickerManager;
	import com.rekoo.util.RKDisplayObjectUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 渐隐渐显效果的弹框。
	 * @author Administrator
	 */
	public class RKZoomPopUp extends RKPopUp implements IRKFrameTicker
	{
		/**
		 * 渐隐渐显效果的弹框。
		 * @param modal_ 是否模态显示。
		 * @param queue_ 是否排队显示。
		 * 
		 */	
		public function RKZoomPopUp()
		{
			super();
		}
		
		private var _rect:Rectangle = null;
		
		override public function show():void
		{
			if ( scrollRect != null )
			{
				_rect = scrollRect.clone();
			}
			else
			{
				_rect = getBounds(this);
			}
			
			visible = false;
			
			super.show();
			
			_bm = RKDisplayObjectUtil.getCapture(this);
			
			_bm.scaleX = 0.0;
			_bm.scaleY = 0.0;
			
			_bm.x = x + _rect.x + _rect.width / 2;
			_bm.y = y + _rect.y + _rect.height / 2;
			
			parent.addChild(_bm);
			
			TweenLite.to(_bm, 0.35, {transformAroundCenter:{scale:1.0}, ease:Back.easeOut, onComplete:onTweenComplete});
			
			//RKFrameTickerManager.instance.register(this);
		}
		
		private function onTweenComplete():void
		{
			visible = true;
			
			parent.removeChild(_bm);
			_bm.bitmapData.dispose();
			_bm = null;
		}
		
		private var _bm:Bitmap = null;
		
		public function tick():void
		{
			if ( _bm.scaleX < 1 )
			{
				_bm.scaleX += 0.3;
				_bm.x -= _rect.width / 2 * 0.3;
			}
			
			if ( _bm.scaleY < 1 )
			{
				_bm.scaleY += 0.3;
				_bm.y -= _rect.height / 2 * 0.3;
			}
			
			if ( _bm.scaleX >= 1 && _bm.scaleY >= 1 )
			{
				/*
				_bm.scaleX = 1;
				_bm.scaleY = 1;
				
				_bm.x = (RKFrameWork.APP_Width - _rect.width) / 2;
				_bm.y = (RKFrameWork.APP_Height - _rect.height) / 2;
				*/
				RKFrameTickerManager.instance.unregister(this);
				
				visible = true;
				
				parent.removeChild(_bm);
				_bm.bitmapData.dispose();
				_bm = null;
			}
		}
	}
}
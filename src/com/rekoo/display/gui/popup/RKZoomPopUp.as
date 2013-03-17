package com.rekoo.display.gui.popup
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.rekoo.RKFrameWork;
	import com.rekoo.interfaces.IRKFrameTicker;
	import com.rekoo.manager.RKFrameTickerManager;
	
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
				_rect = scrollRect;
			}
			else
			{
				_rect = getBounds(this);
			}
			
			scaleX = 0.0;
			scaleY = 0.0;
			
			x += _rect.width / 2;
			y += _rect.height / 2;
			
			super.show();
			
			//TweenLite.to(this, 0.2, {transformAroundCenter:{scale:1.0}});
			
			RKFrameTickerManager.instance.register(this);
		}
		
		public function tick():void
		{
			if ( scaleX < 1  )
			{
				scaleX += 0.3;
				x -= _rect.width / 2 * 0.3;
			}
			
			if ( scaleY < 1 )
			{
				scaleY += 0.3;
				y -= _rect.height / 2 * 0.3;
			}
			
			if ( scaleX >= 1 && scaleY >= 1 )
			{
				scaleX = 1;
				scaleY = 1;
				
				x = (RKFrameWork.APP_Width - _rect.width) / 2;
				y = (RKFrameWork.APP_Height - _rect.height) / 2;
				
				RKFrameTickerManager.instance.unregister(this);
			}
		}
	}
}
package com.rekoo.display.gui.popup
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.rekoo.RKFrameWork;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 渐隐渐显效果的弹框。
	 * @author Administrator
	 */
	public class RKZoomPopUp extends RKPopUp
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
		
		override public function show():void
		{
			var _rect:Rectangle = getBounds(this);
			
			scaleX = 0.0;
			scaleY = 0.0;
			
			x += _rect.width / 2;
			y += _rect.height / 2;
			
			TweenLite.to(this, 0.2, {transformAroundCenter:{scale:1.0}});
			super.show();
		}
	}
}
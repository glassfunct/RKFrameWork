package com.rekoo.display.gui.popup
{
	import com.greensock.TweenLite;
	import com.rekoo.RKFrameWork;

	/**
	 * 渐隐渐显效果的弹框。 
	 * @author Administrator
	 * 
	 */	
	public class RKAlphaPopUp extends RKPopUp
	{
		/**
		 * 渐隐渐显效果的弹框。
		 * @param modal_ 是否模态显示。
		 * @param queue_ 是否排队显示。
		 * 
		 */			
		public function RKAlphaPopUp(modal_:Boolean, queue_:Boolean)
		{
			super(modal_, queue_);
		}
		
		override public function show():void
		{
			alpha = 0.0;
			TweenLite.to(this, 0.5, {alpha:1.0});
			super.show();
		}
	}
}
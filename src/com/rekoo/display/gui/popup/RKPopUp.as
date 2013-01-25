package com.rekoo.display.gui.popup
{
	import com.rekoo.display.gui.RKGUI;
	import com.rekoo.interfaces.IRKPopUp;
	
	import flash.display.Bitmap;

	/**
	 * 弹框基类。 
	 * @author Administrator
	 * 
	 */	
	public class RKPopUp extends RKGUI implements IRKPopUp
	{
		private var _modal:Boolean = false;
		private var _queue:Boolean = false;
		
		/**
		 * 弹框基类。 
		 * @param modal_ 是否模态显示。
		 * @param queue_ 是否排队显示。
		 * 
		 */		
		public function RKPopUp()
		{
			super();
		}

		public function get modal():Boolean
		{
			return _modal;
		}

		public function set modal(value:Boolean):void
		{
			_modal = value;
		}

		public function get queue():Boolean
		{
			return _queue;
		}
				
		public function set queue(value:Boolean):void
		{
			_queue = value;
		}
	}
}
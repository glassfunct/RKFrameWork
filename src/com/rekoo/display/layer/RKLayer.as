package com.rekoo.display.layer
{
	import com.rekoo.display.RKToolTipableSprite;

	/**
	 * 层。 
	 * @author Administrator
	 * 
	 */	
	public class RKLayer extends RKToolTipableSprite
	{
		private var _name:String = null;
		
		/**
		 * 层。 
		 * @param name_ 层名称。
		 * 
		 */		
		public function RKLayer(name_:String)
		{
			super();
			_name = name_;
		}
		
		public function getName():String
		{
			return _name;
		}
	}
}
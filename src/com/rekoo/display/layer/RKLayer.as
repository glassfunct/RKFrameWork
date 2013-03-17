package com.rekoo.display.layer
{
	import com.rekoo.display.RKTooltipableSprite;

	/**
	 * 层。 
	 * @author Administrator
	 * 
	 */	
	public class RKLayer extends RKTooltipableSprite
	{
		private var _type:String = null;
		
		/**
		 * 层。 
		 * @param name_ 层名称。
		 * 
		 */		
		public function RKLayer(type_:String)
		{
			super();
			_type = type_;
		}
		
		public function getType():String
		{
			return _type;
		}
	}
}
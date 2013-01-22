package com.rekoo.geom
{
	import flash.geom.Point;
	
	/**
	 * 尺寸。
	 * @author Administrator
	 * 
	 */	
	public class RKSize
	{
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		
		/**
		 * 尺寸。
		 * @param width_ 宽度。
		 * @param height_ 高度。
		 * 
		 */		
		public function RKSize(width_:Number = 0.0, height_:Number = 0.0)
		{
			width = width_;
			height = height_;
		}
		
		/**
		 * 中心点。
		 * @return Point。
		 * 
		 */		
		public function get center():Point
		{
			return new Point(width / 2, height / 2);
		}
	}
}
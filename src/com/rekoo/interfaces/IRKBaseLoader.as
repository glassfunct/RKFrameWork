package com.rekoo.interfaces
{
	public interface IRKBaseLoader
	{
		/**
		 * 加载进度（百分比）。
		 * @return Number。
		 */
		function get percent():Number;
		
		/**
		 * 是否影响加载进度。
		 * @return Boolean。
		 * 
		 */		
		function get effectLoadingPer():Boolean;
		
		/**
		 * 是否显示加载图。
		 * @return Boolean。
		 * 
		 */		
		function get showLoading():Boolean;
	}
}
package com.rekoo.interfaces
{
	public interface IRKBaseLoader
	{
		/**
		 * 基本URL。
		 * @return 
		 * 
		 */		
		function get baseURL():String;
		
		/**
		 * 哈希后的URL。
		 * @return 
		 * 
		 */		
		function get hashedURL():String;
		
		/**
		 * 素材名。(带扩展名)
		 * @return 
		 * 
		 */		
		function get resourceName():String;
		
		/**
		 * 素材类型。
		 * @return 
		 * 
		 */		
		function get resourceType():String;
		
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
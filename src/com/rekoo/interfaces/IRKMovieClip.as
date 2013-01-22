package com.rekoo.interfaces
{
	public interface IRKMovieClip extends IRKFrameTicker
	{
		/**
		 * 是否自动播放。
		 * @return Boolean。
		 */		
		function get autoPlay():Boolean;
		
		/**
		 * 是否自动播放。
		 * @param value Boolean。
		 */	
		function set autoPlay(value:Boolean):void;
		
		/**
		 * 循环次数。为0则无限循环。
		 * @return uint。
		 */	
		function get loop():uint;
		
		/**
		 * 循环次数。为0则无限循环。
		 * @param value uint。
		 */
		function set loop(value:uint):void;
		
		/**
		 * 自定义帧频。
		 * @return int。
		 */
		function get frameRate():int;
		
		/**
		 * 自定义帧频。
		 * @param value int。
		 */
		function set frameRate(value:int):void;
		
		/**
		 * 当前帧。
		 * @return int。
		 */		
		function get currentFrame():int;
		
		/**
		 * 总帧数。
		 * @return int。
		 */	
		function get totalFrames():int;
		
		/**
		 * 播放。
		 */	
		function play():void;
		
		/**
		 * 停止。
		 */	
		function stop():void;
		
		/**
		 * 从某一帧开始播放。
		 * @param frame_ 帧数。
		 */		
		function gotoAndPlay(frame_:int):void;
		
		/**
		 * 停在某一帧。
		 * @param frame_ 帧数。
		 */	
		function gotoAndStop(frame_:int):void;
		
		function dispose():void;
	}
}
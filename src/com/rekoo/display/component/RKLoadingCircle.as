package com.rekoo.display.component
{
	import com.rekoo.interfaces.IRKFrameTicker;
	import com.rekoo.manager.RKFrameTickerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 转圈的loading动画。
	 * @author zhe.zhang
	 */
	public class RKLoadingCircle extends Shape implements IRKFrameTicker
	{
		private var _radius:int = 0;
		
		/**
		 * 构造函数。
		 * @param	radius_ 半径。
		 */
		public function RKLoadingCircle(radius_:Number)
		{
			super();
			
			_radius = radius_;
			
			create();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function set radius(value:Number):void
		{
			if ( value < 15 )
				_radius = 15;
			else if ( value > 25 )
				_radius = 25;
			else
				_radius = value;
			
			create();
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 * 销毁。
		 */
		public function dispose():void
		{
			graphics.clear();
			
			if ( parent )
				parent.removeChild(this);
		}
		
		private function create():void
		{
			var _lr:Number = 0.0;
			
			var _angles:Array = [0];
			var _circles:Array = [];
			
			_circles.push( { c:new Point(_radius, 0), r:0, a:0 } );
			
			graphics.clear();
			
			graphics.beginFill(0, 0);
			graphics.drawCircle(0, 0, _radius);
			graphics.endFill();
			
			//构造8个紧贴在一起围成一圈的圆。
			for ( var _i:int = 0; _i <= 8; _i ++ )
			{
				var _r:Number = 0.0;//半径。
				var _c:Point = new Point();//圆心。
				var _a:Number = 0.0;//透明度。
				
				if ( _i != 0 )
				{
					if ( _i == 1 )
					{
						_lr = _r = _radius * 0.3;
					}
					else
					{
						_r = _lr * 0.91;
						_lr = _r;
					}
					
					var _al:Number = _circles[_i - 1].r + _r;
					var _bl:Number = _radius - _circles[_i - 1].r;
					var _cl:Number = _radius - _r;
					var _acos:Number = (_bl * _bl + _cl * _cl - _al * _al) / (2 * _bl * _cl);
					
					if ( _acos < -1 )
					{
						_acos = -1;
					}
					else if ( _acos > 1 )
					{
						_acos = 1;
					}
					
					var _angleA:Number = Math.acos( _acos ) * 180 / Math.PI;
					_angles[_i] = _angleA + _angles[_i - 1];
					
					_c.x = Math.cos(_angles[_i] * Math.PI / 180) * (_radius - _r);
					_c.y = Math.sin(_angles[_i] * Math.PI / 180) * (_radius - _r);
					_a = (9 - _i) / 10;
					
					_circles.push( { c:_c, r:_r, a:_a } );
				}
			}
			
			//把剩下的角度平均分配到每两个圆的夹角中。
			var _leftAngle:Number = 360 - _angles[8];
			
			for ( var _k:int = 0; _k <= 8; _k ++ )
			{
				_angles[_k] = _angles[_k] + _leftAngle / 11 * _k;
				
				_circles[_k].c.x = Math.cos(_angles[_k] * Math.PI / 180) * (_radius - _r);
				_circles[_k].c.y = Math.sin(_angles[_k] * Math.PI / 180) * (_radius - _r);
			}
			
			//把圆画出来。
			for ( var _q:int = 0; _q <= 8; _q ++ )
			{
				graphics.beginFill(0xFFFFFF, _circles[_q].a);
				graphics.drawCircle(_circles[_q].c.x, _circles[_q].c.y, _circles[_q].r);
				graphics.endFill();
			}
		}
		
		private function onAddedToStage(evt_:Event):void
		{
			visible = true;
			RKFrameTickerManager.instance.register(this);
		}
		
		private function onRemovedFromStage(evt_:Event):void
		{
			visible = false;
			RKFrameTickerManager.instance.unregister(this);
		}
		
		public function tick():void
		{
			rotation -= 40;
			
			if ( rotation == -360 )
				rotation = 0;
		}
	}
}
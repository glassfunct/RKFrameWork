package com.rekoo.display.component
{
	import com.rekoo.RKDirection;
	import com.rekoo.RKFrameWork;
	import com.rekoo.RKPosition;
	import com.rekoo.display.RKSprite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	/**
	 * 滚动条。
	 * @author Administrator
	 * 
	 */	
	public class RKScrollBar extends RKSprite
	{
		private var _direct:String = null;
		
		protected var _upArrowBtn:RKButton = null;
		protected var _downArrowBtn:RKButton = null;
		
		protected var _thumb:Sprite = null;
		protected var _bar:Sprite = null;
		
		private var _thumbStartPos:Point = new Point();
		private var _mouseStartPos:Point = new Point();
		
		private var _thumbTargetPos:Point = new Point();
		private var _oldThumbTargetPos:Point = new Point();
		
		protected var _mask:DisplayObject = null;
		protected var _target:DisplayObject = null;
		
		private var _tarOrgX:Number = 0.0;
		private var _tarOrgY:Number = 0.0;
		
		private var _refValue:Number = 0.0;
		private var _totalValue:Number = 0.0;
		
		private var _step:Number = 0.0;
		private var _stepScale:Number = 0.0;
		private var _barScale:Number = 0.0;
		
		private var _changeFunc:Function = null;
		
		/**
		 * 滚动条。
		 * @param skin_ 皮肤。
		 * @param direction_ 方向（RKDirection）。
		 * 
		 */		
		public function RKScrollBar(skin_:DisplayObject, direction_:String = "VERTICAL", onChange_:Function = null)
		{
			super(skin_);
			_direct = direction_;
			_changeFunc = onChange_;
			
			init();
		}
		
		private function init():void
		{
			_upArrowBtn = new RKButton(skin["upArrow"], onUpArrow);
			_downArrowBtn = new RKButton(skin["downArrow"], onDownArrow);
			
			_thumb = skin["thumb"];
			_bar = skin["bar"];
			
			_thumb.buttonMode = true;
			_thumb.useHandCursor = true;
			
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			RKFrameWork.APP_Stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			
			addEventListener(Event.ADDED_TO_STAGE, onaAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			RKFrameWork.APP_Stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			
			removeEventListener(Event.ADDED_TO_STAGE, onaAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onaAddedToStage(evt_:Event):void
		{
			RKFrameWork.APP_Stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, true);
		}
		
		private function onRemovedFromStage(evt_:Event):void
		{
			RKFrameWork.APP_Stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, true);
		}
		
		private function onMouseWheel(evt_:MouseEvent):void
		{
			var _hitFlag:Boolean = false;
			
			if ( _mask && _target )
			{
				if ( _mask.getBounds(RKFrameWork.APP_Stage).contains(RKFrameWork.APP_Stage.mouseX, RKFrameWork.APP_Stage.mouseY))
				{
					_hitFlag = true;
				}
			}
			
			if ( this.getBounds(RKFrameWork.APP_Stage).contains(RKFrameWork.APP_Stage.mouseX, RKFrameWork.APP_Stage.mouseY) )
			{
				_hitFlag = true;
			}
			
			if ( _hitFlag )
			{
				_thumbTargetPos.y -= evt_.delta * _step / _stepScale;
				updatePos();
				evt_.stopPropagation();
			}
		}
		
		private function onThumbDown(evt_:MouseEvent):void
		{
			_thumbStartPos.x = _thumb.x;
			_thumbStartPos.y = _thumb.y;
			
			_oldThumbTargetPos.copyFrom(_thumbStartPos);
			
			_mouseStartPos.x = RKFrameWork.APP_Stage.mouseX;
			_mouseStartPos.y = RKFrameWork.APP_Stage.mouseY;
			
			RKFrameWork.APP_Stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
		}
		
		
		private function onThumbUp(evt_:MouseEvent):void
		{
			RKFrameWork.APP_Stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
		}
		
		private function onThumbMove(evt_:MouseEvent):void
		{
			_thumbTargetPos.x = _thumbStartPos.x + RKFrameWork.APP_Stage.mouseX - _mouseStartPos.x;
			_thumbTargetPos.y = _thumbStartPos.y + RKFrameWork.APP_Stage.mouseY - _mouseStartPos.y;
			
			updatePos();
		}
		
		private function updatePos():void
		{
				if ( _thumbTargetPos.x < _bar.x )
				{
					_thumbTargetPos.x = _bar.x;
				}
				else if ( _thumbTargetPos.x + _thumb.width > _bar.width + _bar.x )
				{
					_thumbTargetPos.x = _bar.width + _bar.x - _thumb.width;
				}
				
				if ( _thumbTargetPos.y < _bar.y )
				{
					_thumbTargetPos.y = _bar.y;
				}
				else if ( _thumbTargetPos.y + _thumb.height > _bar.height + _bar.y )
				{
					_thumbTargetPos.y = _bar.height + _bar.y - _thumb.height;
				}
				
				if ( _direct == RKDirection.HORIZONTAL )
				{
					_thumb.x = _thumbTargetPos.x;
					
					if ( _mask && _target )
					{
						var _num1:Number = (_bar.x - _thumb.x) / (_bar.width - _thumb.width) * (_totalValue - _refValue);
						
						if ( isNaN(_num1) )
						{
							_num1 = 0;
						}
						
						_target.x = _tarOrgX + _num1;
					}
					
					if ( _oldThumbTargetPos.x != _thumbTargetPos.x && _changeFunc != null )
					{
						_changeFunc();
					}
				}
				else if ( _direct == RKDirection.VERTICAL )
				{
					_thumb.y = _thumbTargetPos.y;
					
					if ( _mask && _target )
					{
						var _num2:Number = (_bar.y - _thumb.y) / (_bar.height - _thumb.height) * (_totalValue - _refValue);
						
						if ( isNaN(_num2) )
						{
							_num2 = 0;
						}
						
						_target.y = _tarOrgY + _num2;
					}
					
					if ( _oldThumbTargetPos.y != _thumbTargetPos.y && _changeFunc != null )
					{
						_changeFunc();
					}
				}
				
				_oldThumbTargetPos.copyFrom(_thumbTargetPos);
		}
		
		private function onUpArrow():void
		{
			_thumbTargetPos.x -= _step / _stepScale;
			_thumbTargetPos.y -= _step / _stepScale;
			updatePos();
		}
		
		private function onDownArrow():void
		{
			_thumbTargetPos.x += _step / _stepScale;
			_thumbTargetPos.y += _step / _stepScale;
			updatePos();
		}
		
		/**
		 * 绑定显示对象。
		 * @param target_ 目标容器。
		 * @param mask_ 目标容器的蒙版。
		 * @param step_ 每点一次上下箭头或每个鼠标滚轮单位delta，目标容器所移动的距离。
		 * @param barScale_ 滚动条的缩放比例（默认与蒙版等高或等宽）。
		 * 
		 */		
		public function bindDisplayObject(target_:DisplayObject, mask_:DisplayObject, step_:Number = 1.0, barScale_:Number = 1.0):void
		{
			if ( _direct == RKDirection.HORIZONTAL )
			{
				bindValue(mask_.width, target_.width, step_, barScale_);
			}
			else if ( _direct == RKDirection.VERTICAL )
			{
				bindValue(mask_.height, target_.height, step_, barScale_);
			}
			
			target_.mask = mask_;
			_tarOrgX = target_.x;
			_tarOrgY = target_.y;
			//target_.x = mask_.x;
			//target_.y = mask_.y;
			
			_target = target_;
			_mask = mask_;
		}
		
		/**
		 * 绑定数值。
		 * @param reference_ 参考值。相当于绑定显示对象时可视区域的值。
		 * @param total_ 总值。
		 * @param step_  每点一次上下箭头或每个鼠标滚轮单位delta，目标容器所移动的距离。
		 * @param barScale_  滚动条的缩放比例（默认与蒙版等高或等宽）。
		 * 
		 */		
		public function bindValue(reference_:Number, total_:Number, step_:Number = 1.0, barScale_:Number = 1.0):void
		{
			_target = null;
			_mask = null;
			
			_refValue = reference_;
			_totalValue = total_;
			
			_step = step_;
			_barScale = barScale_;
			
			updateView();
			
		}
		
		private function updateView(reset_:Boolean = true):void
		{
			if ( _direct == RKDirection.HORIZONTAL )
			{
				if ( _mask && _target )
				{
					_refValue = _mask.width;
					_totalValue = _target.scrollRect ? _target.scrollRect.width : _target.width;
				}
				
				_bar.width = (_refValue - 28) * _barScale;
				_thumb.width = Math.min(_bar.width, _refValue / _totalValue * _bar.width * _barScale);
				_downArrowBtn.x = _bar.width + 28;
				_stepScale = (_totalValue - _refValue) / (_bar.width - _thumb.width);
			}
			else if ( _direct == RKDirection.VERTICAL )
			{
				if ( _mask && _target )
				{
					_refValue = _mask.height;
					_totalValue = _target.scrollRect ? _target.scrollRect.height : _target.height;
				}
				
				_bar.height = (_refValue - 28) * _barScale;
				_thumb.height = Math.min(_bar.height, _refValue / _totalValue * _bar.height * _barScale);
				_downArrowBtn.y = _bar.height + 28;
				_stepScale = (_totalValue - _refValue) / (_bar.height - _thumb.height);
			}
			
			visible = _totalValue > _refValue;
			
			if ( reset_ || !visible )
			{
				_thumb.x = _bar.x;
				_thumb.y = _bar.y;
			}
			
			_oldThumbTargetPos.copyFrom(_thumbTargetPos);
			_thumbTargetPos.x = _thumb.x;
			_thumbTargetPos.y = _thumb.y;
		}
		
		/**
		 * 目标容器尺寸发生改变时调用此方法刷新滚动条。
		 * @param reset_ 是否重置滚动条位置。
		 */		
		public function refresh(reset_:Boolean = true):void
		{
			updateView(reset_);
			updatePos();
		}
		
		/**
		 * 滚动条当前移动距离与最大移动距离的百分比（0～1）。
		 */		
		public function get position():Number
		{
			var _res:Number = 0.0;
			
			if ( _direct == RKDirection.HORIZONTAL )
			{
				_res = (_thumb.x - _bar.x) / (_bar.width - _thumb.width);
			}
			else if ( _direct == RKDirection.VERTICAL )
			{
				_res = (_thumb.y - _bar.y) / (_bar.height - _thumb.height);
			}
			
			return _res;
		}
		
		/**
		 * @private
		 */
		public function set position(value_:Number):void
		{
			if ( visible )
			{
				_thumbTargetPos.x = _bar.x + (_bar.width - _thumb.width) * value_;
				_thumbTargetPos.y = _bar.y + (_bar.height - _thumb.height) * value_;
				updatePos();
			}
		}
	}
}
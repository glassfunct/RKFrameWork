package com.rekoo.display.component
{
	import com.rekoo.display.RKSprite;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class RKNumberStepper extends RKSprite
	{
		protected var _addBtn:RKButton = null;
		protected var _minusBtn:RKButton = null;
		protected var _maxBtn:RKButton = null;
		protected var _minBtn:RKButton = null;
		protected var _inputTF:TextField = null;
		protected var _onChange:Function = null;
		
		private var _minValue:int = 0;
		private var _maxValue:int = 0;
		private var _curValue:int = 0;
		private var _step:int = 0;
		
		public function RKNumberStepper(skin_:DisplayObject, minValue_:int, maxValue_:int, step_:int = 1, onChange_:Function = null)
		{
			super(skin_);
			_minValue = minValue_;
			_maxValue = maxValue_;
			_step = step_;
			_onChange = onChange_;
		}
		
		override public function initView():void
		{
			_addBtn = new RKButton(skin["addBtn"]);
			_minusBtn = new RKButton(skin["minusBtn"]);
			
			if ( skin["maxBtn"] != null )
			{
				_maxBtn = new RKButton(skin["maxBtn"], max);
			}
			
			if ( skin["minBtn"] != null )
			{
				_minBtn = new RKButton(skin["minBtn"], min);
			}
			
			_inputTF = skin["input"];
			_inputTF.restrict = "0-9";
			_inputTF.addEventListener(Event.CHANGE, onNumChanged);
		}
		
		private function add():void
		{
			var _num:int = parseInt(_inputTF.text);
			_inputTF.text = (_num + _step).toString();
			
			onNumChanged(null);
		}
		
		private function minus():void
		{
			var _num:int = parseInt(_inputTF.text);
			_inputTF.text = (_num - _step).toString();
			
			onNumChanged(null);
		}
		
		private function onNumChanged(evt_:Event = null):void
		{
			var _num:int = parseInt(_inputTF.text);
			
			if ( _num == _curValue )
			{
				return;
			}
			
			if ( _num < _minValue )
			{
				_num = _minValue;
			}
			else if ( _num > _maxValue )
			{
				_num = _maxValue;
			}
			
			_curValue = _num;
			
			_inputTF.text = _curValue.toString();
			
			_addBtn.enabled = _curValue < _maxValue;
			_minusBtn.enabled = _curValue > _minValue;
			
			if ( _onChange != null )
			{
				if ( _onChange.length )
				{
					_onChange(this);
				}
				else
				{
					_onChange();
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_inputTF.removeEventListener(Event.CHANGE, onNumChanged);
		}

		public function get minValue():Number
		{
			return _minValue;
		}

		public function set minValue(value:Number):void
		{
			_minValue = value;
		}

		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function set maxValue(value:Number):void
		{
			_maxValue = value;
		}

		public function get currentValue():Number
		{
			return _curValue;
		}

		public function set currentValue(value:Number):void
		{
			if ( _curValue != value )
			{
				_curValue = value;
				_inputTF.text = _curValue.toString();
				onNumChanged();
			}
		}

		public function get step():int
		{
			return _step;
		}

		public function set step(value:int):void
		{
			_step = value;
		}
		
		public function max():void
		{
			currentValue = maxValue;
		}
		
		public function min():void
		{
			currentValue = minValue;
		}

		public function get onChange():Function
		{
			return _onChange;
		}

		public function set onChange(value:Function):void
		{
			_onChange = value;
		}


	}
}
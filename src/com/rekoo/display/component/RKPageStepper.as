package com.rekoo.display.component
{
	import com.rekoo.display.RKSprite;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	public class RKPageStepper extends RKSprite
	{
		protected var _prevBtn:RKButton = null;
		protected var _nextBtn:RKButton = null;
		protected var _firstBtn:RKButton = null;
		protected var _lastBtn:RKButton = null;
		protected var _pageNumTF:TextField = null;
		
		private var _curPage:int = 0;
		private var _totalPages:int = 0;
		protected var _onChange:Function = null;
		
		public function RKPageStepper(skin_:DisplayObject, totalPages_:int, onChange_:Function = null)
		{
			super(skin_);
			_totalPages = totalPages_;
			_onChange = onChange_;
		}
		
		override public function initView():void
		{
			_prevBtn = new RKButton(skin["prevBtn"], prevPage);
			_nextBtn = new RKButton(skin["nextBtn"], nextPage);
			
			if ( skin["firstBtn"] )
			{
				_firstBtn = new RKButton(skin["firstBtn"], firstPage);
			}
			
			if ( skin["lastBtn"] )
			{
				_lastBtn = new RKButton(skin["lastBtn"], lastPage);
			}
			
			if ( skin["pageNum"] )
			{
				_pageNumTF = skin["pageNum"];
			}
			
			updateDisplay();
			
		}
		
		public function prevPage():void
		{
			if ( _curPage > 1 )
			{
				currentPage --;
			}
		}
		
		public function nextPage():void
		{
			if ( _curPage < _totalPages )
			{
				currentPage ++;
			}
		}
		
		public function firstPage():void
		{
			currentPage = 1;
		}
		
		public function lastPage():void
		{
			currentPage = _totalPages;
		}

		public function get currentPage():int
		{
			return _curPage;
		}

		public function set currentPage(value:int):void
		{
			value = Math.min(value, _totalPages);
			
			if (_curPage != value )
			{
				_curPage = value;
				
				updateDisplay();
				
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
		}

		public function get totalPages():int
		{
			return _totalPages;
		}

		public function set totalPages(value:int):void
		{
			_totalPages = value;
			
			if ( _totalPages < _curPage )
			{
				currentPage = _totalPages;
			}
			else
			{
				updateDisplay();
			}
		}

		public function get onChange():Function
		{
			return _onChange;
		}

		public function set onChange(value:Function):void
		{
			_onChange = value;
		}
		
		private function updateDisplay():void
		{
			if ( _pageNumTF )
			{
				_pageNumTF.text = _curPage + "/" + _totalPages;
			}
			
			_prevBtn.enabled = _curPage > 1;
			
			if ( _firstBtn )
			{
				_firstBtn.enabled = _curPage != 1;
			}
			_nextBtn.enabled = _curPage < _totalPages;
			
			if ( _lastBtn )
			{
				_lastBtn.enabled = _curPage != _totalPages;
			}
		}

	}
}
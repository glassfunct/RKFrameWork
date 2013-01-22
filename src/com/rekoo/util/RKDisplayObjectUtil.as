package com.rekoo.util
{
	import com.rekoo.RKDisplayAlign;
	import com.rekoo.interfaces.IRKMovieClip;
	import com.rekoo.interfaces.IRKSprite;
	import com.rekoo.interfaces.IRKToolTipSkin;
	import com.rekoo.interfaces.IRKToolTipable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class RKDisplayObjectUtil
	{
		/**
		 * 销毁显示对象。
		 * @param displayObject_ DisplayObject。
		 * 
		 */		
		public static function dispose(displayObject_:DisplayObject):void
		{
			if ( displayObject_ == null )
			{
				return;
			}
			
			if ( displayObject_.parent )
			{
				displayObject_.parent.removeChild(displayObject_);
			}
			
			if ( displayObject_ is IRKToolTipSkin )
			{
				(displayObject_ as IRKToolTipSkin).dispose();
			}
			else if ( displayObject_ is IRKToolTipable )
			{
				(displayObject_ as IRKToolTipable).dispose();
			}
			else if ( displayObject_ is IRKSprite )
			{
				(displayObject_ as IRKSprite).dispose();
			}
			else if ( displayObject_ is IRKMovieClip )
			{
				(displayObject_ as IRKMovieClip).dispose();
			}
			else if ( displayObject_ is MovieClip )
			{
				(displayObject_ as MovieClip).stop();
				(displayObject_ as MovieClip).graphics.clear();
			}
			else if ( displayObject_ is Sprite )
			{
				(displayObject_ as Sprite).graphics.clear();
			}
			else if ( displayObject_ is Shape )
			{
				(displayObject_ as Shape).graphics.clear();
			}
			else if ( displayObject_ is Bitmap )
			{
				(displayObject_ as Bitmap).bitmapData.dispose();
			}
			
			displayObject_ = null;
		}
		
		/**
		 * 更新显示对象对齐方式。
		 * @param target_ 显示对象。
		 * @param area_ 目标区域。
		 * @param align_ 对齐方式。
		 * @param offset_ 坐标偏移量。
		 * @param simple_ 是否简单对齐。简单对齐的话不会考虑显示对象的大小。
		 * 
		 */		
		public static function align(target_:DisplayObject, area_:Rectangle, align_:String, offset_:Point = null, simple_:Boolean = false):void
		{
			var _rect:Rectangle = simple_ ? new Rectangle() : target_.getBounds(target_);
			
			switch ( align_ )
			{
				case RKDisplayAlign.LEFT:
					target_.x = area_.x;
					target_.y = area_.y + (area_.height - _rect.height) / 2;
					break;
				
				case RKDisplayAlign.LEFT_TOP:
					target_.x = area_.x;
					target_.y = area_.y;
					break;
				
				case RKDisplayAlign.TOP:
					target_.x = area_.x + (area_.width - _rect.width) / 2;
					target_.y = area_.y;
					break;
				
				case RKDisplayAlign.RIGHT_TOP:
					target_.x = area_.x + area_.width - _rect.width;
					target_.y = area_.y;
					break;
				
				case RKDisplayAlign.RIGHT:
					target_.x = area_.x + area_.width - _rect.width;
					target_.y = area_.y + (area_.height - _rect.height) / 2;
					break;
				
				case RKDisplayAlign.RIGHT_BOTTOM:
					target_.x = area_.x + area_.width - _rect.width;
					target_.y = area_.y + area_.height - _rect.height;
					break;
				
				case RKDisplayAlign.BOTTOM:
					target_.x = area_.x + (area_.width - _rect.width) / 2;
					target_.y = area_.y + area_.height - _rect.height;
					break;
				
				case RKDisplayAlign.LEFT_BOTTOM:
					target_.x = area_.x;
					target_.y = area_.y + area_.height - _rect.height;
					break;
				
				case RKDisplayAlign.CENTER:
					target_.x = area_.x + (area_.width - _rect.width) / 2;
					target_.y = area_.y + (area_.height - _rect.height) / 2;
					break;
				
				case RKDisplayAlign.NONE:
					target_.x = area_.x;
					target_.y = area_.y;
					break;
				
				default:
					target_.x = area_.x;
					target_.y = area_.y;
					break;
			}
			
			if ( offset_ )
			{
				target_.x += offset_.x;
				target_.y += offset_.y;
			}
		}
		
		/**
		 * 切割图像（先从左向右，后自上而下）。
		 * @param bitmapData_ 源图像。
		 * @param cols_ 源图像包含的列数。
		 * @param rows_ 源图像包含的行数。
		 * @return Array。
		 */		
		public static function splitBitmapData(bitmapData_:BitmapData, cols_:int, rows_:int):Array
		{
			var _arr:Array = [];
			var _bitmapData:BitmapData = null;
			var _cellW:Number = bitmapData_.width / cols_;
			var _cellH:Number = bitmapData_.height / rows_;
			
			for ( var _row:int = 0; _row < rows_; _row ++ )
			{
				for ( var _col:int = 0; _col < cols_; _col ++ )
				{
					_bitmapData = new BitmapData(_cellW, _cellH, true, 0);
					_bitmapData.lock();
					_bitmapData.copyPixels(bitmapData_, new Rectangle(_col * _cellW, _row * _cellH, _cellW, _cellH), new Point());
					_bitmapData.unlock();
					
					_arr.push(_bitmapData);
				}
			}
			
			return _arr;
		}
	}
}
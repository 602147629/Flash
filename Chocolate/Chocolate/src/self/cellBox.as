package src.self 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class cellBox extends Sprite 
	{
		private var _type:int;
		private var _xx:Number;
		private var _yy:Number;
		
		public function cellBox() 
		{
			super();
			TextField(tt).mouseEnabled = false;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
			//tt.text = _type.toString();
		}
		
		public function get xx():Number 
		{
			return _xx;
		}
		
		public function set xx(value:Number):void 
		{
			_xx = value;
		}
		
		public function get yy():Number
		{
			return _yy;
		}
		
		public function set yy(value:Number):void
		{
			_yy = value;
		}
	}

}
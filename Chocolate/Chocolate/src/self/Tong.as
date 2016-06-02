package src.self 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class Tong extends MovieClip 
	{
		private var _index:uint;
		public function Tong() 
		{
			super();
		}
		/**
		 * 更新
		 * @param	position
		 * @param	index
		 */
		public function update(position:Point, ind:uint):void {
			this.x = position.x;
			this.y = position.y;
			this.gotoAndStop(ind);
			index = ind;
		}
		/**
		 * 倒
		 */
		public function open():void {
			this["a" + index].gotoAndStop(2);
		}
		
		public function get index():uint 
		{
			return _index;
		}
		
		public function set index(value:uint):void 
		{
			_index = value;
		}
	}

}
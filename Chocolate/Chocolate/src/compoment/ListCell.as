package src.compoment 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class ListCell extends Sprite 
	{
		private var _index:Number = 0;
		private var _label:TextField;
		public function ListCell() 
		{
			super();
			initView();
		}
		
		private function initView():void {
			_label = label;
			_label.mouseEnabled = false;
		}
		
		public function get index():Number 
		{
			return _index;
		}
		
		public function set index(value:Number):void 
		{
			_index = value;
		}
		/**
		 * 设置label
		 * @param	str
		 */
		public function labels(str:String):void {
			_label.text = str;
		}
	}

}
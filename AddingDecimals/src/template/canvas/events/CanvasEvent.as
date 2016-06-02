package template.canvas.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class CanvasEvent extends Event 
	{
		public static const ALPHA_CHANGE_EVENT:String = "ALPHA_CHANGE_EVENT";//透明度改变
		
		
		private var _data:Object={};
		public function CanvasEvent(type:String,data:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			_data = data;
			super(type, bubbles, cancelable);
			
		}
		
		/**
		 * 事件携带的数据
		 */
		public function get data():Object {
			return _data;
		}
	}

}
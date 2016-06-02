package template.menus.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Mu
	 */
	public class MenuClickEvent extends Event 
	{
		
		public static const MENU_CLICK_EVENT:String = "MENU_CLICK_EVENT";
		
		private var _data:Object;
		public function MenuClickEvent(type:String,data:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_data = data;
			super(type, bubbles, cancelable);
		} 
		
		public function get data():Object {
			return _data;
		}
		
		public override function clone():Event 
		{ 
			return new MenuClickEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuClickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
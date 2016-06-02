package template.utily 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**事件桥，可以全局发送，接受事件
	 * ...
	 * @author Mu
	 */
	public class EventBridge 
	{
		public static var instance:EventDispatcher = new EventDispatcher();
		public function EventBridge() 
		{
			throw new Error("不可以实例化");
		}
		
		public static function dispatchEvent(e:Event):void {
			instance.dispatchEvent(e);
		}
		
		public static function addEventListener(type:String, listener:Function, priority:Number):void {
			instance.addEventListener(type, listener,false,priority);
		}
		
		public static function removeEventListener(type:String, listener:Function):void {
			instance.removeEventListener(type, listener);
		}
		
		public static function hasEventListener(type:String):Boolean {
			return instance.hasEventListener(type);
		}
	}

}
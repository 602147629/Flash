package template.animate.event 
{
	import flash.events.Event;
	
	/**控制条事件
	 * ...
	 * @author Mu
	 */
	public class AnimateControllerEvent extends Event 
	{
		
		public static const ANIMATE_PLAY_EVENT:String = "animate_play_event";//播放
		public static const ANIMATE_PAUSE_EVENT:String = "animate_pause_event";//暂停
		public static const ANIMATE_STOP_EVENT:String = "animate_stop_event";//停止
		public static const ANIMATE_FOWARD_EVENT:String = "animate_foward_event";//快进
		public static const ANIMATE_BACK_EVENT:String = "animate_back_event";//快退
		
		public static const ANIMATE_BAR_DOWN:String = "animate_bar_down";
		public static const ANIMATE_BAR_UP:String = "animate_bar_up";
		
		public static const ANIMATE_LINE_DOWN:String = "animate_line_down";
		
		public static const SOUND_BAR_DOWN:String = "sound_bar_down";
		public static const SOUND_BAR_UP:String = "sound_bar_up";
		
		public static const SOUND_LINE_DOWN:String = "sound_line_down";
		
		public static const SOUND_MURE_DOWN:String = "sound_mute_down";
		public static const SOUND_OPEN_DOWN:String = "sound_open_down";
		
		private var _data:Object;
		public function AnimateControllerEvent(type:String,data:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			_data = data;
			super(type,bubbles, cancelable);
			
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(obj:Object):void {
			_data = obj;
		}
	}

}
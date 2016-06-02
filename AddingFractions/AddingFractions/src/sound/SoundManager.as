package src.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	/**声音播放
	 * @author Mu
	 */
	public class SoundManager 
	{
		private var sound:Sound;//声音
		private var channel:SoundChannel;//通道
		private var soundData:Array = [];
		
		private static var _instance:SoundManager = new SoundManager();
		public function SoundManager() 
		{
			if (_instance) {
				throw new Error("单例");
			}
		}
		
		public static function  get instance():SoundManager {
			return _instance;
		}
		
		/**
		 * 播放声音
		 * @param	id
		 */
		public function playSound(id:String):void {
			disposeSound();
			
			var cl:Class = ApplicationDomain.currentDomain.getDefinition(id) as Class;
			sound = new cl();
			channel = sound.play();
			channel.addEventListener(Event.SOUND_COMPLETE, playComplete);
		}
		
		private function playComplete(e:Event):void {
			disposeSound();
		}
		
		/**
		 * 销毁声音
		 */
		public function disposeSound():void {
			if (sound) {
				sound = null;
			}
			if (channel) {
				channel.stop();
				if (channel.hasEventListener(Event.SOUND_COMPLETE))
					channel.removeEventListener(Event.SOUND_COMPLETE, playComplete);
				channel = null;
			}
		}
	}

}
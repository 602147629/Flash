package template.utily.sound 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Mu
	 */
	public class SoundManager 
	{
		private static var _instance:SoundManager = new SoundManager();
		public function SoundManager() 
		{
			if (_instance) {
				throw new Error("单利！");
			}
		}
		public static function get instance():SoundManager {
			return _instance;
		}
		
		/////声音列表
		private var soundLists:Dictionary = new Dictionary();
		
		/**
		 * 检查是否已经存在
		 * @param	id
		 * @return
		 */
		private function checkExist(id:String):SoundCell {
			for (var key:String in soundLists) {
				if (key == id)
				{
					return soundLists[id] as SoundCell;
				}
			}
			return null;
		}
		
		/**
		 * 预加载多个声音
		 * @param	urlArr
		 * @param	complateHand
		 */
		public function preload(urlArr:Array, complateHand:Function):void {
			var count:Number = 0;
			var soundSrc:SoundCell;
			var url:String;
			for (var i:int = 0; i < urlArr.length; i++) {
				url = urlArr[i];
				soundSrc = new SoundCell(url, comHand, errHand);
			}
			
			function comHand(e:Event):void {
				soundSrc.loadComplete = true;
				count ++;
				soundLists[url] = soundSrc;
				if (complateHand != null&& count==urlArr.length)
					complateHand();
			}
			function errHand(e:IOErrorEvent):void {
				trace("error:" + count);
			}
		}
		
		/**
		 * 播放声音
		 * @param	url  地址
		 */
		public function playSound(url:String):void {
			if (!url) {
				trace("地址为空！！");
				return;
			}
			
			var soundSrc:SoundCell = checkExist(url);
			if (soundSrc == null) {
				soundSrc = new SoundCell(url);
				soundLists[url] = soundSrc;
				soundSrc.play();
			}else {
				soundSrc.play();
			}
		}
		/**
		 * 获取声音源
		 * @param	url
		 * @return
		 */
		public function getSound(url:String):SoundCell {
			for (var key:String in soundLists) {
				if (key == url) {
					return soundLists[key] as SoundCell;
				}
			}
			return null;
		}
		
		/**
		 * 统一调整音量
		 * @param	num
		 */
		public function volumeTotal(num:Number):void {
			for each(var obj:Object in soundLists) {
				SoundCell(obj).volume(num);
			}
		}
	}

}
package template.utily.sound 
{
	import com.greensock.events.LoaderEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Mu
	 */
	public class SoundCell 
	{
		public var soundPlayer:Sound;
		public var soundChannel:SoundChannel;
		
		public var position:Number = 0;
		public var loadComplete:Boolean = false;
		public var loadComHand:Function = null;
		public var loadErrHand:Function = null;
		public function SoundCell(url:String,conH:Function=null,errH:Function=null) 
		{
			if (!url) return;
			var request:URLRequest = new URLRequest(url);
			soundPlayer = new Sound();
			
			if(conH!=null)
				loadComHand = conH;
			else
				loadComHand = conHander;
			if(errH!=null)
				loadErrHand = errH;
			else
				loadErrHand = errHander;
			
			soundPlayer.addEventListener(Event.COMPLETE, loadComHand);
			soundPlayer.addEventListener(IOErrorEvent.IO_ERROR,loadErrHand);
			soundPlayer.load(request);
		}
		
		private function conHander(e:Event):void {
			loadComplete = true;
		}
		private function errHander(e:IOErrorEvent):void {
			trace("...", e);
		}
		
		/**
		 * 播放
		 */
		public function play():void {
			if (loadComplete)
			{
				if (soundChannel) {
					soundChannel.stop();
					soundChannel = null;
				}
				//trace("play:",position);
				soundChannel = soundPlayer.play(position);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCom);
			}
			else
				trace("还没加载完成！");
		}
		
		private function soundCom(e:Event):void 
		{
			position = 0;
		}
		
		public function pause():void {
			position = soundChannel.position;
			//trace("pause:", position);
			soundChannel.stop();
		}
		
		public function stopSound():void {
			if (soundChannel) {
				soundChannel.stop();
				position = 0;
			}
		}
		
		public function volume(num:Number):void {
			if (soundChannel) {
				var transform:SoundTransform = new SoundTransform();
				transform.volume = num;
				soundChannel.soundTransform = transform;
			}
		}
	}

}
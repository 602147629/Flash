package src.compoment 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	
	/**单选组
	 * ...
	 * @author Mu
	 */
	public class RadioGroup extends Sprite 
	{
		
		private var groupData:Array = [];
		
		private var _selectedIndex:Number = 0;
		private var changHand:Function;//改变函数
		public function RadioGroup(changFuns:Function = null) 
		{
			super();
			changHand = changFuns;
		}
		/**
		 * 添加到组
		 * @param	radio
		 */
		public function addToGroup(radio:RadioButton):void {
			if (groupData.indexOf(radio) == -1) {
				radio.index = groupData.length;
				groupData.push(radio);
				radio.addEventListener(Event.CHANGE, changHands);
			}
		}
		
		private function changHands(e:Event):void {
			SoundManager.instance.playSound(SoundList.SOUND_RADIO);
			var radio:RadioButton = e.currentTarget as RadioButton;
			unSelectedAll();
			radio.selected = true;
			selectedIndex = radio.index;
			if (changHand!=null) {
				changHand(selectedIndex);
			}
		}
		
		private function unSelectedAll():void {
			for (var i:int = 0; i < groupData.length; i++) {
				var radio:RadioButton = groupData[i];
				radio.selected = false;
			}
		}
		
		public function get selectedIndex():Number {
			return _selectedIndex;
		}
		public function set selectedIndex(val:Number):void {
			_selectedIndex = val;
			unSelectedAll();
			groupData[val].selected = true;
		}
		
		
	}

}
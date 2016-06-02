/**Created by the Morn,do not modify.*/
package game.ui.templateView {
	import morn.core.components.*;
	public class ControllerViewUI extends View {
		public var line:Image = null;
		public var flag_line:Image = null;
		public var btn_stop:Button = null;
		public var btn_pre:Button = null;
		public var bar:Button = null;
		public var btn_play:Button = null;
		public var btn_pause:Button = null;
		public var btn_next:Button = null;
		public var animate_label:Label = null;
		public var sound_label:Label = null;
		public var btn_soundOpen:Button = null;
		public var btn_mute:Button = null;
		public var sound_line:Image = null;
		public var sound_flagline:Image = null;
		public var soundbar:Button = null;
		public var close:Button = null;
		protected static var uiView:XML =
			<View width="1024" height="60">
			  <Image skin="png.template.animate_controller.img_controllerBg" x="21" y="5"/>
			  <Image skin="png.template.animate_controller.img_cicleBg" x="60" y="9"/>
			  <Image skin="png.template.animate_controller.img_cicleBg" x="748" y="8"/>
			  <Image skin="png.template.animate_controller.img_controllerLine" x="194" y="20" var="line"/>
			  <Image skin="png.template.animate_controller.img_line" x="195" y="27" var="flag_line"/>
			  <Button skin="png.template.animate_controller.btn_stop" x="110" y="23" var="btn_stop"/>
			  <Button skin="png.template.animate_controller.btn_pre" x="35" y="24" var="btn_pre"/>
			  <Button skin="png.template.animate_controller.btn_point" x="194" y="20" var="bar"/>
			  <Button skin="png.template.animate_controller.btn_play" x="75" y="21" var="btn_play"/>
			  <Button skin="png.template.animate_controller.btn_pause" x="73" y="22" width="16" height="16" var="btn_pause"/>
			  <Button skin="png.template.animate_controller.btn_next" x="135" y="25" var="btn_next"/>
			  <Label text="100%" x="706" y="22" color="0xffffff" var="animate_label"/>
			  <Label text="100%" x="919" y="21" color="0xffffff" var="sound_label"/>
			  <Button skin="png.template.animate_controller.btn_soundOpen" x="758" y="20" var="btn_soundOpen"/>
			  <Button skin="png.template.animate_controller.btn_sound_mute" x="761" y="20" var="btn_mute"/>
			  <Image skin="png.template.animate_controller.img_controllerLine" x="807" y="21" width="100" var="sound_line"/>
			  <Image skin="png.template.animate_controller.img_line" x="808" y="28" var="sound_flagline"/>
			  <Button skin="png.template.animate_controller.btn_point" x="805" y="22" var="soundbar"/>
			  <Button skin="png.template.animate_controller.btn_close" x="982" y="22" var="close"/>
			</View>;
		public function ControllerViewUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}
/**Created by the Morn,do not modify.*/
package template.animate.view {
	import morn.core.components.*;
	public class ControllerLineUI extends View {
		public var line:Image = null;
		public var flag_line:Image = null;
		public var close:Button = null;
		public var btn_next:Button = null;
		public var animate_label:Label = null;
		public var sound_line:Image = null;
		public var sound_flagline:Image = null;
		public var soundbar:Button = null;
		public var sound_label:Label = null;
		public var btn_pause:Button = null;
		public var btn_play:Button = null;
		public var bar:Button = null;
		public var btn_pre:Button = null;
		public var btn_soundOpen:Button = null;
		public var btn_mute:Button = null;
		public var btn_stop:Button = null;
		protected static var uiView:XML =
			<View width="1024" height="100">
			  <Image skin="png.template.img_controllerBg" x="20" y="25"/>
			  <Image skin="png.template.img_controllerLine" x="152" y="40" var="line"/>
			  <Image skin="png.template.img_line" x="152" y="49" height="2" var="flag_line"/>
			  <Button skin="png.template.btn_close" x="981" y="42" var="close"/>
			  <Button skin="png.template.btn_next" x="126" y="46" var="btn_next"/>
			  <Image skin="png.template.img_cicleBg" x="59" y="28"/>
			  <Image skin="png.template.img_cicleBg" x="747" y="28"/>
			  <Label text="100%" x="669" y="37" color="0xffffff" size="18" var="animate_label"/>
			  <Image skin="png.template.img_controllerLine" x="807" y="41" width="100" var="sound_line"/>
			  <Image skin="png.template.img_line" x="810" y="50" height="2" var="sound_flagline"/>
			  <Button skin="png.template.btn_point" x="805" y="40" width="20" height="20" sizeGrid="3,3,3,3" var="soundbar"/>
			  <Label text="100%" x="916" y="38" color="0xffffff" size="18" var="sound_label"/>
			  <Button skin="png.template.btn_pause" x="72" y="41" var="btn_pause"/>
			  <Button skin="png.template.btn_play" x="74" y="40" var="btn_play"/>
			  <Button skin="png.template.btn_point" x="148" y="40" sizeGrid="2,2,2,2" width="20" height="20" var="bar"/>
			  <Button skin="png.template.btn_pre" x="33" y="45" var="btn_pre"/>
			  <Button skin="png.template.btn_soundOpen" x="757" y="40" var="btn_soundOpen"/>
			  <Button skin="png.template.btn_sound_mute" x="758" y="40" var="btn_mute" width="11" height="18"/>
			  <Button skin="png.template.btn_stop" x="106" y="44" var="btn_stop"/>
			</View>;
		public function ControllerLineUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}
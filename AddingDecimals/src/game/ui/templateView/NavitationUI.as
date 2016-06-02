/**Created by the Morn,do not modify.*/
package game.ui.templateView {
	import morn.core.components.*;
	public class NavitationUI extends View {
		public var img_titleBg:Image = null;
		public var btn_showMenu:Button = null;
		public var btn_showBg:Button = null;
		public var btn_tool:Button = null;
		public var label_titleName:Label = null;
		protected static var uiView:XML =
			<View width="1024" height="100">
			  <Image skin="png.template.nagivation.title_bg" x="0" y="0" sizeGrid="2,2,2,2" width="1024" height="40" var="img_titleBg"/>
			  <Button skin="png.template.nagivation.btn_MenuShow" x="912" y="6" var="btn_showMenu"/>
			  <Button skin="png.template.nagivation.btn_titleShow" x="949" y="6" var="btn_showBg"/>
			  <Button skin="png.template.nagivation.btn_ToolShow" x="986" y="6" var="btn_tool"/>
			  <Label text="的弗拉的减肥爱的煎熬鹿鼎记" x="24" y="7" size="18" var="label_titleName"/>
			</View>;
		public function NavitationUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}
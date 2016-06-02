/**Created by the Morn,do not modify.*/
package game.ui.self {
	import morn.core.components.*;
	public class FormulaUI extends View {
		public var num1:Label = null;
		public var num2:Label = null;
		public var add:Label = null;
		public var line:Image = null;
		public var sum:Label = null;
		protected static var uiView:XML =
			<View width="600" height="400">
			  <Label text="0" x="80" y="45" font="微软雅黑" size="26" var="num1" letterSpacing="10" align="right" autoSize="right"/>
			  <Label text="0" x="80" y="77" font="微软雅黑" size="26" var="num2" letterSpacing="10" align="right" autoSize="right"/>
			  <Label text="+" x="25" y="77" font="微软雅黑" size="26" var="add" bold="true"/>
			  <Image skin="png.self.hline" x="33" y="113" width="150" height="5" var="line"/>
			  <Label text="0" x="80" y="121" font="微软雅黑" size="26" var="sum" letterSpacing="10" autoSize="right"/>
			</View>;
		public function FormulaUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}
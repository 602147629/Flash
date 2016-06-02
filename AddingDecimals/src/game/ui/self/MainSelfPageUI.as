/**Created by the Morn,do not modify.*/
package game.ui.self {
	import morn.core.components.*;
	public class MainSelfPageUI extends View {
		public var sortBtn:Button = null;
		public var clearBtn:Button = null;
		public var checkBox:ComboBox = null;
		public var numberBox:CheckBox = null;
		public var showAddends:CheckBox = null;
		public var showSum:CheckBox = null;
		public var modelGroup:RadioGroup = null;
		public var baiLabel:Label = null;
		public var shiLabel:Label = null;
		public var geLabel:Label = null;
		protected static var uiView:XML =
			<View width="1024" height="720">
			  <Image skin="png.self.topL" x="20" y="50" sizeGrid="9,9,9,9" width="756" height="151"/>
			  <Image skin="png.self.vline" x="20" y="201" width="1" height="501"/>
			  <Image skin="png.self.vline" x="774" y="201" width="1" height="501"/>
			  <Button skin="png.self.button" x="800" y="661" var="sortBtn" label="排序" labelFont="微软雅黑" labelSize="18"/>
			  <Button label="清除" skin="png.self.button" x="903" y="661" var="clearBtn" labelFont="微软雅黑" labelSize="18"/>
			  <ComboBox labels="100，10，1,10，1，0.1,1，0.1，0.01,0.1，0.01，0.001" skin="png.self.combobox" x="800" y="100" var="checkBox" selectedIndex="0" labelSize="18" labelFont="微软雅黑"/>
			  <Image skin="png.self.hline" x="20" y="451" width="754"/>
			  <Image skin="png.self.hline" x="20" y="701" width="754"/>
			  <Image skin="png.self.xline" x="272" y="202" height="500"/>
			  <Image skin="png.self.xline" x="523" y="202" height="500"/>
			  <CheckBox label="显示方块的数量" skin="png.self.checkbox" x="800" y="164" labelSize="18" labelFont="微软雅黑" var="numberBox"/>
			  <CheckBox label="显示加数" skin="png.self.checkbox" x="800" y="372" labelSize="18" labelFont="微软雅黑" var="showAddends"/>
			  <CheckBox label="显示和" skin="png.self.checkbox" x="830" y="416" labelFont="微软雅黑" labelSize="18" var="showSum"/>
			  <Label text="设置方块的值" x="801" y="65" size="18" font="微软雅黑"/>
			  <RadioGroup labels="加数模式,和模式" skin="png.self.radio" x="808" y="252" labelSize="18" direction="vertical" space="10" selectedIndex="0" var="modelGroup"/>
			  <Label text="label" x="201" y="115" font="微软雅黑" size="18" var="baiLabel"/>
			  <Label text="label" x="425" y="115" font="微软雅黑" size="18" var="shiLabel"/>
			  <Label text="label" x="613" y="115" font="微软雅黑" size="18" var="geLabel"/>
			</View>;
		public function MainSelfPageUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}
/**Created by the Morn,do not modify.*/
package game.ui.templateView {
	import morn.core.components.*;
	public class CanvasTollsUI extends View {
		public var bg:Image = null;
		public var flag_block:Image = null;
		public var btn_cancel:Button = null;
		public var btn_pencil:Button = null;
		public var btn_line:Button = null;
		public var btn_dotline:Button = null;
		public var btn_arrow:Button = null;
		public var btn_rectangle:Button = null;
		public var btn_circle:Button = null;
		public var btn_polygon:Button = null;
		public var btn_edgeNumPre:Button = null;
		public var btn_edgeNumNext:Button = null;
		public var btn_lineThickPre:Button = null;
		public var btn_lineThickNext:Button = null;
		public var img_lineColor:Image = null;
		public var btn_isFill:CheckBox = null;
		public var img_fillColor:Image = null;
		public var btn_eyeclose:Button = null;
		public var btn_eyeopen:Button = null;
		public var btn_restore:Button = null;
		public var btn_delete:Button = null;
		public var btn_help:Button = null;
		public var label_edgeNum:Label = null;
		public var label_lineThick:Label = null;
		protected static var uiView:XML =
			<View width="1024" height="100">
			  <Image skin="png.template.canvas.img_bg" x="0" y="0" width="1024" sizeGrid="3,3,3,3" height="40" var="bg"/>
			  <Image skin="png.template.canvas.img_block" x="8" y="4" var="flag_block"/>
			  <Button skin="png.template.canvas.btn_cancel" x="844" y="6" var="btn_cancel"/>
			  <Button skin="png.template.canvas.btn_pencil" x="45" y="6" var="btn_pencil"/>
			  <Button skin="png.template.canvas.btn_line" x="99" y="6" var="btn_line"/>
			  <Button skin="png.template.canvas.btn_dotline" x="140" y="6" var="btn_dotline"/>
			  <Button skin="png.template.canvas.btn_arrow" x="9" y="6" var="btn_arrow"/>
			  <Image skin="png.template.canvas.img_cutline" x="84" y="9"/>
			  <Image skin="png.template.canvas.img_cutline" x="182" y="9"/>
			  <Button skin="png.template.canvas.btn_rectangle" x="194" y="6" var="btn_rectangle"/>
			  <Button skin="png.template.canvas.btn_circle" x="236" y="6" var="btn_circle"/>
			  <Image skin="png.template.canvas.img_cutline" x="272" y="9"/>
			  <Button skin="png.template.canvas.btn_polygon" x="283" y="6" var="btn_polygon"/>
			  <Label text="边数" x="316" y="7" color="0x999999" size="18"/>
			  <Button skin="png.template.canvas.btn_left" x="353" y="6" var="btn_edgeNumPre"/>
			  <Button skin="png.template.canvas.btn_right" x="427" y="6" var="btn_edgeNumNext"/>
			  <Label text="线粗" x="471" y="6" color="0x999999" size="18"/>
			  <Button skin="png.template.canvas.btn_left" x="506" y="6" var="btn_lineThickPre"/>
			  <Button skin="png.template.canvas.btn_right" x="578" y="7" var="btn_lineThickNext"/>
			  <Image skin="png.template.canvas.img_cutline" x="462" y="9"/>
			  <Image skin="png.template.canvas.色块" x="609" y="8" var="img_lineColor"/>
			  <Label text="线色" x="632" y="7" color="0x999999" size="18"/>
			  <CheckBox skin="png.comp.checkbox" x="685" y="12" var="btn_isFill"/>
			  <Label text="填充" x="700" y="6" color="0x999999" size="18"/>
			  <Image skin="png.template.canvas.色块" x="748" y="7" var="img_fillColor"/>
			  <Label text="填充色" x="772" y="6" color="0x999999" size="18"/>
			  <Image skin="png.template.canvas.img_cutline" x="834" y="9"/>
			  <Button skin="png.template.canvas.btn_eyeclose" x="915" y="10" var="btn_eyeclose"/>
			  <Button skin="png.template.canvas.btn_eyeopen" x="916" y="12" var="btn_eyeopen"/>
			  <Button skin="png.template.canvas.btn_restore" x="880" y="6" var="btn_restore"/>
			  <Button skin="png.template.canvas.btn_delete" x="959" y="5" var="btn_delete"/>
			  <Button skin="png.template.canvas.btn_help" x="989" y="6" var="btn_help"/>
			  <Image skin="png.template.canvas.img_input" x="379" y="9" sizeGrid="3,3,3,3" width="48" height="22"/>
			  <Image skin="png.template.canvas.img_input" x="531" y="9" sizeGrid="3,3,3,3" width="48" height="22"/>
			  <Label text="123" x="384" y="7" color="0x999999" size="18" var="label_edgeNum"/>
			  <Label text="123" x="536" y="8" color="0x999999" size="18" var="label_lineThick"/>
			</View>;
		public function CanvasTollsUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}
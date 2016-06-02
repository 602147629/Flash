package template.navigation 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import game.ui.templateView.NavitationUI;
	
	/**导航
	 * ...
	 * @author Mu
	 */
	public class NavigationController extends NavitationUI 
	{
		private var subject_block:Sprite;
		
		private var menuHand:Function = null;
		private var bgHand:Function = null;
		private var toolHand:Function = null;
		public function NavigationController() 
		{
			init();
		}
		private function init():void {
			subject_block = new Sprite();
			addChild(subject_block);
			
			addEvent();
			
			/////临时设定
			btn_tool.visible = false;
			btn_showMenu.x = 929;
			btn_showBg.x = 968;
		}
		////绘制学科颜色
		private function drawBlock(color:uint):void {	
			with (subject_block.graphics) {
				clear();
				beginFill(color);
				drawRect(0, 0, 10, 40);
				endFill();
			}
		}
		
		private function addEvent():void {
			btn_showMenu.addEventListener(MouseEvent.MOUSE_DOWN, showMenuHand);
			btn_showBg.addEventListener(MouseEvent.MOUSE_DOWN, showBgHand);
			btn_tool.addEventListener(MouseEvent.MOUSE_DOWN, showToolHand);
		}
		
		private function showMenuHand(e:MouseEvent):void 
		{
			menuHand();
		}
		
		private function showBgHand(e:MouseEvent):void 
		{
			bgHand();
		}
		
		private function showToolHand(e:MouseEvent):void 
		{
			toolHand();
		}
		
		//根据学科名 获取当前的点缀颜色
		private	function getColor(names: String): uint {
			var color: uint = 0x000000;
			switch (names) {
				case "语文":
					color = 0x009999;
					break;
				case "数学":
					color = 0x637987;
					break;
				case "英语":
					color = 0xCB3398;
					break;
				case "物理":
					color = 0x0099FF;
					break;
				case "化学":
					color = 0x24B5E4;
					break;
				case "生物":
					color = 0x009900;
					break;
				case "历史":
					color = 0xCC6600;
					break;
				case "地理":
					color = 0xFF6600;
					break;
				case "政治":
					color = 0xD30102;
					break;
			}
			
			return color;
		}
		/**
		 * 设置数据
		 */
		public function set datas(data:Dictionary):void {
			var obj:Object = data["data"];
			
			label_titleName.text = obj.title;
			drawBlock(getColor(obj.subject));
			this.setPosition(obj.x, obj.y);
			this.setSize(obj.w, obj.h);
			
			menuHand = obj.menuHand;
			bgHand  = obj.bgHand;
			toolHand = obj.toolHand;
		}
		
		////显示背景
		private var _showBg:Boolean = true;
		public function set showBg(boo:Boolean):void {
			_showBg = boo;
			img_titleBg.visible = boo;
			subject_block.visible = boo;
			label_titleName.visible = boo;
		}
		public function get showBg():Boolean {
			return _showBg;
		}
		
		////是否显示菜单按钮
		public function set menuBtnVisible(value:Boolean):void {
			btn_showMenu.visible = value;
		}
	}

}
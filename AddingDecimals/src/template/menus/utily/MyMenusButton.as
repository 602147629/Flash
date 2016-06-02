package template.menus.utily 
{
	import flash.display.Sprite;
	import morn.core.components.Button;
	
	/**自定义菜单按钮
	 * ...
	 * @author Mu
	 */
	public class MyMenusButton extends Button 
	{
		public static const MENU_FLAG_MAIN:String = "MENU_FLAG_MAIN";////主按钮
		public static const MENU_FLAG_SUB:String = "MENU_FLAG_SUN";////子按钮
		
		private var _flag:String;
		/**
		 * 设置菜单标签
		 */
		public function get flag():String {
			return _flag;
		}
		public function set flag(value:String):void {
			_flag = value;
		}
		
		/**
		 * 构造函数
		 * @param	skin  皮肤
		 * @param	label 标签
		 */
		public function MyMenusButton(skin:String=null, label:String="") 
		{
			super(skin, label);
			if (skin) {
				this.sizeGrid = "4,4,4,4";
			}
			this.labelSize = 16;
			this.label = label;
			
			
		}
		override public function get label():String 
		{
			return super.label;
		}
		/**
		 * 重写父类方法  让自身宽度随文本而变
		 */
		override public function set label(value:String):void 
		{
			super.label = value;
			this.width = _btnLabel.width;
			defaultWidth = this.width;
			_btnLabel.align = "left";
		}
		
		/////子菜单
		private var _subarr:Array=[];
		public function set subarr(arr:Array):void {
			_subarr = arr;
		}
		public function get subarr():Array {
			return _subarr;
		}
		
		////父菜单
		private var _father:Sprite;
		public function get father():Sprite {
			return _father;
		}
		public function set father(value:Sprite):void {
			_father = value;
		}
		
		/***tab 标签**/
		private var _tab:String;
		public function get tab():String {
			return _tab;
		}
		public function set tab(value:String):void {
			_tab = value;
		}
		
		/**默认宽度**/
		private var _defaultWidth:Number=0;
		public function set defaultWidth(value:Number):void {
			_defaultWidth = value;
		}
		public function get defaultWidth():Number {
			return _defaultWidth;
		}
	}

}
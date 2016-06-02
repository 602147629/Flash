package template
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import iflash.method.bind;
	import template.animate.AnimateControllerManager;
	import template.canvas.CanvasTolls;
	import template.menus.MenusController;
	import template.navigation.NavigationController;
	
	/**模板主类
	 * ...
	 * @author Mu
	 */
	public class Template extends Sprite
	{
		private var navigation:NavigationController;
		private var menu:MenusController;
		private var canvas:CanvasTolls;
		private var animate:AnimateControllerManager;
		private var _this:Object = this;
		
		private static var _instance:Template = new Template();
		
		public function Template()
		{
			if (_instance)
			{
				throw new Error("单利");
			}
		}
		
		public static function get instance():Template
		{
			return _instance;
		}
		
		public function init():void
		{
			navigation = new NavigationController();
			menu = new MenusController();
			canvas = new CanvasTolls();
			
			addChild(menu);
			//addChild(canvas);
			addChild(navigation);
		}
		
		/**
		 * 设置数据
		 */
		public function set dataSource(data:Dictionary):void
		{
			var naviData:Object = data["navigation"];
			var menuData:Object = data["menu"];
			var canvasData:Object = data["canvas"];
			
			menu.dataSource(menuData.data, bind(this,menuData.handler));
			menu.setPosition(menuData.x, menuData.y);
			canvas.setPosition(canvasData.x, canvasData.y);
			
			canvas.visible = false;
			naviData.data["data"]["menuHand"] = bind(this, menuHand);
			naviData.data["data"]["bgHand"] = bind(this, bgHand);
			naviData.data["data"]["toolHand"] = bind(this, toolHand);
			navigation.datas = naviData.data;
		}
		
		
		/**
		 * 菜单是否显示
		 * @param	boo
		 */
		public function set menuShow(boo:Boolean):void {
			menu.visible = boo;
			navigation.menuBtnVisible = boo;
		}
		
		/**
		 * 动画控制
		 */
		public function Animate(an:MovieClip=null,autoPlay:Boolean = false,canDrag:Boolean = true,isLoop:Boolean= false):void
		{
			if (an)
			{
				AnimateControllerManager.instance.controlls(an, this,autoPlay,canDrag,isLoop);
				AnimateControllerManager.instance.setPosition(0, 650);
			}
			else
			{
				if (AnimateControllerManager.instance.isHave)
				{
					AnimateControllerManager.instance.destory();
				}
			}
		}
		/**
		 * 获取动画的播放状态
		 */
		public function get animateIsPlaying():Boolean {
			return AnimateControllerManager.instance.isPlaying;
		}
		/**
		 * 动画是否播放完成
		 */
		public function get animateIsComplete():Boolean {
			return AnimateControllerManager.instance.isPlayComplete;
		}
		/**
		 * 菜单默认选择项
		 * @param	flag
		 */
		public function defaultSelceMenuCell(flag:String):void {
			menu.setSelectByTab(flag);
		}
		
		private function menuHand():void
		{
			menu.visible = !menu.visible;
			setMenuPosition(navigation.showBg);
		}
		
		private function bgHand():void
		{
			navigation.showBg = !navigation.showBg;
			setMenuPosition(navigation.showBg);
		}
		
		private function toolHand():void
		{
			canvas.visible = !canvas.visible;
		}
		
		private function setMenuPosition(bgshow:Boolean):void
		{
			if (bgshow)
			{
				menu.setPosition(0, 40);
			}
			else
			{
				menu.setPosition(0, 0);
			}
		}
	}

}
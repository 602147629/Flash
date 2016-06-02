package template.menus
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import morn.core.components.Image;
	import template.Global;
	import template.menus.events.MenuClickEvent;
	import template.menus.utily.MyMenusButton;
	import template.utily.EventBridge;
	
	/**菜单管理器
	 * ...
	 * @author Mu  datasource = {"main":"aaaaa","sub":"a#b#c","skinurl":"png.comp.button", "showLabel":false};
	 */
	public class MenusController extends Sprite
	{
		//private static var _instance:MenusController = new MenusController();
		public function MenusController()
		{
			//if (_instance) {
			//throw new Error("单利！");
			//}else {
			init();
			//}
		}
		//获取此类的唯一实例
		//public static function get instance():MenusController {
		//return _instance;
		//}
		
		private var _bg:Image;
		
		////初始化
		private function init():void
		{
			_bg = new Image("png.template.canvas.img_bg");
			_bg.sizeGrid = "2,2,2,2";
			_bg.setSize(1024, 40);
			addChild(_bg);
			
			addEvent();
		}
		
		/**
		 * 获取背景
		 */
		public function get bg():Image
		{
			return _bg;
		}
		
		////事件
		private function addEvent():void
		{
			App.stage.addEventListener(MouseEvent.MOUSE_DOWN, stageDwonHand);
		}
		
		private function stageDwonHand(e:MouseEvent):void
		{
			if (!(e.target is MyMenusButton)) {
				hideSubMenu();
			}
		}
		
		private var menuArr:Array = []; //菜单按钮集合
		private var mainMenuArr:Array = []; //主菜单数组
		private var subMenuArr:Array = []; //子菜单数组
		private var _dataSource:Dictionary; //数据集合
		
		private var menuHand:Function = null;
		
		/**
		 * 设置数据
		 */
		public function dataSource(data:Dictionary, handlder:Function):void
		{
			menuHand = handlder;
			parseData(data);
		}
		
		public function setPosition(xx:Number, yy:Number):void
		{
			this.x = xx;
			this.y = yy;
		}
		
		////解析数据
		private function parseData(data:Dictionary):void
		{
			var menuBtn:MyMenusButton;
			var menuSubBtn:MyMenusButton;
			var startX:Number = 0;
			for each (var obj:Object in data)
			{
				var sub:String = obj.sub;
				menuBtn = new MyMenusButton(obj.mainSkin, obj.main);
				menuBtn.flag = MyMenusButton.MENU_FLAG_MAIN;
				menuBtn.x = startX;
				addChild(menuBtn);
				startX += menuBtn.width + 1;
				mainMenuArr.push(menuBtn);
				menuBtn.addEventListener(MouseEvent.CLICK, menuDwonHand);
				
				if (!sub)
					continue;
				var sub_arr:Array = sub.split("#");
				var skin_arr:Array = obj.subSkin.split("#");
				var sub_con:String;
				for (var i:int = 0; i < sub_arr.length; i++)
				{
					sub_con = sub_arr[i];
					menuSubBtn = new MyMenusButton(skin_arr[i], sub_arr[i]);
					menuSubBtn.flag = MyMenusButton.MENU_FLAG_SUB;
					//menuSubBtn.x = menuBtn.x;
					//menuSubBtn.y = menuBtn.height + i * menuBtn.height + 1;
					menuSubBtn.father = menuBtn;
					menuSubBtn.addEventListener(MouseEvent.CLICK, menuDwonHand);
					addChild(menuSubBtn);
					subMenuArr.push(menuSubBtn);
					menuBtn.subarr.push(menuSubBtn);
				}
			}
			
			setMenuTab();
			setSubSize();
			
			setSelectByTab("1");
		}
		
		/////设置菜单tab
		private function setMenuTab():void
		{
			for (var i:int = 0; i < mainMenuArr.length; i++)
			{
				var main:MyMenusButton = mainMenuArr[i] as MyMenusButton;
				var sarr:Array = main.subarr;
				main.tab = i + 1 + "";
				if (sarr.length == 0)
					continue;
				for (var j:int = 0; j < sarr.length; j++)
				{
					var sub:MyMenusButton = sarr[j];
					sub.tab = main.tab + (j + 1);
				}
			}
		}
		
		/////设置子按钮尺寸  竖直方向
		private function setSubSize():void
		{
			//var startx:Number = 0;
			var w:Number = 0;
			for (var i:int = 0; i < mainMenuArr.length; i++)
			{
				var main:MyMenusButton = mainMenuArr[i];
				//main.x = startx;
				//startx += main.width +1;
				var arr:Array = main.subarr;
				if (arr.length == 0)
					continue;
				for (var j:int = 0; j < arr.length; j++)
				{
					var sub:MyMenusButton = arr[j] as MyMenusButton;
					w = Math.max(w, sub.width);
				}
				
				for (j = 0; j < arr.length; j++)
				{
					sub = arr[j];
					w = Math.max(w, main.width);
					
					sub.width = w;
					sub.x = main.x;
					sub.y = main.height + j * main.height + 1;
					
						//TweenMax.to(sub, 0.5, {width:w,x:main.x,y:main.height + j * main.height + 1});
				}
			}
		}
		
		/////设置子按钮尺寸  水平方向
		private function setSubSizeHorizontal():void
		{
			
			for (var i:int = 0; i < mainMenuArr.length; i++)
			{
				var main:MyMenusButton = mainMenuArr[i];
				;
				var arr:Array = main.subarr;
				if (arr.length == 0)
					continue;
				var startx:Number = main.x;
				for (var j:int = 0; j < arr.length; j++)
				{
					var sub:MyMenusButton = arr[j] as MyMenusButton;
					
					sub.width = sub.defaultWidth;
					sub.x = startx;
					sub.y = main.height + 1;
					startx += sub.width + 1;
						//TweenMax.to(sub, 0.5, {width:sub.defaultWidth, x:startx, y:main.height +1, onComplete:com } );
						//function com():void {
						//startx += sub.width + 1;
						//}
				}
			}
		}
		
		/////阴藏子按钮
		private function hideSubMenu():void
		{
			for (var i:int = 0; i < subMenuArr.length; i++)
			{
				var sub:MyMenusButton = subMenuArr[i];
				sub.visible = false;
			}
		}
		
		////菜单按钮事件
		///
		private function menuDwonHand(e:MouseEvent):void
		{
			//e.stopPropagation();
			e.stopImmediatePropagation();
			var menu:MyMenusButton = e.currentTarget as MyMenusButton;
			
			if (menu.subarr.length == 0 && menu.selected)
				return;
			menuHand(menu.tab);
			
			//var data:Object = { };
			//data.tab = menu.tab;
			//EventBridge.instance.dispatchEvent(new MenuClickEvent(MenuClickEvent.MENU_CLICK_EVENT,data));
			
			if (menu.flag == MyMenusButton.MENU_FLAG_MAIN)
			{
				mainMenuSelected(menu);
			}
			else if (menu.flag == MyMenusButton.MENU_FLAG_SUB)
			{
				subMenuSelected(menu);
			}
		}
		
		/////主按钮选择
		private function mainMenuSelected(menu:MyMenusButton):void
		{
			hideSubMenu();
			
			if (menu.subarr.length == 0)
			{
				cancelSelectAllMenu();
				menu.selected = true;
			}
			else
			{
				showMenuByArr(menu.subarr);
			}
		}
		
		/////子按钮选择
		private function subMenuSelected(menu:MyMenusButton):void
		{
			cancelSelectAllMenu();
			hideSubMenu();
			menu.selected = true;
			MyMenusButton(menu.father).selected = true;
		}
		
		//////根据数组显示菜单
		private function showMenuByArr(arr:Array):void
		{
			for (var i:int = 0; i < arr.length; i++)
			{
				var menu:MyMenusButton = arr[i] as MyMenusButton;
				menu.visible = true;
			}
		}
		
		////取消选择所有按钮
		private function cancelSelectAllMenu():void
		{
			for (var i:int = 0; i < mainMenuArr.length; i++)
			{
				var m:MyMenusButton = mainMenuArr[i];
				m.selected = false;
				if (m.subarr.length == 0)
					continue;
				for (var j:int = 0; j < m.subarr.length; j++)
				{
					var sub:MyMenusButton = m.subarr[j];
					sub.selected = false;
				}
			}
		}
		
		/**
		 * 设置坐标
		 */
		public function set position(p:Point):void
		{
			this.x = p.x;
			this.y = p.y;
		}
		
		/**
		 * 根据tab设置选定的按钮 主按钮 1 2 3 4.....子按钮 11 12 13 14....21 22 23 24..
		 * @param	tab
		 */
		public function setSelectByTab(tab:String = "1"):void
		{
			var totalArr:Array = mainMenuArr.concat(subMenuArr);
			for (var i:int = 0; i < totalArr.length; i++)
			{
				var menu:MyMenusButton = totalArr[i] as MyMenusButton;
				if (menu.tab == tab)
				{
					if (menu.flag == MyMenusButton.MENU_FLAG_MAIN)
					{
						mainMenuSelected(menu);
					}
					else if (menu.flag == MyMenusButton.MENU_FLAG_SUB)
					{
						subMenuSelected(menu);
					}
					menu.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					break;
				}
			}
		}
		
		public static const DIRECTION_HORIZAOTAL:String = "HORIZONTAL"; ////水平方向
		public static const DIRECTION_VERTICAL:String = "VERTICAL"; /////竖直方向
		
		/**
		 * 菜单排列方向DIRECTION_HORIZAOTAL  DIRECTION_VERTICAL
		 * @param	dir
		 */
		public function menuArrangeDirection(dir:String):void
		{
			if (dir == DIRECTION_HORIZAOTAL)
			{
				setSubSizeHorizontal();
			}
			else if (dir == DIRECTION_VERTICAL)
			{
				setSubSize();
			}
		}
	}
}
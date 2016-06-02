package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import iflash.method.bind;
	import morn.core.handlers.Handler;
	import self.Main_self;
	import template.Global;
	import template.Template;
	/**
	 * ...
	 * @author Mu
	 */
	[SWF(width=1024,height = 720,backgroundColor=0xffffff)]
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			IFlash.setBgcolor("#ffffff");
			IFlash.setSize(1024, 720);
			IFlash.showInfo(false);
			IFlash.preSwfAssets([]);
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			App.init(this);
			App.loader.loadAssets(["assets/comp.swf","assets/template.swf","assets/asset_self.swf","assets/self.swf"], new Handler(comHnader));
		}
		private function comHnader():void {
			//SoundManager.instance.preload([SoundProxy.HTYE_SOUND_URL], soundCom);
			ConfigureTemplate();
			CustomeContent();
		}
		
		private function soundCom():void
		{
			ConfigureTemplate();
			CustomeContent();
		}
		
		/***
		 * 配置模板数据
	     **/
		private function ConfigureTemplate():void {
			stage.frameRate = 30;
			addChild(Global.contentContainer);
			addChild(Global.templateContainer);
			
			Template.instance.init();
			Global.templateContainer.addChild(Template.instance);
			
			/////Bux 形变动画 不支持
			//var an:MovieClip = SkinManager.instance.getObjectByName("sanxia") as MovieClip;
			//Global.contentContainer.addChild(an);

			///菜单数据
			var data1:Dictionary = new Dictionary();	
			data1[0] = 
			{ 
				"main":"交流发电机原理",
				"mainSkin":"png.template.menu.btn_menu",
				"sub":"", 
				"subSkin":""
			};
			data1[1] = 
			{
				"main":"立体图与剖视图",
				"mainSkin":"png.template.menu.btn_menu",
				"sub":"",
				"subSkin":""
			};
			data1[2] = 
			{
				"main":"变化规律",
				"mainSkin":"png.template.menu.btn_menu",
				"sub":"",
				"subSkin":""
			};
			
			///导航数据
			var dic:Dictionary = new Dictionary();
			dic["data"] = 
			{
				"x":0,
				"y":0,
				"w":1024,
				"h":40,
				"subject":"数学",
				"title":"AddingDecimals"
			};
			///模板数据
			var data:Dictionary = new Dictionary();	
			data["navigation"] = 
			{
				"data":dic
			};
			data["menu"] =
			{
				"data":data1,
				"handler":bind(this,menuHand),
				"x":0,
				"y":40
			};
			data["canvas"] =
			{
				"x":0,
				"y":40
			};
			
			Template.instance.dataSource = data;
			
			///////动画控制器
			//Template.instance.Animate(an,false,false,false);
			///设置是否需要显示菜单
			Template.instance.menuShow = false;
			///菜单选择
			function menuHand(tab:String):void {
				////不持支多个case
				if (tab == "1") {
					
				}else if (tab == "2") {
					
				}else if (tab == "3") {
					
				}
			}
			
			//这种控制多个动画，或者动画伴随声音的 需要这么写
			//var isplay:Boolean;
			//var s:SoundCell = SoundManager.instance.getSound(SoundProxy.HTYE_SOUND_URL);
			//addEventListener(Event.ENTER_FRAME, enterHand);
			//function enterHand(e:Event):void {
				//if (Template.instance.animateIsPlaying && isplay == false ) {
					//s.play();
					//isplay = true;
				//}else if(Template.instance.animateIsPlaying== false && isplay){
					//s.pause();
					//isplay = false;
				//}
				//
				//if (Template.instance.animateIsComplete) {
					//s.stopSound();
					//isplay = false;
				//}
			//}
		}
		
		/**
		 * 自定义内容
		 */
		private function CustomeContent():void {
			var mainSelf:Main_self = new Main_self();
			Global.contentContainer.addChild(mainSelf);	
		}
	}
	
}
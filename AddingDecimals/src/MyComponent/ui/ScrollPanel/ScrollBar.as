package MyComponent.ui.ScrollPanel
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import MyComponent.ui.SkinManager;
	import MyComponent.ui.button.Button;
	import MyComponent.ui.mo.SButton;
	import MyComponent.ui.mo.UISkin;
	
	import total.Total;

	public class ScrollBar extends Sprite
	{
		//目标影片
		private var targetMc: Sprite;
		//需要显示的高度
		private var showHeight: Number=0;
		//控制影片的总高度
		private var totalHeight: Number=0;
		
		private var line:UISkin;
		private var bar:Button
		public function ScrollBar()
		{
			super();
			line= new UISkin(SkinManager.instance.getBitmapDataByName("line"),new Rectangle(2,2,2,2));
			addChild(line);
			
			var skin:SButton = new SButton();
			skin.upSkin = new UISkin(SkinManager.instance.getBitmapDataByName("barup"),new Rectangle(2,2,2,2));
			skin.overSkin = new UISkin(SkinManager.instance.getBitmapDataByName("barup"),new Rectangle(2,2,2,2));
			skin.downSkin = new UISkin(SkinManager.instance.getBitmapDataByName("bardown"),new Rectangle(2,2,2,2));
			
			bar = new Button("",null,120,skin);
//			bar.graphics.beginFill(0xff0000);
//			bar.graphics.drawRect(0,0,bar.width,bar.height);
//			bar.graphics.endFill();
			addChild(bar);
			
			this.visible = false;
		}
		
		///开始函数
		public function startH(target:Sprite,sw:Number,sh:Number): void {
			this.visible = true;
			targetMc = target;
			bar.setSize(sw,bar.height);
			line.setSize(sw,sh);
			bar.x = (line.width-bar.width)/2;
			bar.y = 0;
			totalHeight = targetMc.height;
			showHeight = sh;
			if (targetMc) {
				if (totalHeight > showHeight) {
					this.visible = true;
					setBarHeight();
				} else {
					this.visible = false;
				}
			}
		}
		
		private function setBarHeight(): void {
			bar.setSize(bar.width,showHeight / totalHeight * line.height);
			
			targetMc.scrollRect = new Rectangle(0, 0, targetMc.width+20, line.height);
			
			bar.addEventListener(MouseEvent.MOUSE_DOWN, downHand);
			bar.addEventListener(MouseEvent.MOUSE_UP, upHand);
			Total.instance.stageObject.addEventListener(MouseEvent.MOUSE_UP, upHand);
		}
		
		private function downHand(e: MouseEvent): void {
			var r: Rectangle = new Rectangle(0, 0, 0, line.height - bar.height);
			bar.startDrag(false, r);
			Total.instance.stageObject.addEventListener(MouseEvent.MOUSE_MOVE, moveHand);
		}
		
		private function upHand(e: MouseEvent): void {
			try {
				bar.stopDrag();
				Total.instance.stageObject.removeEventListener(MouseEvent.MOUSE_MOVE, moveHand);
			} catch (e: Error) {};
		}
		
		private function moveHand(e: MouseEvent): void {
			var num: Number = bar.y / (line.height - bar.height);
			targetMc.scrollRect = new Rectangle(0, (totalHeight - showHeight) * num, targetMc.width+20, line.height);
		}
	}
}
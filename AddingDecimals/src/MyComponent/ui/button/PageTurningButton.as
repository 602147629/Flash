package MyComponent.ui.button
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import MyComponent.ui.SkinManager;
	import MyComponent.ui.mo.SButton;
	import MyComponent.ui.mo.UISkin;
	
	public class PageTurningButton extends Sprite
	{
		private var contentS:TextField;
		
		private var targetMc:MovieClip;
		private var format:TextFormat = TextFormatLib.white_14px;
		
		private var countNum:Number = 1;
		private var minFrame:Number = 1;
		private var maxFrame:Number = 1;
		
		private var rightB:Button;
		private var leftB:Button;
		public function PageTurningButton(mc:MovieClip)
		{
			var skin:SButton = new SButton();
			skin.upSkin = new UISkin(SkinManager.instance.getBitmapDataByName("page_button_on"),new Rectangle(2,2,2,2));
			skin.overSkin = new UISkin(SkinManager.instance.getBitmapDataByName("page_button_over"),new Rectangle(2,2,2,2));
			skin.downSkin = new UISkin(SkinManager.instance.getBitmapDataByName("page_button_down"),new Rectangle(2,2,2,2));
			
			var bg:UISkin = new UISkin(SkinManager.instance.getBitmapDataByName("page_bg"),new Rectangle(2,2,2,2));
			addChild(bg);
			
			rightB= new Button("",null,0,skin,rightH);
			rightB.x = 84;
			rightB.y = 5;
			addChild(rightB);
			
			leftB= new Button("",null,0,skin,leftH);
			leftB.scaleX = -1;
			leftB.x = 25
			leftB.y = 5;
			addChild(leftB);
			
			contentS = new TextField();
			contentS.text = "aaaa";
			contentS.autoSize = "left";
			contentS.x = 30;
			contentS.setTextFormat(format);
			addChild(contentS);
			
			
			targetMc = mc;
			targetMc.stop();
			maxFrame = targetMc.totalFrames;
			setText(countNum);
			setTPostion();
			setEnabled(rightB,true);
			setEnabled(leftB,false);
		}
		
		private function rightH(data:*):void{
			countNum++;
			countNum = Math.min(countNum,maxFrame);
			if(countNum == maxFrame){
				setEnabled(rightB,false);
			}else{
				setEnabled(rightB,true);
			}
			setEnabled(leftB,true);
			setText(countNum);
		}
		private function leftH(data:*):void{
			countNum--;
			countNum = Math.max(countNum,minFrame);
			if(countNum == minFrame){
				setEnabled(leftB,false);
			}else{
				setEnabled(leftB,true);
			}
			setEnabled(rightB,true);
			setText(countNum);
		}
		
		private function setText(num:Number):void{
			contentS.text = num + "/" + maxFrame;
			contentS.setTextFormat(format);
			targetMc.gotoAndStop(num);
		}
		
		private function setTPostion():void{
			contentS.x = (this.width-contentS.width)/2;
			contentS.y = (this.height-contentS.height)/2;
		}
		
		/**
		 *设置交互对象是否是灰态
		 * @param mc
		 * @param boo
		 */
		private function setEnabled(mc: InteractiveObject, boo: Boolean): void {
			mc.mouseEnabled = boo;
			if (mc is DisplayObjectContainer) {
				DisplayObjectContainer(mc).mouseChildren = boo;
			}
			if (boo) {
				mc.alpha = 1;
				mc.filters = [];
			} else {
				var mat: Array = [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
				var colorMat: ColorMatrixFilter = new ColorMatrixFilter(mat);
				mc.filters = [colorMat];
				mc.alpha = 0.5;
			}
		}
	}
}
package src.self 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import src.compoment.CheckBox;
	import src.compoment.ComboBox;
	import src.compoment.NumericStepper;
	import src.compoment.RadioButton;
	import src.compoment.RadioGroup;
	import src.sound.SoundList;
	import src.sound.SoundManager;
	
	/**主界面
	 * ...
	 * @author Mu
	 */
	public class MainView extends Sprite 
	{
		//格子
		private var gridView:GridView;
		
		//一些组件
		private var radio_model:RadioButton;
		private var radio_draw:RadioButton;
		private var radio_pack:RadioButton;
		private var radioGroup:RadioGroup;
		private var comboxBox:ComboBox;
		private var numberBox:NumericStepper;
		private var autoDraw:CheckBox;
		private var showNumbers:CheckBox;
		private var showLabel:CheckBox;
		
		public function MainView() 
		{
			initView();
		}
		//初始化界面
		private function initView():void {
			gridView = new GridView();
			gridView.x = 350;
			gridView.y = 153;
			gridView.externalFun = updateT;
			addChild(gridView);
			this.setChildIndex(gridView, 2);
			
			this.setChildIndex(delb, this.numChildren - 1);
			
			radio_model = new RadioButton("设计模具");
			radio_model.x = 67;
			radio_model.y = 165;
			addChild(radio_model);
			
			radio_draw = new RadioButton("浇注巧克力");
			radio_draw.x = 67;
			radio_draw.y = 210;
			addChild(radio_draw);
			
			radio_pack = new RadioButton("包装");
			radio_pack.x = 67;
			radio_pack.y = 440;
			addChild(radio_pack);
			
			radioGroup = new RadioGroup(radioChangeHand);
			radioGroup.addToGroup(radio_model);
			radioGroup.addToGroup(radio_draw);
			radioGroup.addToGroup(radio_pack);
			radioGroup.selectedIndex = 0;
			
			numberBox = new NumericStepper(1, 1, 300,numberChangeHand);
			numberBox.x = 100;
			numberBox.y = 340;
			numberBox.scaleX = numberBox.scaleY = 0.8;
			addChild(numberBox);
			
			autoDraw = new CheckBox("自动浇注",autoFilterChange);
			autoDraw.x = 100;
			autoDraw.y = 389;
			addChild(autoDraw);
			
			showNumbers = new CheckBox("显示模具边长",showNumberChange);
			showNumbers.x = 67;
			showNumbers.y = 520;
			addChild(showNumbers);
			
			showLabel = new CheckBox("显示包装标签",showLabelChange);
			showLabel.x = 67;
			showLabel.y = 565;
			addChild(showLabel);
			
			comboxBox = new ComboBox(comboxHand);
			comboxBox.x = 100;
			comboxBox.y = 240;
			addChild(comboxBox);
			comboxBox.data = ["黑巧克力", "牛奶巧克力", "白巧克力"];
			
			delb.addEventListener(MouseEvent.CLICK, delHand);
			
			clearBtn.addEventListener(MouseEvent.CLICK, dclick);
			updateT("在设置模具模式下，点击格子拖拽，设计模具！");
		}
		
		private function dclick(e:MouseEvent):void 
		{
			gridView.delAll();
			updateT("在设置模具模式下，点击格子拖拽，设计模具！");
		}
		
		private function delHand(e:MouseEvent):void 
		{
			gridView.delBox();
		}
		//更新
		private function updateT(content:String):void {
			cont.text = content;
		}
		
		/**
		 * 添加事件
		 */
		private function addEvent():void {
			clearBtn.addEventListener(MouseEvent.CLICK, clearHand);
		}
		
		//清除
		private function clearHand(e:MouseEvent):void {
			
		}
		/**
		 * 选择
		 * @param	index
		 */
		private function radioChangeHand(index:Number):void {
			gridView.currentModel = gridView.modelArr[index];
		}
		/**
		 * 数字改变
		 */
		private function numberChangeHand(num:Number,ojb:Object):void {
			gridView.fillNumber =  num;
		}
		/**
		 * 下拉列表
		 * @param	index
		 */
		private function comboxHand(index:Number):void {
			gridView.chocomaticModel = gridView.chocoModelArr[index];
		}
		/**
		 * 自动填充
		 * @param	selected
		 */
		private function autoFilterChange(selected:Boolean):void {
			gridView.autoFill = selected;
		}
		/**
		 * 显示数字
		 * @param	selected
		 */
		private function showNumberChange(selected:Boolean):void {
			gridView.showNumber = selected;
		}
		/**
		 * 显示标签
		 * @param	selected
		 */
		private function showLabelChange(selected:Boolean):void {
			gridView.showLabel = selected;
		}
	}
}
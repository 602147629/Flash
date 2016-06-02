package MyComponent.ui.mo
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import MyComponent.ui.ScaleBitmap;
	
	public class UISkin extends ScaleBitmap
	{
		public function UISkin(_parentBitmapData:BitmapData,_rect:Rectangle=null)
		{
			super(_parentBitmapData);
			if(_rect){
				this.scale9Grid = _rect.clone();
			}
		}
		/**
		 * 获取皮肤的克隆数据
		 * @return
		 */
		public function clone():UISkin
		{
			var skin:UISkin = new UISkin(this.bitmapData, this.scale9Grid);
			return skin;
		}
		/**
		 * 销毁数据(并不销毁原始数据 销毁克隆数据 对象数据)
		 */
		override public function dispose():void
		{
			super.dispose();
		}
	}
}
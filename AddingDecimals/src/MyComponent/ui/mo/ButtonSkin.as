package MyComponent.ui.mo
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import MyComponent.ui.ScaleBitmap;
	
	public class ButtonSkin extends ScaleBitmap
	{
		public var upSkin:UISkin;
		public var overSkin:UISkin;
		public var downSkin:UISkin;
		public function ButtonSkin(bitmapData:BitmapData=null,_rect:Rectangle = null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			if(_rect){
				this.scale9Grid = _rect.clone();
			}
			super(bitmapData);
		}
	}
}
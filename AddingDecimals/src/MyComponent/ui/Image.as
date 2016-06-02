package MyComponent.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class Image extends Bitmap
	{
		private var loader:Loader;
		private var url:String;
		private var overFun:Function;
		public function Image(res:String="",defaultName:String="image",overf:Function=null)
		{
			url = res;
			overFun = overf;
		}
		
		/**
		 *尝试加载 
		 */		
		private function tryLoad():void{
			if(loader== null){
				loader = new Loader();
			}
			if(!loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			}
			if(!loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)){
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioHand);
			}
		}
		/**
		 *加载完成 
		 * @param e
		 */		
		private function loadComplete(e:Event):void{
			var bmd:BitmapData = (loader.content as Bitmap).bitmapData;
			SkinManager.instance.setSkinDic(imgRes,bmd.clone());
			if(this.bitmapData != null){
				this.bitmapData.dispose();
			}
			this.bitmapData = bmd;
			loader.unloadAndStop();
			loader = null;
			if(this.overFun != null){
				this.overFun(this);
			}
			
		}
		/**
		 *加载错误 
		 * @param e
		 */		
		private function ioHand(e:IOErrorEvent):void{
			trace("路径错误："+imgRes);
		}
		
		/**
		 *获取资源路径 
		 * @return 
		 * 
		 */		
		public function get imgRes():String{
			return url;
		}
		
	}
}
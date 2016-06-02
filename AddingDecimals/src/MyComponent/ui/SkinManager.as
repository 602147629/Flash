package MyComponent.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.Dictionary;

	/**
	 *皮肤管理类 
	 * @author mu-pc
	 */	
	public class SkinManager
	{
		public static var instance:SkinManager = new SkinManager();
		public function SkinManager()
		{
			if(instance)
			{
				throw new Error("单列类！");
			}
		}
		
		/**
		 *皮肤池 
		 */		
		private var skinDic:Dictionary = new Dictionary();
		
		/**
		 *保存皮肤 
		 * @param id
		 * @param data
		 */		
		public function setSkinDic(id:String,data:*):void{
			skinDic[id] = data;
		}
		/**
		 *获取皮肤 
		 * @param id
		 * @return 
		 */		
		public function getSkinDic(id:String):*{
			return skinDic[id];
		}
		
		
		
		/**
		 *根据名字获取共享库位图数据 
		 * @param name
		 * @return 
		 */		
		public function getBitmapDataByName(name:String):BitmapData{
			var tempClass:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			var tempBData:BitmapData = new tempClass();
			return tempBData;
		}
		/**
		 *获取共享库位图 
		 * @param name
		 * @return 
		 */		
		public function getBitmapByName(name:String):Bitmap{
			var bitmap:Bitmap = new Bitmap();
			bitmap.bitmapData = getBitmapDataByName(name);
			return bitmap;
		}
		
		/**
		 *获取共享库对象 
		 * @param name
		 * @return 
		 */		
		public function getObjectByName(name:String):*{
			var tempClass:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
			var tempObj:Object = new tempClass();
			return tempObj;
		}
		
		/**
		 *注册字体 
		 * @param name 库中名字
		 */		
//		public function getFontByName(name:String):void{
//			var tempClass:Class = ApplicationDomain.currentDomain.getDefinition(name) as Class;
//			Font.registerFont(tempClass);
//		}
//		
		/**
		 *共享库是否有此类 
		 * @param name
		 * @return 
		 */		
		public function isHasClassName(name:String):Boolean{
			return ApplicationDomain.currentDomain.hasDefinition(name);
		}
	}
}
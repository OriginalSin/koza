package sergik.utils {
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedSuperclassName;
	import flash.events.*;
	import flash.net.*;
	import flash.net.SharedObject;

	import mx.utils.Base64Encoder;

/**
 * clenears, clone, Dumper, ArrayConventers
 */
public class Utils {
	public function Utils() {
	}

	/**
	* Получить экземпляр обьекта из Библиотеки
	*/
	public static function takeLinkage(lnk:String, dom:ApplicationDomain = null):Object {
		if(!dom) dom = ApplicationDomain.currentDomain;
		var mcClass:Class = null;
		if(dom && dom.hasDefinition(lnk)) {
			mcClass = dom.getDefinition(lnk) as Class;
		}
		if(!mcClass) {
			trace('Utils::takeLinkage Не найден класс ', lnk, dom.hasDefinition(lnk))
			return null;
		}
/*
trace('__ ', mcClass, getQualifiedSuperclassName(mcClass), (mcClass is Bitmap))
		if(getQualifiedSuperclassName(mcClass) == 'flash.display::BitmapData') {
			return new Bitmap(mcClass) as Object;
			//return new mcClass(0, 0);
		}
*/
		return new mcClass();
	}

	/**
	 * Преобразование русских символов в строку имени файла
	 */
	public static function rus2filename(st:String):String {
		var encoder:Base64Encoder = new Base64Encoder();
		var out:String = st;
		encoder.encodeUTFBytes(out);
		return encoder.toString();
	}

	/**
	 * Удаление всех потомков
	 * @param	vmc
	 */
	public static function clrChilds(vmc:Object):void {    //
		if(!vmc) return;
		while (vmc.numChildren) {
			var c:Object = vmc.getChildAt(0);
			if(c.hasOwnProperty('destructor')) c.destructor();
			if(vmc.contains(c)) vmc.removeChild(c);
		}
	}

	/**
	 * Клонирование обьекта через ByteArray
	 * @param	source
	 * @return
	 */
	public static function clone(source:Object):* {
		var myBA:ByteArray = new ByteArray();
		myBA.writeObject(source);
		myBA.position = 0;
		return(myBA.readObject());
	}

	/**
	* Dumper обьектов
	*/
	public static function Dumper(node:Object, fl:int = 2, name:String = '', tabs:String = ''):String {
		//var attr:Vector.<String> = Vector.<String>([]);
		var attr:Array = [];
		var i:int;	//	итерации
		var debStr:String = '';
		debStr += (name ? '\n' + tabs + '"'+ name + '": ' : '');

		var tp:String = typeof(node);
//trace('typeof: ', tp, 'name: ', name, 'tabs: ', tabs.length);
		switch(tp) {
			case 'boolean':		// boolean
				debStr += node;
				break;
			case 'string':		// строка
				debStr += '"'+node+'"';
				break;
			case 'number':		// число
				debStr += node;
				break;
			case 'function':	// функция
			case 'object':		// обьект
				if(node == null) {
					debStr += 'null';
					break;
				}
				//trace('hhhhh: ', node.constructor,':', node.prototype);
				var constrType:String = node.constructor.toString();
				if(constrType == '[class Array]') {			// массив
					debStr += "["+ '\n' + tabs + '\t';
					for(i=0;i< node.length;i++) attr.push(Dumper(node[i], fl, '', tabs+'\t'));
					//trace('attr: ',name , ' : ', attr);
					debStr += attr.join(',');
					debStr += '\n' + tabs + ']';
				} else if(constrType == '[class Object]') {	// хэш
					debStr += "{" + tabs + '\t';
					for(var prop:String in node) attr.push(Dumper(node[prop], fl, prop, tabs+'\t'));
					debStr += tabs+'\t' + attr.join(',');
					debStr += '\n' + tabs + '}';
				} else  {									// напечатаем класс
					debStr += constrType;
				}
				break;
			default:		// неизвестный тип
				debStr += ' unknown type: '+tp;
				break;
		}
		return debStr;
	}

	/**
	 * Преобразовать ключи Hash-а в Vector.<String>
	public static function hashToVector(items:Object = null):Vector.<String> {
		var out:Vector.<String> = Vector.<String>([]);
		if(items) for(var key:String in items) out.push(key);
		return out;
	}
	 */

	/**
	 * Открыть link в новом окне Браузера
	 * @see war.ui.WarUI
	*/
	public static function openURLtab(link:String, targ:String = null, par:Object = null, type:String = 'GET'):void {
		if(!link) return;
		var url:String = link || "http://google.ru";
		var request:URLRequest = new URLRequest(url);
		if(par) {
			var variables:URLVariables = new URLVariables();
            for(var key:String in par) variables[key] = par[key];
            request.data = variables;
		}
		request.method = (type == 'GET' ? URLRequestMethod.GET : URLRequestMethod.POST);
		navigateToURL(request, targ);
		//trace("--------------- URL_open_tab ",type)
	}

	/**
	 * Cохранить настройки в куку Flash
	 * @see net.ConnectUI
	 */
	public static  function flashCookie(hash:Object, flag:String = 'write', cname:String = 'p_data'):void {
		if(typeof(hash) != 'object') return;
		//trace(">> save_local_file");
		var sharedObject:SharedObject = SharedObject.getLocal(cname);	// Обьект Flash куки
		//if(!sharedObject) sharedObject = SharedObject.getLocal(cname);
		var k:String;
		if(flag == 'read') {
			for(k in sharedObject.data) hash[k] = sharedObject.data[k];
			return;
		}
		for(k in hash) {
			//trace(">> w : " , k, hash[k], sharedObject.data[k]);
			if(hash[k] == false) delete sharedObject.data[k];
			else sharedObject.data[k] = hash[k];
		}

		var flushStatus:String = null;
		try {
			flushStatus = sharedObject.flush(10000);
		} catch (error:Error) {
			//trace(">> save_local_file Error: Не могу записать файл на диск");
		}
	}

	/**
	 * Форматирование суммы
	*/
	public static function sumFormat(dt:int = 0):String {
		var zn:int = int(dt / 1000000) % 1000;
		//var out:String = '';
//		if(zn > 0) out += (zn > 99 ? '':(zn > 9 ? '0':'00')) + zn + ' ';
		var out:String = (zn > 0 ? zn + ' ' : '');
		zn = int(dt / 1000) % 1000;
		if(out || zn > 0) out += (zn > 99 ? '':(zn > 9 ? '0':'00')) + zn + ' ';
//		out += (zn > 0 ? zn + ' ' : '');
		zn = dt % 1000;
		out += (zn > 99 ? '':(zn > 9 ? (out ? '0':'') : (out ? '00':''))) + zn;
//		out += zn;
		return out;
	}

	/**
	 * Форматирование Даты
	*/
	public static function dateFormat(tm:Number = 0, timeFlag:Boolean = false):String {
		var dt:Date = new Date(tm || null);
		var zn:int = dt['date'];
		var out:String = (zn > 9 ? '':'0') + zn + '.';
		zn = dt['month']+1;
		out += (zn > 9 ? '':'0') + zn + '.';
		out += dt['fullYear'];
		if(timeFlag) {
			out += '\n';
			zn = dt['hours'];
			out += (zn > 9 ? '':'0') + zn + ':';
			zn = dt['minutes'];
			out += (zn > 9 ? '':'0') + zn + ':';
			zn = dt['seconds'];
			out += (zn > 9 ? '':'0') + zn;
		}
		return out;
	}

	/**
	 * Получить аттрибуты из MouseEvent
	*/
	public static function chkTarget(e:MouseEvent):Object {
		var out:Object = {
			'target': e.target
			,'btn_from': e.target.name
			,'tp': e.target.name
			,'len': 0
		};
		var ta:Array = out['btn_from'].split('_');
		if(ta && ta.length) {
			out['len'] = ta.length;
			out['tp'] = ta[0];
		}
		out['ta'] = ta;
		return out;
	}

	public static function randomInRange(min:Number, max:Number):Number {
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

}
}

package sergik.net {
	import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;

	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import com.carlcalderon.arthropod.Debug;

public class FileLoader extends Loader {
	public var file:String = '';
	public var attr:Object = null; // Атрибуты от вызова
	public var callBack:Object = null;
	private var preloader:Object = null;
	private var suff:String = '';

	/**
	* Загрузчик одного файлов
	*	fileName - имя загружаемого файла
	*	par - параметры загрузки
	*		callback:Function	- вызываемый метод после загрузки
	*/
	public function FileLoader(fileName:String, par:Object = null) {
		super();
		this.file = fileName;
		if(par) {
			if(par['callback']) this.callBack = par['callback'];
			if(par['suffOff']) this.suff = '';
			if(par['attr']) this.attr = par['attr'];
		}
		init();
	}

    private function init():void {
		this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progress, false, 0, true);
		this.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
		this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError, false, 0, true);
		this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);

		var req:URLRequest = new URLRequest(this.file + this.suff);
		//if(Conf.isDebugMode) Debug.log("FileLoader::load  - "+ this.file + this.suff, 0xff8a00);
		var cont:LoaderContext = new LoaderContext(false, (this.file == 'skin.swf' ? ApplicationDomain.currentDomain : new ApplicationDomain()));
		load(req, cont);
    }

	private function destructor():void {
		this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
		this.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
		this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
		this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		//unloadAndStop();
	}

	/**
	* Обработчик COMPLETE при загрузке картинки
	*/
	private function onComplete(event:Event):void {
//trace("FileLoader::onComplete загружен файл - "+ this.file);
		if(callBack) callBack.call(null, 'onComplete', this );
		destructor();
    }

	/**
	* Обработчик IO_ERROR при загрузке картинки
	*/
    private function onIoError(event:IOErrorEvent):void {
		if(callBack) callBack.call(null, 'IOError', this );
		destructor();
 //trace("FileLoader::onIoError ошибка загрузки файла - "+ this.file + ' : ' + event);
		//Debug.log("FileLoader::onIoError ошибка загрузки файла - "+ this.file + ' : ' + event, 0xff8a00);
		//Debug.log("FileLoader::onIoError ошибка загрузки файла - "+ this.file + ' : ' + this.contentLoaderInfo.url, 0xff8a00);
	}

	/**
	* Обработчик SecurityError при загрузке картинки
	*/
	private function onSecurityError(e:SecurityErrorEvent):void {
		if(callBack) callBack.call(null, 'SecurityError', this );
		destructor();
		//Debug.log("FileLoader::onSecurityError ошибка загрузки файла - "+ this.file, 0xff8a00);
//trace("FileLoader::onSecurityError ошибка загрузки файла - "+ this.file + ' : ' + e);
	}

	private function progress(e:ProgressEvent):void {
		if(!preloader || !e || !e.bytesTotal) return;
		preloader.tf.text = String(int(100*(e.bytesLoaded/e.bytesTotal)))+"% "+this.file
	}
}
}
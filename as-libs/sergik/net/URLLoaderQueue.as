package sergik.net {
/**
 * URLLoader ('js/messages.js','js/GlowStyles.js')
 */
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.net.URLRequestHeader;
import flash.events.*;

public class URLLoaderQueue extends URLLoader {
	public var file:String = '';
	private var attr:Object = null;
	private var suff:String = '';

	public function URLLoaderQueue(file:String, par:Object = null) {
		this.file = file;
		this.attr = par || {};
		//trace('URLLoaderQueue ', attr['callback'], par)
		var request:URLRequest = new URLRequest(file);
		if(this.attr['header'] == "application/octet-stream") {
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			request.requestHeaders.push(header);
		}
		if(this.attr['vars']) {
			var variables:URLVariables = new URLVariables();
			for(var key:String in this.attr['vars']) variables[key] = this.attr['vars'][key];
			request.data = variables;
		}
		request.method = URLRequestMethod[this.attr['type'] || 'GET'];
		
		configureListeners();
		super(request);
	}

	public function destructor():void {
		//trace("URLLoaderQueue::destructor");
		this.removeEventListener(Event.COMPLETE, completeHandler);
		this.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		this.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		this.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		this.removeEventListener(Event.OPEN, openHandler);
		//unloadAndStop();
	}

	private function configureListeners():void {
		this.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
		this.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
		this.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
		this.addEventListener(Event.OPEN, openHandler, false, 0, true);
	}

	private function openHandler(event:Event):void {
		//trace("openHandler: " + event);
	}

	private function progressHandler(event:ProgressEvent):void {
		if(attr['callback']) attr['callback'].call(null, 'onProgress', {'bytesLoaded':event.bytesLoaded, 'bytesTotal':event.bytesTotal} );
		//trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal, file);
	}

	private function httpStatusHandler(event:HTTPStatusEvent):void {
		//trace("httpStatusHandler: " + event);
	}

	private function securityErrorHandler(event:SecurityErrorEvent):void {
		//trace("securityErrorHandler: " + event);
		if(attr['callback']) attr['callback'].call(null, 'SecurityErrorEvent', this );
		destructor();
	}

	private function ioErrorHandler(event:IOErrorEvent):void {
		//trace("ioErrorHandler: " + event);
		if(attr['callback']) attr['callback'].call(null, 'IOErrorEvent', this );
		destructor();
	}

	private function completeHandler(event:Event):void {
//trace("completeHandler: " , file);
		if(attr['callback']) attr['callback'].call(null, 'onComplete', this );
		destructor();
	}

}
}
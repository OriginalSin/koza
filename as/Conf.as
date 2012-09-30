package {
/**
 * Global configs
 *
 */

public class Conf {

	public static const BAR_COLOR:uint = 0x00ACEF;
	public static const BAR_BG:uint = 0x666666;

	public static var domain:String = '';		// боевой домен
	public static var revision:String = '14';			// Revision - из SVN
	//public static var anonsURL:String = 'json/gtv_anons.js';	// URL для получения JSON анонсов
	public static var anonsURL:String = '/WebServices/GeniumTV.asmx/GetPreview';	// URL для получения JSON анонсов
	public static var golosURL:String = '/WebServices/GeniumTV.asmx/GetVoting';	// URL для получения списка голосований
	public static var golosResURL:String = '/WebServices/GeniumTV.asmx/SaveVoting';	// URL для получения списка голосований
	//public static var golosURL:String = 'http://192.168.0.200:84/WebServices/GeniumTV.asmx/GetPreviewLast';	// URL для отправки голоса
	public static var getvideoURL:String = 'http://geniumtv.ru/getvideo.ashx?id=';	// URL для получения видео

	//public static var progrURL:String = 'json/gtv_konk.js';		// URL для получения списка программ для слайдера
	public static var progrURL:String = '/WebServices/GeniumTV.asmx/GetLastIssue';	// URL для получения списка программ для слайдера

	public static var issueURL:String = '/WebServices/GeniumTV.asmx/GetIssue';	// URL для получения аттрибутов

	/*================= Ex-private vars  ===============*/

	public static var cnf:Object = {
		'debugMode': 0							// режим дебага
		,'path_prefix': '/'						// добавляемый префикс имен файлов
		//,'path_prefix': 'http://'+domain+'/'	// добавляемый префикс имен файлов
		//,'path_postfix': '?'+revision			// постфикс для загрузки файлов
		,'path_postfix': ''						// постфикс для загрузки файлов
		,'curVideoPlayStatus': false			// текущий статус проигрывания видео
		,'allLoaded': false						// признак - загружены все обьекты
		,'site_url': 'http://'+domain+'/'		// URL сайта
		,'ldrURL': ''							// URL загружаемой SWF 
		,'standAlone': false					// standAlone запуск
		,'tmp': {}
		,'preload_items': [
		]
		,'galConfig': {							// Настройки галереи
			'pxSpace': 4
			,'numCols': 3
			,'colLen': 1
			,'picWidth': 410
			,'picHeight': 108
			,'radius': 285
			,'picsArray': []
			,'capsArray': []
			,'bmpDataArray': []
		}
	};

	public static var metaData:Object = null;	// onMetaData данные потока
	public static var pUI:Object = null;		// Родительский обьект
	public static var volLike:Number = 0.5;		// Любимая громкость звука
	public static var volBeforeOff:Number = 0;	// громкость перед выключением звука

	public static function chkLoaderURL(ui:Object):void {
		pUI = ui;
		cnf['ldrURL'] = pUI.loaderInfo.loaderURL;
		if(!cnf['ldrURL'].match(domain)) {	// Режим запуска в отладчике
			cnf['standAlone'] = true;
			//cnf['path_prefix'] = 'D:/work/infoservise_work/';
			cnf['path_postfix'] = '';
		}
		//trace('domain: ' , cnf['ldrURL'], ' : ' , domain, ' : ', cnf['ldrURL'].match(domain));
	}

}
}
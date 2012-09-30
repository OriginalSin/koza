// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/APIVK.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-02-07 12:39:36 +0500 (Sun, 07 Feb 2010) $
// Revision of current version: $Rev: 156 $

package com.vk.api
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import utils.MD5;

	/**
	 * Главный класс библиотеки apivk.
	 * <p>Единственный обязательный класс в библиотеке.</p>
	 * <p>Используется для инициализации, генерации сигнатуры, 
	 * создания объектов <code>URLRequest</code>.</p>
	 *
	 * @see http://apivk.googlecode.com
	 * @see http://vkontakte.ru/pages.php?id=2369282
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/URLRequest.html
	 */
	public class APIVK
	{
		private static const API_VERSION: String = '2.0';

		private static var _isJSON: Boolean;
		public static const XML : String = 'XML';
		public static const JSON: String = 'JSON';

		/**
		 * Определяет тип HTTP запроса.
		 *
		 * @default 'POST';
		 * @see #POST
		 * @see #GET
		 */
		public static var httpMethod: String = POST;
		public static const POST: String = 'POST';
		public static const GET : String = 'GET';

		private static var _apiURL   : String;
		private static var _viewerID  : String;
		private static var _apiID     : String;
		private static var _secret    : String;
		private static var _isTestMode: Boolean;

		private static var _params: Array = [];

		/**
		 * Инициализация.
		 * <p> Необходимо сделать вызов данной прежде, чем обращаться
		 * каким-либо другим методам библиотеки apivk.</p>
		 *
		 * <p>Если <code>isTestMode</code> задаётся значение <code>false</code>,
		 * то в качестве <code>viewer_id</code> нужно задавать id владельца
		 * приложения <code>api_id</code>.</p>
		 *
		 * @param api_url адрес сервиса API, по которому необходимо
		 * осуществлять запросы
		 *
		 * @param viewer_id id текущего пользователя, переданный SWF
		 * посредством flashvars при инициализации.
		 *
		 * @param api_id идентификатор приложения, присваивается при создании.
		 *
		 * @param secret секрет приложения.
		 *
		 * @param format формат возвращаемых данных
		 *
		 * @param isTestMode если этот параметр равен true, разрешает
		 * тестовые запросы к данным приложения. При этом аутентификация
		 * не проводится и считается, что текущий пользователь – это автор
		 * приложения. Это позволяет тестировать приложение без загрузки
		 * его на сайт. По умолчанию <code>false</code>.
		 */
		public static function init(
		                            api_url   : String,
		                            viewer_id : String,
		                            api_id    : String,
		                            secret    : String,
		                            format    : String = JSON,
		                            isTestMode: Boolean = false
		                            ): void
		{
			_apiURL     = api_url;
			_viewerID   = viewer_id;
			_apiID      = api_id;
			_secret     = secret;
			_isJSON     = (format == JSON);
			_isTestMode = isTestMode;
		}

		/**
		 * Добавить параметр в список параметров запроса.
		 *
		 * @param name имя параметра
		 * @param value значение параметра
		 */
		public static function addPar(name: String, value: String): void
		{
			_params.push(new Parameter(name, value));
		}

		/**
		 * Добавить параметр, значение которого есть список значений
		 *
		 * @param list список параметров.
		 */
		public static function addParArray(name: String, list: Array): void
		{
			_params.push(new Parameter(name, list.join(',')));
		}

		/**
		 * Cоздать объект XMLRequest.
		 * <p>Использует данные полученные через <code>APIVK.method</code>,
		 * <code>addPar</code>, <code>addParArray</code>. После использования
		 * эти данные удаляются.</p>
		 *
		 * @return HTTP запрос, в соответствии с предыдущими обращениями к классу.
		 *
		 * @see #method
		 * @see #addPar()
		 * @see #addParSafe()
		 */
		public static function req(method: String): URLRequest{
			_params.push(new Parameter('api_id', _apiID     ));
			if (_isJSON)
				_params.push(new Parameter('format', JSON));
			_params.push(new Parameter('method', method     ));
			if (_isTestMode)
				_params.push(new Parameter('test_mode', '1'));
			_params.push(new Parameter('v'     , API_VERSION));
			_params.push(new Parameter('sig'   , getSig(_params)));

			var req: URLRequest = new URLRequest();
			req.url    = _apiURL;
			req.method = httpMethod;

			var vars: URLVariables = new URLVariables();
			for each (var p: Parameter in _params){
				vars[p.name] = p.value;
			}
			req.data = vars;
			_params.splice(0);// clear array;
			return req;
		}
		private static function getSig(parameters: Array): String
		{
			_params.sortOn('name');
			var str: String = _viewerID + _params.join('') + _secret;
			//trace('str for sig: '+str);
			return MD5.encrypt(str);
		}

		/**
		 * Универсальный метод, который позволяет запускать
		 * последовательность других методов, сохраняя и фильтруя
		 * промежуточные результаты.
		 *
		 * @param code код алгоритма в VKScript - формате, похожем на
		 * JavaSсript или ActionScript (предполагается совместимость с
		 * ECMAScript). Алгоритм должен завершаться командой return
		 * %выражение%. Операторы должны быть разделены точкой с
		 * запятой.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=execute
		 */
		public static function execute(
		                               code: String
		                               ): URLRequest
		{
			APIVK.addPar('code', code);
			return APIVK.req('execute');
		}
	}
}
class Parameter
{
	public var name : String;
	public var value: String;
	public function Parameter(name: String, value: String)
	{
		this.name  = name;
		this.value = value;
	}
	public function toString(): String
	{
		return name + "=" + value;
	}
}

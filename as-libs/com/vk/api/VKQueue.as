// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/VKQueue.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-03 15:51:27 +0500 (Sun, 03 Jan 2010) $
// Revision of current version: $Rev: 131 $

package com.vk.api
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;

	import com.serialization.json.JSON;

	/**
	 * Создание очереди для запросов URLRequest, парсинг ответа.
	 * <p>Используемый алгоритм: </p>
	 * <ul>
	 *
	 *   <li>Если таймер не запущен, за запрос отправляется</li>
	 *
	 *   <li>Если таймер запущен, за запрос добавляется в очередь</lI>
	 *
	 *   <li>Если в ответе получили error 6, то добавляем запрос в
	 *   очередь, запускаем таймер</li>
	 *
	 *   <li>По истечению таймера отправляем запрос. Если очередь не
	 *   пуста, то таймер запускаем снова.</li>
	 * </ul>
	 *
	 * <p>Таким образом некоторые наборы запросов отправляются
	 * одновременно и ответ от них может быть получен в порядке,
	 * отличном от порядка добавления запроса в очередеть (т.е. через
	 * функцию <code>VKQueue.addReq</code></p>
	 */
	public class VKQueue
	{
		private static var _queue: Array = []; // = [Record]
		private static var _timer: Timer;
		private static var _isJSON: Boolean;
		/**
		 * Инициализация.
		 *
		 * @param delay интервал до отправки следующиего запроса в
		 * случае когда получена ошибка 6 "Too many requests per second"
		 *
		 * @param format формат данных получаемых сервера. Допустимые
		 * значения: <code>"JSON"</code>, <code>"XML"</code>
		 */
		public static function init(
		                            delay: Number = 400,
		                            format: String = 'JSON'
		                            ): void
		{
			_isJSON = (format == "JSON");
			_timer = new Timer(delay, 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		/**
		 * Добавить запрос в очередь.
		 *
		 * @param req
		 *
		 * @param onSuccess вызывается после получения ответа в случае,
		 * если нет тега error. В функцию передаётся полученные данные:
		 * <code>onSuccess(data: Object)</code>
		 *
		 * @param onError вызывается в случае, если получен ответ с
		 * тегом error. В функцию передаётся код ошибки, название
		 * ошибки, параметры запросы: <code>onError(errorCode: String,
		 * errorMsg: String, reqParams: *)</code>
		 *
		 */
		public static function addReq(
		                              req: URLRequest,
		                              onSuccess: Function = null,
		                              onError: Function = null
		                              ):void
		{
			var r: Record = new Record(req, onSuccess, onError);
			if (_timer.running)
				_queue.push(r);
			else
				makeReq(r);
		}

		private static function makeReq(r: Record):void
		{
			var onComplete: Function =
				function (e: Event): void
				{
					onReceive(e.target.data, r)
					e.target.removeEventListener(Event.COMPLETE, onComplete);
				}
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(r.req);
		}

		private static function onTimer(e: TimerEvent): void
		{
			var r: Record = _queue.shift();
			makeReq(r.repeat());
			_timer.reset();
			if (_queue.length != 0)
				_timer.start();
		}

		private static function onReceive(raw: *, r: Record): void
		{
			var isError: Boolean;
			// isError means Error 6

			//quick test for error 6
			if (_isJSON)
				isError = String(raw).slice(0, 24) ==
				           '{"error":{"error_code":6';
			else{
				var pattern: RegExp = /<\?xml version="1\.0" encoding="utf-8"\?>\s*<error>\s*<error_code>6<\/error_code>/;
				isError = (pattern.exec(raw) != null);
			}
			if (isError){//if error 6
				//trace('VKQueue: Error 6 "Too many requests per second" ');
				if (r.isRepeat)
					_queue.unshift(r);
				else
					_queue.push(r);
				_timer.reset();
				_timer.start();
			}else{
				// isError means any Error
				var data: Object;
				if (_isJSON){
					data = JSON.deserialize(raw);
					isError = Boolean(data.error);
					if (isError)
						data = data.error;
					else
						data = data.response;
				}else{
					data = XML(raw);
					isError = (data.localName() == 'error');
				}
				if (isError){//if any error
					if (r.onError != null)
						r.onError(
						          data.error_code.toString(),
						          data.error_msg.toString(),
						          data.request_params
					          );
				}else
					if (r.onSuccess != null)
						r.onSuccess(data);
			}
		}
	}
}
class Record
{
	import flash.net.URLRequest;

	public var req: URLRequest;
	public var onSuccess: Function;
	public var onError: Function;
	//если запрос отправляется повторноев связи с ошибкой 6:
	public var isRepeat: Boolean = false;

	public function Record(
	                       req: URLRequest,
	                       onSuccess: Function,
	                       onError: Function
	                       )
	{
		this.req       = req;
		this.onSuccess = onSuccess;
		this.onError   = onError;
	}
	public function repeat(): Record
	{
		isRepeat = true;
		return this;
	}
}

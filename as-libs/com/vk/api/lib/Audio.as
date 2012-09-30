// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Audio.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;

	/**
	 * Работа с аудиозаписями.
	 */
	public class Audio
	{
		/**
		 * Возвращает список аудиозаписей пользователя или группы. 
		 *
		 * @param uid id пользователя, которому принадлежат
		 * аудиозаписи. По умолчанию id текущего пользователя.
		 *
		 * @param gid id группы, которой принадлежат аудиозаписи. Если
		 * указан параметр gid, uid игнорируется.
		 *
		 * @param aids список id аудиозаписей, входящие в выборку по uid
		 * или gid.
		 *
		 * @param need_user если этот параметр равен true, сервер
		 * возвратит базовую информацию о владельце аудиозаписей в
		 * структуре user (id, photo, name, name_gen).
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.get
		 */
		public static function get(
		                           uid: String = '',
		                           gid: String = '',
		                           aids: Array = null,
		                           need_user: Boolean = false
		                           ): URLRequest
		{
			if (uid != '')
				APIVK.addPar('uid', uid);
			if (gid != '')
				APIVK.addPar('gid', gid);
			if (aids)
				APIVK.addParArray('aids', aids);
			if (need_user)
				APIVK.addPar('need_user', '1');
			return APIVK.req('audio.get');
		}

		/**
		 * Возвращает информацию об аудиозаписях. 
		 *
		 * @param audios список идентификаторов вида <code>[UserOwnerID,
		 * AudioID]</code> или <code>[-GroupOwnerID, AudioID]</code>
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.getById
		 */
		public static function getById(
		                               audios: Array
		                               ): URLRequest
		{
			var list: Array = [];
			for each (var id: Array in audios)
				list.push(String(id[0]) + '_' + String(id[1]));
			APIVK.addParArray('audios', list);
			return APIVK.req('getById');
		}

		/**
		 * Возвращает текст аудиозаписи
		 *
		 * @param lyrics_id id текста
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.getLyrics
		 */
		public static function getLyrics(
		                                 lyrics_id: String
		                                 ): URLRequest
		{
			APIVK.addPar('lyrics_id', lyrics_id);
			return APIVK.req('audio.getLyrics');
		}

		/**
		 * Возвращает адрес сервера для загрузки аудиозаписей.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.getUploadServer
		 */
		public static function getUploadServer(): URLRequest
		{
			return APIVK.req('audio.getUploadServer');
		}

		/**
		 * Сохраняет аудиозаписи после успешной загрузки.
		 *
		 * @param server параметр, возвращаемый в результате загрузки
		 * аудиофайла на сервер.
		 *
		 * @param audio параметр, возвращаемый в результате загрузки
		 * аудиофайла на сервер.
		 *
		 * @param hash параметр, возвращаемый в результате загрузки
		 * аудиофайла на сервер.
		 *
		 * @param artist автор композиции. По умолчанию берется из ID3
		 * тегов.
		 *
		 * @param title название композиции. По умолчанию берется из ID3
		 * тегов.
n		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.save
		 */
		public static function save(
		                            server: String,
		                            audio: String,
		                            hash: String,
		                            artist: String = '',
		                            title: String = ''
		                        ): URLRequest
		{
			APIVK.addPar('server', server);
			APIVK.addPar('artist', artist);
			APIVK.addPar('hash', hash);
			if (artist != '')
				APIVK.addPar('artist', artist);
			if (title != '')
				APIVK.addPar('title', title);
			return APIVK.req('audio.save');
		}

		/**
		 * Возвращает список аудиозаписей в соответствии с заданным
		 * критерием поиска.
		 *
		 * @param q строка поискового запроса. Например, The Beatles. 
		 *
		 * @param sort Вид сортировки. <code>'1'</code> - по
		 * длительности аудиозаписи, <code>'0'</code> - по дате
		 * добавления.
		 *
		 * @param lyrics Если этот параметр равен <code>true</code>,
		 * поиск будет производиться только по тем аудиозаписям, которые
		 * содержат тексты.
		 *
		 * @param count количество возвращаемых аудиозаписей (максимум 30). 
		 *
		 * @param offset смещение относительно первой найденной
		 * аудиозаписи для выборки определенного подмножества.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.search
		 */
		public static function search(
		                              q: String,
		                              sort: String,
		                              lyrics: Boolean = false,
		                              count: String = '30',
		                              offset: String = '0'
		                        ): URLRequest
		{
			APIVK.addPar('q', q);
			APIVK.addPar('sort', sort);
			APIVK.addPar('count', count);
			if (lyrics)
				APIVK.addPar('lyrics', '1');
			if (offset != '0')
				APIVK.addPar('offset', offset);
			return APIVK.req('audio.search');
		}

		/**
		 * Копирует аудиозапись на страницу пользователя или группы. 
		 *
		 * @param aid id аудиозаписи. 
		 *
		 * @param oid id владельца аудиозаписи. Если копируемая
		 * аудиозапись находится на странице группы, в этом параметре
		 * должно стоять значение, равное -id группы.
		 *
		 * @param gid id группы, в которую следует копировать
		 * аудиозапись. Если параметр не указан, аудиозапись копируется
		 * не в группу, а на страницу текущего пользователя. Если
		 * аудиозапись все же копируется в группу, у текущего
		 * пользователя должны быть права на эту операцию.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.add
		 */
		public static function add(
		                           aid: String,
		                           oid: String,
		                           gid: String = ''
		                           ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('oid', oid);
			if (gid != '')
				APIVK.addPar('gid', gid);
			return APIVK.req('audio.add');
		}

		/**
		 * Удаляет аудиозапись со страницы пользователя или группы.
		 *
		 * @param aid id аудиозаписи.
		 *
		 * @param oid id владельца аудиозаписи. Если копируемая
		 * аудиозапись находится на странице группы, в этом параметре
		 * должно стоять значение, равное -id группы.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.delete
		 */
		public static function deleteAudio(
		                                   aid: String,
		                                   oid: String
		                                   ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('oid', oid);
			return APIVK.req('audio.delete');
		}

		/**
		 * Редактирует данные аудиозаписи на странице пользователя или группы.
		 *
		 * @param aid id аудиозаписи.
		 *
		 * @param oid id владельца аудиозаписи. Если копируемая
		 * аудиозапись находится на странице группы, в этом параметре
		 * должно стоять значение, равное -id группы.
		 *
		 * @param artist название исполнителя аудиозаписи.
		 *
		 * @param title название аудиозаписи.
		 *
		 * @param text текст аудиозаписи, если введен.
		 *
		 * @param no_search <code>true</code> - скрывает аудиозапись из
		 * поиска по аудиозаписям.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.edit
		 */
		public static function edit(
		                            aid: String,
		                            oid: String,
		                            artist: String,
		                            title: String,
		                            text: String,
		                            no_search: Boolean
		                            ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('oid', oid);
			APIVK.addPar('artist', artist);
			APIVK.addPar('title', title);
			APIVK.addPar('text', text);
			if (no_search)
				APIVK.addPar('no_search', '1');
			else
				APIVK.addPar('no_search', '0');
			return APIVK.req('audio.edit');
		}

		/**
		 * Восстанавливает удаленную аудиозапись пользователя после удаления. 
		 *
		 * @param aid id удаленной аудиозаписи.
		 *
		 * @param oid id владельца аудиозаписи. По умолчанию - id
		 * текущего пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.restore
		 */
		public static function restore(
		                               aid: String,
		                               oid: String = ''
		                               ): URLRequest
		{
			APIVK.addPar('aid', aid);
			if (oid != '')
				APIVK.addPar('oid', oid);
			return APIVK.req('audio.restore');
		}

		/**
		 * Изменяет порядок аудиозаписи, перенося ее между
		 * аудиозаписями, идентификаторы которых переданы параметрами
		 * after и before.
		 *
		 * @param aid id аудиозаписи, порядок которой изменяется. 
		 *
		 * @param after id аудиозаписи, после которой нужно поместить
		 * аудиозапись. Если аудиозапись переносится в начало, параметр
		 * может быть равен нулю.
		 *
		 * @param before id аудиозаписи, перед которой нужно поместить
		 * аудиозапись. Если аудиозапись переносится в конец, параметр
		 * может быть равен нулю.
		 *
		 * @param oid id владельца изменяемой аудиозаписи. По умолчанию
		 * - id текущего пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=audio.reorder
		 */
		public static function reorder(
		                               aid: String,
		                               after: String,
		                               before: String,
		                               oid: String = ''
		                               ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('after', after);
			APIVK.addPar('before', before);
			if (oid != '')
				APIVK.addPar('oid', oid);
			return APIVK.req('audio.reorder');
		}

		/**
		 * Загрузка аудиозаписей.
		 *
		 * <p>Использование созданного <code>URLRequest</code> в классе
		 * <code>VKQueue</code> невозможно.</p>
		 *
		 * @param upload_url адрес, полученный в ответе на запрос
		 * <code>Audio.getUploadServer</code>
		 *
		 * @see http://vkontakte.ru/pages.php?id=2372787
		 * @see getUploadServer()
		 * @example
		 * <listing>
		 * import flash.net.FileReference;<br/>
		 * var file: FileReference;<br/>
		 * function chooseFile(): void
		 * {
		 *   var file: FileReference = new FileReference();
		 *   file.addEventListener(Event.SELECT, onSelect);
		 *   file.browse([new FileFilter("MP3 Files (*.mp3)", "*.mp3")]);
		 * }<br/>
		 * function onSelect(): void
		 * {
		 *   file.addEventListener(Event.COMPLETE, onComplete);
		 *   file.upload(API.Audio.upload(upload_url), "file");
		 * }
		 * </listing>
		 * <listing>
		 * // при динамической загрузке:
		 * import com.vk.api.API; <br/>
		 * function onComplete(e: Event): void
		 * {
		 *   var res: Object = API.JSON.deserialize(e.target.data);
		 *   trace("server="+res.server);
		 *   trace("audio="+res.audio);
		 *   trace("hash=" +res.hash);
		 * }<br/><br/>
		 * // если библиотека включёна в приложение:
		 * import com.serialization.json.JSON; <br/>
		 * function onComplete(e: Event): void
		 * {
		 *   var res: Object = JSON.deserialize(e.target.data);
		 *   trace("server="+res.server);
		 *   trace("audio="+res.audio);
		 *   trace("hash=" +res.hash);
		 * }
		 * </listing>
		 */
		public static function upload(
		                        upload_url: String
		                        ): URLRequest
		{
			var req: URLRequest = new URLRequest(upload_url);
			req.method = 'POST';
			req.requestHeaders.push(new URLRequestHeader(
			                                             "Cache-Control",
			                                             "no-cache"
			                                             )
			                        );
			return req;
		}
	 }
 }

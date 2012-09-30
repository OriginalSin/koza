// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Photos.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-28 17:19:36 +0500 (Thu, 28 Jan 2010) $
// Revision of current version: $Rev: 144 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Работа с фотографиями
	 */
	public class Photos
	{
		/**
		 * Возвращает список альбомов пользователя. 
		 *
		 * <p>Возвращает информацию об альбомах пользователях в виде
		 * массива объектов, каждый из которых имеет поля aid, thumb_id,
		 * owner_id, title, description, created, updated, size,
		 * privacy.</p>
		 * 
		 * @param uid ID пользователя, которому принадлежат альбомы. По
		 * умолчанию ID текущего пользователя.
		 *
		 * @param aids список ID альбомов. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.getAlbums
		 */
		public static function getAlbums(
		                                 uid: String = null,
		                                 aids: Array = null
		                                 ): URLRequest
		{
			if (uid)
				APIVK.addPar('uid', uid);
			if (aids)
				APIVK.addParArray('aids', aids);
			return APIVK.req('photos.getAlbums');
		}

		/**
		 * Возвращает список фотографий в альбоме.
		 *
		 * <p>Возвращает информацию о фотографиях альбома в виде массива
		 * объектов, каждый из которых имеет поля pid, aid, owner_id,
		 * src, src_small, src_big, created. Если фотография была
		 * загружена с параметром save_big равным 1, то в информации о
		 * ней будут возвращены поля src_xbig, src_xxbig, содержащие
		 * адреса фотографий более высокого качества. </p>
		 *
		 * @param uid ID пользователя, которому принадлежит альбом с
		 * фотографиями.
		 *
		 * @param aid ID альбома с фотографиями. 
		 *
		 * @param pids список ID фотографий. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.get
		 */
		public static function get(
		                           uid: String,
		                           aid: String,
		                           pids: Array = null
		                        ): URLRequest
		{
			APIVK.addPar('uid', uid);
			APIVK.addPar('aid', aid);
			if (pids)
				APIVK.addParArray('pids', pids);
			return APIVK.req('photos.get');
		}

		/**
		 * Возвращает информацию о фотографиях по их идентификаторам.
		 *
		 * <p>Возвращает информацию о фотографиях в виде массива
		 * объектов, каждый из которых имеет поля pid, aid, owner_id,
		 * src, src_small, src_big, created. Если фотография была
		 * загружена с параметром save_big равным 1, то для нее также
		 * будут возвращены поля src_xbig и src_xxbig, содержащие адреса
		 * фотографий более высокого качества. </p>
		 *
		 * <p>Если у пользователя, под
		 * которым пускается запрос, нет прав на просмотр фотографии,
		 * информация о ней не придет в ответе. <p>
		 *
		 * @param photos список идентификаторов вида <code>[UserOwnerID,
		 * PhotoID]</code>
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.getById
		 */
		public static function getById(
		                               photos: Array
		                               ): URLRequest
		{
			var list: Array = [];
			for each (var id: Array in photos)
				list.push(String(id[0]) + '_' + String(id[1]));
			APIVK.addParArray('photos', list);
			return APIVK.req('photos.getById');
		}

		/**
		 * Создает пустой альбом для фотографий.
		 *
		 * <p> Возвращает объект альбома с полями aid, thumb_id,
		 * owner_id, title, description, created, updated, size,
		 * privacy. </p>
		 *
		 * @param title название альбома.
		 *
		 * @param privacy уровень доступа к альбому. Значения: 0 – все
		 * пользователи, 1 – только друзья, 2 – друзья и друзья друзей.
		 *
		 * @param comment_privacy уровень доступа к комментированию
		 * альбома. Значения: 0 – все пользователи, 1 – только друзья, 2
		 * – друзья и друзья друзей.
		 *
		 * @param description текст описания альбома.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.createAlbum
		 */
		public static function createAlbum(
		                                   title: String,
		                                   privacy: String = '0',
		                                   comment_privacy: String = '0',
		                                   description: String = null
		                                   ): URLRequest
		{
			APIVK.addPar('title', title);
			APIVK.addPar('privacy', privacy);
			APIVK.addPar('comment_privacy', comment_privacy);
			if (description)
				APIVK.addPar('description', description);
			return APIVK.req('photos.createAlbum');
		}

		/**
		 * Редактирует данные альбома для фотографий пользователя.
		 *
		 * <p>Возвращает 1 в случае успеха. </p>
		 *
		 * @param aid идентификатор редактируемого альбома. 
		 *
		 * @param title новое название альбома.
		 *
		 * @param privacy новый уровень доступа к альбому. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей. 
		 *
		 * @param comment_privacy новый уровень доступа к комментированию альбома. Значения: 0 – все пользователи, 1 – только друзья, 2 – друзья и друзья друзей. 
		 *
		 * @param description новый текст описания альбома. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.editAlbum
		 */
		public static function editAlbum(
		                                 aid: String,
		                                 title: String,
		                                 privacy: String = null,
		                                 comment_privacy: String = null,
		                                 description: String = null
		                        ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('title', title);
			if (privacy)
				APIVK.addPar('privacy', privacy);
			if (comment_privacy)
				APIVK.addPar('comment_privacy', comment_privacy);
			if (description)
				APIVK.addPar('description', description);
			return APIVK.req('photos.editAlbum');
		}

		/**
		 * Возвращает адрес сервера для загрузки фотографий.
		 *
		 * <p>Возвращает объект с полями upload_url и aid.</p>
		 *
		 * @param aid ID альбома, в который необходимо загрузить фотографии.
		 *
		 * @param save_big если этот параметр равен <code>true</code>,
		 * то помимо стандартных размеров, фотографии будут сохранены в
		 * больших размерах – 807 и 1280 точек в ширину.</p>
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.getUploadServer
		 */
		public static function getUploadServer(
		                                       aid: String = null,
		                                       save_big: Boolean = false
		                                       ): URLRequest
		{
			if (aid)
				APIVK.addPar('aid', aid);
			if (save_big)
				APIVK.addPar('save_big', '1');
			return APIVK.req('photos.getUploadServer');
		}

		/**
		 * Сохраняет фотографии после успешной загрузки.
		 *
		 * <p>Возвращает массив объектов с загруженными фотографиями,
		 * каждый из которых имеет поля pid, aid, owner_id, src,
		 * src_big, src_small, created. Если фотографии были загружены с
		 * параметром save_big равным 1, то в возвращаемом массиве будут
		 * определены поля src_xbig, src_xxbig, содержащие адреса
		 * фотографий более высокого качества. </p>
		 *
		 * @param aid ID альбома, в который необходимо загрузить фотографии.
		 *
		 * @param server параметр, возвращаемый в результате загрузки
		 * фотографий на сервер.
		 *
		 * @param photos_list параметр, возвращаемый в результате
		 * загрузки фотографий на сервер.
		 *
		 * @param hash параметр, возвращаемый в результате загрузки
		 * фотографий на сервер.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.save
		 */
		public static function save(
		                            aid: String,
		                            server: String,
		                            photos_list: String,
		                            hash: String
		                            ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('server', server);
			APIVK.addPar('photos_list', photos_list);
			APIVK.addPar('hash', hash);
			return APIVK.req('photos.save');
		}

		/**
		 * Возвращает адрес сервера для загрузки фотографии на страницу
		 * пользователя.
		 *
		 * <p>Возвращает объект с единственным полем upload_url.</p>
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.getProfileUploadServer
		 */
		public static function getProfileUploadServer(): URLRequest
		{
			return APIVK.req('photos.getProfileUploadServer');
		}

		/**
		 * Сохраняет фотографию пользователя после успешной загрузки.
		 *
		 * <p>Возвращает объект, содержащий поля photo_hash и
		 * photo_src. Параметр photo_hash необходим для подтверждения
		 * пользователем изменения его фотографии через вызов метода
		 * saveProfilePhoto Flash-контейнера. Поле photo_src содержит
		 * путь к загруженной фотографии. </p>
		 *
		 * @param server параметр, возвращаемый в результате загрузки
		 * фотографий на сервер.
		 *
		 * @param photo параметр, возвращаемый в результате
		 * загрузки фотографий на сервер.
		 *
		 * @param hash параметр, возвращаемый в результате загрузки
		 * фотографий на сервер.
		 *
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.saveProfilePhoto
		 */
		public static function saveProfilePhoto(
		                                        server: String,
		                                        photo: String,
		                                        hash: String
		                                        ): URLRequest
		{
			APIVK.addPar('server', server);
			APIVK.addPar('photo', photo);
			APIVK.addPar('hash', hash);
			return APIVK.req('photos.saveProfilePhoto');
		}

		/**
		 * Переносит фотографию из одного альбома в другой.
		 *
		 * <p>Возвращает 1 в случае успеха. </p>
		 *
		 * @param pid id переносимой фотографии. 
		 *
		 * @param target_aid id альбома, куда переносится фотография. 
		 *
		 * @param oid id владельца переносимой фотографии, по умолчанию
		 * id текущего пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.move
		 */
		public static function move(
		                            pid: String,
		                            target_aid: String,
		                            oid: String = null
		                        ): URLRequest
		{
			APIVK.addPar('pid', pid);
			APIVK.addPar('target_aid', target_aid);
			if (oid)
				APIVK.addPar('oid', oid);
			return APIVK.req('photos.move');
		}

		/**
		 * Делает фотографию обложкой альбома.
		 *
		 * <p>Возвращает 1 в случае успеха. </p>
		 *
		 * @param pid id фотографии, которая должна стать обложкой альбома. 
		 *
		 * @param aid id альбома. 
		 *
		 * @param oid id владельца альбома, по умолчанию id текущего пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.makeCover
		 */
		public static function makeCover(
		                                 pid: String,
		                                 aid: String,
		                                 oid: String = null
		                                 ): URLRequest
		{
			APIVK.addPar('pid', pid);
			APIVK.addPar('aid', aid);
			if (oid)
				APIVK.addPar('oid', oid);
			return APIVK.req('photos.makeCover');
		}

		/**
		 * Меняет порядок альбома в списке альбомов пользователя.
		 *
		 * <p>Возвращает 1 в случае успеха. </p>
		 *
		 * @param aid id альбома, порядок которого нужно изменить. 
		 *
		 * @param before id альбома, перед которым следует поместить альбом. 
		 *
		 * @param after id альбома, после которого следует поместить альбом. 
		 *
		 * @param oid id владельца альбома, по умолчанию id текущего пользователя. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.reorderAlbums
		 */
		public static function reorderAlbums(
		                                     aid: String,
		                                     before: String,
		                                     after: String,
		                                     oid: String = null
		                                     ): URLRequest
		{
			APIVK.addPar('aid', aid);
			APIVK.addPar('before', before);
			APIVK.addPar('after', after);
			if (oid)
				APIVK.addPar('oid', oid);
			return APIVK.req('photos.reorderAlbums');
		}

		/**
		 * Меняет порядок фотографии в списке фотографий альбома пользователя.
		 *
		 * <p>Возвращает 1 в случае успеха. </p>
		 * 
		 * @param pid id фотографии, порядок которой нужно изменить. 
		 *
		 * @param before id фотографии, перед которой следует поместить
		 * фотографию.
		 *
		 * @param after id фотографии, после которой следует поместить
		 * фотографию.
		 *
		 * @param oid id владельца фотографии, по умолчанию id текущего
		 * пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=photos.reorderPhotos
		 */
		public static function reorderPhotos(
		                                     pid: String,
		                                     before: String,
		                                     after: String,
		                                     oid: String = null
		                                     ): URLRequest
		{
			APIVK.addPar('pid', pid);
			APIVK.addPar('before', before);
			APIVK.addPar('after', after);
			if (oid)
				APIVK.addPar('oid', oid);
			return APIVK.req('photos.reorderPhotos');
		}
	}
}

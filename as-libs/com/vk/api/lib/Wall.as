// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Wall.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-02-04 16:07:48 +0500 (Thu, 04 Feb 2010) $
// Revision of current version: $Rev: 147 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Стена.
	 */
	public class Wall
	{
		/**
		 * Возвращает адрес сервера для загрузки фотографии на стену
		 * пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=wall.getPhotoUploadServer
		 */
		public static function getPhotoUploadServer(): URLRequest
		{
			return APIVK.req('wall.getPhotoUploadServer');
		}

		/**
		 * Сохраняет запись на стене пользователя.
		 *
		 * <p>Запись может содержать фотографию, ранее загруженную на
		 * сервер ВКонтакте или любую доступную фотографию из альбома
		 * пользователя.</p>
		 *
		 * @param wall_id id пользователя, на стене которого размещается
		 * запись.
		 *
		 * @param post_id id записи, содержащий символы от a до z и от 0
		 * до 9. Этот параметр будет передаваться в приложение через
		 * flashVars при просмотре или создании записи на стене
		 * пользователя.
		 *
		 * @param server параметр, возвращаемый в результате загрузки
		 * изображения на сервер.
		 *
		 * @param photo параметр, возвращаемый в результате загрузки
		 * изображения на сервер.
		 *
		 * @param hash параметр, возвращаемый в результате загрузки
		 * изображения на сервер.
		 *
		 * @param photo_id_user id пользователя, разместившего
		 * фотографию. Используется только совместно с параметром
		 * <code>photo_id_photo</code>.
		 *
		 * @param photo_id_photo id фотографии.
		 *
		 * @param message текст сообщения для размещения на стене
		 * пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=wall.savePost
		 */
		public static function savePost(
		                                wall_id:        String,
		                                post_id:        String = null,
		                                server:         String = null,
		                                photo:          String = null,
		                                hash:           String = null,
		                                photo_id_user:  String = null,
		                                photo_id_photo: String = null,
		                                message:        String = null
		                                ): URLRequest
		{
			APIVK.addPar('wall_id', wall_id);
			if (post_id)
				APIVK.addPar('post_id', post_id);
			if (server)
				APIVK.addPar('server', server);
			if (photo)
				APIVK.addPar('photo', photo);
			if (hash)
				APIVK.addPar('hash', hash);
			if (photo_id_user)
				APIVK.addPar('photo_id', photo_id_user+'_'+photo_id_photo);
			if (message)
				APIVK.addPar('message', message);
			return APIVK.req('wall.savePost');
		}
	}
}

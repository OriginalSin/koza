// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/User.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-04-13 21:38:50 +0600 (Tue, 13 Apr 2010) $
// Revision of current version: $Rev: 164 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * информация о пользователе
	 */
	public class User
	{

		/**
		 * установил ли текущий пользователь приложение или нет. 
		 *
		 * @param uid ID пользователя. По умолчанию ID текущего пользователя. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=isAppUser
		 */
		public static function isAppUser(
		                                 uid: String
		                                 ): URLRequest
		{
			APIVK.addPar('uid', uid);
			return APIVK.req('isAppUser');
		}

		/**
		 * Возвращает расширенную информацию о пользователях.
		 *
		 * @param uids список ID пользователей (максимум 1000 штук).
		 *
		 * @param fields поля анкет, необходимые для
		 * получения. Доступные значения: uid, first_name, last_name,
		 * nickname, sex, bdate (birthdate), city, country, timezone,
		 * photo, photo_medium, photo_big, has_mobile, rate.
		 * <p>Значения uid, first_name и last_name возвращаются всегда,
		 * вне зависимости от выбранных полей и их количества. </p>
		 *
		 * @param name_case падеж для склонения имени и фамилии
		 * пользователя. Возможные значения: именительный – nom,
		 * родительный – gen, дательный – dat, винительный – acc,
		 * творительный – ins, предложный – abl. По умолчанию nom.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getProfiles
		 * @see UserField
		 * @see UserNameCase
		 */
		public static function getProfiles(
		                                   uids: Array,
		                                   fields: Array = null,
		                                   name_case: String = ''
		                        ): URLRequest
		{
			APIVK.addParArray('uids', uids);
			if (fields)
				APIVK.addParArray('fields', fields);
			if (name_case != '')
				APIVK.addPar('name_case', name_case);
			return APIVK.req('getProfiles');
		}

		/**
		 * Возвращает список идентификаторов друзей текущего пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getFriends
		 */
		public static function getFriends(): URLRequest
		{
			return APIVK.req('getFriends');
		}

		/**
		 * Возвращает список идентификаторов друзей текущего
		 * пользователя, которые установили данное приложение.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getAppFriends
		 */
		public static function getAppFriends(): URLRequest
		{
			return APIVK.req('getAppFriends');
		}

		/**
		 * Возвращает баланс текущего пользователя на счету приложения в
		 * сотых долях голоса.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getUserBalance
		 */
		public static function getUserBalance(): URLRequest
		{
			return APIVK.req('getUserBalance');
		}

		/**
		 * Получает настройки текущего пользователя в данном приложении.
		 *
		 * <p> Возвращает битовую маску настроек текущего пользователя в
		 * данном приложени. Например, если метод возвращает 3, это
		 * означает, что пользователь разрешил отправлять ему
		 * уведомления и получать список его друзей.</p>
		 *
		 * <ul>
		 * <li>+1 – пользователь разрешил отправлять ему уведомления.</li>
		 * <li>+2 – доступ к друзьям.</li>
		 * <li>+4 – доступ к фотографиям.</li>
		 * <li>+8 – доступ к аудиозаписям.</li>
		 * <li>+32 – доступ к предложениям.</li>
		 * <li>+64 – доступ к вопросам.</li>
		 * <li>+128 – доступ к wiki-страницам.</li>
		 * <li>+256 – доступ к меню слева.</li>
		 * </ul>
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getUserSettings
		 * @see UserSett
		 */
		public static function getUserSettings(): URLRequest
		{
			return APIVK.req('getUserSettings');
		}

		/**
		 * Возвращает список id групп текущего пользователя. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getGroups
		 */
		public static function getGroups(): URLRequest
		{
			return APIVK.req('getGroups');
		}

		/**
		 * Возвращает базовую информацию о группах текущего пользователя
		 * или о группах из списка gids.
		 *
		 * @param gids список id групп, информацию о которых нужно
		 * получить. Если этот параметр указан, то информация о группах
		 * текущего пользователя возвращена не будет.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getGroupsFull
		 */
		public static function getGroupsFull(
		                                     gids: Array = null
		                                     ): URLRequest
		{
			if (gids)
				APIVK.addParArray('gids', gids);
			return APIVK.req('getGroupsFull');
		}
	}
}

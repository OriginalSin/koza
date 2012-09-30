// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/UserField.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-04-13 21:38:50 +0600 (Tue, 13 Apr 2010) $
// Revision of current version: $Rev: 164 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Описание полей анкеты, используемые в методе <code>User.getProfiles</code>
	 * @see User#getProfiles()
	 */
	public class UserField
	{
		/**
		 * 
		 */
		public static const UID: String = 'uid';

		/**
		 *
		 */
		public static const FIRST_NAME: String = 'first_name';

		/**
		 *
		 */
		public static const LAST_NAME: String = 'last_name';

		/**
		 * Никнейм.
		 * <p>Если никнейм отсутствует, то при приёме данных в формате XML
		 * в узле <user> содержится пустой тег <nickname />.</p>
		 */
		public static const NICKNAME: String = 'nickname';

		/**
		 * Пол пользователя.
		 * <p>Возвращаемые значения: 1 - женский, 2 -
		 * мужской, 0 - без указания пола.</p>
		 */
		public static const SEX: String = 'sex';

		/**
		 * День рождения.
		 * <p>Дата выдаётся в формате: "23.11.1981" или
		 * "21.9" (если год скрыт).  Если дата рождения скрыта целиком,
		 * то при приёме данных в формате XML в узле <user> отсутствует
		 * тег bdate. </p>
		 */
		public static const BDATE: String = 'bdate';

		/**
		 * Город.
		 * <p>Выдаётся id города, указанного у пользователя в
		 * разделе "Контакты". Название города по его id можно узнать
		 * при помощи метода getCities.  Если город не указан, то при
		 * приёме данных в формате XML в узле <user> отсутствует тег
		 * city.</p>
		 */
		public static const CITY: String = 'city';

		/**
		 * Страна.
		 * <p>Выдаётся id страны, указанной у пользователя в
		 * разделе "Контакты". Название страны по её id можно узнать при
		 * помощи метода getCountries.  Если страна не указана, то при
		 * приёме данных в формате XML в узле <user> отсутствует тег
		 * country. </p>
		 */
		public static const COUNTRY: String = 'country';

		/**
		 * 
		 */
		public static const TIMEZONE: String = 'timezone';

		/**
		 * Фото шириной 50 пикселей.
		 * <p>В случае отсутствия у пользователя фотографии выдаётся
		 * ответ: "images/question_c.gif"</p>
		 */
		public static const PHOTO: String = 'photo';

		/**
		 * Фото шириной 100 пикселей.
		 * <p>В случае отсутствия у пользователя фотографии выдаётся
		 * ответ: "images/question_b.gif"</p>
		 */
		public static const PHOTO_MEDIUM: String = 'photo_medium';

		/**
		 * Фото шириной 200 пикселей.
		 * <p>В случае отсутствия у пользователя фотографии выдаётся
		 * ответ: "images/question_a.gif"</p>
		 */
		public static const PHOTO_BIG: String = 'photo_big';

		/**
		 * Известен ли номер мобильного телефона пользователя.
		 *
		 * <p>Возвращаемые значения: 1 - известен, 0 - не известен.<p>
		 */
		public static const HAS_MOBILE: String = 'has_mobile';

		/**
		 * Рейтинг пользователя
		 */
		public static const RATE: String = 'rate';

		/**
		 * На выходе будут доступны поля <code>home_phone</code>,
		 * <code>mobile_phone</code>
		 */
		public static const CONTACTS: String = 'contacts';

		/**
		 * На выходе будут доступны поля <code>university</code>,
		 * <code>university_name</code>, <code>faculty</code>,
		 * <code>faculty_name</code>, <code>graduation</code
		 */
		public static const EDUCATION: String = 'education';
	}
}

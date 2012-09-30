// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Misc.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-07 10:32:04 +0500 (Thu, 07 Jan 2010) $
// Revision of current version: $Rev: 135 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Методы, не вошедшие в другие классы.
	 */
	public class Misc
	{
		/**
		 * unixtime сервера.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getServerTime
		 */
		public static function getServerTime(): URLRequest
		{
			return APIVK.req('getServerTime');
		}

		/**
		 * Возвращает список таргетированных рекламных объявлений для
		 * текущего пользователя.
		 *
		 * @param count количество возвращаемых рекламных объявлений
		 * (максимум 20).
		 *
		 * @param type тип рекламных объявлений. 1 – только
		 * таргетированные объявления, 2 – только прямые объявления
		 * приложений, 3 – все объявления. По умолчанию равен 3.
		 *
		 * @param apps_ids список id приложений для выборки из прямых
		 * объявлений. Этот параметр игнорируется в том случае, если
		 * параметр type равен 1.
		 *
		 * @param min_price минимальная стоимость перехода по рекламной
		 * ссылке в сотых долях голоса. Применяется только при выборке
		 * из прямых объявлений. По умолчанию равен 0.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getAds
		 */
		public static function getAds(
		                              count: String = '1',
		                              type: String = null,
		                              apps_ids: Array = null,
		                              min_price: String = null
		                              ): URLRequest
		{
			APIVK.addPar('count', count);
			if (type)
				APIVK.addPar('type', type);
			if (apps_ids)
				APIVK.addParArray('apps_ids', apps_ids);
			if (min_price)
				APIVK.addPar('min_price', min_price);
			return APIVK.req('getAds');
		}

		/**
		 * Устанавливает название приложения, которое выводится в левом меню.
		 *
		 * <p> Перед использованием необходимо, чтобы пользователь
		 * добавил приложение в левое меню со страницы приложения,
		 * списка приложений или настроек. </p>
		 *
		 * @param name короткое название приложения для левого меню, до
		 * 17 символов в формате UTF.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=setNameInMenu
		 */
		public static function setNameInMenu(
		                                     name: String
		                                     ): URLRequest
		{
			APIVK.addPar('name', name);
			return APIVK.req('setNameInMenu');
		}
	}
}

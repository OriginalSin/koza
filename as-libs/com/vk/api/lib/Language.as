// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Language.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Локализация приложений.
	 */
	public class Language
	{
		/**
		 * Возвращает список переведенных на указанный язык фраз. 
		 *
		 * @param language ID языка, на котором необходимо получить
		 * переведенные фразы. По умолчанию выбирается язык текущего
		 * пользователя приложения.
		 *
		 * @param keys список ключей языковых фраз, перевод для которых
		 * необходимо получить.
		 *
		 * @param all если этот параметр равен <code>true</code>, то
		 * возвращается список из всех созданных фраз.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=language.getValues
		 */
		public static function getValues(
		                                 language: String = null,
		                                 keys: Array = null,
		                                 all: Boolean = false
		                                 ): URLRequest
		{
			if (language)
				APIVK.addPar('language', language);
			if (keys)
				APIVK.addParArray('keys', keys);
			if (all)
				APIVK.addPar('all', '1');
			return APIVK.req('language.getValues');
		}
	}
}

// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Geo.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * информация о географических объектах.
	 */
	public class Geo
	{
		/**
		 * информация о городе
		 *
		 * @param cids список ID городов
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getCities
		 */
		public static function getCities(
		                                 cids: Array
		                                 ): URLRequest
		{
			APIVK.addParArray('cids', cids);
			return APIVK.req('getCities');
		}

		/**
		 * информация о стране
		 *
		 * @param cids список ID стран
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getCountries
		 */
		public static function getCountries(
		                                    cids: Array
		                                    ): URLRequest
		{
			APIVK.addParArray('cids', cids);
			return APIVK.req('getCountries');
		}
	}
}

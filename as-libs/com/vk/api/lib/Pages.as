// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Pages.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Работа с вики-страницами.
	 */
	public class Pages
	{
		/**
		 * Возвращает информацию о вики-странице.
		 *
		 * @param pid id вики-страницы.
		 *
		 * @param title название вики-страницы
		 *
		 * @param gid id группы, где создана страница. 
		 *
		 * @param mid id создателя вики-страницы. В этом случае произойдет обращение не к странице группы, а к одной из личных вики-страниц пользователя.
		 *
		 * @param need_html определяет, требуется ли в ответе html-представление вики-страницы. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=pages.get
		 */
		public static function get(
		                           pid:   String = null,
		                           title: String = null,
		                           gid:   String = null,
		                           mid:   String = null,
		                           need_html: Boolean = false
		                           ): URLRequest
		{
			if (pid)
				APIVK.addPar('pid', pid);
			if (title)
				APIVK.addPar('title', title);
			if (gid)
				APIVK.addPar('gid', gid);
			if (mid)
				APIVK.addPar('mid', mid);
			if (need_html)
				APIVK.addPar('need_html', '1');
			return APIVK.req('pages.get');
		}

		/**
		 * Сохраняет текст вики-страницы. 
		 *
		 * @param pid id вики-страницы.
		 *
		 * @param title название вики-страницы
		 *
		 * @param gid id группы, где создана страница. 
		 *
		 * @param mid id создателя вики-страницы. В этом случае произойдет обращение не к странице группы, а к одной из личных вики-страниц пользователя.
		 *
		 * @param text новый текст страницы в вики-формате.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=pages.save
		 */
		public static function save(
		                            pid:   String = null,
		                            title: String = null,
		                            gid:   String = null,
		                            mid:   String = null,
		                            text: String = ''
		                            ): URLRequest
		{
			if (pid)
				APIVK.addPar('pid', pid);
			if (title)
				APIVK.addPar('title', title);
			if (gid)
				APIVK.addPar('gid', gid);
			if (mid)
				APIVK.addPar('mid', mid);
			APIVK.addPar('Text', text);
			return APIVK.req('pages.save');
		}

		/**
		 * Сохраняет новые настройки доступа на чтение и редактирование
		 * вики-страницы.
		 *
		 * @param pid id вики-страницы.
		 *
		 * @param gid id группы, где создана страница.
		 *
		 * @param view значение настройки доступа на чтение;
		 *
		 * @param edit значение настройки доступа на редактирование; 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=pages.saveAccess
		 */
		public static function saveAccess(
		                                  pid: String,
		                                  gid: String,
		                                  view: String,
		                                  edit: String
		                                  ): URLRequest
		{
			APIVK.addPar('pid', pid);
			APIVK.addPar('gid', gid);
			APIVK.addPar('view', view);
			APIVK.addPar('edit', edit);
			return APIVK.req('pages.saveAccess');
		}

		/**
		 * Возвращает текст одной из старых версий страницы. 
		 *
		 * @param hid id версии вики-страницы. 
		 *
		 * @param gid id группы, где создана страница. 
		 *
		 * @param need_html определяет, требуется ли в ответе
		 * html-представление версии вики-страницы.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=pages.getVersion
		 */
		public static function getVersion(
		                                  hid: String,
		                                  gid: String,
		                                  need_html: Boolean = false
		                        ): URLRequest
		{
			APIVK.addPar('hid', hid);
			APIVK.addPar('gid', gid);
			if (need_html)
				APIVK.addPar('need_html', '1');
			return APIVK.req('pages.getVersion');
		}

		/**
		 * Возвращает список вики-страниц в группе. 
		 *
		 * @param gid id группы, где создана страница.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=pages.getTitles
		 */
		public static function getTitles(
		                                 gid: String
		                                 ): URLRequest
		{
			APIVK.addPar('gid', gid);
			return APIVK.req('pages.getTitles');
		}

		/**
		 * Возвращает html-представление вики-разметки. 
		 *
		 * @param text текст в вики-формате. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=parseWiki
		 */
		public static function parseWiki(
		                                 text: String
		                                 ): URLRequest
		{
			APIVK.addPar('Text', text);
			return APIVK.req('parseWiki');
		}
	}
}

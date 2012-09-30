// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Messages.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Организация циклической очереди сообщений.
	 *
	 * <p>Используются переменные 2064, 3072, 2080-2207 для организации
	 * простой циклической очереди сообщений, удобной, например, для
	 * реализации полностью клиентского чата.</p>
	 *
	 * <ul>
	 * <li>Переменная 2064 хранит общее количество сообщений, уже
	 * записанных в очередь.</li>
	 * <li>Переменная 3072 - количество
	 * сообщений, прочитанных текущим пользователем.</li>
	 * <li>Переменная 2080+(i mod 128) содержит i-ое сообщение. (i
	 * больше или равно 0; в этой переменной хранится строка с id
	 * пользователя, временем отправки сообщения, именем пользователя и
	 * текстом сообщения, разделенными символом с кодом 31).</li>
	 * </ul>
	 */
	public class Messages
	{

		/**
		 * добавить в очередь сообщение
		 *
		 * @param message сообщение для отправки
		 *
		 * @param session целочисленный идентификатор сеанса (комнаты);
		 * если этот параметр не указан, то по умолчанию сообщение
		 * отправляется в комнату с идентификатором 0.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=sendMessage
		 */
		public static function sendMessage(
		                                   message: String,
		                                   session: String = '0'
		                                   ): URLRequest
		{
			APIVK.addPar('message', message);
			if (session != '0')
				APIVK.addPar('session', session);
			return APIVK.req('sendMessage');
		}

		/**
		 * получить список сообщений чата.
		 *
		 * @param session целочисленный идентификатор сеанса (комнаты);
		 * если этот параметр не указан, то по умолчанию сообщение
		 * отправляется в комнату с идентификатором 0.
		 *
		 * @param messages_to_get количество сообщений, которые будут
		 * получены (если параметр не указан, возвращаются все
		 * непрочитанные сообщения).
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getMessages
		 */
		public static function getMessages(
		                        session: String = '0',
		                        messages_to_get: String = '0'
		                        ): URLRequest
		{
			if (session != '0')
				APIVK.addPar('session', session);
			if (messages_to_get != '0')
				APIVK.addPar('messages_to_get', messages_to_get);
			return APIVK.req('getMessages');
		}
	}
}

// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Variables.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-02-05 11:13:38 +0500 (Fri, 05 Feb 2010) $
// Revision of current version: $Rev: 153 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Хранение данных на серверах Вконтакте.
	 * <p></p>
	 * <table class="innertable">
	 * <tr>
	 *  <th>Номера</th><th>Постоянные</th>
	 *  <th>api_id</th><th>user_id</th><th>session</th>
	 *  <th>Описание</th>
	 * </tr>
	 * <tr>
	 *  <td><code>0</code></td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>unixtime</td>
	 * </tr>
	 * <tr>
	 *  <td><code>1-14</code></td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>&#xA0;</td>
	 * </tr>
	 * <tr>
	 *  <td><code>16</code></td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>highscores count</td>
	 * </tr>
	 * <tr>
	 *  <td><code>17</code></td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>max_scores</td>
	 * </tr>
	 * <tr>
	 *  <td>18-31</td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>application variables</td>
	 * </tr>
	 * <tr>
	 *  <td><code>30-(32+max_scores-1)</code></td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>highscore records</td>
	 * </tr>
	 * <tr>
	 *  <td>(32+max_scores-1)-1023</td><td>✔</td>
	 *  <td>✔</td><td>&#xA0;</td><td>&#xA0;</td>
	 *  <td>application variables</td>
	 * </tr>
	 *
	 *
	 * <tr>
	 *  <td><code>1024-1039</code></td><td>✔</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>&#xA0;</td>
	 * </tr>
	 * <tr>
	 *  <td>1040-1279</td><td>✔</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>user private vars</td>
	 * </tr>
	 * <tr>
	 *  <td><code>1280-1295</code></td><td>✔</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>&#xA0;</td>
	 * </tr>
	 * <tr>
	 *  <td>1296-1503</td><td>✔</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>user public vars (other users: read only)</td>
	 * </tr>
	 * <tr>
	 *  <td>1503-1535</td><td>✔</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>user public vars (other users: read-write)</td>
	 * </tr>
	 * <tr>
	 *  <td>1535-1567</td><td>&#xA0;</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>user public vars (other users: read-write)</td>
	 * </tr>
	 * <tr>
	 *  <td>1568-1791</td><td>&#xA0;</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>user public vars (other users: read only)</td>
	 * </tr>
	 * <tr>
	 *  <td>1792-2047</td><td>&#xA0;</td>
	 *  <td>✔</td><td>✔</td><td>&#xA0;</td>
	 *  <td>user private vars</td>
	 * </tr>
	 *
	 *
	 * <tr>
	 *  <td><code>2048</code></td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>current session's id (read only)</td>
	 * </tr>
	 * <tr>
	 *  <td><code>2049</code></td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>current session's name</td>
	 * </tr>
	 * <tr>
	 *  <td><code>2050-2063</code></td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>&#xA0;</td>
	 * </tr>
	 * <tr>
	 *  <td><code>2064</code></td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>messages count</td>
	 * </tr>
	 * <tr>
	 *  <td>2065-2079</td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>session vars</td>
	 * </tr>
	 * <tr>
	 *  <td><code>2080-2207</code></td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>message query</td>
	 * </tr>
	 * <tr>
	 *  <td>2208-3071</td><td>&#xA0;</td>
	 *  <td>✔</td><td>&#xA0;</td><td>✔</td>
	 *  <td>session vars</td>
	 * </tr>
	 *
	 *
	 * <tr>
	 *  <td><code>3072</code></td><td>&#xA0;</td>
	 *  <td>✔</td><td>✔</td><td>✔</td>
	 *  <td>read messages count</td>
	 * </tr>
	 * <tr>
	 *  <td>3073-4095</td><td>&#xA0;</td>
	 *  <td>✔</td><td>✔</td><td>✔</td>
	 *  <td>instance vars</td>
	 * </tr>
	 * </table>
	 * <p>В постоянных переменных может храниться до 255 байтов.
	 * Во временных переменнах &#x2014; до 4095 байтов</p>
	 * 
	 * <p><code>Моноширинным шрифтом</code> обозначены
	 * зарезервированные переменные<p>
	 */
	public class Variables
	{
		/**
		 * id пользователя.
		 * <p>Используется в зависимости от номера переменной (см. Таблицу)</p>
		 * <p>Чтобы очистить переменную нужно задать ее значение равной
		 * пустой строке <code>""</code>. В этом случае параметр user_id
		 * передаваться не будет, но значение будет считаться равным id
		 * текущего пользователя </p>
		 */
		public static var user_id: String = "";
		/**
		 * Номер сессии.
		 * <p>Определяет c какой группой переменных работаем.</p>
		 */
		public static var session: String = "0";
		/**
		 * Получить значение переменной.
		 *
		 * @param key номер переменной.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getVariable
		 */
		public static function getVariable(
		                        key: uint
		                        ): URLRequest
		{
			APIVK.addPar('key', key.toString());
			checkUserIDGet(key);
			checkSession(key);
			return APIVK.req('getVariable');
		}

		/**
		 * Получить значение нескольких переменных.
		 * 
		 *
		 * @param key номер первой переменной.
		 *
		 * @param count Значение от 1 до 32, количество переменных.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=getVariables
		 */
		public static function getVariables(
		                                    key: uint,
		                                    count: uint
		                        ): URLRequest
		{
			APIVK.addPar('key',   key.toString()   );
			APIVK.addPar('count', count.toString() );
			checkUserIDGet(key);
			checkSession(key);
			return APIVK.req('getVariables');
		}

		/**
		 * Записать в переменную.
		 *
		 * @param key номер переменной.
		 *
		 * @param value значение переменной.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=putVariable
		 */
		public static function putVariable(
		                        key: uint,
		                        value: String
		                        ): URLRequest
		{
			APIVK.addPar('key',   key.toString() );
			APIVK.addPar('value', value          );
			checkUserIDPut(key);
			checkSession(key);
			return APIVK.req('putVariable');
		}
		private static function checkUserIDGet(key: uint): void{
			if (user_id == "")
				return;
			if ((1280 <= key) && (key <= 1791))
				APIVK.addPar('user_id', user_id);
		}
		private static function checkUserIDPut(key: uint): void{
			if (user_id == "")
				return;
			if ((1504 <= key) && (key <= 1567))
				APIVK.addPar('user_id', user_id);
		}
		private static function checkSession(key: uint): void{
			if (2048 <= key)
				APIVK.addPar('session', session);
		}
	}
}

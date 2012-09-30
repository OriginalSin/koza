// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Offers.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Работа с сервисом предложений
	 */
	public class Offers
	{
		/**
		 * Сохраняет информацию о предложении текущего пользователя.
		 *
		 * @param message текст предложения, который будет доступен для других пользователей.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.edit
		 */
		public static function edit(
		                            message: String
		                            ): URLRequest
		{
			APIVK.addPar('message', message);
			return APIVK.req('offers.message');
		}

		/**
		 * Открывает предложение текущего пользователя для общего доступа.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.open
		 */
		public static function open(): URLRequest
		{
			return APIVK.req('offers.open');
		}

		/**
		 * Закрывает предложение текущего пользователя, убирая его из
		 * общего доступа.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.close
		 */
		public static function close(): URLRequest
		{
			return APIVK.req('offers.close');
		}

		/**
		 * Возвращает информацию о предложении, размещенном текущим
		 * пользователем.
		 *
		 * @param uids список ID пользователей, предложения которых
		 * необходимо получить. По умолчанию используется ID текущего
		 * пользователя.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.get
		 */
		public static function get(
		                           uids: Array = null
		                           ): URLRequest
		{
			if (uids)
				APIVK.addParArray('uids', uids);
			return APIVK.req('offers.get');
		}

		/**
		 * Возвращает предложение случайного пользователя в соответствии
		 * с выбранными фильтрами.
		 *
		 * <p>Возвращает объект offer, содержащий поля uid, name, photo,
		 * date, message, age, online, city_id и city_name. </p>
		 *
		 * @param count количество возвращаемых предложений.
		 *
		 * @param text ключевые слова в тексте предложения.
		 *
		 * @param age_from минимальный возраст владельца предложения.
		 *
		 * @param age_to максимальный возраст владельца предложения.
		 *
		 * @param city id города владельца предложения.
		 *
		 * @param country id страны владельца предложения.
		 *
		 * @param sex id пола владельца предложения.
		 *
		 * @param online онлайн-статус владельца предложения.
		 *
		 * @param photo наличие фотографии у владельца предложения.
		 *
		 * @param status id семейного положения владельца предложения.
		 *
		 * @param politic id политических взглядов владельца предложения.
		 *
		 * @param university id университета владельца предложения.
		 *
		 * @param edu_form id формы обучения в вузе владельца предложения.
		 *
		 * @param edu_status id статуса обучения в вузе владельца предложения.
		 *
		 * @param school id школы владельца предложения.
		 *
		 * @param district id района, указанного владельцем предложения в Местах.
		 *
		 * @param station id станции метро, указанной владельцем предложения в Местах.
		 *
		 * @param group id группы, в которой должен состоять владелец предложения.
		 *
		 * @param company строка - компания владельца предложения.
		 *
		 * @param position строка - должность владельца предложения.
		 *
		 * @param religion строка - религия владельца предложения.
		 *
		 * @param interests ключевые слова в интересах владельца предложения.
		 *
		 * @param name ключевые слова в имени владельца предложения.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.search
		 */
		public static function search(
		                              count:      String,
		                              text:       String = null,
		                              age_from:   String = null,
		                              age_to:     String = null,
		                              city:       String = null,
		                              country:    String = null,
		                              sex:        String = null,
		                              online:     Boolean = false,
		                              photo:      Boolean = false,
		                              status:     String = null,
		                              politic:    String = null,
		                              university: String = null,
		                              edu_form:   String = null,
		                              edu_status: String = null,
		                              school:     String = null,
		                              district:   String = null,
		                              station:    String = null,
		                              group:      String = null,
		                              company:    String = null,
		                              position:   String = null,
		                              religion:   String = null,
		                              interests:  String = null,
		                              name:       String = null
		                              ): URLRequest
		{
			APIVK.addPar('count', count);
			if (text)
				APIVK.addPar('text', text);
			if (age_from)
				APIVK.addPar('age_from', age_from);
			if (age_to)
				APIVK.addPar('age_to', age_to);
			if (city)
				APIVK.addPar('city', city);
			if (country)
				APIVK.addPar('country', country);
			if (sex)
				APIVK.addPar('sex', sex);
			if (online)
				APIVK.addPar('online', '1');
			if (photo)
				APIVK.addPar('photo', '1');
			if (status)
				APIVK.addPar('status', status);
			if (politic)
				APIVK.addPar('politic', politic);
			if (university)
				APIVK.addPar('university', university);
			if (edu_form)
				APIVK.addPar('edu_form', edu_form);
			if (edu_status)
				APIVK.addPar('edu_status', edu_status);
			if (school)
				APIVK.addPar('school', school);
			if (district)
				APIVK.addPar('district', district);
			if (station)
				APIVK.addPar('station', station);
			if (group)
				APIVK.addPar('group', group);
			if (company)
				APIVK.addPar('company', company);
			if (position)
				APIVK.addPar('position', position);
			if (religion)
				APIVK.addPar('religion', religion);
			if (interests)
				APIVK.addPar('interests', interests);
			if (name)
				APIVK.addPar('name', name);
			return APIVK.req('offers.search');
		}

		/**
		 * Возвращает список ответов на предложение, размещенное текущим
		 * пользователем.
		 *
		 * @param count количество ответов, которое необходимо получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества ответов.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.getInboundResponses
		 */
		public static function getInboundResponses(
		                                           count: String = null,
		                                           offset: String = null
		                                           ): URLRequest
		{
			if (count)
				APIVK.addPar('count', count);
			if (offset)
				APIVK.addPar('offset', offset);
			return APIVK.req('offers.getInboundResponses');
		}

		/**
		 * Возвращает список ответов на предложения, принятые текущим пользователем. 
		 *
		 * @param count количество ответов, которое необходимо получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества ответов.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.getOutboundResponses
		 */
		public static function getOutboundResponses(
		                                            count: String = null,
		                                            offset: String = null
		                                            ): URLRequest
		{
			if (count)
				APIVK.addPar('count', count);
			if (offset)
				APIVK.addPar('offset', offset);
			return APIVK.req('offers.getOutboundResponses');
		}

		/**
		 * Принимает ответ текущего пользователя на выбранное предложение. 
		 *
		 * @param uid идентификатор владельца предложения, на которое
		 * дается ответ.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.accept
		 */
		public static function accept(
		                              uid: String
		                              ): URLRequest
		{
			APIVK.addPar('uid', uid);
			return APIVK.req('offers.accept');
		}

		/**
		 * Отклоняет ответ текущего пользователя на выбранное предложение. 
		 *
		 * @param uid идентификатор владельца предложения, ответ на
		 * которое отклоняется.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.refuse
		 */
		public static function refuse(
		                              uid: String
		                              ): URLRequest
		{
			APIVK.addPar('uid', uid);
			return APIVK.req('offers.refuse');
		}

		/**
		 * Помечает выбранные ответы на предложение текущего
		 * пользователя как просмотренные.
		 *
		 * @param uids идентификаторы пользователей, ответивших на
		 * предложение пользователя
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.setResponseViewed
		 */
		public static function setResponseViewed(
		                                         uids: Array
		                                         ): URLRequest
		{
			APIVK.addParArray('uids', uids);
			return APIVK.req('offers.setResponseViewed');
		}

		/**
		 * Удаляет выбранные ответы на предложение текущего пользователя. 
		 *
		 * @param uids идентификаторы пользователей, ответивших на
		 * предложение пользователя
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=offers.deleteResponses
		 */
		public static function deleteResponses(
		                                       uids: Array
		                                       ): URLRequest
		{
			APIVK.addParArray('uids', uids);
			return APIVK.req('offers.deleteResponses');
		}
	}
}

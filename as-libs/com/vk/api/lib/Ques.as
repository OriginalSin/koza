// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/Ques.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Работа с сервисом вопросов.
	 */
	public class Ques
	{
		/**
		 * Возвращает список вопросов, созданных пользователем.
		 *
		 * <p>Возвращает массив объектов - вопросов текущего
		 * пользователя, каждый из которых содержит поля qid, uid, type,
		 * text, answers_num, last_poster_id, last_poster_name,
		 * last_post_date, date, а также поля name, photo и online (если
		 * значение need_profiles в запросе больше 0).</p>
		 *
		 * @param uids id пользователей, которым принадлежат вопросы,
		 * через запятую.
		 *
		 * @param qid id отдельного вопроса, информацию о котором нужно
		 * получить. Если указан qid, то uids не учитывается.
		 *
		 * @param sort сортировка результатов (0 - по дате обновления в
		 * порядке убывания, 1 - по дате создания в порядке возрастания,
		 * 2 - по дате создания в порядке убывания).
		 *
		 * @param need_profiles определяет, требуется ли в ответе
		 * краткая информация об авторе вопроса (поля name, photo и
		 * online). Значения от 0 до 3. Чем больше значение, тем крупнее
		 * фотография в поле photo.
		 *
		 * @param name_case падеж для склонения имени и фамилии
		 * пользователя. Возможные значения: именительный – nom,
		 * родительный – gen, дательный – dat, винительный – acc,
		 * творительный – ins, предложный – abl. По умолчанию nom.
		 *
		 * @param count количество вопросов, которое необходимо
		 * получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества вопросов.
		 *
		 * @see UserNameCase
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.get
		 */
		public static function get(
		                           uids: Array,
		                           qid: String = null,
		                           sort: String = '0',
		                           need_profiles: String = '0',
		                           count: String = '1',
		                           offset: String = '0'
		                        ): URLRequest
		{
			if (uids)
				APIVK.addParArray('uids', uids);
			if (qid)
				APIVK.addPar('qid', qid);
			APIVK.addPar('sort', sort);
			APIVK.addPar('need_profiles', need_profiles);
			APIVK.addPar('count', count);
			if (offset != '0')
				APIVK.addPar('offset', offset);
			return APIVK.req('questions.get');
		}

		/**
		 * Редактирует вопрос текущего пользователя.
		 *
		 * <p>В случае успешного сохранения вопроса метод возвратит 1.</p>
		 *
		 * @param qid id редактируемого вопроса. 
		 *
		 * @param text новый текст вопроса. 
		 *
		 * @param type новый тип вопроса. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.edit
		 */
		public static function edit(
		                            qid: String,
		                            text: String,
		                            type: String
		                            ): URLRequest
		{
			APIVK.addPar('qid', qid);
			APIVK.addPar('text', text);
			APIVK.addPar('type', type);
			return APIVK.req('questions.get');
		}

		/**
		 * Создает новый вопрос у текущего пользователя.
		 *
		 * <p> В случае успешного создания вопроса метод возвратит
		 * идентификатор созданного вопроса (qid).</p>
		 *
		 * @param text новый текст вопроса. 
		 *
		 * @param type новый тип вопроса. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.add
		 */
		public static function add(
		                           text: String,
		                           type: String
		                           ): URLRequest
		{
			APIVK.addPar('text', text);
			APIVK.addPar('type', type);
			return APIVK.req('questions.add');
		}

		/**
		 * Удаляет вопрос текущего пользователя.
		 *
		 * <p>В случае успешного удаления вопроса метод возвратит 1. </p>
		 *
		 * @param qid id удаляемого вопроса.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.delete
		 */
		public static function deleteQues(
		                                  qid: String
		                                  ): URLRequest
		{
			APIVK.addPar('qid', qid);
			return APIVK.req('questions.delete');
		}

		/**
		 * Возвращает список вопросов, соответствующих критериям поиска.
		 *
		 * <p>Возвращает количество найденных вопросов и массив
		 * соответствующих им объектов, каждый из которых содержит поля
		 * qid, uid, type, text, answers_num, last_poster_id,
		 * last_poster_name, last_post_date, date, а также поля name,
		 * photo и online (если значение need_profiles в запросе больше
		 * 0).</p>
		 *
		 * @param text ключевые слова для поиска по вопросам.
		 *
		 * @param sort сортировка результатов (0 - по дате добавления, 1
		 * - по числу комментариев).
		 *
		 * @param type id типа вопросов, среди которых нужно
		 * осуществлять поиск.
		 *
		 * @param need_profiles определяет, требуется ли в ответе
		 * краткая информация об авторе вопроса (поля name, photo и
		 * online). Значения от 0 до 3. Чем больше значение, тем крупнее
		 * фотография в поле photo.
		 *
		 * @param name_case падеж для склонения имени и фамилии
		 * пользователя. Возможные значения: именительный – nom,
		 * родительный – gen, дательный – dat, винительный – acc,
		 * творительный – ins, предложный – abl. По умолчанию nom.
		 *
		 * @param count количество вопросов, которое необходимо
		 * получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества вопросов.
		 *
		 * @see UserNameCase
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.search
		 */
		public static function search(
		                              text: String,
		                              sort: String = '0',
		                              type: String = null,
		                              need_profiles: String = '0',
		                              name_case: String = null,
		                              count: String = '1',
		                              offset: String = '0'
		                              ): URLRequest
		{
			APIVK.addPar('text', text);
			APIVK.addPar('sort', sort);
			if (type)
				APIVK.addPar('type', type);
			if (need_profiles != '0')
				APIVK.addPar('need_profiles', need_profiles);
			if (name_case)
				APIVK.addPar('name_case', name_case);
			APIVK.addPar('count', count);
			APIVK.addPar('offset', offset);
			return APIVK.req('questions.search');
		}

		/**
		 * Возвращает список всех возможных типов вопросов.
		 *
		 * <p>Возвращает массив всех возможных типов вопросов, каждый из
		 * объектов которого содержит поля tid и name.</p>
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.getTypes
		 */
		public static function getTypes(): URLRequest
		{
			return APIVK.req('questions.getTypes');
		}

		/**
		 * Возвращает список вопросов, на которые ответил пользователь.
		 *
		 * <p>Возвращает массив объектов – вопросов, на которые ответил
		 * текущий пользователь, каждый из которых содержит поля qid,
		 * uid, type, text, answers_num, last_poster_id,
		 * last_poster_name, last_post_date, date, а также поля name,
		 * photo и online (если значение need_profiles в запросе больше
		 * 0).</p>
		 *
		 * @param sort сортировка результатов (0 - по дате обновления в
		 * порядке убывания, 1 - по дате создания в порядке возрастания,
		 * 2 - по дате создания в порядке убывания).
		 *
		 * @param need_profiles определяет, требуется ли в ответе
		 * краткая информация об авторе вопроса (поля name, photo и
		 * online). Значения от 0 до 3. Чем больше значение, тем крупнее
		 * фотография в поле photo.
		 *
		 * @param name_case падеж для склонения имени и фамилии
		 * пользователя. Возможные значения: именительный – nom,
		 * родительный – gen, дательный – dat, винительный – acc,
		 * творительный – ins, предложный – abl. По умолчанию nom.
		 *
		 * @param count количество вопросов, которое необходимо
		 * получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества вопросов.
		 *
		 *
		 * @see UserNameCase
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.getOutbound
		 */
		public static function getOutbound(
		                                   sort: String = '0',
		                                   need_profiles: String = '0',
		                                   name_case: String = null,
		                                   count: String = '1',
		                                   offset: String = '0'
		                                   ): URLRequest
		{
			APIVK.addPar('sort', sort);
			if (need_profiles != '0')
				APIVK.addPar('need_profiles', need_profiles);
			if (name_case)
				APIVK.addPar('name_case', name_case);
			APIVK.addPar('count', count);
			APIVK.addPar('offset', offset);
			return APIVK.req('questions.getOutbound');
		}

		/**
		 * Возвращает список ответов на вопрос.
		 *
		 * <p>Возвращает количество найденных ответов и массив
		 * соответствующих им объектов, каждый из которых содержит поля
		 * aid, qid, uid, text, num, date, а также поля name, photo и
		 * online (если значение need_profiles в запросе больше 0).</p>
		 *
		 * @param qid id вопроса.
		 *
		 * @param sort сортировка результатов (1 - в порядке убывания
		 * даты, по умолчанию - в порядке возрастания)
		 *
		 * @param need_profiles определяет, требуется ли в ответе
		 * краткая информация об авторе ответа (поля name, photo и
		 * online). Значения от 0 до 3. Чем больше значение, тем крупнее
		 * фотография в поле photo.
		 *
		 * @param count количество ответов, которое необходимо получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества ответов.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.getAnswers
		 */
		public static function getAnswers(
		                                  qid: String,
		                                  sort: String = '0',
		                                  need_profiles: String = '0',
		                                  count: String = '1',
		                                  offset: String = '0'
		                                  ): URLRequest
		{
			APIVK.addPar('qid', qid);
			APIVK.addPar('sort', sort);
			if (need_profiles != '0')
				APIVK.addPar('need_profiles', need_profiles);
			APIVK.addPar('count', count);
			APIVK.addPar('offset', offset);
			return APIVK.req('questions.getOutbound');
		}

		/**
		 * Добавляет ответ на вопрос.
		 *
		 * <p>В случае успешного добавления ответа метод возвратит 1. </p>
		 *
		 * @param uid id автора вопроса, ответ к которому добавляется. 
		 *
		 * @param qid id вопроса. 
		 *
		 * @param text текст ответа. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.addAnswer
		 */
		public static function addAnswer(
		                                 uid: String,
		                                 qid: String,
		                                 text: String
		                                 ): URLRequest
		{
			APIVK.addPar('uid', uid);
			APIVK.addPar('qid', qid);
			APIVK.addPar('text', text);
			return APIVK.req('questions.addAnswer');
		}

		/**
		 * Удаляет ответ на вопрос. Может быть запущен только автором
		 * ответа или автором вопроса.
		 *
		 * <p>В случае успешного удаления ответа метод возвратит 1.</p> 
		 *
		 * @param uid id автора вопроса, ответ к которому удаляется. 
		 *
		 * @param aid id удаляемого ответа. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.deleteAnswer
		 */
		public static function deleteAnswer(
		                                    uid: String,
		                                    aid: String
		                                    ): URLRequest
		{
			APIVK.addPar('uid', uid);
			APIVK.addPar('aid', aid);
			return APIVK.req('questions.deleteAnswer');
		}

		/**
		 * отмечает, что пользователь присоединяется к ответу на вопрос.
		 *
		 * <p>Возвращает новое количество пользователей,
		 * присоединившихся к ответу. </p>
		 *
		 * @param uid id автора вопроса, ответ к которому одобряется.
		 *
		 * @param aid id одобряемого ответа. 
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.joinAnswer
		 */
		public static function joinAnswer(
		                                  uid: String,
		                                  aid: String
		                                  ): URLRequest
		{
			APIVK.addPar('uid', uid);
			APIVK.addPar('aid', aid);
			return APIVK.req('questions.joinAnswer');
		}

		/**
		 * Возвращает список пользователей, присоединившихся к ответу.
		 *
		 * <p>Возвращает количество найденных ответов и массив
		 * соответствующих им объектов, каждый из которых содержит поля
		 * vid, voter_id, date, а также поля name, photo и online (если
		 * значение need_profiles в запросе больше 0).</p>
		 *
		 * @param uid id автора вопроса.
		 *
		 * @param aid id ответа.
		 *
		 * @param sort сортировка результатов (1 - в порядке убывания
		 * даты, по умолчанию - в порядке возрастания)
		 *
		 * @param need_profiles определяет, требуется ли в ответе
		 * краткая информация о личности присоединившихся к ответу (поля
		 * name, photo и online). Значения от 0 до 3. Чем больше
		 * значение, тем крупнее фотография в поле photo.
		 *
		 * @param count количество пользователей, которое необходимо
		 * получить.
		 *
		 * @param offset смещение, необходимое для выборки определенного
		 * подмножества пользователей.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.getAnswerVotes
		 */
		public static function getAnswerVotes(
		                                      uid: String,
		                                      aid: String,
		                                      sort: String = '0',
		                                      need_profiles: String = '0',
		                                      count: String = '1',
		                                      offset: String = '0'
		                                      ): URLRequest
		{
			APIVK.addPar('uid', uid);
			APIVK.addPar('aid', aid);
			APIVK.addPar('sort', sort);
			if (need_profiles != '0')
				APIVK.addPar('need_profiles', need_profiles);
			APIVK.addPar('count', count);
			APIVK.addPar('offset', offset);
			return APIVK.req('questions.getAnswerVotes');
		}

		/**
		 * Отмечает список новых ответов на вопрос пользователя как прочитанный.
		 *
		 * <p>Работает в том случае, если пускается под пользователем -
		 * автором вопроса.</p>
		 *
		 * <p>Возвращает 1. Если некоторые из id ответов не будут
		 * относиться к вопросам текущего пользователя, они будут
		 * проигнорированы.</p>
		 *
		 * @param aids список id ответов, которые нужно отметить как прочитанные.
		 *
		 * @see http://vkontakte.ru/pages.php?o=-1&p=questions.markAsViewed
		 */
		public static function markAsViewed(
		                                    aids: Array
		                                    ): URLRequest
		{
			APIVK.addParArray('aids', aids);
			return APIVK.req('questions.markAsViewed');
		}
	}
}

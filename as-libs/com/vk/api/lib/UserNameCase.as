// -*- coding: utf-8 -*-

// Copyright (c) 2009-2010 The apivk.googlecode.com project Authors.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// url in repo: $URL: https://apivk.googlecode.com/svn/trunk/src/com/vk/api/lib/UserNameCase.as $
// Author   of current version: $Author: ivann.exe $
// Date     of current version: $Date: 2010-01-01 14:02:30 +0500 (Fri, 01 Jan 2010) $
// Revision of current version: $Rev: 129 $

package com.vk.api.lib
{
	import com.vk.api.APIVK;
	import flash.net.URLRequest;

	/**
	 * Описание падежей для имени и фамилии, используемые в методе
	 * <code>User.getProfiles</code>
	 *
	 * @see User#getProfiles
	 */
	public class UserNameCase
	{

		/**
		 * именительный
		 */
		public static const NOM: String = 'nom';

		/**
		 * родительный
		 */
		public static const GEN: String = 'gen';

		/**
		 * дательный
		 */
		public static const DAT: String = 'dat';

		/**
		 * винительный
		 */
		public static const ACC: String = 'acc';

		/**
		 * творительный
		 */
		public static const INS: String = 'ins';

		/**
		 * предложный
		 */
		public static const ABL: String = 'abl';
	}
}

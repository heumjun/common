/*
 * @Class Name : CookieUtils.java
 * @Description : 쿠키유틸 class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2013.12.26    배동오         최초 생성
 *
 * @author 배동오
 * @since 2013.12.26
 * @version 1.0
 * @see
 */
package com.stxdis.util.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.util.CookieGenerator;
import org.springframework.web.util.WebUtils;

// TODO: Auto-generated Javadoc
/**
 * The Class CookieUtils.
 */
public class CookieUtils {
	

	/**
	 * 쿠키생성.
	 *
	 * @param response the response
	 * @param path 쿠키 경로
	 * @param maxAge 쿠키 저장시간
	 * @param cookieName 쿠키 명
	 * @param cookieValue 쿠키 값
	 */
	public static void createCookie(HttpServletResponse response, String path, int maxAge, String name,
			String value) {
		CookieGenerator cookieGenerator = new CookieGenerator();
		cookieGenerator.setCookiePath(path);
		cookieGenerator.setCookieMaxAge(maxAge);
		cookieGenerator.setCookieName(name);
		cookieGenerator.addCookie(response, value);

	}


	/**
	 * 쿠키삭제.
	 *
	 * @param response the response
	 * @param path 경로
	 * @param name the 쿠키명
	 */
	public static void removeCookie(HttpServletResponse response, String path, String name) {
		CookieGenerator cookieGenerator = new CookieGenerator();
		cookieGenerator.setCookiePath(path);
		cookieGenerator.setCookieMaxAge(0);
		cookieGenerator.setCookieName(name);
		cookieGenerator.addCookie(response, "");

	}

	/**
	 * 쿠키 값 가져오기.
	 * 
	 * @param request
	 *            the request
	 * @param cookieName
	 *            the cookie name
	 * @return the cooke value
	 */
	public static String getCookeValue(HttpServletRequest request, String cookieName) {

		Cookie cookie = WebUtils.getCookie(request, cookieName);

		if (cookie == null) {
			return null;
		} else {
			return cookie.getValue();
		}

	}

}

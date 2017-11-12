package stxship.dis.common.util;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import stxship.dis.common.constants.DisConstants;

/**
 * @파일명 : DisSessionUtil.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  세션 정보 관련 클레스
 *     </pre>
 */
public class DisSessionUtil {

	/**
	 * @메소드명 : getAuthenticatedUser
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 세션으로 부터 유저 정보를 취득한다.
	 * 유저정보가 없으면 NULL반환
	 *     </pre>
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getAuthenticatedUser() {
		Map<String, Object> result = new HashMap<String, Object>();
		Object userInfo = RequestContextHolder.getRequestAttributes().getAttribute(DisConstants.SESSION_LOGIN_USER_OBJ,
				RequestAttributes.SCOPE_SESSION);
		if (userInfo == null) {
			return null;
		}
		result = (Map<String, Object>) userInfo;

		return result;
	}

	/**
	 * @메소드명 : getUserId
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 세션으로 부터 유저아이디를 취득한다.
	 *     </pre>
	 * 
	 * @return
	 */
	public static String getUserId() {
		Map<String, Object> userInfo = getAuthenticatedUser();
		String userId = "";
		if (userInfo != null) {
			userId = userInfo.get(DisConstants.SESSION_LOGIN_ID).toString();
		}
		return userId;
	}

	/**
	 * @메소드명 : setLoginUserObject
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DB에서 취득한 로그인 유저정보를 세션에 저장
	 *     </pre>
	 * 
	 * @param loginUser
	 */
	public static void setLoginUserObject(Object loginUser) {
		RequestContextHolder.getRequestAttributes().setAttribute(DisConstants.SESSION_LOGIN_USER_OBJ, loginUser,
				RequestAttributes.SCOPE_SESSION);

	}

	/**
	 * @메소드명 : setObject
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 세션에 입력된 정보를 저장한다.
	 *     </pre>
	 * 
	 * @param key
	 * @param obj
	 */
	public static void setObject(String key, Object obj) {
		RequestContextHolder.getRequestAttributes().setAttribute(key, obj, RequestAttributes.SCOPE_SESSION);
	}

	/**
	 * @메소드명 : getObject
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 세션에 입력된 정보를 취득한다.
	 *     </pre>
	 * 
	 * @param key
	 * @return
	 */
	public static Object getObject(String key) {
		Object obj = RequestContextHolder.getRequestAttributes().getAttribute(key, RequestAttributes.SCOPE_SESSION);
		if (obj == null) {
			obj = "";
		}
		return obj;
	}

}

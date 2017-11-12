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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

// TODO: Auto-generated Javadoc
/**
 * The Class SessionUtils.
 */
public class SessionUtils {
	


	public static Map getAuthenticatedUser() {

		//return 
		Map userInfo = (Map) RequestContextHolder.getRequestAttributes().getAttribute("loginUser", RequestAttributes.SCOPE_SESSION);
		
		if (userInfo == null) {
			userInfo = new HashMap();
			
			userInfo.put("user_id",   "TestId1");
			userInfo.put("user_name", "testName");
		}
		
		return userInfo;
	}

	public static List<String> getAuthorities() {

		// 권한 설정을 리턴한다.
		List<String> listAuth = new ArrayList<String>();

		return listAuth;
	}

	public static Boolean isAuthenticated() {
		// 인증된 유저인지 확인한다.

		if (RequestContextHolder.getRequestAttributes() == null) {
			return false;
		} else {

			if (RequestContextHolder.getRequestAttributes().getAttribute(
					"loginUser", RequestAttributes.SCOPE_SESSION) == null) {
				return false;
			} else {
				return true;
			}
		}


	}
	public static String getUserId() {

		//return 
		Map userInfo=getAuthenticatedUser();
		String userId = "";
		if(userId!=null){
			userId	=	userInfo.get("user_id").toString();
		}
		return userId;
	}
	
	public static String getDwgDeptCode() {
		Map<String, String> userInfo = getAuthenticatedUser();
		String dwgDeptCode = "";
		if( dwgDeptCode != null ) {
			dwgDeptCode = StringUtil.nullString( userInfo.get( "dwgdeptcode" ) );
		}
		return dwgDeptCode;
	}

}

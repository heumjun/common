package com.stxdis.util.message;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.springframework.context.support.MessageSourceAccessor;

public class CommonMessage {
	
	/**
	* MessageSourceAccessor
	*/
	private static MessageSourceAccessor msAcc = null;

	public void setMessageSourceAccessor(MessageSourceAccessor msAcc) {
		this.msAcc = msAcc;
	}

	/**
	* KEY에 해당하는 메세지 반환
	* @param key
	* @return
	*/
	public static String getMessage(String key) {
		return msAcc.getMessage(key, Locale.getDefault());
	}

	/**
	* KEY에 해당하는 메세지 반환
	* @param key
	* @param objs
	* @return
	*/
	public static String getMessage(String key, Object[] objs) {
		return msAcc.getMessage(key, objs, Locale.getDefault());
	}
	
	
	@SuppressWarnings("unchecked")
	public static ArrayList DBOperation(String result, String key) {
		
		ArrayList arr = new ArrayList();
		
		if (key == null || "".equals(key)) {
			key = getDefaultKey(result);
		}
		
		Map 	  map = new HashMap() ;
				
		map.put("result", 	 	result);
		map.put("Result_Msg", 	getMessage(key));
		
		arr.add(map);
		
		return arr;
	}
	
	@SuppressWarnings("unchecked")
	public static ArrayList DBOperation(String result, String key, Object[] objs) {
		
		ArrayList arr = new ArrayList();
		
		if (key == null || "".equals(key)) {
			key = getDefaultKey(result);
		}

		Map 	  map = new HashMap() ;
		
		map.put("result", 	 	result);
		map.put("Result_Msg", 	getMessage(key, objs));
		
		arr.add(map);
		
		return arr;
	}
	
	@SuppressWarnings("unchecked")
	public static ArrayList MessageOperation(String result, String message) {
		
		ArrayList arr = new ArrayList();
		Map 	  map = new HashMap() ;
		
		map.put("result", 	 	result);
		map.put("Result_Msg", 	message);
		
		arr.add(map);
		
		return arr;
	}
	
	private static String getDefaultKey(String result) {
		
		String key = "";
		if ("success".equals(result)) {
			key = "common.default.succ";
		} else if ("fail".equals(result)) {
			key = "common.default.fail";
		} else if ("duplication".equals(result)) {
			key = "common.default.duplication";
		}
		
		return key;
	}

}





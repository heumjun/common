package stxship.dis.common.util;

import java.util.Map;

import org.apache.commons.collections.map.CaseInsensitiveMap;

/**
 * @파일명 : DisStringUtil.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 4.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  String Util을 구현
 *     </pre>
 */
public class DisStringUtil {
	/**
	 * @메소드명 : nullString
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * null 데이타는 "" 로 치환
	 *     </pre>
	 * 
	 * @param obj
	 * @return
	 */
	public static String nullString(Object obj) {
		String ret = "";

		ret = obj == null ? "" : obj.toString();

		return ret;
	}

	public static String setEmptyExt(String arg) {
		if (isNullString(arg))
			return "";
		else
			return arg;
	}

	public static boolean isNullString(String arg) {
		if (arg == null || arg.equals("") || arg.equalsIgnoreCase("null"))
			return true;
		else
			return false;
	}

	public static String setEmpty(String str) {
		String ret = "";
		if (str != null) {
			ret = str.trim();
		}
		return ret;
	}
	
	/**
	 * 
	 * @메소드명	: objectValueMapChangeString
	 * @날짜		: 2016. 11. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * Object value 형태의 map을 string value형태의 map으로 변경하여 리턴 
	 * CaseInsensitiveMap를 사용하여 대소문자 구분 필요 없는 상태로 리턴 및 앞뒤 문자 trim처리
	 * </pre>
	 * @param param
	 * @return
	 */
	public static Map<String,String> objectValueMapChangeString(Map<String,Object> param){
		Map<String,String> returnValue = new CaseInsensitiveMap();
		for(String key : param.keySet()){
			returnValue.put(key, nullString(param.get(key)).trim());
		}
		return returnValue;
	}
	public static Map<String,Object> stringValueMapChangeObject(Map<String,String> param){
		Map<String,Object> returnValue = new CaseInsensitiveMap();
		for(String key : param.keySet()){
			returnValue.put(key, param.get(key));
		}
		return returnValue;
	}
	 // isNumeric 
	public static boolean isNumeric(String text)  
    {
        if (text == null || text.trim().length() == 0) return false;
        
        for (int i = 0; i < text.length(); i++) {
            if (!Character.isDigit(text.charAt(i))) return false;
        }
        return  true;
    }

    // isAlphabet
	public static boolean isAlphabet(String text)  
    {
        if (text == null || text.trim().length() == 0) return false;
        
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122)) { ; /* skip */ } 
            else { return false; }
        }
        return true;
    }    
	
	// utility function : replaceAmpAll
	public static synchronized String replaceAmpAll(String str, String oldstr, String newstr) 
	{
		StringBuffer buf = new StringBuffer(); 
		int savedpos = 0; 

		while(true) { 
			int pos = str.indexOf(oldstr, savedpos); 
			if (pos != -1) { 
				buf.append(str.substring(savedpos, pos)); 
				buf.append(newstr); 
				savedpos = pos + oldstr.length(); 
				if(savedpos >= str.length()) break; 
			} 
			else break; 
		} 

		buf.append(str.substring(savedpos, str.length())); 
		return buf.toString(); 
	} 
}

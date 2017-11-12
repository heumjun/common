package com.stx.common.util;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/**
 * <pre>
 * 프로젝트명 : STX 기술로 프로젝트 PLM 구축
 * 시스템명   : 공통( COMMON )
 * 버전      : 1.0
 * 작성자     : 권진만
 * 작성일자   : 2005.01.25
 * V 1.0     : 최초 작성
 *             시스템 전반에서 사용되는 String 관련 유틸리티 메소드들을 정의한다.
 * </pre>
 * 
 * 기능 : String 관련된 것들을 처리한다. 사용처 : 시스템 전반
 *
 */
public class StringUtil {
	public StringUtil() {
	}

	/**
	 * String을 Empty 처리를 한다. null일경우는 ""를 리턴하고, 그렇지 않을 경우는 양쪽 스페이스를 없애고 리턴한다.
	 * 
	 * @param str
	 *            String 원본 String
	 * @return String 원본 String가 null일 경우 "" 그렇지 않을 경우 trim 된 String
	 */
	public static String setEmpty(String str) {
		String ret = "";
		if (str != null) {
			ret = str.trim();
		}
		return ret;
	}

	/**
	 * String 타입 변수가 아무 값을 가지지 않는지를 체크한다. 아무 값을 가지지 않는 다는 경우는 null, "", "null" 인
	 * 경우를 포함한다.
	 * 
	 * @param arg
	 *            체크할 String 타입 변수
	 * @return String 타입 변수가 아무 값을 가지지 않는 경우 true, 아니면 false
	 */
	public static boolean isNullString(String arg) {
		if (arg == null || arg.equals("") || arg.equalsIgnoreCase("null"))
			return true;
		else
			return false;
	}

	/**
	 * setEmpty() 메소드와 유사한 기능을 제공하는데, 값이 null인 경우 외에 "null"인 경우도 포함하여 처리한다. 단,
	 * trim() 기능은 제공하지 않는다.
	 * 
	 * @param str
	 *            String 원본 String
	 * @return String 원본 String가 null일 경우 "" 그렇지 않을 경우 trim 된 String
	 */
	public static String setEmptyExt(String arg) {
		if (isNullString(arg))
			return "";
		else
			return arg;
	}

	/**
	 *
	 * @param str
	 *            String
	 * @param len
	 *            int
	 * @return String
	 */
	public static String header(String str, int len) {
		return header(str, len, "");
	}

	/**
	 *
	 * @param str
	 *            String
	 * @param len
	 *            int
	 * @return String
	 */
	public static String header(String str, int len, String sFillPost) {
		str += getFillString(sFillPost, len);

		if (str.length() > len) {
			str = str.substring(0, len);
		}
		return str;
	}

	/**
	 *
	 * @param str
	 *            String
	 * @param len
	 *            int
	 * @return String
	 */
	public static String tail(String str, int len) {
		return tail(str, len, "");
	}

	public static String tail(String str, int len, String sFillPre) {
		str = getFillString(sFillPre, len) + str;

		if (str.length() > len) {
			len = str.length() - len;
			str = str.substring(len);
		}
		return str;
	}

	public static String getFillString(String sFill, int len) {
		String sRet = "";
		for (int i = 0; i < len; i++) {
			sRet += sFill;
		}
		return sRet;
	}

	/**
	 * sSource 문자열을 len만큼 잘라서 StringList에 담아 Return한다. 이때 한글이나 특수 문자가 섞여 있을 경우,
	 * 정확하게 len길이만큼 짤린다고 보장할 수 없다.
	 * 
	 * @param sSource
	 *            String
	 * @param len
	 *            int
	 * @return StringList
	 */
	public static ArrayList slice(String sSource, int len) {
		ArrayList slRet = new ArrayList();
		String sTmp = "";

		while (sSource.length() > 0) {
			sTmp = sSource.substring(0,
					sSource.length() < len ? sSource.length() : len);
			while (sTmp.getBytes().length > len) {
				sTmp = sTmp.substring(0, sTmp.length() - 1);
			}
			slRet.add(sTmp);
			sSource = sSource.substring(sTmp.length());
		}

		// sSource.getBytes()

		return slRet;
	}

	/**
	 * 공백을 리턴한다.
	 * 
	 * @param iLen
	 *            int 공백의 길이.
	 * @return String
	 */
	public static String SPACE(int iLen) {
		return StringUtil.header(" ", iLen);
	}

	public static String SPACE(int iLen, String sFill) {
		return StringUtil.header(sFill, iLen, sFill);
	}

	public static String replaceFirst(String sSource, String sTarget,
			String sReplace) {
		String sRet = sSource;
		int iIdx = sSource.indexOf(sTarget);
		if (iIdx > 0) {
			String sTmp = sSource.substring(0, iIdx);
			sTmp += sReplace;
			sTmp += sSource.substring(iIdx + sTarget.length());
			sRet = sTmp;
		}
		return sRet;
	}

	/**
	 * sSource가 Null이거나 ""이면 sTarget를 리턴한다.
	 * 
	 * @param sSource
	 *            String
	 * @param sTarget
	 *            String
	 * @return String
	 */
	public static String NVL(String sSource, String sTarget) {
		if ("".equals(setEmptyExt(sSource))) {
			return sTarget;
		} else {
			return sSource;
		}
	}

	/**
	 * 원본 문자열을 매치되는 문자(열)을 기준으로 잘라서 String[] 형태로 리턴한다. StringTokenizer와 다른 점은
	 * 공백에 해당하는 값도 포함된다는 것이며, JDK 1.4 이상의 String.split()에 해당된다고 보면 된다.
	 * 
	 * @param originalStr
	 *            처리할 원본 문자열
	 * @param matchStr
	 *            문자열을 자르는 기준(비교) 문자(열)
	 * @return String[]
	 */
	public static ArrayList split(String originalStr, String matchStr) {
		if (originalStr == null)
			return null;
		if (originalStr.trim().equals(""))
			return null;

		ArrayList resultList = new ArrayList();
		String originalStrBackup = originalStr;

		while (originalStr.indexOf(matchStr) >= 0) {
			resultList.add(originalStr.substring(0,
					originalStr.indexOf(matchStr)));
			originalStr = originalStr.substring(originalStr.indexOf(matchStr)
					+ matchStr.length());
		}
		if (originalStr != null && !originalStr.equals(""))
			resultList.add(originalStr);
		if (originalStrBackup.endsWith(matchStr))
			resultList.add("");
		return resultList;
		/***
		 * String[] resultArray = new String[resultList.size()]; for (int i = 0;
		 * i < resultList.size(); i++) { resultArray[i] =
		 * (String)resultList.get(i); }
		 * 
		 * return resultArray;
		 ***/
	}

	/**
	 * String.replace()의 확장으로 문자열 내에 일치하는 모든 항목을 변경한다. JDK 1.4 이상의
	 * String.replaceAll()에 해당된다고 보면 된다.
	 * 
	 * @param originalStr
	 *            처리할 원본 문자열
	 * @param fromStr
	 *            변경할 기존 문자(열)
	 * @param toStr
	 *            변경할 대상 문자(열)
	 * @return String
	 */
	public static String replaceAll(String originalStr, String fromStr,
			String toStr) {
		if (originalStr == null)
			return null;

		String resultStr = originalStr;

		while (resultStr.indexOf(fromStr) >= 0) {
			resultStr = resultStr.substring(0, resultStr.indexOf(fromStr))
					+ toStr
					+ resultStr.substring(resultStr.indexOf(fromStr)
							+ fromStr.length());
		}

		return resultStr;
	}

	public static String nullString(Object obj) {
		String ret = "";

		ret = obj == null ? "" : obj.toString();

		return ret;
	}

	public static String delSpace(String v) {
		if (v != null) {
			StringTokenizer sbt = new StringTokenizer(v, " ");
			StringBuffer sb = new StringBuffer();
			while (sbt.hasMoreElements()) {
				sb.append(sbt.nextToken());
			}
			return sb.toString();
		} else {
			return v;
		}
	}

}

/**
 * <pre>
 * 프로젝트명 : STX 기술로 프로젝트 PLM 구축
 * 시스템명 : Property 자료 읽기
 * 버젼 : 1.0
 * 작성자 : 박남열
 * 작성일자 : 2005/05/19
 * </pre>
 * 기능 : Property Class
 * @version 1.0
 */

package com.stx.common.util;

import java.io.IOException;
import java.util.Properties;
import java.util.StringTokenizer;

import stxship.dis.common.util.DisMessageUtil;

//import oracle.jdbc.driver.*;

public class STXPLMProperty {

	/*
	 * 사용예 : STXPLMProperty.getPLMProperty("stx_plm_system","PLM","RD");
	 * STXPLMProperty.getPLMProperty("stx_plm_system","PLM.RD");
	 * STXPLMProperty.getPLMPropertyList("stx_plm_system",
	 * "PLM.ITEM.CHECK.DISABLE.");
	 * 
	 * 위치: ".../ematrix/WEB-INF/classes/" Properties 파일 :
	 * stx_plm_system.properties
	 * 
	 */

	// public static final String SYSTEM_PLM = "PLM";

	/*private static Properties getPropFile(String p_strPropName) throws IOException, ClassNotFoundException {
		// 프로퍼티 객체 생성
		Properties prop = new Properties();
		try {
			// 읽을 property 파일 절대 경로.. = C:/DIS_PROPERTIES/
			StringBuffer strURL = new StringBuffer();
			strURL.append("C:/DIS_PROPERTIES/").append(p_strPropName).append(".properties");

			// 프로퍼티 파일 스트림에 담기
			FileInputStream fis = new FileInputStream(strURL.toString());
			// 프로퍼티 파일 로딩
			prop.load(new java.io.BufferedInputStream(fis));
			fis.close();
		} catch (Exception ee) {
			ee.printStackTrace();
			System.out.println("ERROR :: STXPLMProperty - getPropFile");
		}

		return prop;
		*//***
		 * //파일위치: WEB-INF\classes 에 존재해야함. StringBuffer strURL = new
		 * StringBuffer();
		 * strURL.append("/WEB-INF/").append(p_strPropName).append(".properties"
		 * );
		 * //strURL.append("/DIS/WEB-INF/config").append(p_strPropName).append(
		 * ".properties");
		 * 
		 * Properties prop = new Properties(); STXPLMProperty dbc = new
		 * STXPLMProperty(); InputStream ips =
		 * dbc.getClass().getResourceAsStream(strURL.toString());
		 * 
		 * prop.load(ips); ips.close(); return prop;
		 ***//*
	}*/

	public static String getInfoProperty(String p_strPropName, String p_str) throws IOException, Exception {

		Properties p = null;

		// p = getPropFile(p_strPropName);
		// p.list( System.out );

		// return p.getProperty(p_str);
		return DisMessageUtil.getMessage(p_str);
	}

	/*
	 * 용도 : properties에 존재하는 파일의 값을 가져온다. 매개변수: p_strPropName (파일명), : 프로퍼티가
	 * PLM.RD=XXXX 인경우 p_strMain 값(PLM), p_strSubo값(RD) 서버를 대입한다.
	 */
	public static String getPLMProperty(String p_strPropName, String p_strMain, String p_strSub)
			throws IOException, Exception {

		StringBuffer strInfo = new StringBuffer();
		strInfo.append(p_strMain).append(".").append(p_strSub);

		return getInfoProperty(p_strPropName, strInfo.toString());
	}

	/*
	 * 참조 : getPLMProperty 와 동일함.
	 */
	public static String getPLMProperty(String p_strPropName, String p_strMain, String p_strSub, String p_strSubDetail)
			throws IOException, Exception {

		StringBuffer strInfo = new StringBuffer();
		strInfo.append(p_strMain).append(".").append(p_strSub).append(".").append(p_strSubDetail);

		return getInfoProperty(p_strPropName, strInfo.toString());
	}

	/*
	 * 참조 : getPLMProperty 와 동일하며, p_str에 전체값을 넘겨준다.
	 */
	public static String getPLMProperty(String p_strPropName, String p_str) throws IOException, Exception {

		return getInfoProperty(p_strPropName, p_str);
	}

	/*
	 * 용도 : properties에 존재하는 파일의 값을 가져오며, 하위에 연결된 값을 모두 가져온다. 매개변수:
	 * p_strPropName (파일명), : PLM.ITEM.CHECK.DISABLE 에 항목을 가져온다.
	 * PLM.ITEM.CHECK.DISABLE.Z2=Z1 PLM.ITEM.CHECK.DISABLE.Z3=Z2,Z1
	 * PLM.ITEM.CHECK.DISABLE.Z4=ZZ3,Z2,Z1 PLM.ITEM.CHECK.DISABLE.Z5=Z4,Z3,Z2,Z1
	 *
	 */
	/*public static String[][] getPLMPropertyList(String p_strPropName, String p_strPrefix)
			throws IOException, Exception {

		String returnValue[][] = new String[1][2];
		Properties sysprops = null;
		int nPrefixLen = p_strPrefix.length();

		sysprops = getPropFile(p_strPropName);
		// p.list( System.out );

		// 배열개수를 구한다.
		int nCount = 0;
		for (Enumeration e = sysprops.propertyNames(); e.hasMoreElements();) {
			String key = (String) e.nextElement();

			if (key.startsWith(p_strPrefix)) {
				nCount++;
			}
		} // end for

		// 배열 초기화
		returnValue = new String[nCount][2];
		int nLoop = 0;

		// 배열을 대입을 한다.
		for (Enumeration e = sysprops.propertyNames(); e.hasMoreElements();) {
			String key = (String) e.nextElement();

			if (key.startsWith(p_strPrefix)) {
				String strGetKey = key.substring(nPrefixLen);
				String value = sysprops.getProperty(key);

				returnValue[nLoop][0] = strGetKey;
				returnValue[nLoop][1] = value;
				nLoop++;
				// System.out.println(strGetKey + "=" + value);
			}
		} // end for

		return returnValue;
	}*/

	// z3=Z1,Z2 일경우
	// Z3 Item으로 시작하는 것은 Z1,Z2 Item이 올 수 없음.
	public static boolean getPartNameCheck(String p_strPartName, String p_strChildPartName,
			String[][] p_strDisablePartName) throws IOException, Exception {

		// 상위Item과 하위Item이 동일할 경우
		if (p_strPartName.equals(p_strChildPartName))
			return false;

		boolean bOKCheck = true; // 디폴트값이 true

		for (int nX = 0; nX < p_strDisablePartName.length; nX++) {

			if (p_strPartName.startsWith(p_strDisablePartName[nX][0])) {
				// Child값 Check
				StringTokenizer sTok = new StringTokenizer(p_strDisablePartName[nX][1], ",");
				while (sTok.hasMoreTokens()) {
					String strDisableItem = sTok.nextToken();

					// System.out.println("nX="+nX+"#key="+p_strDisablePartName[nX][0]+"#value
					// token="+strDisableItem);

					// @ 마크는 뒤에 Item이 올 수 없다는 것.
					if (p_strChildPartName.startsWith(strDisableItem) || strDisableItem.equals("@")) {
						bOKCheck = false;
						break;
					}
				} // End of StringTokenizer sTok
			}
			// System.out.println("nX="+nX+"#key="+p_strDisablePartName[nX][0]+"#value="+p_strDisablePartName[nX][1]);
			if (bOKCheck == false)
				break;

		} // End of for p_strDisablePartName.length

		return bOKCheck;
	}

}

/*
 * @Class Name : StringUtils.java
 * @Description : org.apache.commons.lang.StringUtils extends  메소드 추가
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

import java.math.BigDecimal;
import java.util.Map;
import java.util.StringTokenizer;




// TODO: Auto-generated Javadoc
/**
 * The Class StringUtils.
 */
public class StringUtils extends org.apache.commons.lang.StringUtils  {
   
	/**
	 * 문자열 자르기 
	 *
	 * @param str the 문자
	 * @param len the 제한길이
	 * @param isAddDot the is '...'추가여부
	 * @return the string
	 */
	public static String cutString(String str, int len , boolean isAddDot  ) { 

		  byte[] by = str.getBytes();
		  int count = 0;
		  try  {
		   for(int i = 0; i < len; i++) {
		    if((by[i] & 0x80) == 0x80) count++;
		   }
		   if((by[len - 1] & 0x80) == 0x80 && (count % 2) == 1) len--;
		   
		   String returnValue = new String(by, 0, len) ;
		   if(isAddDot){
			   returnValue = returnValue + "...";
		   }
		   
		   return returnValue;   
		  }
		  catch(java.lang.ArrayIndexOutOfBoundsException e)
		  {
		   ////	System.out.println(e);
		   return str;
		  }
		 }


	/**
	 * String => double 형변환
	 *
	 * @param inputString the input 변환할 문자
	 * @param nullValue the null 값이 없을경우 리턴값
	 * @return the double null
	 */
	public static double getDoubleNull( String inputString, double nullValue )
	{
		try
		{
			if(inputString == null || inputString.equals("")) return nullValue;
			return Double.parseDouble(inputString);
		} catch(Exception e) {
			return nullValue;
		}
	}	

	/**
	 * String => int 형변환
	 *
	 * @param inputString the input 변환할 문자
	 * @param nullValue the null 값이 없을경우 리턴값
	 * @return the double null
	 */
	public static int getIntNull(String stText){
		try{
	  		if(stText == null || stText.equals("")) return 0;
	  		return Integer.parseInt(stText.trim());
		}
		catch(Exception e){
  		return 0;
		}

	}

	public static int getIntNull(String stText , int defaultVal){
		try{
	  		if(stText == null || stText.equals("")) return defaultVal;
	  		return Integer.parseInt(stText.trim());
		}
		catch(Exception e){
  		return defaultVal;
		}

	}
	public static String substring(String str, int end) { 
	  try  {

			str = getNull(str);
			if(str.length() > end){
				str = str.substring(end);
			}
			return str;
		
	  }
	  catch(java.lang.ArrayIndexOutOfBoundsException e)
	  {
	   //System.out.println(e);
	   return str;
	  }
	 }
	public static String substring(String str, int start, int end) { 
	  try  {
			str = getNull(str);
			if(str.length() > end){
				str = str.substring(start,end);
			}
			return str;
	  }
	  catch(java.lang.ArrayIndexOutOfBoundsException e)
	  {
	   //System.out.println(e);
	   return str;
	  }
	 }
	


	/**
	 *
	 * @param inputString the input 변환할 문자
	 * @return the String
	 */
  public static String getNull(String stText){
	    try{
	      if(stText == null || "null".equals(stText)) return "";

		      stText = replace(stText,"<" , "&lt;");
		      stText = replace(stText,">" , "&gt;");
		      stText = replace(stText,"\"" , "&quot;");
	      
	      return stText.trim();
	    }
	    catch(Exception e){
	      ////	System.out.println(e.toString());		
	      //e.printStackTrace();
	      return "";
	    }

	  }
  	/**
	 *
	 * @param str String
	 * @param len int
	 * @return String
	 */
	public static String header( String str, int len ) {
     return header( str, len, "" );
	 }
	
	 /**
	  *
	  * @param str String
	  * @param len int
	  * @return String
	  */
	 public static String header( String str, int len, String sFillPost ) {
	     str += getFillString( sFillPost, len );
	
	     if( str.length() > len ) {
	         str = str.substring( 0, len );
	     }
	     return str;
	 }
	
	 /**
		 *
		 * @param str String
		 * @param len int
		 * @return String
		 */
		public static String tail( String str, int len ) {
	     return tail( str, len, "" );
		}
	
	 public static String tail( String str, int len, String sFillPre ) {
	     str = getFillString( sFillPre, len ) + str;
	
	     if( str.length() > len ) {
	         len = str.length() - len;
	         str = str.substring( len );
	     }
	     return str;
	 }
	
	 public static String getFillString( String sFill, int len ) {
			String sRet = "";
	     for( int i = 0; i < len; i++ ) {
	         sRet += sFill;
	     }
	     return sRet;
	 }

	/**
	 *
	 * @param inputString the input 변환할 문자
	 * @return the String
	 */
public static String getNull(String stText , String defaultVal){
	    try{
	      if(stText == null || "null".equals(stText)) return defaultVal;

		      stText = replace(stText,"<" , "&lt;");
		      stText = replace(stText,">" , "&gt;");
		      stText = replace(stText,"\"" , "&quot;");
	      
	      return stText.trim();
	    }
	    catch(Exception e){
	      ////	System.out.println(e.toString());		
	      //e.printStackTrace();
	      return defaultVal;
	    }

	  }



  public static String iso8859(String strStr)
  throws java.io.UnsupportedEncodingException
  {
          if (strStr == null)
          {
                  return  null;
          }
          else
          {
                  return new String(strStr.getBytes("KSC5601"), "8859_1");
          }
  }


  public static String KSC5601_1(String strStr)  throws java.io.UnsupportedEncodingException
  {
          if (strStr == null)
          {
                  return  null;
          }
          else
          {
                  return new String(strStr.getBytes("8859_1"), "KSC5601");
          }
  }


  public static String KSC5601_2(String strStr)  throws java.io.UnsupportedEncodingException
  {
          if (strStr == null)
          {
                  return  null;
          }
          else
          {
                  return new String(strStr.getBytes("UTF-8"), "KSC5601");
          }
  }




  public static String utf8(String strStr)
  throws java.io.UnsupportedEncodingException
  {
          if (strStr == null)
          {
                  return  null;
          }
          else
          {
                  return new String(strStr.getBytes("KSC5601"), "UTF-8");
          }
  }


  public static String euckr(String strStr)
  throws java.io.UnsupportedEncodingException
  {
          if (strStr == null)
          {
                  return  null;
          }
          else
          {
                  return new String(strStr.getBytes("KSC5601"), "EUC-KR");
          }
  }
  
  public static String mapGetString(Map map, String colNm) {

		Object obj = map.get(colNm);
		
		if ( obj == null ) {			
			return "";
		} else {
			if (obj instanceof String) {
				return (String) obj;
			} else if (obj instanceof BigDecimal) {
				return  ((BigDecimal)map.get(colNm)).toString();
			} else if (obj instanceof Integer) {
				return ((Integer)map.get(colNm)).toString();
			} else if (obj instanceof Double) {
				return ((Double)map.get(colNm)).toString();
			} else {
				return (String) obj;
			}
		}
	}
  	 /** 2014 02-28 04:39 개발자 : 최유진
	  * 넘어온 문자열을 해당 구분자로 잘라 스트링배열으로 반환한다
	  * 예)
	  *     String[] result = divideString("A01,B01,C01", ",");
	  *     return "A01","B01","C01"
	  *
	  * @param    array - 문자열 조합
	  * @param    gubun - 구분자 문자
	  * @return   분리된 문자열 배열
	  */
	 public static String[] divideString1(String str, String gubun){

		  if( str == null ) return null;
		  String[] result = null;

		  StringTokenizer st = new StringTokenizer(str,gubun);
		  result = new String[st.countTokens()];
		  for(int i=0; st.hasMoreTokens(); i++)
		   result[i] = st.nextToken();
		  return result;
		 }
}
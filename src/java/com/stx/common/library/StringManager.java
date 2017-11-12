
package com.stx.common.library;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 * <p> 제목: String 관리 라이브러리</p> 
 * <p> 설명: String 관리 라이브러리</p> 
 * <p> Copyright: Copyright (c) 2013</p> 
 *@author 백재호
 *@date 2013. 08
 *@version 1.0
 */
public class StringManager { 
    
    /**
    * 해당 문자열에서 older String 을 newer String 으로 교체한다.
    @param original 전체 String
    @param older 전체 String 중 교체 전 문자 String
    @param newer 전체 String 중 교체 후 문자 String
    @return result 교체된 문자열을 반환함
    */
    public static String replace(String original, String older, String newer) { 
        String result = original;
        
        if ( original != null ) { 
            int idx = result.indexOf(older);
            int newLength = newer.length();

            while ( idx >= 0 ) { 
                if ( idx == 0 ) { 
                    result = newer + result.substring(older.length() );
                }else { 
                    result = result.substring(0, idx) + newer + result.substring(idx + older.length() );
                }
                idx = result.indexOf(older, idx + newLength);
            }
        }

        return result;
    }
    
    /**
    * java.lang.String 패키지의 trim() 메소드와 기능은 동일, null 체크만 함
    @param str 전체 문자열
    @return result  trim 된 문자열을 반환함
    */
    public static String trim(String str) throws Exception { 
        String result = "";
        
        if ( str != null ) 
            result = str.trim();
            
        return result;
    }
    
    /**
    * java.lang.String 패키지의 substring() 메소드와 기능은 동일, null 체크만 함
    @param str 전체 문자열
    @param beginIndex 
    @param endIndex 
    @return result  substring 된 문자열을 반환함
    */
    public static String substring(String str, int beginIndex, int endIndex) { 
        String result = "";

        if ( str != null ) 
            result = str.substring(beginIndex, endIndex);
        
        return result;
    }
    
    
    /**
    * java.lang.String 패키지의 substring() 메소드와 기능은 동일, null 체크만 함
    @param str 전체 문자열
    @param beginIndex 
    @return result  substring 된 문자열을 반환함
    */
    public static String substring(String str, int beginIndex) { 
        String result = "";

        if ( str != null ) 
            result = str.substring(beginIndex);
            
        return result;
    }
    
    /**
    *java.lang.String 패키지의 substring() 메소드와 기능은 동일한데 오른쪽 문자끝부터 count 를 해서 자름
    @param str 전체 문자열
    @param count  오른쪽 문자끝(1) 부터 count 까지 
    @return result  substring 된 문자열을 반환함
    */
    public static String rightstring(String str, int count) throws Exception { 
        if ( str == null ) return null;
        
        String result = null;
        try { 
            if ( count == 0)     //      갯수가 0 이면 공백을 
                result = "";
            else if ( count > str.length() )    //  문자열 길이보다 크면 문자열 전체를
                result = str;
            else
                result = str.substring(str.length()-count,str.length() );  //  오른쪽 count 만큼 리턴
        } catch ( Exception ex ) { 
            throw new Exception("StringManager.rightstring(\"" +str + "\"," +count + ")\r\n" +ex.getMessage() );
        }

        return result;
    }
    
     /**
    * null 체크
    @param str 전체 문자열
    @return str  null 인경우 "" 을, 아니면 원래의 문자열을 반환한다.
    */
    public static String chkNull(String str) { 
        if ( str == null ) 
            return "";
        else 
            return str;
    }
    
     /**
    * String 형을 int 형으로 변환, null 및 "" 체크
    @param str 전체 문자열
    @return null 및 "" 일 경우 0 반환
    */
    public static int toInt(String str) { 
        if ( str == null || str.equals("")) 
            return 0;
        else 
            return Integer.parseInt(str);
    }
    
     /**
    * Base64로 암호화
    @param str 전체 문자열
    @return Base64로 암호화된 문자열
    */
    public static String BASE64Encode(String str) { 
        String result = "";
        BASE64Encoder encoder;
    
        try { 
            encoder = new BASE64Encoder(); 
            result = encoder.encode(str.getBytes() );
        } catch( Exception e ) { }    
        return result;
    }
  
     /**
    * Base64로 복호화
    @param str 전체 문자열
    @return Base64로 복호화된 문자열
    */
    public static String BASE64Decode(String str) { 
        String result = "";
        BASE64Decoder decoder;
    
        try { 
            decoder = new BASE64Decoder(); 
            result = new String(decoder.decodeBuffer(str)); 
        } catch( Exception e ) { }
        
        return result;
    }  
  
     /**
    * URLEncoder 로 암호화
    @param str 전체 문자열
    @return URLEncoder로 복호화된 문자열
    */
    public static String URLEncode(String str) throws Exception {      
        String result = "";
        try { 
            if ( str != null )
                result = URLEncoder.encode(str);
        } catch ( Exception ex ) { 
            throw new Exception("StringManager.URLEncode(\"" +str + "\")\r\n" +ex.getMessage() );
        }

        return result;
    }  
    
    public static String korEncode(String str) throws UnsupportedEncodingException { 
        if ( str == null ) return null;
        return new String(str.getBytes("8859_1"), "KSC5601");           
    }
    
    public static String engEncode(String str) throws UnsupportedEncodingException { 
        if ( str == null ) return null; 
        return new String(str.getBytes("KSC5601"), "8859_1");   
    }
        
    /** 
    * SQL Query 문에서 value 값의 ' ' 를 만들어 주기 위한 메소드
    @param str   ' ' 안에 들어갈 변수 값
    @return   'str' 로 리턴됨
    */
    public static String makeSQL(String str) { 
        String result = "";
        if ( str != null ) 
            str = replace(str, "--", "");
            str = replace(str, "+", "");
            //str = replace(str, "/", "");
            str = replace(str, "\\", "");
            str = replace(str, "&", "&amp;");
            str = replace(str, "*", "");
            
            result = "'" + chkNull(replace(str, "'", "''")) + "'";
        return result;
    } 
    /** 
     * SQL Query 문에서 value 값의 ' ' 를 만들어 주기 위한 메소드
     @param str   ' ' 안에 들어갈 변수 값
     @return   'str' 로 리턴됨
     */
     public static String ScriptReplace(String str) { 
         String result = "";
         if ( str != null ){        	 
             str = replace(str, "&", "&amp;");    
             str = replace(str, "<", "&lt;");
             str = replace(str, ">", "&gt;");
             str = replace(str, "\"", "&quot;");
             result = chkNull(str);
         }
         return result;
     } 
    /** 
    * 제목을 보여줄때 제한된 길이를 초과하면 뒷부분을 짜르고 "..." 으로 대치한다.
    @param title(제목등의 문자열), max(최대길이)
    @return title(변경된 문자열)
    */  
    public static String formatTitle(String title, int max) { 
        if ( title == null ) return null;
        
        if ( title.length() <= max)
            return title;
        else
            return title.substring(0,max-3) + "...";
    }       
    
    /** 
    * 제목을 보여줄때 제한된 길이를 초과하면 뒷부분을 짜르고 "..." 으로 대치한다.
    @param title(제목등의 문자열), max(최대길이)
    @return title(변경된 문자열)
    */  
    public static String cutZero(String seq) { 
        String result = "";
    
        try { 
            result = Integer.parseInt(seq) + "";
        } catch( Exception e ) { }    
        return result;
    }
    
    /**
     * 통화형으로 변환한다.
     * @param price
     * @return
     */
    public static String priceComma(Object price){        
        
        double ddb = 0.00;
        try{
            ddb = Double.parseDouble(price.toString());
        } catch (Exception e) {
            return "";
        }
        if(ddb == 0.00) return "";
        
        DecimalFormat df = new DecimalFormat(",###.##");
        
        return df.format(ddb);
    }  
    
    public static String getComma(String str)
    {
        return getComma(str, true);
    }

    public static String getComma(String str, boolean isTruncated)
    {
        if(str == null)
            return "0";
        if(str.trim().equals(""))
            return "0";
        if(str.trim().equals("&nbsp;"))
            return "&nbsp;";
        int pos = str.indexOf(".");
        if(pos != -1)
        {
            if(!isTruncated)
            {
                DecimalFormat commaFormat = new DecimalFormat("#,##0.00");
                return commaFormat.format(Float.parseFloat(str.trim()));
            } else
            {
                DecimalFormat commaFormat = new DecimalFormat("#,##0");
                return commaFormat.format(Long.parseLong(str.trim().substring(0, pos)));
            }
        } else
        {
            DecimalFormat commaFormat = new DecimalFormat("#,##0");
            return commaFormat.format(Long.parseLong(str.trim()));
        }
    }

    public static String getComma(Long lstr)
    {
        DecimalFormat commaFormat = new DecimalFormat("#,##0");
        if(lstr == null)
            return "0";
        else
            return commaFormat.format(lstr);
    }
    
    public static String juminno(String str)
    {
        String ret = "";
        
        try {
            if ( str != null || str.length() == 13 ) {
                ret = str.substring(0,6) + "-" + str.substring(6);
            }
        } catch (Exception e) { }
        return ret;
    }   
    
}


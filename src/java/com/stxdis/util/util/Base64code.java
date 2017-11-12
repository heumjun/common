package com.stxdis.util.util;

public class Base64code {
	
	@SuppressWarnings("restriction")
	public static String base64Encode(String str)  throws java.io.IOException {
		   if ( str == null || str.equals("") ) {
		      return "";
		   } else {
		      sun.misc.BASE64Encoder encoder = new sun.misc.BASE64Encoder();
		      byte[] b1 = str.getBytes();
		      String result = encoder.encode(b1);
		      return result;
		   }
		 }

	@SuppressWarnings("restriction")
	public static String base64Decode(String str)  throws java.io.IOException {
		   if ( str == null || str.equals("") ) {
		      return "";
		   } else {
		      sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
		      byte[] b1 = decoder.decodeBuffer(str);
		      String result = new String(b1);
		      return result;
		   }
		 }  
	
}

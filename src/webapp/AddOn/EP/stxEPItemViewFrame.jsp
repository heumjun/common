<%--  
§DESCRIPTION: EP 부품표준서 메인 프레임 (분류별보기)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPItemViewFrame.jsp
--%>

<%@ page import = "javax.crypto.Cipher"%>
<%@ page import = "javax.crypto.spec.IvParameterSpec"%>
<%@ page import = "javax.crypto.spec.SecretKeySpec"%>
<%@ page import = "sun.misc.BASE64Decoder"%>
<%@ page import = "sun.misc.BASE64Encoder"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%!

	// EP Parameter 전송 복호화 변수
	private static final String ENC_PARA_FORMAT   = "DES/CBC/PKCS5Padding";
	private static final String PARA_KEY          = "STX^ONS7";   // 각 사 또는 시스템별로 정의된 KEY ( EP와 정의된 값 ) : 조선해양
	private static final String IV                = "OS$37INF";   // 각 사 또는 시스템별로 정의된 IV ( EP와 정의된 값 )  : 조선해양

	// EP Cookie 복호화 변수
	private static final String ENC_COOKIE_FORMAT = "DES/ECB/PKCS5Padding";
	private static final String COOKIE_KEY        = "Forcetec";   // ONESTX EP 공통 KEY

	private static final String UTF_8 = "UTF-8";

	private static BASE64Encoder ENCORDER          = new BASE64Encoder();
	private static BASE64Decoder DECORDER          = new BASE64Decoder();

	
	// EP Parameter 암호화 Method ( DES/CBC모드) - 사용안함 ( EP에서 암호화 해서 넘겨 줌.)
	public static String encrypt(String value) {

		SecretKeySpec   SecureKey     = new SecretKeySpec(PARA_KEY.getBytes(), "DES");
		IvParameterSpec InitialVector = new IvParameterSpec(IV.getBytes());
		String          encrypt       = "";

		try {

			Cipher ecipher = Cipher.getInstance(ENC_PARA_FORMAT);
			
			// ciphers 생성
			ecipher.init(Cipher.ENCRYPT_MODE, SecureKey, InitialVector);
			
			byte[] byte_enc = value.getBytes(UTF_8);
			
			// Encrypt
			byte[] enc = ecipher.doFinal(byte_enc);

			encrypt = ENCORDER.encode(enc);

		} catch (Exception e) {

			System.out.println("encrypt==>"+ e.getMessage());
		}

		return encrypt;
	}

	
	// EP Parameter 복호화 Method ( DES/CBC모드) 
	public static String decrypt(String value) {

		SecretKeySpec   SecureKey     = new SecretKeySpec(PARA_KEY.getBytes(), "DES");
		IvParameterSpec InitialVector = new IvParameterSpec(IV.getBytes());
		String          decrypt       = "";

		try {

			Cipher dcipher = Cipher.getInstance(ENC_PARA_FORMAT);
			
			// ciphers 생성
			dcipher.init(Cipher.DECRYPT_MODE, SecureKey, InitialVector);
			
			// EP 
			byte[] dec      = DECORDER.decodeBuffer(value);
			// Decrypt
			byte[] byte_dec = dcipher.doFinal(dec);

			decrypt = new String(byte_dec, UTF_8);

		} catch (Exception e) {

			System.out.println("decrypt==>"+ e.getMessage());
		}

		return decrypt;
	}
	

	
	// EP Cookie 암호화 Method ( DES/ECB모드) - 사용안함 ( EP에서 Cookie 암호화 해서 Set 해줌.)
	public static String encryptCookie(String value) {

		SecretKeySpec   SecureKey     = new SecretKeySpec(COOKIE_KEY.getBytes(), "DES");
		String          encrypt       = "";

		try {

			Cipher ecipher = Cipher.getInstance(ENC_COOKIE_FORMAT);
			
			// ciphers 생성
			ecipher.init(Cipher.ENCRYPT_MODE, SecureKey);
			
			byte[] byte_enc = value.getBytes(UTF_8);
			
			// Encrypt
			byte[] enc = ecipher.doFinal(byte_enc);

			// EP에서 Encode 후 UrlEncode 해서 넘기므로 동일하게. 한번더 UTF8로 ENCODE 한다.
			encrypt = java.net.URLEncoder.encode(ENCORDER.encode(enc), UTF_8);   

		} catch (Exception e) {

			System.out.println("encryptCookie==>"+ e.getMessage());
		}

		return encrypt;
	}
	
	
	// EP Cookie 복호화 Method ( DES/ECB모드)
	public static String decryptCookie(String value) {


		SecretKeySpec SecureKey  = new SecretKeySpec(COOKIE_KEY.getBytes(), "DES");
		String decrypt = "";

		try {

			Cipher dcipher = Cipher.getInstance(ENC_COOKIE_FORMAT);

			// ciphers 생성
			dcipher.init(Cipher.DECRYPT_MODE, SecureKey);
			
			// EP ( C# ) 에서 암호화된 값을 UrlEncode 해서 넘기므로 
			// JAVA에서 URLDecoder 처리하여. base64 Decode 처리해 준다.
			byte[] dec = DECORDER.decodeBuffer(java.net.URLDecoder.decode(value, UTF_8));
			
			// Decrypt
			byte[] byte_dec = dcipher.doFinal(dec);

			decrypt = new String(byte_dec) ;
			
		} catch (Exception e) {

			System.out.println("decryptCookie==>"+ e.getMessage());
		}
		return decrypt;
	}
	
%>

<%  // 품목 부품표준서 view Frame 

    String loginID = request.getParameter("loginID");
    System.out.println("~~~ loginID = "+loginID);
    loginID = "209452";
    System.out.println("~~~ loginID1 = "+loginID);
/** test 임시제거
	String cipherloginID = request.getParameter("loginID");	
	System.out.println("~~~ cipherloginID = "+cipherloginID);

	// 2013-04-19 Kang seonjung : EP 에서 파라미터로 넘어온 사번이 DES 방식으로 암호화가 되어있어서 복호화함.
	String loginID = decrypt(cipherloginID);
	System.out.println("~~~ loginID = "+loginID);


	//최초 접속이후(암호화된 사번) 재호출된 경우 파라미터로 복호화된 사번 넘겨줌 (사번 복호화 시 에러로 인한 리턴 불가 건 조치)
String cipherloginID = "";
	if("".equals(loginID)) loginID =  cipherloginID;
**/	
	
	String frameTop  	= "stxEPInfoItemTopInclude.jsp?loginID="+loginID;
	String frameLevel_1  	= "stxEPItemViewLevel_1.jsp";
	String frameLevel_2   	= "stxEPItemViewLevel_2.jsp";
    String frameLevel_3   	= "stxEPItemViewLevel_3.jsp?loginID="+loginID;

%>

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<style type="text/css">
A:link {color:black; text-decoration: none}
A:visited {color:black; text-decoration: none}
A:active {color:green; text-decoration: none ; font-weight : bold;}
A:hover {color:red;text-decoration:underline font-weight : bold;}
.title_1			{font-family:"굴림체"; font-Size: 12pt; font-weight: bold;}
.title_2			{font-family:"굴림체"; font-Size: 11pt; font-weight: bold;}
.title_3			{font-family:"굴림체"; font-Size: 10pt; font-weight: bold;}
.title_4			{font-family:"굴림체"; font-Size: 9pt; font-weight: bold;}
.title_5			{font-family:"굴림체"; font-Size: 11pt;}
.title_6			{font-family:"굴림체"; font-Size: 10pt;}
.title_7			{font-family:"굴림체"; font-Size: 9pt;}
.title_8			{font-family:"굴림체"; font-Size: 8pt;}
.button_simple {font-size: 9pt;	font-weight: bold; height: 23px; width: 90px; }
</style>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">

<form name="frmFrame" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr height="30">
        <td>
            <iframe name="FRAME_TOP" src="<%=frameTop%>" width="100%" height="28" frameborder="0" scrolling=no>  </iframe> 
        </td>
    </tr>

    <tr height="44">
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="2%">&nbsp;</td>
                    <td align="left">        
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td height="5" colspan="2"></td>
                            </tr>
                            <tr height="30"> 
                                <td style="padding-left:0" valign="middle" width="12">
                                    <img src="images/title_icon.gif">
                                </td>
                                <td class="title_1" style="padding-left:3" valign="middle">
                                    &nbsp;STX조선해양 부품표준서  
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" class="button_simple" name="searchMode" value="전체보기" onclick="searchModePageLoad();">    
                                </td>  
                            </tr>
                            <tr height="4" >
                                <td background="images/title_line.gif" colspan="2"></td>
                            </tr>
                            <tr>
                                <td height="5" colspan="2"></td>
                            </tr>
                        </table>
                    </td>
                 </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="2%">&nbsp;</td>
                    <td width="30%">
                        <iframe name="FRAME_LEVEL_1" src="<%=frameLevel_1%>" width="100%" height="550" frameborder="0"></iframe> 
                    </td>
                    <td width="30%">
                        <iframe name="FRAME_LEVEL_2" src="<%=frameLevel_2%>" width="100%" height="550" frameborder="0"></iframe> 
                    </td>
                    <td width="38%">
                        <iframe name="FRAME_LEVEL_3" src="<%=frameLevel_3%>" width="100%" height="550" frameborder="0"></iframe> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

<script language="javascript">
    function searchModePageLoad()
    {
        var url = "stxEPItemViewFrame_1.jsp?loginID=<%=loginID%>";
        document.location.href = url;
    }
</script>
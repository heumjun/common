<%--  
��DESCRIPTION: EP ��ǰǥ�ؼ� ���� ������ (�з�������)
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxEPItemViewFrame.jsp
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

	// EP Parameter ���� ��ȣȭ ����
	private static final String ENC_PARA_FORMAT   = "DES/CBC/PKCS5Padding";
	private static final String PARA_KEY          = "STX^ONS7";   // �� �� �Ǵ� �ý��ۺ��� ���ǵ� KEY ( EP�� ���ǵ� �� ) : �����ؾ�
	private static final String IV                = "OS$37INF";   // �� �� �Ǵ� �ý��ۺ��� ���ǵ� IV ( EP�� ���ǵ� �� )  : �����ؾ�

	// EP Cookie ��ȣȭ ����
	private static final String ENC_COOKIE_FORMAT = "DES/ECB/PKCS5Padding";
	private static final String COOKIE_KEY        = "Forcetec";   // ONESTX EP ���� KEY

	private static final String UTF_8 = "UTF-8";

	private static BASE64Encoder ENCORDER          = new BASE64Encoder();
	private static BASE64Decoder DECORDER          = new BASE64Decoder();

	
	// EP Parameter ��ȣȭ Method ( DES/CBC���) - ������ ( EP���� ��ȣȭ �ؼ� �Ѱ� ��.)
	public static String encrypt(String value) {

		SecretKeySpec   SecureKey     = new SecretKeySpec(PARA_KEY.getBytes(), "DES");
		IvParameterSpec InitialVector = new IvParameterSpec(IV.getBytes());
		String          encrypt       = "";

		try {

			Cipher ecipher = Cipher.getInstance(ENC_PARA_FORMAT);
			
			// ciphers ����
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

	
	// EP Parameter ��ȣȭ Method ( DES/CBC���) 
	public static String decrypt(String value) {

		SecretKeySpec   SecureKey     = new SecretKeySpec(PARA_KEY.getBytes(), "DES");
		IvParameterSpec InitialVector = new IvParameterSpec(IV.getBytes());
		String          decrypt       = "";

		try {

			Cipher dcipher = Cipher.getInstance(ENC_PARA_FORMAT);
			
			// ciphers ����
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
	

	
	// EP Cookie ��ȣȭ Method ( DES/ECB���) - ������ ( EP���� Cookie ��ȣȭ �ؼ� Set ����.)
	public static String encryptCookie(String value) {

		SecretKeySpec   SecureKey     = new SecretKeySpec(COOKIE_KEY.getBytes(), "DES");
		String          encrypt       = "";

		try {

			Cipher ecipher = Cipher.getInstance(ENC_COOKIE_FORMAT);
			
			// ciphers ����
			ecipher.init(Cipher.ENCRYPT_MODE, SecureKey);
			
			byte[] byte_enc = value.getBytes(UTF_8);
			
			// Encrypt
			byte[] enc = ecipher.doFinal(byte_enc);

			// EP���� Encode �� UrlEncode �ؼ� �ѱ�Ƿ� �����ϰ�. �ѹ��� UTF8�� ENCODE �Ѵ�.
			encrypt = java.net.URLEncoder.encode(ENCORDER.encode(enc), UTF_8);   

		} catch (Exception e) {

			System.out.println("encryptCookie==>"+ e.getMessage());
		}

		return encrypt;
	}
	
	
	// EP Cookie ��ȣȭ Method ( DES/ECB���)
	public static String decryptCookie(String value) {


		SecretKeySpec SecureKey  = new SecretKeySpec(COOKIE_KEY.getBytes(), "DES");
		String decrypt = "";

		try {

			Cipher dcipher = Cipher.getInstance(ENC_COOKIE_FORMAT);

			// ciphers ����
			dcipher.init(Cipher.DECRYPT_MODE, SecureKey);
			
			// EP ( C# ) ���� ��ȣȭ�� ���� UrlEncode �ؼ� �ѱ�Ƿ� 
			// JAVA���� URLDecoder ó���Ͽ�. base64 Decode ó���� �ش�.
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

<%  // ǰ�� ��ǰǥ�ؼ� view Frame 

    String loginID = request.getParameter("loginID");
    System.out.println("~~~ loginID = "+loginID);
    loginID = "209452";
    System.out.println("~~~ loginID1 = "+loginID);
/** test �ӽ�����
	String cipherloginID = request.getParameter("loginID");	
	System.out.println("~~~ cipherloginID = "+cipherloginID);

	// 2013-04-19 Kang seonjung : EP ���� �Ķ���ͷ� �Ѿ�� ����� DES ������� ��ȣȭ�� �Ǿ��־ ��ȣȭ��.
	String loginID = decrypt(cipherloginID);
	System.out.println("~~~ loginID = "+loginID);


	//���� ��������(��ȣȭ�� ���) ��ȣ��� ��� �Ķ���ͷ� ��ȣȭ�� ��� �Ѱ��� (��� ��ȣȭ �� ������ ���� ���� �Ұ� �� ��ġ)
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
.title_1			{font-family:"����ü"; font-Size: 12pt; font-weight: bold;}
.title_2			{font-family:"����ü"; font-Size: 11pt; font-weight: bold;}
.title_3			{font-family:"����ü"; font-Size: 10pt; font-weight: bold;}
.title_4			{font-family:"����ü"; font-Size: 9pt; font-weight: bold;}
.title_5			{font-family:"����ü"; font-Size: 11pt;}
.title_6			{font-family:"����ü"; font-Size: 10pt;}
.title_7			{font-family:"����ü"; font-Size: 9pt;}
.title_8			{font-family:"����ü"; font-Size: 8pt;}
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
                                    &nbsp;STX�����ؾ� ��ǰǥ�ؼ�  
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" class="button_simple" name="searchMode" value="��ü����" onclick="searchModePageLoad();">    
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
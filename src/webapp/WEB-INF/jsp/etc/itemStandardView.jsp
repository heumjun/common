<%--  
§DESCRIPTION: EP 부품표준서 메인 프레임 (분류별보기)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPItemViewFrame.jsp
--%>
<%@ page import = "java.util.*" %>
<%@ page import = "javax.crypto.Cipher"%>
<%@ page import = "javax.crypto.spec.IvParameterSpec"%>
<%@ page import = "javax.crypto.spec.SecretKeySpec"%>
<%@ page import = "sun.misc.BASE64Decoder"%>
<%@ page import = "sun.misc.BASE64Encoder"%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

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
	Map loginUser = (Map) request.getSession().getAttribute("loginUser");
	// String loginID = SessionUtils.getUserId();
	String loginID = (String) loginUser.get("user_id");
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
	
	String frameLevel_1  	= "itemStandardViewLevel1.do";
	String frameLevel_2   	= "itemStandardViewLevel2.do";
    String frameLevel_3   	= "itemStandardViewLevel3.do?loginID="+loginID;
    String frameSearch   	= "itemStandardViewSearch.do?loginID="+loginID;
    
%>

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
    <style type="text/css">
		A:link {color:black; text-decoration: none}
		A:visited {color:black; text-decoration: none}
		A:active {color:green; text-decoration: none ; font-weight : bold;}
		A:hover {color:red;text-decoration:underline; font-weight : bold;}
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
	<script type="text/javascript">
	var menuId = '';
	
	function emsDbMasterLink() {
		//메뉴ID를 가져오는 공통함수 
		getMenuId("emsDbMaster.do", callback_MenuId);
		
		location.href='emsDbMasterLink.do?etc=Y&menu_id='+menuId;
	}
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
	
	</script>
</head>


<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		STX조선해양 부품표준서
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	<table class="searchArea conSearch">
		<tr>
			<td>
				<div class="button endbox">
					<input type="button" class="btn_blue" name="searchMode" value="기준정보 등록요청" onclick="location.href='standardInfoTrans.do'">
					<input type="button" class="btn_blue" name="searchMode" value="품목분류표" onclick="location.href='itemCategoryView.do'">
					<!-- menu_id=M00123 메뉴 ID 값 하드코딩 처리 2017-03-09 -->
					<input type="button" class="btn_blue" name="searchMode" value="기자재통합기준정보관리" onclick="javascript:emsDbMasterLink();">
<!-- 					<input type="button" class="btn_blue" name="searchMode" value="양식지&메뉴얼" onclick="location.href='documentView.do'"> -->
				</div>
			</td>
		</tr>
	</table>
	<form name="frmFrame" method="post" >
	<input type="hidden" name="loginID" value="<%=loginID%>">
	<div id="tabs" style = "margin-top:10px">
		<ul>
			<li><a id="a_tab1" href="#tabs-1" >분류별 보기</a></li>
			<li><a id="a_tab2" href="#tabs-2" >검색 보기</a></li>
		</ul>
		<div id="tabs-1">
			<table>
             <tr>
                 <td>
                 	<fieldset style="border:none;margin-top:2px;padding:0 10px 0 0">
					<legend  class="sc_tit2">대분류</legend>
					<iframe name="FRAME_LEVEL_1" id="FRAME_LEVEL_1" src="<%=frameLevel_1%>" width="100%" frameborder="0"></iframe>
					</fieldset>
                 </td>
                 <td>
                 	<fieldset style="border:none;margin-top:2px;">
					<legend  class="sc_tit2">중분류</legend>
					<iframe name="FRAME_LEVEL_2" id="FRAME_LEVEL_2" src="<%=frameLevel_2%>" width="100%" frameborder="0"></iframe>
					</fieldset>
                 </td>
                 <td>
	                 <fieldset style="border:none;margin-top:2px;padding:0 0 0 10px">
					<legend  class="sc_tit2">소분류</legend>
					<iframe name="FRAME_LEVEL_3" id="FRAME_LEVEL_3" src="<%=frameLevel_3%>" width="100%" frameborder="0"></iframe>
					</fieldset>
                 </td>
             </tr>
         </table>
		</div>
		<div id="tabs-2">
			<iframe name="FRAME_SEARCH" id="FRAME_SEARCH" src="<%=frameSearch%>" width="100%" frameborder="0" style="" scrolling="no"></iframe>
		</div>
	</div>
	</form>
</div>

</body>
</html>

<script language="javascript">
	$(function() {    $( "#tabs" ).tabs();  });
    function searchModePageLoad()
    {
        var url = "stxEPItemViewFrame_1.jsp?loginID=<%=loginID%>";
        document.location.href = url;
    }
    $(document).ready(function(){
    	$(window).bind('resize', function() {
        	$('#tabs').css('height', $(window).height()-170);
    		$('#FRAME_LEVEL_1').css('height', $(window).height()-230);
    		$('#FRAME_LEVEL_2').css('height', $(window).height()-230);
    		$('#FRAME_LEVEL_3').css('height', $(window).height()-230);
    		$('#FRAME_SEARCH').css('height', $(window).height()-200);
    		
         }).trigger('resize');
    });
    
    function OpenUrl(url){
        location.href = url;
    }
</script>
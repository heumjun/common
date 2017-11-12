<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Dwg PopUp View</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

<script src="http://dwgprint.stxons.com/dsv/DSViewerAX.js"></script>
<script type="text/javascript" src="/js/stxAjax.js"></script>
<script type="text/javascript" src="/js/SecurePM3AX2.js"></script>
</head>
<body>
<input type="hidden" id="mode" name="mode" value="<c:out value="${mode}" />" />
<input type="hidden" id="fileName" name="fileName" value="<c:out value="${p_file_name}" />" />
<input type="hidden" id="vEmpNo" name="vEmpNo" value="<c:out value="${loginId}" />" />
<input type="hidden" id="user_id" name="user_id" value="<c:out value="${loginId}" />" />
<input type="hidden" name="p_daoName"  />
<input type="hidden" name="p_queryType"  />
<input type="hidden" name="p_process" />
</body>
<script type="text/javascript">
$(document).ready(function(){
	var vFileName = $("#fileName").val();
	var mode = $("#mode").val();
	var vEmpNo = $("#vEmpNo").val();
	var user_id = $("#user_id").val();
	var vReturn = getDWGXML("dwgPopupViewList.do?VIEWMODE="+mode+"&P_FILE_NAME="+vFileName+"&vEmpNo="+user_id);
	
	//vReturn = '<?xml version="1.0" encoding="utf-8" ?><DSVX version="1.0"><LOG item01="82" item02="211055" item03="양동협" item04="4" item05="설계운영팀" item06="4" item07="설계운영팀" item08="" item09="" item10="" item11="" item12="" item13="VIEW" item14="1" item15="PLM" item16="PLM" item17="" item18="PLMLIVE" item19="20161110" item20="" item21="" item22="" item23="" item24="" item25=""  /><SCREEN_MARKUP><IMAGE xy="CC0,0" align="CC" src="stxlogo_eng_color.bmp" size="728,89" rotate="0" opacity="10" /><TEXTLINE xy="RB-15,13" align="RB" fontname="돋움" fontsize="11" fontcolor="red" fontstyle="B" bgcolor="white" rotate="0" opacity="100" >  문서보안(도면 유출 금지)</TEXTLINE></SCREEN_MARKUP><PRINT_MARKUP><WATERMARK  size="170,60" repeatsize="420,297" rotate="0" opacity="10"><IMAGE xy="CT0,0" align="CT" src="stxlogo_eng_mono.bmp" size="140,40" rotate="0" opacity="100" /><TEXTLINE xy="CC 0,-25" align="CC" fontname="굴림" fontsize="14" fontcolor="black"  >%FILEINFO1% BLOCK-%FILEINFO2%</TEXTLINE><TEXTLINE xy="CC 0,-15" align="CC" fontname="굴림" fontsize="8"  fontcolor="black"  >ERP09773795</TEXTLINE></WATERMARK><TEXTLINE xy="LC0,0" align="LC" fontname="굴림" fontsize="2.5" fontcolor="black" fontstyle="B" bgcolor="none" rotate="90" opacity="100" >%DATE%/%FILEINFO3%</TEXTLINE><TEXTLINE xy="RC0,0" align="RC" fontname="굴림" fontsize="2.5" fontcolor="black" fontstyle="B" bgcolor="none" rotate="270" opacity="100" >%DATE%/%FILEINFO3%</TEXTLINE></PRINT_MARKUP> <DOC name="ERP09773795"><FILE src="ftp_src:/NEWDWG/S1611/M/5B/88/101/101H/S1611-M5B88101-101H-0040-02.PDF" info1="S1611" info2="101" info3="설계운영팀 양동협/S1611-S1611-M5B88101-101H-0040-02.PDF//9773795" /></DOC></DSVX>';
	SecurePM3AXControl();
	DSViewerAXControl();
	DSViewerAXCtl.Language = 'AUTO';
	DSViewerAXCtl.ClearOptions(); //기존에 설정된 값들은 제거한다.
	DSViewerAXCtl.SetOption( "XML", vReturn ); //XML 값 설정
	DSViewerAXCtl.SetOption( "MnuOpenFiles", "diable" ); // "Open Files" 메뉴 제어( enable, diable )
	DSViewerAXCtl.SetOption( "MnuOpenXml", "enable" );   // "Open XML" 메뉴 제어( enable, diable )
	DSViewerAXCtl.SetOption( "MnuDocInfo", "enable" );   // "Document Information" 메뉴 제어( enable, diable )
	DSViewerAXCtl.SetOption( "MnuPrint", "diable" ); //"Print" 메뉴 제어 ( enable, diable )
 	DSViewerAXCtl.SetOption( "MaxCopies", "3" );         // 최대 복사 매수 설정 ( -1이면 복사매수 제한 없음 )
	DSViewerAXCtl.SetOption( "MnuBookmark", "enable" );  // "Bookmark" 메뉴 제어( enable, diable )
	DSViewerAXCtl.SetOption( "MnuFileList", "enable" );  // "File List" 메뉴 제어( enable, diable )
	DSViewerAXCtl.SetOption( "MnuThumbnail", "enable" ); // "Thumbnail" 메뉴 제어( enable, diable ) 
	DSViewerAXCtl.ShowViewer();
	//self.close();
	if (/MSIE/.test(navigator.userAgent)) { 
         if(navigator.appVersion.indexOf("MSIE 7.0")>=0 || navigator.appVersion.indexOf("MSIE 8.0">=0))  { 
            window.open('about:blank','_self').close(); 
        }else { 
            self.opener = self ;
            window.close() ;
        }
    }
});
function getDWGXML(remote_url){
   	
   	return $.ajax({
       	type: "GET",
      		url: remote_url,
       	async: false,
   	}).responseText;
   	 
}
</script>
</html>
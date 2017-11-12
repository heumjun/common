<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<script src="http://dwgprint.stxons.com/dsv/DSViewerAX.js"></script>
<script type="text/javascript" src="./js/stxAjax.js"></script>
<script type="text/javascript" src="./js/SecurePM3AX2.js"></script>
</head>
<body>
<div id="body">
</div>
<input type="hidden" id="mode" name="mode" value="<c:out value="${mode}"/>" />
<input type="hidden" id="fileName" name="fileName" value="<c:out value="${P_FILE_NAME}"/>" />
<input type="hidden" id="vEmpNo" name="vEmpNo" value="<c:out value="${vEmpNo}"/>" />
<input type="hidden" name="loginid"	id="loginid" value="${loginUser.user_id}"	/>
도면정보를 로딩중입니다.....
</body>
<script type="text/javascript">
$(document).ready(function(){
	//var loadingBox;
	//loadingBox = new ajaxLoader( $( '#body' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
	var vFileName = $("#fileName").val();
	var mode = $("#mode").val();
	var vEmpNo = $("#vEmpNo").val();
	var user_id = $("#loginid").val();
	getDWGXML("selectView.do?VIEWMODE="+mode+"&P_FILE_NAME="+vFileName+"&vEmpNo="+user_id);	
	//var vReturn = getDWGXML("selectView.do?VIEWMODE="+mode+"&P_FILE_NAME="+vFileName+"&vEmpNo="+user_id);
	
// 	SecurePM3AXControl();
// 	DSViewerAXControl();
// 	DSViewerAXCtl.Language = 'AUTO';
// 	DSViewerAXCtl.ClearOptions(); //기존에 설정된 값들은 제거한다.
// 	DSViewerAXCtl.SetOption( "XML", vReturn ); //XML 값 설정
// 	DSViewerAXCtl.SetOption( "MnuOpenFiles", "enable" ); // "Open Files" 메뉴 제어( enable, diable )
// 	DSViewerAXCtl.SetOption( "MnuOpenXml", "enable" );   // "Open XML" 메뉴 제어( enable, diable )
// 	DSViewerAXCtl.SetOption( "MnuDocInfo", "enable" );   // "Document Information" 메뉴 제어( enable, diable )
// 	DSViewerAXCtl.SetOption( "MnuPrint", "enable" ); //"Print" 메뉴 제어 ( enable, diable )
//  	DSViewerAXCtl.SetOption( "MaxCopies", "3" );         // 최대 복사 매수 설정 ( -1이면 복사매수 제한 없음 )
// 	DSViewerAXCtl.SetOption( "MnuBookmark", "enable" );  // "Bookmark" 메뉴 제어( enable, diable )
// 	DSViewerAXCtl.SetOption( "MnuFileList", "enable" );  // "File List" 메뉴 제어( enable, diable )
// 	DSViewerAXCtl.SetOption( "MnuThumbnail", "enable" ); // "Thumbnail" 메뉴 제어( enable, diable ) 
// 	DSViewerAXCtl.ShowViewer();
// 	//self.close();
// 	if (/MSIE/.test(navigator.userAgent)) { 
//          if(navigator.appVersion.indexOf("MSIE 7.0")>=0 || navigator.appVersion.indexOf("MSIE 8.0">=0))  { 
//             window.open('about:blank','_self').close(); 
//         }else { 
//             self.opener = self ;
//             window.close() ;
//         }
//     }
});
	function getDWGXML(remote_url){
    	$.ajax({
        	type: "GET",
       		url: remote_url,
        	async: true,
        	success : function(data) {
        		SecurePM3AXControl();
        		DSViewerAXControl();
        		DSViewerAXCtl.Language = 'AUTO';
        		DSViewerAXCtl.ClearOptions(); //기존에 설정된 값들은 제거한다.
        		DSViewerAXCtl.SetOption( "XML", data ); //XML 값 설정
        		DSViewerAXCtl.SetOption( "MnuOpenFiles", "enable" ); // "Open Files" 메뉴 제어( enable, diable )
        		DSViewerAXCtl.SetOption( "MnuOpenXml", "enable" );   // "Open XML" 메뉴 제어( enable, diable )
        		DSViewerAXCtl.SetOption( "MnuDocInfo", "enable" );   // "Document Information" 메뉴 제어( enable, diable )
        		DSViewerAXCtl.SetOption( "MnuPrint", "enable" ); //"Print" 메뉴 제어 ( enable, diable )
        	 	DSViewerAXCtl.SetOption( "MaxCopies", "3" );         // 최대 복사 매수 설정 ( -1이면 복사매수 제한 없음 )
        		DSViewerAXCtl.SetOption( "MnuBookmark", "enable" );  // "Bookmark" 메뉴 제어( enable, diable )
        		DSViewerAXCtl.SetOption( "MnuFileList", "enable" );  // "File List" 메뉴 제어( enable, diable )
        		DSViewerAXCtl.SetOption( "MnuThumbnail", "enable" ); // "Thumbnail" 메뉴 제어( enable, diable ) 
        		DSViewerAXCtl.ShowViewer();
        		self.close();
        		if (/MSIE/.test(navigator.userAgent)) { 
        	         if(navigator.appVersion.indexOf("MSIE 7.0")>=0 || navigator.appVersion.indexOf("MSIE 8.0">=0))  { 
        	            window.open('about:blank','_self').close(); 
        	        }else { 
        	            self.opener = self ;
        	            window.close() ;
        	        }
        	    }
        	}
    	});
    }
</script>
</html>
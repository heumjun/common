<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<title>Design Information System</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<script>
if('${loginUser.multi_menu_yn}' == 'Y'){
	var v_checked = true;
} else {
	var v_checked = false;
}
// 권한이 변경되었을때
function roleChage(roleCode) {
	// 변경된 권한으로 좌측 메뉴를 보여준다.
	$( "#menu" ).attr( "src", "layoutLeftMenu.do?up_link=menu&roleCode=" + roleCode );
	$( "#main" ).attr( "src", "layoutMainContents.do?up_link=menu" );
	
}

//팝업 
function notice_getCookie( name ) { 
   var nameOfCookie = name + "="; 
   var x = 0; 
   while ( x <= document.cookie.length ) { 
              var y = (x+nameOfCookie.length); 
              if ( document.cookie.substring( x, y ) == nameOfCookie ) { 
                         if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 ) 
                                 endOfCookie = document.cookie.length; 
                         return unescape( document.cookie.substring( y, endOfCookie ) ); 
              } 
              x = document.cookie.indexOf( " ", x ) + 1; 
              if ( x == 0 ) 
                      break; 
   } 
   return ""; 
}
$(document).ready(function() {
	var formData = fn_getFormData('#application_form');
	
	var left = 10;
	var top = (screen.height/2)-(700/2);
	
	<c:forEach var="item" items="${popupList}" varStatus="status" >

		if("${status.index}" != 0) {
				left += 600;
		}
		if ( notice_getCookie( "Notice_${item.seq}" ) != "done" ) { 
		       window.open('eventPopup.do?seq=${item.seq}','Notice_${item.seq}','toolbar=no, location=no,directories=no, status=no, menubar=no, scrollbars=no, resizable=no,copyhistory=no,'
		    		    + 'width=600, height=480, top='+top+', left='+left).focus();
		}
	</c:forEach>
	
	

	/* for(var i=0; i<5; i++) {
		
	} */
});
</script>
</head>
<form id="application_form" name="application_form" method="post">
</form>
<frameset rows="98,*" frameborder="0" border="0" scrolling="no" frameborder="0">
	<frame src="layoutHeader.do?up_link=${up_link}" scrolling="no" name="header" id="header" border="0" noresize
		style="border-bottom-color: 1px solid block;">
	<frameset cols="204,12,*" id="body" name="body" frameborder="0" border="0" marginwidth="0" marginheight="0">
		<frame src="layoutLeftMenu.do?up_link=${up_link}" id="menu" name="menu" frameborder="0" border="0" framespacing="0"
			noresize scrolling="no">
		<frame src="layoutSeparation.do?up_link=${up_link}" id="menusep" name="menu" frameborder="0" border="0" framespacing="0"
			noresize scrolling="no">
		<frame src="layoutMainContents.do?up_link=${up_link}" id="main" name="main" scrolling="no">
	</frameset>
</frameset>
</html>

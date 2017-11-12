<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>특기사항</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="projectNo" value="${projectNo }"/>
				<input type="hidden" name="dwgCode" value="${dwgCode }"/>
				<input type="hidden" name="designerId" value="${designerId }"/>
				<table width="100%" align="center">
					<tr>
						<td>
							<textarea name="delayreason_desc" rows="15" cols="50"<c:if test="${isEditable eq null or isEditable ne 'true' }">readonly</c:if>>${delayReasonDesc}</textarea>
						</td>
					</tr>
				</table>
			</form>
			<c:if test="${isEditable ne null and isEditable eq 'true' }">
				<div id="buttonArray">
					<input type="button" class="btn_blue" value="저장" onclick="fn_saveReason();"><br/><br/>
				</div>
			</c:if>
		</div>
	</div>
	
	<script type="text/javascript">
		function fn_saveReason(){
			$.ajax({
		    	url:'<c:url value="popUpSaveDelayresonDesc.do"/>',
		    	type:'POST',
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : $("#application_form").serialize(),
		    	success : function(data){
		    		alert("저장을 완료하였습니다.");
		    		window.returnValue = application_form.delayreason_desc.value;
		 	        window.close();
		    	}, 
		    	error : function(e){
		    		alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
		    	}
		    });
		}
	</script>
</body>
</html>
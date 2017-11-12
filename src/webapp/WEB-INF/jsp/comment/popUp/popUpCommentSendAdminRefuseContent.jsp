<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ page import = "com.stx.common.util.StringUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.headerBD {position:relative; width:595px; height:140px; margin:0 0 27px 4px;}			
			.searchDetail1 {float:left; font-weight:bold; margin:3px;}
			.buttonInput{float:right; width:60px; margin:2px;}
			.content {position:relative; margin-left:4px; width:595px; height:395px; text-align:center; overflow-x:auto; }
			.td_keyEvent {font-size: 8pt; font-family: 굴림, 돋움, Verdana, Arial, Helvetica; vertical-align: bottom;}
			.ui-jqgrid .ui-jqgrid-hdiv {position: relative; margin: 0;padding: 0; overflow-x: hidden; border-left: 0 none !important; border-top : 0 none !important; border-right : 0 none !important;}
			.ui-jqgrid .ui-jqgrid-hbox {float: left; padding-right: 20px;}
			.ui-jqgrid .ui-jqgrid-htable {table-layout:fixed;margin:0;}
			.ui-jqgrid .ui-jqgrid-htable th {height:25px;padding: 3px 2px 0 2px;}
		</style>
	</head>

	<title>
		COMMENT 발신 반려내용 작성
	</title>

	<body oncontextmenu="return false">
		<form id="application_form" name="application_form" >
		
			<input type="hidden" name="pageYn" id="pageYn" value="N">
			<input type="hidden" name="p_userId" id="p_userId" value="${UserId}">
			<input type="hidden" id="page" name="page" value="" />
			<input type="hidden" id="rows" name="rows" value="" />
				
			<input type="hidden" id="p_send_id" name="p_send_id" value="${send_id_array}" />
					
			<div class= "subtitle" style="width:565px;">
				COMMENT 반려내용 작성
				<jsp:include page="../../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			</div>
			
			<div class="headerBD">
			<table>
				<tr>
					<td width="200px">
						<div class="searchDetail1">
							<input type="text" class="disablefield" id="" name="" value="반려내용" style="width:70px;text-align:center;font-weight:bold;padding-bottom:3px" readonly="readonly" />
						</div>						
					</td>
					<td width="295px">			
						<div class="button endbox" style="height:30px;margin-top:5px;margin-right:0px">							
							<input type="button" class="btn_blue2" value="반 려" id="btnApply"/>
							<input type="button" class="btn_blue2" value="닫 기" id="btnClose"/>
						</div>
					</td>
				</tr>
				<tr>
					<td width="495px" colspan="2">
						<div class="searchDetail1">
							<textarea id="p_mail_comment" name="p_mail_comment" style="width:580px;height:100px;"></textarea>
						</div>
					</td>
				</tr>
			</table>
			</div>

		</form>
		<script type="text/javascript" >
		$(document).ready(function(){
			
		});
		
		//########  닫기버튼 ########//
		$("#btnClose").click(function(){
			window.close();					
		});	
		
		//발신문서 반려 버튼
		$( "#btnApply" ).click( function() {

			if($("#p_mail_comment").val() == ""){
				alert("반려 내용을 작성해 주세요.");
				return false;
			}
			
			var form = $('#application_form');
			$(".loadingBoxArea").show();
			$.post("commentSendAdminApply.do?send_id_array="+$("#p_send_id").val()+"&p_mail_type=J", form.serialize(),function(json)
			{	
				alert(json.resultMsg);
				$(".loadingBoxArea").hide();
				window.close();
				opener.fn_search();
			},"json");
			
		} );
		</script>
	</body>
</html>
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
		COMMENT_반려
	</title>

	<body oncontextmenu="return false">
		<form id="application_form" name="application_form" >
		
			<input type="hidden" name="p_mail_type" id="p_mail_type"  value="" />
			<div class= "subtitle" style="width:565px;">
				COMMENT_반려
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
			
			var args = window.dialogArguments;

			var selarrrow = args.projectJqGridObj.jqGrid('getGridParam', 'selarrrow');
			
			if(selarrrow.length == 0) {
				alert("반려 항목을 선택하셔야 합니다.");
				return false;
			}
			
			$("#p_mail_type").val("J");
			
			for (var i = 0; i < selarrrow.length; i++) {
				
				var item = args.projectJqGridObj.jqGrid('getRowData', selarrrow[i]);
				
				args.projectJqGridObj.setCell (selarrrow[i], 'oper', 'U', '');
				
			}
			
			//승인 로직
			if(confirm('반려 하시겠습니까?')) {
				
				var changeResultRows =  args.getChangedGridInfo("#projectJqGridList");
				
				var url			= "commentAdminConfirmAction.do";
				var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
				var formData = fn_getFormData('#application_form');
				var parameters = $.extend({},dataList,formData);
				
				lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
				
				$.post(url, parameters, function(data) {
					alert(data.resultMsg);
				},"json").error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				}).always(function() {
					lodingBox.remove();
					args.jqGridObj.jqGrid( "clearGridData" );
					args.fn_search();
					self.close();		
				});
				
			}
			
		} );
		</script>
	</body>
</html>
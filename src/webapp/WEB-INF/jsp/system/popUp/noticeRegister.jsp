<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지사항 등록</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<script type="text/javascript">
	$(document).ready(function() {
		
		
		$( "#p_start_date, #p_end_date" ).datepicker({
	    	dateFormat: 'yy-mm-dd',
	    	prevText: '이전 달',
		    nextText: '다음 달',
		    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		    dayNames: ['일','월','화','수','목','금','토'],
		    dayNamesShort: ['일','월','화','수','목','금','토'],
		    dayNamesMin: ['일','월','화','수','목','금','토'],
		    showMonthAfterYear: true,
		    yearSuffix: '년',
		    changeYear: true,
		    changeMonth: true
	  	});
		
		$("#btnRegister").click(function() {
			
			var result = true;
			var message = "";
			var frm = document.frmNoticeAdd;
			
			//시작일 종료일 Validation	
			if($("#p_start_date").val() != "" && $("#p_end_date").val() != "") {
				
				var startDateArr = $("#p_start_date").val().split('-');
				var endDateArr = $("#p_end_date").val().split('-');
				
				var startDateCompare = new Date(startDateArr[0], startDateArr[1], startDateArr[2]);
		        var endDateCompare = new Date(endDateArr[0], endDateArr[1], endDateArr[2]);
		        
		        if(startDateCompare.getTime() > endDateCompare.getTime()) {
		        	result = false;
		        	message = "종료일은 시작일보다  이후 날짜로 선택하세요.";
		        	$("#p_start_date").focus();
		        }
			}
			
			if (!result) {
				alert(message);
				return false;
			}
			
	        if(confirm("저장하시겠습니까?"))
	        {
	        	$("#p_start_date").attr("disabled", false);
				$("#p_end_date").attr("disabled", false);
	            frm.encoding = "multipart/form-data";
	            //frm.target = "_self";
	            frm.action = "frmNoticeAddSave.do";
	            frm.submit();    
	        }
		});
	});
	
	function fileView(seq ) {
		var attURL = "noticeFileView.do?";
	    attURL += "p_seq="+seq;
	
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	    //window.showModalDialog(attURL,"",sProperties);
	    window.open(attURL,"",sProperties);
	    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
	}
	
	function checkBoxHeader(e, tObj) {
  		e = e||event;/* get IE event ( not passed ) */
  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
  		
  		var isChk = $("input[id=chkNotify_yn]").is(":checked");

  		if(isChk){
  			$("#p_notify_yn").val('Y');
			$("#p_start_date").attr("disabled", false);
			$("#p_end_date").attr("disabled", false);
			$("#p_start_date").css("background", "none");
  			$("#p_end_date").css("background", "none");
  		} else {
  			$("#p_notify_yn").val('N');
  			$("#p_start_date").attr("disabled", true);
  			$("#p_end_date").attr("disabled", true);
  			$("#p_start_date").css("background", "#DADADA");
  			$("#p_end_date").css("background", "#DADADA");
  			$("#p_start_date").val("");
  			$("#p_end_date").val("");
  		}
	}
</script>
</head>
<body>
<form name="frmNoticeAdd"  method="post">
<input type="hidden" id="p_notify_yn" name="p_notify_yn" value="Y"/>
	<div style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
		<img src="/images/main/tit_notice.gif" style="padding-top: 10px; padding-bottom: 6px; padding-left: 10px;" />
	</div>
	<table class="table_st01">
		<col width="85px">
		<col width="240px">
		<col width="85px">
		<col width="240px">
		<thead>
			<tr>
				<th><strong>제목</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3">
					<input type="text" id="p_subject" name="p_subject" value="" style="width: 495px; margin-left: 5px;" />
				</td>
			</tr>
			<tr>
				<th><strong>내용</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3">
					<textarea id="p_contents" name="p_contents" cols="95" rows="20" style="border: 0px;"></textarea>
				</td>
			</tr>
			<tr>
				<th><strong>시작일</strong></th>
				<td style="text-align: left;">
					<input type="text" name="p_start_date" id="p_start_date"  style="width:100px; margin-left: 5px;" value=""/>
				</td>
				<th><strong>종료일</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3">
					<input type="text" name="p_end_date" id="p_end_date"  style="width:100px; margin-left: 5px;" value=""/>
				</td>
			</tr>
			<tr>
				<th><strong>공지여부</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3">
					<input type="checkbox" id="chkNotify_yn" name="chkNotify_yn" checked="checked" onclick="checkBoxHeader(event, this)" style="margin-left: 5px;" />
				</td>
			</tr>
			<tr>
				<th><strong>첨부파일</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3">
					<input type="file" value="Import" name="fileName" id="fileExl" size="71" style="margin-left: 5px;" />
				</td>
			</tr>
		</thead>
	</table>
	<div style="float: right; padding: 5px 5px;">
		<input type="button" class="btnAct btn_blue" id="btnRegister" name="btnRegister" value="등록" />
	</div>
</form>	
</body>
</html>

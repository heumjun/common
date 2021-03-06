<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>ECO 생성</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="application_form" name="application_form">
	<%
		String main_description = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("main_description")),"UTF-8");
	%>
	<input type="hidden" id="ecoYN" name="ecoYN" value="${ecoYN}"/>
	<input type="hidden" id="p_main_type" name="p_main_type" value="${mainType}"/>
	
	<div class="subtitle">CREATE ECO</div>	
	
	<div class = "topMain" style="margin-top: 0px;">
		<table class="searchArea2 conSearch">
			<col width="120"/>
			<col width="460"/>
				<tr>
					<th class="only_eco">ECO Description</th>
					<td>
						<textarea name="main_description" id= "main_description" ROWS="9" style="width:95%; margin-top:10px;" onblur="layerhide();" onfocus="layershow();" onkeydown="tablayerhide();"><%=main_description%></textarea>
					</td>
				</tr>
				<tr>
					<th class="only_eco">Related ECR</th>
					<td>
						<input type="text" name="eng_change_name" id="eng_change_name" value="${eng_change_name}" style="width: 82%;" readonly/>
						<input type="hidden" name="eng_change_req_code" id="eng_change_req_code" value="${eng_change_req_code}"/>
						<input type="hidden" name="eng_change_cause" id="eng_change_cause" value="${eng_change_cause}"/>
						<input type="button" class="only_eco btn_gray2" id="RelatedEcrDelete" name="RelatedEcrDelete" value="삭제" />
						<input type="button" class="only_eco btn_gray2" id="RelatedEcrSearch" name="RelatedEcrSearch" value="검색" />
					</td>
				</tr>
				<tr>
					<th class="only_eco">ECO Cause</th>
					<td>
						<input type="text" name="couse_desc" id="couse_desc" value="${couse_desc}" style="width: 90%;" readonly/>
						<input type="hidden" name="eco_cause" id="eco_cause" value="${eco_cause}"/>
						<input type="button" class="only_eco btn_gray2" id="causeSearch" name="causeSearch" value="검색" />
					</td>
				</tr>
				<tr>
					<th class="only_eco">결재자</th>
					<td>
						<input type="text" name="manufacturing_engineer" id="manufacturing_engineer" value="${manufacturing_engineer == undefined ? loginUser.user_name : manufacturing_engineer}" style="width: 90%;" readonly/>
						<input type="hidden" name="manufacturing_engineer_emp_no" id="manufacturing_engineer_emp_no" value="${manufacturing_engineer_emp_no == undefined ? loginUser.user_id : manufacturing_engineer_emp_no}"/>
						<input type="hidden" name="design_engineer" id="design_engineer" value="${loginUser.user_name}"/>
						<input type="hidden" name="design_engineer_emp_no" id="design_engineer_emp_no" value="${loginUser.user_id}"/>
						<input type="hidden" name="user_group" id="user_group" value="${loginUser.insa_dept_code}"/>
						<input type="hidden" name="user_group_name" id="user_group_name" value="${loginUser.insa_dept_name}"/>
						<input type="button" class="only_eco btn_gray2" id="manufacturingSearch" name="manufacturingSearch" value="검색" />
					</td>
				</tr>
		</table>
		<br>
		<div class="button">
			<input type="button" id="btnClose" name="btnClose" value="CANCEL" class="btn_blue2" />
			<input type="button" id="btnConfirm" name="btnConfirm" value="DONE" class="btn_blue2" />
		</div>
	</div>
	<div id="desc_layer" style="position: absolute; left: 330px; top: 190px; border: 1px solid blue; display: none; background-color: yellow; padding: 10px;">
		<font style="color: blue; font-weight: bold;">
			<br />* Standard of making ECO
			<br />
			&nbsp;&nbsp;
			(Description Guide)
			<br /><br />
			&nbsp;&nbsp;
			1. Project &amp; Stage
			<br />
			&nbsp;&nbsp;
			2. Description of Change
			<br />
			&nbsp;&nbsp;
			3. Related Dept/Person
			<br />
			&nbsp;&nbsp;
			4. ECO Cause Code
			<br />
			&nbsp;&nbsp;
			5. Job Start Y/N
			<br /><br />
		</font>
	</div>
</form>
<script type="text/javascript">		
$(document).ready( function() {	

	//취소
	$( '#btnClose' ).click( function() {
		self.close();
	});
	
	//완료
	$( '#btnConfirm' ).click( function() {
		if($('#main_description').val() == "" || $('#main_description').val() == undefined) {
			alert("ECO Description을 입력하세요.");
			return;
		}
		if($('#couse_desc') == "" || $('#couse_desc') == undefined) {
			alert("ECO Cause를 선택하세요.");
			return;
		}
		if($('#manufacturing_engineer').val() == "" || $('#manufacturing_engineer').val() == undefined) {
			alert("결재자를 선택하세요.");
			return;
		}
		
		if($('#ecoYN').val() == "Y") {			
			var returnValue = new Array();
			returnValue[0] = $('#eng_change_name').val();
			returnValue[1] = $('#eng_change_req_code').val();
			returnValue[2] = $('#eng_change_cause').val();
			returnValue[3] = $('#couse_desc').val();
			returnValue[4] = $('#eco_cause').val();
			returnValue[5] = $('#design_engineer').val();
			returnValue[6] = $('#design_engineer_emp_no').val();
			returnValue[7] = $('#manufacturing_engineer').val();
			returnValue[8] = $('#manufacturing_engineer_emp_no').val();
			returnValue[9] = $('#user_group').val();
			returnValue[10] = $('#user_group_name').val();
			returnValue[11] = $('#main_description').val();
			window.returnValue = returnValue;
			self.close();
		} else {
			lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( "saveEco1.do", fn_getFormData('#application_form'), function(data) {
				debugger;
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					var returnValue = new Array();
					returnValue[0] = data.main_name;

					window.returnValue = returnValue;
					self.close();
				}
			}, "json" ).error( function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				lodingBox.remove();
			} );
		}
		
	});
	
	//관련자 ECR 검색
	$( '#RelatedEcrSearch' ).click( function() {
		/* var rs = window.showModalDialog( "popUpECR.do?save=create&eco_cause=" + $("#eco_cause").val(),
				window,
				"dialogWidth:1200px; dialogHeight:440px; center:on; scroll:off; status:off" ); */
		
		var rs = window.showModalDialog( "popUpECR.do?save=create&eco_cause=" + $("#eco_cause").val(),
				window,
				"dialogWidth:1200px; dialogHeight:440px; center:on; scroll:off; status:off" );
		
		if( rs != null ) {
			$("#eng_change_name").val(rs[1]);
			$("#eng_change_req_code").val(rs[0]);
			$("#eng_change_cause").val(rs[2]);
		}
	});
	
	//관련자 ECR 삭제
	$( '#RelatedEcrDelete' ).click( function() {
		$("#eng_change_name").val("");
		$("#eng_change_req_code").val("");
		$("#eng_change_cause").val("");
	});
	
	//ECO Cause 검색
	$( '#causeSearch' ).click( function() {
		var rs = window.showModalDialog( "popUpCause.do?loginid=" + $( "#design_engineer_emp_no" ).val() + "&statesCode=" + $("#eng_change_cause").val(),
				window,
				"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
		
		if( rs != null ) {
			$( "#couse_desc" ).val(rs[1]);
			$( "#eco_cause" ).val(rs[0]);
		}
	});
	
	//결재자 검색
	$( '#manufacturingSearch' ).click( function() {
		var rs = window.showModalDialog( "popUpEmpNoAndRegiter.do?register_type=RME&main_type=ECO&loginid=" + $( "#design_engineer_emp_no" ).val(),
				window,
				"dialogWidth:600px; dialogHeight:470px; center:on; scroll:off; status:off" );
		
		if( rs != null ) {
			$( "#manufacturing_engineer" ).val(rs[2]);
			$( "#manufacturing_engineer_emp_no" ).val(rs[0]);
		}
		
	});

	$.post("ecoRegisterInfo.do", fn_getFormData("#application_form"), function(data) {
		for (var i in data ){
			$( "#design_engineer" ).val(data[i].main_user_name);
			$( "#design_engineer_emp_no" ).val(data[i].main_emp_no);
			//$( "#user_group_name" ).val(data[i].main_dept_name);
			$( "#manufacturing_engineer" ).val(data[i].sub_user_name);
			$( "#manufacturing_engineer_emp_no" ).val(data[i].sub_emp_no);
		}
	}, "json").error(function() {
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	});
});

var layershow = function() {
	$( "#desc_layer" ).show();
}

var layerhide = function() {
	$( "#desc_layer" ).hide();
}

var tablayerhide = function() {
	var input1 = document.getElementById('main_description') 
	input1.onkeydown = function(event) { 
		if(event.keyCode == 9) {
			$( "#desc_layer" ).hide();
		}
	}
}

</script>
</body>
</html>

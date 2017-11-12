<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<%
	
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공정 지연현황 조회</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		공정 지연현황 조회
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
	<form id="application_form" name="application_form">
		<div id="searchDiv">
			<input type="hidden" name="loginID" value="${loginUser.user_id}" />
			<input type="hidden" name="designerID" value="${loginUserInfo.designerID}" />
			<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
			<input type="hidden" name="dwgDepartmentCode" value="${loginUserInfo.dwg_deptcode}" />
			<input type="hidden" name="lockDate" value="${loginUserInfo.lockDate }"/>
			<table class="searchArea conSearch">
				<col width="3%"/>
				<col width="9%"/>
				<col width="2%"/>
				<col width="10%"/>
				<col width="2%"/>
				<col width="10%"/>
				<col width="2%"/>
				<col width="10%"/>
				<col width="*"/>
				<tr>
					<th>호선</th>
					<td>
						<input type="text" name="projectList" value="" onchange="onlyUpperCase(this);" class = "required" id="p_project_no" onkeypress="this.value=this.value.toUpperCase().trim()"/>
						<input type="button" name="ProjectsButton" value="검색" class="btn_gray2" id="btn_project_no"/>
						<!-- 어드민옵션있음 나중에 추가-->
						<c:if test="${loginUserInfo.is_admin eq 'Y'}">
							<input type="button" name="" value="조회가능 호선관리" class="btn_gray2" id="btn_project_serach_able"/>
						</c:if>
					</td>
					<th>부서</th>
					<td>
						<select name="departmentList" style="width:250px;" onchange="departmentSelChanged('designerList',this);">
							<option value=" ">&nbsp;</option>
							<!-- 부서 목록 리스트 추가 -->
							<c:forEach var="item" items="${departmentList }">
								<option value="${item.dept_code }" <c:if test="${item.dept_code eq loginUserInfo.dept_code }">selected="selected"</c:if> >${item.dept_code } : ${item.dept_name }</option>
							</c:forEach>
						</select>
					</td>
					<th>사번</th>
					<td colspan="2">
						<select name="designerList" style="width:130px;">
							<option value="">&nbsp;</option>
							<!-- 사번 목록 리스트 추가 -->
							<c:forEach var="item" items="${personsList }">
								<option value="${item.employee_num }" >${item.employee_num }   ${item.name }</option>
							</c:forEach>
						</select>
						완료List포함<input type="checkbox" id="searchComplete" name="searchComplete">
	                	<c:if test="${loginUserInfo.is_admin eq 'Y'}">전체List포함<input type="checkbox" name="searchAll" value="true"></c:if>
	                	<c:if test="${loginUserInfo.is_admin eq 'N'}"><input type="hidden" name="searchAll" value="false"></c:if>
					</td>
					<td style="text-align: right;">
		                <input type="button" value='조 회' class="btn_blue" id="btn_search"/>
		                <input type="button" value='저 장' class="btn_blue" id="btn_save" onclick="fn_saveGridData('dataList')"/>
		                <input type="button" name="PrintButton" value='출 력' class="btn_blue" onclick="viewReport();"/>
		                <input type="button" name="ExcelButton" value='엑 셀' class="btn_blue" onclick="viewReportExcel();"/>
	            	</td>
				</tr>
				<tr class="checkBoxTr">
					<th>
						관리기준일	
					</th>
					<td>
	                	<input type="text" id="p_created_date_start" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 65px;"/>
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 65px;"/>
					</td>
					<th rowspan="2">
						Basic
					</th>
					<td rowspan="2">
						<input type="checkbox" name="bAll" style="width:9pt;" onclick="toggleChecks(this);" />ALL
	                    <input type="checkbox" name="bDS" value="Y" style="width:9pt;" />Design Start
	                    <input type="checkbox" name="bDF" value="Y" style="width:9pt;" checked="checked" />Design Finish
	                    <input type="checkbox" name="bOS" value="Y" style="width:9pt;" checked="checked" />OwnerApp.Submit<br/>
	                    <input type="checkbox" name="bOF" value="Y" style="width:9pt;" checked="checked" />OwnerApp.Receive
	                    <input type="checkbox" name="bCS" value="Y" style="width:9pt;"  />ClassApp.Submit
	                    <input type="checkbox" name="bCF" value="Y" style="width:9pt;"  />ClassApp.Receive<br/>
	                    <input type="checkbox" name="bRF" value="Y" style="width:9pt;"  />Issued for Working
	                    <input type="checkbox" name="bWK" value="Y" style="width:9pt;"  />Issued for Const
					</td>
					<th rowspan="2">
						Maker
					</th>
					<td rowspan="2">
						<input type="checkbox" name="mAll" style="width:9pt;" onclick="toggleChecks(this);" />ALL
	                    <input type="checkbox" name="mDS" value="Y" style="width:9pt;" checked="checked" />P.R.
	                    <input type="checkbox" name="mDF" value="N" style="width:9pt;" />Vender Selection
	                    <input type="checkbox" name="mOS" value="N" style="width:9pt;" />P.O.<br/>
	                    <input type="checkbox" name="mOF" value="Y" style="width:9pt;" checked="checked" />VenderDwg.Receive
	                    <input type="checkbox" name="mCS" value="Y" style="width:9pt;" checked="checked" />OwnerApp.Submit<br/>
	                    <input type="checkbox" name="mCF" value="Y" style="width:9pt;"  />OwnerApp.Receive
	                    <input type="checkbox" name="mRF" value="Y" style="width:9pt;" checked="checked" />Issued for Working<br/>
	                    <input type="checkbox" name="mWK" value="Y" style="width:9pt;"  />Issued for Const
					</td>
					<th rowspan="2">
						Product
					</th>
					<td rowspan="2">
						<input type="checkbox" name="pAll" style="width:9pt;" onclick="toggleChecks(this);" />ALL
	                    <input type="checkbox" name="pDS" value="N" style="width:9pt;" />Design Start
	                    <input type="checkbox" name="pDF" value="N" style="width:9pt;" />Design Finish
	                    <input type="checkbox" name="pOS" value="N" style="width:9pt;" />OwnerApp.Submit<br/>
	                    <input type="checkbox" name="pOF" value="N" style="width:9pt;" />OwnerApp.Receive
	                    <input type="checkbox" name="pCS" value="N" style="width:9pt;" />ClassApp.Submit
	                    <input type="checkbox" name="pCF" value="N" style="width:9pt;" />ClassApp.Receive<br/>
	                    <input type="checkbox" name="pRF" value="N" style="width:9pt;" />Issued for Working
	                    <input type="checkbox" name="pWK" value="N" style="width:9pt;" checked="checked" />Issued for Const
					</td>
				</tr>
				<tr>
					<th>
						Total Deviation
					</th>
					<td>
						<input type="text" name="totalDeviation" value="" style="background-color:#ffffcc" readonly="readonly" />
					</td>
				</tr>
			</table>
		</div>
	</form>
	<form id="application_form1" name="application_form1">
		<div class="content">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
	<div id="reasonSelectDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
	    <tr><td>
	        <select name="reasonSelect" style="width:150px;background-color:#fff0f5" onchange="fn_reasonSelChanged();">
	            <option value="&nbsp;"></option>
	            <option value="자체지연">자체지연</option>
	            <option value="계약지연">계약지연</option>
	            <option value="Maker Dwg. 미접수">Maker Dwg. 미접수</option>
	            <option value="선주승인지연">선주승인지연</option>
	            <option value="선급승인지연">선급승인지연</option>
	            <option value="타부서 관련도면 미접수">타부서 관련도면 미접수</option>
	            <option value="Comment">Comment</option>
	            <option value="기타">기타</option>
	        </select>
	    </td></tr>
	    </table>
	</div>
	<div id="datePickerDiv" style="position:absolute; display:none; z-index: 9;" class="div_popup">
		<input type="hidden" id="targetRowId" value=""/>
		<input type="hidden" id="targetName" value=""/>
		<input type="hidden" id="limitOption" value="N"/>
	    <input type="text" id="normalDatePicker" class="datepicker" maxlength="10" style="width: 65px;"/>
	</div>
</div>
<script type="text/javascript">
	$( function() {
		
		var dates = $( "#p_created_date_start, #p_created_date_end" ).datepicker( {
			prevText: '이전 달',
			nextText: '다음 달',
			monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			dayNames: ['일','월','화','수','목','금','토'],
			dayNamesShort: ['일','월','화','수','목','금','토'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			dateFormat: 'yy-mm-dd',
			showMonthAfterYear: true,
			yearSuffix: '년',
			onSelect: function( selectedDate ) {
				var option = this.id == "p_created_date_start" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		} );
		
		var normalDate = $("#normalDatePicker").datepicker( {
			prevText: '이전 달',
			nextText: '다음 달',
			monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			dayNames: ['일','월','화','수','목','금','토'],
			dayNamesShort: ['일','월','화','수','목','금','토'],
			dayNamesMin: ['일','월','화','수','목','금','토'],
			dateFormat: 'yy-mm-dd',
			showMonthAfterYear: true,
			yearSuffix: '년',
			onSelect: function( selectedDate,instance) {
				var targetRowId = $('#targetRowId').val();
				var targetName = $('#targetName').val();
				var lastVal = instance.lastVal;
				var limitOption = $('#limitOption').val();
				if(limitOption != 'Y'){
					$('#dataList').jqGrid('setCell',targetRowId, targetName, selectedDate);
					$('#dataList').jqGrid('setCell',targetRowId, 'oper', 'U');
				}
				else {
					if(!fn_dateLimitOptionCheck(selectedDate)){
						$('#dataList').jqGrid('setCell',targetRowId, targetName, lastVal);
					} else {
						$('#dataList').jqGrid('setCell',targetRowId, targetName, selectedDate);
						$('#dataList').jqGrid('setCell',targetRowId, 'oper', 'U');
					}
				}
			}
		} ).on('change',function(){
			var targetRowId = $('#targetRowId').val();
			var targetName = $('#targetName').val();
			$('#dataList').jqGrid('setCell',targetRowId, targetName, '&nbsp;');
			$('#dataList').jqGrid('setCell',targetRowId, 'oper', 'U');
		});
		
	} );



	$(document).ready(function(){
		fn_toDate("p_created_date_end" );
		//호선 검색 팝업 호출
		$("#btn_project_no").click(function() {
	        
	        var paramStr = "selectedProjects=" + application_form.projectList.value;
	        paramStr += "&loginID=" + application_form.loginID.value;
	        paramStr += "&category=DEVIATION";
			
			var rs = window.showModalDialog("popUpProjectSelectWin.do?"+paramStr, 
					window, "dialogHeight:500px;dialogWidth:600px; center:on; scroll:off; status:off");
	
			if(rs != null || rs != undefined){
				$("#p_project_no").val(rs);
			}
		});
		$(".div_popup").focusout(function(){
			fn_toggleDivPopUp();
		});
		// 조회가능 호선관리 창을 Show
		$("#btn_project_serach_able").click(function(){
			var sProperties = 'dialogHeight:500px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
		    var paramStr = "loginID=" + application_form.loginID.value;
		    paramStr += "&category=DEVIATION";
		    
		    var rs = window.showModalDialog("popUpProjectSelectMng.do?" + paramStr, "", sProperties);
		});
		
		//조회 실행처리
		$("#btn_search").click(function(){
			//입력 DIV레이어 숨김
			fn_toggleDivPopUp();
			//basic maker product checkbox값 확인 및 처리
			var checkboxTrArray = $(".checkBoxTr input:checkbox");		
			for(var i = 0; i < checkboxTrArray.length; i++){
				if($(checkboxTrArray[i]).is(":checked")){
					$(checkboxTrArray[i]).val("Y");
				} else {
					$(checkboxTrArray[i]).val("N");
				}
			}
			//완료 리스트 포함 값 확인 및 처리
			if($("#searchComplete").is(":checked")){
				$("#searchComplete").val("true");
			} else {
				$("#searchComplete").val("false");
			}
			//기타 입력값 확인 처리
			if(!checkInputs())return;
			
			//그리드 갱신을 위한 작업
			$( '#dataList' ).jqGrid( 'clearGridData' );
			//그리드 postdata 초기화 후 그리드 로드 
			$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
			$( '#dataList' ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : '<c:url value="progressDeviationMainGrid.do"/>',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( '#application_form' )
			} ).trigger( 'reloadGrid' );
		});
		
	});
	//날짜  유효성 체크: Action 일자 변경 처리 용
	function fn_dateLimitOptionCheck(checkDate){
		if(checkDate != null && checkDate.trim() != ""){
			// 오늘 기준 -(lockDate 0 ~ +1 일 이내 날짜만 입력 가능(체크)
			if(application_form.isAdmin.value != "Y"){
				var today = new Date();
				var dateStrs = checkDate.split("-");
				var lockDate = application_form.lockDate.value;
				
				if(lockDate != ""){
					if(lockDate.indexOf("-") == 0) lockDate = lockDate.substring(1);
					// 선택일에 +(lockDate)일 한 일자(오늘날짜보다 같거나 커야함) 
					 var targetDate = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "+" + lockDate)); 
					 if (targetDate < today) {
						alert("입력 가능 일자가 아닙니다.\n\n자세한 사항은 기술기획팀-기술계획P에 문의바랍니다.");
						return false;
					 }
				}
				// 선택일에 -1일 한 일자(오늘날짜보다 작거나 같아야함)
				var targetDate2 = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "-1")); 
				if (targetDate2 > today) {
				    alert("오늘날짜 기준 +1일 이내의 날짜만 입력할 수 있습니다!");
				    return false;
				}
			}
		}
		return true;
	}
	//체크항목을 모두 체크 or 모두 체크 해제
	function toggleChecks(obj)
	{
		var checked =$(obj).is(":checked"); 
		$(obj).nextAll().prop("checked",checked);
	}
	//입력 조건 체크
	function checkInputs()
	{
	    if (application_form.projectList.value == "") {
	        alert("호선을 선택하십시오.");
	        return false;
	    }
	
	    if (application_form.dateSelected_to.value == "") {
	        alert("관리기준일을 입력하십시오.");
	        return false;
	    }
	
	    if (application_form.bDS.checked == false && application_form.bDF.checked == false && 
			application_form.bOS.checked == false && application_form.bOF.checked == false && 
			application_form.bCS.checked == false && application_form.bCF.checked == false && 
	        application_form.bRF.checked == false && application_form.bWK.checked == false && 
	        application_form.mDS.checked == false && application_form.mDF.checked == false && 
	        application_form.mOS.checked == false && application_form.mOF.checked == false && 
	        application_form.mCS.checked == false && application_form.mCF.checked == false && 
	        application_form.mRF.checked == false && application_form.mWK.checked == false && 
	        application_form.pDS.checked == false && application_form.pDF.checked == false && 
	        application_form.pOS.checked == false && application_form.pOF.checked == false && 
	        application_form.pCS.checked == false && application_form.pCF.checked == false && 
	        application_form.pRF.checked == false && application_form.pWK.checked == false
	       )
	    {
	        alert("관리기준일 조건을 하나 이상 체크하십시오.");
	        return false;
	    }
	
	    return true;
	}
	//부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
	function departmentSelChanged(sabunTagName,obj) 
	{
	    var dept_code = $(obj).val();
	    var sabunTagObj = $("select[name="+sabunTagName+"]");
	    $.ajax({
	    	url:'<c:url value="getPartPersonsForDPProgress.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"dept_code" : dept_code},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		sabunTagObj.empty();
	    		sabunTagObj.append("<option value=''>&nbsp;</option>");
	    		for(var i=0; i<jsonData.rows.length; i++){
	    			var rows = jsonData.rows[i];
	    			sabunTagObj.append("<option value='"+rows.employee_num+"'>"+rows.employee_num+" : "+rows.name+"</option>");
	    		}
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
    // 프린트(리포트 출력) - VIEW & PRINT 양식
    function viewReport()
    {
        var rdFileName = "stxPECDPProgressDeviationViewAdmin.mrd";
        //if (DPProgressDeviationHeader.isAdmin.value != "Y") rdFileName = "stxPECDPProgressDeviationView.mrd";
        viewReportProc(rdFileName);
    }

    // 프린트(리포트 출력) - EXCEL EXPORT 양식
    function viewReportExcel()
    {
        viewReportProc("stxPECDPProgressDeviationViewExcel.mrd");
    }
 	// 프린트(리포트 출력) 서브 프로시저
   function viewReportProc(rdFileName)
   {
		if (!checkInputs()) return;

		var projectNoStrs = application_form.projectList.value;

		var strs = projectNoStrs.split(",");
			projectNoStrs = "";
		for (var i = 0; i < strs.length; i++) {
				var tempStr = strs[i];
				if (i > 0) projectNoStrs += ",";
				projectNoStrs += "'" + tempStr.trim() + "'";
		}

       	var paramStr = projectNoStrs + ":::" + 
			        	application_form.departmentList.value + ":::" + 
			        	application_form.dateSelected_to.value + ":::";

	       paramStr += (application_form.bDS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bDF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bOS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bOF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bCS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bCF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bRF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.bWK.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mDS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mDF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mOS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mOF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mCS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mCF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mRF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.mWK.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pDS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pDF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pOS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pOF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pCS.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pCF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pRF.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.pWK.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.dateSelected_from.value == '' ? 'N' : application_form.dateSelected_from.value) + ":::";
	       paramStr += (application_form.searchComplete.checked ? "Y" : "N") + ":::";
	       paramStr += (application_form.searchAll.checked ? "Y" : "N");
	       //paramStr = encodeURIComponent(paramStr);
	        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/" + rdFileName 
	                      + "&param=" + paramStr;
	       window.open(urlStr, "", "");
   	}
</script>
<script type="text/javascript">
//메인 컨테르 jqgrid작업 시작
//마스터 그리드
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		
		$( "#dataList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['Project','Part','DWG.No','Zone','Exist','1st','2nd','Task(Drawing Title)','담당자',
			            '지연사유','조치예정일','현장필요시점','특기사항',
			            'Plan','Action','check','Plan','Action','check','Plan','Action','check','Plan','Action','check'
			            ,'Plan','Action','check','Plan','Action','check','Plan','Action','check','Plan','Action','check',
			            'Part','EMP_NO','DW_PLAN_S_O','DW_PLAN_F_O','OW_PLAN_S_O','OW_PLAN_F_O',
			            'CL_PLAN_S_O','CL_PLAN_F_O','RF_PLAN_S_O','WK_PLAN_S_O','oper'],
			colModel : [{name : 'projectno', index : 'projectno', width: 50, align : "center",frozen:true},
						{name : 'deptname', index : 'deptname', width: 70, align : "center",frozen:true},
						{name : 'dwgcode', index : 'dwgcode', width: 70, align : "center",frozen:true},
						{name : 'dwgzone', index : 'dwgzone', width: 50, align : "center",frozen:true},
						{name : 'outsourcingyn', index : 'outsourcingyn', width: 30, align : "center",frozen:true},
						{name : 'outsourcing1', index : 'outsourcing1', width: 30, align : "center",frozen:true},
						{name : 'outsourcing2', index : 'outsourcing2', width: 30, align : "center",frozen:true},
						{name : 'dwgtitle', index : 'dwgtitle', width: 250, align : "left",frozen:true,title:true},
						{name : 'name', index : 'name', width: 50, align : "center",frozen:true},
						{name : 'delayreason', index : 'delayreason', width: 150, align : "center"},
						{name : 'resolveplandate', index : 'resolveplandate', width: 80, align : "center"},
						{name : 'requireddate', index : 'requireddate', width: 80, align : "center"},
						{name : 'delayreason_desc', index : 'delayreason_desc', width: 150, align : "center"},
						{name : 'dw_plan_s', index : 'dw_plan_s', width: 80, align : "center"},
						{name : 'dw_act_s', index : 'dw_act_s', width: 80, align : "center"},
						{name : 'dw_act_s_check', index : 'dw_act_s_check', width: 80, align : "center",hidden:true},
						{name : 'dw_plan_f', index : 'dw_plan_f', width: 80, align : "center"},
						{name : 'dw_act_f', index : 'dw_act_f', width: 80, align : "center"},
						{name : 'dw_act_f_check', index : 'dw_act_f_check', width: 80, align : "center",hidden:true},
						{name : 'ow_plan_s', index : 'ow_plan_s', width: 80, align : "center"},
						{name : 'ow_act_s', index : 'ow_act_s', width: 80, align : "center"},
						{name : 'ow_act_s_check', index : 'ow_act_s_check', width: 80, align : "center",hidden:true},
						{name : 'ow_plan_f', index : 'ow_plan_f', width: 80, align : "center"},
						{name : 'ow_act_f', index : 'ow_act_f', width: 80, align : "center"},
						{name : 'ow_act_f_check', index : 'ow_act_f_check', width: 80, align : "center",hidden:true},
						{name : 'cl_plan_s', index : 'cl_plan_s', width: 80, align : "center"},
						{name : 'cl_act_s', index : 'cl_act_s', width: 80, align : "center"},
						{name : 'cl_act_s_check', index : 'cl_act_s_check', width: 80, align : "center",hidden:true},
						{name : 'cl_plan_f', index : 'cl_plan_f', width: 80, align : "center"},
						{name : 'cl_act_f', index : 'cl_act_f', width: 80, align : "center"},
						{name : 'cl_act_f_check', index : 'cl_act_f_check', width: 80, align : "center",hidden:true},
						{name : 'rf_plan_s', index : 'rf_plan_s', width: 80, align : "center"},
						{name : 'rf_act_s', index : 'rf_act_s', width: 80, align : "center"},
						{name : 'rf_act_s_check', index : 'rf_act_s_check', width: 80, align : "center",hidden:true},
						{name : 'wk_plan_s', index : 'wk_plan_s', width: 80, align : "center"},
						{name : 'wk_act_s', index : 'wk_act_s', width: 80, align : "center"},
						{name : 'wk_act_s_check', index : 'wk_act_s_check', width: 80, align : "center",hidden:true},
						{name : 'deptcode', index : 'deptcode', width: 80, align : "center",hidden:true},
						{name : 'sabun', index : 'sabun', width: 80, align : "center", hidden:true},
						{name : 'dw_plan_s_o', index : 'dw_plan_s_o', width: 80, align : "center",hidden:true },
						{name : 'dw_plan_f_o', index : 'dw_plan_f_o', width: 80, align : "center",hidden:true },
						{name : 'ow_plan_s_o', index : 'ow_plan_s_o', width: 80, align : "center",hidden:true },
						{name : 'ow_plan_f_o', index : 'ow_plan_f_o', width: 80, align : "center",hidden:true },
						{name : 'cl_plan_s_o', index : 'cl_plan_s_o', width: 80, align : "center",hidden:true },
						{name : 'cl_plan_f_o', index : 'cl_plan_f_o', width: 80, align : "center",hidden:true },
						{name : 'rf_plan_s_o', index : 'rf_plan_s_o', width: 80, align : "center",hidden:true },
						{name : 'wk_plan_s_o', index : 'wk_plan_s_o', width: 80, align : "center",hidden:true },
						{name : 'oper', index : 'oper', width: 80, align : "center",hidden:true }
			           ],
			gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			hidegrid: false,
			altRows:false,
			viewrecords : true,
			autowidth : true, //autowidth: true,
			shrinkToFit: false,
			height : objectHeight,
			pager: "#jqGridPager",
			loadonce:true, 
            rowNum:50,
			rownumbers: true,
			emptyrecords : '데이터가 존재하지 않습니다. ',
			pager : jQuery('#pDataList'),
			cellEdit : false, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			},
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records"
			},
			ondblClickRow : function(rowId,iRow,colId) {
				var rowData = jQuery(this).getRowData(rowId);
				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				var deptcode = rowData.deptcode;
				var isEditable = false;
				//수정가능 여부 확인
				if(application_form.isAdmin.value == "Y" || deptcode == application_form.dwgDepartmentCode.value) isEditable = true;
				
				//입력 수정 layer팝업 전체 닫기
				fn_toggleDivPopUp();
				
				if(isEditable){
					/*지연 특기사유 팝업 EditView*/
					if(cm[colId].name == "delayreason_desc"){
						fn_delayreason_desc(rowData['projectno'],rowData['dwgcode'],"true",application_form.designerID.value,rowId);
					}
				}
				else {
					/*지연 특기사유 팝업 뷰*/
					if(cm[colId].name == "delayreason_desc"){
						fn_delayreason_desc(rowData['projectno'],rowData['dwgcode'],"false",application_form.designerID.value,rowId);
					}
				}
			},
			onCellSelect : function( rowId, colId, content, event) {
				var rowData = jQuery(this).getRowData(rowId);
				var deptcode = rowData.deptcode;

				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				var isEditable = false;
				if(application_form.isAdmin.value == "Y" || deptcode == application_form.dwgDepartmentCode.value) isEditable = true;
				
				// 드래그 등으로 열 위치값이 애매할 경우는 return
				if(colId < 0) return;
				
				//일자 입력 대상 컬럼
				var normalDatePickerList = ['resolveplandate','requireddate'];
				//일자 입력 제한 대상 컬럼
				var limitDatePickerList = ['dw_act_s','dw_act_f','ow_act_s','ow_act_f','cl_act_s','cl_act_f','rf_act_s','wk_act_s'];
				
				if(isEditable){
					fn_toggleDivPopUp();
					//지연사유 입력 selectbox layer실행
					if(cm[colId].name == "delayreason")fn_selectReason( $(this).find("tr#"+rowId).find("td:eq("+colId+")"), rowData.projectno, rowData.dwgcode, 'F1', rowData.delayreason);
					//일자 입력 대상 컬럼 arry에 해당 컬럼 이름이 있을 경우 실행
					if(jQuery.inArray( cm[colId].name, normalDatePickerList ) > -1){
						
						fn_normalDatePicker($(this).find("tr#"+rowId).find("td:eq("+colId+")"),rowData[cm[colId].name],rowId,cm[colId].name,'N');
						
					}//일자 입력 제한 대상 컬럼 array에 해당 컬럼 이름이 있을 경우 실행
					else if(jQuery.inArray( cm[colId].name, limitDatePickerList ) > -1){
						
						if(rowData[cm[colId].name+"_check"] == "Y" &&  application_form.isAdmin.value != "Y") return;
						
						fn_normalDatePicker($(this).find("tr#"+rowId).find("td:eq("+colId+")"),rowData[cm[colId].name],rowId,cm[colId].name,'Y');
					}
				} else {
					fn_toggleDivPopUp();
				}
			},
			loadComplete: function () {
				// 도면타입에 따라 Header 부분 선택 값을 변경(: Color-Highlight 로 표시)
        		$('.jqgrow').mouseover(function(e) {
        		    var rowId = $(this).attr('id'); //
        		    var list = $('#dataList').getRowData(rowId);
        		    if(list.dwgcode != null && list.dwgcode.indexOf("V") == 0){
        		    	$(".groupheadersTop").css("backgroundColor",'#e5e5e5');
        		    	$(".groupheadersBottom").css("backgroundColor",'#32cd32');
        		    	$('.commonheadersTop').css("backgroundColor",'#32cd32');
        		    } else {
        		    	$(".groupheadersTop").css("backgroundColor",'#32cd32');
        		    	$(".groupheadersBottom").css("backgroundColor",'#e5e5e5');
        		    	$('.commonheadersTop').css("backgroundColor",'#32cd32');
        		    }
        		});
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				//totalDeviation설정
				application_form.totalDeviation.value = $("#dataList").getGridParam("records");
				
				//로우별 색깔표시
				var comparekey1 = ['dw_plan_s_o','dw_plan_f_o','ow_plan_s_o','ow_plan_f_o','cl_plan_s_o','cl_plan_f_o','rf_plan_s_o','wk_plan_s_o'];
                var comparekey2 = ['dw_act_s','dw_act_f','ow_act_s','ow_act_f','cl_act_s','cl_act_f','rf_act_s','wk_act_s'];
				for( var i = 0; i < rows.length; i++ ) {
					var deptcode = $( "#dataList" ).getCell( rows[i], "deptcode" );
					//특기사항 개행문자 제거처리
					var delayreason_desc = $( "#dataList" ).getCell( rows[i], "delayreason_desc" );
						delayreason_desc = delayreason_desc.replace(/\n/g, "");
					var isEditable = false;
					if(application_form.isAdmin.value == "Y" || deptcode == application_form.dwgDepartmentCode.value) isEditable = true;
					
					//수정 가능시 색깔 표시
					if(isEditable){
						var color = "#ffffe0";
						$('#dataList').jqGrid('setCell',rows[i], 'delayreason', '', {background : color });
						$('#dataList').jqGrid('setCell',rows[i], 'resolveplandate', '', {background : color });
						$('#dataList').jqGrid('setCell',rows[i], 'requireddate', '', {background : color });
						$('#dataList').jqGrid('setCell',rows[i], 'delayreason_desc', '', {background : color });
					}
					
					//기타 반복적인 항목 색깔 표시
                    for(var c = 0; c < comparekey1.length; c++) {
                    	var actionObjValue = $( "#dataList" ).getCell( rows[i], comparekey2[c] );
                    	var planObjValue = $( "#dataList" ).getCell( rows[i], comparekey1[c] );
                    	var color = "#ffffe0";
                    	if(!isEditable){
                    		color = "#ffffff";
                    	}
                    	if(actionObjValue == "" && planObjValue == "Y"){
                    		color = "#ff0000";
                    	}
                    	$('#dataList').jqGrid('setCell',rows[i], comparekey2[c], '', {background : color });
                    	
                    }
                    $('#dataList').jqGrid('setCell',rows[i], 'delayreason_desc', delayreason_desc);
				}
			},
			loadError:function(xhr, status, error) {
			}
		});
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그룹헤더 3단 처리
		$("#dataList").jqGrid('setGroupHeaders', {
			  useColSpanStyle: true, 
			  groupHeaders:[
			 	 {startColumnName: 'outsourcingyn', numberOfColumns: 3, titleText: 'Outsourcing Plan'},
			 	{startColumnName: 'dw_plan_s', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('DrawingStart','Purchase Request')},
			 	{startColumnName: 'dw_plan_f', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('DrawingFinish','MakerSelection')},
			 	{startColumnName: 'ow_plan_s', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('OwnerApp.Submit','PurchaseOrder')},
			 	{startColumnName: 'ow_plan_f', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('OwnerApp.Receive','DrawingReceive')},
			 	{startColumnName: 'cl_plan_s', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('ClassApp.Submit','OwnerApp.Submit')},
			 	{startColumnName: 'cl_plan_f', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('ClassApp.Receive','OwnerApp.Receive')},
			 	{startColumnName: 'rf_plan_s', numberOfColumns: 2, titleText: fn_groupHeaderTemplet('Working','MakerWorking')},
			 	{startColumnName: 'wk_plan_s', numberOfColumns: 2, titleText: "<table style='width:100%;border-spacing:0px;'>" +
			        "<tr><td class='commonheadersTop'>Construction</td></tr>" +
			        "</table>"}
			  ]
		});
		//그리드 넘버링 표시
		$("#dataList").jqGrid("setLabel", "rn", "No");
		//컬럼 고정처리
		$("#dataList").jqGrid('setFrozenColumns');
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() );
		
	});
	//지연사유 특기사항
	function fn_delayreason_desc(projectNo,dwgCode,isEditable,designerId,rowid){
	    
	    var paramStr = "projectNo=" + projectNo;
	    paramStr += "&dwgCode=" + dwgCode;
	    paramStr += "&isEditable=" + isEditable;
	    paramStr += "&designerId="+designerId;
		
		var rs = window.showModalDialog("popUpDelayReasonDesc.do?"+paramStr, 
				window, "dialogHeight:300px;dialogWidth:300px; center:on; scroll:off; status:off");

		if(rs != null || rs != undefined){
			rs = rs.replace(/\n/g, "");
			$('#dataList').jqGrid('setCell',rowid, 'delayreason_desc', rs);
		}
	}
	//헤더 그룹핑 템플릿
	function fn_groupHeaderTemplet(topString,bottomString){
		var returnValue = "<table style='width:100%;border-spacing:0px;'>" +
        "<tr><td class='groupheadersTop' style='border-bottom : 1px solid #807fd7;'>"+topString+"</td></tr>" +
        "<tr>" +
            "<td class='groupheadersBottom'>"+bottomString+"</td>" +
        "</tr>" +
        "</table>";
        return returnValue;
	}
	//그리드 내의 데이터 피커
	function fn_normalDatePicker(targetObj,currentData,rowId,colName,limitOption){
		fn_toggleDivPopUp($("#datePickerDiv"),targetObj);
		$("#targetRowId").val('').val(rowId);
		$("#targetName").val('').val(colName);
		$("#limitOption").val('').val(limitOption);
		$("#normalDatePicker").css("width",targetObj.outerWidth());
		$("#normalDatePicker").css("height",targetObj.outerHeight());
		$("#normalDatePicker").val(currentData);
		$("#normalDatePicker").focus().click();
		
	}
	// 지연사유 선택 화면 Show
    function fn_selectReason(targetObj, projectNo, dwgCode, fieldKind, currentData)
    {
    	fn_toggleDivPopUp($("#reasonSelectDiv"),targetObj);
    	var reasonSelect = $("#reasonSelectDiv [name=reasonSelect]");
        for (var i = 0; i < reasonSelect.find("option").size(); i++) {
            var str = reasonSelect.find("option:eq("+i+")").val();
            if (str == currentData) {
            	reasonSelect.find("option:eq("+i+")").attr("selected","true");
            	reasonSelect.focus().click();
            	return;
            } else {
            	reasonSelect.find("option:eq(0)").attr("selected","true");
            	reasonSelect.focus().click();
            	return;
            }
        }
    }
    // 지연사유 선택(입력) 처리
    function fn_reasonSelChanged()
    {
    	var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
    	var rowData = $("#dataList").jqGrid('getRowData',selectRow);
    	var reasonSelectValue = $("#reasonSelectDiv [name=reasonSelect]").val();    	
		
    	$('#dataList').jqGrid('setCell',selectRow, 'delayreason', reasonSelectValue);
    	$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
    	/* $('#dataList').jqGrid('setCell',selectRow, 'oper', 'U'); */
    	
        fn_toggleDivPopUp();
    }
 	// div팝업 선택 화면 Hidden
    function fn_toggleDivPopUp(activeDivObj,targetObj)
    {
 		$(".div_popup").css("display","none");
 		if(activeDivObj != null && activeDivObj != undefined){
 			activeDivObj.css("left",targetObj.offset().left);
 			activeDivObj.css("top",targetObj.offset().top);
 			activeDivObj.css("display","");
 		}
    }
 	//그리드 수정사항 저장
	function fn_saveGridData(saveGrid){
		fn_toggleDivPopUp();
		var savedGrid = $("#"+saveGrid).jqGrid( 'getRowData' );
		if(savedGrid.length == 0) return;
		
		//수정 유무 체크
		if ( !fn_checkGridModify( "#dataList" ) ) {
			return;
		}
		
		var resultData = [];
		var savedRows = savedGrid.concat(resultData);
		var url = 'progressDeviationMainGridSave.do';
		var dataList = { chmResultList : JSON.stringify( savedRows ) };
		var formData = fn_getFormData( '#application_form1' );
		var parameters = $.extend( {}, dataList, formData );
		
		lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post( url, parameters, function( data ) {
			alert(data.resultMsg);
			if ( data.result == 'success' ) {
				$('#btn_search').click();
			}
		}, 'json' ).error( function() {
			alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
		} ).always( function() {
			lodingBox.remove();
		} );
	}
	function onlyUpperCase(obj) {
		obj.value = obj.value.toUpperCase();	
	}
</script>
</body>
</html>
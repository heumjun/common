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
<title>일일시수 결재관리</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
#personList .jqgrow{
    cursor:pointer;
}

</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		일일시수 결재관리
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include> 
		<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="dept_name" value="${loginUserInfo.dept_name }" />
	    <input type="hidden" name="user_name" value="${loginUserInfo.name }" />    
	    <input type="hidden" name="user_title" value="${loginUserInfo.title }" />
	    <input type="hidden" name="is_manager" value="${loginUserInfo.is_manager }" />
	    <input type="hidden" name="target_emp_num" value="" />
	    <input type="hidden" name="target_emp_name" value="" />
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="5%"/>
				<col width="20%"/>
				<col width="5%"/>
				<col width="20%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="*"/>
				<tr>
					<th>부서</th>
					<td>
						<select id="departmentList" name="departmentList">
							<c:choose>
								<c:when test="${loginUserInfo.is_admin eq 'Y' }">
									<c:forEach var="item" items="${departmentList }">
										<option value="${item.dept_code}" <c:if test="${loginUserInfo.dept_code eq item.dept_code }">selected="selected"</c:if>>${item.dept_code} ${item.dept_name}</option>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<option value="${loginUserInfo.dept_code}">${loginUserInfo.dept_code} ${loginUserInfo.dept_name}</option>
								</c:otherwise>
							</c:choose>
						</select>
					</td>
					<th>일자</th>
					<td>
						<input type="text" id="p_created_date" value="" name="dateselected" class="datepicker" style="width: 50%; text-align: center;"  readonly="readonly"/>
						<input type="text" name="workingdayYn" value="" readonly="readonly" style="background: #c8c8c4; font-weight: bold; width: 30%; text-align: center;" />
					</td>
					<td style="border-right-color: rgb(247, 247, 247);">
						<input type="button" value="결재 조회" class="btn_gray2" onclick="showApprovalsViewWin();"/>
						<input type="button" value="입력율 조회" class="btn_gray2" onclick="showInputRateViewWin();"/>
						<input type="button" value="휴일 체크" class="btn_gray2" onclick="showHolidayCheckWin();"/>
					</td>
					<td style="text-align: right;">
						<input type="button" value="조회" class="btn_gray2" id="btn_search"/>
						<input type="button" value="저장" class="btn_gray2" id="btn_save"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="content" id="boardDiv">
			<font color="blue">현황 더블클릭 시 해당 일자로 조회됩니다.</font>
			<table class="insertArea">
				<tr bgcolor="#e5e5e5" id="monthRow">
					<th>
						<span id="month"></span>월            				
           			</th>
           			<th>
           				일자
           			</th>
				</tr>
				<tr id="inputRateRow">
           			<td bgcolor="#e5e5e5">
           				입력현황            				
           			</td>
           			<td bgcolor="#e5e5e5">
           				%
           			</td>
            	</tr>
            	<tr id="approvalListRow">
           			<td bgcolor="#e5e5e5">
           				결재현황            				
           			</td>
           			<td bgcolor="#e5e5e5">
           				Y/N
           			</td>
            	</tr>
			</table>
		</div>
		<div class="content" id="boardTotalDiv">
			<table class="searchArea2">
		        <tr>
		        	<th>[전체결재]</th>
		            <td width="420">
		            	<input type="radio" name="ApprovalAllSelect" id="ApprovalAllSelect" value="APPROVE_ALL" onClick="checkAll();" />선택&nbsp;&nbsp;&nbsp;&nbsp;
		               	<input type="radio" name="ApprovalAllSelect" id="ApprovalAllSelect2" value="APPROVE_NONE" onClick="unCheckAll();" />해제
		            </td>
		            <th>[부서정보]</th>
		            <td>
					                총시수: <input type="text" name="workTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;font-weight:bold;text-align:center;" />
					                정상: <input type="text" name="normalTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;font-weight:bold;text-align:center;" />
					                연장: <input type="text" name="overtimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;font-weight:bold;text-align:center;" />
					                특근: <input type="text" name="specialTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;font-weight:bold;text-align:center;" />
		            </td>
		            <th>[개인정보]</th>
		            <td>
					                사번: <input type="text" name="personInfo" value="" readonly style="background-color:#D8D8D8;width:100px;border:0;color:#000000;font-weight:bold;text-align:center;" />
					                총시수: <input type="text" name="personWorkTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;font-weight:bold;text-align:center;" />
					                정상: <input type="text" name="personNormalTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;font-weight:bold;text-align:center;" />
					                연장: <input type="text" name="personOvertime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;font-weight:bold;text-align:center;" />
					                특근: <input type="text" name="personSpecialTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;font-weight:bold;text-align:center;" />
		            </td>
		        </tr>
		    </table>
		</div>
		<div id="personListHeaderDiv" style="width: 30%; float:left;">
		</div>
		<div id="dataListHeaderDiv" style="width: 70%; float:left;">
		</div>
		<div style="clear: both;"></div>
		<div id="personListDiv" style="width: 30%; float:left;">
			<table id="personList"></table>
			<div id="pPersonDataList"></div>
		</div>
		<div id="dataListDiv" style="width: 70%; float:left;">
			<table id="dataList"></table>
			<div id="pDataList"></div>
		</div>
		<div id="dataOceanListDiv" style="width: 30%; float:left; display: none;">
			<table id="dataOceanList"></table>
			<div id="pDataOceanList"></div>
		</div>
		<div class="content" style="clear: both;">
			<input type="hidden" name="drawingNo" value="" />
			<table style="margin-top:3px">
				<tr>
					<td><span style="font-size: 11pt; font-family: 돋움; font-weight: bold;"> ※ DP 공정 ※ </span>
						<table class="insertArea">
							<tr>
								<td bgcolor="deepskyblue">계획</td>
								<td><input name="dwPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="dwPlanFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owPlanFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clPlanFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="rfPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="wkPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td class="td_standardBold"><input name="planMH" value="" readonly
									style="background-color: #D8D8D8; width: 80px; border: 0; color: #ff0000; font-weight: bold; text-align: center;" />
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan="2" align="center"><img src="/AddOn/DP/images/stxTemp1.jpg" /><br> <font size="2"
									face="돋움"><b>착수일</b></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font size="2" face="돋움"><b>완료일</b></font></td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp2.jpg" /><br> <font size="2" face="돋움"><b>선주승인발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp3.jpg" /><br> <font size="2" face="돋움"><b>선주승인접수</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp4.jpg" /><br> <font size="2" face="돋움"><b>선급승인발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp5.jpg" /><br> <font size="2" face="돋움"><b>선급승인접수</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp6.jpg" /><br> <font size="2" face="돋움"><b>참고용발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp7.jpg" /><br> <font size="2" face="돋움"><b>작업용발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp8.jpg" /><br> <font size="2" face="돋움"><b>시수</b></font>
								</td>
							</tr>
							<tr>
								<td bgcolor="deepskyblue">실적</td>
								<td><input name="dwActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="dwActualFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owActualFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clActualFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="rfActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="wkActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td class="td_standardBold">
									<input name="actualMH" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0; color: #ff0000; font-weight: bold; text-align: center;" />
								</td>
							</tr>
						</table></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<script type="text/javascript">
//일반 자바스크립트 
	//상단 헤더 명
	function partListHeaderChange(){
		$("#personListHeaderDiv").html("");
		var deptName = application_form.departmentList.options[application_form.departmentList.selectedIndex].text;
        deptName = $.trim(deptName.split(" ")[1]);
		$("#personListHeaderDiv").append(deptName+"   "+application_form.dateselected.value);
	}
	//세부 헤더 명
	function partPersonHeaderChange(name){
		$("#dataListHeaderDiv").html("");
		$("#dataListHeaderDiv").append(name+"   "+application_form.dateselected.value);
	}
	//detail 초기화
	function partPersonDetailInit(){
		$("#dataListHeaderDiv").html("");
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		application_form.personInfo.value = "";
        application_form.personWorkTime.value = "";
        application_form.personNormalTime.value = "";
        application_form.personOvertime.value = "";
        application_form.personSpecialTime.value = "";
        
        application_form.target_emp_num.value = "";
		application_form.target_emp_name.value = "";
	}
	// 파트 구성원 목록의 모든 항목을 체크
    function checkAndUnCheck()
    {
    	if(document.getElementById('ApprovalAllSelect').checked){
    		checkAll();
    	} else {
    		unCheckAll();
    	}
    }
    // 체크박스 모두 선택 
    function checkAll()
    {
    	var rows = $( "#personList" ).getDataIDs();
    	for(var i=0; i<rows.length; i++)
    	{
			var rowData = $('#personList').jqGrid('getRowData', rows[i]);
			//시수입력 완료가 안된 대상은 선택 되면 안됨
			if($('#personList #'+rows[i]).find("input[type=checkbox]").attr("disabled") != "disabled")
			{
				$('#personList').jqGrid('setCell',rows[i], 'confirm_yn', 'Y');
			}
    	}	
    }

    // 체크박스 모두 선택 해제
    function unCheckAll()
    {
    	var rows = $( "#personList" ).getDataIDs();
    	for(var i=0; i<rows.length; i++)
    	{
			var rowData = $('#personList').jqGrid('getRowData', rows[i]);
			//시수입력 완료가 안된 대상은 선택 되면 안됨
			if($('#personList #'+rows[i]).find("input[type=checkbox]").attr("disabled") != "disabled")		
			{
				$('#personList').jqGrid('setCell',rows[i], 'confirm_yn', 'N');
			}
    	}
    }
    
    //board 생성처리
    function boardRowCreate(){
    	//일자 생성
    	var selectedDate = application_form.dateselected.value.split("-");
    	var firstDate = (new Date( selectedDate[0], selectedDate[1], 1)).getDate();
    	var lastDate = (new Date( selectedDate[0], selectedDate[1], 0)).getDate();
    	var monthRow = $("#monthRow");
    	var approvalRow = $("#approvalListRow");
    	var dpInputRateRow = $("#inputRateRow");
    	
    	monthRow.find(".addMonthRow").remove();
    	approvalRow.find(".addApprovalRow").remove();
    	dpInputRateRow.find(".addInputRateRow").remove();
    	
    	for(var i= firstDate; i <= lastDate; i++){
    		monthRow.append("<th class='addMonthRow'>"+i+"</th>");
    	}
    	//getPartDPConfirmsList 결재현황
    	$.ajax({
	       	url:'<c:url value="getPartDPConfirmsList.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"dept_code" : application_form.departmentList.value,
	       			"dateFrom":selectedDate[0]+"-"+selectedDate[1]+"-"+firstDate,
	       			"dateTo":selectedDate[0]+"-"+selectedDate[1]+"-"+lastDate},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		var error = false;
	       		for(var i=0; i<jsonData.rows.length; i++){
	       			var rows = jsonData.rows[i];
	       			if(rows.error != undefined || rows.error != null){
	       				error = true;
	       				break;
	       			}
	       			var bgColor = "";
	       			if(rows.confirm_yn == "N") bgColor = "#FFB2F5";
	       			approvalRow.append("<td class='addApprovalRow' bgcolor='"+bgColor+"' ondblclick='approvalViewCallBack(\""+rows.work_day+"\")'>"+rows.confirm_yn+"</td>");
	       		}
	       		if(error){
	       			alert("Error 발생. 관리자에게 문의하세요");
	       			for(var i= firstDate; i <= lastDate; i++){
	       				approvalRow.append("<td class='addApprovalRow'></td>");
	       	    	}
	       		}
	       	}, 
	       	error : function(e){
	       		alert("Error 발생. 관리자에게 문의하세요");
	       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	       	}
        });
    	
    	//getPartDPInputRateList 시수입력율
    	$.ajax({
	       	url:'<c:url value="getPartDPInputRateList.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"dept_code" : application_form.departmentList.value,
	       			"dateFrom":selectedDate[0]+"-"+selectedDate[1]+"-"+firstDate,
	       			"dateTo":selectedDate[0]+"-"+selectedDate[1]+"-"+lastDate},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		var error = false;
	       		for(var i=0; i<jsonData.rows.length; i++){
	       			var rows = jsonData.rows[i];
	       			if(rows.error != undefined || rows.error != null){
	       				error = true;
	       				break;
	       			}
	       			var displayStr =rows.input_rate;
	       			// 평일일 경우 시수입력율이 100% 미만일 때 빨간색 표시
	       			if(rows.is_work_day == "Y"){
	       				if(rows.input_rate != "-"){
	       					if(parseInt(rows.input_rate) < 100){
	       						displayStr = "<font color='red'>"+displayStr+"%</font>";
	       					} else {
	       						displayStr += "%";
	       					}
	       				}
	       			} else{
	       				// 휴일일 경우는 입력율만 표시
	       				if(rows.input_rate != "-"){
	       					displayStr += "%";	
	       				}
	       			}
	       			dpInputRateRow.append("<td class='addInputRateRow' ondblclick='approvalViewCallBack(\""+rows.work_day+"\")'>"+displayStr+"</td>");
	       		}
	       		if(error){
	       			alert("Error 발생. 관리자에게 문의하세요");
	       			for(var i= firstDate; i <= lastDate; i++){
	       				dpInputRateRow.append("<td class='addInputRateRow'></td>");
	       	    	}
	       		}
	       	}, 
	       	error : function(e){
	       		alert("Error 발생. 관리자에게 문의하세요");
	       		alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	       	}
        });
    }
    
	// 결재조회 화면 Show
    function showApprovalsViewWin() 
    {
        var sProperties = 'dialogHeight:500px;dialogWidth:500px;scroll=no;center:yes;resizable=no;status=no;';
		var paramStr = "dept_code=" + application_form.departmentList.value;
        
		var rs = window.showModalDialog("popUpApprovalListView.do?"+paramStr, window, sProperties);

		if(rs != null && rs != undefined){
		}
    }
    //결재조회 화면 일자 더블클릭
    function approvalViewCallBack(dateStr){
    	var prevVal = application_form.dateselected.value;
    	application_form.dateselected.value = dateStr;
    	fn_holidayCheck(dateStr,application_form.workingdayYn);
		partPersonSearch();
    }
 	// 입력율조회 화면 Show
    function showInputRateViewWin() 
    {
        var deptName = application_form.departmentList.options[application_form.departmentList.selectedIndex].text;
        deptName = $.trim(deptName.split(" ")[1]);
        var sProperties = 'dialogHeight:400px;dialogWidth:700px;scroll=no;center:yes;resizable=no;status=no;';
        /* var paramStr = "dept_code=" + application_form.departmentList.value
        				+"&dept_name="+encodeURIComponent(deptName); */
        var paramObj = new function() {
			this.window = window;
            this.dept_code = application_form.departmentList.value;
            this.dept_name = deptName;
        }
        var rs = window.showModalDialog("popUpApprovalInputRateView.do", paramObj, sProperties);
        if(rs != null && rs != undefined){
		}
    }
 	// 휴일체크 화면 Show
    function showHolidayCheckWin() 
    {
    	var deptName = application_form.departmentList.options[application_form.departmentList.selectedIndex].text;
        deptName = $.trim(deptName.split(" ")[1]);

        var sProperties = 'dialogHeight:400px;dialogWidth:700px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
			this.window = window;
            this.dept_code = application_form.departmentList.value;
            this.dept_name = deptName;
        }
       /*  var paramStr = "dept_code=" + application_form.departmentList.value
		+"&dept_name="+encodeURIComponent(deptName); */
        var rs = window.showModalDialog("popUpApprovalHolidayCheckView.do", paramObj, sProperties);
        if(rs != null && rs != undefined){
		}
        /* var dhHolidayCheckResult = window.showModalDialog("stxPECDPApproval_HolidayCheckFS.do", paramObj, sProperties); */
    }
</script>
<script type="text/javascript">
var prevDate = "";
$(document).ready(function(){
	fn_toDate("p_created_date");
	
	$( "#p_created_date" ).datepicker( {
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
		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		onSelect: function( selectedDate,i) {
			prevDate = i.lastVal;
			var prevAry = i.lastVal.split("-");
			var selectAry = selectedDate.split("-");
			var check = false;
			
			if(prevAry[0] != selectAry[0]){
				check = true;
			}
			else if(prevAry[1] != selectAry[1]){
				check = true;
			}
			if(check)boardRowCreate();
			fn_holidayCheck(selectedDate,application_form.workingdayYn);
			partPersonSearch();
		}
	} );
	//저장 처리
	$("#btn_save").click(function(){

		var chmResultRows = [];
		if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
			    // 시수결재 or 해제 대상 추출
				getChangedChmResultData(function(data){
					if(data.length == 0){
						alert("저장할 데이터가 없습니다");
						return;
					}
					chmResultRows = data;
			
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					
					var url = 'dpApprovalMainGridSave.do';
					var formData = fn_getFormData('#application_form');
					var parameters = $.extend({}, dataList, formData);
					
					lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					$.post( url, parameters, function( data2 ) {
						alert(data2.resultMsg);
						if ( data2.result == 'success' ) {
							$("#btn_search").click();
						}
					}, "json" ).error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						lodingBox.remove();
					} );
				});
		}
	});
	//조회 처리
	$("#btn_search").click(function(){
		boardRowCreate();
		partPersonSearch();
	});
	
});
//부서 인원 결재조회 
function partPersonSearch(){
	partPersonDetailInit();
	//그리드 갱신을 위한 작업
	$( '#personList' ).jqGrid( 'clearGridData' );
	//그리드 postdata 초기화 후 그리드 로드 
	$( '#personList' ).jqGrid( 'setGridParam', {postData : null});
	$( '#personList' ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : '<c:url value="dpApprovalPersonMainGrid.do"/>',
		datatype : 'json',
		page : 1,
		postData :fn_getFormData($('#application_form'))
	} ).trigger( 'reloadGrid' );
}
//부서 인원 상세 결재조회 
function partPersonDetailSearch(){
	//그리드 갱신을 위한 작업
	$( '#dataList' ).jqGrid( 'clearGridData' );
	//그리드 postdata 초기화 후 그리드 로드 
	$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
	$( '#dataList' ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : '<c:url value="dpApprovalPersonDetailMainGrid.do"/>',
		datatype : 'json',
		page : 1,
		postData :fn_getFormData($('#application_form'))
	} ).trigger( 'reloadGrid' );
}
//계획 시수 대비 초과내역 조회 
function partPersonDetailOceanSearch(){
	//그리드 갱신을 위한 작업
	$( '#dataOceanList' ).jqGrid( 'clearGridData' );
	//그리드 postdata 초기화 후 그리드 로드 
	$( '#dataOceanList' ).jqGrid( 'setGridParam', {postData : null});
	$( '#dataOceanList' ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : '<c:url value="dpApprovalPersonDetailOceanMainGrid.do"/>',
		datatype : 'json',
		page : 1,
		postData :fn_getFormData($('#application_form'))
	} ).trigger( 'reloadGrid' );
}
//오늘날짜
function fn_toDate( to_date ) {
	var url = 'selectWeekList.do';

	$.post( url, "", function( data ) {
		$( "#" + to_date ).val( data.created_date_end );
		fn_holidayCheck(data.created_date_end,application_form.workingdayYn);
		boardRowCreate();
		partPersonSearch();
	}, "json" );
}
//휴일 체크
function fn_holidayCheck(dateValue,displayObj){
	var workingDayYN = "N";
	$.ajax({
       	url:'<c:url value="getDateHolidayInfo.do"/>',
       	type:'POST',
       	async: false,
       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
       	data : {"selectDate" : dateValue},
       	success : function(data){
       		workingDayYN = data;
       		if(displayObj != undefined && displayObj != null)
  			{
       			if (workingDayYN == 'Y') $(displayObj).val("평일");
       			else if (workingDayYN == 'N')$(displayObj).val("휴일");
                else $(displayObj).val(workingDayYN);
  			}
       	}, 
       	error : function(e){
       		alert(e);
       		return;
       	}
    });
}
//가져온 배열중에서 필요한 배열만 골라내기
function getChangedChmResultData(callback ) {
	var resultData = []; 
	var changedData = $.grep( $( "#personList" ).jqGrid( 'getRowData' ), function(obj) {
		// 시수입력 완료된 대상(즉, checkbox disabled 안 된것 )의 시수결재 여부 정보 리턴
		return (obj.inputdone_yn == 'Y' && (obj.confirm_yn == 'Y' || obj.confirm_yn == 'N'));
	} );
	callback.apply(this, [ changedData.concat(resultData) ]);
}
</script>
<script type="text/javascript">
	//체크 인원 관련 그리드
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#personList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['사번','성명','시수','FCT.','완료','결재','normal','special','overtime'],
			colModel : [
			            	{name : 'employee_num', index : 'employee_num', width: 10, align : "center"},
							{name : 'name', index : 'name', width: 25, align : "center"},
							{name : 'worktime', index : 'worktime', width: 10, align : "center"},
							{name : 'mh_factor', index : 'mh_factor', width: 10, align : "center"},
							{name : 'inputdone_yn', index : 'inputdone_yn', width: 10, align : "center"},
							{name : 'confirm_yn', index : 'confirm_yn', width: 5, align : "center", 
									editable:true, edittype:'checkbox', editoptions: { value:"Y:N" }, 
									formatter: "checkbox", formatoptions: {disabled : false}
							},
							{name : 'normal', index : 'normal', width: 10, align : "center", hidden:true},
							{name : 'special', index : 'special', width: 10, align : "center", hidden:true},
							{name : 'overtime', index : 'overtime', width: 10, align : "center", hidden:true}
			           ],
	        gridview : true,
	   		cmTemplate: { title: true,sortable: false},
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true,
	   		height : objectHeight,	   		
	   		rowNum : -1,
	   		rownumbers: true,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pPersonDataList'),
	   		cellEdit : true, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
			loadComplete: function (data) {
			},
			onCellSelect : function(rowid, iCol,  cellcontent,e){
				var rowData = $('#personList').jqGrid('getRowData', rowid);
				application_form.target_emp_num.value = rowData.employee_num;
				application_form.target_emp_name.value = rowData.name;
				
				partPersonHeaderChange(rowData.name);
				partPersonDetailSearch();
			},
			gridComplete : function() {
				partListHeaderChange();
				var rows = $( "#personList" ).getDataIDs();
				var normalTimeSum = 0;
				var overTimeSum = 0;
				var specialTimeSum = 0;
				var workTimeSum = 0;
				
				for(var i=0; i<rows.length; i++){
					var rowData = $('#personList').jqGrid('getRowData', rows[i]);
					normalTimeSum += (isNaN(parseFloat(rowData.normal))? 0 : parseFloat(rowData.normal));
					overTimeSum += (isNaN(parseFloat(rowData.overtime))? 0 : parseFloat(rowData.overtime));
					specialTimeSum += (isNaN(parseFloat(rowData.special))? 0 : parseFloat(rowData.special));
					workTimeSum += (isNaN(parseFloat(rowData.worktime))? 0 : parseFloat(rowData.worktime));
					if(rowData.inputdone_yn != "Y"){
						$('#personList').jqGrid('setCell',rows[i], 'inputdone_yn', '', {background : '#BFFFEF;' });
						// 시수입력 미완료 대상은 checkbox disabled 처리
						$("#personList #"+rows[i]).find("input[type=checkbox]").attr("disabled",true);
						
					}
					if(rowData.confirm_yn == '' || rowData.confirm_yn == null || rowData.confirm_yn == undefined)
						$("#personList").jqGrid('setCell', rows[i], 'confirm_yn', 'N');
					if(rowData.inputdone_yn == '' || rowData.inputdone_yn == null || rowData.inputdone_yn == undefined)
						$("#personList").jqGrid('setCell', rows[i], 'inputdone_yn', 'N');
					$('#personList').jqGrid('setCell',rows[i], 'employee_num', '', {color : 'blue' });
					$('#personList').jqGrid('setCell',rows[i], 'mh_factor', '', {color : 'silver' });
					
				}
				application_form.normalTimeTotal.value = normalTimeSum;
				application_form.workTimeTotal.value = workTimeSum;
				application_form.overtimeTotal.value = overTimeSum;
				application_form.specialTimeTotal.value = specialTimeSum;
				
				
			}
		});
		$( "#personList" ).jqGrid( 'navGrid', "#pPersonDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 넘버링 표시
		$("#personList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#personList"), $("#personListDiv"),0.44);
	});	
</script>
<script type="text/javascript">
	//체크 인원 관련 그리드
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['시각','공사번호','도면번호','OP','OP2','원인부서','관련근거','업무내용','EVENT1','EVENT2','EVENT3','선종','시수',
			            'normal','overtime','special','event1_str','event2_str','event3_str'],
			colModel : [
			            	{name : 'start_time', index : 'start_time', width: 40, align : "center"},
							{name : 'project_no', index : 'project_no', width: 40, align : "center"},
							{name : 'dwg_code', index : 'dwg_code', width: 60, align : "center"},
							{name : 'op_code', index : 'op_code', width: 20, align : "center"},
							{name : 'op_str', index : 'op_str', width: 20, align : "center", hidden:true},
							{name : 'cause_depart', index : 'cause_depart', width: 70, align : "center"},
							{name : 'basis', index : 'basis', width: 70, align : "center"},
							{name : 'work_desc', index : 'work_desc', width: 150, align : "center"},
							{name : 'event1', index : 'event1', width: 40, align : "center"},
							{name : 'event2', index : 'event2', width: 40, align : "center"},
							{name : 'event3', index : 'event3', width: 40, align : "center"},
							{name : 'ship_type', index : 'ship_type', width: 40, align : "center"},
							{name : 'work_time', index : 'work_time', width: 30, align : "center"},
							{name : 'normal_time', index : 'normal_time', width: 30, align : "center", hidden:true},
							{name : 'overtime', index : 'overtime', width: 30, align : "center", hidden:true},
							{name : 'special_time', index : 'special_time', width: 30, align : "center", hidden:true},
							{name : 'event1_str', index : 'event1_str', width: 30, align : "center", hidden:true},
							{name : 'event2_str', index : 'event2_str', width: 30, align : "center", hidden:true},
							{name : 'event3_str', index : 'event3_str', width: 30, align : "center", hidden:true}
			           ],
	        gridview : true,
	   		cmTemplate: { title: true,sortable: false},
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true,
	   		height : objectHeight,	   		
	   		rowNum : -1,
	   		rownumbers: true,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pDataList'),
	   		cellEdit : false, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
			loadComplete: function (data) {
			},
			onCellSelect : function(rowid, iCol,  cellcontent,e){
				var rowData = jQuery(this).getRowData(rowid);
				
				updateDrawingInfo(rowData.project_no, rowData.dwg_code);
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				var normalTimeSum = 0;
				var overTimeSum = 0;
				var specialTimeSum = 0;
				var workTimeSum = 0;
				for(var i=0; i<rows.length; i++){
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					if(rowData.event1 != "")$("#dataList").jqGrid('setCell', rows[i], 'event1', rowData.event1+":"+rowData.event1_str);
					if(rowData.event2 != "")$("#dataList").jqGrid('setCell', rows[i], 'event2', rowData.event2+":"+rowData.event2_str);
					if(rowData.event3 != "")$("#dataList").jqGrid('setCell', rows[i], 'event3', rowData.event3+":"+rowData.event3_str);
					var normalTime = (isNaN(parseFloat(rowData.normal_time))? 0 : parseFloat(rowData.normal_time));
					var overTime = (isNaN(parseFloat(rowData.overtime))? 0 : parseFloat(rowData.overtime));
					var specialTime = (isNaN(parseFloat(rowData.special_time))? 0 : parseFloat(rowData.special_time));
					var workTime = normalTime + overTime + specialTime;
					$("#dataList").jqGrid('setCell', rows[i], 'work_time', workTime);
					
					$('#dataList').jqGrid('setCell',rows[i], 'start_time', '', {color : 'blue' });
					
					normalTimeSum += normalTime;
					overTimeSum += overTime;
					specialTimeSum += specialTime;
				}
				workTimeSum = normalTimeSum + overTimeSum + specialTimeSum;
				
				application_form.personInfo.value = application_form.target_emp_num.value + "  " + application_form.target_emp_name.value;
				application_form.personNormalTime.value = normalTimeSum;
				application_form.personWorkTime.value = workTimeSum;
				application_form.personOvertime.value = overTimeSum;
				application_form.personSpecialTime.value = specialTimeSum;
				
				$.ajax({
			       	url:'<c:url value="getDwgDeptGubun.do"/>',
			       	type:'POST',
			       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			       	async: false,
			       	data : {"dept_code" : application_form.departmentList.value},
			       	success : function(data){
			       		if(data == "2"){
			       			$("#dataListDiv").css("width","40%");
			       			$("#dataOceanListDiv").css("display","inline-block");
			       			partPersonDetailOceanSearch();
			       		} else {
			       			$("#dataListDiv").css("width","70%");
			       			$("#dataOceanListDiv").css("display","none");
			       		}
			       	}, 
			       	error : function(e){
			       		alert(e);
			       	}
		        });
			}
		});
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 넘버링 표시
		$("#dataList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.44);
	});	
</script>
<script type="text/javascript">
	//체크 인원 관련 그리드
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataOceanList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['공사번호','도면번호','계획시수','실적시수','초과시수'],
			colModel : [
			            	{name : 'project_no', index : 'project_no', width: 10, align : "center"},
							{name : 'dwg_code', index: 'dwg_code', width: 25, align : "center"},
							{name : 'plan_mh', index : 'plan_mh', width: 25, align : "center"},
							{name : 'actual_mh', index : 'actual_mh', width: 25, align : "center"},
							{name : 'diff_mh', index : 'diff_mh', width: 25, align : "center"}
			           ],
	        gridview : true,
	   		cmTemplate: { title: true,sortable: false},
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		caption : "계획 시수 대비 초과내역",
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true,
	   		height : objectHeight,	   		
	   		rowNum : -1,
	   		rownumbers: true,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pDataOceanList'),
	   		cellEdit : true, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
			loadComplete: function (data) {
			},
			onCellSelect : function(rowid, iCol,  cellcontent,e){
			},
			gridComplete : function() {
				partListHeaderChange();
				var rows = $( "#dataOceanList" ).getDataIDs();
				var check = false;
				for(var i=0; i<rows.length; i++){
					var rowData = $('#dataOceanList').jqGrid('getRowData', rows[i]);
					
					var tdBgColor = "#ffffff";
					
                    if (rowData.diff_mh != ''|| rowData.diff_mh == null ){
                    	check = true;
                    	tdBgColor = "#ff0000";
                    }
                    $('#dataOceanListDiv').jqGrid('setCell',rows[i], 'diff_mh', '', {background : tdBgColor });
				}
				if(!check){
                	$("#dataListDiv").css("width","70%");
	       			$("#dataOceanListDiv").css("display","none");
                }
				
			}
		});
		$( "#dataOceanList" ).jqGrid( 'navGrid', "#pDataOceanList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 넘버링 표시
		$("#dataOceanList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#dataOceanList"), $("#dataOceanListDiv"),0.44);
		
		
	});	
	
	// 해당 호선 + 도면에 대한 공정 계획일, 실적일 데이터를 쿼리하여 표시
	function updateDrawingInfo(projectNo, drawingNo) {
		if (application_form.drawingNo.value == drawingNo)
			return;
		application_form.drawingNo.value = drawingNo;

		initializeProgressDates();

		if (projectNo == '' || projectNo == 'S000' || drawingNo == '' || drawingNo == '*****' || drawingNo == '#####')
			return;
		
		$.ajax({
	    	url:'<c:url value="getDesignProgressInfo.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"projectNo" : projectNo,
	    			"drawingNo" : drawingNo},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		if(jsonData == null)return;
	    		application_form.dwPlanStart.value = jsonData.dw_plan_s 	== undefined ? "" :jsonData.dw_plan_s;
				application_form.dwPlanFinish.value = jsonData.dw_plan_f 	== undefined ? "" :jsonData.dw_plan_f;
				application_form.dwActualStart.value = jsonData.dw_act_s 	== undefined ? "" :jsonData.dw_act_s;
				application_form.dwActualFinish.value = jsonData.dw_act_f 	== undefined ? "" :jsonData.dw_act_f;
				application_form.owPlanStart.value = jsonData.ow_plan_s 	== undefined ? "" :jsonData.ow_plan_s;
				application_form.owPlanFinish.value = jsonData.ow_plan_f 	== undefined ? "" :jsonData.ow_plan_f;
				application_form.owActualStart.value = jsonData.ow_act_s 	== undefined ? "" :jsonData.ow_act_s;
				application_form.owActualFinish.value = jsonData.ow_act_f 	== undefined ? "" :jsonData.ow_act_f;
				application_form.clPlanStart.value = jsonData.cl_plan_s 	== undefined ? "" :jsonData.cl_plan_s;
				application_form.clPlanFinish.value = jsonData.cl_plan_f 	== undefined ? "" :jsonData.cl_plan_f;
				application_form.clActualStart.value = jsonData.cl_act_s 	== undefined ? "" :jsonData.cl_act_s;
				application_form.clActualFinish.value = jsonData.cl_act_f 	== undefined ? "" :jsonData.cl_act_f;
				application_form.rfPlanStart.value = jsonData.rf_plan_s 	== undefined ? "" :jsonData.rf_plan_s;
				application_form.rfActualStart.value = jsonData.rf_act_s 	== undefined ? "" :jsonData.rf_act_s;
				application_form.wkPlanStart.value = jsonData.wk_plan_s 	== undefined ? "" :jsonData.wk_plan_s;
				application_form.wkActualStart.value = jsonData.wk_act_s 	== undefined ? "" :jsonData.wk_act_s;
				application_form.planMH.value = jsonData.planmh 			== undefined ? "" :jsonData.planmh;
				application_form.actualMH.value = jsonData.actualmh 		== undefined ? "" :jsonData.actualmh;
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
	// 계획일, 실적일 전체 항목들의 표시를 ''로 초기화 
	function initializeProgressDates() {
		application_form.dwPlanStart.value = "";
		application_form.dwPlanFinish.value = "";
		application_form.owPlanStart.value = "";
		application_form.owPlanFinish.value = "";
		application_form.clPlanStart.value = "";
		application_form.clPlanFinish.value = "";
		application_form.rfPlanStart.value = "";
		application_form.wkPlanStart.value = "";
		application_form.dwActualStart.value = "";
		application_form.dwActualFinish.value = "";
		application_form.owActualStart.value = "";
		application_form.owActualFinish.value = "";
		application_form.clActualStart.value = "";
		application_form.clActualFinish.value = "";
		application_form.rfActualStart.value = "";
		application_form.wkActualStart.value = "";
		application_form.planMH.value = "";
		application_form.actualMH.value = "";
	}
	
</script>
</body>
</html>
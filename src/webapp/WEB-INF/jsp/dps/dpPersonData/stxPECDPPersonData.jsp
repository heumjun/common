<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
%>
<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>개인 별 시수조회</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<style type="text/css">
    .hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
    }   
     /*헤더 개행처리*/
    th.ui-th-column div{
	word-wrap: break-word; /* IE 5.5+ and CSS3 */
	    white-space: pre-wrap; /* CSS3 */
	    white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
	    white-space: -pre-wrap; /* Opera 4-6 */
	    white-space: -o-pre-wrap; /* Opera 7 */
	    overflow: hidden;
	    height: auto;
	    vertical-align: middle;
	    padding-top: 3px;
	    padding-bottom: 3px;
	    height:auto !important;
	}
	/*글자수 오버 시 Warp처리*/
    .ui-jqgrid tr.jqgrow td:nth-child(3), .ui-jqgrid tr.jqgrow td:nth-child(5){
        word-wrap: break-word; /* IE 5.5+ and CSS3 */
        white-space: pre-wrap; /* CSS3 */
        white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
        white-space: -pre-wrap; /* Opera 4-6 */
        white-space: -o-pre-wrap; /* Opera 7 */
        overflow: hidden;
        height: auto;
        vertical-align: middle;
        padding-top: 3px;
        padding-bottom: 3px
    }
	
</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		개인 별 시수조회
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="isManager" value="${loginUserInfo.is_manager}" />
		<input type="hidden" name="excelHeaderName" value=""/>
		<input type="hidden" name="excelHeaderKey" value=""/>
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="7%"/>
				<col width="25%"/>
				<col width="7%"/>
				<col width="17%"/>
				<col width="7%"/>
				<col width="25%"/>
				<col width="*"/>
				<tr>
					<th>부서</th>
					<td>
						<c:choose>
							<c:when test="${loginUserInfo.is_admin eq 'Y'}">
								<input type="text" name="departmentList" value="" style="width: 70%;" onmouseover="showDeptHint(this);"  readonly="readonly"/>
								<input type="button" name="departmentButton" value="검색" class="btn_gray2" id="btn_department_no"/>
								<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
							</c:when>
							<c:when test="${loginUserInfo.is_manager eq 'Y'}">
								<input type="text" name="departmentList" value=<c:choose><c:when test="${loginUserInfo.dept_code_list ne null}">
								 																					'<c:forEach items="${loginUserInfo.dept_code_list }" var="item" varStatus="status">${item.dept_code }<c:if test="${!status.last }">,</c:if></c:forEach>'
								 																				</c:when>
								 																				<c:otherwise>'${loginUserInfo.dept_code}'</c:otherwise>
								 																	</c:choose> style="width: 70%;" onmouseover="showDeptHint(this);"  readonly="readonly"/>
								<input type="button" name="departmentButton" value="검색" class="btn_gray2" id="btn_department_no"/>								
							</c:when>
							<c:otherwise>
								 <input type="text" name="departmentList" style="width: 70%;" value=<c:choose><c:when test="${loginUserInfo.dept_code_list ne null}">
								 																					'<c:forEach items="${loginUserInfo.dept_code_list }" var="item" varStatus="status">${item.dept_code }<c:if test="${!status.last }">,</c:if></c:forEach>'
								 																				</c:when>
								 																				<c:otherwise>'${loginUserInfo.dept_code}'</c:otherwise>
								 																	</c:choose>  readonly="readonly" />
							</c:otherwise>
						</c:choose>
					</td>
					<th>일자</th>
					<td>
						<input type="text" id="p_created_date_start" value="" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 65px;"  />
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 65px;" />
					</td>
					<th>적용 CASE</th>
					<td>
						<select name="factorCaseList" style="width: 90%;" <c:if test="${loginUserInfo.is_admin ne 'Y' and loginUserInfo.is_manager ne 'Y' }"> disabled="disabled"</c:if>>
							<c:set var="factorCase" scope="page" value="${factorCaseList[0].case_no }"/>
							<c:set var="factorCaseSelected" scope="page" value="${factorCaseList[0].active_case_yn }"/>
							<c:set var="factorCaseStr" scope="page" value=""/>
							<c:forEach var="item" items="${factorCaseList }">
								<c:choose>
									<c:when test="${item.case_no ne factorCase }">									
										<option value="${factorCase }" <c:if test="${factorCaseSelected eq 'Y' }">selected="selected"</c:if>>${factorCase }: ${factorCaseStr }</option>
										<c:set var="factorCaseStr" scope="page" value=""/>
										<c:set var="factorCase" scope="page" value="${item.case_no }"/>
										<c:set var="factorCaseSelected" scope="page" value="${item.active_case_yn }"/>
										<c:set var="factorCaseStr" scope="page" value="${factorCaseStr}${item.career_month_from }~${item.career_month_to }M=${item.factor };"/>
									</c:when>
									<c:when test="${item.case_no eq factorCase }">
										<c:set var="factorCaseStr" scope="page" value="${factorCaseStr}${item.career_month_from }~${item.career_month_to }M=${item.factor };"/>
									</c:when>
								</c:choose>
							</c:forEach>
							<c:if test="${factorCase ne ''}">
								<option value="${factorCase }" <c:if test="${factorCaseSelected eq 'Y' }">selected="selected"</c:if>>${factorCase }: ${factorCaseStr }</option>
							</c:if>
						</select>
                    </td>
                    <td style="text-align: right;" >
                    	<input type="button" name="btn_search" value="조회" class="btn_blue" id="btn_search"/>
                    	<input type="button" name="reportExcelButton" value='Excel리포트' class="btn_blue" onclick="fn_excelDownload();"/>
                    	<!-- <input type="button" name="reportButton" value='리포트' class="btn_blue" onclick="viewReport();"/> -->
                    </td>
				</tr>
				<tr>
					<th>기간 당연투입시수</th>
					<td style="height: 20px;" colspan="6"><span id="totInput">0</span></td>
					<!-- <th>기술 부문 잔업평균</th>
					<td style="height: 20px;"><span id="totTechnicAvg">0</span></td>
					<th>파트 잔업평균</th>
					<td colspan="2" style="height: 20px;"><span id="totPartAvg">0</span></td> -->
				</tr>
			</table>
		</div>
		<div class="content" id="dataListDiv">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
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
		changeYear : true, //년변경가능
		changeMonth : true,
		onSelect: function( selectedDate ,i) {
			if(this.id == "p_created_date_start"){
				var to_date_ary = selectedDate.split("-");
				$( "#p_created_date_end").val(to_date_ary[0]+"-"+to_date_ary[1]+"-"+( new Date( to_date_ary[0], to_date_ary[1], 0) ).getDate());
			} else {
				var start = $("#p_created_date_start").val().replace(/[^0-9]/g,"");
				var end = selectedDate.replace(/[^0-9]/g,"");
				if(start > end)
				{
					alert("종료날자가 시작날자보다 앞으로 갈 수 없습니다");
					$("#p_created_date_end").val(i.lastVal);					
				}
			}
		}
	} );
});
$(document).ready(function(){
	//주단위 설정 
	fn_lastMonthDate("p_created_date_start","p_created_date_end");
	//조회 처리
	$("#btn_search").click(function(){
		$("#totInput").text("0");
		/* $("#totTechnicAvg").text("0");
		$("#totPartAvg").text("0"); */
		
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="dpPersonDataMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
		
		$.ajax({
	    	url:'<c:url value="getBaseWorkTime.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : fn_getFormData($('#application_form')),
	    	success : function(data_s){
	    		$("#totInput").text(data_s);
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
    	}); 
		/*  $.ajax({
		    	url:'<c:url value="getAverageOvertimeOfAll.do"/>',
		    	type:'POST',
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : fn_getFormData($('#application_form')),
		    	success : function(data_s){
		    		$("#totTechnicAvg").text(data_s);
		    	}, 
		    	error : function(e){
		    		alert(e);
		    	}
	    }); 
		 $.ajax({
		    	url:'<c:url value="getAverageOvertimeOfSelectedDepts.do"/>',
		    	type:'POST',
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : fn_getFormData($('#application_form')),
		    	success : function(data_s){
		    		$("#totPartAvg").text(data_s);
		    	}, 
		    	error : function(e){
		    		alert(e);
		    	}
	    });  */
	});
	
	//부서 추가 팝업 호출
	$("#btn_department_no").click(function(){
		
		var sProperties = 'dialogHeight:400px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	    var paramStr = "selectedDepartments=" + application_form.departmentList.value;
	    
	     /* window.open("popUpDepartmentSelectWin.do?"+paramStr,""); */ 

	    var rs = window.showModalDialog("popUpDepartmentSelectWin.do?" + paramStr, window, sProperties);
		
	    deptCodeHintStr = "";
		if(rs != null || rs != undefined){
			var strs = rs.split("|");
			application_form.departmentList.value = strs[0];
			deptCodeHintStr = strs[1].replace(/\,/gi, "<br/>");
		}
	});
});
</script>
<script type="text/javascript">
var deptCodeHintStr = "";
// 부서코드 부분 MouseOver 시 부서명을 힌트 형태로 표시
var hintcontainer = null;  
//hint div 표시 처리
function showDeptHint(obj) {   
    if (deptCodeHintStr == "") return;

    if (hintcontainer == null) {   
        hintcontainer = document.createElement("div");   
        hintcontainer.className = "hintstyle";   
        document.body.appendChild(hintcontainer);   
    }   
    obj.onmouseout = hideDeptHint;   
    obj.onmousemove = moveDeptHint;   
    hintcontainer.innerHTML = deptCodeHintStr;   
}
//부서 마우스 이동시에도 영역 안이면 디스플레이 처리
function moveDeptHint(e) {   
    if (deptCodeHintStr == "") return;
    if (!e) e = event; // line for IE compatibility   
    hintcontainer.style.top =  (e.clientY + document.documentElement.scrollTop + 2) + "px";   
    hintcontainer.style.left = (e.clientX + document.documentElement.scrollLeft + 10) + "px";   
    hintcontainer.style.display = "";   
}   
//hint div숨김처리
function hideDeptHint() {   
    hintcontainer.style.display = "none";   
}
//선택 영역 안 전체 input type text 들 값 제거 
function clearData(obj){
	var parent = $(obj).closest("td");
	if($(parent.find("input[type=text]")).attr("name") == "departmentList"){
		deptCodeHintStr = "";
	}
	parent.find("input[type=text]").val("");
}

//프린트(리포트 출력)
function viewReport()
{
    var departmentStr = application_form.departmentList.value.trim();
    if (departmentStr != "") {
        var strs = departmentStr.split(",");
        departmentStr = "";
        for (var i = 0; i < strs.length; i++) {
            if (i > 0) departmentStr += ",";
            departmentStr += "'" + strs[i].trim() + "'";
        }
    }

    var yearMonthStr = application_form.dateSelectedFrom.value;
    var tempStrs = yearMonthStr.split("-");
    yearMonthStr = tempStrs[0] + "." + tempStrs[1];
    
    var urlStr = "http://172.16.2.13:7777/j2ee/STXDPSP/WebReport.jsp?src=<%=reportFileUrl%>";
    urlStr += "stxPECDPPersonDataView_SP.mrd&param=";
    urlStr += application_form.dateSelectedFrom.value + ":::";
    urlStr += application_form.dateSelectedTo.value + ":::";
    urlStr += departmentStr + ":::";
    urlStr += application_form.factorCaseList.value + ":::";
    urlStr += yearMonthStr;
    window.open(urlStr, "", "");
}
function fn_excelDownload(){
	if(!confirm("엑셀 출력에 시간이 소요되오니, 결과가 나올때까지 기다려주십시오.  출력하시겠습니까?")) return;
	var f    = document.application_form;
	var headerNames = [];
	
	
	var headerRow0 = [];
	headerRow0.push({"name":"번호","row_to":2,"start_index":0,"end_index":0});
	headerRow0.push({"name":"부서CODE","row_to":2,"start_index":1,"end_index":1});
	headerRow0.push({"name":"부서","row_to":2,"start_index":2,"end_index":2});
	headerRow0.push({"name":"사번","row_to":2,"start_index":3,"end_index":3});
	headerRow0.push({"name":"성명","row_to":2,"start_index":4,"end_index":4});
	headerRow0.push({"name":"FACT.","row_to":2,"start_index":5,"end_index":5});
	
	headerRow0.push({"name":"공사시수","row_to":0,"start_index":6,"end_index":21});
	headerRow0.push({"name":"비공사시수","row_to":1,"start_index":22,"end_index":25});
	headerRow0.push({"name":"총투입실적","row_to":1,"start_index":26,"end_index":27});
	headerRow0.push({"name":"당연투입","row_to":1,"start_index":28,"end_index":29});
	headerRow0.push({"name":"근태","row_to":1,"start_index":30,"end_index":31});
	headerRow0.push({"name":"잔업및특근","row_to":1,"start_index":32,"end_index":35});
	var row0 = {"row":0,"rowvalue":headerRow0};
	
	var headerRow1 = [];
	headerRow1.push({"name":"도면시수","row_to":1,"start_index":6,"end_index":13});
	headerRow1.push({"name":"비도면시수","row_to":1,"start_index":14,"end_index":20});
	headerRow1.push({"name":"합계","row_to":2,"start_index":21,"end_index":21});
	var row1 = {"row":1,"rowvalue":headerRow1};
	
	var headerRow2 = [];
	headerRow2.push({"name":"설계제도","row_to":2,"start_index":6,"end_index":6});
	headerRow2.push({"name":"도면개정","row_to":2,"start_index":7,"end_index":7});
	headerRow2.push({"name":"도면검토","row_to":2,"start_index":8,"end_index":8});
	headerRow2.push({"name":"협의/검토","row_to":2,"start_index":9,"end_index":9});
	headerRow2.push({"name":"호선관리","row_to":2,"start_index":10,"end_index":10});
	headerRow2.push({"name":"직영계","row_to":2,"start_index":11,"end_index":11});
	headerRow2.push({"name":"외주도면시수","row_to":2,"start_index":12,"end_index":12});
	headerRow2.push({"name":"소계","row_to":2,"start_index":13,"end_index":13});
	
	headerRow2.push({"name":"설계준비","row_to":2,"start_index":14,"end_index":14});
	headerRow2.push({"name":"도면검토","row_to":2,"start_index":15,"end_index":15});
	headerRow2.push({"name":"PR/BOM","row_to":2,"start_index":16,"end_index":16});
	headerRow2.push({"name":"협의/검토","row_to":2,"start_index":17,"end_index":17});
	headerRow2.push({"name":"호선관리","row_to":2,"start_index":18,"end_index":18});
	headerRow2.push({"name":"기타","row_to":2,"start_index":19,"end_index":19});
	headerRow2.push({"name":"소계","row_to":2,"start_index":20,"end_index":20});

	headerRow2.push({"name":"보조지원","row_to":2,"start_index":22,"end_index":22});
	headerRow2.push({"name":"생산향상","row_to":2,"start_index":23,"end_index":23});
	headerRow2.push({"name":"기타","row_to":2,"start_index":24,"end_index":24});
	headerRow2.push({"name":"소계","row_to":2,"start_index":25,"end_index":25});

	headerRow2.push({"name":"시수","row_to":2,"start_index":26,"end_index":26});
	headerRow2.push({"name":"차지율","row_to":2,"start_index":27,"end_index":27});

	headerRow2.push({"name":"시수","row_to":2,"start_index":28,"end_index":28});
	headerRow2.push({"name":"사용율","row_to":2,"start_index":29,"end_index":29});

	headerRow2.push({"name":"시수","row_to":2,"start_index":30,"end_index":30});
	headerRow2.push({"name":"율","row_to":2,"start_index":31,"end_index":31});

	headerRow2.push({"name":"연장","row_to":2,"start_index":32,"end_index":32});
	headerRow2.push({"name":"특근","row_to":2,"start_index":33,"end_index":33});
	headerRow2.push({"name":"총계","row_to":2,"start_index":34,"end_index":34});
	headerRow2.push({"name":"잔업율","row_to":2,"start_index":35,"end_index":35});
	
	var row2 = {"row":2,"rowvalue":headerRow2};
	
	
	headerNames.push(row0);
	headerNames.push(row1);
	headerNames.push(row2);
	
	application_form.excelHeaderName.value = "";
	application_form.excelHeaderName.value = JSON.stringify(headerNames);
	
	
	var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
	var str = '';
	for(var i =0; i < cm.length; i++){
		if(i < cm.length)str = str+cm[i].name +",";
	}
	
	application_form.excelHeaderKey.value = "";
	application_form.excelHeaderKey.value = str;
	
	f.action = "dpPersonDataExcelExport.do";
	f.method = "post";
	f.submit();
	
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
			colNames : ['부서CODE','부서','사번','성명','Fact.','POSITION',
			            '설계제도','도면개정','도면검토','협의/검토','호선관리','직영계','외주도면시수','소계',
			            '설계준비','도면검토','PR/BOM','협의/검토','호선관리','기타','소계','합계',
			            '보조지원','생산향상','기타','소계',
			            '시수','차지율',
			            '시수','사용율',
			            '시수','율',
			            '연장','특근','총계','잔업율',
			            '시수<br>입력','마감<br>여부'],
			colModel : [{name : 'dept_code', index : 'dept_code', width: 30, align : "center"},
			            {name : 'dept_name', index : 'dept_name', width: 40, align : "center"},
			            {name : 'employee_no', index : 'employee_no', width: 25, align : "center"},
			            {name : 'emp_name', index : 'emp_name', width: 40, align : "center"},
			            {name : 'mh_factor', index : 'mh_factor', width: 20, align : "center"},
			            {name : 'position', index : 'position', width: 40, align : "center", hidden:true},
			            /**공사시수**/
			            /**도면시수**/
			            {name : 'mh_a1', index : 'mh_a1', width: 22, align : "center"},
			            {name : 'mh_a2', index : 'mh_a2', width: 22, align : "center"},
			            {name : 'mh_a3', index : 'mh_a3', width: 22, align : "center"},
			            {name : 'mh_a4', index : 'mh_a4', width: 22, align : "center"},
			            {name : 'mh_a5', index : 'mh_a5', width: 22, align : "center"},
			            {name : 'mh_in', index : 'mh_in', width: 22, align : "center"},
			            {name : 'mh_out', index : 'mh_out', width: 22, align : "center"},
			            {name : 'mh_dwg_sum', index : 'mh_dwg_sum', width: 22, align : "center"},
			            /**도면시수END**/
			            /**비도면시수**/
			            {name : 'mh_b1', index : 'mh_b1', width: 22, align : "center"},
			            {name : 'mh_b2', index : 'mh_b2', width: 22, align : "center"},
			            {name : 'mh_b3', index : 'mh_b3', width: 22, align : "center"},
			            {name : 'mh_b4', index : 'mh_b4', width: 22, align : "center"},
			            {name : 'mh_b5', index : 'mh_b5', width: 22, align : "center"},
			            {name : 'mh_b6', index : 'mh_dedwg_sum', width: 22, align : "center"},
			            {name : 'mh_dedwg_sum', index : 'mh_dedwg_sum', width: 22, align : "center"},
			            /**비도면시수END**/
			            /**합계**/
			            {name : 'mh_con_tot', index : 'mh_con_tot', width: 22, align : "center"},
			            /**공사시수END**/
			            /**비공사시수**/
			            {name : 'mh_c1', index : 'mh_c1', width: 22, align : "center"},
			            {name : 'mh_c2', index : 'mh_c2', width: 22, align : "center"},
			            {name : 'mh_c3', index : 'mh_c3', width: 22, align : "center"},
			            {name : 'mh_decon_sum', index : 'mh_decon_sum', width: 22, align : "center"},
			            /**비공사시수END**/
			            /**총투입실적**/
		             	{name : 'mh_take', index : 'mh_take', width: 22, align : "center"},
		             	{name : 'mh_take_rate', index : 'mh_take_rate', width: 22, align : "center"},
			            /**총투입실적END**/
			            /**당연투입**/
			            {name : 'normal_time', index : 'normal_time', width: 22, align : "center"},
			            {name : 'normal_time_rate', index : 'normal_time_rate', width: 22, align : "center"},
			            /**당연투입END**/
			            /**근태**/
			            {name : 'mh_d1', index : 'mh_d1', width: 22, align : "center"},
			            {name : 'mh_d1_rate', index : 'mh_d1_rate', width: 22, align : "center"},
			            /**근태END**/
			            /**잔업및특근**/
			            {name : 'overtime', index : 'overtime', width: 22, align : "center"},
			            {name : 'special_time', index : 'special_time', width: 22, align : "center"},
			            {name : 'over_total', index : 'over_total', width: 22, align : "center"},
			            {name : 'over_total_rate', index : 'over_total_rate', width: 20, align : "center"},
			            /**잔업및특근END**/
			            {name : 'inputdone', index : 'inputdone', width: 22, align : "center"},
			            {name : 'confirm', index : 'confirm', width: 22, align : "center"}
			           ],
	        gridview : true,
	   		cmTemplate: { title: false },
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
			beforeProcessing : function(data, status, xhr){
		    },
			loadComplete: function (data) {
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				var baseworktime_f = parseFloat($("#totInput").text());
				for(var i=0; i<rows.length; i++){
					
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					
					var trProjectBgColor = "#ffffff";            
		            var tdBgColor = "#ffffff";
		            
					$('#dataList').jqGrid('setCell',rows[i], 'emp_name', rowData.position+" "+rowData.emp_name); 
					if(i == 0){
						$('#dataList').jqGrid('setRowData',rows[i],'',{background:"#dddddd"});
					} else {
						trProjectBgColor = "#ffffd0";
						var normal_time_f = isNaN(parseFloat(rowData.normal_time)) ? 0 : parseFloat(rowData.normal_time);
						var mh_factor_f = isNaN(parseFloat(rowData.mh_factor)) ? 0 : parseFloat(rowData.mh_factor);
						tdBgColor = normal_time_f < (baseworktime_f * mh_factor_f) ? "#ff0000" : "#ffffff";
						
						$('#dataList').jqGrid('setCell',rows[i], 'dept_code', '', {background : trProjectBgColor});
						$('#dataList').jqGrid('setCell',rows[i], 'dept_name', '', {background : trProjectBgColor}); 
						$('#dataList').jqGrid('setCell',rows[i], 'employee_no', '', {background : trProjectBgColor});
						$('#dataList').jqGrid('setCell',rows[i], 'emp_name', '', {background : trProjectBgColor});
						$('#dataList').jqGrid('setCell',rows[i], 'mh_factor', '', {background : trProjectBgColor});
						
						$('#dataList').jqGrid('setCell',rows[i], 'normal_time', '', {background : tdBgColor});	
					}
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				var cm = $("#dataList").jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'inputdone' || cm[iCol].name == 'confirm'){
					var item = $("#dataList").getRowData(rowid);
					var sProperties = 'dialogHeight:540px;dialogWidth:500px;scroll=no;center:yes;resizable=no;status=no;';
					var paramObj = new function() {
						this.window = window;
			            this.designerId = item.employee_no;
			            this.designerName = item.emp_name;
			            this.startDate = $("#p_created_date_start").val();
			            this.endDate = $("#p_created_date_end").val();
			        }
					var rs = window.showModalDialog("popUpDesignApprovalViewWin.do",paramObj, sProperties);

					if(rs != null && rs != undefined){
					}
				}
				
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
		
		$( "#dataList" ).jqGrid( 'setGroupHeaders', {
			useColSpanStyle : true,
			groupHeaders : [ { startColumnName : 'mh_a1', numberOfColumns : 16, titleText : fn_groupHeaderMultiTemplet('공사시수',['16','도면시수','8','비도면시수','7','','1'],$("#dataList_mh_a1").width())},
			                 { startColumnName : 'mh_c1', numberOfColumns : 4, titleText : '비공사시수' },
			                 { startColumnName : 'mh_take', numberOfColumns : 2, titleText : '총투입실적' },
			                 { startColumnName : 'normal_time', numberOfColumns : 2, titleText : '당연투입' },
			                 { startColumnName : 'mh_d1', numberOfColumns : 2, titleText : '근태' },
			                 { startColumnName : 'overtime', numberOfColumns : 4, titleText : '잔업및특근' }
			                 ]
		} );
		
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.68);
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		/* fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() ); */
		
	});	
	//멀티헤더 그룹핑 템플릿
	//topString = 맨위 헤더
	//header Ary = {2번째 헤더명,colspan,이하 반복}
	function fn_groupHeaderMultiTemplet(topString,headerAry,columnWidth){
		var returnValue = "<table style='width:100%;border-spacing:0px;'>";
		returnValue +="<tr><td style='border-bottom : 1px solid #807fd7;' colspan='"+headerAry[0]+"'>"+topString+"</td></tr><tr>";
	    for(var i = 1; i < headerAry.length; i= i+2)
	   	{
	    		var color = "border-right : 1px solid #807fd7;";
	    		if(headerAry.length == (i+2)) color = ''; 
	    		returnValue+="<td align='center' style='"+color+"' colspan='"+headerAry[i+1]+"' width='"+(headerAry[i+1]*columnWidth)+"'>"+headerAry[i]+"</td>";	
	   	}
	    returnValue += "</tr></table>"; 
	    return returnValue;
	}
	
</script>
</body>
</html>
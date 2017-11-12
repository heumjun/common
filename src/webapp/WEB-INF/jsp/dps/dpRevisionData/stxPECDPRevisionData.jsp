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
<title>부서별 개정 시수조회</title>
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
</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		부서별 개정 시수조회
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="isManager" value="${loginUserInfo.is_manager}" />
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="7%"/>
				<col width="15%"/>
				<col width="5%"/>
				<col width="15%"/>
				<col width="5%"/>
				<col width="15%"/>
				<col width="*"/>
				<tr>
					<th>호선</th>
					<td>
						<input type="text" name="projectList" value="" onkeyup="checkInputAZ09(this);" id="p_project_no" style="width: 70%; ime-mode:disabled" />
						<input type="button" name="ProjectsButton" value="검색" class="btn_gray2" id="btn_project_no"/>
						<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>부서</th>
					<td>
						<c:choose>
							<c:when test="${loginUserInfo.is_admin eq 'Y'}">
								<input type="text" name="departmentList" value="" style="width: 70%;" onmouseover="showDeptHint(this);"  readonly="readonly"/>
								<input type="button" name="departmentButton" value="검색" class="btn_gray2" id="btn_department_no"/>
								<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
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
				</tr>
				<tr>
					<th>원인부서</th>
					<td>
						<select name="causeDeptList" style="width:90%">
                    		<option value="" selected="selected">&nbsp;</option>
                    		<c:forEach var="item" items="${departmentList }">
									<option value="${item.dept_code }">${item.dept_code } : ${item.dept_name }</option>
							</c:forEach>
                    	</select>
					</td>
					<th>적용 CASE</th>
					<td>
						<select name="factorCaseList" style="width: 80%;" <c:if test="${loginUserInfo.is_admin ne 'Y' and loginUserInfo.is_manager ne 'Y' }"> disabled="disabled"</c:if>>
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
					<td style="text-align: right;" colspan="2">
                    	<input type="button" name="btn_search" value="조회" class="btn_blue" id="btn_search"/>
                    	<input type="button" name="reportButton" value='리포트' class="btn_blue" onclick="viewReport();"/>
                    </td>
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
		changeMonth : true, //월변경가능
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
		gridDataTotal = null;
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="dpRevisionDataMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
		
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
	
	//호선 검색 팝업 호출
	$("#btn_project_no").click(function() {
        var paramStr = "selectedProjects=" + application_form.projectList.value;
        
		var rs = window.showModalDialog("popUpProjectNModelSelectWin.do?"+paramStr, 
				window, "dialogHeight:500px;dialogWidth:500px; center:on; scroll:off; status:off");

		if(rs != null || rs != undefined){
			$("#p_project_no").val(rs);
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
		application_form.departmentList.value = "";
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
    var projectStr = application_form.projectList.value.trim();
    if (projectStr != "") {
        var strs = projectStr.split(",");
        projectStr = "";
        for (var i = 0; i < strs.length; i++) {
            if (i > 0) projectStr += ",";
            projectStr += "'" + strs[i].trim() + "'";
        }
    }

    var yearMonthStr = application_form.dateSelected_from.value;
    var tempStrs = yearMonthStr.split("-");
    yearMonthStr = tempStrs[0] + "." + tempStrs[1];

    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/";
    urlStr += "stxPECDPDepartmentRevDataView.mrd&param=";
    urlStr += application_form.dateSelected_from.value + ":::";
    urlStr += application_form.dateSelected_to.value + ":::";
    urlStr += departmentStr + ":::";
    urlStr += projectStr + ":::";
    urlStr += application_form.causeDeptList.value + ":::";
    urlStr += application_form.factorCaseList.value + ":::";
    urlStr += yearMonthStr + ":::";
    urlStr += (projectStr == "" ? "ALL" : "SELECTED") + ":::";
    urlStr += (departmentStr == "" ? "ALL" : "SELECTED");
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
			colNames : ['부서CODE','부서명',
			            <c:forEach items="${opCodeList }" var="item" varStatus="status">
			            	'${item.key }${item.value }'
							<c:if test="${!status.last }">,</c:if>
						</c:forEach>
			            ,'Total','순수설계','20Extra'],
			colModel : [
			            	{name : 'dept_code', index : 'dept_code', width: 20, align : "center"},
							{name : 'dept_name', index : 'dept_name', width: 50, align : "center"},
							<c:forEach items="${opCodeList }" var="item" varStatus="status">
							{name : '${item.key }', index:'${item.key }', width:50, align:"center"}
								<c:if test="${!status.last }">,</c:if>
							</c:forEach>
							,{name : 'op_wtime_row_total', index : 'op_wtime_row_total', width: 20, align : "center"},
							{name : 'op_wtime_row_total2', index : 'op_wtime_row_total2', width: 20, align : "center"},
							{name : 'op_wtime_val', index : 'op_wtime_val', width: 25, align : "center"}
			           ],
	        gridview : true,
	   		cmTemplate: { title: true },
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
				var ids = $("#dataList").getDataIDs();
				$.each(ids, function(idx,rowId){
					var rowData = $("#dataList").getRowData(rowId);
					$('#dataList').jqGrid('setCell',rowId, '5K', '', {background : '#AAEBAA' });
					$('#dataList').jqGrid('setCell',rowId, '5L', '', {background : '#AAEBAA' });
					$('#dataList').jqGrid('setCell',rowId, '5M', '', {background : '#AAEBAA' });
					$('#dataList').jqGrid('setCell',rowId, '5R', '', {background : '#AAEBAA' });
				});
			},
			gridComplete : function() {
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
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.55);
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		/* fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() ); */
		
	});	
	function checkInputAZ09(obj){
		var num_check=/^[A-Za-z0-9,]*$/;
		$(obj).val($(obj).val().toUpperCase());
		if(!num_check.test($(obj).val())){
			alert("Invalid Text. Ex.F9999;F9998 !");
			$(obj).val($(obj).val().substr(0,$(obj).val().length-1));
			return;
		}
	}
</script>
</body>
</html>
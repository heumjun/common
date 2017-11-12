<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy" var="currentYear"/>
<fmt:formatDate value="${now}" pattern="MM" var="currentMonth"/>

<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ERP INTERFACE</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
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
	<div id="mainDiv" class="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" name="loginID" value="${loginUser.user_id}" />
			<input type="hidden" name="currentYear" value="${currentYear}" />
    		<input type="hidden" name="currentMonth" value="${currentMonth}" />
    		<input type="hidden" name="dateFrom" value="" />
		    <input type="hidden" name="dateTo" value="" />
		    
			<div id="searchDiv">
				<table class="searchArea conSearch">
					<col width="7%"/>
					<col width="10%"/>
					<col width="5%"/>
					<col width="25%"/>
					<col width="5%"/>
					<col width="18%"/>
					<col width="*"/>
					<tr>
						<th>전송년월</th>
						<td>
							<select name="yearSelect" style="width:50%;" onchange="yearSelectChanged();">
								<option value="">&nbsp;</option>
								<c:forEach var="item"  begin="0" end="${currentYear-1996}">
									<option value="${currentYear-item }">${currentYear-item} 년</option>
								</c:forEach>
                			</select>
                			<select name="monthSelect" style="width:40%;">
                    			<option value="">&nbsp;</option>
                			</select>
						</td>
						<th>호선</th>
						<td>
							<input type="text" name="projectList" value="" onkeyup="checkInputAZ09(this);" id="p_project_no" style="width: 70%; ime-mode:disabled" />
							<input type="button" name="ProjectsButton" value="검색" class="btn_gray2" id="btn_project_no"/>
							<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
						</td>
						<th>적용 CASE</th>
						<td>
							<select name="factorCaseList" style="width: 80%;">
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
					</tr>
					<tr>
						<th>전송대상</th>
	                    <td>
	                    	<select name="targetSelect" style="width:115px;">
			                    <option value="기술기획팀">기술기획팀</option>
			                    <option value="해양설계관리팀">해양설계관리팀</option>
			                </select>
	                    </td>
	                    <th>부서</th>
						<td>
							<input type="text" name="departmentList" value="" style="width: 70%;" readonly="readonly"/>
							<input type="button" name="departmentButton" value="검색" class="btn_gray2" id="btn_department_no"/>
							<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
						</td>
						<td colspan="2" style="text-align: right;">
							<input type="button" name="btn_search" value="조회" class="btn_blue" id="btn_search"/>
				            <input type="button" name="reportButton" value='리포트' class="btn_blue" onclick="viewReport();"/>
				            <input type="button" name="btn_erp_send" value='ERP 전송실행' class="btn_blue" id="btn_erp_send"/>
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
//년도 선택 변경 시 월 선택 값 초기화
function yearSelectChanged()
{
    for (var i = application_form.monthSelect.options.length - 1; i > 0; i--) {
        application_form.monthSelect.options[i] = null;
    }

    var yearSelected = application_form.yearSelect.value;
    if (yearSelected == "") return;

    if (yearSelected == application_form.currentYear.value) {
        for (var i = application_form.currentMonth.value - 1; i >= 1; i--) {
            application_form.monthSelect.options[application_form.monthSelect.options.length] = new Option(i + " 월", i);
        }
    }
    else {
        for (var i = 12; i >= 1; i--) {
            application_form.monthSelect.options[application_form.monthSelect.options.length] = new Option(i + " 월", i);
        }
    }
}
//선택 영역 안 전체 input type text 들 값 제거 
function clearData(obj){
	var parent = $(obj).closest("td");
	if($(parent.find("input[type=text]")).attr("name") == "departmentList"){
		deptCodeHintStr = "";
		application_form.departmentList.value = "";
		fn_departmentSelChanged();
	}
	parent.find("input[type=text]").val("");
}

function checkInputAZ09(obj){
	var num_check=/^[A-Za-z0-9,]*$/;
	$(obj).val($(obj).val().toUpperCase());
	if(!num_check.test($(obj).val())){
		alert("Invalid Text. Ex.F9999;F9998 !");
		$(obj).val($(obj).val().substr(0,$(obj).val().length-1));
		return;
	}
}
//프린트(리포트 출력)
function viewReport()
{
    var yearStr = application_form.yearSelect.value;
    var monthStr = application_form.monthSelect.value;
    if (yearStr == "" || monthStr == "") {
        alert("전송년월을 선택하십시오!");
        return;
    }

    var fromYear = eval(yearStr);
    var fromMonth = eval(monthStr);
    
    var toYear = fromMonth == 12 ? fromYear + 1 : fromYear;
    var toMonth = fromMonth == 12 ? 1 : fromMonth + 1;

    var fromYearStr = fromYear;
    var fromMonthStr = fromMonth <= 9 ? "0" + fromMonth : fromMonth;
    var toYearStr = toYear;
    var toMonthStr = toMonth <= 9 ? "0" + toMonth : toMonth;
    
    var projectStr = application_form.projectList.value.trim();
    if (projectStr != "") {
        var strs = projectStr.split(",");
        projectStr = "";
        for (var i = 0; i < strs.length; i++) {
            if (i > 0) projectStr += ",";
            projectStr += "'" + strs[i].trim() + "'";
        }
    }        

    var targetStr = application_form.targetSelect.value.trim();

    var departmentStr = application_form.departmentList.value.trim();
    if (departmentStr != "") {
        var strs = departmentStr.split(",");
        departmentStr = "";
        for (var i = 0; i < strs.length; i++) {
            if (i > 0) departmentStr += ",";
            departmentStr += "'" + strs[i].trim() + "'";
        }
    }

    var urlStr = "";
    /*
    urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/";
    urlStr += "stxPECDPProjectDataERPIFView.mrd&param=";
    */
    urlStr += fromYearStr + "" + fromMonthStr + "01" + ":::";
    urlStr += toYearStr + "" + toMonthStr + "01" + ":::";
    urlStr += fromYearStr + "" + fromMonthStr + ":::";
    urlStr += application_form.factorCaseList.value + ":::";
    urlStr += fromYearStr + "." + fromMonthStr + ":::";      
    urlStr += (projectStr == "" ? "ALL" : "SELECTED") + ":::";      
    urlStr += projectStr + ":::";
    urlStr += targetStr + ":::";
    urlStr += departmentStr;
    /*
    window.open(urlStr, "", "");
    */

    var thisForm = document.forms[0];
    thisForm.insertBefore(createHidden("src", "http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPProjectDataNewERPIFView.mrd"));
    thisForm.insertBefore(createHidden("param", urlStr));
    var reportWin = window.open("", "reportWindow", "");
    thisForm.action = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp";
    thisForm.method = "post";
    thisForm.target = "reportWindow";
    thisForm.submit();
}
//Utility Function: Hidden Element 생성
function createHidden(nameStr, valueStr) 
{
    var obj = document.createElement("input");
    obj.type = "hidden";
    obj.name = nameStr;
    obj.value = valueStr;
    return obj;
}
//그리드 변경된 내용 가져오는 함수
function getGridChangedData(jqGridObj, callback) {
	var changedData = $.grep(jqGridObj.jqGrid('getRowData'), function(obj) { 
		return obj.erpifyn == 'N'; 
	});

	callback.apply(this, [changedData]);
}

function fn_checkGridModifyNoAlt( gridID ) {
	var nChangedCnt = 0;
	var ids     	= $( gridID ).jqGrid('getDataIDs');
		
	for( var i = 0; i < ids.length; i++ ) {
		var erpifyn = $( gridID ).jqGrid('getCell', ids[i], 'erpifyn');
		if ( erpifyn == 'N') {
			nChangedCnt++;
		}
	}

	if ( nChangedCnt == 0 ) {
		return 0;
	}
	
	return nChangedCnt;	
}
</script>
<script type="text/javascript">
var loadingBox;
$(document).ready(function(){
	//조회 처리
	$("#btn_search").click(function(){
		var yearStr = application_form.yearSelect.value;
	    var monthStr = application_form.monthSelect.value;
	    if (yearStr == "" || monthStr == "") {
	        alert("전송년월을 선택하십시오!");
	        return;
	    }

	    var fromYear = eval(yearStr);
	    var fromMonth = eval(monthStr);
	    
	    var toYear = fromMonth == 12 ? fromYear + 1 : fromYear;
	    var toMonth = fromMonth == 12 ? 1 : fromMonth + 1;

	    var fromYearStr = fromYear;
	    var fromMonthStr = fromMonth <= 9 ? "0" + fromMonth : fromMonth;
	    var toYearStr = toYear;
	    var toMonthStr = toMonth <= 9 ? "0" + toMonth : toMonth;
	    
	    application_form.dateFrom.value = fromYearStr + "" + fromMonthStr + "01";
	    application_form.dateTo.value = toYearStr + "" + toMonthStr + "01";
        
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="popUpProjectDataERPIFFSMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
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
			fn_departmentSelChanged();
		}
	});
	
	//ERP전송
	$("#btn_erp_send").click(function(){
		var no_send_erp_cnt = fn_checkGridModifyNoAlt("#dataList");
		var loadingBox  = new ajaxLoader( $( '#mainDiv' ));
		if(no_send_erp_cnt > 0){
			
			var msg = "ERP 미전송(ERP에 데이터 미존재) 호선 " + no_send_erp_cnt + " 건의 시수정보를\n\nERP로 전송합니다! ";
	        msg    += "계속 진행하시겠습니까?";


	        if (confirm(msg)){
	        	getGridChangedData($( "#dataList" ),function(data) {
					changeRows = data;

					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var formData = fn_getFormData('#application_form');
					var parameters = $.extend({}, dataList, formData);
				
					loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					$.post('<c:url value="popUpProjectDataERPIFFSMainGridSave.do"/>',parameters ,function(data){
						if ( data.result == 'success' ) {
		    				$('#btn_search').click();
		    			} else if(data.result == 'fail'){
		    				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		    			}
					},"json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				});
	        } else {
	        	loadingBox.remove();
	        	return;
	        }
		} else {
			loadingBox.remove();
			alert("변경할 내용이 없습니다.");
		}
	});
});
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
		colNames : ['PROJECT','시수소계(Factor 미적용)','전송시수(Factor 적용)','전송시수 (ERP I/F결과)','전송일자','전송여부(ERP 데이터 존재여부)'],
		colModel : [
		            	{name : 'project_no', index : 'project_no', width: 70, align : "center"},
						{name : 'wtime', index : 'wtime', width: 20, align : "center"},
						{name : 'wtime_f', index : 'wtime_f', width: 20, align : "center"},
						{name : 'erp_wtime_f', index : 'erp_wtime_f', width: 20, align : "center"},
						{name : 'erp_create_date', index : 'erpcreatedate', width: 20, align : "center"},
						{name : 'erpifyn', index : 'erpifyn', width: 20, align : "center"}
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
			var ids = $("#dataList").getDataIDs();
			
			$.each(ids, function(idx,rowId){
				var rowData = $("#dataList").getRowData(rowId);
				$('#dataList').jqGrid('setCell',rowId, 'project_no', '', {background : '#ffffd0' });
				if(rowData.erpifyn == 'Y'){
					$('#dataList').jqGrid('setCell',rowId, 'erpifyn', '', {background : '#66ff66' });
				} else {
					$('#dataList').jqGrid('setCell',rowId, 'erpifyn', '', {background : '#ff0000' });
				}
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
	
	resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.75);
	
});	
</script>
</body>
</html>
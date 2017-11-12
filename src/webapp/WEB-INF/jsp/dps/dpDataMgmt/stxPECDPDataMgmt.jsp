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
<title>설계시수 Data 관리</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
    .hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
    }   
</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		설계시수 Data 관리
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="isManager" value="${loginUserInfo.is_manager}" />
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="7%"/>
				<col width="25%"/>
				<col width="7%"/>
				<col width="25%"/>
				<col width="7%"/>
				<col width="25%"/>
				<col width="*"/>
				<tr>
					<th>호선</th>
					<td>
						<input type="text" name="projectList" value="" onkeyup="checkInputAZ09(this);" onchange="onlyUpperCase(this);" id="p_project_no" style="width: 70%; ime-mode:disabled" />
						<input type="button" name="ProjectsButton" value="검색" class="btn_gray2" id="btn_project_no"/>
						<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>부서</th>
					<td>
						<input type="text" name="departmentList" value="" style="width: 70%;" onmouseover="showDeptHint(this);"  readonly="readonly"/>
						<input type="button" name="departmentButton" value="검색" class="btn_gray2" id="btn_department_no"/>
						<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>사번</th>
					<td>
						<select name="designerList" id="designerList" style="width: 50%;">
							<option value="">&nbsp;</option>
						</select>
						 <input type="text" name="designerInput" value="" style="width:30%;background-color:#e8e8e8;" onKeyUp="javascript:this.value=this.value.toUpperCase();">
					</td>
				</tr>
				<tr>
					<th>일자</th>
					<td>
						<input type="text" id="p_created_date_start" value="" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 65px;"  />
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 65px;" />
					</td>
					<th>도면번호</th>
					<td>
						<input type="text" name="drawingNo[0]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[1]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[2]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[3]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[4]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[5]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[6]" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo[7]" value="" maxlength="1" style="width:18px;"   />
		                <input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>적용 CASE</th>
					<td>
						<select name="factorCaseList" style="width: 90%;">
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
					<th>OP CODE</th>
					<td><input type="text" name="opCode" value="" style="width:90%;" /></td>
					<th>원인부서</th>
					<td>
						<select name="causeDeptList" style="width:90%">
                    		<option value="" selected="selected">&nbsp;</option>
                    		<c:forEach var="item" items="${departmentList }">
									<option value="${item.dept_code }">${item.dept_code } : ${item.dept_name }</option>
							</c:forEach>
                    	</select>
					</td>
					<td colspan="2" style="text-align: right;">
						 <input type="button" value='Search' class="btn_blue" id="btn_search"/>
						 <input type="button" value='Excel' class="btn_blue" id="btn_excel"/>
						 <!-- <input type="button" value='Save' class="btn_blue" id="btn_save"/> -->
					</td>
				</tr>
			</table>
		</div>
		<div class="content">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
	
	<div id="causeDepartDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
	    <tr><td>
	        <select name="causeDepartSelect" style="width:150px;background-color:#fff0f5" onchange="fn_causeDepartSelChanged();">
	           <c:forEach var="item" items="${departmentList }">
									<option value="${item.dept_code }">${item.dept_code }:${item.dept_name }</option>
			   </c:forEach>
	        </select>
	    </td></tr>
	    </table>
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
	//오늘날짜 범위설정 
	fn_addDate("p_created_date_start","p_created_date_end", "0" );
	//fn_weekDate("p_created_date_start","p_created_date_end" );
	//저장 처리
	/* $("#btn_save").click(function(){
		fn_toggleDivPopUp();
		var savedGrid = $( "#dataList").jqGrid( 'getRowData' );
		if(savedGrid.length == 0) return;
		
		//수정 유무 체크
		if ( !fn_checkGridModify( "#dataList" ) ) {
			return;
		}
		var resultData = [];
		var savedRows = savedGrid.concat(resultData);
		var url = '<c:url value="dataMgmtMainGridSave.do"/>';
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
	}); */
	
	//조회 처리
	$("#btn_search").click(function(){
		var sUrl = 'dataMgmtMainGrid.do';
		
		$( '#dataList' ).jqGrid( 'clearGridData' );
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : sUrl,
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( '#application_form' )
		} ).trigger( 'reloadGrid' );	

	});
	//엑셀 다운로드 호출
	$("#btn_excel").click(function(){
		var sUrl = "dataMgmtExcelExport.do";
		var f = document.application_form;

		f.action = sUrl;
		f.method = "post";
		f.submit();
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
	$(".div_popup").focusout(function(){
		fn_toggleDivPopUp();
	});
});
</script>
<script type="text/javascript">
//div팝업 선택 화면 Hidden
function fn_toggleDivPopUp(activeDivObj,targetObj)
{
		$(".div_popup").css("display","none");
		if(activeDivObj != null && activeDivObj != undefined){
			activeDivObj.css("left",targetObj.offset().left);
			activeDivObj.css("top",targetObj.offset().top);
			activeDivObj.css("display","");
		}
}
//원인부서 선택 화면 Show
function fn_causeDepart(targetObj,currentData)
{
	fn_toggleDivPopUp($("#causeDepartDiv"),targetObj.next());
	var causeDepartSelect = $("#causeDepartDiv [name=causeDepartSelect]");
	causeDepartSelect.val(currentData).focus();
}

// 지연사유 선택(입력) 처리
function fn_causeDepartSelChanged()
{
	var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
	var rowData = $("#dataList").jqGrid('getRowData',selectRow);
	var causeDepartSelectValue = $("#causeDepartDiv [name=causeDepartSelect]").val();    	
	var causeDepartSelectText = $("#causeDepartDiv [name=causeDepartSelect] option:selected").text();
	$('#dataList').jqGrid('setCell',selectRow, 'dept_code', causeDepartSelectValue,{background:'#ffcccc'});
	$('#dataList').jqGrid('setCell',selectRow, 'dept_name', causeDepartSelectText.split(":")[1],{background:'#ffcccc'});
	$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
    fn_toggleDivPopUp();
}

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
		fn_departmentSelChanged();
	}
	parent.find("input[type=text]").val("");
}
//숫자 영어 및 구분자(,)를 제외한 기타의 입력 방지
function checkInputAZ09(obj){
	var num_check=/^[A-Za-z0-9,]*$/;
	$(obj).val($(obj).val().toUpperCase());
	if(!num_check.test($(obj).val())){
		alert("Invalid Text. Ex.F9999;F9998 !");
		$(obj).val($(obj).val().substr(0,$(obj).val().length-1));
		return;
	}
}
//부서 변경시 사번 항목 추가 및 조정 처리
function fn_departmentSelChanged(){
	var sabunTagObj = $("#designerList");
    if (application_form.departmentList.value == ""){
    	sabunTagObj.empty();
    	return;
    }
    
    $.ajax({
    	url:'<c:url value="getPartPersons2.do"/>',
    	type:'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"dept_code_list" : application_form.departmentList.value},
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
		colNames : ['PROJECT','작업일자','사번','성명','부서CODE','부서','도면번호','OP코드',
		            '직접','배부','공사구분','정상','잔업','특근'],
		colModel : [{name : 'project_no', index : 'project_no', width: 10, align : "center"},
		            {name : 'workday', index : 'workday', width: 10, align : "center"},
		            {name : 'employee_no', index : 'employee_no', width: 10, align : "center"},
		            {name : 'emp_name', index : 'emp_name', width: 10, align : "center"},
		            {name : 'dept_code', index : 'dept_code', width: 10, align : "center"},
		            {name : 'dept_name', index : 'dept_name', width: 20, align : "center"},
		            {name : 'dwg_code', index : 'dwg_code', width: 10, align : "center"},
		            {name : 'op_code', index : 'op_code', width: 10, align : "center"},
		            {name : 'direct_mh', index : 'direct_mh', width: 5, align : "center"},
		            {name : 'dist_mh', index : 'dist_mh', width: 5, align : "center"},
		            {name : 'project_gbn', index : 'project_gbn', width: 10, align : "center"},
		            {name : 'normal_time_factor', index : 'normal_time_factor', width: 5, align : "center"},
		            {name : 'over_time_factor', index : 'over_time_factor', width: 5, align : "center"},
		            {name : 'special_time_factor', index : 'special_time_factor', width: 5, align : "center"}
		           ],
        gridview : true,
   		cmTemplate: { title: false },
   		toolbar : [ false, "bottom" ],
   		hidegrid: false,
   		altRows:false,
   		viewrecords : true,
   		autowidth : true, //autowidth: true,
   		height : objectHeight,
   		rowNum : 1000,
		rowList : [ 1000, 3000 ],
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
			records : "records",
			repeatitems : false,
		},
		onPaging: function(action) {
			$(this).jqGrid("clearGridData");
			$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } }).triggerHandler( 'reloadGrid' ); 
		},
		ondblClickRow : function(rowId,iRow,colId) {
		},
		onCellSelect : function( rowId, colId, content, event) {
			/* var rowData = jQuery(this).getRowData(rowId);
			var isAdmin = application_form.isAdmin.value;
			var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
			if(isAdmin == "Y"){
				fn_toggleDivPopUp();
				if(cm[colId].name == "dept_code")fn_causeDepart( $(this).find("tr#"+rowId).find("td:eq("+colId+")"), rowData.dept_code);
			} */
		},
		loadComplete: function (data) {
			var $this = $(this);
			if( $this.jqGrid( 'getGridParam', 'datatype') === 'json') {
				// because one use repeatitems: false option and uses no
				// jsonmap in the colModel the setting of data parameter
				// is very easy. We can set data parameter to data.rows:
				$this.jqGrid( 'setGridParam', {
					datatype : 'local',
					data : data.rows,
					pageServer : data.page,
					recordsServer : data.records,
					lastpageServer : data.total
				} );

				// because we changed the value of the data parameter
				// we need update internal _index parameter:
				this.refreshIndex();

				if( $this.jqGrid( 'getGridParam', 'sortname') !== '' ) {
					// we need reload grid only if we use sortname parameter,
					// but the server return unsorted data
					$this.triggerHandler( 'reloadGrid' );
				}
			} else {
				$this.jqGrid( 'setGridParam', {
					page : $this.jqGrid( 'getGridParam', 'pageServer' ),
					records : $this.jqGrid( 'getGridParam', 'recordsServer' ),
					lastpage : $this.jqGrid( 'getGridParam', 'lastpageServer' )
				} );
				this.updatepager( false, true );
			}			
		},
		gridComplete : function() {
			/* var rows = $( "#dataList" ).getDataIDs(); */
			/* var isAdmin = application_form.isAdmin.value; */
			/* for( var i = 0; i < rows.length; i++ ) {
				if(isAdmin == "Y"){
    		    	$('#dataList').jqGrid('setCell',rows[i],'dept_code','',{background:'#ffffe0'});
				}
			} */
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
	
	//그리드 넘버링 표시
	$("#dataList").jqGrid("setLabel", "rn", "No");
	//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
	fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() );
	
});	

</script>
</body>
</html>
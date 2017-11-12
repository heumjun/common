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
<title>Drawing Distribution History Search and Register</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
	/*Description 글자수 오버 시 Warp처리*/
    .ui-jqgrid tr.jqgrow td:nth-child(8){
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
		Drawing Distribution History Search and Register
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="designerID" value="${loginUserInfo.designerID}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="dwgDepartmentCode" value="${loginUserInfo.dwg_deptcode}" />
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="6%"/>
				<col width="8%"/>
				<col width="2%"/>
				<col width="10%"/>
				<col width="6%"/>
				<col width="6%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="*"/>
				<tr>
					<th>Project No.</th>
					<td>
						<input type="text" name="projectInput" id="projectNo" value="" style="width:100px;" >
		                <input type="button" name="showprojectListBtn" value="+" style="width:20px;height:20px;font-weight:bold;" 
		                       onclick="fn_showProjectSel(this);">
					</td>
					<th>Dept.</th>
					<td>
						<select name="departmentList" style="width:250px;" onchange="departmentSelChanged('designerList',this);">
							<option value="" selected="selected">&nbsp;</option>
							<!-- 부서 목록 리스트 추가 -->
							<c:forEach var="item" items="${departmentList }">
								<option value="${item.dept_code }" <c:if test="${item.dept_code eq loginUserInfo.dept_code }">selected="selected"</c:if>>${item.dept_code } : ${item.dept_name }</option>
							</c:forEach>
						</select>
					</td>
					<th>Distribution No. Requestor</th>
					<td>
						<select name="designerList" style="width:130px;">
							<option value="">&nbsp;</option>
							<!-- 사번 목록 리스트 추가 -->
							<c:forEach var="item" items="${personsList }">
								<option value="${item.employee_no }" >${item.employee_no }   ${item.employee_name }</option>
							</c:forEach>
						</select>
					</td>
					<td style="text-align: right;" colspan="2">
		                <input type="button" value='Search' class="btn_blue" id="btn_search"/>
		                 <input type="button" value='Register' class="btn_blue" id="btn_register"/>
		                <input type="button" value='Print' class="btn_blue" id="btn_print" onclick="viewReport();"/>
                		<c:if test="${loginUserInfo.is_admin eq 'Y'}">
	                		<input type="button" value='Save' class="btn_blue" id="btn_save"/>
			                <input type="button" value='Del' class="btn_blue" id="btn_del"/>
                		</c:if>
	            	</td>
				</tr>
				<tr>
					<th>Distribution No. Request Date</th>
					<td align="left">
						<input type="text" id="p_created_date_start" value="" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 65px;"/>
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 65px;"/>
						<input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>Dwg No.</th>
					<td>
						<input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="text" name="drawingNo" value="" maxlength="1" style="width:18px;"   />
		                <input type="button" name="" value="clear" class="btn_blue" onclick="clearData(this);" />
					</td>
					<th>REV.</th>
					<td> 
						<input type="text" name="deployRevInput" value="" maxlength="2" style="width:100px;" >
                    </td>
                    <th>Distribution No.</th>
                    <td>
                    	<input type="text" name="deployNoInput" value="" maxlength="9" style="width:120px;" >
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
</div>
<!-- 호선 선택 div팝업 -->
<div id="projectListDiv" style="position:absolute;display:none; z-index: 9;">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="projectList" id="projectList" style="width:150px;background-color:#fff0f5" onchange="fn_projectChanged(this);">
            <option value="&nbsp;"></option>
            <c:forEach var="item" items="${projectList }">
            	<option value="${item.projectno }">${item.projectno }</option>
            </c:forEach>
        </select>
    </td></tr>
    </table>
</div>
<!-- 구분 선택 div팝업 -->
<div id="gubunSelectDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="gubunSelect" style="width: 120px;" onchange="fn_gubunSelectChanged();">
        	<option value=""></option>
            <option value="출도실">출도실</option>
            <option value="자체">자체</option>
        </select>
    </td></tr>
    </table>
</div>
<!-- 일반 입력 div팝업 -->
<div id="inputTextDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
    	<input type="hidden" id="columnName" value="">
        <input type="text" id="inputText" value="" onchange="fn_inputTextChanged();">
    </td></tr>
    </table>
</div>
<!-- 원인부서 선택 div팝업 -->
<div id="causeDepartSelectDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="causeDepartSelect" style="width: 120px;" onchange="fn_causeDepartSelectChanged();">
        				
        	<option value=""></option>
        	<c:forEach var="item" items="${causeDepartmentList }">
        		<option value="${item.dept_code }">${item.dept_name }</option>
        	</c:forEach>
        </select>
    </td></tr>
    </table>
</div>
<!-- Note TextArea div팝업 -->
<div id="deployDescDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
       	<textarea rows="2" cols="20" id="deployDescArea" onchange="fn_deployDescChanged();">
       	</textarea>
    </td></tr>
    </table>
</div>
<script type="text/javascript">
	//호선 검색 값 변경
	function fn_projectChanged(obj){
		$("#projectNo").val($(obj).val());
		fn_hideProjectSel();
	}
	//호선 검색view show
	function fn_showProjectSel(obj){
		var activeDivObj = $("#projectListDiv");
		var activeSelectBox = $("#projectList");
		activeDivObj.css("left",$(obj).prev().offset().left);
		activeDivObj.css("top",$(obj).prev().offset().top);
		activeDivObj.css("display","");
		activeSelectBox.find("option:eq(0)").attr("selected","true");
		activeSelectBox.focus().click();
	}
	//호선 검색 view hide
	function fn_hideProjectSel(){
		$("#projectListDiv").css("display","none");
	}
	
	//선택 영역 안 전체 input type text 들 값 제거 
	function clearData(obj){
		var parent = $(obj).closest("td");
		parent.find("input[type=text]").val("");
	}
	//부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
	function departmentSelChanged(sabunTagName,obj) 
	{
	    var dept_code = $(obj).val();
	    var sabunTagObj = $("select[name="+sabunTagName+"]");
	    $.ajax({
	    	url:'<c:url value="getPartPersons.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"dept_code" : dept_code},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		sabunTagObj.empty();
	    		sabunTagObj.append("<option value=''>&nbsp;</option>");
	    		for(var i=0; i<jsonData.rows.length; i++){
	    			var rows = jsonData.rows[i];
	    			sabunTagObj.append("<option value='"+rows.employee_no+"'>"+rows.employee_no+" : "+rows.employee_name+"</option>");
	    		}
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
	
	//Division select box 선택
	function fn_gubunSelectChanged(){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		var gubunSelectValue = $("#gubunSelectDiv [name=gubunSelect]").val();
		if(gubunSelectValue == ""){
			fn_toggleDivPopUp();
			return;
		}
		if(!$("#"+selectRow+"_checkBox").is(":checked"))$("#"+selectRow+"_checkBox").prop("checked",true);
		$('#dataList').jqGrid('setCell',selectRow, 'gubun', gubunSelectValue,{background : "#ff0000"});
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	  	fn_toggleDivPopUp();
	}
	//Division select box 구분 팝업
	function fn_selectGubun(targetObj,currentData){
	    fn_toggleDivPopUp($("#gubunSelectDiv"),targetObj);
    	var gubunSelect = $("#gubunSelectDiv [name=gubunSelect]");
    	gubunSelect.css("width",targetObj.css("width"));
    	gubunSelect.css("height",targetObj.css("height"));
        gubunSelect.val(currentData);
    	gubunSelect.focus().click();
	}
	
	//원인부서 선택 select box
	function fn_causeDepart(targetObj,currentData){
		fn_toggleDivPopUp($("#causeDepartSelectDiv"),targetObj);
    	var causeDepartSelect = $("#causeDepartSelectDiv [name=causeDepartSelect]");
    	causeDepartSelect.css("width",targetObj.css("width"));
    	causeDepartSelect.css("height",targetObj.css("height"));
    	causeDepartSelect.val(currentData);
    	causeDepartSelect.focus().click();
	}
	//원인부서 선택
	function fn_causeDepartSelectChanged(){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		var causeDepartSelectValue = $("#causeDepartSelectDiv [name=causeDepartSelect]").val();
		var causeDepartSelectName = $("#causeDepartSelectDiv [name=causeDepartSelect] option:selected").text();
		if(causeDepartSelectValue == ""){
			fn_toggleDivPopUp();
			return;
		}
		if(!$("#"+selectRow+"_checkBox").is(":checked"))$("#"+selectRow+"_checkBox").prop("checked",true);
		$('#dataList').jqGrid('setCell',selectRow, 'cause_depart_code', causeDepartSelectValue);
		$('#dataList').jqGrid('setCell',selectRow, 'cause_depart_name', causeDepartSelectName,{background : "#ff0000"});
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	  	fn_toggleDivPopUp();
	}
	//일반 input box 변경사항 처리
	function fn_inputTextChanged(){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		var inputText = $("#inputText").val();
		var columnName = $("#columnName").val();
		if(columnName == '') return;
		if(inputText == '') inputText = "&nbsp;";
		
		if(columnName == 'eco_no' && inputText != "&nbsp;"){
			var num_check=/^[0-9]*$/;
			if(!num_check.test(inputText)){
				alert("숫자만 입력 바랍니다.");
				return;
			} else {
				/**기존 로직 주석처리된 부분 
				    !! : 기존 로직에서 주석 처리된 부분에서 findObjects를 부르거나 사용한 곳을 알수가 없음. 기존로직에서도 주석처리됨
					DIS-ERROR : ECO 정보 가져오는 부분 수정필요
				    // PLM에서 ECO 정보를 GET 
				    else if (requestProc != null && requestProc.equalsIgnoreCase("GetECOInfo")) {
				        String ecoNo = request.getParameter("ecoNo");
				
				        try { 
				            String whereExp = "name == '" + ecoNo + "' && revision == '-'";
				            ArrayList selects = new ArrayList();
				            selects.addElement(DomainObject.SELECT_DESCRIPTION);
				            selects.addElement("attribute[Category of Change]");
				            ArrayList ArrayList = DomainObject.findObjects(context, "ECO", "eService Production", whereExp, selects);
				            if (ArrayList.size() > 0) {
				                Map map = (Map)ArrayList.get(0);
				                resultMsg = (String)map.get("attribute[Category of Change]") + "|" + (String)map.get(DomainObject.SELECT_DESCRIPTION);
				            }
				            else resultMsg = "";
				        }
				        catch (Exception e) { 
				            resultMsg = "ERROR"; 
				        }
				    }
				**/
				$('#dataList').jqGrid('setCell',selectRow, columnName, inputText,{background : "#ff0000"});
				$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
				fn_toggleDivPopUp();
				return;
			}
		}
		
		if(!$("#"+selectRow+"_checkBox").is(":checked"))$("#"+selectRow+"_checkBox").prop("checked",true);
		$('#dataList').jqGrid('setCell',selectRow, columnName, inputText,{background : "#ff0000"});
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
		
	  	fn_toggleDivPopUp();
	}
	
	//전체 input text type div 처리
	function fn_inputText(targetObj,colmnName,currentData,styleOption,maxLength) {
		fn_toggleDivPopUp($("#inputTextDiv"),targetObj);
		var initData = "";
		var initColmnName = "";
    	var inputText = $("#inputText");
    	var inputColNm = $("#columnName");
    	if(currentData != '') initData = currentData;
    	if(colmnName != '') initColmnName = colmnName;
    	inputColNm.val(initColmnName);
    	inputText.val(initData);
    	inputText.attr('style',styleOption);
    	inputText.css("width",targetObj.css("width"));
    	inputText.css("height",targetObj.css("height"));
    	inputText.attr('maxLength',maxLength);
    	inputText.focus().click();
	}
	//Category of Change Popup
	//출도원인 코드 선택 창을 SHOW
	function fn_reasonCodePopup(rowId){
		var rs  = window.showModalDialog("popUpHardCopyDwgCreateCodeSelect.do", 
				window, "dialogHeight:600px;dialogWidth:540px; center:on; scroll:on; status:off");
		if(rs != null || rs != undefined){
			if(!$("#"+rowId+"_checkBox").is(":checked"))$("#"+rowId+"_checkBox").prop("checked",true);
			$('#dataList').jqGrid('setCell',rowId, 'reason_code', rs,{background : "#ff0000"});
			$('#dataList').jqGrid('setCell',rowId, 'oper', 'U');
		}
	}
	//Distribution Time
	//개정시기 선택 popup show
	function fn_revTimingPopup(rowId,currentData){
		var paramStr = "dwgCategory=" + currentData +
						"&departCode=" + application_form.dwgDepartmentCode.value;
		var rs  = window.showModalDialog("popUpHardCopyDwgCreateRevTimingSelect.do?"+paramStr, 
				window, "dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no");
		if(rs != null || rs != undefined){
			if(!$("#"+rowId+"_checkBox").is(":checked"))$("#"+rowId+"_checkBox").prop("checked",true);
			$('#dataList').jqGrid('setCell',rowId, 'rev_timing', rs,{background : "#ff0000"});
			$('#dataList').jqGrid('setCell',rowId, 'oper', 'U');
		}
	}
	//note textarea변경시 배경 색처리및 값처리
	function fn_deployDescChanged(rowId){	
		if(!$("#"+rowId+"_checkBox").is(":checked"))$("#"+rowId+"_checkBox").prop("checked",true);
		$('#dataList').jqGrid('setCell',rowId, 'deploy_desc', '',{background : "#ff0000"});
		$('#dataList').jqGrid('setCell',rowId, 'oper', 'U');
	}
	
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
	
	//가져온 배열중에서 필요한 배열만 골라내기
	function getChangedChmResultData(callback ) {
		var resultData = []; 
		var changedData = $.grep( $( "#dataList" ).jqGrid( 'getRowData' ), function(obj) {
			return obj.checkBox == true;
		} );
		callback.apply(this, [ changedData.concat(resultData) ]);
	}
	
</script>
<script type="text/javascript">
$(document).ready(function(){
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
	
	//메뉴바 호선 선택 focus out시에 div 숨김처리
	$("#projectListDiv").focusout(function(e){
		e.preventDefault();
		e.stopPropagation();
		fn_hideProjectSel();
	});
	//그리드 div팝업 전체 focus out시에 div 숨김처리
	$(".div_popup").focusout(function(){
		fn_toggleDivPopUp();
	});
	//조회처리
	$("#btn_search").click(function(){
		
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="dwgRegisterMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :$('#application_form').serializeArray()
		} ).trigger( 'reloadGrid' );
		
	});
	
	// 도면 배포항목 등록 화면 Show
	$("#btn_register").click(function(){
		var rs  = window.showModalDialog("popUpHardCopyDwgCreate.do", 
				window, 'dialogHeight:600px;dialogWidth:920px;scroll=no;center:yes;resizable=no;status=no;');
		if(rs != null || rs != undefined){
			$("#btn_search").click();
		}
	});
	
	<c:if test="${loginUserInfo.is_admin eq 'Y'}">
	//저장
	$("#btn_save").click(function(){
		var chmResultRows = [];
		if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
			getChangedChmResultData(function(data){
				
				if(data.length == 0) alert("저장할 데이터가 없습니다");
				
				$.each(data,function(index){
					data[index].gubun = data[index].gubun.replace("Itself","자체");
					data[index].gubun = data[index].gubun.replace("Copy Center","출도실");
					data[index].rev_timing = data[index].rev_timing.replace("Pre-Design","설계 전");
					data[index].rev_timing = data[index].rev_timing.replace("Post-Design","설계 후");
					data[index].rev_timing = data[index].rev_timing.replace("Pre-Production","생산 전");
					data[index].rev_timing = data[index].rev_timing.replace("Post-Production","생산 후");
					data[index].rev_timing = data[index].rev_timing.replace("Pre-Manufacture","제작 전");
					data[index].rev_timing = data[index].rev_timing.replace("Post-Manufacture","제작 후");
					data[index].rev_timing = data[index].rev_timing.replace("Pre-Installation","설치 전");
					data[index].rev_timing = data[index].rev_timing.replace("Post-Installation","설치 후");
					data[index].rev_timing = data[index].rev_timing.replace("Pre-Cutting", "절단 전");
					data[index].rev_timing = data[index].rev_timing.replace("Post-Cutting", "절단 후");
					data[index].rev_timing = data[index].rev_timing.replace("Pre-Production", "시공 전");
					data[index].rev_timing = data[index].rev_timing.replace("Post-Production", "시공 후");
				});
				
				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				
				var url = 'dwgRegisterMainGridSave.do';
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
	//삭제
	$("#btn_del").click(function(){
		var chmResultRows = [];
		if ( confirm( '변경된 데이터를 삭제하시겠습니까?' ) != 0 ) {
			getChangedChmResultData(function(data){
				if(data.length == 0) alert("삭제할 데이터가 없습니다");
				
				$.each(data,function(index){
					data[index].oper = 'D';
				});
				
				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				
				var url = 'dwgRegisterMainGridSave.do';
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
	</c:if>
	
	fn_all_text_upper();
	var objectHeight = gridObjectHeight(4);
	$( "#dataList" ).jqGrid( {
		datatype : 'json',
		mtype : '',
		url : '',
		postData : fn_getFormData( '#application_form' ),
		colNames : ['선택'
		            ,'Division','Distribution No','Project','Rev','Dwg No','DESCRIPTION','Dept.'
		            ,'Distribution No. Requestor','Distribution No. Request Date','Distribution Date','ECO No.','Category of Change'
		            ,'Change Request Dept.','Distribution Time','Note'
		            ,'dept_code','employee_no','cause_depart_code','dwgcategory'
		            ,'oper'],
		colModel : [{name : 'checkBox', index : 'checkBox', width: 20, align : "center", formatter:checkBox, unformat:checkBoxUnformat},
		            {name : 'gubun', index : 'gubun', width: 80, align : "center"},
		            {name : 'deploy_no', index : 'deploy_no', width: 90, align : "center"},
		            {name : 'project_no', index : 'project_no', width: 50, align : "center"},
		            {name : 'deploy_rev', index : 'deploy_rev', width: 50, align : "center"},
		            {name : 'dwg_code', index : 'dwg_code', width: 50, align : "center"},
		            {name : 'dwg_title', index : 'dwg_title', width: 200, align : "center"},
		            {name : 'dept_name', index : 'dept_name', width: 80, align : "center"},
		            {name : 'name', index : 'name', width: 90, align : "center"},
		            {name : 'request_date', index : 'request_date', width: 90, align : "center"},
		            {name : 'deploy_date', index : 'deploy_date', width: 70, align : "center"},
		            {name : 'eco_no', index : 'eco_no', width: 110, align : "center"},
		            {name : 'reason_code', index : 'reason_code', width: 70, align : "center"},
		            {name : 'cause_depart_name', index : 'cause_depart_name', width: 90, align : "center"},
		            {name : 'rev_timing', index : 'rev_timing', width: 70, align : "center"},
		            {name : 'deploy_desc', index : 'deploy_desc', width: 150, align : "center",formatter:textArea, unformat:textAreaUnformat},
		            {name : 'dept_code', index : 'dept_code', width: 70, align : "center",hidden : true},
		            {name : 'employee_no', index : 'employee_no', width: 70, align : "center",hidden : true},
		            {name : 'cause_depart_code', index : 'cause_depart_code', width: 70, align : "center",hidden : true},
		            {name : 'dwgcategory', index : 'dwgcategory', width: 70, align : "center",hidden : true},
		            {name : 'oper', index : 'oper', width: 70, align : "center",hidden : true}
		           ],
		gridview : true,
		cmTemplate: { title: false },
		toolbar : [ false, "bottom" ],
		hidegrid: false,
		altRows:false,
		viewrecords : true,
		autowidth : true, //autowidth: true,
		height : objectHeight,
		pager: "#jqGridPager",
		rowNum : -1,
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
		},
		onCellSelect : function( rowId, colId, content, event) {
			var rowData = jQuery(this).getRowData(rowId);
			var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
			var isEditable = application_form.isAdmin.value == "Y" ? true : false;
			
			//입력 수정 layer팝업 전체 닫기
			fn_toggleDivPopUp();
			
			if(isEditable){
				//Division구분 선택 selectbox
				if(cm[colId].name == "gubun")fn_selectGubun( $(this).find("tr#"+rowId).find("td:eq("+colId+")"),rowData.gubun);
				if(cm[colId].name == "deploy_rev" ||
				   cm[colId].name == "deploy_date" ||
				   cm[colId].name == "eco_no"
				){
					var style = "width:"+$(this).find("tr#"+rowId).find("td:eq("+colId+")").width()+"px;"+
								"height:"+$(this).find("tr#"+rowId).find("td:eq("+colId+")").height()+"px;"+
								"cursor:hand;";
					var maxLength = 3;
					if(cm[colId].name == "deploy_date" || cm[colId].name == "eco_no") maxLength = 10;
					
					fn_inputText( $(this).find("tr#"+rowId).find("td:eq("+colId+")"),cm[colId].name,rowData[cm[colId].name],style,maxLength);
				}
				if(cm[colId].name == "reason_code") fn_reasonCodePopup(rowId);
				if(cm[colId].name == "cause_depart_name") fn_causeDepart($(this).find("tr#"+rowId).find("td:eq("+colId+")"),rowData.cause_depart_code);
				if(cm[colId].name =="rev_timing")fn_revTimingPopup(rowId,rowData.dwgcategory);
				/* if(cm[colId].name =="deploy_desc")fn_deployDesc($(this).find("tr#"+rowId).find("td:eq("+colId+")"),rowData.deploy_desc); */
			} else {
				
			}
		},
		loadComplete: function (data) {
			var isEditable = application_form.isAdmin.value == "Y" ? true : false;
			var ids = $("#dataList").getDataIDs();
			$("#cb_"+$("#dataList")[0].id).hide();
			$.each(ids,function(idx,rowId){
				var rowData = $("#dataList").getRowData(rowId);
				if(isEditable == true){
					var color = "#ffffe0";
					$('#dataList').jqGrid('setCell',rowId, 'gubun', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'deploy_rev', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'deploy_date', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'eco_no', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'reason_code', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'cause_depart_name', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'rev_timing', '', {background : color });
					$('#dataList').jqGrid('setCell',rowId, 'deploy_desc', '', {background : color });
				}
			});
		},
		gridComplete : function() {
			
		},
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
//checkbox formatter
function checkBox(cellValue,options,rowObject){
	var id = options['rowId'];
	var str = "<input type='checkBox' name='checkBox' id="+id+"_checkBox >";
	return str;
}
//checkbox un formatter
function checkBoxUnformat(cellValue,options,rowObject){
	var checked = $("#"+options['rowId']+"_checkBox").is(":checked");
	return checked;
}
//textArea formatter
function textArea(cellValue,options,rowObject){
	var isEditable = application_form.isAdmin.value == "Y" ? true : false;
	var id = options['rowId'];
	if(cellValue == undefined)cellValue = '';
	if(isEditable)var str = "<textarea name='deploy_desc' id='"+id+"_deploy_desc'  onchange='fn_deployDescChanged("+id+")'>"+cellValue+"</textarea>";
	else var str = "<textarea name='deploy_desc' id='"+id+"_deploy_desc'  onchange='fn_deployDescChanged("+id+")' readonly='readonly'>"+cellValue+"</textarea>";
	return str;
}
//textArea un formatter
function textAreaUnformat(cellValue,options,rowObject){
	var textAreaValue = $("#"+options['rowId']+"_deploy_desc").val();
	return textAreaValue;
}

//프린트(리포트 출력) - VIEW & PRINT 양식
function viewReport()
{
    var rdFileName = "stxPECDPHardCopyDwgView.mrd";
    viewReportProc(rdFileName);
}

// 프린트(리포트 출력) 서브 프로시저
function viewReportProc(rdFileName)
{
    var paramStr = application_form.projectInput.value + ":::" + 
    				application_form.departmentList.value + ":::" + 
    				application_form.designerList.value + ":::";

    var fromDate = application_form.dateSelected_from.value;
    var toDate = application_form.dateSelected_to.value;
    
    if (fromDate != "" && toDate != "") { // 시작-종료 순서가 반대이면 조정
        var tempStrs = fromDate.split("-");
        var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        tempStrs = toDate.split("-");
        var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        if (fromDateObj > toDateObj) {
            var temp = toDate;
            toDate = fromDate;
            fromDate = temp;
        }
    }

    paramStr += fromDate + ":::" + 
                toDate + ":::" + 
                application_form.deployRevInput.value + ":::" + 
                application_form.deployNoInput.value + ":::";

    var dwgCode = "";
    var test = $("#application_form input[name=drawingNo]");
    for (var i = 0; i < test.size(); i++) {
        var str = test[i].value;
        if (str == "") dwgCode += "_";
        else dwgCode += str;
    }

    paramStr += dwgCode + ":::";
    paramStr = encodeURIComponent(paramStr);

    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/" + rdFileName 
                 + "&param=" + paramStr;
    window.open(urlStr, "", "");
}
</script>
</body> 
</html>
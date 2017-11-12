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
<title>Drawing Distribution History Register</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<jsp:useBean id="toDay" class="java.util.Date" />
<style type="text/css">
	.addStyle td{
		text-align: left !important;
		padding-left: 5px !important;
	}
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
<body style=" overflow : scroll; overflow-x : hidden;">
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form name="application_form" id="application_form">
				<input type="hidden" name="deployNoPrefix" value="${deployNoPrefix}" />
			    <input type="hidden" name="dept_code" value="${loginUserInfo.dept_code }" />
			    <input type="hidden" name="loginID" value="${loginId }" />
			    <input type="hidden" name="requestDate" value="<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" />" />
			    <input type="hidden" name="deployDate" value="" />
				<table class="insertArea addStyle" cellSpacing="1" cellpadding="0" border="0" id="tableHead">
					<col width="30%"/>
					<col width="*"/>
					<tbody>
					    <tr>
							<th>Division</th>
							<td> 
								<input type="radio" name="inputGubun" value="출도실" checked="checked" onclick="gubun_printFromCopyRoomChecked();" />Copy Center
				            	<input type="radio" name="inputGubun" value="자체" onclick="gubun_printFromDeptChecked();" />Itself
				            </td>
					    </tr>
					    <tr>
							<th>Distribution No.</th>
							<td>${deployNoPrefix}-<i>xxxxx</i></td>
						</tr>
						<tr>
							<th>Dept.</th>
							<td>${loginUserInfo.dept_code }: ${loginUserInfo.dept_name }</td>
						</tr>
						<tr>
							<th>Distribution No. Requestor</th>
							<td>${loginUserInfo.name }</td>
						</tr>
						<tr>
							<th>Distribution No. Request Date</th>
							<td><fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" /></td>
						</tr>
						<tr>
							<th>Distribution Date</th>
							<td id="deployDateTD"></td>
						</tr>
					</tbody>
				</table>
			</form>
			<form id="application_form1" name="application_form1">
			<div class="content">
					<table id="dataList"></table>
					<div id="pDataList"></div>
			</div>
			</form>
			<div style="text-align: right;">
				 <input type="button" value="Save" class="btn_blue" id="btn_save">
				 <input type="button" name="cancelButton" value="Cancel" class="btn_blue" onclick="window.close();">
			</div>
		</div>
	</div>
	<div id="projectListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
	    <tr><td>
	    	<input type="hidden" id="targetRowId">
	        <select name="projectList" id="projectList" style="width:150px;background-color:#fff0f5" onchange="fn_projectChanged(this);">
	            <option value="&nbsp;"></option>
	            <c:forEach var="item" items="${projectList }">
	            	<option value="${item.projectno }">${item.projectno }</option>
	            </c:forEach>
	        </select>
	    </td></tr>
	    </table>
	</div>
	<div id="dwgNoListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
		    <tr><td>
		    	<input type="hidden" id="dwgNoTargetRowId">
		        <select name="dwgNoList" id="dwgNoList" style="width:150px;background-color:#fff0f5" onchange="fn_dwgNoChanged(this);">
		            <option value="&nbsp;"></option>
		        </select>
		    </td></tr>
	    </table>
	</div>
	<div id="causeDepartSelectDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
	    <tr><td>
	        <select name="causeDepartSelect" style="width: 120px;" onchange="fn_causeDepartSelectChanged();">
				<option value="" selected="selected">&nbsp;</option>
				<!-- 부서 목록 리스트 추가 -->
				<c:forEach var="item" items="${departmentList }">
					<option value="${item.dept_code }">${item.dept_code } : ${item.dept_name }</option>
				</c:forEach>
	        </select>
	    </td></tr>
	    </table>
	</div>
<script type="text/javascript">
	var tableId = '';
	var resultData = [];
	var kRow = 0;
	var kCol = 0;
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var row_selected = 0;
	var cmtypedesc;
	var lodingBox;
	var lastsel;
	$(document).ready(function(){
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['PROJECT','REV','DwgNo','DESCRIPTION','ECO No.','Category of Change','Change RequestDept.','Distribution Time','Note',
			            'dwgcategory','oper'],
			colModel : [      
			            {name : 'project_no', index : 'project_no', width: 80, align : "center", formatter:textSelectFormatter, unformat:textSelectUnFormatter},
			            {name : 'deploy_rev', index : 'deploy_rev', width: 50, align : "center", formatter:textFormatter, unformat:textUnFormatter},
			            {name : 'dwg_no', index : 'dwg_no', width: 110, align : "center", formatter:textSelectFormatter, unformat:textSelectUnFormatter},
			            {name : 'dwg_desc', index : 'dwg_desc', width: 200, align : "center",eidtable:false},
			            {name : 'eco_no', index : 'eco_no', width: 110, align : "center", formatter:textFormatter, unformat:textUnFormatter},
			            {name : 'reason_code', index : 'reason_code', width: 70, align : "center"},
			            {name : 'cause_depart_code', index : 'cause_depart_code', width: 90, align : "center"},
			            {name : 'rev_timing', index : 'rev_timing', width: 70, align : "center"},
			            {name : 'deploy_desc', index : 'deploy_desc', width: 150, align : "center",formatter:textArea, unformat:textAreaUnformat},
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
			emptyrecords : '데이터가 존재하지 않습니다. ',
			pager : jQuery('#pDataList'),
			pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
			cellEdit : false, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			beforeEditCell : function(rowid, cellname, value,iRow, iCol) {
				idRow = rowid;
				idCol = iCol;
				kRow = iRow;
				kCol = iCol;
			},
			ondblClickRow : function(rowId,iRow,colId) {
			},
			onCellSelect : function( rowId, colId, content, event) {
				var rowData = jQuery(this).getRowData(rowId);
				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				
				if(cm[colId].name == "reason_code") fn_reasonCodePopup(rowId);
				if(cm[colId].name == "cause_depart_code")fn_causeDepart($(this).find("tr#"+rowId).find("td:eq("+colId+")"),rowData.cause_depart_code);
				if(cm[colId].name =="rev_timing")fn_revTimingPopup(rowId,$("#"+rowId+"_"+"dwgcategory").val());
			},
			loadComplete: function (data) {
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
		//Add 버튼
		$("#dataList").navButtonAdd('#pDataList', {
			caption : "",
			buttonicon : "ui-icon-plus",
			onClickButton : addChmResultRow,
			position : "first",
			title : "Add",
			cursor : "pointer"
		});
		
		//Del 버튼
		$("#dataList").navButtonAdd('#pDataList', {
			caption : "",
			buttonicon : "ui-icon-minus",
			onClickButton : deleteRow,
			position : "second",
			title : "Del",
			cursor : "pointer"
		});
		
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		fn_gridresize( $(window), $("#dataList"),0,0.85);
		
		$(".div_popup").focusout(function(){
			fn_toggleDivPopUp();
		});
		
		$("#btn_save").click(function(){
			 var projectSelectBoxOptions = $("#projectList").find("option");
			var chmResultRows = [];
			if ( confirm( '데이터를 저장하시겠습니까?' ) != 0 ) {
				 if(!fn_checkGridModify( $("#dataList")))return;
				
				 getGridChangedData($("#dataList"), function(data){
					 	var check = false;
						$.each(data,function(index,value){
							// 호선입력 유효성(존재하는 호선인지) 체크
						 	for(var i =1; i< projectSelectBoxOptions.length;i++){
								if(data[index].project_no == ""){
									alert("Please input the 'Proejct.'!");
									check = false;
									break;
							 	} else if(data[index].project_no == projectSelectBoxOptions[i].value){
							 		check = true;
							 		break;
							 	}
							}
							if(!check){
								alert("Invalid or Unexisted Project No.!");
								return;
							}
							// REV. 값 범위가 유효한지 체크
							if(data[index].deploy_rev == ""){
								alert("Please input the 'REV.'!");
								check = false;
								return;
							}
							var num_check=/^[A-Za-z0-9+]*$/;
							if(!num_check.test(data[index].deploy_rev)){
								alert("Invalid REV.!");
								check = false;
								return;
							}	
							// 출도원인
							if(data[index].reason_code == ""){
								alert("Please input the 'Category of Change'!");
								check = false;
								return;
							}
							// 출도시기
							if(data[index].rev_timing == ""){
								 alert("Please input the 'Distribution Time'!");
								 check = false;
								return;
							}
							
							$.each(data[index],function(subindex,value){
								data[index][subindex] = value.trim();
							});
					 	});
						if(!check) return;
						var dataList = { chmResultList : JSON.stringify( data ) };
						
						var url = 'popUpHardCopyDwgCreateGridSave.do';
						var formData = fn_getFormData('#application_form');
						var parameters = $.extend({}, dataList, formData);
						
						lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
						$.post( url, parameters, function( data2 ) {
							alert(data2.resultMsg);
							if ( data2.result == 'success' ) {
								window.returnValue = data2.result;
				      			self.close();
							}
						}, "json" ).error( function() {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
							lodingBox.remove();
						} );
				 });
			}
		});
	});
	/** 구분(출도실|자체) 값 변경 시 배포일자 값 변경 ------------------------*/
    function gubun_printFromCopyRoomChecked()
    {
        application_form.deployDate.value = ""; 
        document.getElementById("deployDateTD").innerHTML = "";
    }
    function gubun_printFromDeptChecked()
    {
    	application_form.deployDate.value = "<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" />"; 
        document.getElementById("deployDateTD").innerHTML = "<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" />";
    }
	
	//Add 버튼 
	function addChmResultRow() {
		var ids = $("#dataList").getDataIDs();
		if(ids.length > 7){
			alert("8줄 이상 입력하실수 없습니다.");
			return;
		}
		$('#dataList').saveCell(kRow, idCol);
	
		var item = {};
		var colModel = $('#dataList').jqGrid('getGridParam', 'colModel');
	
		for ( var i in colModel)
			item[colModel[i].name] = '';
	
		item.oper = 'I';
	
		$('#dataList').resetSelection();
		var rowId = $.jgrid.randId();
		var color = "#ffffe0";
		$('#dataList').jqGrid('addRowData', rowId, item, 'first');
		
		$('#dataList').jqGrid('setCell',rowId, 'project_no', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'deploy_rev', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'dwg_no', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'eco_no', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'reason_code', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'cause_depart_name', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'rev_timing', '', {background : color });
		$('#dataList').jqGrid('setCell',rowId, 'deploy_desc', '', {background : color });
		tableId = '#dataList';
	}
	//Del 버튼
	function deleteRow() {
		$('#dataList').saveCell(kRow, kCol);

		var selrow = $('#dataList').jqGrid('getGridParam', 'selrow');
		var item = $('#dataList').jqGrid('getRowData', selrow);
		
		var ids = $("#dataList").getDataIDs();
		if(selrow == null){
			selrow = ids[0];
			item = $('#dataList').jqGrid('getRowData', selrow);
		}
		
		if (item.oper == 'I') {
			$('#dataList').jqGrid('delRowData', selrow);
		} else {
			item.oper = 'D';

			$('#dataList').jqGrid("setRowData", selrow, item);
			var colModel = $( '#dataList' ).jqGrid( 'getGridParam', 'colModel' );
			for( var i in colModel ) {
				$( '#dataList' ).jqGrid( 'setCell', selrow, colModel[i].name,'', {background : '#FF7E9D' } );
			}
		}

		$('#dataList').resetSelection();
	}
	
	
	//dwgcode selectlist
	// 도면번호 선택 SELECT BOX SHOW
	function fn_showDwgCodeNoSel(id,obj){
		fn_setSelectionRow(id);
		var rowData = $("#dataList").jqGrid('getRowData',id);
		var activeDivObj = $("#dwgNoListDiv");
		var activeSelectBox = $("#dwgNoList");
		var selectedProject = $("#"+id+"_project_no").val().trim();
        if (selectedProject == ""){
        	alert("Please select a PROJECT first!");
        	return;
        }
        
		$("#dwgNoTargetRowId").val(id);
		
		activeSelectBox.empty();
		activeSelectBox.append("<option value=''>&nbsp;</option>");
		
		$.ajax({
	    	url:'<c:url value="getDrawingListForWork2.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"dept_code" : application_form.dept_code.value,
	    			"project_no" : selectedProject},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		for(var i=0; i<jsonData.rows.length; i++){
	    			var rows = jsonData.rows[i];
	    			activeSelectBox.append("<option value='"+rows.dwgcode+","
	    										+rows.dwgtitle+","
	    										+rows.d_timing+","
	    										+rows.dwgcategory
	    										+"'>"+rows.dwgcode+" : "+rows.dwgtitle+"</option>");
	    		}
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    }).always( function() {
	    	activeDivObj.css("left",$(obj).prev().offset().left);
			activeDivObj.css("top",$(obj).prev().offset().top);
			activeDivObj.css("display","");
			activeSelectBox.find("option:eq(0)").prop("selected","true");
			activeSelectBox.css("width",$(obj).closest("td").width());
			activeSelectBox.css("height",$(obj).closest("td").height());
			activeSelectBox.focus().click();
		});
	}
	//dwgcode select
	// 도면번호 선택 SELECT BOX SHOW
	function fn_dwgNoChanged(obj){
		var splitObj = $(obj).val().split(",");
		$("#"+$("#dwgNoTargetRowId").val()+"_"+"dwg_no").val(splitObj[0]);
		$('#dataList').jqGrid('setCell',$("#dwgNoTargetRowId").val(), 'dwg_desc', splitObj[1]);
		$('#dataList').jqGrid('setCell',$("#dwgNoTargetRowId").val(), 'dwgcategory', splitObj[3]);
		
		/* activeDrawingNoInputObj.value = strs[0];
        activeDrawingDescInputObj.value = strs[1];
        //activeRevTimingInputObj.value = strs[2];
        activeDwgCategoryInputObj.value = strs[3]; */
        
		fn_toggleDivPopUp();
	}
	
	function fn_dwgCodeChanged(rowId,obj){
		
		// 대문자로 변환
        $(obj).val($(obj).val().toUpperCase());
		
		//수기 입력
		var selectedProject = $("#"+rowId+"_project_no").val().trim();
        if(selectedProject == ""){
        	alert("Please select a PROJECT first!");
        	return;
        }
        if($(obj).val().trim().length == 0) return;
        
		// 도면 Desc., 출도시기 값을 초기화
		$('#dataList').jqGrid('setCell',rowId, 'dwg_desc', '&nbsp;');
		$('#dataList').jqGrid('setCell',rowId, 'dwgcategory', '&nbsp;');
		$('#dataList').jqGrid('setCell',rowId, 'rev_timing', '&nbsp;');
		
        // 도면코드 8 자리가 다 입력되었으면 해당 도면의 정보를 쿼리해서 도면 Desc., 출도시기 값도 결정
        if ($(obj).val().trim().length == 8) {
        	$.ajax({
    	    	url:'<c:url value="getDrawingListForWork3.do"/>',
    	    	type:'POST',
    	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	    	data : {"dept_code" : application_form.dept_code.value,
    	    			"project_no" : selectedProject,
    	    			"dwg_no" : $(obj).val().trim()},
    	    	success : function(data){
    	    		var jsonData = JSON.parse(data);
    	    		if(jsonData == null){
    	    			alert("Dwg No. '" + drawingNoInputObj.value.trim() + "' does not exist!");
    	    			return;
    	    		}
    	    		else if(jsonData.dwgcode == '' || jsonData.dwgcategory == ''){
    	    			alert("Dwg No. '" + drawingNoInputObj.value.trim() + "' does not exist!");
    	    			return;
    	    		}
    	    		
    	    		$('#dataList').jqGrid('setCell',rowId, 'dwg_desc', jsonData.dwgtitle);
    	    		$('#dataList').jqGrid('setCell',rowId, 'dwgcategory', jsonData.dwgcategory);
    	    		
    	    		 /* (document.getElementById(dwgDescInputId)).value = strs[1];
                        //(document.getElementById(revTimingInputId)).value = strs[2];
                        (document.getElementById(dwgCategoryInputId)).value = strs[3]; */
    	    	}, 
    	    	error : function(e){
    	    		alert(e);
    	    	}
    	    });
        }
		
	}
	//custom formatter로 인한 row selection 강제 활성화처리
	function fn_setSelectionRow(id){
		$("#dataList").jqGrid('setSelection',id);
	}
	//input type + button formatter
	function textSelectFormatter(cellValue,options,rowObject){
		var id = options.rowId;
		var columnName = options['colModel'].name; 

		if(columnName == "project_no"){
			var str = "<input type='text' style='width:80%; height:100%;' onfocus='fn_setSelectionRow(\""+id+"\")' onkeyup='this.value=this.value.toUpperCase()' name='"+columnName+"' id='"+id+"_"+columnName+"'>"
			  +"<input type='button' value='+' style='width:20%; height:100%;' onclick='fn_showProjectSel(\""+id+"\",this)'>";
		} else if(columnName="dwg_no"){
			var str = "<input type='text' style='width:80%; height:100%;' maxlength=8 name='"+columnName+"' id='"+id+"_"+columnName+"' onfocus='fn_setSelectionRow(\""+id+"\")' onkeyup='fn_dwgCodeChanged(\""+id+"\",this)' onchange='fn_dwgCodeChanged(\""+id+"\",this)'>"
			+"<input type='button' value='+' style='width:20%; height:100%;' onclick='fn_showDwgCodeNoSel(\""+id+"\",this)'>";
		} else {
			var str = "<input type='text' style='width:80%; height:100%;' name='"+columnName+"' id='"+id+"_"+columnName+"' onfocus='fn_setSelectionRow(\""+id+"\")'>"
			  +"<input type='button' value='+' style='width:20%; height:100%;'>";
		}
		return str;
	}
	//Un input type + button formatter
	function textSelectUnFormatter(cellValue,options,rowObject){
		var id = options['rowId'];
		var columnName = options['colModel'].name;
		return $("#"+id+"_"+columnName).val();
	}
	//text formatter
	function textFormatter(cellValue,options,rowObject){
		var id = options['rowId'];
		var columnName = options['colModel'].name;
		var str = ""
		if(columnName == "eco_no"){
			str = "<input type='text' name='text' style='width:100%;' id='"+id+"_"+columnName+"' maxlength=10 onkeyup='fn_checkECONo(\""+id+"\",this)' onfocus='fn_setSelectionRow(\""+id+"\")'>";
		} 
		else str = "<input type='text' name='text' style='width:100%;' id='"+id+"_"+columnName+"' onkeyup='this.value=this.value.toUpperCase()' onfocus='fn_setSelectionRow(\""+id+"\")'>";
		return str;
	}
	//untext formatter
	function textUnFormatter(cellValue,options,rowObject){
		var id = options['rowId'];
		var columnName = options['colModel'].name;
		return $("#"+id+"_"+columnName).val();
	}
	
	//textArea formatter
	function textArea(cellValue,options,rowObject){
		var id = options['rowId'];
		if(cellValue == undefined)cellValue = '';
		
		var str = "<textarea name='deploy_desc' id='"+id+"_deploy_desc'>"+cellValue+"</textarea>";
		return str;
	}
	//textArea unformatter
	function textAreaUnformat(cellValue,options,rowObject){
		var textAreaValue = $("#"+options['rowId']+"_deploy_desc").val();
		return textAreaValue;
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
	
	//호선 검색view show
	function fn_showProjectSel(id,obj){
		fn_setSelectionRow(id);
		var activeDivObj = $("#projectListDiv");
		var activeSelectBox = $("#projectList");
		$("#targetRowId").val(id);
		activeDivObj.css("left",$(obj).prev().offset().left);
		activeDivObj.css("top",$(obj).prev().offset().top);
		activeDivObj.css("display","");
		activeSelectBox.find("option:eq(0)").prop("selected","true");
		activeSelectBox.css("width",$(obj).closest("td").width());
		activeSelectBox.css("height",$(obj).closest("td").height());
		activeSelectBox.focus().click();
	}
	//호선 변경
	function fn_projectChanged(obj){
		$("#"+$("#targetRowId").val()+"_"+"project_no").val($(obj).val());
		fn_toggleDivPopUp();
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
		$('#dataList').jqGrid('setCell',selectRow, 'cause_depart_code', causeDepartSelectValue);
	  	fn_toggleDivPopUp();
	}
	//Category of Change Popup
	//출도원인 코드 선택 창을 SHOW
	function fn_reasonCodePopup(rowId){
		var rs  = window.showModalDialog("popUpHardCopyDwgCreateCodeSelect.do", 
				window, "dialogHeight:600px;dialogWidth:540px; center:on; scroll:on; status:off");
		if(rs != null || rs != undefined){
			$('#dataList').jqGrid('setCell',rowId, 'reason_code', rs);
		}
	}
	//Distribution Time
	//개정시기 선택 popup show
	function fn_revTimingPopup(rowId,currentData){
		if (currentData == "") {
	            alert("Please select 'Dwg No' first!");
	            return;
	    }
		var paramStr = "dwgCategory=" + currentData +
						"&departCode=" + application_form.dept_code.value;
		var rs  = window.showModalDialog("popUpHardCopyDwgCreateRevTimingSelect.do?"+paramStr, 
				window, "dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no");
		if(rs != null || rs != undefined){
			$('#dataList').jqGrid('setCell',rowId, 'rev_timing', rs);
		}
	}

	/* ECO NO. 입력 시 출도원인과 비고 값 자동입력 */
    // ECO No. 입력 시 존재하는 ECO인지 체크하고, 존재하면 ECO 정보로 출도원인과 비고 값을 자동 입력 
	function fn_checkECONo(rowId,obj){
		 // ECO 코드 10 자리가 다 입력되었으면 해당 ECO의 정보를 쿼리해서 출도원인과 비고 값도 결정
        var ecoNo = $(obj).val().trim();
        if (ecoNo.length == 10) {
        	var num_check=/^[0-9]*$/;
			if(!num_check.test(ecoNo)){
				alert("Invalid 'ECO NO.'!");
				return;
			}else {
				//현재 밑에 로직 데이터 불러오는 부분 전체 주석처리되어있음.
				//메인과 같은형태임.
				//기존 로직 참조바람
				//페이지 : stxPECDP_GeneralAjaxProcess.jsp 메소드 : GetECOInfo
				/* checkECONoSubProc(ecoNo, ecoNoInputObj, indexNo); */	
			}
        }
	}
</script>
</body>
</html>
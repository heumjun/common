<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>비파괴검사대상 관리</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
 .ui-jqgrid .ui-jqgrid-htable th div {
    height:30px;
} 
</style>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<form id="application_form" name="application_form">
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}" />
			<input type="hidden" id="p_delegate_project_no" name="p_delegate_project_no"/>
			<input type="hidden" id="P_FILE_NAME" name="P_FILE_NAME"/>
			<div class="subtitle">
				비파괴검사대상 관리
				<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
				<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
			</div>
			<table class="searchArea conSearch">
					<col width="60">
					<col width="110">
					<col width="80">
					<col width="170">
					<col width="60">
					<col width="110">
					<col width="60">
					<col width="110">
					<col width="60">
					<col width="110">
					<col width="60">
					<col width="110">
					<col width="">
					<tr>
						<th>호선</th>
						<td>
						<input type="text" id="p_project_no" name="p_project_no" style="width: 80px;text-align: center;ime-mode:disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" value="${project_no}"/>
						<!-- <input type="button" id="btn_project_no" name="btn_project_no" class="btn_gray2" value="검색" /> -->
						</td>
						<th>부서</th>
						<td>
						<select id="dwgDept" name="dwgDept">
						<option value='ALL'>ALL</option>
						</select>
						</td>
						<th>DWG No.</th>
						<td>
						<input type="text" id="p_dwg_no" name="p_dwg_no" style="width:80px;" value="${p_dwg_no}" alt="DWG NO." onchange="onlyUpperCase(this);" />
						</td>
						<th>Stage</th>
						<td>
							<input type="text" name="p_stage_no" style="width:80px;" value="" onchange="onlyUpperCase(this);" />
						</td>
						<th>PCS No.</th>
						<td>
							<input type="text" name="p_pcs_no" style="width:80px;" value="" onchange="onlyUpperCase(this);" />
						</td>
						<th>구분</th><td>
						<select name="p_form" id="p_form">
							<option value="P"  selected="selected">관통관</option>
							<option value="N" >관통관 이외</option>
						</select>
						<td>
							<div class="button">
								<input type="button" id="btnSearch" name="" class="btn_blue" value="조회" />
								<input type="button" value="저장" id="btnSave" class="btn_blue" />
							</div>
						</td>
					</tr>
					</table>
					<table class="searchArea2">
						<tr>
							<td style = "padding-right:10px;">
								<div id="SeriesCheckBox" class="searchDetail seriesChk"  style="height:30px;"></div>
							</td>
						</tr>
					</table>
			<div class="content"  style="position:relative; float: left; width: 100%;">
				<fieldset style="border:none;position:relative; float:left; width: 49%;">
				<table class="searchArea2" >
						<tr><th width="120px">검사 대상 ITEM코드</th>
						<td>
							<input type="text" id="p_pcs_item_code1" maxlength="20" name="p_pcs_item_code1" value=""
							style="text-align: center; width: 120px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							
							<div class="button">
								<input type="button" id="btnDWGViewFrom" name="" class="btn_blue" value="도면 VIEW" />
							</div>
						</td>
						</tr>
				
				</table>
					<div  id="grdFromListDiv">
						<table id="grdFromList"></table>
						<div id="pgrdFromList"></div>
					</div>
				</fieldset>
				
				<fieldset style="border:none;position:relative; float:right; width: 49%;">
				<table class="searchArea2 conSearch" >
				<tr><th width="120px">검사 비대상 ITEM코드</th>
						<td>
							<input type="text" id="p_pcs_item_code2" maxlength="20" name="p_pcs_item_code2" value="" 
							style="text-align: center; width: 120px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
							
							<div class="button">
								<input type="button" id="btnDWGViewTo" name="" class="btn_blue" value="도면 VIEW" />
							</div>
						</td>
						</tr>
				</table>
					<div  id="grdToListDiv">
						<table id="grdToList"></table>
						<div id="pgrdToList"></div>
					</div>
				</fieldset>
			</div>
		</form>
	</div>
	<script type="text/javascript">
		var row_selected;
		var tableId = "#peGrid";
		var deleteData = [];

		var searchIndex = 0;
		var lodingBox;
		var win;

		var isLastRev = "N";
		var isExistProjNo = "N";
		var sState = "";

		var preFromProject_no, preToProject_no;
		var preFromRevision, preToRevision;
		
		$(document).ready(
				function() {
					/* history.pushState({"html":""},"",""); */
					$("#grdFromList").jqGrid({
						url: '',
						treedatatype: "json",
						mtype: "",
						postData : fn_getFormData("#application_form"),
						colNames : [ '도면<br><input type="checkbox" id = "chkHeaderFrom" onclick="checkBoxHeaderFrom(event)"/>','호선', 'BOM<br>STAGE', '도면 No',
						             'PCS No', '품목코드','관경','재질','두께','급관','수압','중량','관<br>형태','후처리<br>코드','의장<br>착수일'
						             ,'','','','file_name','emp_no','','검사대상<br><input type="checkbox" id = "fromChkHeader" onclick="fromCheckBoxHeader(event)" checked/>','', 'qm_check_flag',''],
						colModel : [ 
									 { name:'rev', index:'rev'				, width:25	,align:'center',formatter: formatOptChkFrom},
									 { name : 'project_no', index : 'project_no', width : 50, align : "center" },
						             { name : 'pipe_stage', index : 'pipe_stage', width : 40, align : "center"},
						             { name : 'dwg_no', index : 'dwg_no', width: 60, align : "center"},
						             { name : 'piece_no', index : 'piece_no', width : 60, align : "center" }, 
						             { name : 'pcs_item_code', index : 'pcs_item_code', width : 80, align : "center" },
						             
						             { name : 'diameter', index : 'diameter', width : 30, align : "center" },
						             { name : 'material', index : 'material', width : 30, align : "center" },
						             { name : 'thickness', index : 'thickness', width : 30, align : "center" },
						             { name : 'class_pipe', index : 'class_pipe', width : 30, align : "center" },
						             { name : 'water_press', index : 'water_press', width : 30, align : "center" },
						             { name : 'unit_weight', index : 'unit_weight', width : 30, align : "center" },
						             { name : 'form', index : 'form', width : 30, align : "center" },
						             { name : 'rt', index : 'rt', width : 30, align : "center" },
						             { name : 'scheduled_start_date', index : 'scheduled_start_date', width : 60, align : "center" },
						             
						             { name : 'project_id', index : 'project_id', width : 80, align : "center" ,hidden:true},
						             { name : 'job_item_id', index : 'job_item_id', width : 80, align : "center" ,hidden:true},
						             { name : 'pcs_item_id', index : 'pcs_item_id', width : 80, align : "center" ,hidden:true},
						             
						             { name : 'file_name', index : 'file_name', width : 80, align : "center" ,hidden:true},
						             { name : 'emp_no', index : 'emp_no', width : 80, align : "center" ,hidden:true},
						             
						             { name : 'ndt_pcs_flag', index : 'ndt_pcs_flag', width : 60, align: "center"  ,hidden:true},
						             { name : 'ndt_pcs_flag_check', index : 'ndt_pcs_flag_check', width : 40, align: "center", sortable : false,formatter : formatOptFrom, align : "center"},
						             { name : 'ndt_pcs_flag_changed', index : 'ndt_pcs_flag_changed', width : 80,hidden:true},
						             
						             
						             { name : 'qm_check_flag', index : 'qm_check_flag', width : 80, align : "center",hidden:true},
						             { name : 'oper', index : 'oper', width : 80, align : "center" ,hidden:true}
						           ],
						         rowNum : 100,
								 cmTemplate: { title: false },
								 rowList : [ 100, 500, 1000 ],
								 autowidth : true,
								 caption : "검사 대상",
								 rownumbers : true,
								 pager : $( '#pgrdFromList' ),
								 toolbar : [ false, "bottom" ],
								 viewrecords : true,
								 width		: $(window).width()  * 0.40,
								 height : $(window).height()-330,
		    			         hidegrid : false,

					    jsonReader : {
							root : "rows",
							page : "page",
							total : "total",
							records : "records",
							repeatitems : false,
						},
			            gridComplete : function() {
			            	var rows = $( "#grdFromList" ).getDataIDs();
							for ( var i = 0; i < rows.length; i++ ) {
								var ret = $(this).getRowData( rows[i] );
								if( ret.qm_check_flag != "Y" ){
									$( "#grdFromList" ).jqGrid( 'setCell', rows[i], 'ndt_pcs_flag_check', '', { cursor : 'pointer', background : 'pink' } );	
								}
							}
						},
						onCellSelect : function( rowid, iCol, cellcontent, e ) {
							
						}
					});			

					/* $("#grdFromList").jqGrid('filterToolbar', {
						stringResult : true,
						searchOnEnter : false
					}); */

					$("#grdToList").jqGrid({
						url: '',
						treedatatype: "json",
						mtype: "",
						postData : fn_getFormData("#application_form"),
						colNames : [ '도면<br><input type="checkbox" id = "chkHeaderTo" onclick="checkBoxHeaderTo(event)" />','호선', 'BOM<br>STAGE', '도면 No',
						             'PCS No', '품목코드','관경','재질','두께','급관','수압','중량','관<br>형태','후처리<br>코드','의장<br>착수일'
						             ,'','','','file_name','emp_no','','검사대상<br><input type="checkbox" id = "toChkHeader" onclick="toCheckBoxHeader(event)" />','', 'qm_check_flag',''],
						colModel : [ 
									 { name:'rev', index:'rev'				, width:25	,align:'center',formatter: formatOptChkTo},
									 { name : 'project_no', index : 'project_no', width : 50, align : "center" },
						             { name : 'pipe_stage', index : 'pipe_stage', width : 40, align : "center"},
						             { name : 'dwg_no', index : 'dwg_no', width: 60, align : "center"},
						             { name : 'piece_no', index : 'piece_no', width : 60, align : "center" }, 
						             { name : 'pcs_item_code', index : 'pcs_item_code', width : 80, align : "center" },
						             
						             { name : 'diameter', index : 'diameter', width : 30, align : "center" },
						             { name : 'material', index : 'material', width : 30, align : "center" },
						             { name : 'thickness', index : 'thickness', width : 30, align : "center" },
						             { name : 'class_pipe', index : 'class_pipe', width : 30, align : "center" },
						             { name : 'water_press', index : 'water_press', width : 30, align : "center" },
						             { name : 'unit_weight', index : 'unit_weight', width : 30, align : "center" },
						             { name : 'form', index : 'form', width : 30, align : "center" },
						             { name : 'rt', index : 'rt', width : 30, align : "center" },
						             { name : 'scheduled_start_date', index : 'scheduled_start_date', width : 60, align : "center" },
						             
						             { name : 'project_id', index : 'project_id', width : 80, align : "center" ,hidden:true},
						             { name : 'job_item_id', index : 'job_item_id', width : 80, align : "center" ,hidden:true},
						             { name : 'pcs_item_id', index : 'pcs_item_id', width : 80, align : "center" ,hidden:true},
						             
						             { name : 'file_name', index : 'file_name', width : 80, align : "center" ,hidden:true},
						             { name : 'emp_no', index : 'emp_no', width : 80, align : "center" ,hidden:true},
						             
						             { name : 'ndt_pcs_flag', index : 'ndt_pcs_flag', width : 60, align: "center"  ,hidden:true},
						             { name : 'ndt_pcs_flag_check', index : 'ndt_pcs_flag_check', width : 40, align: "center", sortable : false,formatter : formatOptTo, align : "center"},
						             { name : 'ndt_pcs_flag_changed', index : 'ndt_pcs_flag_changed', width : 80,hidden:true},
						             
						             
						             { name : 'qm_check_flag', index : 'qm_check_flag', width : 80, align : "center",hidden:true},
						             { name : 'oper', index : 'oper', width : 80, align : "center" ,hidden:true}
						           ],
						         rowNum : 100,
								 cmTemplate: { title: false },
								 rowList : [ 100, 500, 1000 ],
								 autowidth : true,
								 caption : "검사 비대상",
								 rownumbers : true,
								 pager : $( '#pgrdToList' ),
								 toolbar : [ false, "bottom" ],
								 viewrecords : true,
								 width		: $(window).width()  * 0.40,
								 height : $(window).height()-330,
		    			         hidegrid : false,

					    jsonReader : {
							root : "rows",
							page : "page",
							total : "total",
							records : "records",
							repeatitems : false,
						},
			            gridComplete : function() {
			            	var rows = $( "#grdToList" ).getDataIDs();
							for ( var i = 0; i < rows.length; i++ ) {
								var ret = $(this).getRowData( rows[i] );
								if( ret.qm_check_flag != "Y" ){
									$( "#grdToList" ).jqGrid( 'setCell', rows[i], 'ndt_pcs_flag_check', '', { cursor : 'pointer', background : 'pink' } );	
								}
								
							}
						},
						onCellSelect : function( rowid, iCol, cellcontent, e ) {
							
						}
					});		

					$("#btn_project_no").click(function() {
						var rs = window.showModalDialog("popUpProjectNo.do?pipe_project=Y&p_delegate_project_no=none", window, "dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off");
						if (rs != null) {
							$("#p_project_no").val(rs[0]);
						} else {
							$("#p_project_no").val('');
						}
					});

					$("#btnSearch").click(function() {
						fn_search();
					});
					// 저장 버튼
					$('#btnSave').click(function() {
						fn_save();
					});
					
					//grid resize
					fn_insideGridresize($(window),$("#grdFromListDiv"),$("#grdFromList"), 120);
					//grid resize
					fn_insideGridresize($(window),$("#grdToListDiv"),$("#grdToList"), 120);
					//fn_gridresize($(window),$("#entryDiv"));
					
					$.post( "selectDWGDPGroupList.do", fn_getFormData( '#application_form' ), function( data ) {
						for(var i =0; i < data.length; i++){
							if("${loginUser.upper_dwg_dept_code}" == data[i].dwg_dept_code){
								$("#dwgDept").append( "<option selected value='"+data[i].dwg_dept_code+ "'>" + data[i].dwg_dept_name + "</option>" );	
							} else {
								$("#dwgDept").append( "<option value='"+data[i].dwg_dept_code+ "'>" + data[i].dwg_dept_name + "</option>" );
							}
							 
						}	
					}, "json" );
				});
		
		/***********************************************************************************************																
		 * 이벤트 함수 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/
		//STATE 값에 따라서 checkbox 생성
		function formatOptChkFrom(cellvalue, options, rowObject){
			var rowid = options.rowId;
	   		var str ="<input type='checkbox' name='checkboxFrom' id='"+rowid+"_chkBoxOVFrom' class='chkboxItemFrom' value="+rowid+" />";
			return str;      
		}
		
		function formatOptChkTo(cellvalue, options, rowObject){
			var rowid = options.rowId;
	   		var str ="<input type='checkbox' name='checkboxTo' id='"+rowid+"_chkBoxOVTo' class='chkboxItemTo' value="+rowid+" />";
			return str;      
		}
		
		function formatOptFrom(cellvalue, options, rowObject){
			var rowid = options.rowId;
			if( rowObject.qm_check_flag == 'Y' ) {
				return "";
			} else {
				if(rowObject.ndt_pcs_flag == "Y") {
					return "<input type='checkbox' id='from"+rowid+"_ndt_pcs_flag' checked onclick='chkClickFrom(" + rowid + ")'/>";	
				} else {
					return "<input type='checkbox' id='from"+rowid+"_ndt_pcs_flag' onclick='chkClickFrom(" + rowid + ")'/>";	
				}
				
			}
		}
		
		function formatOptTo(cellvalue, options, rowObject){
			var rowid = options.rowId;
			if( rowObject.qm_check_flag == 'Y' ) {
				return "";
			} else {
				if(rowObject.ndt_pcs_flag == "Y") {
					return "<input type='checkbox' id='to"+rowid+"_ndt_pcs_flag' checked onclick='chkClickTo(" + rowid + ")'/>";	
				} else {
					return "<input type='checkbox' id='to"+rowid+"_ndt_pcs_flag' onclick='chkClickTo(" + rowid + ")'/>";	
				}
				
			}
		}
		
		function chkClickFrom( rowid ) {
			if( ( $( "#from" + rowid + "_ndt_pcs_flag" ).is( ":checked" ) ) ) {
				$("#grdFromList").setRowData( rowid, { ndt_pcs_flag : "Y" } );
			} else {
				$("#grdFromList").setRowData( rowid, { ndt_pcs_flag : "N" } );
			}
		}
		
		function chkClickTo( rowid ) {
			if( ( $( "#to" + rowid + "_ndt_pcs_flag" ).is( ":checked" ) ) ) {
				$("#grdToList").setRowData( rowid, { ndt_pcs_flag : "Y" } );
			} else {
				$("#grdToList").setRowData( rowid, { ndt_pcs_flag : "N" } );
			}
		}
		
		function checkBoxHeaderFrom(e) {
	  		e = e||event;/* get IE event ( not passed ) */
	  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if(($("#chkHeaderFrom").is(":checked"))){
				$(".chkboxItemFrom").prop("checked", true);
			}else{
				$("input.chkboxItemFrom").prop("checked", false);
			}
		}
		
		function checkBoxHeaderTo(e) {
	  		e = e||event;/* get IE event ( not passed ) */
	  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if(($("#chkHeaderTo").is(":checked"))){
				$(".chkboxItemTo").prop("checked", true);
			}else{
				$("input.chkboxItemTo").prop("checked", false);
			}
		}
		
		// header checkbox action 
		function fromCheckBoxHeader(e) {
			e = e || event;/* get IE event ( not passed ) */
			e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if (($("#fromChkHeader").is(":checked"))) {
				var rows = $( "#grdFromList" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = $( '#grdFromList' ).jqGrid( 'getRowData', rows[i] );
					if( item.qm_check_flag != "Y" ){
						item.ndt_pcs_flag = 'Y';
						$( '#grdFromList' ).jqGrid( "setRowData",rows[i], item );
						$( "#from" + rows[i] + "_ndt_pcs_flag" ).prop("checked", true);
					}
				}
				
			} else {
				var rows = $( "#grdFromList" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = $( '#grdFromList' ).jqGrid( 'getRowData', rows[i] );
					if( item.qm_check_flag != "Y" ){
						item.ndt_pcs_flag = 'N';
						$( '#grdFromList' ).jqGrid( "setRowData",rows[i], item );
						$( "#from" + rows[i] + "_ndt_pcs_flag" ).prop("checked", false);
					}
					
				}
			}
		}
		function toCheckBoxHeader(e) {
			e = e || event;/* get IE event ( not passed ) */
			e.stopPropagation ? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
			if (($("#toChkHeader").is(":checked"))) {
				
				var rows = $( "#grdToList" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = $( '#grdToList' ).jqGrid( 'getRowData', rows[i] );
					/* if( item.qm_check_flag != "Y" ){ */
						item.ndt_pcs_flag = 'Y';
						$( '#grdToList' ).jqGrid( "setRowData", rows[i], item );
						$( "#to" + rows[i] + "_ndt_pcs_flag" ).prop("checked", true);
					/* } */
				}
				
			} else {
				var rows = $( "#grdToList" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = $( '#grdToList' ).jqGrid( 'getRowData', rows[i] );
					if( item.qm_check_flag != "Y" ){
						item.ndt_pcs_flag = 'N';
						$( '#grdToList' ).jqGrid( "setRowData", rows[i], item );
						$( "#to" + rows[i] + "_ndt_pcs_flag" ).prop("checked", false);
					}
				}
			}
		}
		$("#btnDWGViewFrom").click(function(){
	    	vFileName="";
	    	if($(".chkboxItemFrom").is(":checked") == false){
	    		alert('VIEW대상 도면을 선택 바랍니다.');
	    		return;
	    	}  
	    	$(".chkboxItemFrom:checked").each(function() {
					var rowid = $(this).val();
					var item = $('#grdFromList').jqGrid('getRowData',rowid);
		    		vFileName += item.file_name+"|";
		    		vEmpNo = item.emp_no;
		    		
			});
			
				$("#P_FILE_NAME").val(vFileName);
	    		var sURL = "popUpDWGView.do?mode=dwgChkView&vEmpNo="+vEmpNo;
				form = $('#application_form');		
				form.attr("action", sURL);
				var myWindow = window.open("","listForm","height=100,width=100,location=no");
					    
				form.attr("target","listForm");
				form.attr("method", "post");	
						
				myWindow.focus();
				form.submit();
	    });
		
		$("#btnDWGViewTo").click(function(){
	    	vFileName="";
	    	if($(".chkboxItemTo").is(":checked") == false){
	    		alert('VIEW대상 도면을 선택 바랍니다.');
	    		return;
	    	}  
	    	$(".chkboxItemTo:checked").each(function() {
					var rowid = $(this).val();
					var item = $('#grdToList').jqGrid('getRowData',rowid);
		    		vFileName += item.file_name+"|";
		    		vEmpNo = item.emp_no;
		    		
			});
			
				$("#P_FILE_NAME").val(vFileName);
	    		var sURL = "popUpDWGView.do?mode=dwgChkView&vEmpNo="+vEmpNo;
				form = $('#application_form');		
				form.attr("action", sURL);
				var myWindow = window.open("","listForm","height=100,width=100,location=no");
					    
				form.attr("target","listForm");
				form.attr("method", "post");	
						
				myWindow.focus();
				form.submit();
	    });
		 /* function formChange(sel) {
			 if(sel.value == "N"){
				 $("#p_pcs_item_code2").addClass( "required" );
			 } else {
				 $("#p_pcs_item_code2").removeClass( "required" );
			 }
		 } */


		/***********************************************************************************************																
		 * 기능 함수 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/

		// Input Text입력시 대문자로 변환하는 함수
		function onlyUpperCase(obj) {

			obj.value = obj.value.toUpperCase();
			
		}

		// 폼데이터를 Json Arry로 직렬화
		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}


		/***********************************************************************************************																
		 * 서비스 호출하는 부분 입니다. 	
		 *
		 ************************************************************************************************/
		function fn_search(){
			
			/* if($("#p_form option:selected").val() =="N"){
				if($("#p_pcs_item_code2").val() ==""){
					alert("관통관 이외는 검사비대상 ITEM코드가 필수 입력입니다.");
					return;
				}
			} */
			/* if($("#p_project_no").val() ==""){
				alert("호선은 필수 입력입니다.");
				return;
			} */
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y", null);
			
			$("#grdToList").clearGridData(true);
			$("#grdFromList").clearGridData(true);
			var sUrl = "ndtPcsList.do?p_ndt_pcs_flag=Y";
			jQuery("#grdFromList").jqGrid('setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype : "json",
				postData : getFormData("#application_form")
			}).trigger("reloadGrid");	
			
			var sUrl = "ndtPcsList.do?p_ndt_pcs_flag=N";
			jQuery("#grdToList").jqGrid('setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype : "json",
				postData : getFormData("#application_form")
			}).trigger("reloadGrid");
		}

		// 원본 프로젝트의 목록를 대상 프로젝트로 복사 저장
		function fn_save() {
			
			var fromList = $( "#grdFromList" ).getDataIDs();
			//var fromList = $( "#grdFromList" ).jqGrid( 'getRowData' );
			//변경된 체크 박스가 있는지 체크한다.
			for( var i = 0; i < fromList.length; i++ ) {
				var item = $( '#grdFromList' ).jqGrid( 'getRowData', fromList[i] );
				if( item.ndt_pcs_flag_changed != item.ndt_pcs_flag ) {
					item.oper = 'U';
				} else {
					item.oper = '';
				}
				$( '#grdFromList' ).jqGrid( "setRowData", fromList[i], item );
			}
			
			var toList = $( "#grdToList" ).getDataIDs();
			//var toList = $( "#grdToList" ).jqGrid( 'getRowData' );
			//변경된 체크 박스가 있는지 체크한다.
			for( var i = 0; i < toList.length; i++ ) {
				var item = $( '#grdToList' ).jqGrid( 'getRowData', toList[i] );
				if( item.ndt_pcs_flag_changed != item.ndt_pcs_flag ) {
					item.oper = 'U';
				} else {
					item.oper = '';
				}
				$( '#grdToList' ).jqGrid( "setRowData", toList[i], item );
			}

			var changedData1 = $.grep($("#grdFromList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'U';
			});
			
			var changedData2 = $.grep($("#grdToList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'U';
			});
			
			if(changedData1.length ==0 && changedData2.length ==0) {
				alert("변경된 내용이 없습니다.");
				return;
			}
			
			if (confirm('저장 하시겠습니까?') == 0) {
				return;
			}
			
			lodingBox = new ajaxLoader($('#mainDiv'), {
				classOveride : 'blue-loader',
				bgColor : '#000',
				opacity : '0.3'
			});
			var changedData = $.merge(changedData1,changedData2);
			var dataList = {
					chmResultList : JSON.stringify(changedData)
				};
			var formData = getFormData('#application_form');

			var parameters = $.extend({}, dataList, formData );
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			var url = "saveNdtPcsMgnt.do?p_chk_series="+ar_series;
			
			$.post(url,
					parameters,
					function(data) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								fn_search();
							}

					}).fail(function() {
				alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			}).always(function() {
				lodingBox.remove();
			});
		}
		
	</script>
</body>
</html>

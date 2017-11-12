<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC Management</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<input type="hidden" id="p_col_name" name="p_col_name"/>
		<input type="hidden" id="p_data_name" name="p_data_name"/>
		<input type="hidden" id="p_dept_nm" name="p_dept_nm" value="${loginUser.dwg_dept_name}"/>
		<input type="hidden" id="p_master_project_no" name="p_master_project_no"/>
		<input type="hidden" id="temp_project_no" name="temp_project_no" value="" />
		<div class="subtitle">
		JOB CREATE
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="65"/>
			<col width="85"/>
			<col width="80"/>			
			<col width="70"/>
			<col width="160"/>
			<col width="70"/>
			<col width="100"/>
			<col width="*"/>
			<tr>
				<th>PROJECT</th>
				<td>
					<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:60px;" value="" onblur="javascript:getDwgNos();"  />
				</td>
				<th>BLOCK</th>
				<td>
					<input type="text" name="p_block_no" style="width:50px;" />
				</td>
				<th>STR</th>
				<td>
					<!--<input type="text" name="p_str_flag" style="width:50px;" />-->
					<select name="p_str_flag" id="p_str_flag" style="width:46px;">
						<option value="%">ALL</option>
					</select>
				</td>
				<th>NAME(TYPE)</th>
				<td>
					<input type="text" name="p_usc_job_type" style="width:60px;" />
				</td>								
				<th>DEPT</th>
				<td>
					<c:choose>
						<c:when test="${loginUser.gr_code=='M1'}">
							<select name="p_sel_dept" id="p_sel_dept" style="width:140px;" onchange="javascript:DeptOnChange(this);" >
							</select>
							<input type="hidden" id="p_dept_code" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
							<input type="hidden" id="p_dept_name" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  />
						</c:when>
						<c:otherwise>
							<input type="text" id="p_dept_name" name="p_dept_name" class="disableInput" value="<c:out value="${loginUser.dwg_dept_name}" />" style="width:140px;" readonly="readonly" />
							<input type="hidden" id="p_dept_code" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
						</c:otherwise>
					</c:choose>
				</td>
				<th>USER</th>
				<td>
					<!-- <input type="text" class="disableInput" name="p_emp_no" style="margin-right:20px; width:55px;" value="<c:out value="${loginUser.user_name}" />" readonly="readonly"/>
					<input type="hidden" name="p_emp_no" value="<c:out value="${loginUser.user_id}" />"  /> -->
					<select name="p_emp_no" id="p_emp_no" style="width:80px;" onchange="javascript:UserOnChange(this);" >
					</select>
					<input type="hidden" name="p_user_id" value="<c:out value="${loginUser.user_id}" />"  />
					<input type="hidden" name="p_user_name" value="<c:out value="${loginUser.user_name}" />"  />
				</td>	
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >						
						<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
						<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
						<input type="button" class="btn_blue2" value="MOVE" id="btnMove"/>
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
					</div>
				</td>				
			</tr>
		</table>
		<table class="searchArea2">
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="150"/>
			<col width="80"/>
			<col width="150"/>
			<col width="80"/>
			<col width="170"/>			
			<col width="*"/>
			<tr>
				<th>STATE</th>
				<td>
					<select name="p_status">
						<option value="%" selected="selected">ALL</option>
						<option value="A">A</option>
						<option value="D">D</option>
					</select>
				</td>
				<th>ECO No.</th>
				<td>
					 <input type="text" name="p_eco_no" value="" style="width:60px;"  />
				</td>
				<th>BK ITEM</th>
				<td>
				<input type="text" name="p_bk_code" value="" style="width:130px;" />
				</td>
				<th>ACT ITEM</th>
				<td>
				<input type="text" name="p_act_code" value="" style="width:130px;" />
				</td>				
				<th>JOB ITEM</th>
				<td>
				<input type="text" name="p_job_code" value="" style="width:130px;" />
				</td>		
				<th>ECO</th>
				<td>
				<select name="p_is_eco" class="commonInput" style="width:45px;">
					<option value="ALL" selected="selected">ALL</option>
					<option value="Y" >Y</option>
					<option value="N" >N</option>
				</select>
				</td>		
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_blue2" value="EXPORT" id="btnExport"/>
						<input type="button" class="btn_blue2" value="BOM" id="btnBom"/>
						<input type="button" class="btn_blue2" value="RESTORE" id="btnRestore"/>
						<input type="button" class="btn_blue2" value="CANCEL" id="btnCancel"/>						
					</div>
				</td>	
			</tr>
		</table>
		<div class="series"> 
			<table class="searchArea">
				<tr>
					<td>
						<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="content">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var resultData = [];
	
	var jqGridObj = $("#jqGridMainList");	
	
	//기술 기획일 경우 부서 선택 기능
	if(typeof($("#p_sel_dept").val()) !== 'undefined'){
		getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
	}
	
	if(typeof($("#p_dept_code").val()) != 'undefined'){
		getAjaxHtml($("#p_emp_no"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerUser&p_dept_code="+$("input[name=p_dept_code]").val()+"&p_user_id="+$("input[name=p_user_id]").val(), null, null);	
	}
	
	$(document).ready(function(){
		
		//엔터 버튼 클릭
		$("*").keypress(function(event) {
		  if (event.which == 13) {
		        event.preventDefault();
		        $('#btnSelect').click();
		    }
		});
		
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'STATE' 		, name : 'state_flag'	, index : 'state_flag'	, width : 100, editable : false, align : "center"},
					{label:'MASTER'	    , name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 80, editable : false, align : "center"},
					{label:'PROJECT'	, name : 'project_no'	, index : 'project_no'	, width : 80, editable : false, align : "center"},
					{label:'구역'			, name : 'area'			, index : 'area'		, width : 100, editable : false, align : "center", hidden:true},
					{label:'BLOCK'		, name : 'block_no'		, index : 'block_no'	, width : 60, editable : false, align : "center"},
					{label:'STR'		, name : 'str_flag'		, index : 'str_flag'	, width : 60, editable : false, align : "center"},
					{label:'B_STR'		, name : 'block_str_flag', index : 'block_str_flag'	, width : 60, editable : false, align : "center", hidden:true},
					{label:'NAME(TYPE)'	, name : 'usc_job_type'	, index : 'usc_job_type', width : 120, editable : false, align : "center"},
					{label:'BK ITEM'	, name : 'block_code'	, index : 'block_code'	, width : 130, editable : false, align : "center"},
					{label:''			, name : 'old_act_code'	, index : 'old_act_code', width : 130, editable : false, align : "center", hidden:true},
					{label:'ACT ITEM'	, name : 'act_code'		, index : 'act_code'	, width : 130, editable : false, align : "center"},					
					{label:'JOB ITEM'	, name : 'job_code'		, index : 'job_code'	, width : 130, editable : false, align : "center"},
					{label:''			, name : 'block_catalog', index : 'block_catalog', width : 130, editable : false, align : "center", hidden:true},
					{label:''   		, name : 'act_catalog'	, index : 'act_catalog'	, width : 130, editable : false, align : "center", hidden:true},
					{label:'JOB CATA'	, name : 'job_catalog'	, index : 'job_catalog'	, width : 130, editable : false, align : "center"},
					{label:'DEPT'		, name : 'dwgdeptnm'	, index : 'dwgdeptnm'	, width : 150, editable : false, align : "center"},
					{label:'USER'		, name : 'user_name'	, index : 'user_name'	, width : 100, editable : false, align : "center"},
					{label:'DATE'		, name : 'work_date'	, index : 'work_date'	, width : 100, editable : false, align : "center"},
					{label:'ECO'		, name : 'eco_no'		, index : 'eco_no'		, width : 100, editable : false, align : "center", classes : "handcursor"},
					{label:'RELEASE'	, name : 'eco_date'		, index : 'eco_date'	, width : 100, editable : false, align : "center"},
					{label:'WORK'		, name : 'work_yn'		, index : 'work_yn'		, width : 60, editable : false, align : "center"},
					{label:'BOM'		, name : 'ssc_bom_qty'	, index : 'ssc_bom_qty'	, width : 60, editable : false, align : "center"},
					{label:'ACT CODE'	, name : 'wip_act_code'	, index : 'wip_act_code', width : 100, editable : false, align : "center"},
					{label:'ACT ST'		, name : 'wip_act_st'	, index : 'wip_act_st'	, width : 100, editable : false, align : "center"},
					{label:'CRUD'		, name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true}					
				],
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cmTemplate: { title: false },
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
             multiselect: true,
             
             height: 460,
             pager: '#bottomJqGridMainList',
             rowList:[100,500,1000],
	         rowNum:100, 
	         recordtext: '내용 {0} - {1}, 전체 {2}',
        	 emptyrecords:'조회 내역 없음',
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow = rowid;
             	idCol = iCol;
             	kRow  = iRow;
             	kCol  = iCol;
   			 },
			 jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             onPaging: function(pgButton) {

			 },
   			 loadComplete: function (data) {
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        //datatype: 'local',
				        data: data.rows,
				        pageServer: data.page,
				        recordsServer: data.records,
				        lastpageServer: data.total
				    });
				
				    // because we changed the value of the data parameter
				    // we need update internal _index parameter:
				    this.refreshIndex();
				
				    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
				        // we need reload grid only if we use sortname parameter,
				        // but the server return unsorted data
				        $this.triggerHandler('reloadGrid');
				    }
				} else {
				    $this.jqGrid('setGridParam', {
				        page: $this.jqGrid('getGridParam', 'pageServer'),
				        records: $this.jqGrid('getGridParam', 'recordsServer'),
				        lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
				    });
				    this.updatepager(false, true);
				}					
			},
			gridComplete: function(data){

			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {

			},
			ondblClickRow : function(rowid, cellname, value, iRow, iCol) {
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colModel" );
				var colName = cm[value];
				var item = $("#jqGridMainList").jqGrid( "getRowData", rowid );
				var prj_no = item.project_no;
				
				if ( colName['index'].indexOf("eco_no") == 0 ) {
					var ecoName = item.eco_no;
	              	
	              	if( ecoName != "" && ecoName != "W" ) {
						var sUrl = "./eco.do?ecoName=" + ecoName+"&popupDiv=Y&checkPopup=Y&menu_id=${menu_id}";
						window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:650px; center:on; scroll:off; status:off");
	              	}
				}
				if ( colName['index'].indexOf("block_code") == 0 ) {
					var block_code = item.block_code;
					if(block_code != '' && block_code != undefined) {
						var arg = "&mother_code="+prj_no+"&item_code="+block_code+"&project_no="+prj_no;
						var rs = window.open("bomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
						"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
					}
				}
				if ( colName['index'].indexOf("act_code") == 0 ) {
					var block_code = item.block_code;
					var act_code = item.act_code;
					if(act_code != '' && act_code != undefined) {
						var arg = "&mother_code="+block_code+"&item_code="+act_code+"&project_no="+prj_no;
						var rs = window.open("bomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
						"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
					}			
				}
				if ( colName['index'].indexOf("job_code") == 0 ) {
					var act_code = item.act_code;
					var job_code = item.job_code;
					if(job_code != '' && job_code != undefined) {
						var arg = "&mother_code="+act_code+"&item_code="+job_code+"&project_no="+prj_no;
						var rs = window.open("bomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
						"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
					}
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
    	// 구역 선택
     	$.post( "infoAreaList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_area").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_desc+"</option>");
     		}
		}, "json" );
     	// 구역 선택
     	$.post( "infoStrList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_str_flag").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 90 );   
     	
	    //project 변경 시
		$("#p_project_no").change(function(){
			jqGridObj.jqGrid("clearGridData");
		});
	    
		//부서 변경 시
		$("#p_sel_dept").change(function(){
			getAjaxHtml($("#p_emp_no"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerUser&p_dept_code="+$("#p_sel_dept").val()+"&p_user_id="+$("input[name=p_user_id]").val(), null, null);
		});
		
		//MOVE 버튼 클릭 시
		$("#btnMove").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			for(var i=0; i<row_id.length; i++) {		
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				if(item.job_code == '' || item.job_code == undefined) {
					alert("JOB CODE는 필수입니다.");
					return false;
				}	
			}
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			var nwidth = 900;
			var nheight = 600;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
			var rs = window.open( "popUpUscJobCreateMove.do?p_project_no="+$("#p_project_no").val(), "jobMove", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
		});
		
		//Add 버튼 클릭 시
		$("#btnAdd").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			if(uniqeValidation()){
				var nwidth = 1000;
				var nheight = 600;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
				var rs = window.open( "popUpUscJobCreateAdd.do?p_project_no="+$("#p_project_no").val(), "jobAdd", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
			}
		});
		
		//Search 버튼 클릭 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			fn_search(); 
		});

		//Excel EXPORT 버튼 클릭 시 
		$("#btnExport").click(function(){
			fn_downloadStart();
			fn_excelDownload();	
		});
		
		//BOM 버튼 클릭 시
		$("#btnBom").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			 if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			var nwidth = 1000;
			var nheight = 600;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
			var rs = window.open( "popUpUscJobCreateBom.do", "jobBom", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
		});
		
		//Delete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			for(var i=0; i<row_id.length; i++) {
				var item = jqGridObj.jqGrid('getRowData', row_id[i]);
				var eco_date = item.eco_date;
				var dept = item.dwgdeptnm;
				var ssc_bom_qty = item.ssc_bom_qty;
				var state_flag = item.state_flag;
				
				if(dept != $("#p_dept_nm").val()) {
					alert("해당 부서만 삭제 가능합니다.");
					return;
				}

				//if(eco_date == "" || eco_date == undefined) {
				if(ssc_bom_qty != "" && ssc_bom_qty != "0") {
					alert("BOM이 존재할 경우 삭제할 수 없습니다.");
					return;
				}		
				
				//if(eco_date == "" || eco_date == undefined) {
				if(state_flag == "D") {
					alert("해당데이터는 삭제할 수 없습니다.");
					return;
				}	
			}
			
			if(confirm("삭제 하시겠습니까?")) {
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid('getRowData', row_id[i]);
					jqGridObj.jqGrid('setCell', row_id[i], 'state_flag', 'D');
					jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'U');
				}
				
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'deleteUscJobCreate.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						} else {
							var rows = jqGridObj.getDataIDs();
							for( var i = 0; i < rows.length; i++ ) {
								jqGridObj.jqGrid('setCell', row_id[i], 'oper', null);
							}
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}).always( function() {
				    	lodingBox.remove();	
					});
				});
			}
		});		
		
		//Restore 버튼 클릭 시 
		$("#btnRestore").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				if(item.eco_no != "") {
					alert("ECO Cancel 후에 Restore 하십시오.");
					return false;
				}
				
				if( item.eco_date != '' && item.eco_date != undefined  ) {
					alert("선택한 Data는 Restore 대상이 아닙니다.");
					return false;
				}
				
				//아이템 체크 Validation				
				if(item.state_flag == "" ){
					alert("선택한 Data는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
				
				//아이템 체크 Validation				
				if(item.state_flag == "A" ){
					alert("State 'A'는 Restore 대상이 아닙니다.");			
					rtn = false;
					return false;
				}
			}
			
			if(confirm("Restore 하시겠습니까?")){
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid('getRowData', row_id[i]);
					jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'U');
				}
				
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'restoreUscJobCreate.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						} else {
							var rows = jqGridObj.getDataIDs();
							for( var i = 0; i < rows.length; i++ ) {
								jqGridObj.jqGrid('setCell', row_id[i], 'oper', null);
							}
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}).always( function() {
				    	lodingBox.remove();	
					});
				});
			}
		});
		
		//Cancel 버튼 클릭 시 
		$("#btnCancel").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			for(var i=0; i<row_id.length; i++){
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
				
				//아이템 체크 Validation				
				if(item.state_flag == "" && item.eco_no == "" ){
					alert("선택한 Data는 복구 할 수 없습니다.");			
					rtn = false;
					return false;
				}
			}
			
			if(confirm("Cancel 하시겠습니까?")){
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid('getRowData', row_id[i]);
					jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'U');
				}
				
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'cancelUscJobCreate.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						} else {
							var rows = jqGridObj.getDataIDs();
							for( var i = 0; i < rows.length; i++ ) {
								jqGridObj.jqGrid('setCell', row_id[i], 'oper', null);
							}
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}).always( function() {
				    	lodingBox.remove();	
					});
				});
			}
		});
		
	});	

	function fn_search() {
		// TODO
		if(uniqeValidation()){
			//시리즈 배열 받음
			var ar_series = new Array();
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());

			var sUrl = "uscJobCreateList.do?p_chk_series="+ar_series;
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
	}
		
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
	}
	
	//체크 유무 validation
	var isChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".required").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}
	
	//엑셀 다운로드 화면 호출
	function fn_excelDownload() {
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		var cn = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colNames" );
		var cm = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colModel" );
		
		//시리즈 배열 받음
		var ar_series = new Array();
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		for(var i=1; i<cm.length; i++ ){
			
			if(cm[i]['hidden'] == false) {
				colName.push(cn[i]);
				dataName.push(cm[i]['index']);	
			}
		}
		$( '#p_col_name' ).val(colName);
		$( '#p_data_name' ).val(dataName);
		var f    = document.application_form;
		f.action = "uscJobCreateExcelExport.do?p_chk_series="+ar_series;
		f.method = "post";
		f.submit();
	}
	
	var DeptOnChange = function(obj){
    	$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
    	$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
    }
	
	var UserOnChange = function(obj){
    	$("input[name=p_user_id]").val($(obj).find("option:selected").val());
    	$("input[name=p_user_name]").val($(obj).find("option:selected").text());
    }
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	var getDwgNos = function(){
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			
			form = $('#application_form');
	
			getAjaxTextPost(null, "sscAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
		}
	}
	//도면번호 받아온 후
	var getdwgnoCallback = function(txt){
		var arr_txt = txt.split("|");
	    $("#p_dwg_no").autocomplete({
			source: arr_txt,
			minLength:1,
			matchContains: true, 
			max: 30,
			autoFocus: true,
			selectFirst: true,
			open: function () {
				$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function () {
			    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
		    }
		});
	}

</script>
</body>
</html>
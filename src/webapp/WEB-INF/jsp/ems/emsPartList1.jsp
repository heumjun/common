<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>Part List</title>
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
		<input type="hidden" id="p_partlist_s" name="p_partlist_s"/>
		<input type="hidden" id="temp_project_no" name="temp_project_no" value="" />
		<div class="subtitle">
		Part List
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="220"/>
			<col width="70"/>
			<col width="80"/>
			<col width="60"/>
			<col width="120"/>
			<col width="50"/>
			<col width="80"/>
			<col width="80"/>
			<col width="120"/>
			<col width="*"/>
			<tr>
				<th>Project</th>
				<td>
					<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:60px;" value="" onblur="javascript:getDwgNos();"  />
				</td>
				<th>DWG NO</th>
				<td>
					<input type="text" id="p_dwg_no" name="p_dwg_no" alt="DWG No." style="width:60px;" value="" onblur="javascript:getMaker();"  />
				</td>
				<th>MAKER</th>
				<td>
					<select name="p_maker" id="p_maker" style="width:200px;">
						<option value="%">ALL</option>
					</select>
				</td>
				<th>MAKER NO</th>
				<td>
					<input type="text" id="p_maker_no" name="p_maker_no" alt="MAKER No." style="width:60px;" />
				</td>
				<th>M_DESC</th>
				<td>
					<input type="text" id="p_m_desc" name="p_m_desc" style="width:100px;" />
				</td>		
				<th>구분</th>
				<td>
					<select name="p_status" style="width:60px;">
						<option value="%" selected="selected">ALL</option>
						<option value="CODE">CODE</option>
						<option value="YARD">YARD</option>
						<option value="MAKER">MAKER</option>
					</select>
				</td>		
				<th>ITEM CODE</th>
				<td>
					<input type="text" id="p_item_code" name="p_item_code" style="width:100px;" />
				</td>				
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_red2" value="P_COPY" id="btnProCopy"/>
						&nbsp;&nbsp;&nbsp;
						<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
						<input type="button" class="btn_blue2" value="SAVE" id="btnSave"/>
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
					</div>
				</td>	
			</tr>
		</table>
		<table class="searchArea2">
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="60"/>
			<col width="60"/>
			<col width="60"/>
			<col width="60"/>
			<col width="*"/>
			<tr>
				<th>BLOCK</th>
				<td>
					 <input type="text" name="p_block_no" value="" style="width:60px;"  />
				</td>
				<th>STAGE</th>
				<td>
					 <input type="text" name="p_stage" value="" style="width:60px;"  />
				</td>
				<th>STR</th>
				<td>
					 <input type="text" name="p_str_flag" value="" style="width:60px;"  />
				</td>
				<th>TYPE</th>
				<td>
					 <input type="text" name="p_job_type" value="" style="width:60px;"  />
				</td>				
				<th>BOM</th>
				<td>
					<select name="p_bom">
						<option value="%" selected="selected">ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>
				<th>MOTHER</th>
				<td>
					<select name="p_mother_code">
						<option value="%" selected="selected">ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>
				<th>JOB</th>
				<td>
					<select name="p_job_code">
						<option value="%" selected="selected">ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_red2" value="SSC" id="btnSsc"/>
						&nbsp;&nbsp;&nbsp;
						<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
						<input type="button" class="btn_blue2" value="EXPORT" id="btnExport"/>
						<input type="button" class="btn_blue2" value="IMPORT" id="btnImport"/>
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
		<div id="center" class="content">
			<div id="mainGrid" style="float: left; width: 70%;">
				<table id="jqGridMainList"></table>
				<div id="bottomJqGridMainList"></div>
			</div>
			<div id="subGrid" style="float: right; width: 29%; max-width: 29%;" >
				<table id="jqGridSubList"></table>
				<div id="bottomJqGridSubList"></div>
			</div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var idRow1;
	var idCol1;
	var kRow1;
	var kCol1;
	var resultData = [];
	var resultData1 = [];
	
	var jqGridObj = $("#jqGridMainList");	
	var jqGridObj1 = $("#jqGridSubList");
	
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
					{label:'PROJECT'	, name : 'project_no'	, index : 'project_no'	, width : 70, editable : true, align : "center",  
						 editoptions: { 
							 dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setMakerGrid(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setMakerGrid(rowId);						                    
						                }
					                }
					            }]
							 }},
					{label:'DWG_NO'		, name : 'dwg_no'		, index : 'dwg_no'		, width : 70, editable : true, align : "center",  
						 editoptions: { 
							 dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setMakerGrid(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setMakerGrid(rowId);						                    
						                }
					                }
					            }]
							 }},
					//{label:'MAKER'		, name : 'maker'		, index : 'maker'		, width : 150, editable : false, align : "left"},
					{label:'MAKER'		, name : 'maker'		, index : 'maker'		, width : 150, editable : true,  align : "left", edittype : "select",   
						 editoptions: {
							 dataUrl: function(){
						 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
				             	var url = "infoMakerObj.do?p_chk_series="+item.project_no+"&p_dwgNo="+item.dwg_no;
				 				return url;
						 	},
				   		 	buildSelect: function(data){
				      		 	if(typeof(data)=='string'){
				      		 		data = $.parseJSON(data);
				      		 	}
				      		 	
				       		 	var rtSlt = '<select name="deptid">';
				       		 	
				       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
									if(data.length == 2 && data[idx].maker != " "){
										rtSlt +='<option value="'+data[idx].maker+'">'+data[idx].maker+'</option>';	
					       		 	}else{
					       		 		rtSlt +='<option value="'+data[idx].maker+'">'+data[idx].maker+'</option>';
					       		 	}
				       		 	}
					       		rtSlt +='</select>';
					       		
					       		return rtSlt;
				   		 	}
						 }},
					{label:'MAKER_NO'	, name : 'maker_no'		, index : 'maker_no'	, width : 80, editable : true, align : "center"},
					{label:'M_DESC.'	, name : 'maker_desc'	, index : 'maker_desc'	, width : 150, editable : true, align : "left"},
					{label:'EA'			, name : 'ea'			, index : 'ea'			, width : 30, editable : true, align : "right"},
					{label:'WEIGHT'		, name : 'weight'		, index : 'weight'		, width : 50, editable : true, align : "right"},
					{label:'구분'			, name : 'partlist_type', index : 'partlist_type', width : 65, editable : true, align : "center",
							edittype : 'select', editoptions:{value:"CODE:CODE;YARD:YARD;MAKER:MAKER",
								dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                   
					                    setItemCode(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    
						                    setItemCode(rowId);
						                }
					                }
					            }]}},
					{label:'ITEM CODE'	, name : 'item_code'	, index : 'item_code'	, width : 100, editable : true, align : "center"},					
					{label:'DATE'   	, name : 'create_date'	, index : 'create_date' , width : 80, editable : false, align : "center"},
					{label:'DEPT'		, name : 'dept_name'	, index : 'dept_name'	, width : 100, editable : false, align : "left"},
					{label:'USER'		, name : 'create_name'	, index : 'create_name'	, width : 80, editable : false, align : "center"},
					{label:'COMMENT'   	, name : 'comments'		, index : 'comments'		, width : 100, editable : true, align : "left"},
					{label:'PARTLIST_S'	, name : 'part_list_s'	, index : 'part_list_s'	, width : 100, editable : false, align : "center", hidden:true},
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
				var rows = jqGridObj.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = jqGridObj.getCell( rows[i], "oper" );
					var type = jqGridObj.getCell( rows[i], "partlist_type" );	
					
					jqGridObj.jqGrid( 'setCell', rows[i], 'create_date', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'dept_name', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'create_name', '', { color : 'black', background : '#DADADA' } );	

					if(oper != 'I'){
						if(type == 'CODE') {
							jqGridObj.jqGrid( 'setCell', rows[i], 'item_code', '', '');					
						} else {
							jqGridObj.jqGrid( 'setCell', rows[i], 'item_code', '', { color : 'black', background : '#DADADA' } );	
							jqGridObj.jqGrid( 'setCell', rows[i], 'item_code', '', 'not-editable-cell' );
						}
					}
					
					
					/* if(oper != 'I'){
						jqGridObj.jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'project_no', '', 'not-editable-cell' );
						jqGridObj.jqGrid( 'setCell', rows[i], 'dwg_no', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'dwg_no', '', 'not-editable-cell' );
						jqGridObj.jqGrid( 'setCell', rows[i], 'partlist_type', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'partlist_type', '', 'not-editable-cell' );
						jqGridObj.jqGrid( 'setCell', rows[i], 'ea', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'ea', '', 'not-editable-cell' );
					} else {
						jqGridObj.setColProp('partlist_type', { editable : true, edittype : 'select', editoptions:{value:"YARD:YARD;MAKER:MAKER" }});
					} */
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj1.jqGrid("clearGridData");
				var item = $(this).jqGrid( 'getRowData', rowid );
				
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				
				if(item.oper != 'I') {				
					var project_no    = item.project_no;
					var partlist_type = item.partlist_type;
					var item_code     = item.item_code;		 
				    var part_list_s   = item.part_list_s;	
				    
				    jqGridObj1.jqGrid( "clearGridData" );
					jqGridObj1.jqGrid( 'setGridParam', {
						url : "emsPartList1SubList.do?p_projectNo="+project_no+"&p_partlist_type="+partlist_type+"&p_part_list_s="+part_list_s+"&p_item_cd="+item_code,
						mtype : 'POST',
						datatype : 'json',
						page : 1,
						postData : fn_getFormData( "#application_form" )
					} ).trigger( "reloadGrid" );
					
					$("#p_partlist_s").val(part_list_s);
					
					$("#jqGridSubList").jqGrid('navGrid',"#bottomJqGridSubList",{refresh:false,search:false,edit:false,add:false,del:false});
					if(partlist_type != 'YARD') {
						// 그리드 Row 추가 함수 설정
			    	 	$("#jqGridSubList").navButtonAdd('#bottomJqGridSubList',
			    				{ 	caption:"", 
			    					buttonicon:"ui-icon-plus", 
			    					onClickButton: addRow,
			    					position: "first", 
			    					title:"Add", 
			    					cursor: "pointer",
			    					id:"gridAddBtn"
			    				} 
			    		);
			    	    // 그리드 Row 추가 함수 설정
			    	 	$("#jqGridSubList").navButtonAdd('#bottomJqGridSubList',
			    				{ 	caption:"", 
			    					buttonicon:"ui-icon-minus", 
			    					onClickButton: delRow,
			    					position: "first", 
			    					title:"Del", 
			    					cursor: "pointer",
			    					id:"gridDelBtn"
			    				} 
			    		);
			    	    
			    	 	$("#jqGridSubList").setColProp('block_no', { editable : true});
			    	 	$("#jqGridSubList").setColProp('stage_no', { editable : true});
			    	 	$("#jqGridSubList").setColProp('str_flag', { editable : true});
			    	 	$("#jqGridSubList").setColProp('usc_job_type', { editable : true});
			    	 	$("#jqGridSubList").setColProp('ea', { editable : true});
			    	 	$("#jqGridSubList").setColProp('mother_code', { editable : true});
					} else {
						$("#gridAddBtn").remove();
						$("#gridDelBtn").remove();
						
						$("#jqGridSubList").setColProp('block_no', { editable : false});
			    	 	$("#jqGridSubList").setColProp('stage_no', { editable : false});
			    	 	$("#jqGridSubList").setColProp('str_flag', { editable : false});
			    	 	$("#jqGridSubList").setColProp('usc_job_type', { editable : false});
			    	 	$("#jqGridSubList").setColProp('ea', { editable : false});
			    	 	$("#jqGridSubList").setColProp('mother_code', { editable : false});
					}
				}
			},
			ondblClickRow : function(rowid, cellname, value, iRow, iCol) {
				
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	
     	jqGridObj1.jqGrid({ 
            datatype: 'json',
            url:'',
            mtype : '',
            postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'BLOCK'		, name : 'block_no'		, index : 'block_no'	, width : 50, editable : true, align : "center",  
						 editoptions: { 
							 dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setStrFlag(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setStrFlag(rowId);
						                }
					                }
					            }]
							 }},
					{label:'STAGE'		, name : 'stage_no'		, index : 'stage_no'	, width : 50, editable : true, align : "center"},
					{label:'STR'		, name : 'str_flag'		, index : 'str_flag'	, width : 50, editable : true, align : "center", edittype : "select", 
							editoptions: {
								 dataUrl: function(){
							 		var item = jqGridObj1.jqGrid( 'getRowData', idRow1 );
					             	var url = "infoPartListStrFlag.do?p_projectNo="+item.project_no+"&p_blockNo="+item.block_no;
					 				return url;
							 	 },
					   		 	 buildSelect: function(data){
					      		 	if(typeof(data)=='string'){
					      		 		data = $.parseJSON(data);
					      		 	}
					      		 	
					       		 	var rtSlt = '<select name="deptid1">';
					       		 	
						       		if(data.length > 1) {
						       		 	rtSlt +='<option value="선택">선택</option>';
						       		}
					       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
										if(data.length == 2 && data[idx].str_flag != " "){
											rtSlt +='<option value="'+data[idx].str_flag+'">'+data[idx].str_flag+'</option>';	
						       		 	}else{
						       		 		rtSlt +='<option value="'+data[idx].str_flag+'">'+data[idx].str_flag+'</option>';
						       		 	}
					       		 	}
						       		rtSlt +='</select>';
						       		
						       		return rtSlt;
					   		 	}, 
							 	dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setJobType(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setJobType(rowId);
						                }
					                }
					            }]
							 }},
					{label:'TYPE'		, name : 'usc_job_type'	, index : 'usc_job_type', width : 50, editable : true, align : "center", edittype : "select",  
						 editoptions: { 
							 dataUrl: function(){
						 		var item = jqGridObj1.jqGrid( 'getRowData', idRow1 );
				             	var url = "infoPartListJobType.do?p_projectNo="+item.project_no+"&p_blockNo="+item.block_no+"&p_strFlag="+item.str_flag;
				 				return url;
						 	 },
				   		 	 buildSelect: function(data){
				      		 	if(typeof(data)=='string'){
				      		 		data = $.parseJSON(data);
				      		 	}
				      		 	
				       		 	var rtSlt = '<select name="deptid2">';
				       		 	
				       		 	if(data.length > 1) {
					       		 	rtSlt +='<option value="선택">선택</option>';
					       		}
				       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
									if(data.length == 2 && data[idx].usc_job_type != " "){
										rtSlt +='<option value="'+data[idx].usc_job_type+'">'+data[idx].usc_job_type+'</option>';	
					       		 	}else{
					       		 		rtSlt +='<option value="'+data[idx].usc_job_type+'">'+data[idx].usc_job_type+'</option>';
					       		 	}
				       		 	}
					       		rtSlt +='</select>';
					       		
					       		return rtSlt;
				   		 	 },
							 dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setJobCode(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setJobCode(rowId);						                    
						                }
					                }
					            }]
							 }},
					{label:'EA'			, name : 'ea'			, index : 'ea'			, width : 30,  editable : true, align : "right"},					
					{label:'MOTHER'		, name : 'mother_code'	, index : 'mother_code'	, width : 100, editable : true, align : "center"},
					{label:'JOB ITEM'	, name : 'job_code'		, index : 'job_code'	, width : 100, editable : false, align : "center"},
					{label:'DIFF'		, name : 'diff'			, index : 'diff'		, width : 40,  editable : false, align : "center"},
					{label:'PROJECT_NO' , name : 'project_no'	, index : 'project_no'	, width : 100, editable : false, align : "center", hidden:true},
					{label:'PART_LIST_S', name : 'part_list_s'	, index : 'part_list_s'	, width : 100, editable : false, align : "center", hidden:true},					
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
            pager: '#bottomJqGridSubList',
            rowList:[100,500,1000],
	         rowNum:100, 
	         recordtext: '내용 {0} - {1}, 전체 {2}',
       	 	emptyrecords:'조회 내역 없음',
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	idRow1 = rowid;
            	idCol1 = iCol;
            	kRow1  = iRow;
            	kCol1  = iCol;
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
				var rows = jqGridObj1.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = jqGridObj1.getCell( rows[i], "oper" );	
					
					jqGridObj1.jqGrid( 'setCell', rows[i], 'job_code', '', { color : 'black', background : '#DADADA' } );
					jqGridObj1.jqGrid( 'setCell', rows[i], 'diff', '', { color : 'black', background : '#DADADA' } );
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				
			},
			ondblClickRow : function(rowid, cellname, value, iRow, iCol) {
				
			},
			afterSaveCell : chmResultEditEnd1
    	}); //end of jqGrid

     	//grid resize
	    fn_insideGridresize( $(window), $( "#mainGrid" ), jqGridObj, 90 );
	    fn_insideGridresize( $(window), $( "#subGrid" ), jqGridObj1, 90 );
     	
	    //project 변경 시
		$("#p_project_no").change(function(){
			jqGridObj.jqGrid("clearGridData");
			jqGridObj1.jqGrid("clearGridData");
			
			setMakerList();
		});
	    
		//DWG No 변경 시
		$("#p_dwg_no").change(function(){
			setMakerList();
		});		
		
		//BLOCK 버튼 클릭 시
		$("#btnProCopy").click(function(){
			jqGridObj.saveCell(kRow, idCol );
			fn_copy();			
		});
		
		//SSC 버튼 클릭 시
		$("#btnSsc").click(function(){
			jqGridObj.saveCell(kRow, idCol );
			fn_ssc();
		});
		
		//Add 버튼 클릭 시 
		$("#btnAdd").click(function(){
			jqGridObj1.jqGrid("clearGridData");
			
			var item = {};
	 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
	 		for(var i in colModel) item[colModel[i].name] = '';
	 		item.oper = 'I';
	 		jqGridObj.resetSelection();
	 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
		});
		
		//Delete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			if( idRow == 0 ) {
				return;
			}
			
	 		jqGridObj.saveCell( kRow, kCol );

			var selrow = jqGridObj.jqGrid('getGridParam', 'selrow');
			var item = jqGridObj.jqGrid('getRowData', selrow);

			if ( item.oper == 'I' ) {
				jqGridObj.jqGrid( 'delRowData', selrow );
			} else {
				//alert( '저장된 데이터는 삭제할 수 없습니다.' );
				fn_delete();
			}
			
			jqGridObj.resetSelection();
		});
		
		//Save 버튼 클릭 시 
		$("#btnSave").click(function(){
			jqGridObj.saveCell(kRow, idCol );
			fn_save();			
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
		
		//Excel EXPORT 버튼 클릭 시 
		$("#btnImport").click(function(){
			alert("준비중");
		});
		
	});	
	
	// Add 버튼 
 	function addRow(item) { 		
 		jqGridObj.saveCell( kRow, kCol ); 		
 		
 		var item = {};
 		var colModel = jqGridObj1.jqGrid('getGridParam', 'colModel');
 		for(var i in colModel) item[colModel[i].name] = '';
 		
 		var selrow = jqGridObj.jqGrid('getGridParam', 'selrow');
		var main_item = jqGridObj.jqGrid('getRowData', selrow);		
 		
 		item.oper = 'I';
 		item.project_no = main_item.project_no;
 		item.part_list_s = main_item.part_list_s;
 		jqGridObj1.resetSelection();
 		jqGridObj1.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
 	}
 	// Del 버튼 
 	function delRow(item) {
 		//if( idRow1 == 0 ) {
		//	return;
		//}
		
 		jqGridObj1.saveCell( kRow1, kCol1 );

		//var selrow = jqGridObj1.jqGrid('getGridParam', 'selrow');
		//var item = jqGridObj1.jqGrid('getRowData', selrow);
		
 		//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
		var row_id1 = jqGridObj1.jqGrid('getGridParam', 'selarrrow');
		var row_len = row_id1.length;					
		//I 인것들은 바로 없앰
		for(var i=0; i<row_len; i++){
			var item = jqGridObj1.jqGrid( 'getRowData', row_id1[0]);					
			jqGridObj1.jqGrid('delRowData',row_id1[0]);						
		}
		//I가 아닌 것들을 다시 row_id 구해서 'D' 값 처리
		row_id1 = jqGridObj1.jqGrid('getGridParam', 'selarrrow');
		
		for(var i=0; i<row_id1.length; i++){								
			jqGridObj1.jqGrid('delRowData',row_id1[i]);								
		}

		//if ( item.oper == 'I' ) {
		//jqGridObj1.jqGrid( 'delRowData', selrow );
		//} else {
		//	alert( '저장된 데이터는 삭제할 수 없습니다.' );
		//}
		
		jqGridObj1.resetSelection();
 	}

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
			
			var sUrl = "emsPartList1MainList.do?p_chk_series="+ar_series;
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj1.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				rowNum : jqGridObj.jqGrid('getGridParam', 'rowNum'),
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
	}	
	
	//저장 버튼
	function fn_save(){
		jqGridObj.saveCell( kRow, idCol );
		jqGridObj1.saveCell( kRow1, idCol1 );
		
		if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
			var chmResultRows = [];
			var chmResultRows1 = [];
			
			var selrow = jqGridObj1.jqGrid('getGridParam', 'selrow');
			var item = jqGridObj1.jqGrid('getRowData', selrow);
			
			var row_main = jqGridObj.getDataIDs();
			var row_all = jqGridObj1.getDataIDs();
			var partListS = "";
			var cnt = 0;
			var ea_cnt_t = 0;

			for(var i = 0; i < row_all.length; i++) {
				partListS = jqGridObj1.jqGrid('getCell', row_all[i], 'part_list_s');
				var ea_cnt = Number(jqGridObj1.jqGrid('getCell', row_all[i], 'ea'));
				if(partListS != '' && partListS != undefined) {
					cnt++;
				}
				ea_cnt_t = ea_cnt_t + ea_cnt;
			}
			
			if(cnt > 0) {
				for(var i = 0; i < row_main.length; i++) {
					var m_item = jqGridObj.jqGrid('getRowData', row_main[i]);
					if(partListS == m_item.part_list_s) {
						if(Number(ea_cnt_t) > Number(m_item.ea)) {							
							alert("BOM 정보의 EA 합계는 PARTLIST의 EA 수량을 초과할 수 없습니다.");
							return;
						}
					}
				}
				for(var i = 0; i < row_all.length; i++) {
					jqGridObj1.jqGrid('setCell', row_all[i], 'oper', 'U');
				}
			}
			
			getChangedChmResultData1( function( data ) {
				chmResultRows1 = data;
			} );

			//변경된 row만 가져 오기 위한 함수
			getChangedChmResultData( function( data ) {
				/* for(var i = 0; i < data.length; i++) {
					if(data[i].maker == '' || data[i].maker == undefined) {
						alert("MAKER를 선택하십시오.");
						return;
					}
				} */
				
				$( '#jqGridMainList' ).saveCell( kRow, idCol );
				$( '#jqGridSubList' ).saveCell( kRow1, idCol1 );
				
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				chmResultRows = data;
				var dataList = { chmResultList : JSON.stringify( chmResultRows ), chmResultList1 : JSON.stringify( chmResultRows1 ) };
				var url = 'savePartList1MainList.do';
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend( {}, dataList, formData); 
				
				$.post( url, parameters, function( data ) {
					alert(data.resultMsg);
					if ( data.result == 'success' ) {
						fn_search();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	lodingBox.remove();	
				} );
			} );
		}
	}
	
	function fn_copy(){
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(row_id == ""){
			alert("행을 선택하십시오.");
			return;
		}	
		
		for(var i=0; i<row_id.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
			if(item.oper == "I") {
				alert("작성중인 데이터는 적용할 수 없습니다.");
				return;
			}
		}
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
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
		
		if(uniqeValidation()){
			var rs = window.showModalDialog( "popUpPartListCopy.do?p_chk_series="+ar_series, window, "dialogWidth:500px; dialogHeight:500px; center:on; scroll:off; status:off" );
		}
	}
	
	function fn_ssc(){
		jqGridObj.saveCell( kRow, idCol );
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(row_id == ""){
			alert("행을 선택하십시오.");
			return;
		}

		var jsonGridData = [];
		for(var i=0; i<row_id.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
			if(item.oper == "I") {
				alert("작성중인 데이터는 적용할 수 없습니다.");
				return;
			} else if(item.partlist_type != "CODE") {
				alert("PARTLIST TYPE이 CODE인 데이터만 적용 가능합니다.");
				return;
			}
			jsonGridData.push({item_code : item.item_code
							 , projectNo : item.project_no
         			 		 , part_list_s : item.part_list_s});
						
		}	
		
		if ( confirm( 'SSC 적용하시겠습니까?' ) != 0 ) {
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
	
			var dataList = { chmResultList : JSON.stringify( jsonGridData ) };
			var url = 'savePartListSsc.do';
			var formData = fn_getFormData('#application_form');
			//객체를 합치기. dataList를 기준으로 formData를 합친다.
			var parameters = $.extend( {}, dataList, formData); 
			
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			}).always( function() {
		    	lodingBox.remove();	
			});
		}
	}
	
	function fn_delete() {
		jqGridObj.saveCell( kRow, idCol );
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(row_id == ""){
			alert("행을 선택하십시오.");
			return;
		}

		var jsonGridData = [];
		for(var i=0; i<row_id.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
			if(item.oper == "I") {
				alert("작성중인 데이터는 삭제할 수 없습니다.");
				return;
			}
			jsonGridData.push({part_list_s : item.part_list_s});
						
		}	
		
		if ( confirm( '해당 데이터의 BOM 정보까지 모두 삭제됩니다. 진행하시겠습니까?' ) != 0 ) {
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
	
			var dataList = { chmResultList : JSON.stringify( jsonGridData ) };
			var url = 'deletePartList.do';
			var formData = fn_getFormData('#application_form');
			//객체를 합치기. dataList를 기준으로 formData를 합친다.
			var parameters = $.extend( {}, dataList, formData); 
			
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			}).always( function() {
		    	lodingBox.remove();	
			});
		}
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
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}	
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd1( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj1.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj1.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj1.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData1( callback ) {
		var changedData = $.grep( $( "#jqGridSubList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U';
		} );
		
		callback.apply( this, [ changedData.concat(resultData1) ] );
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
		
		colName.push("BLOCK_NO");colName.push("STAGE");colName.push("STR");colName.push("TYPE");colName.push("EA");colName.push("MOTHER");colName.push("JOB");
		dataName.push("BLOCK_NO");dataName.push("STAGE_NO");dataName.push("STR_FLAG");dataName.push("USC_JOB_TYPE");dataName.push("BOM_QTY");dataName.push("MOTHER_CODE");dataName.push("JOB_CODE");
		
		$( '#p_col_name' ).val(colName);
		$( '#p_data_name' ).val(dataName);
		var f    = document.application_form;
		f.action = "emsPartList1ExcelList.do?p_chk_series="+ar_series;
		f.method = "post";
		f.submit();
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
			
			getMaker();
		}
	}
	
	var getMaker = function(){
		if($("input[name=p_project_no]").val() != "" && $("input[name=p_dwg_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
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
	
	function setMakerList() {
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		var projectNo = $("#p_project_no").val();
		var dwgNo = $("#p_dwg_no").val();
		
		if(dwgNo == undefined) {
			dwgNo = "";
		}
		
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
		
		if(ar_series.length > 0){
			$.post( "infoMakerList.do?p_chk_series="+ar_series+"&p_dwgNo="+dwgNo, "", function( data ) {
				$("#p_maker").children().remove();
				$("#p_maker").append("<option value='%'>ALL</option>");
				for (var i in data ){
					if(data[i] != null) {						
	     				$("#p_maker").append("<option value='"+data[i].maker+"'>"+data[i].maker+"</option>");
					}
	     		}
			}, "json" );
		}
	}
	
	function setMakerGrid(rowId){		
		jqGridObj.saveCell(kRow, idCol );
		var item = jqGridObj.jqGrid( 'getRowData', rowId );

		if(item.project_no != '' && item.project_no != undefined && item.dwg_no != '' && item.dwg_no != undefined && item.dwg_no.length == 8) {
			$.ajax({
				url : "infoMakerObj.do?p_chk_series="+item.project_no+"&p_dwgNo="+item.dwg_no,
				async : false,
				cache : false, 
				dataType : "json",
				success : function(data){
					if(data.length == 0){
						jqGridObj.jqGrid('setCell', rowId, 'maker', '&nbsp;');
					} else {
						jqGridObj.jqGrid('setCell', rowId, 'maker', data[0].maker);
						if(jqGridObj.jqGrid('getCell', rowId, 'oper') != 'I') {
							jqGridObj.jqGrid('setCell', rowId, 'oper', 'U');
						}
					}
				}
			});
		}		
	}
	
	function setItemCode(rowId){		
		jqGridObj.saveCell(kRow, idCol );
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
		
		var cells = $("tbody > tr.jqgrow > td:nth-child(10)", jqGridObj);
		var cell = $(cells[0]);

		if(item.partlist_type == 'CODE') {
			jqGridObj.jqGrid( 'setCell', rowId, 'item_code', '', { color : 'black', background : '#FFFFFF' } );
			cell.removeClass('not-editable-cell');
		} else {
			jqGridObj.jqGrid( 'setCell', rowId, 'item_code', '', { color : 'black', background : '#DADADA' } );
			cell.addClass('not-editable-cell');
		}
	}
	
	function setStrFlag(rowId){		
		jqGridObj1.saveCell(kRow1, idCol1 );
		var item = jqGridObj1.jqGrid( 'getRowData', rowId );

		if(item.project_no != '' && item.project_no != undefined && item.block_no != '' && item.block_no != undefined) {
			$.ajax({
				url : "infoPartListStrFlag.do?p_projectNo="+item.project_no+"&p_blockNo="+item.block_no,
				async : false,
				cache : false, 
				dataType : "json",
				success : function(data){
					if(data.length == 0){
						jqGridObj1.jqGrid('setCell', rowId, 'str_flag', '&nbsp;');
					} else {
						if(data.length == 1) {
							jqGridObj1.jqGrid('setCell', rowId, 'str_flag', data[0].str_flag);
						} else {
							jqGridObj1.jqGrid('setCell', rowId, 'str_flag', '선택');
						}
					}
					setJobType(rowId);
				}
			});
		}		
	}
	
	function setJobType(rowId){		
		jqGridObj1.saveCell(kRow1, idCol1 );
		var item = jqGridObj1.jqGrid( 'getRowData', rowId );

		if(item.project_no != '' && item.project_no != undefined && item.block_no != '' && item.block_no != undefined && item.str_flag != '' && item.str_flag != undefined) {
			$.ajax({
				url : "infoPartListJobType.do?p_projectNo="+item.project_no+"&p_blockNo="+item.block_no+"&p_strFlag="+item.str_flag,
				async : false,
				cache : false, 
				dataType : "json",
				success : function(data){
					if(data.length == 0){
						jqGridObj1.jqGrid('setCell', rowId, 'usc_job_type', '&nbsp;');
					} else {
						if(data.length == 1) {
							jqGridObj1.jqGrid('setCell', rowId, 'usc_job_type', data[0].usc_job_type);
						} else {
							jqGridObj1.jqGrid('setCell', rowId, 'usc_job_type', '선택');
						}
					}
					setJobCode(rowId);
				}
			});
		}		
	}
	
	function setJobCode(rowId){		
		jqGridObj1.saveCell(kRow1, idCol1 );
		var item = jqGridObj1.jqGrid( 'getRowData', rowId );

		if(item.block_no != '' && item.block_no != undefined && item.str_flag != '' && item.str_flag != undefined && item.usc_job_type != '' && item.usc_job_type != undefined) {
			$.ajax({
				url : "infoJobCode.do?p_blockNo="+item.block_no+"&p_strFlag="+item.str_flag+"&p_uscJobType="+item.usc_job_type+"&p_projectNo="+item.project_no,
				async : false,
				cache : false, 
				dataType : "json",
				success : function(data){
					if(data.length == 0){
						jqGridObj1.jqGrid('setCell', rowId, 'job_code', '&nbsp;');
					} else {
						jqGridObj1.jqGrid('setCell', rowId, 'job_code', data[0].mother_code);					
					}
				}
			});
		}		
	}
	
	function cellItemCodeChangeAction(irow, cellName, cellValue, rowIdx){
		
	}

</script>
</body>
</html>
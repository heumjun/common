<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>JOB CREATE ADD</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<input type="hidden" id="p_dept_name" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"/>
		<input type="hidden" id="p_user_name" name="p_user_name" value="<c:out value="${loginUser.user_name}" />"/>
		<input type="hidden" id="p_master_no" name="p_master_no" value="${p_master_no}"/>
		<input type="hidden" id="p_job_pop" name="p_job_pop" value="Y"/>
		<div class="subtitle">
		JOB CREATE ADD<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="90"/>
			<col width="*"/>
			<tr>
				<th>Project</th>
				<td>
					<input type="text" class = "required" id="p_project_no" name="p_project_no" alt="Project" value="${p_project_no}" style="width:80px;" value="" />
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<!-- <input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
						<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/> -->
						<input type="button" class="btn_blue2" value="NEXT" id="btnNext"/>
						<input type="button" class="btn_blue2" value="APPLY" id="btnApply" disabled/>
					</div>
				</td>
			</tr>
		</table>
		<table class="searchArea conSearch">
			<col width="600"/>
			<col width="*"/>
			<tr>
				<td class="bdl_no"  style="border-left:none;">		
				<table>
					<tr>
						<td>
							<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
						</td>
						
					</tr>
				</table>	
				</td>	
			</tr>
		</table>	
		
		<div class="content" id="div1" style="display:block">
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
		<div class="content" id="div2" style="display:none">
			<table id="jqGridMainList1"></table>
			<div id="bottomJqGridMainList1"></div>
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
	var jqGridObj1 = $("#jqGridMainList1");
	
	$(document).ready(function(){
		getAjaxHtml($("#SeriesCheckBox"),"infoUscSeriesProjectList.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y", null);
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			colModel : [
					//{label:'STATE' 		, name : 'state_flag'	, index : 'state_flag'	, width : 70, editable : false, align : "center"},
					{label:'MASTER'	    , name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 90, editable : false, align : "center"},
					{label:'PROJECT'	, name : 'project_no'	, index : 'project_no'	, width : 70, editable : false, align : "center"},
					{label:'BLOCK'		, name : 'block_no'		, index : 'block_no'	, width : 70, editable : true, align : "center", 
						 editoptions: { 
					            dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setJobStr(rowId);
					            	}},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9"){
						            		var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setJobStr(rowId);
					            		}
					                }
					            }]
							 }},
					{label:'B_STR'		, name : 'block_str_flag'		, index : 'block_str_flag'	, width : 70, editable : true, align : "center", edittype : "select",
						 editoptions: { 
							 dataUrl: function(){
						 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
				             	var url = "infoJobCreateMoveStr.do?p_master_project_no="+item.representative_pro_num+"&p_project_no="+$("#p_project_no").val()+"&p_block_no="+item.block_no;
				 				return url;
						 	 },
				   		 	 buildSelect: function(data){
				      		 	if(typeof(data)=='string'){
				      		 		data = $.parseJSON(data);
				      		 	}					      		 	
				      		 	
				       		 	var rtSlt = '<select name="deptid">';
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
					                    setJobCreate(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9"){
						            		var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setJobCreate(rowId);
					            		}
					                }
					            }]
							 }},
					{label:'ACT CATA'   , name : 'act_code'		, index : 'act_code'	, width : 100, editable : true, align : "center", edittype : "select",
							 editoptions: { 
								 dataUrl: function(){
							 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
					             	var url = "infoJobCreateActCode.do?p_master_project_no="+item.representative_pro_num+"&p_project_no="+$("#p_project_no").val()+"&p_block_no="+item.block_no+"&p_str_flag="+item.block_str_flag;
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
										if(data.length == 2 && data[idx].act_catalog != " "){
											rtSlt +='<option value="'+data[idx].act_catalog+'">'+data[idx].act_catalog+'</option>';	
						       		 	}else{
						       		 		rtSlt +='<option value="'+data[idx].act_catalog+'">'+data[idx].act_catalog+'</option>';
						       		 	}
					       		 	}
						       		rtSlt +='</select>';						       		
						       		
						       		return rtSlt;
					   		 	 }
							 }},
					{label:'NAME(TYPE)'	, name : 'usc_job_type'	, index : 'usc_job_type'	, width : 100, editable : true, align : "center"},
					{label:'JOB CATA'	, name : 'job_code'		, index : 'job_code'		, width : 100, editable : true, align : "center", edittype : "select",
						 editoptions: { 
							 dataUrl: function(){
						 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
				             	var url = "infoJobCreateJobCode.do";
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
									if(data.length == 2 && data[idx].job_catalog != " "){
										rtSlt +='<option value="'+data[idx].job_catalog+'">'+data[idx].job_catalog+'</option>';	
					       		 	}else{
					       		 		rtSlt +='<option value="'+data[idx].job_catalog+'">'+data[idx].job_catalog+'</option>';
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
					                    setJobStr1(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9"){
						            		var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setJobStr1(rowId);
					            		}
					                }
					            }]				            
						 }},
					{label:'JOB STR'    , name : 'str_flag' , index : 'str_flag'	, width : 100, editable : false, align : "center", edittype : "select",
						 editoptions: { 
							 dataUrl: function(){
						 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
				             	var url = "infoJobCreateMoveJobStr.do?p_master_project_no="+item.representative_pro_num+"&p_project_no="+$("#p_project_no").val()+"&p_block_no="+item.block_no+"&p_block_str="+item.block_str_flag+"&p_act_catalog="+item.act_code+"&p_job_catalog="+item.job_code;
				 				return url;
						 	 },
				   		 	 buildSelect: function(data){
				      		 	if(typeof(data)=='string'){
				      		 		data = $.parseJSON(data);
				      		 	}					      		 	
				      		 	
				       		 	var rtSlt = '<select name="deptid3">';
				       		 	
				       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
									if(data.length == 2 && data[idx].str_flag != " "){
										rtSlt +='<option value="'+data[idx].str_flag+'">'+data[idx].str_flag+'</option>';	
					       		 	}else{
					       		 		rtSlt +='<option value="'+data[idx].str_flag+'">'+data[idx].str_flag+'</option>';
					       		 	}
				       		 	}
					       		rtSlt +='</select>';						       		
					       		
					       		return rtSlt;
				   		 	 }}},
					{label:'PROCESS'	, name : 'process'		, index : 'process'		, width : 200, editable : false, align : "center"},
					{label:''		    , name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true}
				],
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cmTemplate: { title: false },
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
             multiselect: true,
             pgbuttons 	: false,
			 //pgtext 	: false,
			 pginput 	: false,
             height: 370,
             pager: '#bottomJqGridMainList',
             rowNum:999999, 
	         recordtext: '전체 {2}',
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
   		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

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
					
					jqGridObj.jqGrid( 'setCell', rows[i], 'state_flag', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'representative_pro_num', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'str_flag', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'process', '', { color : 'black', background : '#DADADA' } );
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj.getRowData(rowid);
					afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	
    	// 그리드 버튼 설정
     	jqGridObj.jqGrid('navGrid',"#bottomJqGridMainList",{refresh:false,search:false,edit:false,add:false,del:false});
	
		// 그리드 Row 추가 함수 설정
	 	jqGridObj.navButtonAdd('#bottomJqGridMainList',
				{ 	caption:"", 
					buttonicon:"ui-icon-plus", 
					onClickButton: addRow,
					position: "first", 
					title:"Add", 
					cursor: "pointer"
				} 
		);
	    // 그리드 Row 추가 함수 설정
	 	jqGridObj.navButtonAdd('#bottomJqGridMainList',
				{ 	caption:"", 
					buttonicon:"ui-icon-minus", 
					onClickButton: delRow,
					position: "first", 
					title:"Del", 
					cursor: "pointer"
				} 
		);
     	
     	jqGridObj1.jqGrid({ 
            datatype: 'json',
            url:'',
            mtype : '',
            postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'MASTER'	    , name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 90, editable : false, align : "center"},
					{label:'PROJECT'	, name : 'project_no'	, index : 'project_no'	, width : 70, editable : false, align : "center"},
					{label:'BLOCK'		, name : 'block_no'		, index : 'block_no'	, width : 70, editable : false, align : "center"},
					{label:'B_STR'		, name : 'block_str_flag', index : 'block_str_flag'	, width : 70, editable : false, align : "center"},
					{label:'ACT ITEM'   , name : 'act_code'		, index : 'act_code'	, width : 100, editable : false, align : "center"},
					{label:'NAME(TYPE)'	, name : 'usc_job_type'	, index : 'usc_job_type', width : 100, editable : false, align : "center"},
					{label:'JOB ITEM'	, name : 'job_code'		, index : 'job_code'	, width : 100, editable : false, align : "center"},
					{label:'JOB STR'	, name : 'str_flag'		, index : 'str_flag'	, width : 100, editable : false, align : "center"},
					{label:'PROCESS'	, name : 'process'		, index : 'process'		, width : 200, editable : false, align : "center"},
					{label:''		    , name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true},
					{label:'error_flag'	, name : 'error_flag'	, index : 'error_flag'	, width : 100, editable : false, align : "center", hidden:true}
				],
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cmTemplate: { title: false },
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
            multiselect: true,
            pgbuttons 	: false,
			pgtext 	: false,
			pginput 	: false,
            height: 370,
            pager: '#bottomJqGridMainList1',
            rowNum:999999, 
	         recordtext: '전체 {2}',
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
  		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

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
				var row_id = $(this).getDataIDs();
				for ( var i = 0; i < row_id.length; i++ ) {
					var item = $(this).jqGrid( 'getRowData', row_id[i] );
					$(this).setCell(row_id[i], item.error_flag, '', {color : '#FFFFFF', background : 'red'});
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj1.saveCell(kRow, idCol );
				
				var cm = jqGridObj1.jqGrid('getGridParam', 'colModel');
				
				if(cm[iCol].name == 'after_info'){
					var item = jqGridObj1.getRowData(rowid);
					afterInfoClick(item.ssc_sub_id, item.level, item.item_code);
				}
			},
			afterSaveCell : chmResultEditEnd
    	}); //end of jqGrid
     	//grid resize
     	
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 0 );
	    fn_gridresize( $(window), jqGridObj1, 0 );
     	
     	var item = {};
 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
 		for(var i in colModel) item[colModel[i].name] = '';
 		item.state_flag = 'A';
 		item.oper = 'A';
 		item.representative_pro_num = $("#p_master_no").val();
 		jqGridObj.resetSelection();
 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'first');

     	// JOB_CODE 선택
     	/* $.post( "infoJobCreateJobCode.do", "", function( data ) {
     		jqGridObj.setObject( {
				value : 'job_catalog',
				text : 'job_catalog',
				name : 'job_code',
				data : data
			} );
		}, "json" ); */
     	
		//Add 버튼 클릭
		$("#btnAdd").click(function(){
			jqGridObj.saveCell(kRow, idCol );
			var row_all = jqGridObj.getDataIDs();
			for( var i = 0; i < row_all.length; i++ ) {
				jqGridObj.jqGrid('setCell', row_all[i], 'oper', 'U');
			}
			jqGridObj.saveCell(kRow, idCol );
			
			var item = {};
	 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
	 		for(var i in colModel) item[colModel[i].name] = '';
	 		item.state_flag = 'A';
	 		item.oper = 'I';
	 		item.representative_pro_num = $("#p_master_no").val();
	 		jqGridObj.resetSelection();
	 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
		});
		
		//Delete 버튼 클릭
		$("#btnNext").click(function(){			
			if($("#btnNext").attr("value")=="NEXT") {				
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				jqGridObj.saveCell(kRow, idCol );
				
				var row_id = $( "#jqGridMainList" ).getDataIDs();
				
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
					var block_no = item.block_no;
					var str_flag = item.block_str_flag;
					var usc_job_type = item.usc_job_type;
					var act_catalog = item.act_code;
					var job_catalog = item.job_code;
					var job_str_flag = item.str_flag;
					
					if(block_no == "" || block_no == undefined) {
						alert("BLOCK NO를 입력하세요.");
						return;
					}
					if(str_flag == "선택" || str_flag == undefined) {
						alert("STR를 입력하세요.");
						return;
					}
					if(usc_job_type == "" || usc_job_type == undefined) {
						alert("NAME을 입력하세요.");
						return;
					}
					if(act_catalog == "선택" || act_catalog == undefined) {
						alert("ACTIVITY CATALOG를 선택하세요.");
						return;
					}
					if(job_catalog == "선택" || job_catalog == undefined) {
						alert("JOB CATALOG를 선택하세요.");
						return;
					}
					if(job_str_flag == "" || job_str_flag == undefined) {
						alert("JOB STR를 선택하세요.");
						return;
					}
				}
				
				$("#btnApply").removeAttr("disabled");
				$("#btnNext").attr("value", "BACK");
				
				for(var i=0; i<row_id.length; i++) {						
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
					var block_no = item.block_no;
					var block_str_flag = item.block_str_flag;
					var str_flag = item.str_flag;
					var usc_job_type = item.usc_job_type;
					var act_catalog = item.act_code;
					var job_catalog = item.job_code;
					
					var ar_series = new Array();
					for(var j=0; j < $("input[name=p_series]:checked").size(); j++ ){
						ar_series[j] = $("input[name=p_series]:checked").eq(j).val();
					}

					var url = "jobCreateAddCheck.do?series_chk="+ar_series+"&p_block_no="+block_no+"&p_block_str_flag="+block_str_flag+"&p_str_flag="+str_flag+"&p_usc_job_type="+usc_job_type+
							  "&p_act_catalog="+act_catalog+"&p_job_catalog="+job_catalog;
					var form = $('#application_form');

					getJsonAjaxFrom(url, form.serialize(), null, callback);			
				}

				$("#div1").hide();
				$("#div2").show();
				jqGridObj.trigger("reloadGrid");
			} else if($("#btnNext").attr("value")=="BACK") {
				$("#btnNext").attr("value", "NEXT");
				$("#btnApply").attr("disabled", "disabled");

				$("#div1").show();
				$("#div2").hide();
				
				jqGridObj1.clearGridData(true);
			}
		});
		
		//Apply 버튼 클릭
		$("#btnApply").click(function(){
			var fromList = $( "#jqGridMainList1" ).getDataIDs();
			var str = "OK";
			//변경된 체크 박스가 있는지 체크한다.
			for( var i = 0; i < fromList.length; i++ ) {
				var item = $( '#jqGridMainList1' ).jqGrid( 'getRowData', fromList[i] );
				if( item.process != 'OK' ) {
					str = item.process;
					break;
				}					
			}
			
			if(str != "OK") {
				alert(str);
				return;
			}		
			
			var changedData = $( "#jqGridMainList1" ).jqGrid( 'getRowData' );
			
			if ( confirm( '적용 하시겠습니까?' ) != 0 ) {
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveUscMain.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							window.opener.fn_search();
							self.close();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				} );
			}
			
			/*
			if(confirm("적용 하시겠습니까?")) {
				var args = window.opener;
				var jsonGridData = new Array();										

				for(var i=0; i<fromList.length; i++) {						
					var item = jqGridObj1.jqGrid( 'getRowData', fromList[i]);
					
					jsonGridData.push({state_flag : 'A'
			              , representative_pro_num : item.representative_pro_num
			              , project_no : item.project_no
			              , block_no : item.block_no
			              , block_str_flag : item.block_str_flag
			              , str_flag : item.str_flag
			              , usc_job_type : item.usc_job_type
			              , act_code : item.act_code
			              , job_code : item.job_code
			              , dwgdeptnm : $("#p_dept_name").val()
			           	  , user_name : $("#p_user_name").val()
			           	  , oper : 'I'
			              });
				}	

				args.jqGridObj.clearGridData(true);
				for(var a=0; a<jsonGridData.length; a++) {	
					args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData[a], 'last');
				}						
				
				self.close();
			}	
			*/
		});
	});	
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList1" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'S';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'A';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		printCheckSelectCnt();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		printCheckSelectCnt();
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
	
	function setJobStr(rowId){
		
		jqGridObj.saveCell(kRow, idCol );

		var item = jqGridObj.jqGrid( 'getRowData', rowId );

		$.ajax({
			url : "infoJobCreateMoveStr.do?p_master_project_no="+item.representative_pro_num+"&p_project_no="+$("#p_project_no").val()+"&p_block_no="+item.block_no,
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				if(data.length == 0){
					jqGridObj.jqGrid('setCell', rowId, 'block_str_flag', '&nbsp;');
				} else {
					//jqGridObj.jqGrid('setCell', rowId, 'block_str_flag', data[0].str_flag);	
					if(data.length == 1) {
						jqGridObj.jqGrid('setCell', rowId, 'block_str_flag', data[0].str_flag);
					} else {
						jqGridObj.jqGrid('setCell', rowId, 'block_str_flag', '선택');
					}
				}	
				jqGridObj.jqGrid('setCell', rowId, 'job_code', '선택');
				setJobCreate(rowId);
			}
		});
	}
	
	function setJobCreate(rowId){
		
		jqGridObj.saveCell(kRow, idCol );

		var item = jqGridObj.jqGrid( 'getRowData', rowId );

		$.ajax({
			url : "infoJobCreateActCode.do?p_master_project_no="+item.representative_pro_num+"&p_project_no="+$("#p_project_no").val()+"&p_block_no="+item.block_no+"&p_str_flag="+item.block_str_flag,
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				if(data.length == 0){
					jqGridObj.jqGrid('setCell', rowId, 'act_code', '&nbsp;');
				} else {
					//jqGridObj.jqGrid('setCell', rowId, 'act_code', data[0].act_catalog);
					if(data.length == 1) {
						jqGridObj.jqGrid('setCell', rowId, 'act_code', data[0].act_catalog);
					} else {
						jqGridObj.jqGrid('setCell', rowId, 'act_code', '선택');
					}
				}
				setJobStr1(rowId);
			}
		});
	}
	
	function setJobStr1(rowId){
		
		jqGridObj.saveCell(kRow, idCol );

		var item = jqGridObj.jqGrid( 'getRowData', rowId );

		$.ajax({
			url : "infoJobCreateMoveJobStr.do?p_master_project_no="+item.representative_pro_num+"&p_project_no="+$("#p_project_no").val()+"&p_block_no="+item.block_no+"&p_block_str="+item.block_str_flag+"&p_act_catalog="+item.act_code+"&p_job_catalog="+item.job_code,
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				if(data.length == 0){
					jqGridObj.jqGrid('setCell', rowId, 'str_flag', '&nbsp;');
				} else {
					jqGridObj.jqGrid('setCell', rowId, 'str_flag', data[0].str_flag);
				}
			}
		});
	}
	
	var callback = function(json){
		jqGridObj1.jqGrid('addRowData', $.jgrid.randId(), json, 'first' );
	}
	
	//afterSaveCell
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	// Add 버튼 
 	function addRow(item) { 		
 		jqGridObj.saveCell(kRow, idCol );
		var row_all = jqGridObj.getDataIDs();
		for( var i = 0; i < row_all.length; i++ ) {
			jqGridObj.jqGrid('setCell', row_all[i], 'oper', 'U');
		}
		jqGridObj.saveCell(kRow, idCol );
		
		var item = {};
 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
 		for(var i in colModel) item[colModel[i].name] = '';
 		item.state_flag = 'A';
 		item.oper = 'I';
 		item.representative_pro_num = $("#p_master_no").val();
 		jqGridObj.resetSelection();
 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
 	}
 	// Del 버튼 
 	function delRow(item) {
		//var selrow = jqGridObj.jqGrid('getGridParam', 'selrow');
		//var item = jqGridObj.jqGrid('getRowData', selrow);
		
		//jqGridObj.jqGrid( 'delRowData', selrow );
 		jqGridObj.saveCell( kRow, idCol );
		
 		//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
		var row_id1 = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		var row_len = row_id1.length;					
		//I 인것들은 바로 없앰
		for(var i=0; i<row_len; i++){
			var item = jqGridObj.jqGrid( 'getRowData', row_id1[0]);					
			jqGridObj.jqGrid('delRowData',row_id1[0]);						
		}
		//I가 아닌 것들을 다시 row_id 구해서 'D' 값 처리
		row_id1 = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		for(var i=0; i<row_id1.length; i++){								
			jqGridObj.jqGrid('delRowData',row_id1[i]);								
		}
		
		jqGridObj.resetSelection();
 	}
	
</script>
</body>

</html>
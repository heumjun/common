<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC BLOCK</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
		USC BLOCK<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
		<col width="90"/>
		<col width="100"/>
		<col width="100"/>
		<col width="90"/>
		<col width="140"/>
		<!--<col width="90"/>
		<col width="130"/>
		<col width="90"/>
		<col width="90"/>
		<col width="70"/>
		<col width="70"/>-->
		<col width="*"/>
	<tr>
		<th>Project</th>
		<td>
			<input type="text" class = "require" id="p_project_no" name="p_project_no" alt="Project" value="${p_project_no}" style="width:80px;" value="" readonly/>
		</td>
		<td>
			<input type="checkbox" name="p_act_job" id="p_act_job"/>&nbsp; <label>ACT & JOB</label>
		</td>
		<th>ECO NO.</th>
		<td>
			<input type="text" class="require" name="p_eco_no" id="p_eco_no" alt="ECO"  style="width:60px;" value="" disabled/>
			<input type="button" class="btn_gray2" id="btnEco" name="btnEco" value="CREATE" disabled/>
		</td>
		
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue2" value="V-BLK" id="btnVstr"/>
				<!-- <input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
				<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
				<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/> -->
				<input type="button" class="btn_blue2" value="IMPORT" id="btnExcel"/>						
				<input type="button" class="btn_blue2" value="NEXT" id="btnSave"/>
			</div>
		</td>	
		</tr>
		</table>
		<table class="searchArea2">
			<col width="600"/>
			<col width="*"/>
			<tr>
				<td>
					<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
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
		getAjaxHtml($("#SeriesCheckBox"),"infoUscSeriesProjectList.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y", null, getDeliverySeriesCallback);
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			 colModel : [
					{label:'AREA'		, name : 'area'			, index : 'area'		, width : 100, editable : true, align : "center", edittype : "select", formatter : 'select',  
						 editoptions: { 
							 dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setBlockCata(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
						            		var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setBlockCata(rowId);
					            		}
					                }
					            }]
							 }},
					{label:'B_NAME'		, name : 'block'		, index : 'block'		, width : 100, editable : true, align : "center",  
						 editoptions: { 
							 dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setBlockCata(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setBlockCata(rowId);						                    
						                }
					                }
					            }]
							 }},
					{label:'B_CATA'		, name : 'bk_code'		, index : 'bk_code'		, width : 100, editable : true, align : "center", edittype : "select",   
						 editoptions: {
							 dataUrl: function(){
								    var ar_series = new Array();
									for(var j=0; j < $("input[name=p_series]:checked").size(); j++ ){
										ar_series[j] = $("input[name=p_series]:checked").eq(j).val();
									}
									
							 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
					             	var url = "infoBlockCataList.do?p_chk_series="+ar_series+"&p_block_no="+item.block+"&p_area="+item.area;
					 				return url;
							 	},
					   		 	buildSelect: function(data){
					      		 	if(typeof(data)=='string'){
					      		 		data = $.parseJSON(data);
					      		 	}					      		 	
					      		 	
					       		 	var rtSlt = '<select name="deptid">';
					       		 	
					       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
										if(data.length == 2 && data[idx].block_catalog != " "){
											rtSlt +='<option value="'+data[idx].block_catalog+'">'+data[idx].block_catalog+'</option>';	
						       		 	}else{
						       		 		rtSlt +='<option value="'+data[idx].block_catalog+'">'+data[idx].block_catalog+'</option>';
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
					                    setBlockStr(rowId);
					                }},
					                {
					            	type: 'keydown'
					            	, fn: function(e) {
					            		if(e.keyCode == "9" || e.keyCode == "13"){
					            			var row = $(e.target).closest('tr.jqgrow');
						                    var rowId = row.attr('id');
						                    //job code 셋팅
						                    setBlockStr(rowId);
						                }
					                }
					            }]
							 }},
					{label:'B_STR'		, name : 'block_str_flag', index : 'block_str_flag'	, width : 100, editable : true, align : "center", edittype : "select",   
								 editoptions: {
									 dataUrl: function(){
										    var ar_series = new Array();
											for(var j=0; j < $("input[name=p_series]:checked").size(); j++ ){
												ar_series[j] = $("input[name=p_series]:checked").eq(j).val();
											}
											
									 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
							             	var url = "infoBlockStrList.do?p_chk_series="+ar_series+"&p_block_no="+item.block+"&p_area="+item.area+"&p_block_catalog="+item.bk_code;
							 				return url;
									 	},
							   		 	buildSelect: function(data){
							      		 	if(typeof(data)=='string'){
							      		 		data = $.parseJSON(data);
							      		 	}
							      		 	
							       		 	var rtSlt = '<select name="deptid1">';
							       		 	
							       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
												if(data.length == 2 && data[idx].block_str_flag != " "){
													rtSlt +='<option value="'+data[idx].block_str_flag+'">'+data[idx].block_str_flag+'</option>';	
								       		 	}else{
								       		 		rtSlt +='<option value="'+data[idx].block_str_flag+'">'+data[idx].block_str_flag+'</option>';
								       		 	}
							       		 	}
								       		rtSlt +='</select>';
								       		
								       		return rtSlt;
							   		 	}
									 }},
					{label:'DIFF'		, name : 'diff'			, index : 'diff'		, width : 100, editable : false, align : "center"},
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
			 gridComplete: function(data){
				var rows = jqGridObj.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = jqGridObj.getCell( rows[i], "oper" );		
						
					jqGridObj.jqGrid( 'setCell', rows[i], 'diff', '', { color : 'black', background : '#DADADA' } );
						
					if(oper != 'U'){
						if(oper != 'A'){
							jqGridObj.jqGrid( 'setCell', rows[i], 'area', '', { color : 'black', background : '#DADADA' } );
							jqGridObj.jqGrid( 'setCell', rows[i], 'area', '', 'not-editable-cell' );
							jqGridObj.jqGrid( 'setCell', rows[i], 'block', '', { color : 'black', background : '#DADADA' } );
							jqGridObj.jqGrid( 'setCell', rows[i], 'block', '', 'not-editable-cell' );
							jqGridObj.jqGrid( 'setCell', rows[i], 'bk_code', '', { color : 'black', background : '#DADADA' } );
							jqGridObj.jqGrid( 'setCell', rows[i], 'bk_code', '', 'not-editable-cell' );
							jqGridObj.jqGrid( 'setCell', rows[i], 'block_str_flag', '', { color : 'black', background : '#DADADA' } );
							jqGridObj.jqGrid( 'setCell', rows[i], 'block_str_flag', '', 'not-editable-cell' );
						}
					}
				}
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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
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
					{label:'Project'	, name : 'project_no'	, index : 'project_no'	, width : 166, editable : false, align : "center"},
					{label:'AREA'		, name : 'area'			, index : 'area'		, width : 166, editable : false, align : "center"},
					//{label:'구역'		, name : 'area_name'	, index : 'area_name'	, width : 208, editable : false, align : "center"},
					{label:'B_NAME'		, name : 'block'		, index : 'block'		, width : 166, editable : false, align : "center"},
					{label:'B_CATA'		, name : 'bk_code'		, index : 'bk_code'		, width : 166, editable : false, align : "center"},
					{label:'B_STR'		, name : 'block_str_flag'	, index : 'block_str_flag'	, width : 166, editable : false, align : "center"},
					{label:'DIFF'		, name : 'diff'			, index : 'diff'		, width : 166, editable : false, align : "center"},
					{label:''		    , name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true},
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
			 gridComplete: function(data){

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
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
			},
			afterSaveCell : chmResultEditEnd
    	}); //end of jqGrid

		// 구역 선택
     	$.post( "infoAreaList.do", "", function( data ) {
     		jqGridObj.setObject( {
				value : 'sd_code',
				text : 'sd_code',
				name : 'area',
				data : data
			} );
		}, "json" );
     	
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 0 );
	    fn_gridresize( $(window), jqGridObj1, 0 );
     	
     	$("#p_act_job").change(function(){
     		if($("input[name=p_act_job]").prop("checked")) {
     			$("#p_eco_no").removeAttr("disabled");
     			$("#btnEco").removeAttr("disabled");
     		} else {
     			$("#p_eco_no").attr("disabled", "disabled");
     			$("#btnEco").attr("disabled", "disabled");
     		}
     	});
		
		//V-BLK 클릭
		$("#btnVstr").click(function(){		
			//시리즈 배열 받음
			var ar_series = new Array();
			
			jqGridObj.saveCell(kRow, idCol );
			
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			var nwidth = 1000;
			var nheight = 600;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
			var rs = window.open( "popUpUscVirtualBlock.do?chk_series="+ar_series+"&rep_pro_num="+$("#rep_pro_num").val(), "vBlk", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
		});
     	
		//Add 클릭
		$("#btnAdd").click(function(){		
			var old_item = null;
  			jqGridObj.saveCell(kRow, idCol );
			var row_all = jqGridObj.getDataIDs();
			
			for( var i = 0; i < row_all.length; i++ ) {
				jqGridObj.jqGrid('setCell', row_all[i], 'oper', 'U');
				if(i == row_all.length - 1) {
					old_item = jqGridObj.jqGrid( 'getRowData', row_all[i] );
				}
			}
			jqGridObj.saveCell(kRow, idCol );
			
			var item = {};
	 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
	 		for(var i in colModel) item[colModel[i].name] = '';
	 		item.oper = 'A';
	 		
	 		if(old_item != null) {
	 			item.area = old_item.area;
	 			item.block = old_item.block;
	 			item.bk_code = old_item.bk_code;
	 			item.block_str_flag = old_item.block_str_flag;
	 		}
	 		jqGridObj.resetSelection();
	 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'last');
		});
     	
		//Delete 버튼 클릭
		$("#btnExcel").click(function(){
			if($("#btnExcel").attr("value")=="IMPORT") {
				if($("input[name=p_act_job]").prop("checked") && !uniqeValidation()) {
					return;
				}
				var sURL = "popUpUscBlockExcelImport.do";
				var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
				window.showModalDialog(sURL, window, popOptions);				
			} else if($("#btnExcel").attr("value")=="BACK") {
				$("#btnVstr").removeAttr("disabled");
				//$("#btnAdd").removeAttr("disabled");
				//$("#btnSearch").removeAttr("disabled");
				//$("#btnExcel").removeAttr("disabled");
				$("#p_eco_no").removeAttr("disabled");
     			$("#btnEco").removeAttr("disabled");
				
				$("#btnExcel").attr("value", "IMPORT");
				$("#btnSave").attr("value", "NEXT");
				
				$("#div1").show();
				$("#div2").hide();
				
				jqGridObj1.clearGridData(true);
			}
		});
		
		//Next 버튼 클릭
		$("#btnSave").click(function(){
			if($("#btnSave").attr("value")=="NEXT") {
				//모두 대문자로 변환
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				jqGridObj.saveCell(kRow, idCol );
				
				var row_id = $( "#jqGridMainList" ).getDataIDs();
				if(row_id.length == 0) {
					alert("데이터 임포트 또는 추가하여 주십시오.");
					return;
				}
				
				if($("input[name=p_act_job]").prop("checked") && !uniqeValidation()) {
					return;
				}
				
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
					var area = item.area;
					var block = item.block;
					var bk_code = item.bk_code;
					var block_str_flag = item.block_str_flag;
					
					if(area == "" || area == undefined) {
						alert("AREA를 입력하세요.");
						return;
					}
					if(block == "" || block == undefined) {
						alert("B_NAME을 입력하세요.");
						return;
					}
					if(bk_code == "" || bk_code == undefined) {
						alert("B_CATA를 입력하세요.");
						return;
					}
					if(block_str_flag == "" || block_str_flag == undefined) {
						alert("B_STR를 입력하세요.");
						return;
					}
				}
				
				$("#btnVstr").attr("disabled", "disabled");
				if($("input[name=p_act_job]").prop("checked")) {
	     			$("#p_eco_no").removeAttr("disabled");
	     			$("#btnEco").removeAttr("disabled");
	     		} else {
	     			$("#p_eco_no").attr("disabled", "disabled");
	     			$("#btnEco").attr("disabled", "disabled");
	     		}
				
				$("#btnExcel").attr("value", "BACK");
				$("#btnSave").attr("value", "APPLY");
				
				for(var i=0; i<row_id.length; i++) {					
					var ar_series = new Array();
					
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
					
					var ar_series = new Array();
					for(var j=0; j < $("input[name=p_series]:checked").size(); j++ ){
						ar_series[j] = $("input[name=p_series]:checked").eq(j).val();
					}
					
					var area = item.area;
					var block = item.block;
					var bk_code = item.bk_code;
					var block_str_flag = item.block_str_flag;
					
					var url = "uscBlockImportCheck.do?series_chk="+ar_series+"&p_area="+area+"&p_block="+block+"&p_bk_code="+bk_code+"&p_block_str_flag="+block_str_flag;
					var form = $('#application_form');

					getJsonAjaxFrom(url, form.serialize(), null, callback);			
			
				}

				$("#div1").hide();
				$("#div2").show();
			} else if($("#btnSave").attr("value")=="APPLY") {
				var fromList = $( "#jqGridMainList1" ).getDataIDs();
				var str = "OK";
				//변경된 체크 박스가 있는지 체크한다.
				for( var i = 0; i < fromList.length; i++ ) {
					var item = $( '#jqGridMainList1' ).jqGrid( 'getRowData', fromList[i] );
					if( item.diff != 'OK' ) {
						str = "DIFF";
						break;
					}					
				}
				
				var row_id = fromList;
				
				if($("input[name=p_act_job]").prop("checked") && !uniqeValidation()) {
					return;
				}
				
				if ($("input[name=p_series]:checked").size() == 0) {
					alert("호선을 선택하십시오");
					return;
				}
				
				if(str != "OK") {
					alert("하나 이상의 항목이 OK가 아닐 경우 적용할 수 없습니다.");
					return;
				}				
				
				if(confirm("적용 하시겠습니까?")) {
					var args = window.opener;
					var jsonGridData = new Array();										
					
					for(var i=0; i<row_id.length; i++) {						
						var item = jqGridObj1.jqGrid( 'getRowData', row_id[i]);
						var master = $("#rep_pro_num").val();
						var project = item.project_no;
						var area = item.area;
						var area_name = item.area_name;
						var block = item.block;
						var bk_code = item.bk_code;
						var str_flag = item.block_str_flag;
						
						var ar_series = new Array();
					}	
					
					if($("input[name=p_act_job]").prop("checked")) {
						var chmResultRows = [];
						
						//변경된 row만 가져 오기 위한 함수
						getChangedChmResultData( function( data ) {
							lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
							
							chmResultRows = data;
							var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
							var url = 'useJobActAction.do';
							var formData = fn_getFormData('#application_form');
							//객체를 합치기. dataList를 기준으로 formData를 합친다.
							var parameters = $.extend( {}, dataList, formData); 
							
							$.post( url, parameters, function( data ) {
								alert(data.resultMsg);
								if ( data.result == 'success' ) {
									args.fn_search();
									self.close();
								}
							}, "json" ).error( function () {
								alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
							}).always( function() {
						    	lodingBox.remove();	
							});							
						});
					} else {
						getChangedChmResultData( function( data ) {
							lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
							
							chmResultRows = data;
							var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
							var formData = fn_getFormData('#application_form');
							//객체를 합치기. dataList를 기준으로 formData를 합친다.
							var parameters = $.extend( {}, dataList, formData);								
							
							var sUrl = "uscBlockExportList.do";
							args.jqGridObj.jqGrid( "clearGridData" );
							args.jqGridObj.jqGrid( 'setGridParam', {
								url : sUrl,
								mtype : 'POST',
								datatype : 'json',
								page : 1,
								rows : 100,
								rowNum : 999999,
								postData : parameters
							} ).trigger( "reloadGrid" );

							self.close();
						});
					}						
				}				
			}
		});
		
		//Eco no 버튼 클릭 시 Ajax로 Eno no를 받아 넣는다.
		$("#btnEco").click(function(){
			var dialog = $( '<p>ECO를 연결합니다.</p>' ).dialog( {
				buttons : {
					"SEARCH" : function() {
						var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5&menu_id=${menu_id}",
								window,
								"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; status:off" );

						if( rs != null ) {
							$( "#p_eco_no" ).val( rs[0] );
						}

						dialog.dialog( 'close' );
					},
					"CREATE" : function() {
						var rs = window.showModalDialog( "popUpEconoCreate.do?ecoYN=&mainType=ECO",
								"ECONO",
								"dialogWidth:600px; dialogHeight:430px; center:on; scroll:off; status:off" );
						if( rs != null ) {
							$( "#p_eco_no" ).val( rs[0] );
						}
						dialog.dialog( 'close' );
					},
					"Cancel" : function() {
						dialog.dialog( 'close' );
					}
				}
			} );
		});
	});	
	
    function getDeliverySeriesCallback(){
    	$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
			var deliverySeries = data;
    		for(var i=0; i<$("input[name=p_series]").length; i++){
    			var id = $("input[name=p_series]")[i].id;
    			for(var j=0; j<deliverySeries.length; j++){
    				if($("input[name=p_series]")[i].id == "p_series_"+deliverySeries[j].project_no){
    					$("#" + id).attr("disabled", true); 
        				$("input:checkbox[id='"+id+"']").prop("checked", false);
        				break;
    				}
    				else{
    					$("#" + id).attr("disabled", false);
        				$("input:checkbox[id='"+id+"']").prop("checked", true);
    				}
    			}
    		}	
		},"json");
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
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList1" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'A' || obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}	

	function fn_search() {		
		var sUrl = "uscMainList.do";
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
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
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".require").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return false;
			}
		});
		return rnt;
	}
	
	function setBlockCata(rowId){
		
		jqGridObj.saveCell(kRow, idCol );
		var ar_series = new Array();
		for(var j=0; j < $("input[name=p_series]:checked").size(); j++ ){
			ar_series[j] = $("input[name=p_series]:checked").eq(j).val();
		}

		var item = jqGridObj.jqGrid( 'getRowData', rowId );

		$.ajax({
			url : "infoBlockCataList.do?p_chk_series="+ar_series+"&p_block_no="+item.block+"&p_area="+item.area,
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				if(data.length == 0){
					jqGridObj.jqGrid('setCell', rowId, 'bk_code', '&nbsp;');
				} else {
					jqGridObj.jqGrid('setCell', rowId, 'bk_code', data[0].block_catalog);					
				}
				setBlockStr(rowId);
				$("p_project_no").attr('unselectable', 'on');
                $("p_project_no").css('user-select', 'none');
                $("p_project_no").on('selectstart', false);
			}
		});
		
	}
	
	function setBlockStr(rowId){
		
		jqGridObj.saveCell(kRow, idCol );
		var ar_series = new Array();
		for(var j=0; j < $("input[name=p_series]:checked").size(); j++ ){
			ar_series[j] = $("input[name=p_series]:checked").eq(j).val();
		}

		var item = jqGridObj.jqGrid( 'getRowData', rowId );

		$.ajax({
			url : "infoBlockStrList.do?p_chk_series="+ar_series+"&p_block_no="+item.block+"&p_area="+item.area+"&p_block_catalog="+item.bk_code,
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				if(data.length == 0){
					jqGridObj.jqGrid('setCell', rowId, 'block_str_flag', '&nbsp;');
				} else {
					jqGridObj.jqGrid('setCell', rowId, 'block_str_flag', data[0].block_str_flag);
				}
				$("p_project_no").attr('unselectable', 'on');
                $("p_project_no").css('user-select', 'none');
                $("p_project_no").on('selectstart', false);
			}
		});
		
	}
	
	var callback = function(json){
		jqGridObj1.jqGrid('addRowData', $.jgrid.randId(), json, 'first' );
	}
	
	var setVBlock = function(rs) {
		if(rs != null) {
			var args = window.opener;
			
			args.jqGridObj.clearGridData(true);
			for(var a=0; a<rs.length; a++) {	
				args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), rs[a], 'last');
			}
			self.close();
		}
	}
	
	// Add 버튼 
 	function addRow(item) { 		
 		var old_item = null;
			jqGridObj.saveCell(kRow, idCol );
		var row_all = jqGridObj.getDataIDs();
		
		for( var i = 0; i < row_all.length; i++ ) {
			jqGridObj.jqGrid('setCell', row_all[i], 'oper', 'U');
			if(i == row_all.length - 1) {
				old_item = jqGridObj.jqGrid( 'getRowData', row_all[i] );
			}
		}
		jqGridObj.saveCell(kRow, idCol );
		
		var item = {};
 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
 		for(var i in colModel) item[colModel[i].name] = '';
 		item.oper = 'A';
 		
 		if(old_item != null) {
 			item.area = old_item.area;
 			item.block = old_item.block;
 			item.bk_code = old_item.bk_code;
 			item.block_str_flag = old_item.block_str_flag;
 		}
 		jqGridObj.resetSelection();
 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'last');
 	}
 	// Del 버튼 
 	function delRow(item) {
		var selrow = jqGridObj.jqGrid('getGridParam', 'selrow');
		var item = jqGridObj.jqGrid('getRowData', selrow);
		
		jqGridObj.jqGrid( 'delRowData', selrow );
		
		jqGridObj.resetSelection();
 	}
	
</script>
</body>

</html>
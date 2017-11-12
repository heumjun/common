<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	<title>PURCHASING - MODIFY</title>
	<style type="text/css">
	</style>
</head>
<body>
	<form id="application_form" name="application_form" >
		<input type="hidden" 	name="user_name" 		id="user_name"  	value="${loginUser.user_name}" />
		<input type="hidden" 	name="user_id" 			id="user_id"  		value="${loginUser.user_id}" />
		<input type="hidden" 	name="p_master"    		id="p_master" 		value="${p_master}"/>
		<input type="hidden" 	name="p_dwg_no"    		id="p_dwg_no" 		value="${p_dwg_no}"/>
		<input type="hidden" 	name="p_pos_rev"    	id="p_pos_rev" 		value="${p_pos_rev}"/>
		<input type="hidden" 	name="p_pur_no"    		id="p_pur_no" 		value="${p_ems_pur_no}"/>
		<input type="hidden" 	name="p_session_id"    	id="p_session_id" 	value="${p_session_id}"/>
		<input type="hidden" 	name="p_callback"    	id="p_callback" 	value="${p_callback}"/>
		
		
		<div id="mainDiv" class="mainDiv">
			<div class= "subtitle" style="width: 96.5%;">
				Purchasing POS
				<jsp:include page="../../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
				<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>
			<table class="searchArea conSearch">
				<colgroup>
					<col width="65%">
					<col width="*">
				</colgroup>
				<tr>
					<td >
						<div class="button endbox">
								<input type="button" value="UPLOAD" id="btnUpload"  class="btn_red2"/>
								<input type="button" value="ADD" id="btnAdd" class="btn_blue2"/>
								<input type="button" value="SAVE" id="btnSave"  class="btn_blue2"/>
								<input type="button" value="CLOSE" id="btnClose" class="btn_blue2"/>
						</div>
					</td>						
				</tr>
			</table>
			<div class="content" id="gridPosListDiv">
				<table id="gridPosList"></table>
				<div id="bottomPosList"></div>
			</div>
			
		</div>
	</form>
<script type="text/javascript">

//STATE 값에 따라서 a href 생성
function formatOpt2(cellvalue, options, rowObject){
	
	var file_id = Math.floor(rowObject.file_id);
	var str = "";
	if(cellvalue == "Y"){
			str = "<a href=\"javascript:fileView("+file_id+")\">Y</a>";
	}else{
		str = "N";
	}	  	             
	 	return str;
	 
}


//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
		
	var rowid = options.rowId;
	
	var pos_rev = parseInt(rowObject.pos_rev);
	var is_approved = rowObject.is_approved;
	var checked = "";
	var checkValue = "N";
	if(is_approved == "Y") checked = "disabled";
	else if(pos_rev == $("#p_pos_rev").val()){ checked = "checked=\"checked\""; checkValue ="Y";}   
	var str ="<input type=\"checkbox\" name=\"chkbox\" id=\"check_"+rowid+"\" class=\"chkboxItem\" value=\""+checkValue+"\" "
				+ checked +" onclick=\"this.value = (this.value == 'Y' ? 'N':'Y'); if(gridObj.jqGrid('getCell',"+rowid+",'oper') != 'I')gridObj.jqGrid( 'setCell',"+rowid+", 'oper', 'U');\"/>";
	return str;
}
function unFormatOpt1(cellvalue, options, cell){
	return $('input',cell).attr('value');
}

function disableRow(jqGridObj,rowId,cellNameAry,disableClr){
	for(var i = 0; i < cellNameAry.length; i++){
		jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', 'not-editable-cell' );
		if(disableClr == undefined)jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', { color : 'black', background : '#dadada' } );
		
	}
}

function prependZero(num, len) {
    while(num.toString().length < len) {
        num = "0" + num;
    }
    return num;
}

function fileCallBack(jsonData){
	var rows = gridObj.getDataIDs();
	gridObj.jqGrid( 'setCell', rows[0], 'file_id', jsonData.file_id, 'not-editable-cell');
	gridObj.jqGrid( 'setCell', rows[0], 'is_pos', 'Y', 'not-editable-cell');
	if(gridObj.getCell( rows[0], "oper") != "I"){
		gridObj.jqGrid( 'setCell', rows[0], 'oper', 'U');
	}
}

function getChangedChmResultData(callback) {
	var changedData = $.grep(gridObj.jqGrid('getRowData'),
			function(obj) {
				return obj.oper == 'I' || obj.oper == 'U';
			});
	callback.apply(this, [ changedData.concat(resultData) ]);
}

var idRow;
var idCol;
var kRow;
var kCol;
var lastSelection;
var flagDataChange;
var resultData = [];
var gridObj = $("#gridPosList");

$(document).ready(function(){
 	gridObj.jqGrid({ 
        datatype: 'json', 
        mtype: 'POST', 
        url:'popUpPurchasingNewPosList.do',
        postData : fn_getFormData('#application_form'),		             
        colModel:[
			{label:'CHK' 				,name:'chk_state' 	, index:'chk_state' ,width:25 	,	align:'center', formatter:formatOpt1, unformat:unFormatOpt1,sortable:false},
			{label:'MASTER' 			,name:'master' 		, index:'master' 	,width:55	,	align:'center', sortable:false,	title:false},
			{label:'DWG NO.' 			,name:'dwg_no' 		, index:'dwg_no' 	,width:55 	,	align:'center', sortable:false,	title:false},
			{label:'DWG DESCRIPTION.' 	,name:'dwg_desc' 	, index:'dwg_desc' 	,width:150 	,	align:'center', sortable:false,	title:false},
			{label:'DWG REV'		 	,name:'pos_rev' 	, index:'pos_rev' 	,width:55 	,	align:'center', sortable:false,	title:false,
				cellattr: function (){ 
        		  	return 'title="POS file을 프로그램에 등록한 순서 (실제 POS Rev.과 매치 안됨)"'; 
        		 }
			},
			{label:'항목'			 	,name:'pos_type' 	, index:'pos_type' 	,width:85 	,	align:'center', sortable:false,	title:false,	editable:true,
				edittype:'select', //SELECT BOX 옵션
				formatter:'select',
				editoptions:{
					dataEvents : [ 
					               { 
										type : 'change', 
           						    	fn : function( e ) {
           						    		var row = $(e.target).closest('tr.jqgrow');
       	                                    var rowid = row.attr('id');
       						    			var colModel = gridObj.jqGrid('getGridParam', 'colModel');
       						    			var oper = gridObj.jqGrid('getCell',rowid,'oper');
       						    			
           						    		if(this.value == "A"){
           						    			gridObj.jqGrid( 'setCell', rowid, 'item_type', 'Y', 'not-editable-cell');
           						    			gridObj.jqGrid( 'setCell', rowid, 'is_cost', 'N', 'not-editable-cell' );
           						    		}
           						    		else {
           						    	        for (var iCol = 0; iCol < colModel.length; iCol++) {
           						    	            if (colModel[iCol].name === 'is_cost' || colModel[iCol].name === 'item_type') {
           						    	                var row = gridObj[0].rows.namedItem(rowid);
           						    	                var cell = row.cells[iCol];
           						    	                $(cell).removeClass('not-editable-cell');
           						    	             	if($("#p_pos_rev").val() != "" || ($("#p_pos_rev").val() == "" && $("#p_pur_no").val().length > 0)){
                    						    			gridObj.jqGrid( 'setCell', rowid, 'item_type', 'Y', 'not-editable-cell');
                    									}
           						    	            }
           						    	        }
           						    		}
           						    		if(oper != 'I')gridObj.jqGrid( 'setCell', rowid, 'oper', 'U');
       			 				   		}
       			 				 	}
       		 				 	]
				},
       		  	cellattr: function (){ 
       		  	return 'title="POS 등록 사유"'; 
       		  }
			},
			{label:'ITEM'			 	,name:'item_type' 	, index:'item_type' ,width:30 	,	align:'center', sortable:false,	title:false,	editable : true,
				edittype:'select', //SELECT BOX 옵션
     			formatter:'select',
     			editoptions:{
     			 	value:'Y:Y;N:N',
   			 		dataEvents : [ 
					               { 
										type : 'change', 
           						    	fn : function( e ) {
           						    		var row = $(e.target).closest('tr.jqgrow');
       	                                    var rowid = row.attr('id');
       						    			var colModel = gridObj.jqGrid('getGridParam', 'colModel');
       						    			var oper = gridObj.jqGrid('getCell',rowid,'oper');
           						    		if(oper != 'I')gridObj.jqGrid( 'setCell', rowid, 'oper', 'U');
       			 				   		}
       			 				 	}
       		 				 	]
     			 },
     			cellattr: function (){ 
        		  	return 'title="ITEM이 Y인 경우 SAVE시 자동 승인됩니다."'; 
        		 }
			},
			{label:'원인부서'			 	,name:'cause_dept' 	, index:'cause_dept',width:120 	,	align:'center', sortable:false,	title:false,	editable : true, 
          		 edittype : "select", 
           		 formatter : 'select', 
           		 editrules : { required : false },
           		 editoptions:{
   			 		dataEvents : [ 
					               { 
										type : 'change', 
           						    	fn : function( e ) {
           						    		var row = $(e.target).closest('tr.jqgrow');
       	                                    var rowid = row.attr('id');
       						    			var colModel = gridObj.jqGrid('getGridParam', 'colModel');
       						    			var oper = gridObj.jqGrid('getCell',rowid,'oper');
           						    		if(oper != 'I')gridObj.jqGrid( 'setCell', rowid, 'oper', 'U');
       			 				   		}
       			 				 	}
       		 				 	]
     			 },
           		 cellattr: function (){ 
        		  	return 'title="POS 등록 원인부서"'; 
        		  }
           	},
			{label:'비용발생'			 	,name:'is_cost' 	, index:'is_cost'	,width:45 	,	align:'center', sortable:false,	title:false,	editable : true, 
     			 edittype:'select', //SELECT BOX 옵션
      			 formatter:'select',
      			 editoptions:{
      			 	value:'Y:Y;N:N',
      			 	dataEvents : [ 
					               { 
										type : 'change', 
          						    	fn : function( e ) {
          						    		var row = $(e.target).closest('tr.jqgrow');
      	                                    var rowid = row.attr('id');
      						    			var colModel = gridObj.jqGrid('getGridParam', 'colModel');
      						    			var oper = gridObj.jqGrid('getCell',rowid,'oper');
          						    		if(oper != 'I')gridObj.jqGrid( 'setCell', rowid, 'oper', 'U');
      			 				   		}
      			 				 	}
      		 				 	]
      			 },
      			 cellattr: function (){ 
        		  	return 'title="기자재 사양 변경에 따른 비용 처리 유무 (수량은 증가하지 않고 비용만 증가)"'; 
        		 }
			},
			{label:'EXTRA비용'			,name:'extra_cost' 	, index:'extra_cost',width:60 	,	align:'right', sortable:false,	title:false,	editable : true,
				edittype:'text',
				editoptions:{
      			 	dataEvents : [ 
					               { 
										type : 'change', 
          						    	fn : function( e ) {
          						    		var row = $(e.target).closest('tr.jqgrow');
      	                                    var rowid = row.attr('id');
      						    			var colModel = gridObj.jqGrid('getGridParam', 'colModel');
      						    			var oper = gridObj.jqGrid('getCell',rowid,'oper');
          						    		if(oper != 'I')gridObj.jqGrid( 'setCell', rowid, 'oper', 'U');
      			 				   		}
      			 				 	}
      		 				 	]
      			 },
				cellattr: function (){ 
        		  	return 'title="필요시 기입"'; 
        		 }
			},
			{label:'POS'				,name:'is_pos' 		, index:'is_pos'	,width:40 	,	align:'center', sortable:false,	title:false,	formatter:formatOpt2,
				cellattr: function (){ 
        		  	return 'title="현재 임시 저장한 POS 파일의 유무"'; 
				}
			},
			{label:'승인'				,name:'is_approved' 	, index:'is_approved' 	,width:40 	,	align:'center', sortable:false,	title:false,
				cellattr: function (){ 
        		  	return 'title="POS file이 조달부서에 확정 전달 되었는지 유무"'; 
				}
			},
			{label:'DATE'				,name:'creation_date' 	, index:'creation_date' ,width:50 	,	align:'center', sortable:false,	title:false},
			{label:'REMARK'				,name:'remark' 			, index:'remark' 	,width:180 	,	align:'center', sortable:false,	title:false, editable : true, 
				edittype : "text",
				editoptions:{
      			 	dataEvents : [ 
					               { 
										type : 'change', 
          						    	fn : function( e ) {
          						    		var row = $(e.target).closest('tr.jqgrow');
      	                                    var rowid = row.attr('id');
      						    			var colModel = gridObj.jqGrid('getGridParam', 'colModel');
      						    			var oper = gridObj.jqGrid('getCell',rowid,'oper');
          						    		if(oper != 'I')gridObj.jqGrid( 'setCell', rowid, 'oper', 'U');
      			 				   		}
      			 				 	}
      		 				 	]
      			 },
				cellattr: function (){ 
        		  	return 'title="기타사항"'; 
				}
			},
			{label:'FILE_ID'			,name:'file_id' 	, index:'file_id' 	,width:50 	,	align:'center', sortable:false,	title:false,	hidden:true},
			{label:'OPER'				,name:'oper' 		, index:'oper' 		,width:50 	,	align:'center', sortable:false,	title:false,	hidden:true}
        ],
        gridview: true,
        viewrecords: true,
        autowidth: true,
        cellEdit : true,
        cellsubmit : 'clientArray', // grid edit mode 2		             
        scrollOffset : 0,
        multiselect: false,
        shrinkToFit: false,
        height: 170,
        pager: jQuery('#bottomPosList'),
        rowList:[100,500,1000],
        rowNum:100, 
		beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
        	idRow = rowid;
        	idCol = iCol;
        	kRow  = iRow;
        	kCol  = iCol;
		},
		afterEditCell: function(id,name,val,iRow,iCol){
			  //Modify event handler to save on blur.
			  $("#"+iRow+"_"+name).bind('blur',function(){
				$('#gridPosList').saveCell(iRow,iCol);
			  });
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
        	var pageIndex         = parseInt($(".ui-pg-input").val());
   			var currentPageIndex  = parseInt($("#jqGridPurchasingList").getGridParam("page"));// 페이지 인덱스
   			var lastPageX         = parseInt($("#jqGridPurchasingList").getGridParam("lastpage"));  
   			var pages = 1;
   			var rowNum 			  = 100;	   			
   			if (pgButton == "user") {
   				if (pageIndex > lastPageX) {
   			    	pages = lastPageX
   			    } else pages = pageIndex;
   			}
   			else if(pgButton == 'next_btnjqGridPurchasingList'){
   				pages = currentPageIndex+1;
   			} 
   			else if(pgButton == 'last_btnjqGridPurchasingList'){
   				pages = lastPageX;
   			}
   			else if(pgButton == 'prev_btnjqGridPurchasingList'){
   				pages = currentPageIndex-1;
   			}
   			else if(pgButton == 'first_btnjqGridPurchasingList'){
   				pages = 1;
   			}
 	   		else if(pgButton == 'records') {
   				rowNum = $('.ui-pg-selbox option:selected').val();                
   			}
   			$(this).jqGrid("clearGridData");
   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
		 },
		 onCellSelect: function(row_id,icol,cellcontent,e) {
		 
		 },
		 beforeRequest : function(){
			 $.ajaxSetup({async: false});
			//그리드 내 콤보박스 바인딩
			 	$.post( "popUpPurchasingNewFosSelectBoxCauseDept.do", "", function( data ) {
					$( '#gridPosList' ).setObject( {
						value : 'value',
						text : 'text',
						name : 'cause_dept',
						data : data
					} );
				}, "json" );
			 	
			 	$.post( "popUpPurchasingNewFosSelectBoxPosType.do", "", function( data ) {
			 		var temp = {};
			 		temp['value'] = '';
			 		temp['text'] = '선택';
			 		data.unshift(temp);
					$( '#gridPosList' ).setObject( {
						value : 'value',
						text : 'text',
						name : 'pos_type',
						data : data
					} );
				}, "json" );
			 	 $.ajaxSetup({async: true});
		 },
		 loadComplete: function (data) {
			var $this = $(this);
			if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			    // because one use repeatitems: false option and uses no
			    // jsonmap in the colModel the setting of data parameter
			    // is very easy. We can set data parameter to data.rows:
			    $this.jqGrid('setGridParam', {
			        datatype: 'local',
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

			//승인 안닌것만 색깔 처리
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				//수정 및 결재 가능한 리스트 색상 변경
				var is_approved = $(this).getCell( rows[i], "is_approved" );
				if( is_approved == "N" ) {
					fn_buttonDisabled2($("#btnAdd"));
					$(this).jqGrid( 'setCell', rows[i], 'master', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'dwg_no', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'dwg_desc', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'pos_type', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'item_type', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'cause_dept', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'is_cost', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'extra_cost', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'pos_rev', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'creation_date', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'is_approved', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'is_pos', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'remark', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'oper', '', { color : 'black', background : '#FFFFCC' } );
					if($(this).jqGrid('getCell',rows[i],'pos_type') == "A"){
						var ary = ['item_type','is_cost'];
						disableRow($(this),rows[i],ary,'');
					}
					//아이템 선택하고 왔을경우
					if($("#p_pos_rev").val() != ""|| ($("#p_pos_rev").val() == "" && $("#p_pur_no").val().length > 0)){
						var ary = ['item_type'];
						$(this).jqGrid( 'setCell', rows[i], 'item_type', 'Y', { color : 'black', background : '#FFFFCC' } );
						disableRow($(this),rows[i],ary,'');
					}
				} else {
					var ary = ['chk_state','master','dwg_no','dwg_desc','pos_type','item_type','cause_dept','is_cost','extra_cost',
							'pos_rev','creation_date','is_approved','is_pos','remark'];
					disableRow($(this),rows[i],ary);
					$(this).jqGrid( 'setCell', rows[i], 'oper', '', { color : 'black', background : '#FFFFCC' } );
				}
			}
		},
		gridComplete : function(){
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				 var date = $(this).getCell( rows[i], "creation_date" );
				 var is_approved = gridObj.getCell( rows[i], "is_approved" );
				 if(date == "" && is_approved == ""){
					fn_buttonDisabled2($("#btnAdd"));
					$(this).jqGrid( 'setCell', rows[i], 'master', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'dwg_no', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'dwg_desc', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'pos_type', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'item_type', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'cause_dept', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'is_cost', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'extra_cost', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'pos_rev', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'creation_date', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'is_approved', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'is_pos', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'remark', '', { color : 'black', background : '#FFFFCC' } );
					
					//아이템 선택하고 왔을경우
					if($("#p_pos_rev").val() != "" || ($("#p_pos_rev").val() == "" && $("#p_pur_no").val().length > 0)){
						var ary = ['item_type'];
						$(this).jqGrid( 'setCell', rows[i], 'item_type', 'Y', { color : 'black', background : '#FFFFCC' } );
						disableRow($(this),rows[i],ary,'');
					}
				 }
			}
		}
		
	}); //end of jqGrid
	
	//jqGrid 크기 동적화
	resizeJqGridWidth( $(window), $( "#gridPosList" ),undefined, 0.8);
	
	
	//########  닫기버튼 ########//
	$("#btnClose").click(function(){
		window.close();					
	});
	
	$("#btnSave").click(function(){
		var rows = gridObj.getDataIDs();
		var rowsData = gridObj.jqGrid('getRowData', rows[0]);
		
		if(rowsData.pos_type == ""){ alert("항목을 선택을 하여 주십시오."); return;}
		else if(rowsData.item_type == ""){alert("ITEM 선택을 하여 주십시오."); return;}
		else if(rowsData.file_id == ""){alert("파일 업로드부터 진행하여 주십시오."); return;}
		else if(rowsData.is_cost == ""){alert("비용발생 여부에 대하여 표시하여 주십시오."); return;}
		
		if(rowsData.oper == "I"){
			if(rowsData.item_type == "N"){
				if(!confirm("SAVE와 동시에 대상 DATA 확정되어 후행부서 전달 됩니다.\n진행하시겠습니까?"))return;
			}
			
			if($("#p_pos_rev").val() == "" && $("#p_pur_no").val().length > 0){
				$("check_"+rows[0]).prop("checked",true);
				$("check_"+rows[0]).val("Y");
			}
		} else {
			
		}
		gridObj.saveCell(kRow, idCol);
		var chmResultRows = [];
		
		getChangedChmResultData(function(data) {
			lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3'});
			
			chmResultRows = data;
			
			var dataList = { chmResultList : JSON.stringify(chmResultRows) };
			
			var url = 'popUpPurchasingNewPosInsert.do';
			var formData = fn_getFormData('#application_form');
			//객체를 합치기. dataList를 기준으로 formData를 합친다.
			var parameters = $.extend({}, dataList, formData);
			
			$.post(url, parameters, function(data){
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_buttonEnable2($("#btnAdd"));
					
					//main에서 호출하는 것이 아닌 다른 팝업에서 호출하였을 경우
					if($("#p_callback").val() != "" && $("#p_callback").val() != "N"){
						if($("#p_pos_rev").val() != "" && rowsData.chk_state == "N"){
							data.p_callbackmsg += ",N";
						} else {
							data.p_callbackmsg += ",Y";
							if(data.p_callbackmsg.indexOf("undefined") > -1){
								data.p_callbackmsg = rowsData.file_id+","+rowsData.pos_rev+",Y";
							}
						}
						opener.popUpPosCallBack(data);
						window.close();
						return;
					}
					
					//아이템 선택하고 왔을경우
					if($("#p_pos_rev").val() != "" || ($("#p_pos_rev").val() == "" && $("#p_pur_no").val().length > 0)){
						opener.$("#btnSearch").click();
						window.close();
						return;
					}
					gridObj.closest('.ui-jqgrid-bdiv').scrollLeft(0);
					gridObj.jqGrid( 'setGridParam', {
						mtype : 'POST',
						url : 'popUpPurchasingNewPosList.do',
						datatype : 'json',
						page : 1,
						postData : fn_getFormData( '#application_form' )
					} ).trigger( 'reloadGrid' );
				}
			}, "json").error(function() {
				alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			}).always(function() {
				lodingBox.remove();
			});
		});
		
		/* var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
		$.post( "popUpPurchasingPosInsert.do", $("#application_form").serialize(), function( data ) {
			alert("저장 성공");
			loadingBox.remove();
		},"json"); */
	});
	
	$("#btnAdd").click(function(){
		/*로딩 시 입력 라인 추가*/
		var master = $("#p_master").val();
		var dwgNo = $("#p_dwg_no").val();
		var rows = gridObj.getDataIDs();
		var rev = rows.length > 0 ? prependZero(parseInt(gridObj.getCell( rows[0], "pos_rev"))+1,3) : prependZero(1,3);
		
		if(rows.length > 0){
			var is_approved = gridObj.getCell( rows[0], "is_approved" );
			if(is_approved == "N" || is_approved == ""){
				alert(is_approved == "N" ? "승인되지 않은 항목이 있습니다." : is_approved == "" ? "현재 입력중인 행이 있습니다." : "ERROR");
				return;
			}
		}
		
		var newData = [{
						master		:	master
            			,dwg_no		:	dwgNo
            			,pos_rev 	: 	rev
            			,pos_type	:	''
            			,item_type	:	''
            			,cause_dept : 	'${loginUser.dwg_dept_code}' 
            			,extra_cost :	'0'
            			,is_cost	:	''
            			,is_approved:	''
            			,is_pos		:	''
            			,oper 		:	'I'
            }];
		gridObj.jqGrid('addRowData', $.jgrid.randId(), newData[0], "first");
	});
	
	//########  Upload CLICK ########//
	$("#btnUpload").click(function(){		
		var myGrid = gridObj;
		var rows = myGrid.getDataIDs();
		
		//row 수가 0일때
		if (myGrid.getGridParam("reccount") == "0"){
			alert("항목이 존재하지 않습니다.");
			return;
		}
		
		if(myGrid.jqGrid ('getCell', rows[0], 'is_approved') == "Y"){
			alert("업로드를 할 수 있는 항목이 없습니다.");
			return;
		}
		
		//열려 있는 Text Box를 그리드로 반영(저장) 시킴.
		myGrid.saveCell(kRow, idCol );
							
		var vDwgNo = "";
		var vMaster = "";
		var vPosRev = "";
		var vFileId = "";
		//그리드 첫번째 행 정보를 가져옴
    	vDwgNo = myGrid.jqGrid ('getCell', rows[0], 'dwg_no');				        
    	vMaster = myGrid.jqGrid ('getCell', rows[0], 'master'); 
    	vPosRev = myGrid.jqGrid ('getCell', rows[0], 'pos_rev'); 
    	vFileId = myGrid.jqGrid ('getCell', rows[0], 'file_id');
    	
    	if(vFileId != "") alert("기존 파일이 있습니다. 업로드 이후 저장 시 업로드한 파일로 변경됩니다.");

		url = "popUpPurchasingNewPosUpload.do?master="+vMaster+"&dwg_no="+vDwgNo+"&pos_rev="+vPosRev;

		var nwidth = 570;
		var nheight = 100;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;
	
		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";
		window.open(url,"winpop",sProperties);
	});
	
	
});
</script>
</body>
</html>
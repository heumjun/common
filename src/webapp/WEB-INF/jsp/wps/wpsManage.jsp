<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WPS 관리</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.totalEaArea {
		position: relative;
		margin-left: 10px;
		margin-right: 0px;
		padding: 4px 4px 6px 4px;
		font-weight: bold;
		border: 1px solid #ccc;
		background-color: #D7E4BC;
		vertical-align: middle;
	}
	
	.onMs {
		background-color: #FFFA94;
	}
	
	.sscType {
		color: #324877;
		font-weight: bold;
	}
</style>
</head>

<body>
<form id="application_form" name="application_form" action="wpsFileUpLoadAction.do" method="POST" enctype="multipart/form-data">
	<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
	
	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			WPS 관리
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		
		<table class="searchArea conSearch" >
			<col width="60">
			<col width="100">
			<col width="60">
			<col width="130">
			<col width="60">
			<col width="100">
			<col width="60">
			
			<col width="60">
			<col width="130">
			<col width="60">
			<col width="130">
			
			<tr>
				<td>Wps No</td>
				<td>
					<input type="text" id="i_wps_no" name="i_wps_no" />
				</td>
				<td>Welding Process</td>
				<td>
					<select id="i_process_type" name="i_process_type"></select>
				</td>
				<td>Welding Type</td>
				<td colspan="2">
					<select id="i_welding_type" name="i_welding_type"></select>
				</td>
				<td>Thick</td>
				<td><input type="text" id="i_thick_range_from" name="i_thick_range_from" /></td>
				<td>Range</td>
				<td><input type="text" id="i_thick_range_to" name="i_thick_range_to" /></td>
			</tr>
			<tr>
				<td>Joint Type</td>
				<td>
					<select id="i_plate_type" name="i_plate_type"></select>
				</td>
				<td>consumable</td>
				<td colspan="3"><input type="text" id="i_consumable" name="i_consumable" style="width: 450px;" /></td>
				<td>remark</td>
				<td colspan="4"><input type="text" id="i_remark" name="i_remark" style="width: 600px;" /></td>
			</tr>
			<tr>
				<td>파일 정보</td>
				<td colspan="9">
					<input type="file" style="width:500px" id="uploadFile" name="uploadFile" accept=".pdf" />
				</td>
				<td>
					<div class="button endbox">
						<input type="button" class="btn_blue" id="btnSubmit" value="등록" onclick="uploadAction()"/>
					</div>
				</td>
			</tr>
		</table>
		<br />
			 
		<table class="searchArea conSearch">
			<col width="100">
			<col width="120">
			<col width="100">
			<col width="150">
			<col width="100">
			<col width="150">
			<col width="*" style="min-width:280px">

			<tr>
				<th>Wps No</th>
				<td>
					<input type="text" id="p_wps_no" name="p_wps_no" style="width: 80px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
				</td>
	
				<th>Joint Type</th>
				<td>
					<select type="text" id="p_plate_type" name="p_plate_type" class="toUpper" style="width:120px;"></select>
				</td>
	
				<th>Welding Process</th>
				<td>
					<select type="text" id="p_process_type" name="p_process_type" class="toUpper" style="width:120px;"></select>
				</td>
				
				<td style="border-left:none; padding:10px 0 10px 0;">
					<div class="button endbox">
					<c:if test="${userRole.attribute4 == 'Y'}">
					<input type="button" id="btnSave" name="btnSave" value="저장"  class="btn_blue"/>
					</c:if>
					<c:if test="${userRole.attribute1 == 'Y'}">
					<input type="button" id="btnSearch" name="btnSearch" value="조회"  class="btn_blue"/>
					</c:if>
					</div>
				</td>
			</tr>
		</table>
		
		<div id="leftDiv"  class="content" style="position:relative; float: left; width: 100%;">
			<div style="float:left; width: 69.5%;" id="masterDiv" >
				<table id = "jqGridList"></table>
				<div   id = "btnjqGridList"></div>
				<div>
					<dl>
						<dd style="float: left; text-align: right; height: 20px; width: 20%; margin: 20px 5px 10px 0px;">
							<span class="pop_tit" style="display:inline-block; width:99%;"><strong>Consumable</strong></span>
						</dd>
						<dd style="float: left; height: 20px; width: 79%; margin: 20px 0px 10px 0px;">
							<input type="text" style="width:100%; border:1px solid #d0d9e1;" id="p_consumable" name="p_consumable" readonly="readonly"/>
						</dd>
					</dl>
					<dl>
						<dd style="float: left; text-align: right; height: 20px; width: 20%; margin: 0px 5px 10px 0px;">
							<span class="pop_tit" style="display:inline-block; width:99%;"><strong>Remark</strong></span>
						</dd>
						<dd style="float: left; height: 20px; width: 79%; margin: 0px 0px 10px 0px;">
							<input type="text" style="width:100%; border:1px solid #d0d9e1;" id="p_remark" name="p_remark" readonly="readonly"/>
						</dd>
					</dl>
				</div>
			</div>
			<div style="float:right; width: 29.5%;" id="positionDiv">
				<legend class="sc_tit sc_tit2">Welding Position</legend>
				<table id = "jqGridPositionList"></table>
				<div   id = "btnjqGridPositionList"></div>
				
				<legend class="sc_tit sc_tit2">Approval Class</legend>
				<table id = "jqGridApprovalList"></table>
				<div   id = "btnjqGridApprovalList"></div>
				
				<legend class="sc_tit sc_tit2">Qualitied Base Metal</legend>
				<table id = "jqGridMetalList"></table>
				<div   id = "btnjqGridMetalList"></div>
			</div>
		</div>	
		
		
	</div> <!-- .mainDiv end -->
</form>
</body>
<script type="text/javascript">

var idRow;
var idCol;
var kRow;
var kCol;

var resultData = [];
var resultPositionData = [];
var resultApprovalData = [];
var resultMetalData = [];

var menuId = '';

var jqGridObj = $('#jqGridList');
var jqGridPositionObj = $('#jqGridPositionList');
var jqGridApprovalObj = $('#jqGridApprovalList');
var jqGridMetalObj = $('#jqGridMetalList');

//SelectBox Setting
$(function() {
	
	// 검색 SelectBox
	if(typeof($("#p_plate_type").val()) !== 'undefined'){
		getAjaxHtml($("#p_plate_type"), "wpsPlateTypeSelectBoxDataList.do?sb_type=sel", null, null);
	}
	if(typeof($("#p_process_type").val()) !== 'undefined'){
		getAjaxHtml($("#p_process_type"), "wpsProcessTypeSelectBoxDataList.do?sb_type=sel", null, null);
	}
	
	// 등록 SelectBox
	if(typeof($("#i_process_type").val()) !== 'undefined'){
		getAjaxHtml($("#i_process_type"), "wpsProcessTypeSelectBoxDataList.do?sb_type=sel", null, null);
	}
	if(typeof($("#i_welding_type").val()) !== 'undefined'){
		getAjaxHtml($("#i_welding_type"), "wpsTypeSelectBoxDataList.do?sb_type=sel", null, null);
	}
	if(typeof($("#i_plate_type").val()) !== 'undefined'){
		getAjaxHtml($("#i_plate_type"), "wpsPlateTypeSelectBoxDataList.do?sb_type=sel", null, null);
	}
	
});

// Main Grid 컬럼 정의
function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'WPS_ID' ,name:'wps_id' , index:'wps_id' ,width:5 ,align:'center', sortable:false, editable : true, title:false, hidden: true});
	gridColModel.push({label:'Wps_No' ,name:'wps_no' , index:'wps_no' ,width:80 ,align:'left', sortable:false, editable : true, title:false});
	gridColModel.push({label:'PROCESS_TYPE', name:'process_type', width:50, align:'center', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'Welding Process' ,name:'process_type_desc' , index:'process_type_desc' ,width:120 ,align:'left', title:false, sortable:false, editable : true,
		edittype : "select",
  		editrules : { required : false },
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "wpsProcessTypeSelectBoxGridList.do";
				return url;
			},
  			buildSelect: function(data){
  				
  				if(typeof(data)=='string'){
     				data = $.parseJSON(data);
    			}
  				
 				var rtSlt = '<select id="wpsProcessType" name="wpsProcessType" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="'+data[idx].sb_value+'" >'+data[idx].sb_name+'</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.jqGrid('setCell', rowId, 'process_type', e.target.value);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.jqGrid('setCell', rowId, 'process_type', e.target.value);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.jqGrid('setCell', rowId, 'process_type', e.target.value);
            	}
            }]
  		 }
	});
	gridColModel.push({label:'welding_type', name:'welding_type', width:50, align:'center', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'Welding Type' ,name:'welding_type_desc' , index:'welding_type' ,width:120 ,align:'left', title:false, sortable:false, editable : true,
		edittype : "select",
  		editrules : { required : false },
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "wpsTypeSelectBoxGridList.do";
				return url;
			},
  			buildSelect: function(data){
  				
  				if(typeof(data)=='string'){
     				data = $.parseJSON(data);
    			}
  				
 				var rtSlt = '<select id="wpsProcessType" name="wpsProcessType" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="'+data[idx].sb_value+'" >'+data[idx].sb_name+'</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.jqGrid('setCell', rowId, 'welding_type', e.target.value);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.jqGrid('setCell', rowId, 'welding_type', e.target.value);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.jqGrid('setCell', rowId, 'welding_type', e.target.value);
            	}
            }]
  		 }
	});
	gridColModel.push({label:'Thick' ,name:'thick_range_from' , index:'thick_range_from' ,width:60 ,align:'right', title:false, sortable:false, editable : true});
	gridColModel.push({label:'Range' ,name:'thick_range_to' , index:'thick_range_to' ,width:60 ,align:'right', title:false, sortable:false, editable : true});
	gridColModel.push({label:'PLATE_TYPE', name:'plate_type', width:50, align:'center', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'Joint Type' ,name:'plate_type_desc' , index:'plate_type_desc' ,width:120 ,align:'left', title:false, sortable:false, editable : true,
		edittype : "select",
  		editrules : { required : false },
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "wpsPlateTypeSelectBoxGridList.do";
				return url;
			},
  			buildSelect: function(data){
  				
  				if(typeof(data)=='string'){
     				data = $.parseJSON(data);
    			}
  				
 				var rtSlt = '<select id="wpsProcessType" name="wpsProcessType" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="'+data[idx].sb_value+'" >'+data[idx].sb_name+'</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.jqGrid('setCell', rowId, 'plate_type', e.target.value);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.jqGrid('setCell', rowId, 'plate_type', e.target.value);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    jqGridObj.jqGrid('setCell', rowId, 'plate_type', e.target.value);
            	}
            }]
  		 }
	});
	gridColModel.push({label:'승인일' ,name:'approve_date' , index:'approve_date' ,width:120 ,align:'center', title:false, sortable:false, editable : false});
	gridColModel.push({label:'첨부' ,name:'attach_file' , index:'attach_file' ,width:60 ,align:'center', title:false, sortable:false, editable : false, formatter: uploadFormatter});
	gridColModel.push({label:'CONSUMABLE' ,name:'consumable' , index:'consumable' ,width:120 ,align:'center', title:false, sortable:false, editable : true, hidden: true});
	gridColModel.push({label:'REMARK' ,name:'remark' , index:'remark' ,width:120 ,align:'center', title:false, sortable:false, editable : true, hidden: true});
	gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden: true} );
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).keydown(function (e) { 
	if (e.keyCode == 27) { 
		e.preventDefault();
	} // esc 막기
	if(e.target.nodeName != "INPUT"){
		if(e.keyCode == 8) {
			return false;
		}
	}
});

$(document).ready(function(){
	
	jqGridObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'',
	    postData : fn_getFormData('#application_form'),
	    colModel:gridColModel,
	    gridview: true,
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit:true,
	    multiselect: false, 
	    rownumbers : true,
	    cellEdit : true, // grid edit mode 1
		cellsubmit : 'clientArray', // grid edit mode 2
	    pager: $('#btnjqGridList'),
	    rowList:[100,500,1000],
	    recordtext: '내용 {0} - {1}, 전체 {2}',
	    emptyrecords:'조회 내역 없음',
	    rowNum:100, 
		beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	    	idRow=rowid;
	    	idCol=iCol;
	    	kRow = iRow;
	    	kCol = iCol;
		},
		afterSaveCell : chmResultEditEnd,
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
   			var currentPageIndex  = parseInt(jqGridObj.getGridParam("page"));// 페이지 인덱스
   			var lastPageX         = parseInt(jqGridObj.getGridParam("lastpage"));  
   			var pages = 1;
   			var rowNum 			  = 100;	   			
   			if (pgButton == "user") {
   				if (pageIndex > lastPageX) {
   			    	pages = lastPageX
   			    } else pages = pageIndex;
   			}
   			else if(pgButton == 'next_btnjqGridList'){
   				pages = currentPageIndex+1;
   			} 
   			else if(pgButton == 'last_btnjqGridList'){
   				pages = lastPageX;
   			}
   			else if(pgButton == 'prev_btnjqGridList'){
   				pages = currentPageIndex-1;
   			}
   			else if(pgButton == 'first_btnjqGridList'){
   				pages = 1;
   			}
 	   		else if(pgButton == 'records') {
   				rowNum = $('.ui-pg-selbox option:selected').val();                
   			}
   			$(this).jqGrid("clearGridData");
   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
		 },		
		 loadComplete: function (data) {
			var $this = $(this);
			if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			    $this.jqGrid('setGridParam', {
			        datatype: 'local',
			        data: data.rows,
			        pageServer: data.page,
			        recordsServer: data.records,
			        lastpageServer: data.total
			    });
			
			    this.refreshIndex();
			
			    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
			var rowIdx = kRow-1;
			
			var cm = jqGridObj.jqGrid('getGridParam', 'colModel');
			
			var item = jqGridObj.getRowData(rowid);
			jqGridObj.setColProp('wps_no',{editable:false});
			jqGridObj.setColProp('approve_date',{editable:false});
			
			if(cm[iCol].name == 'wps_no' || cm[iCol].name == 'approve_date'){
				
				$("#p_consumable").val(item.consumable);
				$("#p_remark").val(item.remark);
				
				var wps_id = item.wps_id;
						
				// PositionCodeList
				var iUrl = "wpsPositionCodeList.do?p_wps_id=" + wps_id;
				jQuery("#jqGridPositionList").jqGrid('setGridParam',{
					url:iUrl
					,mtype: 'POST'
					,datatype:'json'
					,page:1
					,postData: fn_getFormData('#application_form')
				}).trigger("reloadGrid");
				
				// ApprovalCodeList
				iUrl = "wpsApprovalCodeList.do?p_wps_id=" + wps_id;
				jQuery("#jqGridApprovalList").jqGrid('setGridParam',{
					url:iUrl
					,mtype: 'POST'
					,datatype:'json'
					,page:1
					,postData: fn_getFormData('#application_form')
				}).trigger("reloadGrid");
				
				// MetalCodeList
				iUrl = "wpsMetalCodeList.do?p_wps_id=" + wps_id;
				jQuery("#jqGridMetalList").jqGrid('setGridParam',{
					url:iUrl
					,mtype: 'POST'
					,datatype:'json'
					,page:1
					,postData: fn_getFormData('#application_form')
				}).trigger("reloadGrid");
				
			}
			
			/* if(cm[iCol].name == 'approve_date'){
				$("#p_consumable").val(item.consumable);
				$("#p_remark").val(item.remark);
				
				var wps_id = item.wps_id;
				var wps_no = item.wps_no;
						
				// PositionCodeList
				var iUrl = "wpsPositionCodeList.do?p_wps_id=" + wps_id;
				jQuery("#jqGridPositionList").jqGrid('setGridParam',{
					url:iUrl
					,mtype: 'POST'
					,datatype:'json'
					,page:1
					,postData: fn_getFormData('#application_form')
				}).trigger("reloadGrid");
				
				// ApprovalCodeList
				iUrl = "wpsApprovalCodeList.do?p_wps_id=" + wps_id;
				jQuery("#jqGridApprovalList").jqGrid('setGridParam',{
					url:iUrl
					,mtype: 'POST'
					,datatype:'json'
					,page:1
					,postData: fn_getFormData('#application_form')
				}).trigger("reloadGrid");
				
				// MetalCodeList
				iUrl = "wpsMetalCodeList.do?p_wps_id=" + wps_id;
				jQuery("#jqGridMetalList").jqGrid('setGridParam',{
					url:iUrl
					,mtype: 'POST'
					,datatype:'json'
					,page:1
					,postData: fn_getFormData('#application_form')
				}).trigger("reloadGrid");
			} */
			
			if(cm[iCol].name == 'attach_file'){
				
				/* if(item.oper == 'I') {
					var url = "popUpWpsManageFileUploadPage.do?p_wps_id="+wps_id;
					window.open(url,"","width=520px,height=200px,top=300,left=400,resizable=no,scrollbars=auto,status=no");	
				} */
			        
			}
			
		},
		 gridComplete : function() {
			var rows = $( "#jqGridList" ).getDataIDs();

			for( var i = 0; i < rows.length; i++ ) {
				var oper = $( "#jqGridList" ).getCell( rows[i], "oper" );

				$( "#jqGridList" ).jqGrid( 'setCell', rows[i], 'welding_process', '', { color : 'black', background : '#DADADA' } );
				$( "#jqGridList" ).jqGrid( 'setCell', rows[i], 'welding_type', '', { color : 'black', background : '#DADADA' } );
				$( "#jqGridList" ).jqGrid( 'setCell', rows[i], 'joint_type', '', { color : 'black', background : '#DADADA' } );
			}

			//미입력 영역 회색 표시
			$( "#jqGridList .disables" ).css( "background", "#DADADA" );
		}
	}); //end of jqGrid
	
	//그리드 버튼 숨김
	/* $("#jqGridList").jqGrid('navGrid', "#btnjqGridList", {
			refresh : false,
			search : false,
			edit : false,
			add : false,
			del : false,								
		}
	); */
	
	//Refresh
	/* $("#jqGridList").navButtonAdd('#btnjqGridList', {
		caption : "",
		buttonicon : "ui-icon-refresh",
		onClickButton : function() {
			fn_search();
		},
		position : "first",
		title : "Refresh",
		cursor : "pointer"
	}); */
	
	//Del 버튼
	/* $("#jqGridList").navButtonAdd('#btnjqGridList', {
		caption : "",
		buttonicon : "ui-icon-minus",
		onClickButton : deleteRow,
		position : "first",
		title : "Del",
		cursor : "pointer"
	}); */

	jqGridPositionObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'',
	    postData : fn_getFormData('#application_form'),
	    colNames : [ 'WpsId', 'Code', 'Description', 'POSTION_CODE', '<input type="checkbox" id="checkAll" />', '', 'oper' ],
	    colModel : [ 
					{ index:'wps_id', name:'wps_id', width:80, align:'center', sortable:true, title:false, hidden: true  },
                    { index:'code_name', name:'code_name', width:80, align:'center', sortable:true, title:false  },  
                    { index:'code_desc', name:'code_desc', width:200, align:'center', sortable:true, title:false, editable:true}, 
                    { index:'postion_code', name:'postion_code', width:25, align:'center', sortable:false, title:false, hidden: true},
                    { index:'enable_flag', name:'enable_flag', width: 30, editable: true, sortable: false, edittype: 'checkbox', formatter: "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
                    { index :'enable_flag_changed', name :'enable_flag_changed', hidden: true},
                    { index:'oper', name:'oper', width:25, align:'center', sortable:false, title:false, hidden: true}
        		  ],
	    gridview: true,
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit:true,
	    multiselect: false,
	    //pager: $('#btnjqGridPositionList'),
	    rowList:[100,500,1000],
	    recordtext: '내용 {0} - {1}, 전체 {2}',
	    emptyrecords:'조회 내역 없음',
	    rowNum : 9999, 
	    height : $(window).height()/2-250,
		beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	    	idRow=rowid;
	    	idCol=iCol;
	    	kRow = iRow;
	    	kCol = iCol;
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
	   			var currentPageIndex  = parseInt(jqGridPositionObj.getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt(jqGridPositionObj.getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnjqGridPositionList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridPositionList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridPositionList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridPositionList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
		 },		
		 loadComplete: function (data) {
			var $this = $(this);
			if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			    $this.jqGrid('setGridParam', {
			        datatype: 'local',
			        data: data.rows,
			        pageServer: data.page,
			        recordsServer: data.records,
			        lastpageServer: data.total
			    });
			
			    this.refreshIndex();
			
			    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
		 gridComplete : function() {
			var rows = $( "#jqGridPositionList" ).getDataIDs();

			for( var i = 0; i < rows.length; i++ ) {
				var oper = $( "#jqGridPositionList" ).getCell( rows[i], "oper" );

				if( oper == "" ) {
					$( "#jqGridPositionList" ).jqGrid( 'setCell', rows[i], 'code_name', '', { color : 'black', background : '#DADADA' } );
					$( "#jqGridPositionList" ).jqGrid( 'setCell', rows[i], 'code_desc', '', { color : 'black', background : '#DADADA' } );
				}
			}

			//미입력 영역 회색 표시
			$( "#jqGridPositionList .disables" ).css( "background", "#DADADA" );
		}
	}); //end of jqGrid
	
	//jqGridApprovalObj
	jqGridApprovalObj.jqGrid({
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'',
	    postData : fn_getFormData('#application_form'),
	    colNames : [ 'WpsId', 'Code', 'Description', 'APPROVAL_CLASS_CODE', '<input type="checkbox" id="checkAll" />', '', 'oper' ],
	    colModel : [ 
					{ index:'wps_id', name:'wps_id', width:80, align:'center', sortable:true, title:false, hidden: true  },
                    { index:'code_name', name:'code_name', width:80, align:'center', sortable:true, title:false  },  
                    { index:'code_desc', name:'code_desc', width:200, align:'center', sortable:true, title:false, editable:true},
                    { index:'approval_class_code', name:'approval_class_code', width:25, align:'center', sortable:false, title:false, hidden: true},
                    { index:'enable_flag', name:'enable_flag', width: 30, editable: true, sortable: false, edittype: 'checkbox', formatter: "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
                    { index:'enable_flag_changed', name :'enable_flag_changed', hidden: true},
                    { index:'oper', name:'oper', width:25, align:'center', sortable:false, title:false, hidden: true}
        		  ],
	    gridview: true,
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit:true,
	    multiselect: false,
	    //pager: $('#btnjqGridApprovalList'),
	    rowList:[100,500,1000],
	    recordtext: '내용 {0} - {1}, 전체 {2}',
	    emptyrecords:'조회 내역 없음',
	    rowNum: 9999, 
	    height : $(window).height()/2-250,
		beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	    	idRow=rowid;
	    	idCol=iCol;
	    	kRow = iRow;
	    	kCol = iCol;
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
	   			var currentPageIndex  = parseInt(jqGridApprovalObj.getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt(jqGridApprovalObj.getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnjqGridApprovalList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridApprovalList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridApprovalList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridApprovalList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
		 },		
		 loadComplete: function (data) {
			var $this = $(this);
			if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			    $this.jqGrid('setGridParam', {
			        datatype: 'local',
			        data: data.rows,
			        pageServer: data.page,
			        recordsServer: data.records,
			        lastpageServer: data.total
			    });
			
			    this.refreshIndex();
			
			    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
		 gridComplete : function() {
			var rows = $( "#jqGridApprovalList" ).getDataIDs();

			for( var i = 0; i < rows.length; i++ ) {
				var oper = $( "#jqGridApprovalList" ).getCell( rows[i], "oper" );

				if( oper == "" ) {
					$( "#jqGridApprovalList" ).jqGrid( 'setCell', rows[i], 'code_name', '', { color : 'black', background : '#DADADA' } );
					$( "#jqGridApprovalList" ).jqGrid( 'setCell', rows[i], 'code_desc', '', { color : 'black', background : '#DADADA' } );
				}
			}

			//미입력 영역 회색 표시
			$( "#jqGridApprovalList .disables" ).css( "background", "#DADADA" );
		}		           
	}); //end of jqGrid
	
	jqGridMetalObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'',
	    postData : fn_getFormData('#application_form'),
	    colNames : [ 'WpsId', 'Code', 'Description', 'BASE_METAL_CODE', '<input type="checkbox" id="checkAll" />', '', 'oper' ],
	    colModel : [ 
					{ index:'wps_id', name:'wps_id', width:80, align:'center', sortable:true, title:false, hidden: true  },
                    { index:'code_name', name:'code_name', width:80, align:'center', sortable:true, title:false  },  
                    { index:'code_desc', name:'code_desc', width:200, align:'center', sortable:true, title:false, editable:true},
                    { index:'base_metal_code', name:'base_metal_code', width:25, align:'center', sortable:false, title:false, hidden: true},
                    { index:'enable_flag', name:'enable_flag', width: 30, editable: true, sortable: false, edittype: 'checkbox', formatter: "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
                    { index:'enable_flag_changed', name :'enable_flag_changed', hidden: true},
                    { index:'oper', name:'oper', width:25, align:'center', sortable:false, title:false, hidden: true}
        		  ],
	    gridview: true,
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit:true,
	    multiselect: false,
	    //pager: $('#btnjqGridMetalList'),
	    rowList:[100,500,1000],
	    recordtext: '내용 {0} - {1}, 전체 {2}',
	    emptyrecords:'조회 내역 없음',
	    rowNum:9999, 
	    height : $(window).height()/2-250,
		beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	    	idRow=rowid;
	    	idCol=iCol;
	    	kRow = iRow;
	    	kCol = iCol;
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
	   			var currentPageIndex  = parseInt(jqGridMetalObj.getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt(jqGridMetalObj.getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnjqGridMetalList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridMetalList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridMetalList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridMetalList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
		 },		
		 loadComplete: function (data) {
			var $this = $(this);
			if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
			    $this.jqGrid('setGridParam', {
			        datatype: 'local',
			        data: data.rows,
			        pageServer: data.page,
			        recordsServer: data.records,
			        lastpageServer: data.total
			    });
			
			    this.refreshIndex();
			
			    if ($this.jqGrid('getGridParam', 'sortname') !== '') {
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
		 gridComplete : function() {
			var rows = $( "#jqGridMetalList" ).getDataIDs();

			for( var i = 0; i < rows.length; i++ ) {
				var oper = $( "#jqGridMetalList" ).getCell( rows[i], "oper" );

				if( oper == "" ) {
					$( "#jqGridMetalList" ).jqGrid( 'setCell', rows[i], 'code_name', '', { color : 'black', background : '#DADADA' } );
					$( "#jqGridMetalList" ).jqGrid( 'setCell', rows[i], 'code_desc', '', { color : 'black', background : '#DADADA' } );
				}
			}

			//미입력 영역 회색 표시
			$( "#jqGridMetalList .disables" ).css( "background", "#DADADA" );
		}	           
	}); //end of jqGrid

	// jqGrid 크기 동적화
	fn_insideGridresize( $(window), $( "#masterDiv" ), $( "#jqGridList" ), -310, 0.5 );
	
	fn_insideGridresize( $(window), $( "#positionDiv" ), $( "#jqGridPositionList" ) , 72, 0.5 );
	fn_insideGridresize( $(window), $( "#positionDiv" ), $( "#jqGridApprovalList" ) , 72, 0.5 );
	fn_insideGridresize( $(window), $( "#positionDiv" ), $( "#jqGridMetalList" ) , 72, 0.5 );
	
	
	// Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
	$("#btnSearch").click(function(){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		if(uniqeValidation()){
			fn_search();
		}
	});
	
	//저장버튼
	$("#btnSave").click(function() {
		fn_save();
	});
	
});

function uploadAction() {
	var mainForm = document.application_form;

    if (mainForm.i_wps_no.value == "") {
        alert("Wps No.는 필수입니다.");
        return;
    }
    
    var process_type = mainForm.i_process_type.value;
	if(process_type == "" || process_type==null) {
		alert("Welidng Process는 필수입니다.");
		return;
	}
	
	var welding_type = mainForm.i_welding_type.value;
	if(welding_type == "" || welding_type==null) {
		alert("Welidng Type는 필수입니다.");
		return;
	}
	
	var thick_range_from = mainForm.i_thick_range_from.value;
	if(thick_range_from == "" || thick_range_from==null) {
		alert("Thick는 필수입니다.");
		return;
	}
	
	var thick_range_to = mainForm.i_thick_range_to.value;
	if(thick_range_to == "" || thick_range_to==null) {
		alert("Range는 필수입니다.");
		return;
	}
	
	var plate_type = mainForm.i_plate_type.value;
	if(plate_type == "" || plate_type==null) {
		alert("Joint Type는 필수입니다.");
		return;
	}
	
	var fileName = mainForm.uploadFile.value;
	if(fileName == "" || fileName==null) {
		alert("첨부문서가 없습니다.");
		return;
	}
	
	var fileValue = mainForm.uploadFile.value.split("\\");
    var fileName = fileValue[fileValue.length-1];
    var fileNm = fileName.split(".");
    var file1 = fileNm[0];
    var file2 = fileNm[1];
    var reg = /([0-9]|[A-Z]){5}/;
    var rst = reg.test(file1);
    if(!rst || !(fileNm[1] == 'pdf' || fileNm[1] == 'PDF')) {
    	alert("올바른 파일을 첨부하여 주십시오.");
		return;
    }
    
    fn_upload();
}

function fn_upload() {
	var mainForm = document.application_form;
	
	if(confirm("업로드 하시겠습니까?"))
    {
		$('#application_form').ajaxForm( {
			// 반환할 데이터의 타입. 'json'으로 하면 IE 에서만 제대로 동작하고 크롬, FF에서는 응답을 수신하지
			// 못하는 문제점을 발견하였다. dataType을 정의하지 않을 경우 기본 값은 null 이다.
			dataType : 'text',
			beforeSerialize : function() {
				// form을 직렬화하기전 엘레먼트의 속성을 수정할 수도 있다.
			},
			beforeSubmit : function() {
				//$('#result').html('uploading...');
			},
			success : function( data ) {
				data.replace(/(<([^>]+)>)/ig,"");
				var jData = JSON.parse(data);
				alert(jData.resultMsg);
				document.location.reload();
				//$('#result').html('');
			}
		} );
		$('#application_form').submit();
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

//검색
function fn_search() {
	
	//모두 대문자로 변환
	$("input[type=text]").each(function(){
		$(this).val($(this).val().toUpperCase());
	});
	
	//검색 시 스크롤 깨짐현상 해결
	jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
	
	var sUrl = "wpsManageList.do";
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
}

// issuer 컬럼 포멧
function issuerFormatter(cellvalue, options, rowObject ) {
	
	if(cellvalue == 'O') {
		return "OWNER";		
	} else if(cellvalue == 'C') {
		return "CLASS"
	} else {
		return "";
	}
	
}

//첨부파일 컬럼 포멧
function fileFormatter(cellvalue, options, rowObject ) {
	
	if(rowObject.receipt_id == null) {
		return '';		
	} else {
		return "<img src=\"./images/icon_file.gif\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"fileView('"+rowObject.receipt_id+"');\">";
	}
}

//첨부파일 다운로드
function fileView( receipt_id ) {
	var attURL = "commentReceiptFileDownload.do?p_receipt_id="+receipt_id;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
    window.open(attURL,"",sProperties);
}

var callback_MenuId = function(menu_id) {
	menuId = menu_id;
}

function uploadFormatter(cellvalue, options, rowObject ) {
	
	if(cellvalue == '') {
		return '';
	} else {
		return "<img src=\"./images/pdf_icon.gif\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"hiddenFrame.go_pdfView('"+rowObject.manual_option+"','" + rowObject.pgm_id + "','" + rowObject.oper +"')\">";	
	}
	//onClick="hiddenFrame.go_pdfView('${loginID}','${item.view_flag}','${item.PART_SEQ_ID}','${item.item_catalog_group_id}');"
}

//Del 버튼
/* function deleteRow() {
	$('#jqGridList').saveCell(kRow, kCol);

	var selrow = $('#jqGridList').jqGrid('getGridParam', 'selrow');
	var item = $('#jqGridList').jqGrid('getRowData', selrow);
	
	if (item.oper == 'I') {
		$('#jqGridList').jqGrid('delRowData', selrow);
	} else {
		item.oper = 'D';

		$('#jqGridList').jqGrid("setRowData", selrow, item);
		var colModel = $( '#jqGridList' ).jqGrid( 'getGridParam', 'colModel' );
		for( var i in colModel ) {
			$( '#jqGridList' ).jqGrid( 'setCell', selrow, colModel[i].name,'', {background : '#FF7E9D' } );
		}
	}

	$('#dataList').resetSelection();
} */

//afterSaveCell oper 값 지정
function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $("#jqGridList").jqGrid('getRowData', irowId);
	if (item.oper != 'I')
		item.oper = 'U';

	$("#jqGridList").jqGrid("setRowData", irowId, item);
	$("input.editable,select.editable", this).attr("editable", "0");
}

//저장
function fn_save() {
	
	$("#jqGridList").saveCell(kRow, idCol);

	// 변경된 체크 박스가 있는지 체크한다.
	var changedData = $("#jqGridPositionList").jqGrid('getRowData');
	for (var i = 1; i < changedData.length + 1; i++) {
		var item = $('#jqGridPositionList').jqGrid('getRowData', i);

		if (item.oper != 'I' && item.oper != 'U') {
			
			if (item.enable_flag_changed != item.enable_flag) {
				item.oper = 'U';
			}

			if (item.oper == 'U') {
				// apply the data which was entered.
				$('#jqGridPositionList').jqGrid("setRowData", i, item);
			}
		}
	}
	
	// 변경된 체크 박스가 있는지 체크한다.
	changedData = $("#jqGridApprovalList").jqGrid('getRowData');
	for (var i = 1; i < changedData.length + 1; i++) {
		var item = $('#jqGridApprovalList').jqGrid('getRowData', i);

		if (item.oper != 'I' && item.oper != 'U') {
			
			if (item.enable_flag_changed != item.enable_flag) {
				item.oper = 'U';
			}

			if (item.oper == 'U') {
				// apply the data which was entered.
				$('#jqGridApprovalList').jqGrid("setRowData", i, item);
			}
		}
	}
	
	// 변경된 체크 박스가 있는지 체크한다.
	changedData = $("#jqGridMetalList").jqGrid('getRowData');
	for (var i = 1; i < changedData.length + 1; i++) {
		var item = $('#jqGridMetalList').jqGrid('getRowData', i);

		if (item.oper != 'I' && item.oper != 'U') {
			
			if (item.enable_flag_changed != item.enable_flag) {
				item.oper = 'U';
			}

			if (item.oper == 'U') {
				// apply the data which was entered.
				$('#jqGridMetalList').jqGrid("setRowData", i, item);
			}
		}
	}

	if (!fn_checkValidate()) {
		return;
	}
	
	

	if (confirm('변경된 데이터를 저장하시겠습니까?') != 0) {
		
		var chmResultRows 			= [];
		var positionResultRows 		= [];
		var approvalResultRows 		= [];
		var metalResultRows 		= [];
		

		//변경된 row만 가져 오기 위한 함수
		getChangedChmResultData(function(data, positionData, approvalData, metalData) {
			lodingBox = new ajaxLoader($('#mainDiv'), {
				classOveride : 'blue-loader',
				bgColor : '#000',
				opacity : '0.3'
			});

			chmResultRows 			= data;
			positionResultRows 		= positionData;
			approvalResultRows 		= approvalData;
			metalResultRows 		= metalData;
			
			var dataList = {
				chmResultList : JSON.stringify(chmResultRows),
				positionResultList : JSON.stringify(positionResultRows),
				approvalResultList : JSON.stringify(approvalResultRows),
				metalResultList : JSON.stringify(metalResultRows)
			};

			var url = 'wpsManageSaveAction.do';
			var formData = fn_getFormData('#application_form');
			
			//객체를 합치기. dataList를 기준으로 formData를 합친다.
			var parameters = $.extend({}, dataList, formData);

			$.post(url, parameters, function(data) {
				if ( data.result == 'success' ) {
					alert(data.resultMsg);
					
					var wps_id = data.wps_id;
					
					// PositionCodeList
					var iUrl = "wpsPositionCodeList.do?p_wps_id=" + wps_id;
					jQuery("#jqGridPositionList").jqGrid('setGridParam',{
						url:iUrl
						,mtype: 'POST'
						,datatype:'json'
						,page:1
						,postData: fn_getFormData('#application_form')
					}).trigger("reloadGrid");
					
					// ApprovalCodeList
					iUrl = "wpsApprovalCodeList.do?p_wps_id=" + wps_id;
					jQuery("#jqGridApprovalList").jqGrid('setGridParam',{
						url:iUrl
						,mtype: 'POST'
						,datatype:'json'
						,page:1
						,postData: fn_getFormData('#application_form')
					}).trigger("reloadGrid");
					
					// MetalCodeList
					iUrl = "wpsMetalCodeList.do?p_wps_id=" + wps_id;
					jQuery("#jqGridMetalList").jqGrid('setGridParam',{
						url:iUrl
						,mtype: 'POST'
						,datatype:'json'
						,page:1
						,postData: fn_getFormData('#application_form')
					}).trigger("reloadGrid");
										
					fn_search();
				}
				
			}, "json").error(function() {
				alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
			}).always(function() {
				lodingBox.remove();
			});
			
		});
		
	}
}

//가져온 배열중에서 필요한 배열만 골라내기 
function getChangedChmResultData(callback) {
	
	var changedData = $.grep($("#jqGridList").jqGrid('getRowData'),
			function(obj) {
				return obj.oper == 'I' || obj.oper == 'U'
						|| obj.oper == 'D';
			});
	var changedPositionData = $.grep($("#jqGridPositionList").jqGrid('getRowData'),
			function(obj) {
				return obj.oper == 'I' || obj.oper == 'U'
						|| obj.oper == 'D';
			});
	var changedApprovalData = $.grep($("#jqGridApprovalList").jqGrid('getRowData'),
			function(obj) {
				return obj.oper == 'I' || obj.oper == 'U'
						|| obj.oper == 'D';
			});
	var changedMetalData = $.grep($("#jqGridMetalList").jqGrid('getRowData'),
			function(obj) {
				return obj.oper == 'I' || obj.oper == 'U'
						|| obj.oper == 'D';
			});

	callback.apply(this, [ changedData.concat(resultData), changedPositionData.concat(resultPositionData), changedApprovalData.concat(resultApprovalData), changedMetalData.concat(resultMetalData) ]);
	
}

//필수입력 체크
function fn_checkValidate() {
	
	var result = true;
	var message = "";
	var nChangedCnt = 0;
	
	var ids = $("#jqGridList").jqGrid('getDataIDs');
	var idsPosition = $("#jqGridPositionList").jqGrid('getDataIDs');
	var idsApproval = $("#jqGridApprovalList").jqGrid('getDataIDs');
	var idsMetal = $("#jqGridMetalList").jqGrid('getDataIDs');

	for (var i = 0; i < ids.length; i++) {
		var oper = jqGridObj.jqGrid('getCell', ids[i], 'oper');
		if (oper == 'I' || oper == 'U') {
			nChangedCnt++;
		}
	}
	
	for (var i = 0; i < idsPosition.length; i++) {
		var oper = jqGridPositionObj.jqGrid('getCell', idsPosition[i], 'oper');
		if (oper == 'I' || oper == 'U') {
			nChangedCnt++;
		}
	}
	
	for (var i = 0; i < idsApproval.length; i++) {
		var oper = jqGridApprovalObj.jqGrid('getCell', idsApproval[i], 'oper');
		if (oper == 'I' || oper == 'U') {
			nChangedCnt++;
		}
	}
	
	for (var i = 0; i < idsMetal.length; i++) {
		var oper = jqGridMetalObj.jqGrid('getCell', idsMetal[i], 'oper');
		if (oper == 'I' || oper == 'U') {
			nChangedCnt++;
		}
	}
	
	if (nChangedCnt == 0) {
		result = false;
		message = "변경된 내용이 없습니다.";
	}

	if (!result) {
		alert(message);
	}

	return result;
}

</script>
</html>
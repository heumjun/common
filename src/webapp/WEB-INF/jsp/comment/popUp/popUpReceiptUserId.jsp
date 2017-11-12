<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수신문서_담당자</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.popMainDiv {
		margin: 10px;
	}
	
	.popMainDiv .WarningArea {
		width: 490px;
		border: 1px solid #ccc;
		padding: 8px;
		margin-bottom: 0px;
	}
	
	.popMainDiv .WarningArea .tit {
		font-size: 12pt;
		margin-bottom: 6px;
		color: red;
		font-weight: bold;
	}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
<input type="hidden" name="p_arrDistinct" value="${p_arrDistinct}" />
<input type="hidden" id="p_etc_user_id" name="p_etc_user_id" value="" />

<div id="mainDiv" class="mainDiv">
	<div class="subtitle">수신문서_담당자</div>
	<table class="searchArea3">
		<col width="50"/>
		<col width="460"/>
		<col width="50"/>
			<tr>
				<th style="background-color: yellow;" >COMMENT</th>
				<td>
					<input type="text" name="p_mail_comment" id="p_mail_comment" value="" style="width: 700px;"/>
				</td>
				<td id="btnApply" name="btnApply" rowspan="2" style="color:#ffffff; font-weight:bold; font-size: 14px; background-color: #0054FF; cursor: pointer;" >APPLY</td>
			</tr>
			<tr>
				<th style="background-color: #B7DEE8; text-decoration: underline;"><a href="javascript:etcMail();">참조메일</a></th>
				<td id="etcMailList">
				</td>
			</tr>
	</table>
	<br />
	<table class="">
		<col width="20%"/>
		<col width="20%"/>
		<col width="10%"/>
		<col width="10%"/>
		<col width="40%"/>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td>
					<div class="button endbox">
						<input type="button" value="ADD" id="btnAdd" class="btn_blue2" />
						<input type="button" value="DELETE" id="btnDel" class="btn_blue2" />
					</div>	
				</td>
			</tr>
	</table>
	<div class="content">
		<table id = "jqGridList"></table>
		<div id = "btnjqGridList"></div>
	</div>
</div>	

</form>
</body>
<script type="text/javascript">
var idRow;
var idCol;
var kRow;
var kCol;
var resultData = [];

var jqGridObj = $('#jqGridList');

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'수신 ID' ,name:'receipt_id' , index:'receipt_id' ,width:80 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 DETAIL ID' ,name:'receipt_detail_id' , index:'receipt_detail_id' ,width:80 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 No' ,name:'receipt_no' , index:'receipt_no' ,width:100 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Project' ,name:'project_no' , index:'project_no' ,width:50 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'문서' ,name:'doc_type' , index:'doc_type' ,width:20 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Issuer' ,name:'issuer' , index:'issuer' ,width:50 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Subject' ,name:'subject' , index:'subject' ,width:200 ,align:'left', title:false, sortable:false});
	gridColModel.push({label:'Issue Date' ,name:'issue_date' , index:'issue_date' ,width:60 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Com No.' ,name:'com_no' , index:'com_no' ,width:60 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'담당팀ID' ,name:'receipt_team_code' , index:'receipt_team_code' ,width:80 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'담당팀' ,name:'receipt_team_name' , index:'receipt_team_name' ,width:80 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'담당파트ID' ,name:'receipt_dept_code' , index:'receipt_dept_code' ,width:80 ,align:'center', sortable:false, title:false, editable:true, hidden: true});
	gridColModel.push({label:'담당파트' ,name:'receipt_dept_name' , index:'receipt_dept_name' ,width:80 ,align:'center', sortable:false, title:false, editable:true,
		edittype : "select",
  		editrules : { required : false },
  		cellattr: function (){return 'class="required_cell"';},
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "commentReceiptGridDeptList.do?sb_type=all&p_dept_code=" + item.receipt_team_code;
				return url;
			},
  			buildSelect: function(data){

  				data = $.parseJSON(data);
  				
 				var rtSlt = '<select id="selectReceiptDept" name="selectReceiptDept" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="' + data[idx].sb_value + '"' + data[idx].selected + '>' + data[idx].sb_name + '</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');

                    jqGridObj.setCell(rowId, 'receipt_user_id', ' ');
                    jqGridObj.setCell(rowId, 'receipt_user_name', ' ');
                    jqGridObj.setCell(rowId, 'receipt_dept_code', e.target.value);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.setCell(rowId, 'receipt_dept_code', e.target.value);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
            		jqGridObj.setCell(rowId, 'receipt_dept_code', e.target.value);
                    
            	}
            }]
  		 }
	});
	gridColModel.push({label:'담당자ID' ,name:'receipt_user_id' , index:'receipt_user_id' ,width:80 ,align:'center', sortable:false, title:false, editable:true, hidden: true});
	gridColModel.push({label:'담당자' ,name:'receipt_user_name' , index:'receipt_user_name' ,width:80 ,align:'center', sortable:false, title:false, editable:true,
		edittype : "select",
  		editrules : { required : false },
  		cellattr: function (){return 'class="required_cell"';},
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "commentReceiptGridUserList.do?sb_type=all&p_dept_code=" + item.receipt_dept_code;
				return url;
			},
  			buildSelect: function(data){

  				data = $.parseJSON(data);
  				
 				var rtSlt = '<select id="selectReceiptUser" name="selectReceiptUser" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="' + data[idx].sb_value + '"' + data[idx].selected + '>' + data[idx].sb_name + '</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	},
  		 	dataEvents: [{
            	type: 'change'
            	, fn: function(e, data) {
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    jqGridObj.setCell(rowId, 'receipt_user_id', e.target.value);
                }
            },{ type : 'keydown'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
                    
                    var key = e.charCode || e.keyCode; 
            		if( key == 13 || key == 9) {
            			jqGridObj.setCell(rowId, 'receipt_user_id', e.target.value);
            		}
                    
            	}
            },{ type : 'blur'
            	, fn : function( e) { 
            		var row = $(e.target).closest('tr.jqgrow');
                    var rowId = row.attr('id');
            		jqGridObj.setCell(rowId, 'receipt_user_id', e.target.value);
            	}
            }]
  		 }
	});
	gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden: true} );
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	jqGridObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'popUpReceiptUserIdList.do',
	    postData : fn_getFormData('#application_form'),
	    colModel:gridColModel,
	    gridview: true,
	    cellEdit : true,
	    cellsubmit : 'clientArray', // grid edit mode 2
	    toolbar: [false, "bottom"],
	    viewrecords: false,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit: true,
	    multiselect: true,
	    //pager: $('#btnjqGridList'),
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
	   			else if(pgButton == 'next_btnjqGridAdminList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridAdminList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridAdminList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridAdminList'){
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
			
			gridColorSetting();
			
			var rows = jqGridObj.getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				
				var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
				
				if(item.receipt_team_code != "${loginUser.upper_dwg_dept_code}") {
					jqGridObj.setCell(rows[i], "receipt_dept_name", '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
					jqGridObj.setCell(rows[i], "receipt_user_name", '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
				} 
				
			}
			
		}		           
	}); //end of jqGrid

	//jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#jqGridList" ), -20 );
	
	$("#btnAdd").click(function(){
		
		jqGridObj.saveCell(kRow, idCol );
		// 첫 행 구함.
		var ids = jqGridObj.jqGrid('getDataIDs');
        //get first id
        var cl = ids[ids.length-1];
        var rowData = jqGridObj.getRowData(cl);

        var item = {};
		var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
		
		for ( var i in colModel )
			item[colModel[i].name] = '';
		
		//첫행에 받은 정보들을 다음 행에 복사
		item.receipt_id = rowData['receipt_id'];
		item.receipt_detail_id = rowData['receipt_detail_id'];
		item.receipt_no = rowData['receipt_no'];
		item.project_no = rowData['project_no'];
		item.doc_type 	= rowData['doc_type'];
		item.issuer 	= rowData['issuer'];
		item.subject 	= rowData['subject'];
		item.issue_date = rowData['issue_date'];
		item.com_no 	= rowData['com_no'];
		item.receipt_team_code = rowData['receipt_team_code'];
		item.receipt_team_name = rowData['receipt_team_name'];
		item.receipt_dept_code = rowData['receipt_dept_code'];
		item.receipt_dept_name = rowData['receipt_dept_name'];
		item.receipt_user_id = rowData['receipt_user_id'];
		item.receipt_user_name = rowData['receipt_user_name'];
		item.oper = 'I';
		
		jqGridObj.resetSelection();
		jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
		
		gridColorSetting();
	});
	
	//del 버튼  클릭
	$("#btnDel").click(function(){
		
		jqGridObj.saveCell(kRow, idCol );
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		var ids = $( "#jqGridList" ).getDataIDs();
		
		if(ids.length - selarrrow.length < 1 ) {
			alert("1개행 이하는 삭제 할수 없습니다.");
		} else {
			
			for(var i=selarrrow.length-1; i>=0; i--) {
				
				var item = jqGridObj.jqGrid("getRowData", selarrrow[i]);
				
				if( item.oper == 'I' ) {
					jqGridObj.jqGrid('delRowData', selarrrow[i]);	
				} else {
					jqGridObj.setCell (selarrrow[i], 'oper','D', '');
					jqGridObj.setRowData(selarrrow[i], false, {background: '#FF0000'});
				}
				
			}
		}
		
	});
	
	$("#btnApply").click(function(e) {
		
		$(this).trigger("keydown", [9]);
		
		jqGridObj.saveCell(kRow, idCol );
		
		var formData = fn_getFormData('#application_form');
		
		if ( $("#p_mail_comment").val() == "" ) {
			alert("COMMENT 내용이 없습니다.");
			return;
		}
		
		var rtn = true;
		var p_arr = new Array();
		var p_arrDistinct = new Array();
		var rows = $( "#jqGridList" ).getDataIDs();
		for ( var i = 0; i < rows.length; i++ ) {
			
			var item = jqGridObj.jqGrid("getRowData", rows[i]);
			
			if(item.receipt_dept_name == "") {
				alert("담당파트가 지정되지 않았습니다.");
				return false;
			}
			
			if( item.receipt_user_name == "" || item.receipt_user_name == " " ) {
				alert("담당자가 지정되지 않았습니다.");
				return false;
			}
			
			if(item.oper == 'I') {
				p_arr.push(item.receipt_dept_name);
			} else {
				p_arrDistinct.push(item.receipt_dept_name);
			}
			
		}
		
		$(p_arr).each(function(index, item) {
			//alert($.inArray(item, p_arr));
			if($.inArray(item, p_arrDistinct) > -1) {
				alert("부서정보가 이미 존재합니다. 확인하세요 : " + item);
				rtn = false;
				return false;
			}
		});
		
		if(!rtn) {
			return false;
		}
		
		//승인 로직
		if(confirm('적용하시겠습니까?')) {
			
			var changeRows = [];
			var args = window.dialogArguments;
			
			getChangedChmResultData(function( data ) {
				
				chmResultRows = data;
				
				for(i=0; i<chmResultRows.length; i++) {
					if(chmResultRows.length == 1 && chmResultRows[i].oper == 'D') {
						alert("1개행 이하는 삭제 할수 없습니다.");
						rnt = false;
						return false;
					}
				}
				
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				var url = 'commentReceiptUserApplyAction.do';
				
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );

				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, parameters, function( data ) {
					alert(data.resultMsg);
					args.fn_search();
				}, "json").error( function() {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
					self.close();
				} );
			} );
			
		}
	});
	
});	

function gridColorSetting() {
	
	var rows = $( "#jqGridList" ).getDataIDs();
	for ( var i = 0; i < rows.length; i++ ) {
		$( "#jqGridList" ).setRowData(rows[i], false, {background: '#D9D9D9'});
		$( "#jqGridList" ).setCell (rows[i], 'receipt_dept_code','', {background: '#FFFFFF'});
		$( "#jqGridList" ).setCell (rows[i], 'receipt_dept_name','', {background: '#FFFFFF'});
		$( "#jqGridList" ).setCell (rows[i], 'receipt_user_id','', {background: '#FFFFFF'});
		$( "#jqGridList" ).setCell (rows[i], 'receipt_user_name','', {background: '#FFFFFF'});
	}
	
}


function applyAction() {
	
	$('#btnApply').focus();
	
	jqGridObj.saveCell(kRow, idCol );
	
	var formData = fn_getFormData('#application_form');
	
	if ( $("#p_mail_comment").val() == "" ) {
		alert("COMMENT 내용이 없습니다.");
		return;
	}
	
	var rows = $( "#jqGridList" ).getDataIDs();
	for ( var i = 0; i < rows.length; i++ ) {
		
		var item = jqGridObj.jqGrid("getRowData", rows[i]);
		
		if(item.receipt_dept_name == "") {
			alert("담당파트가 지정되지 않았습니다.");
			return false;
		}
		
		if(item.receipt_user_name == "") {
			alert("담당자가 지정되지 않았습니다.");
			return false;
		}
	}
	
	
	//승인 로직
	if(confirm('적용하시겠습니까?')) {
		
		var changeRows = [];
		var args = window.dialogArguments;
		
		getChangedChmResultData(function( data ) {
			
			chmResultRows = data;
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'commentReceiptUserApplyAction.do';
			
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );

			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				args.fn_search();
			}, "json").error( function() {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
				self.close();
			} );
		} );
		
	}
}

//그리드 변경된 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( jqGridObj.jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D' || obj.oper == '';
	} );
	callback.apply(this, [ changedData.concat(resultData) ]);
};

function etcMail() {
	
	var sURL = "popUpReceiptUserEtcMail.do?p_etc_user_id=" + $("#p_etc_user_id").val() + "&p_etc_user=" + escape(encodeURIComponent($("#etcMailList").text()));
	var popOptions = "dialogWidth: 600px; dialogHeight: 650px; center: yes; resizable: yes; status: no; scroll: yes;"; 
	window.showModalDialog(sURL, window, popOptions);
}

//afterSaveCell oper 값 지정
function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
	
	var item = jqGridObj.jqGrid( 'getRowData', irow );
	if (item.oper != 'I')
		item.oper = 'U';

	jqGridObj.jqGrid( "setRowData", irow, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
	
}

</script>
</html>
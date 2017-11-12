<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수신문서_DWG</title>
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
<input type="hidden" id="p_dept_type" name="p_dept_type" value="" />

<div id="mainDiv" class="mainDiv">
	<div class="subtitle">수신문서관리 - DWG</div>
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
						<input type="button" value="APPLY" id="btnApply" class="btn_blue2" />
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

var jqGridObj = $('#jqGridList');

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'수신 ID' ,name:'receipt_id' , index:'receipt_id' ,width:80 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 DETAIL ID' ,name:'receipt_detail_id' , index:'receipt_detail_id' ,width:80 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 No' ,name:'receipt_no' , index:'receipt_no' ,width:80 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Project' ,name:'project_no' , index:'project_no' ,width:50 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'문서' ,name:'doc_type' , index:'doc_type' ,width:20 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Issuer' ,name:'issuer' , index:'issuer' ,width:50 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Subject' ,name:'subject' , index:'subject' ,width:220 ,align:'left', title:false, sortable:false});
	gridColModel.push({label:'Issue Date' ,name:'issue_date' , index:'issue_date' ,width:60 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'Com No.' ,name:'com_no' , index:'com_no' ,width:60 ,align:'center', title:false, sortable:false});
	gridColModel.push({label:'담당팀ID' ,name:'receipt_team_code' , index:'receipt_team_code' ,width:80 ,align:'center', sortable:false, title:false, editable:true, hidden: true});
	gridColModel.push({label:'담당팀' ,name:'receipt_team_name' , index:'receipt_team_name' ,width:80 ,align:'center', title:false, sortable:false });
	gridColModel.push({label:'담당파트ID' ,name:'receipt_dept_code' , index:'receipt_dept_code' ,width:80 ,align:'center', sortable:false, title:false, editable:true, hidden: true});
	gridColModel.push({label:'담당파트' ,name:'receipt_dept_name' , index:'receipt_dept_name' ,width:80 ,align:'center', title:false, sortable:false });
	gridColModel.push({label:'담당자ID' ,name:'receipt_user_id' , index:'receipt_user_id' ,width:80 ,align:'center', sortable:false, title:false, editable:true, hidden: true});
	gridColModel.push({label:'담당자' ,name:'receipt_user_name' , index:'receipt_user_name' ,width:80 ,align:'center', title:false, sortable:false });
	gridColModel.push({label:'DWG NO.' ,name:'dwg_no' , index:'dwg_no' ,width:60 ,align:'center', sortable:false, title:false, editable:true,
		edittype : "select",
  		editrules : { required : false },
  		//cellattr: function (){return 'class="required_cell"';},
  		editoptions: {
			dataUrl: function(){
        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
   				var url = "commentReceiptDwgNoList.do?p_dept_code=" + item.receipt_dept_code + "&p_dept_type=" + $("#p_dept_type").val() + "&p_project_no=" + item.project_no;
				return url;
			},
  			buildSelect: function(data){
  				if(typeof(data)=='string'){
     				data = $.parseJSON(data);
    			}
 				var rtSlt = '<select id="selectDwgNo" name="selectDwgNo" >';
   				for ( var idx = 0 ; idx < data.length ; idx++) {
					rtSlt +='<option value="'+data[idx].object+'" name="'+data[idx].object+'">'+data[idx].object+'</option>';	
 				}
				rtSlt +='</select>';
				return rtSlt;
  		 	}
  		 }
  		/* dataInit: function(elem) {
			setTimeout(function(){ 
				$(elem).autocomplete({
					source: "commentReceiptDwgNoList.do?p_dept_code=000002&p_dept_type=" + $("#p_dept_type").val() + "&p_project_no=S1741",
					minLength: 1,
	    			matchContains: true, 
	    			autosearch: true,
	    			autoFocus: true,
	    			select: function (event, ui) {
	                    $(elem).val(ui.item.object);
	                    $(elem).trigger('change');
	                }
				});
			}, 50);
		}  */
	});
	gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden: true} );
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	jqGridObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url	:	'popUpReceiptDwgList.do',
	    postData : fn_getFormData('#application_form'),
	    colModel :gridColModel,
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
			
			/* var rows = jqGridObj.getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				
				var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
				
				jqGridObj.setCell(rows[i], "dwg_no", '', 'not-editable-cell', {editoptions: { disabled: 'disabled' }});
				
			} */
			
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
		item.dwg_no = rowData['dwg_no'];
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
					jqGridObj.setRowData(selarrrow[i], false, {background: '#FFFFA2'});
				}
				
			}
		}
		
	});
	
	
	//Apply 클릭
	$("#btnApply").click(function() {
		
		var rnt = true;
		jqGridObj.saveCell(kRow, idCol );
		
		var formData = fn_getFormData('#application_form');
		
		var changeRows = [];
		var rnt = true;
		
		getGridChangedData(jqGridObj,function(data) {
			changeRows = data;
			
			if (changeRows.length == 0) {
				alert("변경된 내용이 없습니다.");
				rnt = false;
				return false;
			}
			
			for(i=0; i<changeRows.length; i++) {
				if(changeRows.length == 1 && changeRows[i].oper == 'D') {
					alert("1개행 이하는 삭제 할수 없습니다.");
					rnt = false;
					return false;
				}
			}
			
		});
		
		if(!rnt) {
			return false;
		}
		
		var dataList = { chmResultList : JSON.stringify(changeRows) };
		var parameters = $.extend({}, dataList, formData);
		
		//getJsonAjaxFrom("commentReceiptTeamApplyAction.do", parameters, null, callback_next);
		
		//승인 로직
		if(confirm('적용하시겠습니까?')){
			
			var args = window.dialogArguments;
			
			$.post("commentReceiptDwgApplyAction.do", parameters, function(data) {
				alert(data.resultMsg);
				args.fn_search();
			},"json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			}).always( function() {
				self.close();
				$("#btnClose").click();
			});
			
		}
		
	});
	
	
});	

function gridColorSetting() {
	
	var rows = $( "#jqGridList" ).getDataIDs();
	for ( var i = 0; i < rows.length; i++ ) {
		$( "#jqGridList" ).setRowData(rows[i], false, {background: '#D9D9D9'});
		$( "#jqGridList" ).setCell (rows[i], 'dwg_no','', {background: '#FFFFFF'});
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
	//jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	
}

</script>
</html>
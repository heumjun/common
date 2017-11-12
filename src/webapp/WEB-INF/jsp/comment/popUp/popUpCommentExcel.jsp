<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PCF IMPORT</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
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
	
	.grid-test {
		font : italic;
		color: #0000FF;
		font-weight: bold;
	}
	
	#jqGridList_receipt_no, #jqGridList_sub_no, #jqGridList_sub_title,
	#jqGridList_initials, #jqGridList_issue_date, #jqGridList_com_no, #jqGridList_builders_reply, #jqGridList_builder_user_name,
	#jqGridList_builder_date, #jqGridList_sub_att, #jqGridList_ref_no, #jqGridList_status, #jqGridList_confirm_user_name, #jqGridList_confirm_date {
		border-right-color: #807fd7;
	}
	
	#jqGridList_list_no {
		text-align: right;
	}
	#jqGridList_list_no {
		border-right: 0px; 
	}
	
	#jqGridList_sub_no {
		text-align: left;
	}
	
</style>
</head>
<body>
<form id="application_form" name="application_form" enctype="multipart/form-data" method="post">
	<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<input type="hidden" name="temp_project_no" id="temp_project_no"  value="" />
	<input type="hidden" name="p_auth_code" id="p_auth_code"  value="${loginUser.author_code}" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	<input type="hidden" name="upper_dwg_dept_code" id="upper_dwg_dept_code"  value="${loginUser.upper_dwg_dept_code}" />
	<input type="hidden" name="dwg_dept_code" id="dwg_dept_code"  value="${loginUser.dwg_dept_code}" />
	<input type="hidden" name="dwgabbr_eng" id="dwgabbr_eng"  value="${loginUser.dwgabbr_eng}" />
	<input type="hidden" name="p_pcf_admin_page" id="p_pcf_admin_page"  value="" />
	<input type="hidden" name="h_my_dept_yn" id="h_my_dept_yn" value="Y" />
	
	<input type="hidden" name="p_project_no" id="p_project_no" value="${p_project_no }" /> 
	<input type="hidden" name="p_dwg_no" id="p_dwg_no" value="${p_dwg_no }" /> 
	<input type="hidden" name="p_issuer" id="p_issuer" value="${p_issuer }" />  
	
	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			PCF IMPORT
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="780">
			<col width="*">
			<tr>
				<td class="sscType" style="border-right:none;"> 
					<input type="button" value="FORM" id="btnForm"  class="btn_red2" />
				</td>
				<td style="border-left:none;">
					<div class="button endbox">
						<input type="button" value="SAVE" id="btnSave"  class="btn_blue2" />
						<input type="button" value="CLOSE" id="btnClose"  class="btn_blue2" />
					</div>
				</td>						
			</tr>
		</table>	
		<table class="searchArea2">
			<col width="780">
			<col width="*">
			<tr>
				<td class="sscType" style="border-right:none;">
					수신 No.
					<select name="p_receipt_no" id="p_receipt_no" style="width:150px;" >
					</select>
					
					<input type="button" value="IMPORT" id="btnExlImp"  class="btn_red2" />
				</td>
				<td style="border-left:none;">
				</td>
			</tr>
		</table>
		
		<div id="jqGridListDiv" class="content">
			<table id="jqGridList"></table>
			<div id="btnjqGridList"></div>
		</div>
		
	</div> <!-- .mainDiv end -->
</form>
</body>
<script type="text/javascript">

var idRow;
var idCol;
var kRow;
var kCol;

var jqGridObj = $('#jqGridList');

if(typeof($("#p_receipt_no").val()) !== 'undefined'){
	getAjaxHtml($("#p_receipt_no"), "commentReceiptNoSelectBoxDataList.do?sb_type=all&p_project_no=" + $("#p_project_no").val() + "&p_dwg_no=" + $("#p_dwg_no").val() + "&p_issuer=" + $("#p_issuer").val(), null, null);
}


function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'수신 ID' ,name:'receipt_id' , index:'receipt_id' ,width:100 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 DETAIL_ID' ,name:'receipt_detail_id' , index:'receipt_detail_id' ,width:100 ,align:'center', sortable:false, title:false, hidden : true});
	gridColModel.push({label:'수신 No.' ,name:'receipt_no' , index:'receipt_no' ,width:100 ,align:'center', sortable:false,  title:false, editable:true, hidden : true});
	gridColModel.push({label:'Sub' ,name:'list_no' , index:'list_no' ,width:50 ,align:'center', sortable:false, title: true, frozen: true});
	gridColModel.push({label:'No.' ,name:'sub_no' , index:'sub_no' ,width:50 ,align:'center', sortable:false, title:false, frozen: true});
	gridColModel.push({label:'BUYER\'S COMMENT' ,name:'sub_title' , index:'sub_title' ,width:400 ,align:'left', sortable:false, title:false, editable:true});
	gridColModel.push({label:'INITIAL' ,name:'initials' , index:'initials' ,width:60 ,align:'center', sortable:false, title:false, editable:true});
	gridColModel.push({label:'UPLOAD_ENABLE_FLAG', name:'upload_enable_flag', width:50, align:'center', sortable:true, title:false, hidden: true} );
	gridColModel.push({label:'UPLOAD_RESULT', name:'upload_result', width:200, align:'center', sortable:true, title: true, hidden: false} );
	gridColModel.push({label:'WORK_KEY', name:'work_key', width:200, align:'center', sortable:true, title: true, hidden: true} );
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
	    colModel: gridColModel,
	    gridview: true,
	    cellEdit : true,
	    cellsubmit : 'clientArray', // grid edit mode 2
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit: true,
	    multiselect: false,
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
			
			var rows = $(this).getDataIDs();
			
			for ( var i = 0; i < rows.length; i++ ) {
				
				var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
				
				if(item.upload_enable_flag == 'E') {
					$(this).setRowData(rows[i], false, {background: '#FCD5B4'});					
				}
				
			}
				
		 },
		 beforeSelectRow:function(rowid, e) {   
			 var cbs = $("tr#"+rowid+".jqgrow > td > input.cbox:disabled", jqGridObj[0]);
			 if (cbs.length === 0) 
			 {
			 	return true;    // allow select the row    
			 }
			 else 
			 { 
			 	return false;   // not allow select the row  
			 }
		 },
		 onSelectAll: function(aRowids,status) {
			if (status) {                  
				var rows = jqGridObj.getDataIDs();
				for(var i=0; i<rows.length; i++){
					var cbs = $("tr#" + rows[i] + ".jqgrow > td > input.cbox:disabled", jqGridObj[0]);
					cbs.removeAttr("checked");
				}
			}
		 },
		 onCellSelect : function( rowid, iCol, cellcontent, e ) {
			jqGridObj.saveCell(kRow, idCol );

			var item = $(this).jqGrid( 'getRowData', rowid );
			
			var cm = jqGridObj.jqGrid( "getGridParam", "colModel" );
			var colName = cm[iCol];
			var myDeptYn = $("#h_my_dept_yn").val();
			
			if ( colName['index'] == "sub_att" ) {

				var sURL = "popUpCommentMainAttach.do?row_selected="+rowid + "&comment_sub_id="+item.comment_sub_id +"&view_flag="+myDeptYn + "&edit_enable_flag=" + item.edit_enable_flag;
				var popOptions = "dialogWidth:800px; dialogHeight: 380px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
				
				/* var popOptions = "width=350, height=380, resizable=yes, scrollbars=no, status=yes"; 
				var win = window.open(sURL, "bomStatus", popOptions); 
				
				setTimeout(function(){
					win.focus();
				 }, 1000); */
				
			}
				
		 },
		 afterSaveCell : chmResultEditEnd
	}); //end of jqGrid
	
	fn_gridresize( $(window), $( "#jqGridList" ), -20 );
	
	//jqGrid 크기 동적화
	jqGridObj.jqGrid('setLabel','receipt_no', '', {'background':'#E6B8B7'});
	
	jqGridObj.jqGrid('setLabel','list_no', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','sub_no', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','sub_title', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','initials', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','issue_date', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','com_no', '', {'background':'#D8E4BC'});
	jqGridObj.jqGrid('setLabel','upload_result', '', {'background':'#D8E4BC'});
	
	// SAVE 버튼 클릭 시
	$("#btnSave").click(function() {
		
		var args = window.dialogArguments;
		
		jqGridObj.saveCell(kRow, idCol );

		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		if(confirm("오류항목 제외하고 저장하시겠습니까?\nY: 항목만 저장, N 현재창 유지")){
			
			var rtn = true;
			var changeResultRows =  getChangedGridInfo("#jqGridList");
			
			var url			= "commentImportConfirmProc.do";
			var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({},dataList,formData);
			
			lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
			
			$.post(url, parameters, function(data)
			{	
				var msg = '';
				var result = '';

				for ( var key in data) {
					if (key == 'resultMsg') {
						msg = data[key];
					}
					if (key == 'result') {
						result = data[key];
					}
				}
				
				alert(msg);
				
			},"json").error(function() {
				alert('시스템 오류입니다.\n전산담당자에게 문의해주세요.');
			}).always(function() {
				lodingBox.remove();
				args.fn_search();
				self.close();
			});

		}
	});
	
	$("#btnClose").click(function() {
		
		var rows = jqGridObj.getDataIDs();
		
		if(rows.length > 0) {
			if(confirm('저장되지 않은 자료가 있습니다. 정말 닫으시겠습니까?\nY 현재창닫기 N 현재창 유지')) {
				self.close();
			}	
		} else {
			self.close();
		}
		
	});
	
	//Excel Form 클릭 다운로드	
	$("#btnForm").click(function(){
		$.download('fileDownload.do?fileName=commentImportForm.xls', null, 'post');
	});
	
	//Excel Import 클릭
	$("#btnExlImp").click(function(){
		
		/* var ids = jqGridObj.getDataIDs();
		if(ids.length > 0) {
			alert("진행중인 COMMENT가 존재합니다.");
			return false;
		} */		

		var sURL = "popUpCommentExcelImport.do";
		var popOptions = "dialogWidth:450px; dialogHeight: 100px; center: yes; resizable: no; status: no; scroll: no;"; 
		window.showModalDialog(sURL, window, popOptions);

		jqGridObj.saveCell(kRow, idCol );
		
	});
	
});

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

//그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	return changedData;
}


//afterSaveCell oper 값 지정
function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
	
	var item = jqGridObj.jqGrid( 'getRowData', irow );
	if (item.oper != 'I') {
		item.oper = 'U';
	} 
	
	fn_buttonEnable2(["#btnSave"]);

	jqGridObj.jqGrid( "setRowData", irow, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
	
	//입력 후 대문자로 변환
	//jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
}

</script>
</html>
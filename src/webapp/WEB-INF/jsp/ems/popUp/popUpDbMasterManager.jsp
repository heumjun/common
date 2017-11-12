<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>납기관리자</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">

<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="button">
		<input type="button" class="btn_blue" value="저장" id="btnSave" />
		<input type="button" class="btn_blue" value="닫기" id="btnClose" />	
	</div>
</div>
<div class="content">
	<table id="itemTransList"></table>
	<div id="btnitemTransList"></div>
</div>
		
</form>

<script type="text/javascript">

var resultData = [];
var idRow = 0;
var idCol = 0;
var nRow = 0;
var kRow = 0;

//########  조회 ########//
$(document).ready(function(){
	search();
	
});						

function search() {			
	var sUrl = "popUpDbMasterManagerList.do";
	loadDatas(sUrl);
}

//########  저장버튼 ########//
$("#btnSave").click(function(){
	
	$( '#itemTransList' ).saveCell( kRow, idCol );
	
	var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
		
	var changeAreaResultRows = getChangedChmResultData("#itemTransList");
	
	//입력하지 않은 항목이 있는지 확인
	if (!fn_checkAreaValidate(changeAreaResultRows)) { 
		loadingBox.remove();
		return;	
	}

	var url			= "popUpDbMasterManagerSave.do";
	var dataList    = {chmResultList:JSON.stringify(changeAreaResultRows)};
	var formData 	= getFormData('#itemTransList');
	
	var parameters = $.extend({},dataList,formData);
			
	$.post(url, parameters, function(json) {

		alert(json.resultMsg);
		if ( json.result == 'success' ) {
			$("#itemTransList").jqGrid("GridUnload");
			search();
		}
	}).fail(function(){
		alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
	}).always(function() {
    	loadingBox.remove();	
	});
	
});

//그리드의 변경된 row데이터를 가져오는 함수
function getChangedChmResultData(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'D';
	});
	
	changedData = changedData.concat(resultData);	
		
	return changedData;
}

//그리드 변경된 데이터 validation 체크하는 함수	
function fn_checkAreaValidate(arr1) {
	var result   = true;
	var message  = "";
	var ids ;
		
	if (arr1.length == 0) {
		result  = false;
		message = "변경된 내용이 없습니다.";	
	}
	
	if (result && arr1.length > 0) {
		ids = $("#itemTransList").jqGrid('getDataIDs');
	
		 for(var  i = 0; i < ids.length; i++) {
			
			var val1 = $("#itemTransList").jqGrid('getCell', ids[i], 'user_id');
		
			if ($.jgrid.isEmpty(val1)) {
				result  = false;
				message = "입력되지 않은 사번 항목이 있습니다.";
				
				break;
			}
			
				
			val1 = $("#itemTransList").jqGrid('getCell', ids[i], 'user_nm');					
			if ($.jgrid.isEmpty(val1)) {
				result  = false;
				message = "입력되지 않은 이름 항목이 있습니다.";
				
				break;
			}
		} 
	}
	if (!result) {
		alert(message);
	}
	
	return result;	
}

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

function loadDatas(url) {
	$("#itemTransList").jqGrid({ 
         datatype: 'json', 
         mtype: 'POST', 
         url:url,
         postData : getFormData('#application_form'),
         colModel:[
         	{label:'이름',name:'user_nm',index:'user_nm',width:60,align:'center',editable:false,sortable:false},
        	{label:'사번',name:'user_id',index:'user_id',width:60,align:'center',editable:false,sortable:false},
        	{name:'oper',index:'oper',width:60,align:'center',sortable:false, hidden:true}
         ],
         cellEdit : true, // grid edit mode 1
		 cellsubmit : 'clientArray', // grid edit mode 2
         gridview: true,
         toolbar: [false, "bottom"],
         viewrecords: true,
         autowidth: true,
         multiselect: true,
         shrinkToFit:true,
         afterSaveCell  : function(rowid,name,val,iRow,iCol) {
         		
	     },
         pager: jQuery('#btnitemTransList'),
         beforeSaveCell : chmResultEditEnd,
		 beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
			idRow = rowid;
			idCol = iCol;
			kRow = iRow;
			kCol = iCol;
		 },
         cellEdit	: true,             // grid edit mode 1
         cellsubmit	: 'clientArray',  	// grid edit mode 2
		 jsonReader : {
             root: "rows",
             page: "page",
             total: "total",
             records: "records",  
             repeatitems: false,
         },
         pgbuttons : false,
 		 pgtext : false,
 		 pginput : false,
         imgpath: 'themes/basic/images',
         onPaging: function(pgButton) {
	
		 },
		 onCellSelect:function(rowid, iCol, cellcontent, e) {
			var ret = $(this).getRowData( rowid );
			var oper = ret.oper;
			if( oper == "I" ) {
				var cm = $(this).jqGrid( "getGridParam", "colModel" );
				var colName = cm[iCol];
				var item = $("#dataList").jqGrid( "getRowData", rowid );
				if ( colName['index'] == "user_nm" || colName['index'] == "user_id" ) {
					
					var rs = window.showModalDialog( "popUpUserInfo.do?cmd=infoUserList.do", window, "dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
					
					if( rs != null ) {
						item.user_id = rs[0];
						item.user_nm = rs[1];
						
						$(this).jqGrid("setRowData", rowid, item);
					}
				}
			} 
			

// 			var cm = $(this).jqGrid( "getGridParam", "colModel" );
// 			var colName = cm[iCol];
// 			var item = $(this).jqGrid( 'getRowData', rowid );
// 			if (item.oper == "") {
// 				$(this).jqGrid('setCell', rowid, 'user_nm', '', 'not-editable-cell');
// 				$(this).jqGrid('setCell', rowid, 'user_id', '', 'not-editable-cell');
// 			}
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

		    var rowIds = $("#itemTransList").getDataIDs();
		    for(var i=0; i<rowIds.length; i++){
		    	var rowDatas = $("#itemTransList").getRowData();
		    	if(rowDatas[i].user_id=="211055"){
		    		document.getElementById("jqg_itemTransList_" + rowIds[i]).disabled = true;
				    $("#jqg_itemTransList_" + rowIds[i]).hide();		
		    	}
		    }
		    
		  	//$("input[name=jqg_itemTransList_1]").attr('disabled', 'true');
		    
		 },
		 onSelectAll: function(aRowids,status) { //disabled 처리된 checkbox 선택 안되도록 해주는 부분
			 if (status) {
			  var cbs = $("tr.jqgrow > td > input.cbox:disabled", $("#itemTransList")[0]);
			  cbs.removeAttr("checked");
			  
			  //전체선택시 211055 사번은 background 컬러 흰색
			    var rowIds = $("#itemTransList").getDataIDs();
			    for(var i=0; i<rowIds.length; i++){
			    	var rowDatas = $("#itemTransList").getRowData();
			    	if(rowDatas[i].user_id=="211055"){
						  $('#itemTransList').jqGrid('setCell', rowIds[i], 'cb', '', {background : '#FFFFFF' });
						  $('#itemTransList').jqGrid('setCell', rowIds[i], 'user_id', '', {background : '#FFFFFF' });
						  $('#itemTransList').jqGrid('setCell', rowIds[i], 'user_nm', '', {background : '#FFFFFF' });
			    	}
			    }
			  
			  $("#itemTransList")[0].p.selarrrow = $("#itemTransList").find("tr.jqgrow:has(td > input.cbox:checked)").map(function() { return this.id; }).get();
			  }
			},
		 afterInsertRow : function(rowid, rowdata, rowelem){
				jQuery("#"+rowid).css("background", "#FFFFCC");
	     }
       
 	});//end of jqGrid 
	
 	$( "#itemTransList" ).jqGrid( 'navGrid', "#btnitemTransList", {
		refresh : false,
		search : false,
		edit : false,
		add : false,
		del : false
		
	} );

	$( "#itemTransList" ).navButtonAdd( '#btnitemTransList', {
		caption : "",
		buttonicon : "ui-icon-minus",
		onClickButton : deleteRow,
		position : "first",
		title : "del",
		cursor : "pointer"
	} );

	$( "#itemTransList" ).navButtonAdd( '#btnitemTransList', {
		caption : "",
		buttonicon : "ui-icon-plus",
		onClickButton : addChmResultRow,
		position : "first",
		title : "add",
		cursor : "pointer"
	} );
 	
	//jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#itemTransList" ), -90 );
	
}

//Del 버튼
function deleteRow() {
	
	//체크한 것만 배열에 담음 
	var selarrrow = $( "#itemTransList" ).getGridParam('selarrrow');
	
	/* 각 ROW 별로 상태에 따라 작업 */
	for(var i=0;i<selarrrow.length;i++){
	
		var selrow = selarrrow[i];	
		var item   = $('#itemTransList').jqGrid('getRowData',selrow);
		
		if(item.oper == '') {
			item.oper = 'D';
			$('#itemTransList').jqGrid("setRowData", selrow, item);
			$('#itemTransList').jqGrid('setCell', selarrrow[i], 'cb', '', {background : '#FF7E9D' });
			$('#itemTransList').jqGrid('setCell', selarrrow[i], 'user_id', '', {background : '#FF7E9D' });
			$('#itemTransList').jqGrid('setCell', selarrrow[i], 'user_nm', '', {background : '#FF7E9D' });
		} else if (item.oper == 'I') {
			$('#itemTransList').jqGrid('delRowData', selrow);	
		} else if (item.oper == 'D') {
			item.oper = '';
			$('#itemTransList').jqGrid("setRowData", selrow, item);
			$('#itemTransList').jqGrid('setCell', selarrrow[i], 'cb', '', {background : '#FFFFFF' });
			$('#itemTransList').jqGrid('setCell', selarrrow[i], 'user_id', '', {background : '#FFFFFF' });
			$('#itemTransList').jqGrid('setCell', selarrrow[i], 'user_nm', '', {background : '#FFFFFF' });
		}
	}
	
	//체크 전체 해제
	$('#itemTransList').resetSelection();
}

//Add 버튼 
function addChmResultRow() {
	$( '#itemTransList' ).saveCell( kRow, idCol );

	var item = {};
	var colModel = $( '#itemTransList' ).jqGrid( 'getGridParam', 'colModel' );
	for( var i in colModel )
		item[colModel[i].name] = '';
	
	item.oper = 'I';
	item.enable_flag = 'Y';
	item.paint_new_rule_flag = 'Y';
	item.model_popup = '...';

	$('#itemTransList').resetSelection();
	$('#itemTransList').jqGrid('addRowData', $.jgrid.randId(), item, 'first' );
}

//afterSaveCell oper 값 지정
function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
	var item = $( '#itemTransList' ).jqGrid( 'getRowData', irowId );
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#itemTransList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
	
	$( '#itemTransList' ).jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
	
	/*
	 //변경 된 row 이면 색 변경
	var ids = $( '#itemTransList' ).jqGrid( 'getDataIDs' );
	if (item.oper == "U") {
		$( '#itemTransList' ).jqGrid( 'setCell', ids[irow - 1], ids[iCol - 1], '', { 'background' : '#6DFF6D' } );
	}
	*/
}

$( '#btnClose' ).click( function() {
	self.close();
} );
</script>
</body>
</html>

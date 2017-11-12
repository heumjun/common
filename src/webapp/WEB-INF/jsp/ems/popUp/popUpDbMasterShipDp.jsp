<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>선종 DP 관리</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">

<input type="hidden" name="p_daoName"   id="p_daoName" value=/>
<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
<input type="hidden" name="p_process"   id="p_process" value=""/>
<input type="hidden" name="p_filename"  id="p_filename" value=""/>
<input type="hidden" name="list_type"   id="list_type" />
<input type="hidden" name="list_type_desc"   id="list_type_desc" />
<input type="hidden" name="userId" id="userId"  value="<c:out value="${UserName}" />" />
<input type="hidden" name="p_spec_seq" id="p_spec_seq" /> 
<input type="hidden" name="p_item_seq" id="p_item_seq" />
<input type="hidden" name="p_itemseq" id="p_itemseq" />
<input type="hidden" name="p_specseq" id="p_specseq" />
<div id="hiddenArea"></div>

<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="button">
		<input type="button" id="btnSave" value="저장" class="btn_blue"/>
		<input type="button" class="btn_blue" value="닫기" id="btnClose" />
	</div>
</div>
<div class="content">
	<table id="itemTransList"></table>
	<div id="btnitemTransList"></div>
</div>
		
</form>

<script type="text/javascript">
var item_seq = $("#p_item_seq").val();
var spec_seq = $("#p_spec_seq").val();
var catalog = $("#p_catalog_code").val();
var item_code = $("#p_itemcode").val();
var item_cnt = $("#p_item_seq").val();
var spec_cnt = $("#p_spec_seq").val();
var resultData = [];
var idRow = 0;
var idCol = 0;
var nRow = 0;
var kRow = 0;
$(document).ready(function(){

	if(item_cnt == item_seq) {
		$("#btnDel").attr("disabled",true);
	} else {
		$("#btnDel").attr("disabled",false);
	}
	
	search();
});						

//######## 조회 버튼 클릭 시 ########//
$("#btnSearch").click(function(){				
	search();
});			

//########  저장 버튼 ########//
$("#btnSave").click(function(){			
	
	var selRows = $("#itemTransList").getDataIDs().length;
	var shipkind = "";
	var ship_kind = "'";
	var shiporder = 0;

	$("#itemTransList").saveCell(idRow, idCol );
	
	for(var i = 0; i < selRows; i++) {
		ship_type = $('#itemTransList').jqGrid('getRowData',(i+1)).ship_type;
		ship_size = $('#itemTransList').jqGrid('getRowData',(i+1)).ship_size;
		
		var ship_order = $('#itemTransList').jqGrid('getRowData',(i+1)).ship_order;
		
		shipkind = ship_type+"_"+ship_size+"_"+ship_order;
		
		if(!(ship_order == "" || ship_order == undefined)) {
			
			if(ship_order < 1 || ship_order > 10) {
				alert("1이상 10이하의 숫자만 입력하십시오.");
				return;
			} else if(shiporder != 0 && shiporder == ship_order) {
				alert("같은 숫자를 입력할 수 없습니다.");
				return;
			} else {
				ship_kind = ship_kind + shipkind + "','";
			}
		}
		shiporder = ship_order;
	}
	ship_kind = ship_kind + "'";

	$("input[name=p_process]").val("mod_shipDp");
	$("input[name=p_ship_kind]").val(ship_kind);

	var chmResultRows = [];
	
	getChangedChmResultData(function( data ) {
		chmResultRows = data;
		var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
		var url = 'popUpEmsDbMasterShipDpSave.do';
		var formData = fn_getFormData( '#application_form' );
		var parameters = $.extend( {}, dataList, formData );

		var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
		
		$.post( url, parameters, function(json) {
			alert(json.resultMsg);
			if ( json.result == 'success' ) {
// 				opener.jQuery("#MasterItemGrid").trigger("reloadGrid");
				self.close();
			}
		}, "json").error( function() {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
			opener.search();
			loadingBox.remove();
		} );
	} );
});	

//########  닫기버튼 ########//
$("#btnClose").click(function(){
	window.close();					
});

function search() {				
	
	var sUrl = "popUpEmsDbMasterShipDpList.do";
	//jQuery("#itemTransList").jqGrid("GridUnload");
	loadDatas(sUrl);
}

//######## Input text 부분 숫자만 입력 ########//
function onlyNumber(event) {
    var key = window.event ? event.keyCode : event.which;    

    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
    || key  == 8  || key  == 46 ) // del, back space
    ) {
        return true;
    }else {
        return false;
    }    
};

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};
	
    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

//STATE 값에 따라서 checkbox 생성
function formatOpt1(cellvalue, options, rowObject){
		
	var rowid = options.rowId;

	var ship_type = rowObject.ship_type;
	var ship_size = rowObject.ship_size;
	var ship_order = rowObject.ship_order;
	
	if(Math.floor(ship_order) == 0) ship_order = '';
		var str ="<input type=\"text\" style=\"width:50%;\" name=\"txt_"+rowid+"\" id=\"txt_"+rowid+"\" value=\""+ship_order+"\" />";
	    
	 	return str;
	 
}

//header checkbox action 
function checkBoxHeader(e) {
		e = e||event;/* get IE event ( not passed ) */
		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
	if(($("#chkHeader").is(":checked"))){
		$(".chkboxItem").prop("checked", true);
	}else{
		$("input.chkboxItem").prop("checked", false);
	}
}

// 왼쪽에서부터 채운다는 의미
function LPAD(s, c, n) {
    if (! s || ! c || s.length >= n) {
        return s;
    }     
    var max = (n - s.length)/c.length;
    for (var i = 0; i < max; i++) {
        s = c + s;    
    }     
    return s;
}

function loadDatas(url) {
	$("#itemTransList").jqGrid({ 
         datatype: 'json', 
         mtype: 'POST', 
         url:url,
         postData : getFormData('#application_form'),
         colNames:['DP순서','선종','선형'],
         colModel:[
         	{name:'ship_order'		, index:'ship_order'	,width:60	,align:'center', editable:true, sortable:false},
        	{name:'ship_type'		, index:'ship_type'		,width:130	,align:'center', sortable:false},
        	{name:'ship_size'		, index:'ship_size'		,width:130	,align:'center', sortable:false}
         ],
         gridview: true,
         toolbar: [false, "bottom"],
         viewrecords: true,
         shrinkToFit:true,
         pager: jQuery('#btnitemTransList'),
         rowNum:999999,
         pgbuttons : false,
 		 pgtext : false,
 		 pginput : false,
         beforeSaveCell : chmResultEditEnd,
         beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
         	idRow=rowid;
         	idCol=iCol;
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
         imgpath: 'themes/basic/images',
         onPaging: function(pgButton) {
			$(this).jqGrid("clearGridData");
 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid"); 		
		 },
		 onCellSelect: function(row_id,icol,cellcontent,e) {
// 		 	if(row_id > item_cnt) {
// 		 		if(icol == 2) {
// 					$(this).editRow(row_id, true);
//                 }
//             }
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
       
 }); //end of jqGrid
	//jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#itemTransList" ), -90 );
	
	$("#btnitemTransList_left").css( "width", 0 );
}

//afterSaveCell
function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
	var item = $( '#itemTransList' ).jqGrid( 'getRowData', irowId );
	$('#itemTransList').jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	$( '#itemTransList' ).jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
}

//그리드 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#itemTransList" ).jqGrid( 'getRowData' ), function( obj ) {
		return  obj.ship_order != '';
	} );
	
	callback.apply(this, [ changedData.concat(resultData) ]);
};

</script>
</body>
</html>

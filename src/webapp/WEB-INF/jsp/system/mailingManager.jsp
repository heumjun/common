<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mailing Manager</title>
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
<form id="application_form" name="application_form" >
	<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			Mailing Manager
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="80">
			<col width="200">
			<col width="80">
			<col width="300">
			<col width="200">
			<col width="*">
			<tr>
				<th>메일 타입</th>
				<td>
					<select name="p_code_type" id="p_code_type" style="width:150px;" ></select>
				</td>
				<th>사용자 이름</th>
				<td>
					<input type="text" id="p_wps_no" name="p_wps_no" style="width: 80px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
					<input type="text" class="notdisabled only_eco" id="user_group_name" name="user_group_name" value="" readonly="readonly" style="width: 180px; margin-left: -5px;" />
				</td>
				<td>
					<input type="radio" checked="true"name="group" id="rb1" onclick="setDepth()">전체 &nbsp;&nbsp;
	        		<input type="radio" name="group" id="rb2" onclick="setDepth()">사용 &nbsp;&nbsp;
	        		<input type="radio" name="group" id="rb3" onclick="setDepth()">사용불가
				</td>
				
				<td style="border-left:none;">
					<div class="button endbox">
						<input type="button" value="SAVE" id="btnSave" class="btn_blue2" />
						<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
						</c:if>
					</div>
				</td>						
			</tr>
		</table>
		
		<div class="content">
			<table id = "jqGridList"></table>
			<div   id = "btnjqGridList"></div>
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

var menuId = '';

var jqGridObj = $('#jqGridList');


//달력 셋팅
$(function() {

	if(typeof($("#p_code_type").val()) !== 'undefined'){
		getAjaxHtml($("#p_code_type"), "wpsCodeTypeSelectBoxDataList.do?sb_type=not", null, null);
	}
});


function getMainGridColModel(){
	
	var gridColModel = new Array();
	
	gridColModel.push({label:'메일 타입', name:'code_type', index:'code_type', width:150, align:'left', sortable:false, title:false, editable: false});
	gridColModel.push({label:'사용자 아이디', name:'code_name', index:'code_name',idth:60, align:'left', sortable:false, title:false, editable: false});
	gridColModel.push({label:'사용자 정보', name:'code_value', index:'code_value', width:150, align:'left', title:false, sortable:false, editable:true});
	gridColModel.push({label:'E-mail 주소', name:'code_desc', index:'code_desc', width:200, align:'left', title:false, sortable:false, editable:true});
	gridColModel.push({label:'사용가능 여부', name:'enable_flag', index:'enable_flag', width: 30, editable: true, sortable: false, edittype: 'checkbox', formatter: "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" });
	gridColModel.push({label:'E-mail 주소', name :'enable_flag_change', index :'enable_flag_change', hidden: true} );
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
	    cellEdit : true,
        cellsubmit : 'clientArray', // grid edit mode 2
	    scrollOffset : 17,
	    shrinkToFit:true,
	    multiselect: false,
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
		beforeSaveCell : chmResultEditEnd,
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
		 gridComplete : function() {
			var rows = $( "#jqGridList" ).getDataIDs();

			for( var i = 0; i < rows.length; i++ ) {
				var oper = $( "#jqGridList" ).getCell( rows[i], "oper" );

				if( oper == "" ) {
					$( "#jqGridList" ).jqGrid( 'setCell', rows[i], 'code_type', '', { color : 'black', background : '#DADADA' } );
					$( "#jqGridList" ).jqGrid( 'setCell', rows[i], 'code_name', '', { color : 'black', background : '#DADADA' } );
				}
			}

			//미입력 영역 회색 표시
			$( "#jqGridList .disables" ).css( "background", "#DADADA" );
		},
	}); //end of jqGrid

	// jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#jqGridList" ), 36 );
	
	
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
	$( "#btnSave" ).click( function() {
		fn_save();
	} );
	
	
});

//afterSaveCell oper 값 지정
function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
	var item = $( '#jqGridList' ).jqGrid( 'getRowData', irowId );
	if( item.oper != 'I' ){
		item.oper = 'U';
		$( '#jqGridList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
	}
	$( '#jqGridList' ).jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
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
	
	var sUrl = "wpsCodeManageList.do";
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
}

//저장
function fn_save() {
	$( '#jqGridList' ).saveCell( kRow, idCol );
	
	var changedData = $( "#jqGridList" ).jqGrid( 'getRowData' );
	
	// 변경된 체크 박스가 있는지 체크한다.
	for( var i = 1; i < changedData.length + 1; i++ ) {
		var item = $( '#jqGridList' ).jqGrid( 'getRowData', i );
		
		if ( item.oper != 'I' && item.oper != 'U' ) {
			
			if ( item.oper == 'U' ) {
				// apply the data which was entered.
				$('#jqGridList').jqGrid( "setRowData", i, item );
			}
		}
	}
	
	if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
		var chmResultRows = [];

		//변경된 row만 가져 오기 위한 함수
		getChangedChmResultData( function( data ) {
			lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'saveWpsCodeManage.do';
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

//가져온 배열중에서 필요한 배열만 골라내기 
function getChangedChmResultData( callback ) {
	var changedData = $.grep( $( "#jqGridList" ).jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	} );
	
	callback.apply( this, [ changedData.concat(resultData) ] );
}

</script>
</html>
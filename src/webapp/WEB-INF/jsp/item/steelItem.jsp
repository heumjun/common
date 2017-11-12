<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>강재 ITEM 생성</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
	<input type="hidden" id="p_col_name" name="p_col_name"/>
	<input type="hidden" id="p_data_name" name="p_data_name"/>
		<div class="subtitle">
		강재 ITEM 생성
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="50"/>
			<col width="80"/>
			<col width="50"/>
			<col width="80"/>
			<col width="*"/>
			<tr>
				<th>Project</th>
				<td>
					<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:60px;"/>
				</td>
				<th>BLOCK</th>
				<td>
					<input type="text" name="p_block_no" style="width:60px;" />
				</td>		
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
						<input type="button" class="btn_blue2" value="코드채번" id="btnSave"/>
					</div>
				</td>					
			</tr>
		</table>
		<div class="content">
			<table id="jqGridMainList"></table>
			<div id="jqGridMainListNavi"></div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var resultData = [];
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	
	var jqGridObj = $("#jqGridMainList");
	
	$(document).ready(function(){
		
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
			colModel : [
					{label:'프로젝트'			, name : 'project_no'			, index : 'project_no'			, width : 70, editable : false, align : "center"},					
					{label:'블록'				, name : 'block_no'				, index : 'block_no'			, width : 70, editable : false, align : "center"},
					{label:'구분'		 	 	, name : 'tpi_item_catalog_code', index : 'tpi_item_catalog_code', width : 150, editable : false, align : "left"},
					{label:'선급' 	 		, name : 'class' 				, index : 'class'				, width : 70, editable : false, align : "center"},
					{label:'재질'				, name : 'grade'				, index : 'grade'				, width : 70, editable : false, align : "center"},
					{label:'두께1'		 	, name : 'thickness1'			, index : 'thickness1'			, width : 70, editable : false, align : "right"},
					{label:'두께2'		 	, name : 'thickness2'			, index : 'thickness2'			, width : 70, editable : false, align : "right"},
					{label:'폭1'	 			, name : 'breadth1'				, index : 'breadth1'			, width : 70, editable : false, align : "right"},
					{label:'폭2'	 	 	 	, name : 'breadth2'				, index : 'breadth2'			, width : 70, editable : false, align : "right"},
					{label:'길이'				, name : 'length'				, index : 'length'				, width : 70, editable : false,  align : "right"},
					{label:'단중'		 	 	, name : 'unit_weight'			, index : 'unit_weight'			, width : 70, editable : false, align : "right"},
					{label:'수량'	 	 	 	, name : 'quantity'				, index : 'quantity'			, width : 70, editable : false, align : "right"},
					{label:'중량'	 	 		, name : 'weight'				, index : 'weight'				, width : 70, editable : false, align : "right"},
					{label:'계열'	 			, name : 'group_system'			, index : 'group_system'		, width : 100, editable : false, align : "center"},					
					{label:'ITEM CODE'	 	, name : 'item_code'			, index : 'item_code'			, width : 150, editable : false,  align : "center"},
					{label:'REQ_LINE_ID'	, name : 'req_line_id'			, index : 'req_line_id'			, width : 100, hidden:true},
					{label:'MSG'			, name : 'error_msg'			, index : 'error_msg'			, width : 100, hidden:true},
					{label:'OPER'			, name : 'oper'					, index : 'oper'				, width : 100, hidden:true},
				],
			gridview: true,
			viewrecords: true,
			autowidth: true,
			cmTemplate: { title: false },
			toolbar	: [false, "bottom"],
			//rownumbers : true,			
			cellEdit : true,
			cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
			//multiselect: true,			
			height: 460,
			pager: '#jqGridMainListNavi',
			rowList:[100,500,1000],
			rowNum:100, 
			recordtext: '내용 {0} - {1}, 전체 {2}',
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
			
			},
		 	loadComplete: function (data) {
									
			},
			gridComplete: function(data){
				
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid     	
     	
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 30 );
     	
	    //Search 버튼 클릭 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			if(uniqeValidation()){
				fn_search(); 
			}
		});
	    
		$("#btnSave").click(function(){
			var row_id = $( "#jqGridMainList" ).getDataIDs();
			if(row_id.length == 0) {
				alert("처리할 데이터가 존재하지 않습니다.");
				return;
			}
			fn_save(); 
		});
     	
	    //엑셀 export 버튼
		$("#btnExport").click(function() {
			fn_downloadStart();
			fn_excelDownload();	
		});
	});
 
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I') {
			item.oper = 'U';
			jqGridObj.jqGrid('setCell', irow, cellName, '', { 'background' : '#6DFF6D' } );
		}

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	// 조회 버튼
	function fn_search() {		
		var sUrl = "steelItemList.do";
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
		$( '#jqGridMainList' ).saveCell( kRow, idCol );
		
		var changedData = $( "#jqGridMainList" ).jqGrid( 'getRowData' );
		
		if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
			var chmResultRows = [];

			//변경된 row만 가져 오기 위한 함수
			getChangedChmResultData( function( data ) {
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );				
				chmResultRows = data;
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				var url = 'saveSteelItem.do';
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend( {}, dataList, formData); 
				
				$.post( url, parameters, function( data ) {
					var jsonGridData = new Array();
					if(data.rows.length > 0) {
						for(var i=0; i<data.rows.length; i++){
							var rows = data.rows[i];
				
							jsonGridData.push({project_no : rows.project_no
								             , block_no : rows.block_no
								             , tpi_item_catalog_code : rows.tpi_item_catalog_code
								             , class : rows.class
								             , grade : rows.grade
								             , thickness1 : rows.thickness1
								             , thickness2 : rows.thickness2
								             , breadth1 : rows.breadth1
								             , breadth2 : rows.breadth2
								             , length : rows.length
								             , unit_weight : rows.unit_weight
								             , quantity : rows.quantity
								             , weight : rows.weight
								             , group_system : rows.group_system
								             , item_code : rows.item_code
								             , req_line_id : rows.req_line_id
								             , error_msg : rows.error_msg
								             , oper : ''});			
						}

						jqGridObj.clearGridData(true);
						jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'last' );
						
						jqGridObj.saveCell(kRow, idCol );
						
						var row_id = jqGridObj.getDataIDs();
						for(var i=0; i<row_id.length; i++) {
							var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);

							if(item.item_code == '' || item.item_code == 'undefined' || item.item_code == undefined) {
								jqGridObj.setRowData(row_id[i], false, {background: '#FF9999'});
							}
						}
						
						alert("코드채번이 완료되었습니다.");
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				}).always( function() {
			    	lodingBox.remove();	
				});
			});
		}
	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {		
		var item = jqGridObj.jqGrid( 'getRowData', irow );		
		item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
		
	}
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'U';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//엑셀 다운로드 화면 호출
	function fn_excelDownload() {
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		var cn = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colNames" );
		var cm = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colModel" );
		for(var i=1; i<cm.length; i++ ){
			
			if(cm[i]['hidden'] == false) {
				colName.push(cn[i]);
				dataName.push(cm[i]['index']);	
			}
		}
		$( '#p_col_name' ).val(colName);
		$( '#p_data_name' ).val(dataName);
		var f    = document.application_form;
		f.action = "steelItemExcelExport.do";
		f.method = "post";
		f.submit();
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
</script>
</body>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC ACTIVITY JOB</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.required_cell{background-color:#F7FC96}	
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
	<input type="hidden" id="p_col_name" name="p_col_name"/>
	<input type="hidden" id="p_data_name" name="p_data_name"/>
		<div class="subtitle">
		USC ACTIVITY JOB
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="50"/>
			<col width="70"/>
			<col width="50"/>
			<col width="60"/>
			<col width="50"/>
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="80"/>
			<col width="60"/>
			<col width="60"/>
			<col width="70"/>
			<col width="*"/>
			<tr>
				<th>구역</th>
				<td>
					<select name="p_area" id="p_area" style="width:50px;">
						<option value="">ALL</option>
					</select>
				</td>		
				<th>B_CATA</th>
				<td>
					<input type="text" name="p_block_catalog" style="width:40px;" />
				</td>		
				<th>B_STR</th>
				<td>
					<input type="text" name="p_block_str" style="width:40px;" />
				</td>
				<th>ACT CATA</th>
				<td>
					<input type="text" name="p_activity_catalog" value="" style="width:40px;" />
				</td>
				<th>JOB CATA</th>
				<td>
					<input type="text" name="p_job_catalog" value="" style="width:40px;" />
				</td>
				<th>JOB_STR</th>
				<td>
					<input type="text" name="p_str" style="width:40px;" />
				</td>
				<th>사용여부</th>
				<td>
					<select name="p_use_yn" style="width:50px;" >
						<option value="" selected="selected">ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>					
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_red2" value="IMPORT" id="btnImport"/>							
						</c:if>
						<input type="button" class="btn_red2" value="EXPORT" id="btnExport"/>		
						&nbsp;&nbsp;&nbsp;
						<c:if test="${userRole.attribute2 == 'Y'}">	
							<input type="button" class="btn_blue2" value="ADD" onclick="addRow()" id="btnAdd"/>
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_blue2" onclick="fn_save()" value="SAVE"  id="btnSave"/>
						</c:if>
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
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
					{label:'구역'			 		 , name : 'area'			, index : 'area'			, width : 70, editable : true, align : "center", editrules : { required : true}},					
					{label:'B_CATA'				 , name : 'block_catalog'	, index : 'block_catalog'	, width : 70, editable : true, align : "center", editrules : { required : true}},
					{label:'B_STR'		 	 	 , name : 'block_str_flag'	, index : 'block_str_flag'	, width : 70, editable : true, align : "center", editrules : { required : true}},
					{label:'ACT CATA' 	 		 , name : 'activity_catalog', index : 'activity_catalog', width : 100, editable : false, align : "center"},
					{label:'JOB CATA'		 	 , name : 'job_catalog'		, index : 'job_catalog'		, width : 100, editable : false, align : "center"},
					{label:'JOB_STR'	 	 	 , name : 'str_flag'		, index : 'str_flag'		, width : 70, editable : true, align : "center", editrules : { required : true}},
					{label:'JOB_TYPE'		 	 , name : 'usc_job_type'	, index : 'usc_job_type'	, width : 80, editable : true, align : "center", 
						editoptions:{
							dataEvents : [ { type : 'keyup',
							 			     fn : function( e ) {
							 			     	//필수 입력 값 조정
							 			     	var item = jqGridObj.jqGrid( 'getRowData', idRow );
							 			     	
							 			     	if($("#" + kRow + "_usc_job_type").val() != ""){
							 			     		syncClassByContainRow(jqGridObj, kRow-1, 'job_description','', true, 'required_cell');
							 			     	}else{
							 			     		syncClassByContainRow(jqGridObj, kRow-1, 'job_description','', false, 'required_cell');
							 			     	}
							 				 }
							 			   } 
							             ]
						}	
					},
					{label:'JOB DESCRIPTION'	 , name : 'job_description'		, index : 'job_description'		, width : 300, editable : true, align : "left"},
					{label:'ACT_AREA'	 	 	 , name : 'activity_area'	, index : 'activity_area'	, width : 110, editable : true, align : "center"},
					{label:'ACT_TYPE'	 	 	 , name : 'activity_type'	, index : 'activity_type'	, width : 110, editable : true, align : "center"},
					{label:'ACT DESCRIPTION'	 , name : 'act_description'		, index : 'act_description'		, width : 300, editable : true, align : "left"},					
					{label:'사용'				 , name : 'use_yn'			, index : 'use_yn'			, width : 40, editable : true,  align : "center", edittype:"select",formatter : 'select',editoptions:{value:"Y:Y;N:N"}, editrules : { required : true}},
					{label:'사용_changed'		 , name : 'use_yn_changed'	, index : 'use_yn_changed'	, width : 40, hidden:true},
					{label:'REMARK'				 , name : 'remark'			, index : 'remark'			, width : 100, editable : true,  align : "center"},
					{label:'OPER'				 , name : 'oper'			, index : 'oper'			, width : 100, hidden:true},
				],
			gridview: true,
			viewrecords: true,
			autowidth: true,
			cmTemplate: { title: false },
			toolbar	: [false, "bottom"],
			rownumbers : true, 
			
			cellEdit : true,
			cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
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
				var rows = jqGridObj.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = jqGridObj.getCell( rows[i], "oper" );
					jqGridObj.jqGrid( 'setCell', rows[i], 'activity_catalog', '', { color : 'black', background : '#DADADA' } );
					jqGridObj.jqGrid( 'setCell', rows[i], 'job_catalog', '', { color : 'black', background : '#DADADA' } );
					
					if(oper != 'I'){
						jqGridObj.jqGrid( 'setCell', rows[i], 'area', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'area', '', 'not-editable-cell' );
						jqGridObj.jqGrid( 'setCell', rows[i], 'block_catalog', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'block_catalog', '', 'not-editable-cell' );						
						jqGridObj.jqGrid( 'setCell', rows[i], 'block_str_flag', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'block_str_flag', '', 'not-editable-cell' );				
						jqGridObj.jqGrid( 'setCell', rows[i], 'usc_job_type', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'usc_job_type', '', 'not-editable-cell' );
						jqGridObj.jqGrid( 'setCell', rows[i], 'job_catalog', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'job_catalog', '', 'not-editable-cell' );
						jqGridObj.jqGrid( 'setCell', rows[i], 'str_flag', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'activity_area', '', { color : 'black', background : '#DADADA' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'activity_type', '', { color : 'black', background : '#DADADA' } );						
						jqGridObj.jqGrid( 'setCell', rows[i], 'description', '', { color : 'black', background : '#DADADA' } );
					} else {
						jqGridObj.jqGrid( 'setCell', rows[i], 'activity_catalog', '', { color : 'black', background : 'pink' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'job_catalog', '', { color : 'black', background : 'pink' } );
						
					}
				}
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				var cm = $(this).jqGrid( "getGridParam", "colModel" );
				var colName = cm[iCol];
				var item = $(this).jqGrid( 'getRowData', rowid );
				if( item.oper == "I" ) {
					if ( colName['index'] == "activity_catalog" ) {
						var rs = window.showModalDialog( "popUpUscActivityStdCatalogSearch1.do", window,
								"dialogWidth:550px; dialogHeight:435px; center:on; scroll:off; status:off" );
						if ( rs != null ) {
							var rslt = rs[0].split(", ");
							for(var i = 0; i < rslt.length; i++) {
								if(i == 0) {
									$(this).setRowData( rowid, { activity_catalog : rslt[i] } );
								} else {
									item.activity_catalog = rslt[i];
									$(this).addRowData($.jgrid.randId(), item, 'after', rowid );
								}
							}
						}
					}
					if ( colName['index'] == "job_catalog" ) {
						 var rs = window.showModalDialog( "popUpUscActivityJobCatalogSearch1.do", window,
								"dialogWidth:550px; dialogHeight:435px; center:on; scroll:off; status:off" );
						if ( rs != null ) {
							var rslt = rs[0].split(", ");
							for(var i = 0; i < rslt.length; i++) {
								if(i == 0) {
									$(this).setRowData( rowid, { job_catalog : rslt[i] } );
								} else {
									item.job_catalog = rslt[i];
									$(this).addRowData($.jgrid.randId(), item, 'after', rowid );
								}
							}
						}
					}
					if ( colName['index'] == "usc_job_type" ) {
						
					}
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
     	
     	// 그리드 버튼 설정
    	jqGridObj.jqGrid('navGrid',"#jqGridMainListNavi",{refresh:false,search:false,edit:false,add:false,del:false});
    	
    	<c:if test="${userRole.attribute2 == 'Y'}">	
    		// 그리드 Row 추가 함수 설정
    	 	jqGridObj.navButtonAdd('#jqGridMainListNavi',
    				{ 	caption:"", 
    					buttonicon:"ui-icon-plus", 
    					onClickButton: addRow,
    					position: "first", 
    					title:"Add", 
    					cursor: "pointer"
    				} 
    		);
     	</c:if>
     	// JOB 구분 콤보박스
     	$.post( "infoComboCodeMaster.do?sd_type=USC_JOB_ATTR", "", function( data ) {
     		jqGridObj.setObject( {
				value : 'value',
				text : 'text',
				name : 'usc_job_type',
				data : data
			} );
		}, "json" );
     	// 구역 선택
     	$.post( "infoAreaList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_area").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
     	
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 30 );
     	
	  //Search 버튼 클릭 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			fn_search(); 
		});
	  
		//Excel Import 클릭
		$("#btnImport").click(function(){
			
			var sURL = "popUpUscActivityJobExcelImport.do";
			var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);
		});
     	
	  //엑셀 export 버튼
		$("#btnExport").click(function() {
			//fn_downloadStart();
			fn_excelDownload();	
		});
	});
	
 	
 	// Add 버튼 
 	function addRow(item) {
 		$( '#jqGridMainList' ).saveCell( kRow, idCol );
 		var item = {};
 		var colModel = jqGridObj.jqGrid('getGridParam', 'colModel');
 		for(var i in colModel) item[colModel[i].name] = '';
 		item.use_yn_changed = 'Y';
 		item.use_yn = 'Y';
 		item.oper = 'I';
 		jqGridObj.resetSelection();
 		jqGridObj.jqGrid('addRowData', $.jgrid.randId(), item, 'first');
 	}
 
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
		
		var sUrl = "uscActivityJobList.do";
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
				for(var i = 0; i < data.length; i++) {
					if(data[i].area == '' || data[i].area == undefined) {
						alert("구역을 입력하십시오.");
						return;
					} else if(data[i].block_catalog == '' || data[i].block_catalog == undefined) {
						alert("B_CATA를 입력하십시오.");
						return;
					} else if(data[i].block_str_flag == '' || data[i].block_str_flag == undefined) {
						alert("B_STR를 입력하십시오.");
						return;
					} /*else if(data[i].activity_catalog == '' || data[i].activity_catalog == undefined) {
						alert("ACT_ITEM_CATA를 선택하십시오.");
						return;
					} else if(data[i].activity_catalog != 'V81' && (data[i].job_catalog == '' || data[i].job_catalog == undefined)) {
						alert("JOB_ITEM_CATA를 입력하십시오.");
						return;
					}*/
				}
				
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				chmResultRows = data;
				
				if(data.length == 0) {
					alert( "변경된 내용이 없습니다." );
					lodingBox.remove();	
				} else {	
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveUscActivityJob.do';
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
				}
			} );
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
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
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
		f.action = "uscActivityJobExcelExport.do";
		f.method = "post";
		f.submit();
	}
</script>
</body>

</html>
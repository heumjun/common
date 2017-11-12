<%--*************************************
@DESCRIPTION				: Standard Code List
@AUTHOR (MODIFIER)			: 정재동
@FILENAME					: systemStandardView.jsp
@CREATE DATE				: 2016-09-08
*************************************--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Registration Request</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	<style>
		table {font-size:98%}
		.btn_common {width:50px; margin:2px; text-align:center}
	</style>
	<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var lastSelection;
		
		var idFileRow;
		var idFileCol;
		var kFileRow;
		var kFileCol;
		
		var resultData = [];
		
		$(document).ready(function(){
			//grid height resizing
			
			makeStandardCodeGrid();
			makeAttachFileGrid();
			
			//jqGrid 크기 동적화
         
         	gridResizing();
			$(window).resize(function() {
				gridResizing();
			});

			//######## 엑셀버튼  ########//
			$("#btnExcel").click(function(){
				jqGridExcel();
			});
			
			//######## 검색버튼  ########//
			$("#btnSearch").click(function(){
				jqGridReload();
			});
			
			//######## 행추가버튼  ########//
			$("#btnLineAdd").click(function(){
				jqGridLineAdd();
			});
			
			//######## 행삭제버튼  ########//
			$("#btnLineDel").click(function(){
				jqGridLineDel();
			});
			
			//######## 저장버튼  ########//
			$("#btnSave").click(function(){
				jqGridSave();
			});
			
			//######## 닫기버튼  ########//
			$("#btnClose").click(function(){
				window.close();
			});
			
			//######## 파일검색버튼  ########//
			$("#btnFileSearch").click(function(){
				jqGridFileReload();
			});
			
			//######## 파일첨부버튼  ########//
			$("#btnFileAdd").click(function(){
				jqGridFileAdd();
			});
			
			//######## 파일삭제버튼  ########//
			$("#btnFileDel").click(function(){
				jqGridFileDel();
			});
			
			//######## 파일저장버튼  ########//
			$("#btnFileSave").click(function(){
				jqGridFileSave();
			});
			
			//key evant 
			$(".searchArea input").keypress(function(event) {
			    if (event.which == 13) {
			        event.preventDefault();
			        $('#btnSearch').click();
			    }
			});
		});
		
		//grid height resizing
		function gridResizing() {
			var gridHeight = $(window).height() - 740; 
			$("#standardCodeGrid").setGridHeight(350);
			$("#attachFileGrid").setGridHeight(gridHeight);
			
			$("#standardCodeGrid").setGridWidth($(".content").width());
			$("#attachFileGrid").setGridWidth($(".content").width());
		}
		
		
		//######## 엑셀버튼  ########//
		function jqGridExcel() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#standardCodeGrid" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#standardCodeGrid" ).jqGrid( "getGridParam", "colModel" );
			for(var i=2; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
					colName.push(cn[i]);
					dataName.push(cm[i]['index']);	
				}
			}
			$( '#p_col_name' ).val(colName);
			$( '#p_data_name' ).val(dataName);
			$("#p_isexcel").val("Y");
			var f    = document.application_form;
			f.action = "systemStandardExcelExport.do";
			f.method = "post";
			f.submit();
			
		}
		
		//######## 검색버튼  ########//
		function jqGridReload() {
			$(".searchArea input").each(function() {
				$(this).val($(this).val().toUpperCase());
			});
			
			$("#p_isexcel").val("");
			
			var sUrl = "systemStandardViewList.do";
			
			$("#standardCodeGrid").jqGrid("clearGridData");
			$('#standardCodeGrid').jqGrid('setGridParam', {url : sUrl, page : 1, datatype : "json", postData : fn_getFormData('#application_form')}).trigger('reloadGrid');
		}
		
		//######## 행추가버튼  ########//
		function jqGridLineAdd() {
			$("#standardCodeGrid").saveCell(kRow, kCol);
			
			var item = {};
			var colModel = $("#standardCodeGrid").jqGrid('getGridParam', 'colModel');
			for(var i in colModel)
				item[colModel[i].name] = '';
			
			item.oper = "I";
			
			$('#standardCodeGrid').resetSelection();
			$('#standardCodeGrid').jqGrid('addRowData', $.jgrid.randId(), item, 'first');
		}
		
		//######## 행삭제버튼  ########//
		function jqGridLineDel() {
			$("#standardCodeGrid").saveCell(kRow, kCol);
			var selarrrow = $('#standardCodeGrid').jqGrid('getGridParam', 'selarrrow');
			var length = selarrrow.length;
			var j = 0;
			
			for(var i = 0; i < length; i++) {
				var item = $('#standardCodeGrid').jqGrid('getRowData', selarrrow[j]);
				
				if(item.oper == "I") {
					$('#standardCodeGrid').jqGrid('delRowData', selarrrow[j]);
				} else {
					if(item.oper == "D") {
						item.oper = item.tmp_oper;
						$('#standardCodeGrid').jqGrid("setRowData", selarrrow[j], item);
						$('#standardCodeGrid').jqGrid('setRowData', selarrrow[j], false, { background : '' });
						j++;
					} else {
						item.tmp_oper = item.oper;
						item.oper = "D";
						$('#standardCodeGrid').jqGrid("setRowData", selarrrow[j], item);
						$('#standardCodeGrid').jqGrid('setRowData', selarrrow[j], false, { background : '#FF7E9D' });
						j++;
					}
				}
			}
		}
		
		//######## 저장버튼  ########//
		function jqGridSave() {
			$("#standardCodeGrid").saveCell(kRow, kCol);			
			
			if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveSystemStandardView.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							jqGridReload();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				} );
			}
		}
		
		//######## 파일첨부검색버튼  ########//
		function jqGridFileReload() {
		
			var sUrl = "systemStandardViewFileList.do";
		
			$("#attachFileGrid").jqGrid("clearGridData");
			$('#attachFileGrid').jqGrid('setGridParam', {url : sUrl, page : 1, datatype : "json", postData : fn_getFormData('#application_form')}).trigger('reloadGrid');
		}
		
		//######## 파일첨부버튼  ########//
		function jqGridFileAdd() {
			var sUrl = "popUpSystemStandardDoc.do";
			
			var nwidth = 290;
			var nheight = 200;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
		
			var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=no";
			window.open(sUrl,"winpop",sProperties);
		}
		
		//######## 파일삭제버튼  ########//
		function jqGridFileDel() {
		$("#attachFileGrid").saveCell(kFileRow, kFileCol);
			var selarrrow = $('#attachFileGrid').jqGrid('getGridParam', 'selarrrow');
			var length = selarrrow.length;
			
			for(var i = 0; i < length; i++) {
				var item = $('#attachFileGrid').jqGrid('getRowData', selarrrow[i]);

				if(item.oper == "D") {
					item.oper = "";
					$('#attachFileGrid').jqGrid("setRowData", selarrrow[i], item);
					$('#attachFileGrid').jqGrid('setRowData', selarrrow[i], false, { background : '' });
				} else {
					item.oper = "D";
					$('#attachFileGrid').jqGrid("setRowData", selarrrow[i], item);
					$('#attachFileGrid').jqGrid('setRowData', selarrrow[i], false, { background : '#FF7E9D' });
				}
			}
		}
		
		//######## 파일저장버튼  ########//
		function jqGridFileSave() {
			$("#attachFileGrid").saveCell(kRow, kCol);
			
			if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
				var chmResultRows = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmFileResultData( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveSystemStandardFile.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							jqGridFileReload();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				} );
			}
		}
		
		//######## 파일다운버튼  ########//
		function jqGridFileDownload(file_id) {
			var attURL = "systemStandardFileDownload.do?";
		    attURL += "file_id="+file_id;
	
		    var sProperties = 'dialogHeight:340px;dialogWidth:380px;scroll=no;center:yes;resizable=no;status=no;';
	
		    window.open(attURL,"",sProperties);
		   
		}
		
		//가져온 배열중에서 필요한 배열만 골라내기(Standard Code)
		function getChangedChmResultData( callback ) {
			var changedData = $.grep($("#standardCodeGrid").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		
		//가져온 배열중에서 필요한 배열만 골라내기(Attach File)
		function getChangedChmFileResultData( callback ) {
			var changedData = $.grep($("#attachFileGrid").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'D';
			});
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		
		function makeStandardCodeGrid() {
			$("#standardCodeGrid").jqGrid({
	             datatype: 'json', 
	             mtype: 'POST', 
	             url:'',
	             postData : fn_getFormData('#application_form'),
                 colModel:[
                 	{label:'st_id_s', name:'st_id_s', index:'st_id_s', width:80, align:'left', sortable:false, hidden : true},
					{label:'영문명', name:'st_title', index:'st_title', width:300, align:'left', sortable:false, editable:true},
					{label:'물리명/약어', name:'st_key', index:'st_key', width:120, align:'left', sortable:false, editable:true},
					{label:'Description', name:'st_desc', index:'st_desc', width:200, align:'left', sortable:false, editable:true},
					{label:'한글명1', name:'st_priority_1', index:'st_priority_1', width:200, align:'left', sortable:false, editable:true},
					{label:'한글명2', name:'st_priority_2', index:'st_priority_2', width:200, align:'left', sortable:false, editable:true},
					{label:'한글명3', name:'st_priority_3', index:'st_priority_3', width:200, align:'left', sortable:false, editable:true},
					{label:'한글명4', name:'st_priority_4', index:'st_priority_4', width:200, align:'left', sortable:false, editable:true},
					{label:'한글명5', name:'st_priority_5', index:'st_priority_5', width:200, align:'left', sortable:false, editable:true},
					{label:'한글명6', name:'st_priority_6', index:'st_priority_6', width:200, align:'left', sortable:false, editable:true},
					{label:'수정일', name:'last_update_date', index:'last_update_date', width:100, align:'center', sortable:false},
					{label:'수정자', name:'last_updated_by', index:'last_updated_by', width:80, align:'center', sortable:false},
					{label:'생성일', name:'creation_date', index:'creation_date', width:100, align:'center', sortable:false, hidden:true},
					{label:'생성자', name:'created_by', index:'created_by', width:80, align:'center', sortable:false, hidden:true},
					{label:'oper', name:'oper', index:'oper', width:80, align:'center', sortable:false, hidden:true},
					{label:'tmp_oper', name:'tmp_oper', index:'tmp_oper', width:80, align:'center', sortable:false, hidden:true},
                 ],
	             gridview: true,
	             toolbar: [false, "bottom"],
	             viewrecords: true,
	             autowidth: true,
	             caption: '시스템 표준 용어/명칭',
	             scrollOffset : 18,	             
	             multiselect: true,
	             pager: jQuery('#bottomstandardCodeGrid'),
	             cellEdit : true, // grid edit mode 1
			     cellsubmit : 'clientArray', // grid edit mode 2
	             //height: gridHeight,
	             rowList:[1000,5000,10000],
		         rowNum:1000,
		         rownumbers : true,
				 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	             	idRow=rowid;
	             	idCol=iCol;
	             	kRow = iRow;
	             	kCol = iCol;
	   			 },
	   			afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        },
	   			 afterSaveCell : function( rowid, cellname, value, iRow, iCol ) {
					
					var item = $( this ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I' && item.oper != 'D'){
						item.oper = 'U';
						$(this).jqGrid('setCell', rowid, cellname, value, { 'background' : '#6DFF6D' } );
					}
					$( this ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
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
					$(this).jqGrid("clearGridData");			    	
		 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  
	
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
				 }
			}); //end of jqGrid
		}
		
		
		function makeAttachFileGrid() {
			$("#attachFileGrid").jqGrid({
	             datatype: 'json', 
	             mtype: 'POST', 
	             url:'',
	             postData : fn_getFormData('#application_form'),
                 colModel:[
                 	{label:'FILE_ID', name:'file_id', index:'file_id', width:80, align:'left', sortable:false, hidden : true},
					{label:'파일명', name:'file_name', index:'file_name', width:400, align:'left', sortable:false, classes : "handcursor"},
					{label:'수정일', name:'last_update_date', index:'last_update_date', width:120, align:'left', sortable:false},
					{label:'수정자', name:'last_updated_by', index:'last_updated_by', width:200, align:'left', sortable:false},
					{label:'생성일', name:'creation_date', index:'creation_date', width:200, align:'left', sortable:false},
					{label:'생성자', name:'created_by', index:'created_by', width:200, align:'left', sortable:false},
					{label:'oper', name:'oper', index:'oper', width:80, align:'center', sortable:false, hidden : true},
					{label:'tmp_oper', name:'tmp_oper', index:'tmp_oper', width:80, align:'center', sortable:false, hidden : true},
                 ],
	             gridview: true,
	             toolbar: [false, "bottom"],
	             viewrecords: true,
	             autowidth: true,
	             caption: '시스템 표준 형식 첨부파일',
	             hidegrid : false,
	             scrollOffset : 18,	             
	             multiselect: true,
	             pager: jQuery('#bottomattachFileGrid'),
	             cellEdit : true, // grid edit mode 1
			     cellsubmit : 'clientArray', // grid edit mode 2
	             //height: gridHeight,
	             rowList:[10,30,50],
		         rowNum:10, 
		         rownumbers : true,
				 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
	             	idFileRow=rowid;
	             	idFileCol=iCol;
	             	kFileRow = iRow;
	             	kFileCol = iCol;
	   			 },
	   			 afterSaveCell : function( rowid, cellname, value, iRow, iCol ) {
					
					var item = $( this ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I' && item.oper != 'D')
						item.oper = 'U';
					$( this ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
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
	   		
					$(this).jqGrid("clearGridData");
			
			    	
		 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  
	
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
				 afterInsertRow : function(rowid, rowdata, rowelem){
						jQuery("#"+rowid).css("background", "#0AC9FF");
			        },
				 onCellSelect : function(rowid, iCol, cellcontent, e) {
					$(this).saveCell(kFileRow, kFileCol);
					 
					var cm = $(this).jqGrid("getGridParam", "colModel");
					var colName = cm[iCol];
					var item = $(this).jqGrid('getRowData', rowid);
					
					var file_id = item.file_id;
					
					if (colName['index'] == "file_name") {
						jqGridFileDownload(file_id);
					}
				 }
			}); //end of jqGrid
		}
		</script>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div class="subtitle">
			시스템 표준관리
			<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif" />&nbsp;필수입력사항</span>
		</div>
		<form id="application_form" name="application_form" >
			
			<input type="hidden" name="p_isexcel" id="p_isexcel" />
			<input type="hidden" id="p_col_name" name="p_col_name"/>
			<input type="hidden" id="p_data_name" name="p_data_name"/>
			
			<table class="searchArea conSearch">
				<tr>
					<td>영문명</td>
					<td width="165"><input style="width:150px;" type="text" id="p_eng_keyworkd" name="p_eng_keyworkd" /></td>
					<td>물리명/약어</td>
					<td width="165"><input style="width:150px;" type="text" id="p_key_keyworkd" name="p_key_keyworkd" /></td>
					<td>Description</td>
					<td width="165"><input style="width:150px;" type="text" id="p_desc_keyworkd" name="p_desc_keyworkd" /></td>
					<td>한글명</td>
					<td width="165"><input style="width:150px;" type="text" id="p_kor_keyworkd" name="p_kor_keyworkd" /></td>
					<td>
						<div class="button">
							<input type="button" class="btn_blue" id="btnExcel" value="엑셀"/>
							<input type="button" class="btn_blue" id="btnSearch" value="조회"/>
							<input type="button" class="btn_blue" id="btnLineAdd" value="행추가"/>
							<input type="button" class="btn_blue" id="btnLineDel" value="행삭제"/>
							<input type="button" class="btn_blue" id="btnSave" value="저장"/>
<!-- 							<input type="button" class="btn_blue" id="btnClose" value="닫기"/> -->
						</div>
					</td>
				</tr>
			</table>
				
			
			<div class="content">
				<table id="standardCodeGrid"></table>
				<div id="bottomstandardCodeGrid"></div>
				<br />
				<table class="searchArea conSearch" style="border-top:0px;">
					<tr>
						<td>
							<div class="button">
								<input type="button" class="btn_blue" id="btnFileSearch" value="파일조회"/>
								<input type="button" class="btn_blue" id="btnFileAdd" value="파일첨부"/>
								<input type="button" class="btn_blue" id="btnFileDel" value="파일삭제"/>
								<input type="button" class="btn_blue" id="btnFileSave" value="저장"/>
							</div>
						</td>
					</tr>
				</table>
				
				<table id="attachFileGrid"></table>
				<div id="bottomattachFileGrid"></div>
			</div>
			
		</form>
	</div>	
</body>
</html>

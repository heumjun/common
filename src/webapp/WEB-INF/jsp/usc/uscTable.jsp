<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC TABLE</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
	<input type="hidden" id="p_col_name" name="p_col_name"/>
	<input type="hidden" id="p_data_name" name="p_data_name"/>
	<input type="hidden" id="temp_project_no" name="temp_project_no" value="" />
		<div class="subtitle">
		USC TABLE
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="50"/>
			<col width="80"/>
			<col width="50"/>
			<col width="60"/>
			<col width="50"/>
			<col width="90"/>
			<col width="50"/>
			<col width="60"/>
			<col width="50"/>
			<col width="90"/>
			<col width="*"/>
			<tr>
				<th>Project</th>
				<td>
					<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:60px;" value="" onblur="javascript:getDwgNos();"  />
				</td>
				<th>B_NAME</th>
				<td>
					<input type="text" name="p_block_no" style="width:40px;" />
				</td>
				<th>구역</th>
				<td>
					<!--<input type="text" id="p_area_code" name="p_area_code"  style="width:80px;" alt="구역" />-->
					<select name="p_area" id="p_area" style="width:70px;">
						<option value="%">ALL</option>
					</select>
				</td>		
				<th>B_CATA</th>
				<td>
					<input type="text" name="p_block_catalog" style="width:40px;" />
				</td>		
				<th>B_STR</th>
				<td>
					<!--<input type="text" name="p_str_flag" style="width:50px;" />-->
					<select name="p_str_flag" id="p_str_flag" style="width:70px;">
						<option value="%">ALL</option>
					</select>
				</td>				
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<input type="button" class="btn_blue2" value="EXPORT" id="btnExport"/>		
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
		//엔터 버튼 클릭
		$("*").keypress(function(event) {
		  if (event.which == 13) {
		        event.preventDefault();
		        $('#btnSelect').click();
		    }
		});
		
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		
		jqGridObj.jqGrid({ 
             datatype: 'json',
             url:'',
             mtype : '',
             postData : fn_getFormData('#application_form'),
             colNames : ['PROJECT','BLOCK','구역','B_CATA','B_STR'],
			colModel : [
					{name : 'project_no'		, index : 'project_no'		, width : 70, editable : false, align : "center"},
					{name : 'block_no'			, index : 'block_no'		, width : 70, editable : false, align : "center"},
					{name : 'area'				, index : 'area'			, width : 70, editable : false, align : "center"},					
					{name : 'item_catalog'		, index : 'item_catalog'	, width : 70, editable : false, align : "center"},
					{name : 'str_flag'			, index : 'str_flag'		, width : 70, editable : false, align : "center"}					
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
			multiselect: false,			
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
				var cm = $(this).jqGrid( "getGridParam", "colModel" );
				var colName = cm[iCol];
				var item = $(this).jqGrid( 'getRowData', rowid );

			}
     	}); //end of jqGrid
     	
     	// 그리드 버튼 설정
    	jqGridObj.jqGrid('navGrid',"#jqGridMainListNavi",{refresh:false,search:false,edit:false,add:false,del:false});
    	
    	// 구역 선택
     	$.post( "infoAreaList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_area").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
    	
     	$.post( "infoStrList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_str_flag").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
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
     	
	    //엑셀 export 버튼
		$("#btnExport").click(function() {
			fn_downloadStart();
			fn_excelDownload();	
		});
	});
	
	// 조회 버튼
	function fn_search() {		
		uscTablereGrid("uscTableList.do");
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
		f.action = "uscTableExcelExport.do";
		f.method = "post";
		f.submit();
	}
	
	var getDwgNos = function(){
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		}
	}
	
	var uscTablereGrid = function(sUrl) {
		var colNms = new Array();
		var colModels = new Array();
		
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		
		colNms.push('PROJECT');
		colNms.push('BLOCK');
		colNms.push('구역');
		colNms.push('B_CATA');
		colNms.push('B_STR');

		colModels.push({name : 'project_no'		, index : 'project_no'		, width : 70, editable : false, align : 'center'});
		colModels.push({name : 'block_no'		, index : 'block_no'		, width : 70, editable : false, align : 'center'});
		colModels.push({name : 'area'			, index : 'area'			, width : 70, editable : false, align : 'center'});
		colModels.push({name : 'item_catalog'	, index : 'item_catalog'	, width : 70, editable : false, align : 'center'});
		colModels.push({name : 'str_flag'		, index : 'str_flag'		, width : 70, editable : false, align : 'center'});
		
		$.post( "infoUscTableColList.do", "", function( data ) {
			for(var i = 0; i < data.rows.length; i++) {
				colNms.push(data.rows[i].activity_catalog);
				colModels.push({name : data.rows[i].activity_catalog.toLowerCase()	, index : data.rows[i].activity_catalog.toLowerCase(), width : 70, editable : false, align : 'center'});
			}
			$("#jqGridMainList").GridUnload();
			$("#jqGridMainList").jqGrid({ 
	             datatype: 'json',
	             url:sUrl,
	             mtype : 'POST',
	             postData : fn_getFormData('#application_form'),
	             colNames : colNms,
				 colModel : colModels,
				 gridview: true,
				 viewrecords: true,
				 autowidth: true,
				 cmTemplate: { title: false },
				 toolbar	: [false, "bottom"],
				 rownumbers : true, 			
				 cellEdit : true,
				 cellsubmit : 'clientArray', // grid edit mode 2
				 scrollOffset : 17,
				 multiselect: false,
				 pgbuttons 	: false,
				 pgtext 	: false,
				 pginput 	: false,
				 height: 460,
				 pager: '#jqGridMainListNavi',
				 rowNum:999999,
				 //rowList:[100,500,1000],				  
				 //recordtext: '내용 {0} - {1}, 전체 {2}',
				 recordtext: '전체 {2}',
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
			 		var $this = $(this);
					if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid('setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						});

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if ($this.jqGrid('getGridParam', 'sortname') !== '') {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler('reloadGrid');
						}
					} else {
						$this.jqGrid('setGridParam', {
							page: $this.jqGrid('getGridParam', 'pageServer'),
							records: $this.jqGrid('getGridParam', 'recordsServer'),
							lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
						} );
						this.updatepager(false, true);
					}					
				 },
				 gridComplete: function(datas){
					 var row = $("#jqGridMainList").getDataIDs();	
					 for ( var i = 0; i < row.length; i++ ) {
						 for( var j = 0; j < data.rows.length; j++) {							 
							 var act_code = $("#jqGridMainList").getCell( row[i], data.rows[j].activity_catalog.toLowerCase() );		
							 
							 if(act_code == "0(0)") {
								 $("#jqGridMainList").setCell( row[i], data.rows[j].activity_catalog.toLowerCase(), '-');
							 } else {
								 $("#jqGridMainList").setCell( row[i], data.rows[j].activity_catalog.toLowerCase(), '', { color : 'red', background : 'yellow' } );
							 }
						 }
					 }
					 for( var k = 0; k < data.rows.length; k++) {	
					 	$('#jqGridMainList').jqGrid('setLabel', data.rows[k].activity_catalog.toLowerCase(), data.rows[k].activity_catalog, {background : 'pink'});	
					 }
				 },
				 onCellSelect : function( rowid, iCol, cellcontent, e ) {
					 var cm = $(this).jqGrid( "getGridParam", "colModel" );
					 var colName = cm[iCol];
					 var item = $(this).jqGrid( 'getRowData', rowid );
					 if ( $("#jqGridMainList").getCell(rowid, iCol) != "-" &&
							 colName['index'] != "project_no" &&
							 colName['index'] != "block_no" &&
							 colName['index'] != "area" &&
							 colName['index'] != "item_catalog" &&
							 colName['index'] != "str_flag") {
						 var pos = abspos(e);
						 var popOptions = "top="+pos.y+", left="+pos.x+", width=240, height=140, resizable=no, status=no, menubar=no, toolbar=no, scrollbars=no, location=no"
						 var rs = window.open( "popUpUscTableDetail.do?p_project_no="+item.project_no+"&p_block_no="+item.block_no+"&p_area="+item.area+
									"&p_block_catalog="+item.item_catalog+"&p_str_flag="+item.str_flag+"&p_act_catalog="+colName['index'].toUpperCase(), "tableDetail",
									popOptions);
						 //rs.focus();
					 }
				}
	     	}); //end of jqGrid
			//grid resize
		    fn_gridresize( $(window), $("#jqGridMainList"), 30 );
		}, "json" );		
	} 
	
	function abspos(e){
	    this.x = e.clientX + (document.documentElement.scrollLeft?document.documentElement.scrollLeft:document.body.scrollLeft) + 100;
	    this.y = e.clientY + (document.documentElement.scrollTop?document.documentElement.scrollTop:document.body.scrollTop) + 50;
	    return this;
	}
</script>
</body>

</html>
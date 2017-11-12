<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PURCHASING - ADD</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
	.viewBtnGroup_off{
		display: none;
	}
	.viewBtnGroup_on{
		display: inline;
	}
</style>
</head>
<body>
	<form id="application_form" name="application_form" >
		<input type="hidden" 	name="user_name" 		id="user_name"  	value="${loginUser.user_name}"		 	/>
		<input type="hidden" 	name="user_id" 			id="user_id"  		value="${loginUser.user_id}"		 	/>
		<input type="hidden" 	name="p_dp_dept_code" 	id="p_dp_dept_code" value="${loginUser.dwg_dept_code}" 		/>
		<input type="hidden" 	name="p_master"    		id="p_master" 		value="${p_master}"						/>
		<!-- 도면 Auto 부르기 위해 마스터 히든값 추가 -->
		<input type="hidden" 	name="p_project_no"    	id="p_project_no" 	value="${p_master}"					/>
		<!-- 도면 Auto 부르기 위해 마스터 히든값 추가 -->
		
		<input type="hidden" 	name="p_session_id"    	id="p_session_id" 	value="${p_session_id}"					/>
		
		<!-- 엑셀출력용 -->
		<input type="hidden" id="p_col_name" name="p_col_name" value="" />
		<input type="hidden" id="p_data_name" name="p_data_name" value="" />
		<input type="hidden" id="p_not_display_col_name" name="p_not_display_col_name" value="" />
		<input type="hidden" id="p_not_display_data_name" name="p_not_display_data_name" value="" />
		
		
		<div id="hiddenArea"></div>
		
		<div id="mainDiv" class="mainDiv">
			<div class= "subtitle" style="width: 96.5%;">
			Purchasing Add
			<jsp:include page="../../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>
					 
			<table class="searchArea conSearch">
				<col width="65%">
				<col width="*">
				<tr>
				<td class="sscType" style="border-right:none;"> 
					선종
					<select name="p_ship_type" id="p_ship_type" style="width:70px;" class="required" alert="선종"></select>
					&nbsp;
					DWG NO.
					<input type="text" class="required" id="p_dwg_no" name="p_dwg_no" style="width:70px; ime-mode:disabled;" onChange="javascript:this.value=this.value.toUpperCase();" value="${p_dwg_no }" onkeyup="chkAsterisk(this);" alt='도면번호'/>
					&nbsp;
					ITEM CODE
					<input type="text" id="p_item_code" maxlength="20" name="p_item_code" style="width:90px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
					&nbsp;
					ITEM DESC
					<input type="text" id="p_item_desc" name="p_item_desc" style="width:200px; ime-mode:disabled;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
					&nbsp;
				</td>
				<td style="border-left:none;">
					<div class="button endbox">
							<input type="button" value="EXPORT" id="btnExport"  class="btn_red2	viewBtnGroup_on"			/>
							<input type="button" value="IMPORT" id="btnImport"  class="btn_red2 viewBtnGroup_on"			/>
							<input type="button" value="SEARCH" id="btnSearch"  class="btn_blue2 viewBtnGroup_on" 			/>
							<input type="button" value="POS" 	id="btnPos"  	class="btn_blue2 viewBtnGroup_on" 			/>
							<input type="button" value="NEXT" 	id="btnNext" 	class="btn_blue2 viewBtnGroup_on" 			/>
							<input type="button" value="BACK" 	id="btnBack"  	class="btn_blue2 viewBtnGroup_off" 			/>
							<input type="button" value="APPLY" 	id="btnApply" 	class="btn_blue2 viewBtnGroup_off"			/>
					</div>
				</td>						
				</tr>
			</table>
			<div class="series"> 
				<table class="searchArea">
					<tr>
						<td>
							<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
						</td>
					</tr>
				</table>
			</div>
			<div class="content" id="first">
				<table id="jqGridPuchasingFristAddList"></table>
				<div id="btnJqGridPuchasingFristAddList"></div>
			</div>
			<div class="content" id="second">
				<table id="jqGridPuchasingSecondAddList"></table>
				<div id="btnJqGridPuchasingSecondAddList"></div>
			</div>
		</div>
	</form>
<script type="text/javascript" >
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var lastSelection;
	var asteric = false;
	var firstGrid = $("#jqGridPuchasingFristAddList");
	var secondGrid = $("#jqGridPuchasingSecondAddList");
	var resultData = [];
	
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
	
	//도면번호 받아온 후
	var getdwgnoCallback = function(txt){
		var arr_txt = txt.split("|");
	    $("#p_dwg_no").autocomplete({
			source: arr_txt,
			minLength:1,
			matchContains: true, 
			max: 30,
			autoFocus: true,
			selectFirst: true,
			open: function () {
				$(this).removeClass( 'ui-corner-all' ).addClass( 'ui-corner-top' );
			},
			close: function () {
				$(this).removeClass( 'ui-corner-top' ).addClass( 'ui-corner-all' );
		    }
	    });
	}
	
	function chkAsterisk(obj){
		if(obj.value.indexOf("*") > -1){
			$(".button.endbox").find("input[type=button]").each(function(index){
				$(this).removeClass("btn_red2");
				$(this).removeClass("btn_blue2");
				$(this).addClass("btn_disable").attr("disabled",true);
			})
			if(!asteric)alert("'*'사용시 전체기능이 제한이 됩니다.");
			asteric = true;
		} else {
			$(".button.endbox").find("input[type=button]").each(function(index){
				$(this).removeClass("btn_disable").removeAttr("disabled",false);
				if($(this).attr("id") != "btnExport" && $(this).attr("id") != "btnImport" ){
					$(this).addClass("btn_blue2");
				}
				else $(this).addClass("btn_red2");
			})
			asteric = false;
		}
	}
	function btnViewChanger(){
		$(".button.endbox").find("[class*=viewBtnGroup_]").each(function(index){
			if($(this).attr("class").indexOf("viewBtnGroup_on") > 0){
				$(this).removeClass("viewBtnGroup_on");
				$(this).addClass("btn_disable").attr("disabled",true);
				$(this).addClass("viewBtnGroup_off");
			} else {
				$(this).removeClass("viewBtnGroup_off");
				$(this).removeClass("btn_disable").attr("disabled",false);
				$(this).addClass("viewBtnGroup_on");
			}
		});
	}
	
	function disableRow(jqGridObj,rowId,cellNameAry,disableClr){
		for(var i = 0; i < cellNameAry.length; i++){
			jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', 'not-editable-cell' );
			if(disableClr == undefined)jqGridObj.jqGrid( 'setCell', rowId, cellNameAry[i], '', { color : 'black', background : '#dadada' } );
			
		}
	}
	
	function popUpPosCallBack(data){
		var chk_ids = firstGrid.jqGrid('getGridParam','selarrrow');
		var split_data = data.p_callbackmsg.split(",");
		var file_id = split_data[0];
		var pos_rev = split_data[1];
		var yn_chk = split_data[2];

		for(var i=0; i < chk_ids.length; i++){
			firstGrid.jqGrid( 'setCell', chk_ids[i], 'pos', yn_chk);
			if(yn_chk == "N"){
				pos_rev = "&nbsp;";
				file_id = "&nbsp;";
			}
			firstGrid.jqGrid( 'setCell', chk_ids[i], 'pos_rev', pos_rev);
			firstGrid.jqGrid( 'setCell', chk_ids[i], 'file_id', file_id);
		}
	}
	
	function getChkedChmResultData(gridObj,callback) {
		var chk_ids = gridObj.jqGrid('getGridParam','selarrrow');
		var changedData = [];
		for(var i = 0; i< chk_ids.length; i++){
			changedData.push(gridObj.jqGrid('getRowData',chk_ids[i]));
		}
		callback.apply(this, [ changedData.concat(resultData) ]);
	}
	
	function getChmResultData(gridObj,callback) {
		var changedData = $.grep(gridObj.jqGrid('getRowData'),
				function(obj) {
					return true;
				});
		callback.apply(this, [ changedData.concat(resultData) ]);
	}
	
	function setGridExcel(uploadList){

		var aryJson = new Array();
		
 		aryJson = JSON.parse(uploadList); 
 		/* aryJson = uploadList.uplist; */
		
 		//jqGrid 초기화
 		firstGrid.jqGrid("clearGridData");
		
 		//jqGrid Row 입력
 		for(var i=0;i<=aryJson.length;i++){

 			firstGrid.jqGrid('addRowData',i+1,aryJson[i]);
 		}
 		//List Validation
 		validationList();

	} 
	//jqGrid Binding 이후 Validation 체크
	function validationList(){
	
		//jqGrid의 rowData를 받아옴.					
		var errData = $.grep( firstGrid.jqGrid( 'getRowData' ), function( obj ) {
			return true;
		});
		
		//DB Master에 없는 데이터는 색깔 표시
		for(var i=0; i < errData.length; i++){
			var ary = ['ship_kind','master','dwg_no','dwg_desc','item_code','item_desc','pos'];
			disableRow(firstGrid,i+1,ary);
			
			firstGrid.jqGrid('setCell',i+1,"ship_kind",$("#p_ship_type").val());
			firstGrid.jqGrid('setCell',i+1,"dwg_no",$("#p_dwg_no").val());
			firstGrid.jqGrid('setCell',i+1,"pos",'N');
			firstGrid.jqGrid( 'setCell', i+1, 'ea', '', { color : 'black', background : '#FFFFCC' } );
			firstGrid.jqGrid( 'setCell', i+1, 'location_no', '', { color : 'black', background : '#FFFFCC' } );
			firstGrid.jqGrid( 'setCell', i+1, 'stage_no', '', { color : 'black', background : '#FFFFCC' } );
			firstGrid.jqGrid( 'setCell', i+1, 'supply_type', '', { color : 'black', background : '#FFFFCC' } );
		}
	}
	
	$(document).ready(function(){
	
		//Dept. 조회조건 SelectBox 리스트를 불러옴
		$.post( "emsNewPurchasingAddSelectBoxPjt.do?master=" + $("#p_master").val(), "", function( data ) {
			for(var i =0; i < data.length; i++){
				 $("#p_ship_type").append("<option value='"+data[i].ship_info+"'>"+data[i].ship_info+"</option>");
			}
			
		}, "json" );
		$.ajaxSetup({async: false});
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_project_no="+$("#p_master").val()+"&p_ischeck=N", null);
		getAjaxTextPost(null, "emsNewAutoCompleteDwgNoList.do", $('#application_form').serialize(), getdwgnoCallback);
		$.ajaxSetup({async: true});
		
		firstGrid.jqGrid({ 
			datatype: 'json', 
	        mtype: 'POST', 
	        url:'',
	        postData : fn_getFormData('#application_form'),
	        colModel:[				
	                  				{label:'선종', 				name:'ship_kind', 	index:'ship_kind', 	width:50, 	align:'center', sortable:false, title:false},
	                				{label:'DWG No.', 			name:'dwg_no', 		index:'dwg_no', 	width:60, 	align:'center', sortable:false, title:false},
	                				{label:'DWG DESCRIPTION', 	name:'dwg_desc', 	index:'dwg_desc', 	width:240, 	align:'left', 	sortable:false},
	                				{label:'ITEM CODE',			name:'item_code', 	index:'item_code', 	width:85, 	align:'center', sortable:false, title:false},
	                				{label:'ITEM DESCRIPTION',	name:'item_desc', 	index:'item_desc', 	width:240, 	align:'left', 	sortable:false},
	                				{label:'EA',				name:'ea', 			index:'ea', 		width:30, 	align:'center', sortable:false, editable:true, eidttype:'text',		formatter:'integer'},
	                				{label:'설치위치',			name:'location_no', index:'location_no',width:40, 	align:'center', sortable:false, editable:true, title:false,
	                					edittype : "select", 
	                	           		formatter : 'select', 
	                	           		editrules : { required : false }
	                				},
	                				{label:'설치시점',			name:'stage_no', 	index:'stage_no', 	width:40, 	align:'center', sortable:false, editable:true, title:false,
	                					edittype : "select", 
	                	           		formatter : 'select', 
	                	           		editrules : { required : false }
	                				},
	                				{label:'사도급',				name:'supply_type', index:'supply_type',width:40, 	align:'center', sortable:false, editable:true, title:false,
	                					edittype:'select', //SELECT BOX 옵션
	                	     			formatter:'select',
	                	     			editoptions:{
	                	     			 	value:'Y:Y;N:N',
	                	     			}
	                	     		},
	                				{label:'POS',				name:'pos', 		index:'pos', 		width:40, 	align:'center', sortable:false,	title:false},
	                				{label:'FILE_ID',			name:'file_id', 	index:'file_id',	width:50,	align:'center', sortable:false,	title:false,	hidden:true},
	                				{label:'POS_REV',			name:'pos_rev', 	index:'pos_rev',	width:50,	align:'center', sortable:false,	title:false,	hidden:true}
	                  ],
	        gridview: true,
	        toolbar: [false, "bottom"],
	        viewrecords: true,
	        autowidth: true,
	        scrollOffset : 0,
	        shrinkToFit:true,
	        pager: jQuery('#btnJqGridPuchasingFristAddList'),
	        rowList:[100,500,1000],
	        recordtext: '내용 {0} - {1}, 전체 {2}',
	        emptyrecords:'조회 내역 없음',
	        multiselect: true,
	        cellEdit : true,
	        cellsubmit : 'clientArray', // grid edit mode 2
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
		   			var currentPageIndex  = parseInt($("#jqGridPurchasingList").getGridParam("page"));// 페이지 인덱스
		   			var lastPageX         = parseInt($("#jqGridPurchasingList").getGridParam("lastpage"));  
		   			var pages = 1;
		   			var rowNum 			  = 100;	   			
		   			if (pgButton == "user") {
		   				if (pageIndex > lastPageX) {
		   			    	pages = lastPageX
		   			    } else pages = pageIndex;
		   			}
		   			else if(pgButton == 'next_btnJqGridPuchasingFristAddList'){
		   				pages = currentPageIndex+1;
		   			} 
		   			else if(pgButton == 'last_btnJqGridPuchasingFristAddList'){
		   				pages = lastPageX;
		   			}
		   			else if(pgButton == 'prev_btnJqGridPuchasingFristAddList'){
		   				pages = currentPageIndex-1;
		   			}
		   			else if(pgButton == 'first_btnJqGridPuchasingFristAddList'){
		   				pages = 1;
		   			}
		 	   		else if(pgButton == 'records') {
		   				rowNum = $('.ui-pg-selbox option:selected').val();                
		   			}
		   			$(this).jqGrid("clearGridData");
		   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
			 },		
			 afterEditCell: function(id,name,val,iRow,iCol){
				  //Modify event handler to save on blur.
				  $("#"+iRow+"_"+name).bind('blur',function(){
					$('#jqGridPuchasingFristAddList').saveCell(iRow,iCol);
				  });
			 },
			 beforeRequest : function(){
				 $.ajaxSetup({async: false});
					//그리드 내 콤보박스 바인딩
				 	$.post( "popUpPurchasingNewAddInstallTime.do", "", function( data ) {
						firstGrid.setObject( {
							value : 'value',
							text : 'value',
							name : 'stage_no',
							data : data
						} );
					}, "json" );
					
				 	$.post( "popUpPurchasingNewAddInstallLocation.do", "", function( data ) {
						firstGrid.setObject( {
							value : 'value',
							text : 'text',
							name : 'location_no',
							data : data
						} );
					}, "json" );
				 $.ajaxSetup({async: true});
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
				//승인 안닌것만 색깔 처리
				var rows = $(this).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var ary = ['ship_kind','master','dwg_no','dwg_desc','item_code','item_desc','pos'];
					disableRow($(this),rows[i],ary);
					
					$(this).jqGrid( 'setCell', rows[i], 'ea', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'location_no', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'stage_no', '', { color : 'black', background : '#FFFFCC' } );
					$(this).jqGrid( 'setCell', rows[i], 'supply_type', '', { color : 'black', background : '#FFFFCC' } );
				}
			 }
     	});
		//jqGrid 크기 동적화
		resizeJqGridWidth( $(window), $( "#jqGridPuchasingFristAddList" ),undefined, 0.7);
		
		secondGrid.jqGrid({ 
			datatype: 'json', 
	        mtype: 'POST', 
	        url:'',
	        postData : fn_getFormData('#application_form'),
	        colModel:[				
	                  				{label:'PROJECT', name:'project', index:'project', width:50, align:'center', sortable:false, title:false},
	                  				{label:'DWG No.', 			name:'dwg_no', 		index:'dwg_no', 	width:60, 	align:'center', sortable:false, title:false},
	                				{label:'DWG DESCRIPTION', 	name:'dwg_desc', 	index:'dwg_desc', 	width:240, 	align:'left', 	sortable:false},
	                				{label:'ITEM CODE',			name:'item_code', 	index:'item_code', 	width:85, 	align:'center', sortable:false, title:false},
	                				{label:'ITEM DESCRIPTION',	name:'item_desc', 	index:'item_desc', 	width:240, 	align:'left', 	sortable:false},
	                				{label:'EA',				name:'ea', 			index:'ea', 		width:30, 	align:'center', sortable:false, editable:true, eidttype:'text',		formatter:'integer'	,	title:false},
	                				{label:'설치위치',			name:'location_no', index:'location_no',width:40, 	align:'center', sortable:false, editable:true, eidttype:'text',		title:false},
	                				{label:'설치시점',			name:'stage_no', 	index:'stage_no', 	width:40, 	align:'center', sortable:false, editable:true, eidttype:'text',		title:false},
	                				{label:'사도급',				name:'supply_type', index:'supply_type',width:40, 	align:'center', sortable:false, editable:true, eidttype:'text',		title:false},
	                				{label:'POS',				name:'pos', 		index:'pos', 		width:40, 	align:'center', sortable:false,	title:false},
	                				{label:'POS_REV',			name:'pos_rev', 	index:'pos_rev',	width:50,	align:'center', sortable:false,	title:false,	hidden:true},
	                				{label:'EMS_PUR_NO',		name:'ems_pur_no', 	index:'ems_pur_no',	width:50,	align:'center', sortable:false,	title:false,	hidden:true}
	                  ],
	        gridview: true,
	        toolbar: [false, "bottom"],
	        viewrecords: true,
	        autowidth: true,
	        scrollOffset : 0,
	        shrinkToFit:true,
	        pager: jQuery('#btnJqGridPuchasingSecondAddList'),
	        rowList:[100,500,1000],
	        recordtext: '내용 {0} - {1}, 전체 {2}',
	        emptyrecords:'조회 내역 없음',
	        multiselect: false,
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
	   			var currentPageIndex  = parseInt($("#jqGridPurchasingList").getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt($("#jqGridPurchasingList").getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnJqGridPuchasingSecondAddList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnJqGridPuchasingSecondAddList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnJqGridPuchasingSecondAddList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnJqGridPuchasingSecondAddList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
	   				rowNum = $('.ui-pg-selbox option:selected').val();                
	   			}
	   			$(this).jqGrid("clearGridData");
	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
			 },		
			 afterEditCell: function(id,name,val,iRow,iCol){
				  //Modify event handler to save on blur.
				  $("#"+iRow+"_"+name).bind('blur',function(){
					$('#secondGrid').saveCell(iRow,iCol);
				  });
			 },
			 beforeRequest : function(){
				 $.ajaxSetup({async: false});
					//그리드 내 콤보박스 바인딩
				 	$.post( "popUpPurchasingNewAddInstallTime.do", "", function( data ) {
				 		secondGrid.setObject( {
							value : 'value',
							text : 'value',
							name : 'stage_no',
							data : data
						} );
					}, "json" );
					
				 	$.post( "popUpPurchasingNewAddInstallLocation.do", "", function( data ) {
				 		secondGrid.setObject( {
							value : 'value',
							text : 'text',
							name : 'location_no',
							data : data
						} );
					}, "json" );
				 $.ajaxSetup({async: true});
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
					var ary = ['project','dwg_no','dwg_desc','item_code','item_desc','item_desc','ea',
					           'location_no','stage_no','supply_type','pos','pos_rev'];
					disableRow($(this),rows[i],ary);
					if($(this).jqGrid('getCell',rows[i],'pos_rev') != "")$(this).jqGrid( 'setCell', rows[i], 'pos', 'Y');
				}
			 }
     	});
		//jqGrid 크기 동적화
		resizeJqGridWidth( $(window), $( "#jqGridPuchasingSecondAddList" ),undefined, 0.7);
		$("#second").hide();
		
		
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			//Uniqe Validation
			if(uniqeValidation()){
				var sUrl = "popUpEmsPurchasingNewAddFisrtList.do";
				firstGrid.jqGrid( "clearGridData" );
				firstGrid.jqGrid( 'setGridParam', {
					url : sUrl,
					mtype : 'POST',
					datatype : 'json',
					page : 1,
					postData : fn_getFormData( "#application_form" )
				} ).trigger( "reloadGrid" );
				//검색 시 스크롤 깨짐현상 해결
				firstGrid.closest(".ui-jqgrid-bdiv").scrollLeft(0);
			}
		});
		
		$("#btnNext").click(function(){
			var chk_ids = firstGrid.jqGrid('getGridParam','selarrrow');
			if(chk_ids.length <= 0){
				alert("선택된 항목이 없습니다.");
				return;
			}
			var rev_cp = "";
			for(var i =0; i < chk_ids.length; i++){
				var rowData = firstGrid.getRowData(chk_ids[i]);
				var rev = rowData.pos_rev;
				if(rowData.ea 			== 	""	){ alert("수량이 없습니다."); 			return; }
				if(rowData.ea 			==	"0"	){ alert("수량이 0이 될 수 없습니다.");	return; }
				if(rowData.location_no 	== 	""	){ alert("설치위치가 없습니다."); 		return; }
				if(rowData.stage_no 	== 	""	){ alert("Stage 정보가 없습니다."); 	return; }
				if(rowData.supply_type 	== 	""	){ alert("사도급 정보가 없습니다.");	return; }
				if(rowData.pos 			== 	"N"	){ alert("POS부터 업로드 하십시오.");	return; }
				if(rowData.dwg_no		!= $("#p_dwg_no").val()){ alert("검색 값의 도면번호와 결과의 도면번호가 상이합니다.\n재조회후 작업해주십시오.");return; }
				
				if(rev_cp == "") rev_cp = rev;
				else {
					if(rev_cp != rev){
						alert("선택한 DATA간 상이한 POS가 포함되어 다음 작업이 불가합니다.");
						return;
					}
				}
			}
			
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			if(ar_series.length == 0){
				ar_series[0] = $("input[name=p_project_no]").val();
				$("input[name=p_series]").eq(0).prop("checked",true);
			}
			
			firstGrid.saveCell(kRow, idCol);
			var chmResultRows = [];
			
			getChkedChmResultData(firstGrid,function(data) {
				
				btnViewChanger();
				$("#first").hide();
				$("#second").show();
				$("input[name=p_series]").attr("disabled",true);
				$("input[id=SerieschkAll]").attr("disabled",true);
				
				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify(chmResultRows) };
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend({}, dataList, formData);
				
				var sUrl = "popUpEmsPurchasingNewAddSecondList.do?p_series="+ar_series+"&p_work_flag=A";
				secondGrid.jqGrid( "clearGridData" );
				secondGrid.jqGrid( 'setGridParam', {
					url : sUrl,
					mtype : 'POST',
					datatype : 'json',
					page : 1,
					postData : parameters
				} ).trigger( "reloadGrid" );
				//검색 시 스크롤 깨짐현상 해결
				secondGrid.closest(".ui-jqgrid-bdiv").scrollLeft(0);
			});
		});
		
		$("#btnPos").click(function(){
			var chk_ids = firstGrid.jqGrid('getGridParam','selarrrow');
			if(chk_ids.length <= 0){
				alert("선택된 항목이 없습니다.");
				return;
			}
			var project = $("#p_master").val();
			var dwg_no = $("#p_dwg_no").val();
			
			if(dwg_no.length == 0){ alert("도면번호를 입력해주십시오."); return;}
			
			$.ajax({
		    	url:'<c:url value="emsNewPosChk.do"/>',
		    	type:'POST',
		    	async: false,
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : {"p_project_no" : project,
		    			"p_dwg_no" : dwg_no,
		    			"p_dept_code" : $("#p_dp_dept_code").val()
		    			},
		    	success : function(data){
		    		if(data == "null"){
		    			alert("해당 정보가 없습니다.\n검색조건의 호선 정보와 도면번호를 정확히 기입하여 주십시오.");
		    			return;
		    		}
		    		var jsonData = JSON.parse(data);
		    		master = jsonData.project_no;
		    		
		    		var rev_cp = "";
		    		for(var i = 0; i < chk_ids.length; i++) {
		    			var rev = firstGrid.jqGrid('getRowData',chk_ids[i]).pos_rev;
		    			if(rev_cp == "") rev_cp = rev;
	    				else {
	    					if(rev_cp != rev){
	    						alert("선택한 DATA는 상이한 POS가 포함되어 POS 작업이 불가합니다.");
	    						return;
	    					}
	    				}
		    		}
		    		
		    		var url = "popUpPurchasingNewPos.do?p_master="+master+"&p_dwg_no="+dwg_no+"&p_callback=Y&p_ems_pur_no="+"&p_pos_rev="+rev_cp;
		    		var nwidth = 1050;
		    		var nheight = 800;
		    		var LeftPosition = (screen.availWidth-nwidth)/2;
		    		var TopPosition = (screen.availHeight-nheight)/2;

		    		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

		    		window.open(url,"",sProperties).focus();
		    	},
		    	error : function(e){
		    		alert(e);
		    	}
			});
			
		});
		$("#btnBack").click(function(){
			btnViewChanger();
			$("#second").hide();
			$("#first").show();
			$("input[id=SerieschkAll]").attr("disabled",false);
			$("input[name=p_series]").attr("disabled",false);
		});
		
		//######## Export 버튼 클릭 시 ########//
		$("#btnExport").click(function(){				
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			var gridColModel = firstGrid.jqGrid ('getGridParam', 'colModel');
			for(var i=0; i<gridColModel.length; i++ ){
				if(gridColModel[i].hidden || i==0){
					continue;
				}
				colName.push(gridColModel[i].label);
				dataName.push(gridColModel[i].name);
			}
			
			form = $('#application_form');

			$("input[name=p_is_excel]").val("Y");
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			if(ar_series.length == 0){
				ar_series[0] = $("input[name=p_project_no]").val();
				$("input[name=p_series]").eq(0).prop("checked",true);
			}
			//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.
			$("#p_col_name").val(colName);
			$("#p_data_name").val(dataName);  
			$("#p_not_display_data_name").val("ship_kind,dwg_no,dwg_desc,pos,file_id,pos_rev");
			$("#p_not_display_col_name").val("선종,DWG No.,DWG DESCRIPTION,POS");
			/* $("#rows").val($("#jqGridPurchasingList").getGridParam("rowNum"));
			$("#page").val($("#jqGridPurchasingList").getGridParam("page"));*/
			
			fn_downloadStart();
			form.attr("action", "emsPurchasingNewExcelExport.do?p_chk_series="+ar_series
						+"&curPageNo="+firstGrid.getGridParam("page")
						+"&pageSize="+firstGrid.getGridParam("rowNum")
						+"&type=ADD");
			
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
		});
		
		$("#btnApply").click(function(){
			secondGrid.saveCell(kRow, idCol);
			var chmResultRows = [];
			
			getChmResultData(secondGrid,function(data) {
				lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3'});
				
				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify(chmResultRows) };
				
				var url = 'popUpEmsPurchasingNewAddApply.do';
				var formData = fn_getFormData('#application_form');
				//객체를 합치기. dataList를 기준으로 formData를 합친다.
				var parameters = $.extend({}, dataList, formData);
				
				$.post(url, parameters, function(data){
					alert(data.resultMsg);
					if ( data.result == 'success' ) {
						opener.$("#btnSearch").click();
						window.close();
					}
				}, "json").error(function() {
					alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
				}).always(function() {
					lodingBox.remove();
				});
			});
		});
		
		$("#btnImport").click(function(){
			if(!confirm("파일 IMPORT시 기존 내용은 지워집니다. 진행하시겠습니까?")) return;

			var sURL = "popUpPurchasingNewAddExcelImport.do";
//				var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
//				window.showModalDialog(sURL, window, popOptions);
			
			var nwidth = 450;
			var nheight = 160;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
			
			var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
			window.open(sURL,"",sProperties).focus();	
		});
	});			
	
</script>
</body>
</html>
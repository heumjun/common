<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>Buy-Buy</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.totalEaArea {position:relative; 
				margin-left:10px; 
				margin-right:0px; 
				padding:4px 4px 6px 4px; 
				font-weight:bold; 
				border:1px solid #ccc; 
				background-color:#D7E4BC; 
				vertical-align:middle; 
				}
	.onMs{background-color:#FFFA94;}
	.sscType {color:#324877;
			font-weight:bold; 
			 }
	input[type=text] {text-transform: uppercase;}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			Buy-Buy
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
	<input type="hidden" name="p_type" value="BUYBUY" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	<input type="hidden" id="p_master_ship" name="p_master_ship" value=""/>
	<input type="hidden" id="p_arrDistinct" name="p_arrDistinct" value=""/>
	
	<table class="searchArea conSearch">
		<col width="800"/>
		<col width="*"/>
		<tr>
		<td class="sscType" style="border-right:none;"> 
			PROJECT
			<input type="text" class="required" id="p_project_no" name="p_project_no" alt="PROJECT"  style="width:50px;" value="" onkeyup="javascript:getSeries();" /> &nbsp;
			MOTHER BUY
			<input type="text" id="p_mother_by" name="p_mother_by" alt="MOTHER BUY" class="required" style="width:100px;" value="" onkeyup="javascript:getDesc();"/>
			<input type="text" id="p_mother_desc" name="p_mother_desc" class="notdisabled" readonly="readonly" style="width:200px;" value="" /> &nbsp;
			적용호선
			<label id="p_apply_project" name="p_apply_project" style="color: blue; font-size:12px;" ></label>
			<input type="hidden" id="p_apply_project_temp" name="p_apply_project_temp" value="" />
		</td>
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox" >
				<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
				<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
				<input type="button" class="btn_blue2" value="SAVE" id="btnSave"/>
				<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
			</div>
		</td>
		</tr>
	</table>
	
	<table class="searchArea2">
		<col width="800"/>
		<col width="*"/>
		<tr>
		<td class="sscType">
			STATE
			<select name="p_state_flag" class="commonInput" style="width:45px;">
				<option value="ALL" selected="selected">ALL</option>
				<option value="A" >A</option>
				<option value="D" >D</option>
				<option value="C" >C</option>
				<option value="Act" >Act</option>
			</select> &nbsp;
			DWG NO
			<input type="text" class="commonInput" id="p_dwg_no" name="p_dwg_no" style="width:90px;" value="" /> &nbsp;
			ITEM CODE
			<input type="text" class="commonInput" id="p_item_code" name="p_item_code" value="" style="width:90px;" /> &nbsp;
			조치대상
			<select id="p_upperaction" name="p_upperaction" class="commonInput" style="width:45px;">
				<option value="ALL" selected="selected">ALL</option>
				<option value="Y" >Y</option>
				<option value="N" >N</option>
			</select> &nbsp;
			ECO
			<select id="p_is_eco" name="p_is_eco" class="commonInput" style="width:45px;">
				<option value="ALL" selected="selected">ALL</option>
				<option value="Y" >Y</option>
				<option value="N" >N</option>
			</select> &nbsp;
			RELEASE
			<select id="p_release" name="p_release" class="commonInput" style="width:45px;">
				<option value="ALL" selected="selected">ALL</option>
				<option value="Y" >Y</option>
				<option value="N" >N</option>
			</select> &nbsp;
		</td>
		<td style="border-left:none;">
		<div class="button endbox" >
			<input type="button" class="btn_blue2" value="BOM" id="btnBom"/>
			<input type="button" class="btn_blue2" value="RESTORE" id="btnRestore"/>
			<input type="button" class="btn_blue2" value="CANCEL" id="btnCancel"/>
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

	<div class="content">
		<table id="jqGridBuyBuyMainList"></table>
		<div id="bottomJqGridBuyBuyMainList"></div>
	</div>
	<!-- loadingbox -->
	<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
</div>
</form>	

<script type="text/javascript" >
	var resultData = [];

	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	var menuId = '';
	
	var jqGridObj = $("#jqGridBuyBuyMainList");
	
	$(function() {
		$("#totalCnt").text(0);
		$("#selCnt").text(0);
		
		if($("#init_flag").val() == 'first') {
			
			if($("input[name=p_check_series]").val() == '') {
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=N&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			} else {
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=N"
						+"&p_project_no="+$("input[name=p_project_no]").val()
						+"&p_ischeck="+$("input[name=p_ischeck]").val()
						+"&p_chk_series="+$("input[name=p_check_series]").val(), null);
			} 
			
		} else {
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=N"
					+"&p_project_no="+$("input[name=p_project_no]").val()
					+"&p_ischeck="+$("input[name=p_ischeck]").val()
					+"&p_chk_series="+$("input[name=p_check_series]").val(), null);
		}
	});
	
	var getSeries = function(){
		if($("input[name=p_project_no]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=N&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y&p_chk_series="+$("input[name=p_project_no]").val(), null);
		}
	}
	
	var getDesc = function(){ 
		if($("input[name=p_project_no]").val() != "" && $("input[name=p_mother_by]").val() != ""){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			form = $('#application_form');
			$.post("getSscDescription.do?p_mother_by=" + $("#p_mother_by").val()+"&p_project_no="+$("#p_project_no").val(),"" ,function(data){
				$("#p_mother_desc").val(data.item_desc);
				$("#p_apply_project").text(data.apply_project);
				$("#p_apply_project_temp").val(data.apply_project);
				$("#p_master_ship").val(data.master_ship);
 				//disableSeries();
			},"json");
		}
	}
	
	var disableSeries = function(){ 
		var apply_project = $("#p_apply_project_temp").val().split(", ");
		for(var i=0; i<$("input[name=p_series]").length; i++){
			var value = 0;
			var id = $("input[name=p_series]")[i].id;
			for(var j=0; j<apply_project.length; j++){
				if($("input[name=p_series]")[i].id == "p_series_"+apply_project[j]){
					value += 1;
				}
			}
			if(value == 0){
				$("#" + id).attr("disabled", true); 
				$("input:checkbox[id='"+id+"']").prop("checked", false);
			}
			else {
				$("#" + id).attr("disabled", false);
				$("input:checkbox[id='"+id+"']").prop("checked", true);
			}
		}	
	}
		
	$(document).ready(function(){
		
		//그리드 헤더 설정
		var gridColModel = new Array();
		gridColModel.push({label:'SSC_SUB_ID', name:'ssc_sub_id', width:40, align:'center', sortable:true, title:false, hidden:true} );
		gridColModel.push({label:'STATE', name:'state_flag', width:40, align:'center', sortable:true, title:false, } );
		gridColModel.push({label:'PROJECT', name:'project_no', width:55, align:'center', sortable:true, title:false, } );
		gridColModel.push({label:'DWG NO', name:'dwg_no', width:70, align:'center', sortable:true, title:false, } );
		gridColModel.push({label:'ITEM CODE', name:'item_code', width:95, align:'center', sortable:true, title:false, cellattr: function (){return 'class="edit_cell"';}, formatter: itemCodeFormatter, unformat:unFormatter});
		gridColModel.push({label:'DESCRIPTION', name:'item_desc', width:300, align:'left', sortable:true} );
		gridColModel.push({label:'EA', name:'ea', width:35, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="edit_cell"';}} );
		gridColModel.push({label:'WEIGHT', name:'item_weight', width:50, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'SUPPLY', name:'supply_type', width:50, align:'center', sortable:true, title:false, cellattr: function (){return 'class="edit_cell"';}} );
		gridColModel.push({label:'DATE', name:'modify_date', width:65, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'DEPT', name:'dept_name', width:85, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'USER', name:'user_name', width:45, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'ECO', name:'eco_no', width:80, align:'center', sortable:true, title:false, formatter: ecoFormatter, unformat:unFormatter, cellattr: function (){return 'style="cursor:pointer"';}} );
		gridColModel.push({label:'RELEASE', name:'release_desc', width:80, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'work_flag', hidden:true, name:'work_flag'} );
		gridColModel.push({label:'oper', hidden:true, name:'oper'} );
		
		//그리드 설정 
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            mtype : 'POST',
            gridview: true,
            viewrecords: true,
            rownumbers:false,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            //shrinkToFit : false, //그리드 가로 넓이 자동맞춤
	        pgbuttons 	 : false,
			pgtext 		 : false,
			pginput 	 : false,
            height: 500,
            pager: '#bottomJqGridBuyBuyMainList',
            //rowList:[100,500,1000],
	        rowNum:99999, 
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
  		
		    	/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
		    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
		     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
		     	 */ 
				$(this).jqGrid("clearGridData");
		
		    	/* this is to make the grid to fetch data from server on page click*/
	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  

			 },
  			 loadComplete: function (data) {
				var $this = $(this);
				if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				    // because one use repeatitems: false option and uses no
				    // jsonmap in the colModel the setting of data parameter
				    // is very easy. We can set data parameter to data.rows:
				    $this.jqGrid('setGridParam', {
				        //datatype: 'local',
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
				    });
				    this.updatepager(false, true);
				}
				var rows = $this.getDataIDs();				
			},	
			afterInsertRow : function(rowid, rowdata, rowelem){
				jQuery("#"+rowid).css("background", "#B6C8FF");
	        },
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
				
				var ret = $(this).getRowData( rowid );
				var oper = ret.oper;
				if( oper != "I" ) {
					$(this).jqGrid( 'setCell', rowid, 'item_code', '', 'not-editable-cell' );
				}
			},
			afterSaveCell : function( rowid, cellName, val, iRow, iCol){
				var item = jqGridObj.jqGrid( 'getRowData', rowid );
				if (item.oper != 'I')
					item.oper = 'U';

				jqGridObj.jqGrid( "setRowData", rowid, item );
				$( "input.editable,select.editable", this ).attr( "editable", "0" );
				
				//U의 경우 수정 이후 row 색상 변경
// 				if(item.oper == 'U'){	
// 					jQuery("#"+rowid).css("background", "#CCFE87");
// 				}
				//입력 후 대문자로 변환
				jqGridObj.setCell (rowid, cellName, val.toUpperCase(), '');
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 30);
	    getDesc();
	});
	
	function itemCodeFormatter(cellvalue, options, rowObject ) {
		
		if(cellvalue == null) {
			return '';
		} else {
			return "<a ondblclick=\"javascript:motherCodeView('"+rowObject.project_no+"','"+rowObject.mother_code+"','"+cellvalue+"')\">"+cellvalue+"</a>";
		}
	}
	
	function ecoFormatter(cellvalue, options, rowObject ) {
		
		if(cellvalue == null) {
			return '';		
		} else {
			return "<a ondblclick=\"javascript:ecoNoClick('"+cellvalue+"')\">"+cellvalue+"</a>";
		}
	}
	
	function unFormatter(cellvalue, options, rowObject ) {
		return cellvalue;
	}
	
	//After Info 버튼 클릭 시 		
	var motherCodeView = function (projectNo, motherCode, itemCode){
		
		//메뉴ID를 가져오는 공통함수 
		getMenuId("sscBomStatus.do", callback_MenuId);
		
		var sURL = "sscBomStatus.do?menu_id=" + menuId + "&up_link=bom&project_no="
			+ projectNo + "&mother_code=" + motherCode + "&item_code=" +itemCode;
		var popOptions = "width=1200, height=730, resizable=yes, scrollbars=no, status=yes"; 
		var win = window.open(sURL, "bomStatus", popOptions); 
		
		setTimeout(function(){
			win.focus();
		 }, 1000);
	}
	
	//Eco No. 버튼 클릭 시 		
	var ecoNoClick = function (eco_no){
		
		//메뉴ID를 가져오는 공통함수 
		getMenuId("eco.do", callback_MenuId);
		
		var sURL = "eco.do?ecoName="+eco_no+"&menu_id=" + menuId + "&popupDiv=Y&checkPopup=Y";
		var popOptions = "width=1200, height=700, resizable=yes, scrollbars=yes, status=yes";
		var win = window.open(sURL, "", popOptions); 
	    
		setTimeout(function(){
			win.focus();
		 }, 500);
	}
	
	//필수 항목 Validation
	var uniqeValidation = function(){
		var rnt = true;
		$(".required").each(function(){
			if($(this).val() == ""){
				$(this).focus();
				alert($(this).attr("alt")+ "가 누락되었습니다.");
				rnt = false;
				return;
			}
		});
		return rnt;
	}

	//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
	$("#btnSearch").click(function(){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		if(uniqeValidation()){
			fn_search();
		}
	});
	
	function fn_search() {
		getDesc();
		if($("#p_apply_project_temp").val() == " "){
			alert("Buy-Buy 품목을 확인해 주세요.");
			return;
		}
		//history.go에서 시리즈 파라미터 유지를 위하여 값을 first에서 next로 조절
		$("#init_flag").val("next");
		
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});

		$("input[name=p_is_excel]").val("N");
		$("input[name=pageYn]").val("N");
		
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		if($("input[name=page_flag]").val() == '') {
			if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=N&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
		}
		
		$("input[name=p_check_series]").val(ar_series);

		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
		
		var sUrl = "sscBuyBuyMainList.do?p_chk_series="+ar_series;
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			//rowNum : pageCnt,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
	}

	//Add 버튼 클릭 시 
	$("#btnAdd").click(function(){
		if($("#p_apply_project_temp").val() == " "){
			alert("Buy-Buy 품목을 확인해 주세요.");
			return;
		}
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		$("input[name=p_ischeck]").val(p_ischeck);
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		$("input[name=p_check_series]").val(ar_series);

		if(uniqeValidation()){

			var p_arr = new Array();
			var p_arrDistinct = new Array();
			var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			
			form = $('#application_form');
			
			form.attr("action", "sscBuyBuyAddMain.do");
			form.attr("target", "_self");	
			form.attr("method", "post");	
			form.submit();
		}
	});
	
	//Delete 버튼 클릭 시 
	$("#btnDelete").click(function(){
		jqGridObj.saveCell(kRow, idCol );
		var rows = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(rows == ""){
			alert("행을 선택하십시오.");
			return false;
		}
		if(confirm("해당 항목을 삭제하시겠습니까?")){
			var chmResultRows = getSelectRowsData(jqGridObj); //멀티 셀렉트 리스트 가져옴
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'sscBuyBuyMainDelete.do';
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({}, dataList, formData);
			$(".loadingBoxArea").show();
			$.post(url, parameters, function(data) {	
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
				$(".loadingBoxArea").hide();
				fn_search();
			});
		}
	});
	
	//그리드의 변경된 row만 가져오는 함수
	function getChangedGridInfo(gridId) {
		var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
			return obj.oper == 'U';
		});
		return changedData;
	}
	
	//Save 버튼 클릭 시 
	$("#btnSave").click(function(){
		jqGridObj.saveCell(kRow, idCol );
		if(confirm("SAVE 하시겠습니까?")){
			var changeResultRows =  getChangedGridInfo(jqGridObj);
			if(changeResultRows == ""){
				alert("저장할 항목이 존재하지 않습니다.");
				return;
			}
			var url			= "sscBuyBuyMainSave.do";
			var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({},dataList,formData);
			$(".loadingBoxArea").show();
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
				$(".loadingBoxArea").hide();
				fn_search();
			});

		}
	});
	
	//RESTORE 버튼 클릭 시 
	$("#btnRestore").click(function(){
		jqGridObj.saveCell(kRow, idCol );
		var rows = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(rows == ""){
			alert("행을 선택하십시오.");
			return false;
		}
		if(confirm("RESTROE 하시겠습니까?")){
			var chmResultRows = getSelectRowsData(jqGridObj); //멀티 셀렉트 리스트 가져옴
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'sscBuyBuyMainRestore.do';
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({}, dataList, formData);
			$(".loadingBoxArea").show();
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
				$(".loadingBoxArea").hide();
				fn_search();
			});
		}
	});
	
	//CANCEL 버튼 클릭 시 
	$("#btnCancel").click(function(){
		jqGridObj.saveCell(kRow, idCol );
		var rows = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(rows == ""){
			alert("행을 선택하십시오.");
			return false;
		}
		if(confirm("CANCEL 하시겠습니까?")){
			var chmResultRows = getSelectRowsData(jqGridObj); //멀티 셀렉트 리스트 가져옴
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'sscBuyBuyMainCancel.do';
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({}, dataList, formData);
			$(".loadingBoxArea").show();
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
				$(".loadingBoxArea").hide();
				fn_search();
			});
		}
	});
	
	//멀티셀렉트 데이터 리턴
	function getSelectRowsData(jqGridId) {
		var savedGrid = jqGridId.jqGrid( 'getGridParam','selarrrow');
		var array = [];
		$.each(savedGrid,function(key,value){
			var obj = jqGridObj.jqGrid('getRowData',value);
			array.push(jqGridObj.jqGrid('getRowData',value));
		});
		var resultData = [];
		var savedRows = array.concat(resultData);
		return savedRows;
	}
	
	//Bom 버튼 클릭 시 
	$("#btnBom").click(function(){			
		var rtn = true;
		//행을 읽어서 키를 뽑아낸다.
		var ssc_sub_id = new Array();
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		if(row_id == ""){
			alert("행을 선택하십시오.");
			return false;
		}
		for(var i=0; i<row_id.length; i++){
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
			if(item.eco_no != ""){
				alert("이미 ECO가 연계되어 있는 대상입니다.");					
				//alert("이미 ECO가 연계되어 있는 대상이 있습니다.");			
				rtn = false;
				return false;
			}
			ssc_sub_id.push(item.ssc_sub_id);
		}
		if(!rtn){
			return false;
		}
		
		var p_arr = new Array();
		var p_arrDistinct = new Array();
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		for(var i=0; i<selarrrow.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
			p_arr.push(item.ssc_sub_id + "@" + item.state_flag + "@" + item.project_no + "@" + item.dwg_no + "@" + item.item_code + "@" + item.item_desc + "@" + item.ea + "@" + item.item_weight + "@" + item.supply_type + "@" + item.modify_date);
		}
		$("#p_arrDistinct").val(p_arr);
		
		form = $('#application_form');
		form.attr("action", "sscBuyBuyBomMain.do?p_ssc_sub_id="+ssc_sub_id);
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	});
	
	var callback_MenuId = function(menu_id) {
		menuId = menu_id;
	}
</script>
</body>

</html>
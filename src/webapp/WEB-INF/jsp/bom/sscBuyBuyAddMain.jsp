<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>BUY-BUY ADD Main</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.totalEaArea {position:relative; margin-right:40px; padding:4px 0 6px 2px; font-weight:bold; border:1px solid #ccc; background-color:#D7E4BC; vertical-align:middle; }	
	
	/*.itemInput {text-transform: uppercase;} */
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
	.header .searchArea .buttonArea #btnForm{float:left;}
	.required_cell{background-color:#F7FC96}	

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
</style>
</head>
<body> 
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			Buy-Buy ADD
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_excel" id="p_excel" value="" />
		<input type="hidden" id="p_step_state" name="p_step_state" value="1" />	
		<input type="hidden" id="p_dept_code" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
		<input type="hidden" id="p_master_ship" name="p_master_ship" value=""/>
		<input type="hidden" id="p_work_key" name="p_work_key" value=""/>
		
		<table class="searchArea conSearch">
			<col width="800"/>
			<col width="*"/>
			<tr>
			<td class="sscType" style="border-right:none;"> 
				PROJECT
				<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" readonly="readonly" style="width:50px;" value="<c:out value="${p_project_no}"/>" /> &nbsp;
				MOTHER BUY
				<input type="text" id="p_mother_by" name="p_mother_by" class="required" readonly="readonly" style="width:100px;" value="<c:out value="${p_mother_by}"/>"/>
				<input type="text" id="p_mother_desc" name="p_mother_desc" class="notdisabled" readonly="readonly" style="width:200px;" value="<c:out value="${p_mother_desc}"/>" /> &nbsp;
				적용호선
				<label id="p_apply_project" name="p_apply_project" style="color: blue; font-size:12px;" ></label>
				<input type="hidden" id="p_apply_project_temp" name="p_apply_project_temp" value="<c:out value="${p_apply_project_temp}"/>" />	
			</td>
			<td class="bdl_no"  style="border-left:none;">
				<div class="button endbox" >
					<input type="button" class="btn_blue2" value="NEXT" id="btnNext" />
					<input type="button" class="btn_blue2" value="BACK" id="btnBack" />
					<input type="button" class="btn_blue2" value="APPLY" id="btnApply" />
					<input type="button" class="btn_blue2" value="CLOSE" id="btnClose"/>
				</div>
			</td>
			</tr>
		</table>
		<table class="searchArea2">
			<tr>
				<td>
					<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
				</td>
			</tr>
		</table>
		<table class="searchArea2">
			<col width="800"/>
			<col width="*"/>
			<tr>
				<td class="bdl_no" style="border-right:none;">
					<input type="button" class="btn_red2" value="FORM" id="btnForm" />
					<span class="totalEaArea" style="padding-left:5px; padding-right:5px; margin-left:10px">
						Total EA <input type="text" id="totalEa" style="width:50px; height:15px;" readonly="readonly"/>
					</span>
				</td>
				<td class="bdl_no" style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_red2" value="IMPORT" id="btnExlImp"/>
						<input type="button" class="btn_red2" value="+" id="btnAdd" style="width:28px; font-size:16px;"/>
						<input type="button" class="btn_red2" value="-" id="btnDel" style="width:28px; font-size:16px;"/>
					</div>
				</td>
			</tr>
		</table>			
		<div class="content">
			<table id="jqGridAddMainList"></table>
			<div id="bottomJqGridAddMainList"></div>
		</div>
		<!-- loadingbox -->
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>
<script type="text/javascript" >
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	var selectAttr = '';
	var backList = '';
	
	//필수 입력 값의 배경 색 지정
	var jqGridObj = $("#jqGridAddMainList");
	var uniqCellBgColor = {'background-color':'#F7FC96'};
	var noUniqCellBgColor = {'background-color':'white'};
	
	$(function() {
		$("#totalCnt").text(0);
		
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
			
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=N&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
			getAjaxTextPost(null, "sscAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
		}
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
				disableSeries();
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
		
		$("#btnBack").hide();
		$("#btnApply").hide();
		
		var gridColModel = new Array();
		//그리드 기본 셋팅 
		gridColModel.push({label:'PROJECT', name:'project_no', width:70, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'DWG NO.', name:'dwg_no', width:110, align:'center', sortable:true, title:false, editable:true,
			edittype : "select",
	  		editrules : { required : false },
	  		cellattr: function (){return 'class="required_cell"';},
	  		editoptions: {
				dataUrl: function(){
	        		var item = jqGridObj.jqGrid( 'getRowData', idRow );
	   				var url = "sscBuyBuyDwgNoList.do?p_dept_code="+$("#p_dept_code").val()+"&p_project_no="+$("#p_project_no").val();
					return url;
				},
	  			buildSelect: function(data){
	  				if(typeof(data)=='string'){
	     				data = $.parseJSON(data);
	    			}
	 				var rtSlt = '<select id="selectDwgNo" name="selectDwgNo" >';
	   				for ( var idx = 0 ; idx < data.length ; idx++) {
						rtSlt +='<option value="'+data[idx].object+'" name="'+data[idx].object+'">'+data[idx].object+'</option>';	
	 				}
					rtSlt +='</select>';
					return rtSlt;
	  		 	}
	  		 }
			
		} );
		gridColModel.push({label:'ITEM CODE', name:'item_code', width:120, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';},
			editoptions: { 
				dataEvents: [{
					type: 'change',
					fn: function(e) {
			   			var row = $(e.target).closest('tr.jqgrow');
						var rowId = row.attr('id');
			  			//ITEM DESC 불러옴
			  			getItemDesc(rowId);
					}
				},{
					type : 'keydown',
					fn : function( e) { 
						var row = $(e.target).closest('tr.jqgrow');
						var rowId = row.attr('id');
						var key = e.charCode || e.keyCode; 
						if( key == 13 || key == 9) {
		 					//ITEM DESC 불러옴
							getItemDesc(rowId);
						}
					}
				}]
			}
		} );			
		gridColModel.push({label:'DESCRIPTION', name:'item_desc', width:300, align:'left', sortable:true} );
		gridColModel.push({label:'EA', name:'ea', width:60, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';}} );
		gridColModel.push({label:'WEIGHT', name:'item_weight', width:80, align:'center', sortable:true, title:false, editable:false} );
		gridColModel.push({label:'SUPPLY', name:'supply_type', width:80, align:'center', sortable:true, title:false, editable:true, cellattr: function (){return 'class="required_cell"';}} );
		gridColModel.push({label:'PROCESS', name:'process', width:60, align:'center', sortable:true, title:false} );
		gridColModel.push({label:'error_msg_item_code', name:'error_msg_item_code', hidden:true, title:false} );
		gridColModel.push({label:'OPER', name:'oper', hidden:true, index:'oper' } );	

		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'.do',
            postData : fn_getFormData('#application_form'),
            colModel: gridColModel,
            gridview: true,
            viewrecords: true,
            rownumbers:false,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit : false,
            height: 560,
            pager: '#bottomJqGridAddMainList',
            rowList:[100,500,1000],
	        rowNum:100, 
	        recordtext: '내용 {0} - {1}, 전체 {2}',
       	 	emptyrecords:'조회 내역 없음',
			beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
            	idRow = rowid;
            	idCol = iCol;
            	kRow  = iRow;
            	kCol  = iCol;
			}	       
			,
  			afterSaveCell : chmResultEditEnd,
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
  				var cbs = $(".cbox", jqGridObj[0]);
  				if($("#p_step_state").val() != "1") {
	   		        cbs.prop("disabled", "disabled");
	   		        cbs.prop("readonly", true);
  				}
  				else{
  					cbs.removeAttr("disabled")
	   		        cbs.prop("readonly", false);
  				}
  				
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
				    
				    $("#p_work_key").val(data.p_work_key);
				
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

				//Total 수량 출력
				totalEaAction();
				
				var err_style = { color : '#FFFFFF', background : 'red'};
				
				var ids = jqGridObj.jqGrid('getDataIDs');
				for(var i=0; i<ids.length; i++){
					//에러 표시
					var item = jqGridObj.jqGrid( 'getRowData', ids[i] );
					if(item.error_msg_item_code != "") {
						jqGridObj.setCell (ids[i], 'item_code','', err_style, {title : item.error_msg_item_code});
					}
					
					//엑셀 업로드시 item desc 불러옴
					getItemDesc(ids[i]);
				}
				
				
			},		
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
			}
			
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 50 );
	    getDesc();

    	//Total 수량 출력
		totalEaAction();
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){ 
			history.go(-1);
		});
		
		//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
		$("#btnAdd").click(function(){
			
			jqGridObj.saveCell(kRow, idCol );
			// 첫 행 구함.
			var ids = jqGridObj.jqGrid('getDataIDs');
            //get first id
            var cl = ids[ids.length-1];
            var rowData = jqGridObj.getRowData(cl);

            var item = {};
			var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
			
			for ( var i in colModel )
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.dwg_no = $( "input[name=p_dwg_no]" ).val();
			
			jqGridObj.resetSelection();
			jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
			
			//Total 수량 출력
			totalEaAction();
		});
		
		//del 버튼  클릭
		$("#btnDel").click(function(){
		
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
			//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
			var row_len = row_id.length;					
			
			for(var i=0; i<row_len; i++){
				jqGridObj.jqGrid('delRowData',row_id[0]);
			}
			
			//Total 수량 출력
			totalEaAction();
			
		});
		
		
		//Excel Import 클릭
		$("#btnExlImp").click(function(){
			
			$("#p_excel").val("Y");
			
			var sURL = "popUpSscBuyBuyAddExcelImport.do";
			var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
			window.showModalDialog(sURL, window, popOptions);

			//Total 수량 출력
			totalEaAction();
		});
		
		//Excel Form 클릭 다운로드	
		$("#btnForm").click(function(){
			$.download('fileDownload.do?fileName=SSCBuyBuyExcelImportFormat.xls',null,'post');
		});
	
		
		$(document).keydown(function (e) { 
			
			if (e.keyCode == 27 || e.keyCode == 8) { 
				e.preventDefault();
			} // esc 막기
		}); 
		
		
	});
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//BOM_QTY 수정 시 전체 수량 필드 변경 
		if(cellName == "ea"){
			totalEaAction();
		}
		if(val == null) val = "";
		//입력 후 대문자로 변환
		jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
		
	}
	
	//대문자 변경
	var evtUpper = function(obj){
		$(obj).val().toUpperCase();
	}
	
	//그리드 내에서 ITEM CODE에 대한 DESCRIPTION 가져옴
	function getItemDesc(rowId) {
		jqGridObj.saveCell(kRow, idCol );
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
	    $.ajax({
			url : "sscBuyBuyAddGetItemDesc.do?p_item_code="+item.item_code,
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				jqGridObj.jqGrid('setCell', rowId, 'item_desc', data.item_desc);
				jqGridObj.jqGrid('setCell', rowId, 'item_weight', data.item_weight);
				jqGridObj.saveCell(kRow, idCol );
			}
		});
	}
	
	//Total 수량 계산
	function totalEaAction() {	
		var totalEa = 0;
		var row_id = jqGridObj.getDataIDs();
		for(var i=0; i<row_id.length; i++) {
			
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
			totalEa += item.ea * 1;
		}
		
		$("#totalEa").val(totalEa);
	}

	//그리드의 변경된 row만 가져오는 함수
	function getGridInsertData(gridId) {
		var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I';
		});
		return changedData;
	}
	
	//Next 버튼 클릭 시 
	$("#btnNext").click(function(){
		
		jqGridObj.saveCell(kRow, idCol );
		
		var changeRows = [];
		var rtn = true;
		getGridChangedData(jqGridObj,function(data) {
			changeRows = data;
			
			$(".required_cell").each(function(){
				
				if($(this).text().trim() == ""){
					alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
					$(this).context.style.backgroundColor = "#ff9999";
					rtn = false;
					return false;
				}
				else{
					$(this).context.style.backgroundColor = "#F7FC96";
				}
			});
			
			if(!rtn){
				return false;
			}

			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			var formData = fn_getFormData('#application_form');
			var dataList = { chmResultList : JSON.stringify(changeRows) };
			var parameters = $.extend({}, dataList, formData);

			//검색 시 스크롤 깨짐현상 해결
			jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 

			//그리드 초기화
			$( jqGridObj).jqGrid( "clearGridData" );
			$( jqGridObj ).jqGrid( 'setGridParam', {
				url : "sscBuyBuyAddNext.do?p_chk_series="+ar_series,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : parameters,
				cellEdit : false
			} ).trigger( "reloadGrid" );
			
			$("#p_step_state").val("2");
			$("#btnNext").hide();
			$("#btnExlImp").hide();
			$("#btnAdd").hide();
			$("#btnDel").hide();
			
			$("#btnBack").show();
			$("#btnApply").show();
			
			$("input[name=p_series]").prop("disabled", "disabled");
		});
	});
	
	$("#btnBack").click(function(){
		
		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 

		var changeRows = [];
		var rtn = true;
		getGridChangedData(jqGridObj,function(data) {
			changeRows = data;
			
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			var formData = fn_getFormData('#application_form');
			var dataList = { chmResultList : JSON.stringify(changeRows) };
			var parameters = $.extend({}, dataList, formData);

			//검색 시 스크롤 깨짐현상 해결
			jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 

			//그리드 초기화
			$( jqGridObj).jqGrid( "clearGridData" );
			$( jqGridObj ).jqGrid( 'setGridParam', {
				url : "sscBuyBuyAddBack.do?p_chk_series="+ar_series,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				postData : parameters,
				cellEdit : true
			} ).trigger( "reloadGrid" );
			
			$("#p_step_state").val("1");
			$("#btnNext").show();
			$("#btnExlImp").show();
			$("#btnAdd").show();
			$("#btnDel").show();
			
			$("#btnBack").hide();
			$("#btnApply").hide();

			disableSeries();
		});
	});
	
	//Apply 버튼 클릭 시 
	$("#btnApply").click(function(){
		
		jqGridObj.saveCell(kRow, idCol );
		
		var ids = jqGridObj.jqGrid('getDataIDs');
		for(var i=0; i<ids.length; i++){

			var item = jqGridObj.jqGrid( 'getRowData', ids[i] );
			if(item.process == "NO") {
				alert("데이터 확인 이후 Back 버튼을 이용하여 진행하십시오.");
				return;
			}
			
			//엑셀 업로드시 item desc 불러옴
			getItemDesc(ids[i]);
		}

		if(confirm("적용 하시겠습니까?")){
			
			var changeRows = [];
			var rtn = true;
			getGridChangedData(jqGridObj,function(data) {
				changeRows = data;
				if (changeRows.length == 0) {
					alert("내용이 없습니다.");
					return;
				}
				
				$(".required_cell").each(function(){
					
					if($(this).text().trim() == ""){
						alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
						$(this).context.style.backgroundColor = "#ff9999";
						rtn = false;
						return false;
					}
					else{
						$(this).context.style.backgroundColor = "#F7FC96";
					}
				});
				
				if(!rtn){
					return false;
				}

				//시리즈 배열 받음
				var ar_series = new Array();
				for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
					ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
				}
				
				var formData = fn_getFormData('#application_form');
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);

				$(".loadingBoxArea").show();
			
				//검색 시 스크롤 깨짐현상 해결
				jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 

				$.post("sscBuyBuyAddApply.do?p_chk_series="+ar_series, parameters, function(data2){
					$(".loadingBoxArea").hide();
					alert(data2.resultMsg);
					$("#btnClose").click();
				},"json");
				
			});
		}
	});

	
</script>
</body>

</html>

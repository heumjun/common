<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>USC Management</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	input[type=text] {text-transform: uppercase;}
</style>
</head>

<body>

<form id="application_form" name="application_form"  >
	<div class="mainDiv" id="mainDiv">
		<input type="hidden" id="p_col_name" name="p_col_name"/>
		<input type="hidden" id="p_data_name" name="p_data_name"/>
		<input type="hidden" id="temp_project_no" name="temp_project_no" value="" />
		<div class="subtitle">
		USC MAIN
		<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="70"/>
			<col width="70"/>
			<col width="70"/>
			<col width="*"/>
			<tr>
				<th>Project</th>
				<td>
					<input type="text" class="required" id="p_project_no" name="p_project_no" alt="Project" style="width:60px;" value="" onblur="javascript:getDwgNos();"  />
				</td>
				<th>구역</th>
				<td>
					<select name="p_area" id="p_area" style="width:60px;">
						<option value="%">ALL</option>
					</select>
				</td>
				<th>B_STR</th>
				<td>
					<select name="p_block_str_flag" id="p_block_str_flag" style="width:60px;">
						<option value="%">ALL</option>
					</select>
				</td>
				<th>STR</th>
				<td>
					<select name="p_str_flag" id="p_str_flag" style="width:60px;">
						<option value="%">ALL</option>
					</select>
				</td>
				<th>BLOCK</th>
				<td>
					<input type="text" name="p_block_no" style="width:60px;" />
				</td>				
				<th>JOB_TYPE</th>
				<td>
					<input type="text" name="p_attr_code" style="width:50px;" />
				</td>
				<th>U_BLK</th>
				<td>
					<input type="text" name="p_upper_block" style="width:50px;" />
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_blue2" value="BLOCK" id="btnBlock"/>
							<input type="button" class="btn_blue2" value="ACTIVITY" id="btnActivity"/>
							<input type="button" class="btn_blue2" value="SAVE" id="btnSave"/>
						</c:if>
						<input type="button" class="btn_blue2" value="SEARCH" id="btnSearch"/>
					</div>
				</td>	
			</tr>
		</table>
		<table class="searchArea2">
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="70"/>
			<col width="80"/>
			<col width="90"/>
			<col width="80"/>
			<col width="*"/>
			<tr>
				<th>STATE</th>
				<td>
					<select name="p_status">
						<option value="%" selected="selected">ALL</option>
						<option value="A">A</option>
						<option value="B">B</option>
						<option value="D">D</option>
					</select>
				</td>
				<th>ECO No.</th>
				<td>
					 <input type="text" name="p_eco_no" value="" style="width:60px;"  />
				</td>
				<th>BLK ITEM</th>
				<td>
				<input type="text" name="p_bk_code" value="" style="width:60px;" />
				</td>
				
				<th>ACT ITEM</th>
				<td>
				<input type="text" name="p_act_code" value="" style="width:60px;" />
				</td>
				
				<th>JOB ITEM</th>
				<td>
				<input type="text" name="p_job_code" value="" style="width:60px;" />
				</td>
				<th><select name="p_is_work" style="width:70px;">
						<option value="WORK" selected="selected">WORK</option>
						<option value="ECO">ECO</option>
						<option value="UBLK">U_BLK</option>
						<option value="RELEASE">RELEASE</option>
						<option value="BOM">BOM</option>
						<!--<option value="BOM">BOM</option>
						<option value="ACT">ACT</option>-->
					</select></th>
				<td>
					<select name="p_is_work_yn">
						<option value="%" selected="selected">ALL</option>
						<option value="Y" >Y</option>
						<option value="N" >N</option>
					</select>
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox" >
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_blue2" value="RESTORE" id="btnRestore"/>
						</c:if>
						<input type="button" class="btn_blue2" value="EXPORT" id="btnExport"/>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" class="btn_blue2" value="DELETE" id="btnDelete"/>
							<input type="button" class="btn_blue2" value="BOM" id="btnBom"/>
						</c:if>
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
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	var resultData = [];
	
	var deliverySeries;
	
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
			colModel : [
					{label:'STATE' 		, name : 'state_flag'	, index : 'state_flag'	, width : 100, editable : false, align : "center"},
					{label:'MASTER'	    , name : 'representative_pro_num'	, index : 'representative_pro_num'	, width : 100, editable : false, align : "center"},
					{label:'PROJECT'	, name : 'project_no'	, index : 'project_no'	, width : 100, editable : false, align : "center"},
					{label:'구역'			, name : 'area'			, index : 'area'		, width : 100, editable : false, align : "center"},
					{label:'BLOCK'		, name : 'block_no'		, index : 'block_no'	, width : 100, editable : false, align : "center"},
					{label:'B_STR'		, name : 'block_str_flag', index : 'block_str_flag', width : 100, editable : false, align : "center"},
					{label:'STR'		, name : 'str_flag'		, index : 'str_flag', width : 100, editable : false, align : "center"},					
					{label:'JOB_STR'	, name : 'job_str_flag'	, index : 'job_str_flag', width : 100, editable : false, align : "center", hidden:true},
					{label:'JOB_TYPE'	, name : 'usc_job_type'	, index : 'usc_job_type', width : 100, editable : false, align : "center"},
					{label:'U_BLK'		, name : 'upper_block'	, index : 'upper_block'	, width : 100, editable : false, align : "center"},
					{label:'BLK ITEM'	, name : 'block_code'	, index : 'block_code'	, width : 100, editable : false, align : "center"},
					{label:'ACT ITEM'   , name : 'act_code'		, index : 'act_code'	, width : 100, editable : false, align : "center"},
					{label:'JOB ITEM'	, name : 'job_code'		, index : 'job_code'	, width : 100, editable : false, align : "center"},
					{label:'BK ITEM'	, name : 'block_catalog', index : 'block_catalog'	, width : 100, editable : false, align : "center", hidden:true},
					{label:'ACT ITEM'   , name : 'activity_catalog'	, index : 'activity_catalog'	, width : 100, editable : false, align : "center", hidden:true},
					{label:'JOB ITEM'	, name : 'job_catalog'	, index : 'job_catalog'	, width : 100, editable : false, align : "center", hidden:true},
					{label:'WORK DATE'	, name : 'work_date'	, index : 'work_date'	, width : 100, editable : false, align : "center"},
					{label:'ECO'		, name : 'eco_no'		, index : 'eco_no'		, width : 100, editable : false, align : "center", classes : "handcursor"},
					{label:'RELEASE'	, name : 'eco_date'		, index : 'eco_date'	, width : 100, editable : false, align : "center"},
					{label:'WORK'		 , name : 'work_yn'		, index : 'work_yn'		, width : 60, editable : true,  align : "center", edittype:"select",formatter : 'select',editoptions:{value:"Y:Y;N:N"}, editrules : { required : true}},
					{label:'BOM'		, name : 'ssc_bom_qty'	, index : 'ssc_bom_qty'	, width : 100, editable : false, align : "center"},
					{label:'ACT CODE'	, name : 'wip_act_code'	, index : 'wip_act_code', width : 100, editable : false, align : "center"},
					{label:'ACT ST'		, name : 'wip_act_st'	, index : 'wip_act_st'	, width : 100, editable : false, align : "center"},
					{label:'KIND'		, name : 'virtual_yn'	, index : 'virtual_yn'	, width : 100, editable : false, align : "center", hidden:true},
					{label:'DEL GBN'	, name : 'delete_gbn'	, index : 'delete_gbn'	, width : 100, editable : false, align : "center", hidden:true},
					{label:'CRUD'		, name : 'oper'			, index : 'oper'		, width : 100, editable : false, align : "center", hidden:true}					
				],
             gridview: true,
             viewrecords: true,
             autowidth: true,
             cmTemplate: { title: false },
             cellEdit : true,
             cellsubmit : 'clientArray', // grid edit mode 2
			 scrollOffset : 17,
             multiselect: true,             
             height: 460,
             pager: '#bottomJqGridMainList',
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
			 onSelectAll: function(aRowids,status) {     
					//전체 선택 눌럿을때 딜리버리 호선은 선택 안되도록 함
					var rows = $( "#jqGridMainList" ).getDataIDs();
					if($("#cb_jqGridMainList").is(":checked") == true){
						var rows = $(this).getDataIDs();
						for(var i=0; i<rows.length; i++){
			    			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
			    			for(var j=0; j<deliverySeries.length; j++){
			    				if(item.project_no == deliverySeries[j].project_no){
			    					jqGridObj.jqGrid("setSelection", i+1);
			    					break;
			    				}
			    			}
			    		}	
						$("#cb_jqGridMainList").prop("checked", true);
					}
					else{
						jqGridObj.jqGrid("resetSelection");
					}
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
				
				//그리드 리스트에서 딜리버리 호선 체크박스 숨김
				var rows = $( "#jqGridMainList" ).getDataIDs();
				$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
					deliverySeries = data;
		    		for(var i=0; i<rows.length; i++){
		    			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
		    			for(var j=0; j<deliverySeries.length; j++){
		    				if(item.project_no == deliverySeries[j].project_no){
		    					$("#jqg_jqGridMainList_"+(i+1)).hide();
		    					break;
		    				}else{
		    					$("#jqg_jqGridMainList_"+(i+1)).show();
		    				}
		    			}
		    		}	
				},"json");
			},
			gridComplete: function(data){
				var rows = jqGridObj.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var work_yn = jqGridObj.getCell( rows[i], "work_yn" );
					var act_st = jqGridObj.getCell( rows[i], "wip_act_st" );
					var eco_date = jqGridObj.getCell( rows[i], "eco_date" );
					
					jqGridObj.jqGrid( 'setCell', rows[i], 'upper_block', '', { color : 'black', background : 'pink' } );

					if(eco_date != '' && (work_yn == 'N' || act_st == '')) {
						//jqGridObj.jqGrid( 'setRowData', rows[i], false, { color : 'black', background : 'red' } );
						jqGridObj.jqGrid( 'setCell', rows[i], 'work_yn', '', { color : 'black', background : 'red' } );
					}
				}
				
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {

			},
			ondblClickRow : function(rowid, cellname, value, iRow, iCol) {
				jqGridObj.saveCell(kRow, idCol );
				
				var cm = $( "#jqGridMainList" ).jqGrid( "getGridParam", "colModel" );
				var colName = cm[value];
				var item = $("#jqGridMainList").jqGrid( "getRowData", rowid );
				var prj_no = item.project_no;
				var block_no = item.block_no;
				
				if ( colName['index'].indexOf("upper_block") == 0 ) {
					var rs = window.showModalDialog( "popUpUscUpperBlockSearch.do?p_project_no="+prj_no, window,
							"dialogWidth:200px; dialogHeight:435px; center:on; scroll:off; status:off" );
					if ( rs != null ) {
						u_blk_set(rs, prj_no, block_no);
					}
				}
				if ( colName['index'].indexOf("eco_no") == 0 ) {
					var ecoName = item.eco_no;
	              	
	              	if( ecoName != "" && ecoName != "W" ) {
						var sUrl = "./eco.do?ecoName=" + ecoName+"&popupDiv=Y&checkPopup=Y&menu_id=${menu_id}";
						window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:650px; center:on; scroll:off; status:off");
	              	}
				}
				if ( colName['index'].indexOf("block_code") == 0 ) {
					var block_code = item.block_code;
					if(block_code != '' && block_code != undefined) {
						var arg = "&mother_code="+prj_no+"&item_code="+block_code+"&project_no="+prj_no;
						var rs = window.open("sscBomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
						"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
						
						setTimeout(function(){
							rs.focus();
						 }, 500);
					}
				}
				if ( colName['index'].indexOf("act_code") == 0 ) {
					var block_code = item.block_code;
					var act_code = item.act_code;
					if(act_code != '' && act_code != undefined) {
						var arg = "&mother_code="+block_code+"&item_code="+act_code+"&project_no="+prj_no;
						var rs = window.open("sscBomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
						"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
						
						setTimeout(function(){
							rs.focus();
						 }, 500);
					}			
				}
				if ( colName['index'].indexOf("job_code") == 0 ) {
					var act_code = item.act_code;
					var job_code = item.job_code;
					if(job_code != '' && job_code != undefined) {
						var arg = "&mother_code="+act_code+"&item_code="+job_code+"&project_no="+prj_no;
						var rs = window.open("sscBomStatus.do?menu_id=${menu_id}&up_link=bom&newWin=Y"+ arg, "",
						"height=900,width=1200,top=200,left=200,location=no,scrollbars=no, resizable=yes");	
						
						setTimeout(function(){
							rs.focus();
						 }, 500);
					}
				}
			},
			afterSaveCell : chmResultEditEnd
     	}); //end of jqGrid
    	// 구역 선택
     	$.post( "infoAreaList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_area").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
     	// 구역 선택
     	$.post( "infoStrList.do", "", function( data ) {
     		for (var i in data ){
     			$("#p_str_flag").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
     		for (var i in data ){
     			$("#p_block_str_flag").append("<option value='"+data[i].sd_code+"'>"+data[i].sd_code+"</option>");
     		}
		}, "json" );
     	//grid resize
	    fn_gridresize( $(window), jqGridObj, 90 );   
     	
	    //project 변경 시
		$("#p_project_no").change(function(){
			jqGridObj.jqGrid("clearGridData");
		});
		
		//BLOCK 버튼 클릭 시
		$("#btnBlock").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			if(uniqeValidation()){
				var nwidth = 900;
				var nheight = 600;
				var LeftPosition = (screen.availWidth-nwidth)/2;
				var TopPosition = (screen.availHeight-nheight)/2;
				var rs = window.open( "popUpUscBlock.do?p_project_no="+$("#p_project_no").val(), "uscBlock", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
			}
		});
		
		//Activity 버튼 클릭 시
		$("#btnActivity").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			var nwidth = 1000;
			var nheight = 600;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
			var rs = window.open( "popUpUscActivity.do", "uscActivity", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
		});
		
		//Save 버튼 클릭 시 
		$("#btnSave").click(function(){
			jqGridObj.saveCell(kRow, idCol );
			fn_save();
		});
		
		
		//Search 버튼 클릭 리스트를 받아 넣는다.
		$("#btnSearch").click(function(){
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			fn_search(); 
		});
		
		//Excel EXPORT 버튼 클릭 시 
		$("#btnExport").click(function(){
			fn_downloadStart();
			fn_excelDownload();	
		});
		
		//Restore 버튼 클릭 시 
		$("#btnRestore").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			for(var i=0; i<row_id.length; i++) {
				var item = jqGridObj.jqGrid('getRowData', row_id[i]);
				var state = item.state_flag;
				var eco_no = item.eco_no;
				var eco_date = item.eco_date;
				
				if(state != 'D') {
					alert("STATE가 D일 경우에만  RESTORE할 수 있습니다.");
					return false;
				} else {
					if(!(eco_date == '' || eco_date == undefined)) {
						alert("RELEASE된 데이터는 RESTORE할 수 없습니다.");
						return false;
					}
				}
			}
			
			for(var i=0; i<row_id.length; i++) {
				jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'R');
			}
			
			if(confirm("적용 하시겠습니까?")) {				
				var chmResultRows1 = [];

				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData1( function( data ) {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					chmResultRows1 = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows1 ) };
					var url = 'restoreUscMain.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						if ( data.result == 'success' ) {
							lodingBox.remove();
							alert("RESTORE 완료되었습니다.");
							fn_search();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}).always( function() {
				    	lodingBox.remove();	
					});
				});				
			}
		});
		
		//Delete 버튼 클릭 시 
		$("#btnDelete").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
			var flg = 0;
			var del_flg = 0;
			for(var i=0; i<row_id.length; i++) {
				var item = jqGridObj.jqGrid('getRowData', row_id[i]);
				var eco_no = item.eco_no;
				var eco_date = item.eco_date;
				var state_flag = item.state_flag;
				
				if((eco_no == '' || eco_no == undefined) || (eco_date == '' || eco_date == undefined)) {
					flg++;
				}
				
				if(state_flag == 'D') {
					del_flg++;
				}
				
				jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'D');
			}
			
			if(del_flg > 0) {
				alert("STATE가 D인 데이터는 삭제할 수 없습니다.");
				return false;
			}
			
			if(flg > 0) {
				if(confirm("ECO RELEASE 되지 않은 항목이 존재합니다.\n삭제 하시겠습니까?")) {								
					if(flg < row_id.length) {
						var rs = window.showModalDialog( "popUpUscDelete.do", window, "dialogWidth:350px; dialogHeight:220px; center:on; scroll:off; status:off" );
						if(rs == "OK") {
							fn_search();
						}
					} else {
						var chmResultRows = [];

						//변경된 row만 가져 오기 위한 함수
						getChangedChmResultData2( function( data ) {
							lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
							
							chmResultRows = data;
							var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
							var url = 'deleteUscMain.do?delete_gbn=';
							var formData = fn_getFormData('#application_form');
							//객체를 합치기. dataList를 기준으로 formData를 합친다.
							var parameters = $.extend( {}, dataList, formData); 
							
							$.post( url, parameters, function( data ) {
								alert(data.resultMsg);
								if ( data.result == 'success' ) {
									lodingBox.remove();
									//alert("삭제 완료되었습니다.");
									fn_search();
								}
							}, "json" ).error( function () {
								alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
							}).always( function() {
						    	lodingBox.remove();	
							});
						});		
					}										
				}
			} else {
				var rs = window.showModalDialog( "popUpUscDelete.do", window, "dialogWidth:350px; dialogHeight:220px; center:on; scroll:off; status:off" );			
				if(rs == "OK") {
					fn_search();
				}
			}			
			
		});
		
		//BOM 버튼 클릭 시
		$("#btnBom").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			for(var i=0; i<row_id.length; i++) {
				var item = jqGridObj.jqGrid('getRowData', row_id[i]);
				var eco_no = item.eco_no;
				var eco_date = item.eco_date;
				
				if(eco_no != "" && eco_no != undefined) {
					alert("DATA는 ECO에 기 연계 되어 있는 대상입니다.");
					return;
				}	
				if(eco_date != "" && eco_date != undefined) {
					alert("선택한 DATA는 RELEASE 된 대상입니다.");
					return;
				}
			}
			var nwidth = 1000;
			var nheight = 600;
			var LeftPosition = (screen.availWidth-nwidth)/2;
			var TopPosition = (screen.availHeight-nheight)/2;
			var rs = window.open( "popUpUscBom.do", "uscBom", "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",resizable=yes,scrollbars=no");
		});
		
	});	

	function fn_search() {
		// TODO
		if(uniqeValidation()){
			//시리즈 배열 받음
			var ar_series = new Array();
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
			
			var sUrl = "uscMainList.do?p_chk_series="+ar_series;
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				rowNum : jqGridObj.jqGrid('getGridParam', 'rowNum'),
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
	}
	
	function fn_search_bom() {
		// TODO
		if(uniqeValidation()){
			//시리즈 배열 받음
			var ar_series = new Array();
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}
			
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			
			if($("input[name=p_project_no]").val() != $("input[name=temp_project_no]").val()) {
				ar_series[0] = $("input[name=p_project_no]").val();
				getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
			}
			$("input[name=temp_project_no]").val($("input[name=p_project_no]").val());
			
			var sUrl = "uscMainList.do?p_chk_series="+ar_series;
			jqGridObj.jqGrid( "clearGridData" );
			jqGridObj.jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				datatype : 'json',
				page : 1,
				rowNum : 100,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
	}
	
	//저장 버튼
	function fn_save(){
		$( '#jqGridMainList' ).saveCell( kRow, idCol );
		
		var changedData = $( "#jqGridMainList" ).jqGrid( 'getRowData' );
		
		if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
			var chmResultRows = [];

			//변경된 row만 가져 오기 위한 함수
			getChangedChmResultData( function( data ) {
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				chmResultRows = data;
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				var url = 'saveUscMain.do';
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
			return obj.oper == 'I' || obj.oper == 'U';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData1( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'R';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//가져온 배열중에서 필요한 배열만 골라내기 
	function getChangedChmResultData2( callback ) {
		var changedData = $.grep( $( "#jqGridMainList" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'D';
		} );
		
		callback.apply( this, [ changedData.concat(resultData) ] );
	}
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
	}
	
	//체크 유무 validation
	var isChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
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
		
		//시리즈 배열 받음
		var ar_series = new Array();
		var p_ischeck = 'N';
		if(($("#SerieschkAll").is(":checked"))){
			p_ischeck = 'Y';
		}
		
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		
		for(var i=1; i<cm.length; i++ ){
			
			if(cm[i]['hidden'] == false) {
				colName.push(cn[i]);
				dataName.push(cm[i]['index']);	
			}
		}
		$( '#p_col_name' ).val(colName);
		$( '#p_data_name' ).val(dataName);
		var f    = document.application_form;
		f.action = "uscMainExcelExport.do?p_chk_series="+ar_series;
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
			
			form = $('#application_form');
	
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
				$(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function () {
			    $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
		    }
		});
	}
	
	var u_blk_set = function(u_blk, prj_no, blk_no) {
		var row_id = jqGridObj.getDataIDs();
		
		for(var i=0; i<row_id.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
			var project_no = item.project_no;
			var block_no = item.block_no;
			
			if(project_no == prj_no && block_no == blk_no) {
				jqGridObj.jqGrid('setCell', row_id[i], 'upper_block', u_blk);
				jqGridObj.jqGrid('setCell', row_id[i], 'oper', 'U');
			}
		}
	}

</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC Modify Main</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.header  {height:90px; margin-top:10px;}
	.header .searchArea {position:relative; width:99%; height:90px;  margin-bottom:6px; }
	.header .searchArea .searchDetail{position:relative; float:left; height:30px; margin:0 0px 4px 0px; font-weight:bold; }
	.header .searchArea .seriesChk{width:100%; height:36px;}	
	.header .searchArea .commonInput{width:70px; text-align:center;}
	.header .searchArea .uniqInput {background-color:#FFE0C0;}
	.header .searchArea .readonlyInput {background-color:#D9D9D9;}

	.header .searchArea .buttonArea1{position:relative; float:right; width:30%; text-align:right; }	
	.header .searchArea .buttonArea1 input{width:70px;  height:22px;}

	.header .searchArea .buttonArea2{position:relative; float:left; width:100%; text-align:right; margin-bottom:10px; }	
	.header .searchArea .buttonArea2 input{width:70px;  height:22px;}
	
	.header .searchArea .buttonArea2 .MoveSelectArea{float:left; width:800px; text-align:left; font-weight:bold; height:24px; }
	.header .searchArea .buttonArea2 .MoveSelectArea .MoveSelectBoxArea{float:left; margin-left:8px; height:24px; line-height:24px;}
	/*.itemInput {text-transform: uppercase;} */
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
	.header .searchArea .buttonArea #btnForm{float:left;}
	.uniqCell{background-color:#F7FC96}
	.sscType {color:#324877;
		font-weight:bold; 
		 }
	
	.subButtonArea input{border:1px solid #888; background-color:#B2C3F2; margin-bottom:4px; width:66px; }
	.required_cell{background-color:#F7FC96}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			SSC Modify -
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_isPaging" value="" />
		<input type="hidden" name="p_master_no" value="${p_master_no}" />
		<input type="hidden" name="p_item_type_cd" id="p_item_type_cd" value="${p_item_type_cd}" />		
		<input type="hidden" name="p_row_standard" value="" />
		<input type="hidden" name="p_work_key" value="" />
		<input type="hidden" name="p_work_flag" value="" />
		<input type="hidden" name="p_ssc_sub_id" value="${p_ssc_sub_id}" />
		<input type="hidden" value="1" id="stepState" name="p_stepstate"/>
		<input type="hidden" value="N" id="p_move_buy_buy_flag" name="p_move_buy_buy_flag"/>	
		<table class="searchArea conSearch">
			<col width="80"/>
			<col width="150"/>
			<col width="80"/>
			<col width="130"/>
			<col width="80"/>
			<col width="150"/>
			<col width="100"/>
			<col width="80"/>
			<col width="*"/>
			<tr>
				<th>PROJECT</th>
				<td>
				<input type="text" name="p_project_no" class = "required"  style="width:50px;" value="${p_project_no}" readonly="readonly"/>
				</td>
			
				<th>DWG NO.</th>
				<td>
				<input type="text" name="p_dwg_no"  class = "required" style="width:60px;" value="<c:out value="${p_dwg_no}" />" readonly="readonly"/>
				</td>
				<th>DEPT.</th>
				<td>
				<input type="text" name="p_dept_name" class="commonInput readonlyInput" style="width:130px;" readonly="readonly" value="<c:out value="${p_dept_name}" />" />
				<input type="hidden" name="p_dept_code" class="commonInput readonlyInput" style="width:70px;" readonly="readonly" value="<c:out value="${p_dept_code}" />" />
				</td>
				<th>USER</th>
				<td>
				<input type="text" name="p_user_name" class="commonInput readonlyInput" style="width:50px;" readonly="readonly" value="<c:out value="${loginUser.user_name}" />" />
				</td>
				<td class="bdr_no" style="border-right:none;">
					<c:choose>
						<c:when test="${p_item_type_cd != 'GE'}">
							<input type="button" class="btn_blue2" value="BUY-BUY" id="btnBuybuy" />
						</c:when>
					</c:choose>	
					<c:choose>
						<c:when test="${p_item_type_cd == 'TR'}">
							&nbsp;
							TRAY NO. COPY
							<input type="checkbox" id="btnTrayNoCopy" name="btnTrayNoCopy" value="" onclick="btnTrayNoCopyCheck()"/>
						</c:when>
					</c:choose>	
					
						
				</td>
				<!-- <th>Rev.</th>
				<td style="border-right:none;">
				<span id="revArea"></span>
				</td> -->
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="BACK" id="btnBack" style="display: none;"/>
						<input type="button" class="btn_blue2" value="NEXT" id="btnNext" />
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
		<table class="searchArea2 ">
			<tr>
				<td class="sscType" style="width: 45px;">
				MOVE
				</td>
				<td style="border-right:none;">
					DWG
					<select name="p_move_dwg_no" id="p_move_dwg_no" style="width:90px;" onchange="javascript:callBack_dwgNo();">
					</select>&nbsp;
					<input type="hidden" name="h_move_dwg_no" id="h_move_dwg_no" value="" />
					BLOCK 
					<select name="p_move_block" id="p_move_block" style="width:60px;" onchange="javascript:BlockOnChange(); JobOnChange();">
					</select>	&nbsp;
					STR 
					<select name="p_move_str" id="p_move_str" style="width:60px;" onchange="javascript:StrOnChange(); JobOnChange();">
					</select>&nbsp;
					TYPE
					<select name="p_move_usc_job_type" id="p_move_usc_job_type" style="width:200px;" onchange="javascript:JobOnChange();">
					</select>&nbsp;
					STAGE 
					<input type="text" name="p_move_stage" id="p_move_stage" style="width:60px;" onchange="javascript:JobOnChange();"/>
					&nbsp;
					
					<font id="p_modify_buy_mother_code_font" color="#ff3333"><b>Mother Item</b></font>
<!-- 					<input type="text" name="p_modify_buy_mother_code" id="p_modify_buy_mother_code" style="width:90px; border: 2px solid #4d79ff;" onchange="javascript:JobValidation()" /> -->
					<select name="p_modify_buy_mother_code" id="p_modify_buy_mother_code" style="width:120px; border: 2px solid #ff3333;" >
					</select>
					
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="DETAIL COPY" id="btnDetailCopy" style="display:none; width:80px" />
<!-- 						<input type="button" class="btn_blue2" value="TRAY NO COPY" id="btnTrayNoCopy" style="display:none; width:90px" /> -->
						<input type="button" class="btn_blue2" value="EA COPY" id="btnEaCopy" style="display:none" />
						<!--input type="button" class="btn_blue2" value="Confirm" id="btnConfirm" /-->
					</div>
				</td>
			</tr>
		</table>
							
		<div class="content">
			<table id="jqGridModifyMainList"></table>
			<div id="bottomJqGridModifyMainList"></div>
		</div>
		<!-- loadingbox -->
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>

<script type="text/javascript" src="/js/getGridColModel${p_item_type_cd}.js" charset='utf-8'></script>
<script type="text/javascript" >
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	var usc_chag_flag = "";
	var backList = "";
	var btnTrayNoCopyCheck = "N";
	
	//필수 입력 값의 배경 색 지정
	var jqGridObj = $("#jqGridModifyMainList");

	$(document).ready(function(){	
		
		$("#p_modify_buy_mother_code_font").hide();
		$("#p_modify_buy_mother_code").hide();
		
		if ( $("#p_item_type_cd").val() == 'TR' ){
			$("#btnTrayNoCopy").show();	
		}
		
		var vAble = "";
		
		$("input[name=p_usc_chg_flag]").each(function(){
			if($(this).val() == "Y"){
				vAble = "disabled='disabled'";	
				usc_chag_flag = "Y";
				return;							
			}
		});
		
		
		//시리즈 호선 받기		
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_able="+vAble, null, getDeliverySeriesCallback);
		
		//Rev 받기.
		//getAjaxHtml($("#revArea"),"sscCommonRevTextBox.do?p_master_no="+$("input[name=p_master_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null);

		//Block 정보 받기
		getAjaxHtml($("#p_move_block"),"commonSelectBoxDataList.do?p_query=getBlockNoList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=sel", null);
		
		//DWG NO 정보 받기		
		getAjaxHtml($("#p_move_dwg_no"),"commonSelectBoxDataList.do?p_query=getDwgNoList&p_master_no="+$("input[name=p_master_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&sb_type=not"+"&p_dept_code="+$("input[name=p_dept_code]").val(), null, callBack_dwgNo);
		
		var vItemTypeCd = $("input[name=p_item_type_cd]").val();

		////js/getGridColModel.js에서 그리드의 colomn을 받아온다.
		var gridColModel = getModifyGridColModel();
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'sscChekedMainList.do',
            postData : fn_getFormData('#application_form'),
            mtype : 'POST',
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
            pager: '#bottomJqGridModifyMainList',
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
				var $this = $(this);
				
				if( data.resultMsg != '' ) {
					alert(data.resultMsg);
					history.go(-1);
				}
				
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
				
				
				//Validation 이후 셀 색깔 변경 및 TITLE TOOLTOP 설정
				var rows = $(this).getDataIDs();
				var err_style = { color : '#FFFFFF', background : 'red'};
				
				//필수 필드 배열 세팅
				var necessary_err_field;
				
				//필수 에러 필드 세팅
				
				if($("input[name=p_item_type_cd]").val() == "SU"){
					necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','item_weight','key_no','paint_code1');	
				}else if($("input[name=p_item_type_cd]").val() == "CA"){
					necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','item_weight','key_no');
				}else if($("input[name=p_item_type_cd]").val() == "OU"){
					necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','key_no');
				}else if($("input[name=p_item_type_cd]").val() == "SE"){
					necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','item_weight','key_no');
				}else if($("input[name=p_item_type_cd]").val() == "TR"){
					necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty','item_weight','key_no');
				}else if($("input[name=p_item_type_cd]").val() == "PA"){
					necessary_err_field = new Array('project_no','dwg_no','job_cd','mother_code','item_code','bom_qty');
				}else{
					necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','item_code','bom_qty');
				}
				
				
				var nomal_err_field;
				//일반 에러 필드 정의 (WORK 테이블의 ERROR_MSG_01, ERROR_MSG_02, ...)
				//error_msg_01,error_msg_02 ... 순으로 컬럼명 세팅
				if($("input[name=p_item_type_cd]").val() == "SU"){	
					nomal_err_field = new Array('paint_code1','key_no');
				}else if($("input[name=p_item_type_cd]").val() == "CA"){	
					nomal_err_field = new Array('attr01', 'attr02');
				}else if($("input[name=p_item_type_cd]").val() == "OU"){	
					nomal_err_field = new Array('temp01', 'paint_code1', 'paint_code2');
				}else if($("input[name=p_item_type_cd]").val() == "SE"){	
					nomal_err_field = new Array('temp01', 'temp02', 'temp03', 'paint_code1', 'item_category_code');
				}else if($("input[name=p_item_type_cd]").val() == "TR"){	
					nomal_err_field = new Array('temp01', 'temp02', 'paint_code1', 'item_category_code');
				}else if($("input[name=p_item_type_cd]").val() == "VA"){	
					nomal_err_field = new Array('temp10');
				}else if($("input[name=p_item_type_cd]").val() == "PA"){	
					nomal_err_field = new Array('temp01');
				}
				
				//모든 행 loop
				for ( var i = 0; i < rows.length; i++ ) {
					
					//TR일때 표준품이면 필수값 해제, 표준품이 아니면 필수값 지정
					if($("input[name=p_item_type_cd]").val() == "TR"){
						
						var itemCode = $(this).getCell( rows[i], "bom_item_detail");
						$(this).setCell(rows[i], "modify_detail", itemCode);

						var str = $(this).getCell( rows[i], "item_code").substring(0,1);
						
						if(str == "1" || str == "2" || str == "3" || str == "4" || str == "5" || str == "9") {
							syncClassByContainRow(jqGridObj, i, 'temp07','', false, 'required_cell');
							$(this).setCell (rows[i], 'temp07','', {'background-color':'#F7FC96'});
						}
						else {
							syncClassByContainRow(jqGridObj, i, 'temp07','', true, 'required_cell');
							$(this).setCell (rows[i], 'temp07','', '', {title : "비표준품은 Tray No 필수입력"});
						}
					}
					
					if(necessary_err_field != null){
						//필수 오류 체크 loop
						for(var j=0; j<necessary_err_field.length; j++){
							//에러 필드 값
							var err_feild_val = $(this).getCell( rows[i], "error_msg_" + necessary_err_field[j]);
							//에러 필드의 값이 있으면 에러 표시 
							if(err_feild_val != ""){
								//수정 및 결재 가능한 리스트 색상 변경
								$(this).setCell (rows[i], necessary_err_field[j],'', err_style, {title : err_feild_val});
							}
						}
						
					}
					if(nomal_err_field != null){
						//각 개별 오류 체크
						for(var j=0; j<nomal_err_field.length; j++){                   
							var numStr = j+1;
							
							if(j < 10){
								numStr = "0" + numStr;
							}
							//에러 필드 값	l
							var err_feild_val = $(this).getCell( rows[i], "error_msg_"+numStr);
							//에러 필드의 값이 있으면 에러 표시 
							if(err_feild_val != ""){
								$(this).setCell (rows[i], nomal_err_field[j],'', err_style, {title : err_feild_val});
							}
						}
					}
					
				}
				
			},		
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
				
				//BOM11에 값이 없으면 TEMP11 EDIT 비활성화
				var item = $( this ).jqGrid( 'getRowData', rowid );
				if(item.bom11 == ""){
					$(this).jqGrid( 'setCell', rowid, 'temp11', '', 'not-editable-cell' );	
				}
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj , 90 );

    	//초기 job 셋팅
    	//getJobCode('','','');
    	
    	$("#btnBuybuy").click(function(){
    		var move_buy_buy_flag = $("#p_move_buy_buy_flag").val();
    		
    		if(move_buy_buy_flag == "N") {
				$("#p_modify_buy_mother_code_font").show();
				$("#p_modify_buy_mother_code").show();
				$("#p_move_buy_buy_flag").val("Y");
				$('#p_move_dwg_no').attr('disabled',true);
    		} else {
    			$("#p_modify_buy_mother_code_font").hide();
				$("#p_modify_buy_mother_code").hide();
    			$("#p_move_buy_buy_flag").val("N");
    			$('#p_move_dwg_no').attr('disabled',false);
    		}
		});
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){ 
			/* //location.href= "/ematrix/tbcMain.tbc?p_project="+$("input[name=p_project]").val()+"&p_dwgno="+$("input[name=p_dwgno]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_ship="+$("select[name=p_ship] option:selected").val();
			var p_ischeck = 'N';
			if(($("#SerieschkAll").is(":checked"))){
				p_ischeck = 'Y';
			}	
		
			//시리즈 배열 받음
			var ar_series = new Array();
			for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
				ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
			}
			location.href= "sscMain.do?p_chk_series="+ar_series
					+"&p_ischeck="+p_ischeck
					+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()
					+"&p_project_no="+$("input[name=p_project_no]").val()
					+"&p_dwg_no="+$("input[name=p_dwg_no]").val()
					+"&page_flag=next"; */
			history.go(-1);
		});
		
		
		//Confirm 버튼  클릭
		$("#btnDel").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return false;
			}
			
		});
		//Next 클릭
		$("#btnNext").click(function(){
			
			if( $("#p_move_buy_buy_flag").val() == "Y"){
				if( $("#p_modify_buy_mother_code").val() == " " || $("#p_modify_buy_mother_code").val() == null ){
					alert("MOTHER ITEM 은 필수 입력사항입니다.");
					return;
				}
			}
			
			jqGridObj.saveCell(kRow, idCol );
			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			//무브 정보가 없으면 수량 변경로직
			if($("#p_move_block").val() == ""){
				$("input[name=p_work_flag]").val("MODIFY_EA");
			}else{
				$("input[name=p_work_flag]").val("MODIFY_MOVE");
			}
			
			var formData = fn_getFormData('#application_form');
			
			//Validation 체크 로직
			if($("input[name=p_stepstate]").val() == "1"){
				
				var dwg_no = $("select[name=p_move_dwg_no]").val();
				var block = $("select[name=p_move_block]").val();
				var str = $("select[name=p_move_str]").val();
				var usc_job_type = $("select[name=p_move_usc_job_type]").val();
				var stage = $("input[name=p_move_stage]").val();
				var buy_mother = $("select[name=p_modify_buy_mother_code]").val();
				
				var row_id = jqGridObj.getDataIDs();
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
					
					//2017-03-29 양동협 대리 요청으로 동일위치로 무브가 가능하도록 변경
// 					if(item.dwg_no == dwg_no && 
// 							item.block_no == block &&
// 							item.str_flag == str &&
// 							item.usc_job_type == usc_job_type &&
// 							item.stage_no == stage
// 							) {
// 						alert("동일 위치에는 MOVE가 불가능합니다.");					
// 						return false;
// 					}
					
					if(item.item_code == buy_mother) {
						alert("동일 ITEM CODE 하위로는 이동이 불가능합니다.");					
						return false;
					}
				}
				
				var rtn = true;
				
				//Move 정보 체크 (Block, Stage, STR, Job)
				if($("input[name=p_work_flag]").val() == "MODIFY_MOVE"){
					var validationItem = new Array("p_move_str", "p_move_dwg_no", "p_move_job_cd");
					
					for(var i=0; i<validationItem.length; i++){
						if($("#"+validationItem[i]).val() == ""){
							alert("Move 정보를 선택하십시오.");
							rtn = false;                                                             
							return false;	
						}
					}
				}
				

				if(!rtn){
					return false;
				}
				
				//Stage 체크
				if($("select[name=p_move_block]").val() != "" ){
					if($("input[name=p_move_stage]").length != 0) {
					
						//필수 값 아님 Validation
						if($("input[name=p_item_type_cd]").val() != "GE" 
						&& $("input[name=p_item_type_cd]").val() != "OU" 
						&& $("input[name=p_item_type_cd]").val() != "EQ"
						&& $("input[name=p_item_type_cd]").val() != "SE"
						&& $("input[name=p_item_type_cd]").val() != "TR"							
						&& $("input[name=p_item_type_cd]").val() != "CA"
						&& $("input[name=p_item_type_cd]").val() != "PA"
						){							
							if($("input[name=p_move_stage]").val() == "" || $("input[name=p_move_stage]").val() == null ){
								alert("Stage를 입력 주십시오.");
								rtn = false;
							}
						}
					}
					if($("select[name=p_move_str]").val() == "" && rtn){
						alert("STR을 지정해 주십시오.");
						rtn = false;
					}
				}
				
				if(!rtn){
					return false;
				}

				//버튼 눌럿으면 수정 못하도록 비활성화
				$('#btnBuybuy').attr('disabled',true);
				$('#p_modify_buy_mother_code').attr('disabled',true);
				
				//모든 행 읽음
				var changeRows = [];
				
				//그리드의 내용을 받는다.
				getGridChangedData(jqGridObj,function(data) {
					changeRows = data;
					
					if (changeRows.length == 0) {
						alert("내용이 없습니다.");
						return;
					}
					
					$(".required_cell").each(function(){
						if($(this).text().trim() == ""){
							alert("필수 입력값 중 입력하지 않은 값이 있습니다.");
							jqGridObj.jqGrid('resetSelection');
							$(this).context.style.backgroundColor = "#ff9999";
							rtn = false;
							return false;
						}
						else{
							$(this).context.style.backgroundColor = "#F7FC96";
						}
					});
					
					for(var i=0; i<changeRows.length; i++){
						
						//수량 변경 시 
						if($("input[name=p_work_flag]").val() == "MODIFY_EA"){
							if($("input[name=p_item_type_cd]").val() == "PA"){
								if(changeRows[i].temp05 == changeRows[i].bom14){
									if(changeRows[i].modify_bom_qty*1 == changeRows[i].bom_qty*1){
										alert("수량이 동일할 수 없습니다.");
										rtn = false;		
										return false;
									}
								}	
							}else if($("input[name=p_item_type_cd]").val() == "VA"){	
								if(changeRows[i].modify_bom_qty*1 == changeRows[i].bom_qty*1 && changeRows[i].bom7 == changeRows[i].temp06 && $("input[name=p_item_type_cd]").val() != "TR" ){
									alert("수량과 SUPPLY 모두 동일할 수 없습니다.");
									rtn = false;		
									return false;
								}
							}else{	
								if(changeRows[i].modify_bom_qty*1 == changeRows[i].bom_qty*1 && $("input[name=p_item_type_cd]").val() != "TR" ){
									alert("수량이 동일할 수 없습니다.");
									rtn = false;		
									return false;
								}
							}
						}else{
							if(changeRows[i].modify_bom_qty*1 > changeRows[i].bom_qty*1){
								alert("Move 수량이 기존 수량보다 많습니다. \n변경EA를 수정하십시오.");
								rtn = false;		
								return false;
							}
						}
					}
					
					if(!rtn){
						return false;
					}
					
					//EA 공백 체크	
					for(var i=0; i<changeRows.length; i++){
						if($("input[name=p_item_type_cd]").val() == "PA"){
							//이론 물량 수량을 각각 업데이트 할 수 있어야 함.
							if((changeRows[i].temp05 == "" || changeRows[i].temp05 == "0")){
								if((changeRows[i].modify_bom_qty*1 == changeRows[i].bom_qty*1)){
									alert("수량이 잘못되었습니다.");
									rtn = false;		
									return false;	
								}
							}
							
							if((changeRows[i].modify_bom_qty == "" || changeRows[i].modify_bom_qty == "0")){
								if((changeRows[i].temp05 == changeRows[i].bom14)){
									alert("수량이 잘못되었습니다.");
									rtn = false;		
									return false;	
								}
							}
						}else{
							if(changeRows[i].modify_bom_qty == "" || changeRows[i].modify_bom_qty == "0" ){
								alert("수량이 잘못되었습니다.");
								rtn = false;		
								return false;
							}
						}
					}
					
					if(!rtn){
						return false;
					}
					
					//시리즈 배열 받음
					var ar_series = new Array();
					for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
						ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
					}
					
					//back버튼 클릭시 필요한 리스트
					backList = changeRows;
					
					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var parameters = $.extend({}, dataList, formData);

					$(".loadingBoxArea").show();
					
					$("#p_selrev").attr("disabled", false);
					
					//검색 시 스크롤 깨짐현상 해결
					jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
					
					//getJsonAjaxFrom("sscModifyValidationCheck.do?p_chk_series="+ar_series, parameters, null, callback_next);
					$.ajax({
						url:"sscModifyValidationCheck.do?p_chk_series="+ar_series,
						cache:false,
						data:parameters,
						dataType:"json",
						type:'POST',
						success:function(data){
							$(".loadingBoxArea").hide();
							if(data.p_err_code == 'S'){
								callback_next(data);
							}
							else{
								jqGridObj.jqGrid('resetSelection');
								alert(data.resultMsg);
								for(var i=0; i<changeRows.length; i++){
									if(changeRows[i].ssc_sub_id == data.error_ssc_sub_id){
										jqGridObj.setCell (i+1, 'temp07','', {'background-color':'#FF9999'});
									}
								}
								return false;
							}
						},
						error:function(jxhr,textStatus)
						{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
							alert(jxhr.responseText);
						}  
					});
					
				});
				 
			}else if($("input[name=p_stepstate]").val() == "2"){
			
				//프로세스가 NO 이면 진행 불가
				if(!chkgridProcess()){
					return false;
				}
				
				//검색 시 스크롤 깨짐현상 해결
				jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
				
				//BOM에 반영	
				if(confirm('적용하시겠습니까?')){
				$(".loadingBoxArea").show();
					$.post("sscModifyApplyAction.do", formData, function(data)
					{	
						$(".loadingBoxArea").hide();
						alert(data.resultMsg);
						$("#btnClose").click();
					},"json");
				}
			}
		});	
		
		//Back 기능
		$("#btnBack").click(function(){
			
			var jsonGridData = new Array();
			var itemtype = $("input[name=p_item_type_cd]").val();
			
			if(confirm('뒤로 돌아가시겠습니까?')){	
				$( jqGridObj).jqGrid( "clearGridData" );
				
					for ( var i = 0; i < backList.length; i++ ) {
						if(itemtype == "EQ") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "PI") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "CA") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "GE") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "OU") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_item_detail : backList[i].bom_item_detail             
					             , modify_detail : backList[i].modify_detail
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "SE") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_item_detail : backList[i].bom_item_detail             
					             , modify_detail : backList[i].modify_detail
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "SU") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "TR") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , temp07 : backList[i].temp07
					             , bom_item_detail : backList[i].bom_item_detail             
					             , modify_detail : backList[i].modify_detail
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						} else if(itemtype == "VA") {
							jsonGridData.push({ssc_sub_id : backList[i].ssc_sub_id
								 , state_flag : backList[i].state_flag
					             , master_ship : backList[i].master_ship
					             , project_no : backList[i].project_no
					             , dwg_no : backList[i].dwg_no
					             , block_no : backList[i].block_no
					             , stage_no : backList[i].stage_no
					             , str_flag : backList[i].str_flag
					             , usc_job_type : backList[i].usc_job_type
					             , job_cd : backList[i].job_cd
					             , buy_buy_flag : backList[i].buy_buy_flag
					             , mother_code : backList[i].mother_code
					             , item_code : backList[i].item_code
					             , key_no : backList[i].key_no
					             , bom_qty : backList[i].bom_qty
					             , modify_bom_qty : backList[i].modify_bom_qty
					             , bom7 : backList[i].bom7
					             , temp06 : backList[i].temp06
					             , process : backList[i].process
					             , item_catalog : backList[i].item_catalog
					             , oper : backList[i].oper
					             , move_info : backList[i].move_info});
						}
					}
				}
			
			//수정할수 있도록 다시 활성화
			$('#btnBuybuy').attr('disabled',false);
			$('#p_modify_buy_mother_code').attr('disabled',false);
			
			//검색 시 스크롤 깨짐현상 해결
			jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
			
			jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
			callback_back();
			
			//모든 행 loop
			var rows = jqGridObj.getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				
				//TR일때 표준품이면 필수값 해제, 표준품이 아니면 필수값 지정
				if($("input[name=p_item_type_cd]").val() == "TR"){
					
					var itemCode = jqGridObj.getCell( rows[i], "bom_item_detail");
					jqGridObj.setCell(rows[i], "modify_detail", itemCode);

					var str = jqGridObj.getCell( rows[i], "item_code").substring(0,1);
					
					if(str == "1" || str == "2" || str == "3" || str == "4" || str == "5" || str == "9") {
						syncClassByContainRow(jqGridObj, i, 'temp07','', false, 'required_cell');
						jqGridObj.setCell (rows[i], 'temp07','', {'background-color':'#F7FC96'});
					}
					else {
						syncClassByContainRow(jqGridObj, i, 'temp07','', true, 'required_cell');
						jqGridObj.setCell (rows[i], 'temp07','', '', {title : "비표준품은 Tray No 필수입력"});
					}
				}
			}
		});
		
		$("#btnEaCopy").click(function(){
			
			var row_id = jqGridObj.getDataIDs();
			for(var i=0; i<row_id.length; i++) {
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
				jqGridObj.jqGrid('setCell', row_id[i], 'modify_bom_qty', item.bom_qty);
			}
			
// 			$("input[name=p_modifyDetail]").each(function(){
// 				if($(this).css("display") != "none"){
// 					$(this).val($(this).parent().parent().find("input[name=p_detail]").val());
// 				}
// 			});
// 			$("input[name=p_modifyEA]").each(function(){
// 				if($(this).css("display") != "none"){
// 					$(this).val($(this).parent().parent().find("input[name=p_ea]").val());
// 				}
// 			});
			
// 			$("input[name=p_modifyKey]").each(function(){
// 				if($(this).css("display") != "none"){
// 					$(this).val($(this).parent().parent().find("input[name=p_key]").val());
// 				}
// 			});
			
		});
		
		$("#btnTrayNoCopy").click(function(){
			if( btnTrayNoCopyCheck == "N"){
				var row_id = jqGridObj.getDataIDs();
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
					jqGridObj.jqGrid('setCell', row_id[i], 'temp07', item.key_no);
				}
				btnTrayNoCopyCheck = "Y";
			}else{
				var row_id = jqGridObj.getDataIDs();
				for(var i=0; i<row_id.length; i++) {
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
					jqGridObj.jqGrid('setCell', row_id[i], 'temp07', "&nbsp;");
				}
				btnTrayNoCopyCheck = "N";
			}
		});
		
		$("#btnDetailCopy").click(function(){
			var row_id = jqGridObj.getDataIDs();
			for(var i=0; i<row_id.length; i++) {
				var item = jqGridObj.jqGrid( 'getRowData', row_id[i] );
				jqGridObj.jqGrid('setCell', row_id[i], 'modify_detail', item.bom_item_detail);
			}
		});
		
		//Excel Form 클릭 다운로드	
		$("#btnForm").click(function(){
			var itemtype = $("input[name=p_item_type_cd]").val();
			$.download('fileDownload.do?fileName=SSCExcelImportFormat'+itemtype+'.xls',null,'post');
		});
	
		
		
		$(document).keydown(function (e) { 
			if (e.keyCode == 27) { 
				e.preventDefault();
			} // esc 막기
			if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA"){
				if(e.keyCode == 8) {
					return false;
				}
			}
		}); 
	});
	
    function getDeliverySeriesCallback(){
    	$.post("getDeliverySeries.do?p_project_no="+$("input[name=p_project_no]").val(),"" ,function(data){
			var deliverySeries = data;
    		for(var i=0; i<$("input[name=p_series]").length; i++){
    			var id = $("input[name=p_series]")[i].id;
    			for(var j=0; j<deliverySeries.length; j++){
    				if($("input[name=p_series]")[i].id == "p_series_"+deliverySeries[j].project_no){
    					$("#" + id).attr("disabled", true); 
        				$("input:checkbox[id='"+id+"']").prop("checked", false);
        				break;
    				}
    				else{
    					$("#" + id).attr("disabled", false);
        				//$("input:checkbox[id='"+id+"']").prop("checked", true);
    				}
    			}
    		}	
		},"json");
    }
	
	var callBack_dwgNo = function(){
		var moveDwgNo = $("#p_move_dwg_no option:selected").val();
		$("#h_move_dwg_no").val(moveDwgNo);
	}

	var callback_next = function(json){
		
		$("#btnBack").show();
		$("#btnNext").attr("value", "Apply");
		
		$("input[name=p_work_key]").val(json.p_work_key);

		//그리드 초기화
		$( jqGridObj).jqGrid( "clearGridData" );
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : 'sscWorkValidationList.do',
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData('#application_form'),
			cellEdit : false
		} ).trigger( "reloadGrid" );
		
		$("input[name=p_stepstate]").val("2");
				
		$("input[name=p_series]").attr("disabled", "disabled");		
		$("select[name=p_move_block]").attr("disabled", "disabled");
		$("input[name=p_move_stage]").attr("disabled", "disabled");
		$("select[name=p_move_str]").attr("disabled", "disabled");		
		$("select[name=p_selrev]").attr("disabled", "disabled");		
		$("select[name=p_move_job_cd]").attr("disabled", "disabled");
		$("select[name=p_move_dwg_no]").attr("disabled", "disabled");
		$("select[name=p_move_usc_job_type]").attr("disabled", "disabled");
		$("#btnEaCopy").attr("disabled", "disabled");
		$("#btnDetailCopy").attr("disabled", "disabled");
		$("#btnTrayNoCopy").attr("disabled", "disabled");

		//검색 시 스크롤 깨짐현상 해결
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
		
		$(".loadingBoxArea").hide();
		
	}
	
	var callback_back = function(json){
		
		$("#btnBack").hide();
		$("#btnNext").attr("value", "NEXT");
		$("input[name=p_work_key]").val("");
		$("input[name=p_stepstate]").val("1");
		if($("#p_move_buy_buy_flag").val() == "N"){
			$("select[name=p_move_dwg_no]").removeAttr("disabled");
		}
		$("input[name=p_series]").removeAttr("disabled");		
		$("select[name=p_move_block]").removeAttr("disabled");
		$("input[name=p_move_stage]").removeAttr("disabled");
		$("select[name=p_move_str]").removeAttr("disabled");		
		$("select[name=p_selrev]").removeAttr("disabled");	
		$("select[name=p_move_job_cd]").removeAttr("disabled");
		$("select[name=p_move_usc_job_type]").removeAttr("disabled");
		$("#btnEaCopy").removeAttr("disabled", "disabled");
		$("#btnDetailCopy").removeAttr("disabled", "disabled");
		
		if($("input[name=p_item_type_cd]").val() == "TR"){
			$("#btnTrayNoCopy").removeAttr("disabled", "disabled");
		}
		
		
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : '',
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData('#application_form'),
			cellEdit : true
		} ).trigger( "reloadGrid" );
		
		//검색 시 스크롤 효과 없애기
		jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0);
		
	}
	
	//afterSaveCell oper 값 지정
	function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
		if(typeof(val) == "undefined") return;
		var item = jqGridObj.jqGrid( 'getRowData', irow );
		if (item.oper != 'I')
			item.oper = 'U';

		jqGridObj.jqGrid( "setRowData", irow, item );
		$( "input.editable,select.editable", this ).attr( "editable", "0" );
		
		//입력 후 대문자로 변환
		jqGridObj.setCell (irow, cellName, val.toUpperCase(), '');
	}
	
	
	//Process 필드가 NO인 것이 있으면 진행불가.
	var chkgridProcess = function(){
		
		var processData = $.grep(jqGridObj.jqGrid('getRowData'), function(obj) { 
			return obj.process == 'NO'; 
		});	
		
		if(processData.length > 0){
			alert("올바르지 않은 데이터가 있습니다. \n데이터를 확인하십시오.");
			return false;
		}else{
			return true;		
		}
	}
	
	//Block 정보 변경시 
	var BlockOnChange = function(){
		//STR 정보 받기
		getAjaxHtml($("#p_move_str"),"commonSelectBoxDataList.do?p_query=getStrFlagList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=sel"+"&p_block_no="+$("#p_move_block option:selected").val(), null);						
	}
	
	//Str 정보 변경시 
	var StrOnChange = function(){
		//STR 정보 받기
		getAjaxHtml($("#p_move_usc_job_type"),"commonSelectBoxDataList.do?p_query=getUscJobTypeList&p_master_no="+$("input[name=p_master_no]").val()
				+"&sb_type=null&p_block_no="+$("#p_move_block option:selected").val()
				+"&p_str_flag="+$("#p_move_str option:selected").val()
				+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null);
		
		var rows = jqGridObj.getDataIDs();
		var item;

		for ( var i = 0; i < rows.length; i++ ) {
			item = jqGridObj.jqGrid( 'getRowData', rows[i] );
			
			jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', item.bom_qty);
			jqGridObj.jqGrid('setCell', rows[i], 'modify_detail', item.bom_item_detail);
			
			/* if(item.bom_qty == "1") {
				jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "1" );	
			}
			else {
				jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "0" );
			} */
		}
		
		/* var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
		jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', item.bom_qty);
		jqGridObj.jqGrid('setCell', rows[i], 'modify_detail', item.bom_item_detail);
		
		var itemType = $("input[name=p_item_type_cd]").val();
		if( itemType != "VA" && itemType != "CA" ){
			var moveJobCdBox = $("#p_move_str").val();
			if(moveJobCdBox != null){
				var rows = jqGridObj.getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
					if(item.bom_qty == 1) {
						jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "1" );
					}
				}
				$("#btnEaCopy").show();
				if(itemType == "SE") $("#btnDetailCopy").show();
			} else {
				$("#btnEaCopy").hide();
				$("#btnDetailCopy").hide();
			}	
		} */
	}
	
	var JobOnChange = function(){
		
		//job 정보를 가져온 후에 실행되어야 하기때문에 0.5초 딜레이
		setTimeout("JobOnChangeTime()", 300);
	}
	
	//Job 정보 변경시 
	var JobOnChangeTime = function(){
		var stageVal = $("#p_move_stage").val();
		if(stageVal == undefined){
			stageVal = "";
		} else {
			stageVal = stageVal.toUpperCase();
		}
		
		//buy-buy 정보 받기
		getAjaxHtml($("#p_modify_buy_mother_code"),"commonSelectBoxDataList.do?p_query=getMotherList&p_project_no="
				+$("input[name=p_master_no]").val() + "&p_dwg_no=" + $("#p_move_dwg_no option:selected").val()
				+"&sb_type=not&p_block_no="+$("#p_move_block option:selected").val()+"&p_str_flag="+$("#p_move_str option:selected").val()
				+"&p_usc_job_type="+$("#p_move_usc_job_type option:selected").val()
				+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val()
				+"&p_stage_no="+stageVal, null);
	}
	
	//Move 정보 변경시 
	var MoveOnChange = function(thisObj){
	
		jqGridObj.saveCell(kRow, idCol );
	
		//모든 행 읽음	
		var rows = jqGridObj.getDataIDs();
		var item;
// 		if( $("input[name=p_item_type_cd]").val() == "CA" ){
// 			for ( var i = 0; i < rows.length; i++ ) {
// 				jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "1" );
// 			}	
// 		}
// 		else {
// 			for ( var i = 0; i < rows.length; i++ ) {
// 				jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "0" );
// 			}
// 		}
		
		for ( var i = 0; i < rows.length; i++ ) {
			item = jqGridObj.jqGrid( 'getRowData', rows[i] );
			if(item.bom_qty == "1") {
				jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "1" );	
			}
			else {
				jqGridObj.jqGrid('setCell', rows[i], 'modify_bom_qty', "0" );
			}
			
		}	
	
		
		$("input[name=p_ea]").each(function(){
			$(this).parent().parent().find("input[name=p_modifyEA]").val($(this).val());
		});
		
		//JOB CD를 불러온다.
		var vListProject = "";
		
		var vUniqPproject = [];
		//상위 변경 무브 시 
		if(usc_chag_flag == "Y"){
					
			var vListProject = $.map($("input[name=p_lproject_no]"), function(item, index){
																		return $(item).val();						
																   });			
			//중복제거
			$.each(vListProject, function(i, el){
				if($.inArray(el, vUniqPproject) === -1) vUniqPproject.push(el);
			});
		}
		
		var vSerise = new Array();
		
		for(var i=0; i<$("input[name=p_series]").length; i++){
			vSerise[i] = $("input[name=p_series]").eq(i).val();
		}
		
		getAjaxHtml($("#p_move_job_cd"),"commonSelectBoxDataList.do?p_query=getJobList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=not&p_block_no="+$("#p_move_block option:selected").val()+"&p_str_flag="+$("#p_move_str option:selected").val() 
				+ "&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null, callback_move);

	}
	

	var callback_move = function(){

		JobValidation();
	}
	
	var JobValidation = function(){
		
		if($("#p_move_job_cd").length == 1 && $("select[name=p_move_job_cd]").find("option:selected").attr("name") != 'undefined') {
			$("select[name=p_move_usc_job_type]").val($("select[name=p_move_job_cd]").find("option:selected").attr("name"));
		}

		//getAjaxHtml($("#p_modify_buy_mother_code"),"commonSelectBoxDataList.do?p_query=getMotherList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=not&p_block_no="+$("#p_move_block option:selected").val()+"&p_str_flag="+$("#p_move_str option:selected").val()+"&p+stage_no="+("#p_move_stage option:selected").val(), null, callback_move);
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		
		var stageVal = $("#p_move_stage").val();
		if(stageVal == undefined){
			stageVal = "";
		}
		
		
		//모든 행 읽음	
		/* var rows = jqGridObj.getDataIDs();
		
		for ( var i = 0; i < rows.length; i++ ) {
			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );

			if(item.move_info == $("#p_move_dwg_no").val() + $("#p_move_block").val() + stageVal + $("#p_move_str").val()+$("#p_move_job_cd").val()){
				alert("Move 정보가 동일하여 이동할 수 없습니다.");
				$("#p_move_job_cd").val("");
				$("#p_move_str").val("");
				return false;
			}
		} */
		
	}
	
	//TR일때 변경EA 자동입력
	var setChangeTray = function(rowId){
		jqGridObj.saveCell(kRow, idCol );
		var item = jqGridObj.jqGrid( 'getRowData', rowId );
		var catalog_code = item.item_catalog;
		var formData = fn_getFormData('#application_form');
		var count = 0;
		$.post("getCatalogTray.do?catalog_code=" + catalog_code, formData, function(data)
		{	
			if(data.cnt != "0"){
				count = item.temp07.split(",").length;
				jqGridObj.jqGrid( 'setCell', rowId, 'modify_bom_qty', count );	
			}
		},"json");
	}
	
	
</script>
</body>

</html>

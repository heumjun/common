<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>DIMS Pending Move Main</title>
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
	td {text-transform: uppercase;}
	.header .searchArea .buttonArea #btnForm{float:left;}
	.uniqCell{background-color:#F7FC96}
	
	.subButtonArea input{border:1px solid #888; background-color:#B2C3F2; margin-bottom:4px; width:66px; }
	.required_cell{background-color:#F7FC96}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			Pending Move
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_isPaging" value="" />
		<input type="hidden" name="p_master_no" value="${p_master_no}" />
		<input type="hidden" name="p_item_type_cd" value="${p_item_type_cd}" />		
		<input type="hidden" name="p_row_standard" value="" />
		<input type="hidden" name="p_work_key" value="" />
		<input type="hidden" name="p_work_flag" value="PD" />
		<input type="hidden" name="p_pending_id" value="${p_pending_id}" />
		<input type="hidden" value="1" id="stepState" name="p_stepstate"/>
		<input type="hidden" value="N" id="p_move_buy_buy_flag" name="p_move_buy_buy_flag"/>	
		<table class="searchArea conSearch">
			<col width="60"/>
			<col width="90"/>
			<col width="60"/>
			<col width="580"/>
			<col width="60"/>
			<col width="160"/>
			<col width="60"/>
			<col width="100"/>
			<col width="*"/>
			<tr>
				<th>Project</th>
				<td>
				<input type="text" name="p_project_no" class = "required"  style="width:50px;" value="${p_project_no}" readonly="readonly"/>
				</td>
				
				<th>Move</th>
				<td>
				Block 
				<select name="p_move_block" id="p_move_block" style="width:60px;" onchange="javascript:BlockOnChange(); MoveOnChange(this); JobOnChange();">
				</select>	
				STR 
				<select name="p_move_str" id="p_move_str" style="width:60px;" onchange="javascript:MoveOnChange(this); JobOnChange();">
				</select>
				TYPE
				<select name="p_move_usc_job_type" id="p_move_usc_job_type" style="width:60px;" onchange="javascript:TypeOnChange(this)">
				</select>
				<!-- Job
				<select name="p_move_job_cd" id="p_move_job_cd" style="width:120px;" onchange="javascript:JobOnChange();">
				</select> -->
				Stage
				<input type="text" name="p_move_stage" id="p_move_stage" style="width:60px;" />
				</td>
				<th>Dept.</th>
				<td>
				<input type="text" name="p_dept_name" class="commonInput readonlyInput" style="width:130px;" readonly="readonly" value="<c:out value="${p_dept_name}" />" />
				<input type="hidden" name="p_dept_code" class="commonInput readonlyInput" style="width:70px;" readonly="readonly" value="<c:out value="${p_dept_code}" />" />
				</td>
				<th>User</th>
				<td>
				<input type="text" name="p_user_name" class="commonInput readonlyInput" style="width:50px;" readonly="readonly" value="<c:out value="${loginUser.user_name}" />" />
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="Back" id="btnBack" style="display:none;"/>
						<input type="button" class="btn_blue2" value="Next" id="btnNext" />
						<input type="button" class="btn_blue2" value="Close" id="btnClose"/>
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
							
		<div class="content">
			<table id="jqGridModifyMainList"></table>
			<div id="bottomJqGridModifyMainList"></div>
		</div>
		<!-- loadingbox -->
		<jsp:include page="common/sscCommonLoadingBox.jsp" flush="false"></jsp:include>
	</div>
</form>

<script type="text/javascript" src="/js/getGridColModelPENDING.js" charset='utf-8'></script>
<script type="text/javascript" >
	var idRow = 0;
	var idCol = 0;
	var nRow = 0;
	var kRow = 0;
	var row_selected = 0;
	var usc_chag_flag = "";
	
	//필수 입력 값의 배경 색 지정
	var jqGridObj = $("#jqGridModifyMainList");
	
	$(document).ready(function(){	
		
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
		
		//Block 정보 받기
		getAjaxHtml($("#p_move_block"),"commonSelectBoxDataList.do?p_query=getBlockNoList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=sel", null);
		
		//DWG NO 정보 받기		
		getAjaxHtml($("#p_move_dwg_no"),"commonSelectBoxDataList.do?p_query=getDwgNoList&p_master_no="+$("input[name=p_master_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&sb_type=not"+"&p_dept_code="+$("input[name=p_dept_code]").val(), null);
		
		var vItemTypeCd = $("input[name=p_item_type_cd]").val();

		////js/getGridColModel.js에서 그리드의 colomn을 받아온다.
		var gridColModel = getModifyGridColModel();
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            postData : fn_getFormData('#application_form'),
            url:'pendingChekedMainList.do',
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
				
				// row 가 2개 이상일경우 move대상에서 usc_job_type 은 비활성화
				// 같은 usc_job_type 에 들어갈 수가 없음 (무조건 에러)-무결성 제약조건에 걸림
				if(rows.length > 1) {
					$("select[name=p_move_usc_job_type]").attr("disabled", "disabled");
				} else {
					$("select[name=p_move_usc_job_type]").removeAttr("disabled");
				}
				
				var err_style = { color : '#FFFFFF', background : 'red'};
				
				//필수 필드 배열 세팅
				var necessary_err_field = new Array('project_no','dwg_no','block_no','stage_no','str_flag','job_cd','mother_code','modify_job_cd','modify_item_code');
				
				//모든 행 loop
				for ( var i = 0; i < rows.length; i++ ) {
					
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
					
				}
				
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj , 30 );
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){ 
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

			jqGridObj.saveCell(kRow, idCol );
			
			var formData = fn_getFormData('#application_form');
			
			//Validation 체크 로직
			if($("input[name=p_stepstate]").val() == "1"){

				var rtn = true;
				if( $("#p_move_block option:selected").val() == " " || $("#p_move_block option:selected").val() == "" ){
					alert("MOVE BLOCK이 선택되지 않았습니다.");
					rtn = false;                                                             
					return false;	
				}
				
				if( $("#p_move_str option:selected").val() == " " || $("#p_move_str option:selected").val() == "" ){
					alert("MOVE STR이 선택되지 않았습니다.");
					rtn = false;                                                             
					return false;	
				}
				

				//모든 행 읽음
				var changeRows = [];
				
				//그리드의 내용을 받는다.
				getGridChangedData(jqGridObj,function(data) {
					changeRows = data;
					
					if(!rtn){
						return false;
					}
					
					//시리즈 배열 받음
					var ar_series = new Array();
					for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
						ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
					}
					
					var dataList = { chmResultList : JSON.stringify(changeRows) };
					var parameters = $.extend({}, dataList, formData);

					$(".loadingBoxArea").show();
					
					$("#p_selrev").attr("disabled", false);
					
					getJsonAjaxFrom("pendingModifyValidationCheck.do?p_chk_series="+ar_series, parameters, null, callback_next);
				});
				 
			}else if($("input[name=p_stepstate]").val() == "2"){
			
				//프로세스가 NO 이면 진행 불가
				if(!chkgridProcess()){
					return false;
				}
				
				//BOM에 반영	
				if(confirm('적용하시겠습니까?')){
				$(".loadingBoxArea").show();
					$.post("pendingModifyApplyAction.do", formData, function(data)
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
			if(confirm('뒤로 돌아가시겠습니까?')){	
				$( jqGridObj).jqGrid( "clearGridData" );
				$( jqGridObj ).jqGrid( 'setGridParam', {
					url : 'pendingChekedMainList.do',
					mtype : 'POST',
					datatype : 'json',
					page : 1,
					postData : fn_getFormData('#application_form'),
					cellEdit : true,
				} ).trigger( "reloadGrid" );
				callback_back();
			}
			
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
	
	var callback_next = function(json){
		
		$("#btnBack").show();
		$("#btnNext").attr("value", "Apply");
		
		$("input[name=p_work_key]").val(json.p_work_key);

		//그리드 초기화
		$( jqGridObj).jqGrid( "clearGridData" );
		$( jqGridObj ).jqGrid( 'setGridParam', {
			url : 'pendingWorkValidationList.do',
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
		$("#btnCopy").attr("disabled", "disabled");
		$(".loadingBoxArea").hide();
		
	}
	
	
	var callback_back = function(){
		
		var vAble = "";
		
		$(".loadingBoxArea").hide();
		$("#btnBack").hide();
		$("#stepState").val("1");
		$("input[name=p_selrev]").val("");
		
		$("input[name=p_series]").removeAttr("disabled");
		$("select[name=p_move_block]").removeAttr("disabled");
		$("input[name=p_move_stage]").removeAttr("disabled");
		$("select[name=p_move_str]").removeAttr("disabled");
		$("select[name=p_selrev]").removeAttr("disabled");
		$("select[name=p_move_job_cd]").removeAttr("disabled");
		$("select[name=p_move_dwg_no]").removeAttr("disabled");
		$("select[name=p_move_usc_job_type]").removeAttr("disabled");
		$('#btnCopy').removeAttr("disabled");
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_action=modify&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_able="+vAble, null);
		
		$("#btnNext").attr("value", "Next");
	}
	
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
        				$("input:checkbox[id='"+id+"']").prop("checked", true);
    				}
    			}
    		}	
		},"json");
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
	
	var JobOnChange = function(){
		//job 정보를 가져온 후에 실행되어야 하기때문에 0.5초 딜레이
		$("select[name=p_move_usc_job_type]").val($("select[name=p_move_job_cd]").find("option:selected").attr("name"));
		setTimeout("JobOnChangeTime()", 500);
	}
	
	//Job 정보 변경시 
	var JobOnChangeTime = function(){
		var stageVal = $("#p_move_stage").val();
		if(stageVal == undefined){
			stageVal = "";
		} else {
			stageVal = stageVal.toUpperCase();
		}
	}
	
	//Move 정보 변경시 
	var MoveOnChange = function(thisObj){
	
		jqGridObj.saveCell(kRow, idCol );
	
		//모든 행 읽음	
		var rows = jqGridObj.getDataIDs();
		var item;
		
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
		
		getAjaxHtml($("#p_move_usc_job_type"),"commonSelectBoxDataList.do?p_query=getPendingUscJobTypeList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=not&p_block_no="+$("#p_move_block option:selected").val()+"&p_str_flag="+$("#p_move_str option:selected").val() + "&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null);
		getAjaxHtml($("#p_move_job_cd"),"commonSelectBoxDataList.do?p_query=getPendingJobList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=not&p_block_no="+$("#p_move_block option:selected").val()+"&p_str_flag="+$("#p_move_str option:selected").val() + "&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null, callback_move);

	}
	
	//Move 정보 변경시 
	var TypeOnChange = function(thisObj){
		getAjaxHtml($("#p_move_job_cd"),"commonSelectBoxDataList.do?p_query=getPendingJobList&p_master_no="+$("input[name=p_master_no]").val()+"&sb_type=not&p_block_no="+$("#p_move_block option:selected").val()+"&p_str_flag="+$("#p_move_str option:selected").val() + "&p_usc_job_type="+$("#p_move_usc_job_type option:selected").val().trim() + "&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null, callback_move);
	}

	var callback_move = function(){
		JobValidation();
	}
	
	var JobValidation = function(){

		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			//$(this).val($(this).val().toUpperCase());
		});
		
		var stageVal = $("#p_move_stage").val();
		if(stageVal == undefined){
			stageVal = "";
		}
		
	}
	
</script>
</body>

</html>

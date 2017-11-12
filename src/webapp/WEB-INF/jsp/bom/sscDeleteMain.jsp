<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC Delete Main</title>
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
			SSC Delete -
			<jsp:include page="common/sscCommonTitle.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
		<input type="hidden" name="p_isPaging" value="" />
		<input type="hidden" name="p_master_no" value="${p_master_no}" />
		<input type="hidden" name="p_item_type_cd" value="${p_item_type_cd}" />		
		<input type="hidden" name="p_row_standard" value="" />
		<input type="hidden" name="p_work_key" value="" />
		<input type="hidden" name="p_work_flag" value="DELETE" />
		<input type="hidden" name="p_ssc_sub_id" value="${p_ssc_sub_id}" />
		<input type="hidden" value="1" id="stepState" name="p_stepstate"/>
		<table class="searchArea conSearch">
			<tr>
				<td class="sscType"  style="border-right:none;">
					PROJECT 
					<input type="text" name="p_project_no" class="required" style="width:50px;" value="${p_project_no}" readonly="readonly"/>
					&nbsp;
					DWG NO. 
					<input type="text" name="p_dwg_no" class="required" style="width:60px;" value="<c:out value="${p_dwg_no}" />" readonly="readonly"/>
					&nbsp;
					DEPT. 
					<input type="text" name="p_dept_name" class="commonInput readonlyInput" style="width:130px;" readonly="readonly" value="<c:out value="${p_dept_name}" />" />
					<input type="hidden" name="p_dept_code" class="commonInput readonlyInput" style="width:70px;" readonly="readonly" value="<c:out value="${p_dept_code}" />" />
					&nbsp;
					USER 
					<input type="text" name="p_user_name" class="commonInput readonlyInput" style="width:50px;" readonly="readonly" value="<c:out value="${loginUser.user_name}" />" />
					<span id="revArea"></span>
				</td>
				<td class="bdl_no"  style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_blue2" value="NEXT" id="btnNext"/>
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
			<col width="80"/>
			<col width="*"/>
			<tr>
				<th>
				</th>
				<td class="sscType" style="border-left:none;">
					<div class="button endbox">
						<input type="button" class="btn_red2" value="-" id="btnDel" style="width:28px; font-size:17px;"/>
					</div>
				</td>
			</tr>
		</table>
		<div class="content">
			<table id="jqGridDeleteMainList"></table>
			<div id="bottomJqGridDeleteMainList"></div>
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
	
	//필수 입력 값의 배경 색 지정
	var jqGridObj = $("#jqGridDeleteMainList");
	
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
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_able="+vAble, null, getDeliverySeriesCallback);
		
		//Rev 받기.
		//getAjaxHtml($("#revArea"),"sscCommonRevTextBox.do?p_master_no="+$("input[name=p_master_no]").val()+"&p_dwg_no="+$("input[name=p_dwg_no]").val()+"&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null);
		
		var vItemTypeCd = $("input[name=p_item_type_cd]").val();
		
		
		///js/getGridColModel.js에서 그리드의 colomn을 받아온다.
		var gridColModel = getDeleteGridColModel();
		
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
            cellEdit : false,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit : false,
            height: 560,
            pager: '#bottomJqGridDeleteMainList',
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
			},		
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
				jqGridObj.saveCell(kRow, idCol );
				row_selected = rowid;
				var item = jqGridObj.jqGrid( 'getRowData', rowid );
				var rows = $(this).getDataIDs();
				for(var i=0; i<rows.length; i++){
					var tempItem = jqGridObj.jqGrid( 'getRowData', rows[i] );
					if(item.project_no == tempItem.project_no && item.mother_code == tempItem.mother_code && item.item_code == tempItem.item_code){
						$(this).jqGrid('setSelection', rows[i]); 
					}
				}
				$(this).jqGrid('setSelection', rowid); 
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 55 );

    	//초기 job 셋팅
    	//getJobCode('','','');
    	
		//Close 버튼 클릭
		$("#btnClose").click(function(){ 
			history.go(-1);
		});
		
		
		//Delete 버튼  클릭
		$("#btnDel").click(function(){
			var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
			if(row_id == ""){
				alert("행을 선택하십시오.");
				return;
			}
			
			//삭제하면 row_id가 삭제된 것에는 없어지기 때문에
			//처음 length는 따로 보관해서 돌리고 row_id의 [0]번째를 계속 삭제한다.
			var row_len = row_id.length;					
			
			for(var i=0; i<row_len; i++){
				jqGridObj.jqGrid('delRowData',row_id[0]);
			}
			
		});
		
		//Next 클릭
		$("#btnNext").click(function(){

			jqGridObj.saveCell(kRow, idCol );
			
			//모두 대문자로 변환
			$("input[type=text]").each(function(){
				$(this).val($(this).val().toUpperCase());
			});
			
			var formData = fn_getFormData('#application_form');
			
			//Validation 체크 로직
			if($("input[name=p_stepstate]").val() == "1"){
				
				var rtn = true;
			
				if(!rtn){
					return false;
				}
				var changeRows = [];
				
				//그리드의 내용을 받는다.
				getGridChangedData(jqGridObj,function(data) {
					changeRows = data;
					
					if (changeRows.length == 0) {
						alert("내용이 없습니다.");
						return;
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
					
					getJsonAjaxFrom("sscDeleteValidationCheck.do?p_chk_series="+ar_series, parameters, null, callback_next);
				});
				 
			}else if($("input[name=p_stepstate]").val() == "2"){
			
				//프로세스가 NO 이면 진행 불가
				if(!chkgridProcess()){
					return false;
				}
				
				//BOM에 반영	
				if(confirm('적용하시겠습니까?')){
				$(".loadingBoxArea").show();
					$.post("sscDeleteApplyAction.do", formData, function(data)
					{	
						$(".loadingBoxArea").hide();
						alert(data.resultMsg);
						$("#btnClose").click();
					},"json");
				}
			}
		
		});	
		
		
		$("#btnConfirm").click(function(){
			if(confirm('변경 없이 조치하시겠습니까?')){	//저장 확인
			form = $('#application_form');
				//필수 파라미터 S	
				$("input[name=p_daoName]").val("TBC_CONFIRMDAO");
				$("input[name=p_queryType]").val("update");
				$("input[name=p_process]").val("ConfirmAction");
				//필수 파라미터 E	
	
				$.post("/ematrix/tbcItemConfirmAction.tbc",form.serialize(),function(json)
				{	
					afterDBTran(json);
					$("#btnClose").click();						
				},"json");
			}
		});
		
		$("#btnCopy").click(function(){
			$("input[name=p_modifyDetail]").each(function(){
				if($(this).css("display") != "none"){
					$(this).val($(this).parent().parent().find("input[name=p_detail]").val());
				}
			});
			$("input[name=p_modifyEA]").each(function(){
				if($(this).css("display") != "none"){
					$(this).val($(this).parent().parent().find("input[name=p_ea]").val());
				}
			});
			
			$("input[name=p_modifyKey]").each(function(){
				if($(this).css("display") != "none"){
					$(this).val($(this).parent().parent().find("input[name=p_key]").val());
				}
			});
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
    
	var callback_next = function(json){
		
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
		$("#btnCopy").attr("disabled", "disabled");
		$("#btnConfirm").attr("disabled", "disabled");
		$("#btnDel").attr("disabled", "disabled");
		$(".loadingBoxArea").hide();
		
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
	
</script>
</body>

</html>

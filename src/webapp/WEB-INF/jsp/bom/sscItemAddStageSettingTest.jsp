<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>SSC StageSetting</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	td {
		text-transform: uppercase;
		text-align: center;
	}
	.buttonArea {
		position:relative; 
		float:right; 
		width:180px; 
	}
</style>
</head>
<body>
<form id="application_form2" name="application_form2" method="post">
	<div class="mainDiv" id="mainDiv">
		<div class="subtitle">
			<input type="hidden" name="p_project_no" value="<c:out value="${p_project_no}" />" />
			<input type="hidden" name="p_dwg_no" value="<c:out value="${p_dwg_no}" />"/>
			<input type="hidden" name="p_item_type_cd" value="<c:out value="${p_item_type_cd}"/>" />		
	
			<div class="buttonArea">
				<input type="button" class="btn_blue" value="Apply" id="btnApply" />
				<input type="button" class="btn_blue" value="Close" id="btnClose" />
			</div>
		</div>	
	
		<!-- loadingbox -->
		<%-- <jsp:include page="./tbc_CommonLoadingBox.jsp" flush="false"></jsp:include> --%>
		
		<!-- Content 영역 Start -->
		<div class="content">
			
			<table id="jqGridMainList"></table>
			<div id="bottomJqGridMainList"></div>
		</div>
		<!-- Content 영역 End -->
	</div>
</form>
<script type="text/javascript" >
	//그리드 사용 전역 변수
	var idRow;
	var idCol;
	var kRow;
	var kCol;
	var row_selected = 0;
	
	var jqGridObj = $("#jqGridMainList");
	var addRowId = $.jgrid.randId();
	
	var ar_series = new Array();
    <c:forEach var="item" items="${p_series}" varStatus="count" begin="0">
    
    	ar_series.push("${item}");
    	
    	jqGridObj.saveCell(kRow, idCol );
    
    	var item = {};
    	
    	var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
		
		for ( var i in colModel )
			item[colModel[i].name] = '';
    	
    	item.project_no = "${item}";
		item.dwg_no = "${p_dwg_no}";
		item.block_no = "";
		item.stage_no = "";
		item.str_flag = "";
		item.job_cd = "";
		item.job_state = "";
		jqGridObj.jqGrid('setRowData', addRowId, item);
	</c:forEach>
	
	for(idx=0; idx<ar_series.length; idx++){
		jqGridObj.saveCell(kRow, idCol );
	    
    	var item = {};
    	
    	var colModel = jqGridObj.jqGrid( 'getGridParam', 'colModel' );
		
		for ( var i in colModel )
			item[colModel[i].name] = '';
    	
    	item.project_no = ar_series[i];
		item.dwg_no = "${p_dwg_no}";
		item.block_no = "";
		item.stage_no = "";
		item.str_flag = "";
		item.job_cd = "";
		item.job_state = "";
		jqGridObj.jqGrid('setRowData', idx+1, item);
	}
	
	$(document).ready(function(){
		
		jqGridObj.jqGrid({ 
            datatype: 'json',
            url:'',
            mtype : '',
            postData : fn_getFormData('#application_form'),
            colNames : [ 'Project','DWG No.', 'Block', 'Stage', 'STR', 'Job', 'JOB State'],
			colModel : [ { name : 'project_no', index : 'project_no', width : 110, align: "center"},
			             { name : 'dwg_no', index : 'dwg_no', width : 80, align : "left", hidden : false }, 
			             { name : 'block_no', index : 'block_no', width : 100, align : "left", hidden : false },
			             { name : 'stage_no', index : 'stage_no', width: 100, align : "center" , editable : true},
			             { name : 'str_flag', index : 'str_flag', width : 40, align : "center" , hidden : false },
			             { name : 'job_cd', index : 'job_cd', width : 100, align : "center" , hidden : false},
			             { name : 'job_state', index : 'job_state', width : 80, align : "center" }
			],
            gridview: true,
            viewrecords: true,
            autowidth: true,
            cellEdit : true,
            cellsubmit : 'clientArray', // grid edit mode 2
			scrollOffset : 17,
            multiselect: true,
            shrinkToFit: false,
            height: 460,
            rownumbers: false,
            //pager: '#bottomJqGridMainList',
            rowList: [100,500,1000],
            rowNum: 100, 
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
			 onSelectAll: function(aRowids,status) {     
				
			 },
			 onSelectRow: function(aRowids,status) {     
				  	
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
				        lastpageServer: data.total,
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
			gridComplete : function() {
			},
			onCellSelect : function( rowid, iCol, cellcontent, e ) {
			}
    	}); //end of jqGrid
    	//grid resize
	    fn_gridresize( $(window), jqGridObj, 200 );
		
		//Close 버튼 클릭
		$("#btnClose").click(function(){
			self.close();
		});	
		
		$("select[name=p_spBlock]").each(function(){
			var trKey = $(this).attr("id").split(",");
			//getAjaxHtml($(this),"/ematrix/tbcCommonSelectBoxDataList.tbc?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveBlockInfo&p_project="+trKey[0]+"&p_dwgno="+trKey[1], null);
			getAjaxHtml($(this),"commonSelectBoxDataList.do?p_query=getStageBlockNoList&p_master_no="+trKey[0]+"&p_dwgno="+trKey[1]+"&sb_type=sel", null);
		});
		
		//APPLY 버튼 클릭
		$("#btnApply").click(function(){
			
			var rtn = true;
			var args = window.dialogArguments;
			var item_type_cd = $("input[name=p_item_type_cd]").val();
			
			//필수 파라미터 S	
			$("input[name=p_daoName]").val("TBC_"+item_type_cd+"_ITEMADD");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("AddStageSSCInsert");
			
			/* $("#stageTbl").find("tr").each(function(i, item){ 
				alert(i);
			}); */
			
			
			//필수 파라미터 E
			/* var formData = args.$('#application_form').serialize();
			var changeRows = [];
			var rtn = true;
			getGridChangedData(args.jqGridObj,function(data) {
				changeRows = data;
				//시리즈 배열 받음
				var ar_series = new Array();
				for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
					ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var parameters = $.extend({}, dataList, formData);

				$(".loadingBoxArea").show();
				$("input[name=p_isPaging]").val("Y");
			
				getJsonAjaxFrom("sscAddValidationCheck.do?p_chk_series="+ar_series,parameters,null, args.callback_next);
			}); */
			
			//var jsonForm = $('#application_form2').serialize() + "&" + args.$('#application_form').serialize();
			
			var rows = $("table.searchArea tr ");
			$(rows).each(function (idx) {
				var startIdx = 1;
                var endIdx = rows[idx].childNodes.length;

               for (i = startIdx; i <= endIdx; i++) {
            	   alert($(rows[idx]).find('td').eq(i).text());
               }
			});
			var returnValue = new Array();
			
			
			
			for(var i=0; i<$(".tdJobState").length; i++){
				alert( $("select[name=p_spBlock].eq(i)").val() );
			}
			
			//window.returnValue = returnValue;
			
			self.close();
			//$.extend(true,$('#application_form2'),args.$('#application_form').serialize()); //jsonForm1에 jsonForm2를 합친다.
			
			//$(".loadingBoxArea").show();
			
			//getAjaxHtmlPost(args.$("#InputArea"),"/ematrix/tbcItemAddStageMainCheck.tbc", jsonForm, null, null, apply_callback);
		
		});
	});
	
	
	//폼데이터를 Json Arry로 직렬화
	function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	
	var apply_callback = function(){
		$(".loadingBoxArea").hide();		
		var args = window.dialogArguments;
		args.callback_next();		
		$("#btnClose").click();
	}
	
	var changeBlock = function(objBlock){
		//var objStage = $(objBlock).parent().parent().find("select[name=p_spStage]");
		var objStr = $(objBlock).parent().parent().find("select[name=p_spStr]");
		var trKey = $(objBlock).attr("id").split(",");
		
    	//Stage 정보 받기
   		//getAjaxHtml(objStage,"/ematrix/tbcCommonSelectBoxDataList.tbc?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveStageInfo&p_project="+trKey[0]+"&p_dwgno="+trKey[1]+"&p_block="+$(objBlock).val(), null);

		//str 정보 받기
		//getAjaxHtml(objStr,"/ematrix/tbcCommonSelectBoxDataList.tbc?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveStrInfo&p_project="+trKey[0]+"&p_dwgno="+trKey[1]+"&p_block="+$(objBlock).val(), null);
		getAjaxHtml(objStr,"commonSelectBoxDataList.do?p_query=getStageStrFlagList&p_project_no="+trKey[0]+"&sb_type=sel"+"&p_block_no="+$(objBlock).val(), null);
		
		
	};
	
	var changeStage = function(objStage){
		var objBlock = $(objStage).parent().parent().find("select[name=p_spBlock]");	
		var objStr = $(objStage).parent().parent().find("select[name=p_spStr]");
		var trKey = $(objStage).attr("id").split(",");
		
		//str 정보 받기
		getAjaxHtml(objStr,"commonSelectBoxDataList.do?p_query=getStageStrFlagList&p_project_no="+trKey[0]+"&p_dwg_no="+trKey[1]+"&p_block_no="+$(objBlock).val()+"&p_stage_no="+$(objStage).val(), null);
		
	};
	
	//Header 체크박스 클릭시 전체 체크.
	var chkAllClick = function(){
		if(($("input[name=chkAll]").is(":checked"))){
			$(".chkboxItem").prop("checked", true);
		}else{
			$(".chkboxItem").prop("checked", false);
		}
		chkItemClickEaAction();
	}
	
	//Body 체크박스 클릭시 Header 체크박스 해제
	var chkItemClick = function(){	
		$("input[name=chkAll]").prop("checked", false);
		chkItemClickEaAction();
	}
	//Total EA 출력
	var chkItemClickEaAction = function(){
		var totalEa = 0;
		$("input[name=p_chkItem]:checked").each(function(){
			totalEa += Number($(this).parent().parent().find(".td_ea").text());
		});
		$("#totalEa").val(totalEa);
	}
	
	//메시지 Call
	var afterDBTran = function(json)
	{
	 	var msg = "";
		for(var keys in json)
		{
			for(var key in json[keys])
			{
				if(key=='Result_Msg')
				{
					msg=json[keys][key];
				}
			}
		}
		alert(msg);
		
	}
	
	//Header 체크 유무 validation
	var isItemChecked = function(){
		if($(".chkboxItem:checked").length == 0){
			alert("Please check item");
			return false;
		}else{
			return true;
		}
	}
	
	var getJobStatus = function(obj){
		
		$("#btnApply").attr('disabled',false);
		
		var trKey = $(obj).parent().parent().find("select[name=p_spBlock]").attr("id").split(",");
		var trID = $(obj).parent().parent().attr("id");

		getAjaxHtml(null,"sscItemAddStageGetMother.do?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getJobStatus&p_project_no="+trKey[0]+"&p_job_cd="+$(obj).val()+"&p_id="+trID, null, getJobStatusCallback);	
	}
	
	var getJobStatusCallback = function(json){	
	
		var jsonTxt = json.replace("[","").replace("]","").replace("\r\n","");
		
		if(jsonTxt != ""){
			var obj = JSON.parse(jsonTxt);

			var job_state = obj.job_state;
			
			if(job_state=="" || job_state == "undefined" || job_state == null) {
				if($("#"+obj.p_id).find("select[name=p_job_cd]").val() != ""){
					job_state = "";
				}
				$("#"+obj.p_id).find(".tdJobState").css("background-color", "#FFFFFF");
			} else if(job_state=="릴리즈 안됨"){
				if($("#"+obj.p_id).find("select[name=p_job_cd]").val() != ""){
					job_state = "릴리즈 안됨";
				}
				$("#"+obj.p_id).find(".tdJobState").css("background-color", "#FFFFFF");
			} else if(job_state=="릴리즈됨"){
				if($("#"+obj.p_id).find("select[name=p_job_cd]").val() != ""){
					job_state = "릴리즈 됨";
				}
				$("#"+obj.p_id).find(".tdJobState").css("background-color", "#FFFFFF");
			} else {
				if(job_state == '완료'){
					$("#"+obj.p_id).find(".tdJobState").css("background-color", "red");		
				} else{
					$("#"+obj.p_id).find(".tdJobState").css("background-color", "#FFD65C");				
				}
			}			
  			$("#"+obj.p_id).find(".tdJobState").text(job_state);
		}
		
		//JOB STATE가 "완료" 일때 APPLY 버튼 비활성
		$("#btnApply").attr('disabled',false);
		for(var i=0; i<$(".tdJobState").length; i++){
			if( $(".tdJobState")[i].textContent == "완료" ){
				$("#btnApply").attr('disabled',true);
				break;
			}
		}
	}
	
	
	
	var inputBlockKeyIn = function(obj, type){
		
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		$("input[type=hidden]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		var trKey = $(obj).parent().parent().find("select[name=p_spBlock]").attr("id").split(",");
		var vSelObj = "";
		var vBlockNo = "";
		var vStrFlag = "";
		
		if(type == "block"){
			vBlockNo = $(obj).val();
			vStrFlag = $(obj).parent().parent().find("select[name=p_spStr]").val();
			vSelObj = $(obj).parent().parent().find("select[name=p_job_cd]");
		}else if(type == "str"){
			vBlockNo = $(obj).parent().parent().find("select[name=p_spBlock]").val();
			vSelObj = $(obj).parent().parent().find("select[name=p_job_cd]");
			vStrFlag = $(obj).val(); 
		}else{
			vSelObj = $(obj);
			vBlockNo = $(obj).parent().parent().find("select[name=p_spBlock]").val();
			vStrFlag = $(obj).parent().parent().find("select[name=p_spStr]").val();
		}
		getAjaxHtml(vSelObj,"commonSelectBoxDataList.do?p_query=getStageJobList&p_master_no="+trKey[0]+"&sb_type=not&p_block_no="+vBlockNo+"&p_str_flag="+vStrFlag + "&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null, callback_job);
		//getAjaxHtml(vSelObj,"commonSelectBoxDataList.do?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveJobInfo&p_project="+$("input[name=p_master]").val()+"&p_dwgno="+$("input[name=p_dwgno]").val()+"&p_block="+vBlockNo+"&p_str="+vStrFlag+"&sb_type=sel&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null, callback_job );		

	}
	
	var callback_job = function(inHtml, target){
		//var vSelObj = $(obj).parent().parent().find("select[name=p_job_cd]");
		if($(target).find("option").length == 2){
			$(target).find("option").eq(1).attr("selected","selected");
		}
		
		getJobStatus(target);
	}
	
	
	
</script>
</body>

</html>
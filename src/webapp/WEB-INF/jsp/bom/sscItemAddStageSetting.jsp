<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>StageSetting</title>
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
	
	input[type=text] {text-transform: uppercase;}
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
				<input type="button" class="btn_blue2" value="Apply" id="btnApply" />
				<input type="button" class="btn_blue2" value="Close" id="btnClose" />
			</div>
		</div>	
	
	<!-- loadingbox -->
	<%-- <jsp:include page="./tbc_CommonLoadingBox.jsp" flush="false"></jsp:include> --%>
	
	<!-- Content 영역 Start -->
		<table class="searchArea conSearch">
		<colgroup>
			<col width="70"/>
			<col width="90"/>
			<col width="70"/>
			<col width="70"/>
			<col width="70"/>
			<col width="120"/>
			<col width="70"/>
			<col width="90"/>				
		</colgroup>				
		<thead>
			<tr>
				<th>PROJECT</th>
				<th>DWG NO.</th>
				<th>BLOCK</th>
				<th>STR</th>
				<th>TYPE</th>
				<th>JOB</th>
				<th>STAGE</th>
				<th>JOB STATE</th>					
			</tr>
		</thead>
		</table>
		<table class="searchArea">
			<colgroup>
				<col width="70"/>
				<col width="90"/>
				<col width="70"/>
				<col width="70"/>
				<col width="70"/>
				<col width="120"/>
				<col width="70"/>
				<col width="90"/>				
			</colgroup>
			<tbody id="stageTbl">
				<c:forEach var="item" items="${p_series}" varStatus="count">	
					<tr id="tr_<c:out value="${item}" />">
						<td id="<c:out value="${count.index}" />">
							
							<c:out value="${item}" />
							<input type="hidden" name="p_stageProjectNo" value="<c:out value="${item}" />" /> 
							<input type="hidden" name="p_stageMotherCode" value="" />
						</td>
						<td><c:out value="${p_dwg_no}" /></td>
						<td>
							<input type="text" name="p_spBlock" id="<c:out value="${item}" />,<c:out value="${p_dwg_no}" />" style="text-transform: uppercase; width:95%;" onchange="changeBlock(this); inputBlockKeyIn(this, 'block');">
						</td>
						<td>
							<select name="p_spStr" id="p_spStr" style="width:50px;" onchange="changeStr(this); inputBlockKeyIn(this, 'str'); ">
							</select>
						</td>
						<td>
							 <select name="p_spAttr" id="p_spAttr" style="width:50px;" onchange="javascript:getJobStatus(this); inputBlockKeyIn(this, 'attr');">
							</select>
							 <%-- <input type="text" name="p_spAttr" style="width:45px;" class="userInput" id="<c:out value="${item}" />,<c:out value="${p_dwg_no}" />"/> --%>
						</td>
 						<td class="tdJobCode" title="Block과 STR을 입력하십시오.">
 							<select name="p_job_cd" style="width: 110px;" disabled="disabled" onchange="javascript:getJobStatus(this);"></select>
 						</td>
						<td>
							<!-- 
								<select name="p_spStage" id="<c:out value="${item}" />,<c:out value="${param.p_dwgno}" />" style="width:60px;" onchange="changeStage(this); getMotherCode(this);">
								</select>
							 -->
							 <input type="text" name="p_spStage" style="width:45px;" class="userInput" id="<c:out value="${item}" />,<c:out value="${p_dwg_no}" />"/>
						</td>
<!--						<td class="tdMotherCode"></td>-->
						<td class="tdJobState"></td>
					</tr>
				</c:forEach>	
							
			</tbody>
		</table>
	<!-- Content 영역 End -->
</div>
</form>
<script type="text/javascript" >
	
	//---------------------------------------
	$(document).ready(function(){
		//Close 버튼 클릭
		$("#btnClose").click(function(){
			self.close();
		});	
		
		/* $("input[name=p_spBlock]").each(function(){
			var trKey = $(this).attr("id").split(",");
			//getAjaxHtml($(this),"/ematrix/tbcCommonSelectBoxDataList.tbc?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveBlockInfo&p_project="+trKey[0]+"&p_dwgno="+trKey[1], null);
			getAjaxHtml($(this),"commonSelectBoxDataList.do?p_query=getStageBlockNoList&p_master_no="+trKey[0]+"&p_dwgno="+trKey[1]+"&sb_type=sel", null);
		}); */
		
		//APPLY 버튼 클릭
		$("#btnApply").click(function(){
			
			var rtn = true;
			var args = window.dialogArguments;
			var item_type_cd = $("input[name=p_item_type_cd]").val();
			
			//필수 파라미터 S	
			$("input[name=p_daoName]").val("TBC_"+item_type_cd+"_ITEMADD");
			$("input[name=p_queryType]").val("select");
			$("input[name=p_process]").val("AddStageSSCInsert");
			
			var returnValue = new Array();
			
			var tdAry = $("#stageTbl");
			<c:forEach var="item" items="${p_series}" varStatus="count">
				var item = {};
				var idx = "${count.index}";
				item["project_no"] = "${item}";
				item["dwg_no"] = "${p_dwg_no}";
				item["block_no"] = tdAry.find("tr:eq(${count.index})").find("input[name=p_spBlock]").val();
				item["stage_no"] = tdAry.find("tr:eq(${count.index})").find("input[name=p_spStage]").val();
				item["str_flag"] = tdAry.find("tr:eq(${count.index})").find("select[name=p_spStr]").val();
				item["usc_job_type"] = tdAry.find("tr:eq(${count.index})").find("select[name=p_spAttr]").val();
				item["job_cd"] = tdAry.find("tr:eq(${count.index})").find("select[name=p_job_cd]").val();
				//item["job_state"] = tdAry.find("select[name=p_spBlock]").val();
				returnValue.push(item);
			</c:forEach>
			window.returnValue = returnValue;
			
			args.$("#NextCheck").val('Next');
			
			self.close();
		
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
		getAjaxHtml(objStr,"commonSelectBoxDataList.do?p_query=getStageStrFlagList&p_project_no="+trKey[0]+"&sb_type=sel"+"&p_block_no="+$(objBlock).val().toUpperCase(), null);
		
		
	};
	
	var changeStr = function(objStr){
		//var objStage = $(objBlock).parent().parent().find("select[name=p_spStage]");
		var objBlock = $(objStr).parent().parent().find("input[name=p_spBlock]");
		var trKey = $(objStr).parent().parent().find("input[name=p_spBlock]").attr("id").split(",");
		var objAttr = $(objStr).parent().parent().find("select[name=p_spAttr]");
    	//Stage 정보 받기
   		//getAjaxHtml(objStage,"/ematrix/tbcCommonSelectBoxDataList.tbc?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveStageInfo&p_project="+trKey[0]+"&p_dwgno="+trKey[1]+"&p_block="+$(objBlock).val(), null);

		//str 정보 받기
		//getAjaxHtml(objStr,"/ematrix/tbcCommonSelectBoxDataList.tbc?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getMoveStrInfo&p_project="+trKey[0]+"&p_dwgno="+trKey[1]+"&p_block="+$(objBlock).val(), null);
		//getAjaxHtml(objStr,"commonSelectBoxDataList.do?p_query=getStageStrFlagList&p_project_no="+trKey[0]+"&sb_type=sel"+"&p_block_no="+$(objBlock).val(), null);
		getAjaxHtml($(objAttr),"commonSelectBoxDataList.do?p_query=getStageUscJobTypeList&sb_type=not&p_master_no=" + trKey[0]
				+ "&p_block_no=" + $(objBlock).val()
				+ "&p_str_flag=" + $(objStr).val()
				+ "&p_item_type_cd=" + $("input[name=p_item_type_cd]").val(), null);
	};
	
	var changeStage = function(objStage){
		var objBlock = $(objStage).parent().parent().find("input[name=p_spBlock]");	
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
		
		var trKey = $(obj).parent().parent().find("input[name=p_spBlock]").attr("id").split(",");
		var trID = $(obj).parent().parent().attr("id");
		
		//$(obj).parent().parent().find("select[name=p_spAttr]").val($(obj).find("option:selected").attr("name"));
		
		getAjaxHtml(null,"sscItemAddStageGetMother.do?p_daoName=TBC_COMMONDAO&p_queryType=select&p_process=getJobStatus&p_project_no="+trKey[0]+"&p_job_cd="+$(obj).val()+"&p_id="+trID, null, getJobStatusCallback);	
	}
	
	var getJobStatusCallback = function(json){	
		
		var jsonTxt = json.replace("[","").replace("]","").replace("\r\n","");
		
		if(jsonTxt != ""){
			var obj = JSON.parse(jsonTxt);

			var job_state = obj.job_state;
			
			if(job_state=="" || job_state == "undefined" || job_state == null) {
				if($("#"+obj.p_id).find("select[name=p_job_cd]").val() != ""){
					job_state = "OPEN";
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
		
		var trKey = $(obj).parent().parent().find("input[name=p_spBlock]").attr("id").split(",");
		var vSelObj = "";
		var vBlockNo = "";
		var vStrFlag = "";
		var vAttr = "";
		
		if(type == "block"){
			vBlockNo = $(obj).val();
			vStrFlag = $(obj).parent().parent().find("select[name=p_spStr]").val();
			vAttr	 = $(obj).parent().parent().find("select[name=p_spAttr]").val();
			vSelObj = $(obj).parent().parent().find("select[name=p_job_cd]");
		}else if(type == "str"){
			vBlockNo = $(obj).parent().parent().find("input[name=p_spBlock]").val();
			vStrFlag = $(obj).val(); 
			vAttr	 = $(obj).parent().parent().find("select[name=p_spAttr]").val();
			vSelObj = $(obj).parent().parent().find("select[name=p_job_cd]");
		}else if(type == "attr"){
			vBlockNo = $(obj).parent().parent().find("input[name=p_spBlock]").val();
			vStrFlag = $(obj).parent().parent().find("select[name=p_spStr]").val();
			vAttr	 = $(obj).val();
			vSelObj = $(obj).parent().parent().find("select[name=p_job_cd]");
		}else{
			vSelObj = $(obj);
			vBlockNo = $(obj).parent().parent().find("input[name=p_spBlock]").val();
			vStrFlag = $(obj).parent().parent().find("select[name=p_spStr]").val();
			vAttr	 = $(obj).parent().parent().find("select[name=p_spAttr]").val();
		}
		
		if(vAttr == null) {
			vAttr = '';
		}
		
		getAjaxHtml(vSelObj,"commonSelectBoxDataList.do?p_query=getStageJobList&p_master_no="+trKey[0]
		+"&sb_type=not&p_block_no="+vBlockNo+"&p_str_flag="+vStrFlag + "&p_usc_job_type=" + vAttr
		+ "&p_item_type_cd="+$("input[name=p_item_type_cd]").val(), null, callback_job);
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ page import = "com.stx.common.util.StringUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.disablefield{border:1px solid #ccc;}
		</style>
	</head>

	<title>
		EMS(Equipment Management System) Purchasing Add
	</title>

	<body oncontextmenu="return false">
		<form id="application_form" name="application_form" >
		
			<input type="hidden" name="pageYn" id="pageYn" value="N">
			<input type="hidden" name="loginId" id="loginId" value="${loginId}"/>
			<input type="hidden" name="p_daoName"   id="p_daoName" value=/>
			<input type="hidden" name="p_queryType" id="p_queryType"  value=""/>
			<input type="hidden" name="p_process"   id="p_process" value=""/>
			<input type="hidden" name="p_filename"  id="p_filename" value=""/>
			<input type="hidden" name="p_approver"  id="p_approver" value=""/>
			<input type="hidden" name="p_flag"  id="p_flag" value="${requestbox.p_flag}"/>
			<input type="hidden" name="p_pr_state"  id="p_pr_state" value=""/>
			<input type="hidden" name="p_master"  id="p_master" value="${p_master}"/>
			<input type="hidden" name="p_project"  id="p_project" value="${p_project}"/>
			<input type="hidden" name="p_dwg_no"  id="p_dwg_no" value="${p_dwg_no}"/>
			<input type="hidden" name="list_type"   id="list_type" />
			<input type="hidden" name="list_type_desc"   id="list_type_desc" />
<%-- 			<input type="hidden" name="p_Ems_pur_no"   id="p_Ems_pur_no" value="${requestbox.p_Ems_pur_no}"/> --%>

			<table>
				<colgroup>
					<col width="70px"/>
					<col width="190px"/>
				</colgroup>				
				<tr style="height:40px">
					<td colspan="2">			
						<div class="button endbox">						
							<input type="button" class="btn_blue" value="REQUEST" id="btnApply"/>
							<input type="button" class="btn_blue" value="COLSE" id="btnClose"/>						
						</div>
					</td>
				</tr>
				<tr>
					<td style="border:0; height:25px;"><input type="text" class="disablefield" id="" name="" value="팀장" style="width:80px;text-align:center;font-weight:bold;" readonly="readonly" /></td>
					<td style="border:1px solid; height:25px;">
						<fieldset id="teamLeader" style="border:none;width: 130px; display: inline;  height:20px; line-height:10px; padding-left:4px; padding-top: 3px;" ></fieldset>
					</td>
				</tr>
				<tr>
					<td style="border:0; height:25px;"><input type="text" class="disablefield" id="" name="" value="파트장" style="width:80px;text-align:center;font-weight:bold;" readonly="readonly" /></td>
					<td style="border:1px solid; height:25px;">
						<fieldset id="partLeader" style="border:none;width: 130px; display: inline;  height:20px; line-height:10px; padding-left:4px; padding-top: 3px;" ></fieldset>
					</td>
				</tr>
			</table>			
		</form>
				
		<script type="text/javascript" >

			$(document).ready(function(){						

				//팀장 승인요청 항목
				$.post( "popUpPurchasingRequestListTeamLeader.do?loginId=" + $("#p_loginId").val(), "", function( data ) {
					for(var i =0; i < data.length; i++){
						 $("#teamLeader").append("<input type='radio' name='depts' id='depts_" + data[i].emp_no + "' value='"+data[i].emp_no+"' checked>"+data[i].user_name);
						 
					}
					
				}, "json" );
				
				//파트장 승인요청 항목
				$.post( "popUpPurchasingRequestListPartLeader.do?loginId=" + $("#p_loginId").val(), "", function( data ) {
					for(var i =0; i < data.length; i++){
						 $("#partLeader").append("<input type='radio' name='depts' id='depts_" + data[i].emp_no + "' value='"+data[i].emp_no+"'>"+data[i].user_name);
						 
					}
					
				}, "json" );
				
			});
			
			//######## Apply 버튼 클릭 시 ########//
			$("#btnApply").click(function(){
				var approver = $(':radio[name="depts"]:checked').val();

				if(confirm("PR 요청하시겠습니까?")) {
					$("input[name=p_approver]").val(approver);
					$("input[name=p_flag]").val("R");
					$("input[name=p_pr_state]").val("R");

					var sUrl="/popUpPurchasingRequestApply.do";
	
					var loadingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
					$.post(sUrl,$("#application_form").serialize(),function(json)
					{
						alert(json.resultMsg);
						loadingBox.remove();
						window.opener.search();
						window.close();
					},"json");
				}
			});
			
			//########  닫기버튼 ########//
			$("#btnClose").click(function(){
				window.close();					
			});	
			
			//######## Input text 부분 숫자만 입력 ########//
			function onlyNumber(event) {
			    var key = window.event ? event.keyCode : event.which;    
			
			    if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
			    || key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
			    || key  == 8  || key  == 46 ) // del, back space
			    ) {
			        return true;
			    }else {
			        return false;
			    }    
			};
			
			//폼데이터를 Json Arry로 직렬화
			function getFormData(form) {
			    var unindexed_array = $(form).serializeArray();
			    var indexed_array = {};
				
			    $.map(unindexed_array, function(n, i){
			        indexed_array[n['name']] = n['value'];
			    });
				
			    return indexed_array;
			}
			
			//STATE 값에 따라서 checkbox 생성
			function formatOpt1(cellvalue, options, rowObject){
					
				var rowid = options.rowId;
				
				var item = $('#itemTransList').jqGrid('getRowData',rowid);
		   		var str ="<input type='checkbox' name='checkbox' id='"+rowid+"_chkBoxOV' class='chkboxItem' value="+Math.round(cellvalue)+" />";
		  	             
		   	 	return str;
		 	 
			}
			
			//header checkbox action 
			function checkBoxHeader(e) {
		  		e = e||event;/* get IE event ( not passed ) */
		  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
				if(($("#chkHeader").is(":checked"))){
					$(".chkboxItem").prop("checked", true);
				}else{
					$("input.chkboxItem").prop("checked", false);
				}
			}
			
			//all checkbox action 
			function checkBoxAll(e) {
		  		e = e||event;/* get IE event ( not passed ) */
		  		e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; //이벤트 지우기
				if(($("#pjtAll").is(":checked"))){
					$(".pjtchkboxItem").prop("checked", true);
				}else{
					$("input.pjtchkboxItem").prop("checked", false);
				}
			}				

		</script>
	</body>
</html>
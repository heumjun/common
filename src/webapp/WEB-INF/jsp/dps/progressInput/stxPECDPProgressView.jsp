<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.*" %>
<%@ page import="stxship.dis.common.util.DisStringUtil" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
<title>공 정 조 회 &amp; 입 력</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
table.insertArea{
	height: 85px;
	border-top: 1px solid #007fc5;
	border-bottom: 1px solid #007fc5;
}
.insertArea th {
	vertical-align: middle;
	text-align: center;
	cursor: pointer;
}
table.insertArea td{
	font-size: 11px;
}
.hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
}
.td_smallYellowBack {
	font-size: 8pt;
	font-family: Verdana, Arial, Helvetica;
	vertical-align: middle;
	text-align: center;
	background-color: #ffffe0;
} 
.displaynone{
	display: none;
}
</style>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<input type="hidden" id="message" value="${message}"/>
	<div class="subtitle">
		공 정 조 회 &amp; 입 력
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
		<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
	    <input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
	    <input type="hidden" name="isManager" value="${loginUserInfo.is_manager}" />
	    <input type="hidden" name="insaDepartmentCode" value="${loginUserInfo.dept_code}" />
	    <input type="hidden" name="dwgDepartmentCode" value="${loginUserInfo.dwg_deptcode}" />
	    <input type="hidden" name="sortType" value="${sortType }">
	    <input type="hidden" name="sortValue" value="${sortValue }">
	    <input type="hidden" name="lockDate" value="${lockDate }">

		<div id="searchDiv">
			<table class="searchArea conSearch" style="table-layout: auto;">
				<col width="5%"/>
				<col width="10%"/>
				<col width="5%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="5%"/>
				<col width="14%"/>
				<col width="5%"/>
				<col width="20%"/>
				<col width="4%"/>
				<col width="3%"/>
				<tr>
					<th>부서</th>
					<td>
						<select id="departmentList" name="departmentList" onchange="departmentSelChanged('designerList',this);">
							<c:forEach var="item" items="${dpmList }" varStatus="status">
								<c:if test="${status.index == 0 }">
									<option value="all" <c:if test="${departmentList eq 'all' }"> selected='selected'</c:if>>&nbsp;</option>
								</c:if>
								<option value="${item.dept_code}"  
								<c:choose>
									<c:when test="${item.dept_code eq departmentList}">selected='selected'</c:when>
									<c:when test="${(departmentList == null or departmentList == '') and loginUserInfo.dept_code eq item.dept_code}">
										selected='selected'
									</c:when>
								</c:choose>
								>${item.dept_code}:${item.dept_name}</option>
							</c:forEach>
						</select>
					</td>
					<th>일자</th>
					<td colspan="4">
						<input type="text" id="p_created_date_start" value="${dateSelected_from}" name="dateSelected_from" readonly="readonly" class="datepicker" maxlength="10" style="width: 20%;" />
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" value="${dateSelected_to}" class="datepicker" readonly="readonly" maxlength="10" style="width: 20%;" />
						<select name="dateCondition" style="width : 35%;background-color:#eeeeee;">
		                    <option value="" <c:if test="${dateCondition eq '' }">selected="selected"</c:if> onclick="fn_search_date_init()">&nbsp;</option>
		                    <option value="DW_S" <c:if test="${dateCondition eq 'DW_S' }">selected="selected"</c:if>>Drawing Start</option>
		                    <option value="DW_F" <c:if test="${dateCondition eq 'DW_F' }">selected="selected"</c:if>>Drawing Finish</option>
		                    <option value="OW_S" <c:if test="${dateCondition eq 'OW_S' }">selected="selected"</c:if>>Owner App. Submit</option>
		                    <option value="OW_F" <c:if test="${dateCondition eq 'OW_F' }">selected="selected"</c:if>>Owner App. Receive</option>
		                    <option value="CL_S" <c:if test="${dateCondition eq 'CL_S' }">selected="selected"</c:if>>Class App. Submit</option>
		                    <option value="CL_F" <c:if test="${dateCondition eq 'CL_F' }">selected="selected"</c:if>>Class App. Receive</option>
		                    <option value="RF" <c:if test="${dateCondition eq 'RF' }">selected="selected"</c:if>>Reference</option>
		                    <option value="WK" <c:if test="${dateCondition eq 'WK' }">selected="selected"</c:if>>Working</option>
		                </select>
					</td>
					<td style="text-align: right;" colspan="4">
						<input type="button" value='조 회' class="btn_blue" id="btn_search"/>
						<input type="button" value='저 장' class="btn_blue" id="btn_save" />
						<input type="button" value='출 력' class="btn_blue" id="btn_print" onclick="viewReport();"/>
						<!-- 20140714 Kangseonjung : PM팀 인원(이재진 : 211363, 진승현 : 211047, 송동길 : 211269, 송우길 : 211856, 김태근:196039, 장현태:209495 )에 대하여 엑셀 출력기능 임시 추가
						20151028 Kangseonjung : 팀파트장에 엑셀 출력기능 추가 -->
						<c:if test="${loginUserInfo.is_admin eq 'Y' or loginUserInfo.isMaritimeBizTeam eq true or loginUserInfo.is_manager eq 'Y' 
									  or loginUserInfo.designerId eq '211047' or loginUserInfo.designerId eq '211269' or loginUserInfo.designerId eq '211363' 
									  or loginUserInfo.designerId eq '211856' or loginUserInfo.designerId eq '196039' or loginUserInfo.designerId eq '209495'
									  or loginUserInfo.designerId eq '206285'}">
									  <input type="button" value='엑 셀' class="btn_blue" id="btn_excel" onclick="viewReportExcel();"/>
						</c:if>
						<c:if test="${loginUserInfo.is_admin eq 'Y' }">
							<input type="button" value='실적입력관리' class="btn_blue" id="btn_data_change_possible"/>
							<input type="button" value='입력제한' class="btn_blue" id="btn_input_lock"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>호선</th>
					<td>
						<input type="text" name="projectInput" value="${projectInput }" onchange="onlyUpperCase(this);" class = "required" id="projectNo" onkeypress="this.value=this.value.toUpperCase().trim()"/>
						<input type="button" name="showprojectListBtn" value="+" style="width:20px;height:20px;font-weight:bold;" onclick="fn_showProjectSel(this);">
						<!-- 어드민옵션있음 나중에 추가-->
						<c:if test="${loginUserInfo.is_admin eq 'Y'}">
							<input type="button" name="" value="조회가능 호선관리" class="btn_gray2" id="btn_project_serach_able"/>
						</c:if>
					</td>
					<th>사번</th>
					<td>
						<select name="designerList" style="width:130px;">
							<option value="">&nbsp;</option>
							<!-- 사번 목록 리스트 추가 -->
							<c:forEach var="item" items="${personsList }">
								<option value="${item.employee_num }" <c:if test="${designerList eq item.employee_num }">selected="selected"</c:if>>${item.employee_num }   ${item.name }</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input type="checkbox" name="allempinput" onclick="fn_checkEmpAll(this)"/>1st담당자 일괄입력
						<select name="allempList" style="width:120px; display:none;">
		                    <option value="">&nbsp;</option>
		                </select>
		                <input type="button" name="ApplyButton" value='적 용' class="btn_gray2" style="display:none;" onclick="fn_applyAllEmp()"/><br>
		                <input type="checkbox" name="allempinput_sub" onclick="fn_checkEmpAll_sub(this)"/>2nd담당자 일괄입력
		                <select name="allempList_sub" style="width:120px; display:none;">
		                    <option value="">&nbsp;</option>
		                </select>
		                <input type="button" name="ApplyButton_sub" value='적 용' class="btn_gray2" style="display:none;" onclick="fn_applyAllEmp_sub()"/>  
					</td>
					<th>도면번호</th>
					<td>
		                <input type="text" name="drawingNo0" id="drawingNo0" value="${drawingNo0}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo1" id="drawingNo1" value="${drawingNo1}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo2" id="drawingNo2" value="${drawingNo2}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo3" id="drawingNo3" value="${drawingNo3}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo4" id="drawingNo4" value="${drawingNo4}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo5" id="drawingNo5" value="${drawingNo5}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo6" id="drawingNo6" value="${drawingNo6}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="text" name="drawingNo7" id="drawingNo7" value="${drawingNo7}" maxlength="1" style="width:7%;" onkeyup="fn_tab(this)" />
		                <input type="button" name="" value="clear" class="btn_gray2"  onclick="clearData(this);" />
		            </td>
		            <th>도면명</th>
		            <td>
		            	<input type="text" name="drawingTitle" value="${drawingTitle }" onKeyUp="javascript:this.value=this.value.toUpperCase();" style="width: 80%; "/>
		            </td>
		            <th>Total</th>
		            <td style="text-align: left;">
		            	<input type="text" name="projectTotal" value="${projectTotal }" readonly style="background-color:#D8D8D8;border:0;" />
		            </td>
				</tr>
				<tr>
					<th>항목<br/>숨기기</th>
					<td colspan="6">
						<input type="checkbox" name="colShowCheck" value="projectno" checked="checked" />Project<!-- default -->
		                <input type="checkbox" name="colShowCheck" value="deptname" />Part
		                <input type="checkbox" name="colShowCheck" value="dwgcode" />Drawing No.
		                <input type="checkbox" name="colShowCheck" value="dwgzone" checked="checked" />Zone<!-- default -->
		                <input type="checkbox" name="colShowCheck" value="outsourcing" checked="checked"/>Outsourcing Plan<!-- default -->
		                <input type="checkbox" name="colShowCheck" value="dwgtitle" />Task
		                <input type="checkbox" name="colShowCheck" value="name,sub_name" />담당자<br>
		                <input type="checkbox" name="colShowCheck" value="dw_plan_s" />Drawing Start
		                <input type="checkbox" name="colShowCheck" value="dw_plan_f" />Drawing Finish
		                <input type="checkbox" name="colShowCheck" value="ow_plan_s" />Owner App. Submit
		                <input type="checkbox" name="colShowCheck" value="ow_plan_f" />Owner App. Finish
		                <input type="checkbox" name="colShowCheck" value="cl_plan_s" />Class App. Submit
		                <input type="checkbox" name="colShowCheck" value="cl_plan_f" />Class App. Finish
		                <input type="checkbox" name="colShowCheck" value="rf_plan_s" />Working
		                <input type="checkbox" name="colShowCheck" value="wk_plan_s" />Construction
					</td>
					<td colspan="2">
						<div>
							<table cellspacing="0" cellpadding="0" border="0" align="left" >
				                 <tr height="15">
				                     <td class="td_keyEvent disable" rowspan="2" width="20%" style="padding-left:2px;color:#0000ff">
				                         <input class="input_noBorder" style="padding:0 3px 0 3px;width:80%;background-color:#D8D8D8;" name="keyeventCT" />
				                     </td>
				                     <td class="td_keyEvent disable" rowspan="2" colspan="3" width="20%" style="padding-left:2px;color:#0000ff">
				                         <input class="input_noBorder" style="padding:0 3px 0 3px;width:80%;background-color:#D8D8D8;" name="keyeventSC" />
				                     </td>
				                     <td class="td_keyEvent disable" colspan="2" width="20%" style="padding-left:2px;color:#0000ff">
				                         <input class="input_noBorder" style="padding:0 3px 0 3px;width:80%;background-color:#D8D8D8;" name="keyeventKL" />
				                     </td>
				                     <td class="td_keyEvent disable" colspan="2" width="20%" style="padding-left:2px;color:#0000ff">
				                         <input class="input_noBorder" style="padding:0 3px 0 3px;width:80%;background-color:#D8D8D8;" name="keyeventLC" />
				                     </td>
				                     <td class="td_keyEvent disable" rowspan="2" width="20%" style="padding-left:2px;color:#0000ff">
				                         <input class="input_noBorder" style="padding:0 3px 0 3px;width:80%;background-color:#D8D8D8;" name="keyeventDL" />
				                     </td>
				                 </tr>
				                 <tr height="6">
				                     <td class="disable"></td>
				                     <td class="td_keyEvent disable" rowspan="2" colspan="2" bgcolor="#00008b"></td>
				                     <td class="disable"></td>
				                 </tr>
				                 <tr height="3">
				                     <td class="disable" colspan="2"></td>
				                     <td class="disable" rowspan="3" width="1%" bgcolor="#00008b"></td>
				                     <td class="td_keyEvent disable" colspan="2"></td>
				                     <td class="td_keyEvent disable" colspan="2"></td>
				                 </tr>
				                 <tr style="height:3px;" bgColor="#00008b">
				                     <td class="td_keyEvent disable" colspan="2"></td>
				                     <td class="td_keyEvent disable" colspan="6"></td>
				                 </tr>
				                 <tr height="3">
				                     <td class="td_keyEvent disable" colspan="2"></td>
				                     <td class="td_keyEvent disable" colspan="6"></td>
				                 </tr>
				             </table>
				     	</div>
					</td>
					<th></th>
		            <td>
		            </td>
				</tr>
			</table>
		</div>
		<div id="dataListDiv" class="content">
			<div id="header" style="position: relative; left: 0; margin: 0px auto;">
				<div id="header_left" style="position: absolute; overflow:hidden; top: 10px; left: 1px; height: 98px; width: 670px;" >
					<table border="0" cellspacing="1" cellpadding="0" align="left" class="insertArea">
						<tbody>
							<tr>
								<th id="td_header_no" 				 rowspan="3" width="44" nowrap>No</th>
								<th id="td_header_project" 			 class="projectno"	rowspan="3" width="50" nowrap>Project </th>
								<th id="td_header_part" 			 class="deptname"   rowspan="3" width="90" nowrap>Part</th>
								<th id="td_header_drawingno" 		 class="dwgcode"    rowspan="3" width="70" nowrap>DrawingNo</th>
								<th id="td_header_zone" 			 class="dwgzone"    rowspan="3" width="40" nowrap>Zone</th>
								<th id="td_header_outsourcingplan" 	 class="outsourcing"rowspan="3" colspan="3" width="81" nowrap>Outsourcing<br>Plan</th>
								<th id="td_header_task" 			 class="dwgtitle"   rowspan="3" width="256" nowrap>Task(Drawing Title)</th>
								<th id="td_header_user" 			 class="name"       rowspan="3" width="50"  nowrap>1st<br>담당자</th>
								<th id="td_header_user1"			 class="name"       rowspan="3" width="50"  nowrap>2nd<br>담당자</th>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="header_right" style="position: absolute; overflow: hidden; top: 10px;  height: 98px; width: 583px; left: 671px;" >
					<table id="table_header2" border="0" cellspacing="1" cellpadding="1" bgcolor="#cccccc" class="insertArea">
						<tbody>
							<tr>
								<th id="area1" rowspan="3" width="40" nowrap>Rev.</th>
								<th rowspan="3" width="70" nowrap>출도일자</th>
								<th id="yardDrawingHeader1"   class="dw_plan_s" colspan="2" nowrap>DrawingStart</th>
								<th id="yardDrawingHeader2"   class="dw_plan_f" colspan="2" nowrap>DrawingFinish</th>
								<th id="yardDrawingHeader3"   class="ow_plan_s" colspan="2" nowrap>OwnerApp.Submit</th>
								<th id="yardDrawingHeader4"   class="ow_plan_f" colspan="2" nowrap>OwnerApp.Receive</th>
								<th id="yardDrawingHeader5"   class="cl_plan_s" colspan="2" nowrap>ClassApp.Submit</th>
								<th id="yardDrawingHeader6"   class="cl_plan_f" colspan="2" nowrap>ClassApp.Receive</th>
								<th id="yardDrawingHeader7"   class="rf_plan_s" colspan="2" nowrap>Working</th>
								<th id="commonDrawingHeader1" class="wk_plan_s" rowspan="2" colspan="2" nowrap>Construction</th>
								<th id="area26" rowspan="3" width="120" nowrap>참조EVENT</th>
								<th id="area27" rowspan="3" width="120" nowrap>현재일자</th>
								<th colspan="8" nowrap>MANHOUR</th>
								<!-- <th id="area2" rowspan="3" width="70" nowrap>BOM 수량</th> -->
							</tr>
							<tr>
								<th id="vendorDrawingHeader1" class="dw_plan_s" colspan="2" nowrap>PurchaseRequest</th>
								<th id="vendorDrawingHeader2" class="dw_plan_f" colspan="2" nowrap>MakerSelection</th>
								<th id="vendorDrawingHeader3" class="ow_plan_s" colspan="2" nowrap>PurchaseOrder</th>
								<th id="vendorDrawingHeader4" class="ow_plan_f" colspan="2" nowrap>DrawingReceive</th>
								<th id="vendorDrawingHeader5" class="cl_plan_s" colspan="2" nowrap>OwnerApp.Submit</th>
								<th id="vendorDrawingHeader6" class="cl_plan_f" colspan="2" nowrap>OwnerApp.Receive</th>
								<th id="vendorDrawingHeader7" class="rf_plan_s" colspan="2" nowrap>MakerWorking</th>
								<th colspan="2" nowrap>Plan</th>
								<th colspan="2" nowrap>Internal</th>
								<th colspan="2" nowrap>Outsourcing</th>
								<th colspan="2" nowrap>Total</th>
							</tr>
							<tr>
								<th id="area2" width="70" class="dw_plan_s" nowrap>Plan</th>
								<th id="area3" width="70" class="dw_plan_s" nowrap>Action</th>
								<th id="area4" width="70" class="dw_plan_f" nowrap>Plan</th>
								<th id="area5" width="70" class="dw_plan_f" nowrap>Action</th>
								<th id="area6" width="70" class="ow_plan_s" nowrap>Plan</th>
								<th id="area7" width="70" class="ow_plan_s" nowrap>Action</th>
								<th id="area8" width="70" class="ow_plan_f" nowrap>Plan</th>
								<th id="area9" width="70" class="ow_plan_f" nowrap>Action</th>
								<th id="area10" width="70" class="cl_plan_s" nowrap>Plan</th>
								<th id="area11" width="70" class="cl_plan_s" nowrap>Action</th>
								<th id="area12" width="70" class="cl_plan_f" nowrap>Plan</th>
								<th id="area13" width="70" class="cl_plan_f" nowrap>Action</th>
								<th id="area14" width="70" class="rf_plan_s" nowrap>Plan</th>
								<th id="area15" width="70" class="rf_plan_s" nowrap>Action</th>
								<th id="area16" width="70" class="wk_plan_s" nowrap>Plan</th>
								<th id="area17" width="70" class="wk_plan_s" nowrap>Action</th>
								<!-- <th id="area19" width="120" nowrap>NEW</th>
								<th id="area20" width="120" nowrap>OLD</th>
								<th id="area21" width="70" nowrap>NEW</th>
								<th id="area22" width="70" nowrap>OLD</th>
								<th id="area23" width="70" nowrap>일정차이</th> -->
								<th id="area18" width="50" nowrap>STD</th>
								<th id="area19" width="55" nowrap>FollowUp</th>
								<th id="area20" width="50" nowrap>STD</th>
								<th id="area21" width="55" nowrap>FollowUp</th>
								<th id="area22" width="50" nowrap>STD</th>
								<th id="area23" width="55" nowrap>FollowUp</th>
								<th id="area24" width="50" nowrap>STD</th>
								<th id="area25" width="55" nowrap>FollowUp</th>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div id="list" style="position: relative; left: 0; margin: 0px auto;" >
				<div id="list_left" style="position: absolute; overflow-x: scroll; overflow-y:hidden; top: 100px; left: 1px; width: 670px;"  onscroll="onScrollHandler2();">
					<table id="table_data1" border="0" cellspacing="1" cellpadding="0" align="left"  class="insertArea">
						<tbody>
							
						</tbody>
					</table>	
				</div>
				<div id="list_right" style="position: absolute; overflow: scroll; top: 100px; padding-right: 21px; width: 583px; left: 671px;" onscroll="onScrollHandler();">
					<table id="table_data2" border="0" cellspacing="1" cellpadding="0" class="insertArea">
						<tbody>
					
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
<!-- 호선 선택 div팝업 -->
<div id="projectListDiv" style="position:absolute;display:none; z-index: 9;">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="projectList" id="projectList" style="width:150px;background-color:#fff0f5" onchange="fn_projectChanged(this);">
            <option value="&nbsp;"></option>
            <c:forEach var="item" items="${projectList }">
            	<option value="${item.projectno }">${item.projectno }</option>
            </c:forEach>
        </select>
    </td></tr>
    </table>
</div>
<div id="personsListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	<input type="hidden" class="rowid" value=""/>
	<input type="hidden" class="colid" value=""/>
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="personsList" style="width:150px;background-color:#fff0f5" onchange="fn_personsSelChanged();">
            <option value="&nbsp;"></option>
        </select>
    </td></tr>
    </table>
</div>
<div id="outsidePersonsListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	<input type="hidden" class="rowid" value=""/>
	<input type="hidden" class="colid" value=""/>
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="outsidePersonsList" style="width:150px;background-color:#fff0f5" onchange="fn_outsidePersonsSelChanged();">
            <option value="&nbsp;"></option>
        </select>
    </td></tr>
    </table>
</div>
<div id="datePickerDiv" style="position:absolute; display:none; z-index: 9;" class="div_popup">
	<input type="hidden" id="targetRowId" value=""/>
	<input type="hidden" id="targetColId" value=""/>
	<input type="hidden" id="limitOption" value="N"/>
    <input type="text" id="normalDatePicker" class="datepicker" maxlength="10" style="width: 65px;" readonly="readonly" ondblclick="fn_deleteDate(this)"/>
</div>
</div>
<script type="text/javascript">
var mst_table = $("#table_data1");
var sub_table = $("#table_data2");
var input_date = "";
$( function() {
	
	var dates = $( "#p_created_date_start, #p_created_date_end" ).datepicker( {
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames: ['일','월','화','수','목','금','토'],
		dayNamesShort: ['일','월','화','수','목','금','토'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		dateFormat: 'yy-mm-dd',
		showMonthAfterYear: true,
		yearSuffix: '년',
		changeYear : true,
		changeMonth : true,
		onSelect: function( selectedDate ) {
			var option = this.id == "p_created_date_start" ? "minDate" : "maxDate",
			instance = $( this ).data( "datepicker" ),
			date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
			dates.not( this ).datepicker( "option", option, date );
		}
	} );
	
	var normalDate = $("#normalDatePicker").datepicker( {
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames: ['일','월','화','수','목','금','토'],
		dayNamesShort: ['일','월','화','수','목','금','토'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		dateFormat: 'yy-mm-dd',
		showMonthAfterYear: true,
		yearSuffix: '년',
		changeYear : true,
		changeMonth : true,
		beforeShow:function(input, inst){
			if(input_date != "") $("#normalDatePicker").datepicker('setDate', input_date);
		},
		onSelect: function( selectedDate,instance) {
			var targetCol = sub_table.find("tr:eq("+$('#targetRowId').val()+")").find("td:eq("+$('#targetColId').val()+")");
			var lastVal = instance.lastVal;
			var limitOption = $('#limitOption').val();
			if(limitOption != 'Y'){
				targetCol.text(selectedDate);
				input_date = selectedDate;
				mst_table.find("tr:eq("+$('#targetRowId').val()+")").find("input[name=oper]").val("U");
			}
			else {
				if(!fn_dateLimitOptionCheck(selectedDate)){
					targetCol.text(lastVal);
				} else {
					targetCol.text(selectedDate);
					input_date = selectedDate;
					mst_table.find("tr:eq("+$('#targetRowId').val()+")").find("input[name=oper]").val("U");
				}
			}
		}
	} );
} );

//입력된 날짜 삭제
function fn_deleteDate(obj){
	if(application_form.isAdmin.value != 'Y') return;
	if($.trim($(obj).val()) == "") return;
	var targetCol = sub_table.find("tr:eq("+$('#targetRowId').val()+")").find("td:eq("+$('#targetColId').val()+")");
	targetCol.text('');
	mst_table.find("tr:eq("+$('#targetRowId').val()+")").find("input[name=oper]").val("U");
	$("#normalDatePicker").datepicker("hide");
	fn_toggleDivPopUp();
}
//도면타입에 따라 Header 부분 선택 값을 변경(: Color-Highlight 로 표시)
function trOnMouseOver(dwgCode)
{
    if (dwgCode != null && dwgCode.indexOf("V") == 0) {
        document.getElementById('yardDrawingHeader1').style.backgroundColor = '#e5e5e5';
        document.getElementById('yardDrawingHeader2').style.backgroundColor = '#e5e5e5';
        document.getElementById('yardDrawingHeader3').style.backgroundColor = '#e5e5e5';
        document.getElementById('yardDrawingHeader4').style.backgroundColor = '#e5e5e5';
        document.getElementById('yardDrawingHeader5').style.backgroundColor = '#e5e5e5';
        document.getElementById('yardDrawingHeader6').style.backgroundColor = '#e5e5e5';
        document.getElementById('yardDrawingHeader7').style.backgroundColor = '#e5e5e5';

        document.getElementById('vendorDrawingHeader1').style.backgroundColor = '#32cd32';
        document.getElementById('vendorDrawingHeader2').style.backgroundColor = '#32cd32';
        document.getElementById('vendorDrawingHeader3').style.backgroundColor = '#32cd32';
        document.getElementById('vendorDrawingHeader4').style.backgroundColor = '#32cd32';
        document.getElementById('vendorDrawingHeader5').style.backgroundColor = '#32cd32';
        document.getElementById('vendorDrawingHeader6').style.backgroundColor = '#32cd32';
        document.getElementById('vendorDrawingHeader7').style.backgroundColor = '#32cd32';

        document.getElementById('commonDrawingHeader1').style.backgroundColor = '#32cd32';
    }
    else {
        document.getElementById('vendorDrawingHeader1').style.backgroundColor = '#e5e5e5';
        document.getElementById('vendorDrawingHeader2').style.backgroundColor = '#e5e5e5';
        document.getElementById('vendorDrawingHeader3').style.backgroundColor = '#e5e5e5';
        document.getElementById('vendorDrawingHeader4').style.backgroundColor = '#e5e5e5';
        document.getElementById('vendorDrawingHeader5').style.backgroundColor = '#e5e5e5';
        document.getElementById('vendorDrawingHeader6').style.backgroundColor = '#e5e5e5';
        document.getElementById('vendorDrawingHeader7').style.backgroundColor = '#e5e5e5';

        document.getElementById('yardDrawingHeader1').style.backgroundColor = '#32cd32';
        document.getElementById('yardDrawingHeader2').style.backgroundColor = '#32cd32';
        document.getElementById('yardDrawingHeader3').style.backgroundColor = '#32cd32';
        document.getElementById('yardDrawingHeader4').style.backgroundColor = '#32cd32';
        document.getElementById('yardDrawingHeader5').style.backgroundColor = '#32cd32';
        document.getElementById('yardDrawingHeader6').style.backgroundColor = '#32cd32';
        document.getElementById('yardDrawingHeader7').style.backgroundColor = '#32cd32';

        document.getElementById('commonDrawingHeader1').style.backgroundColor = '#32cd32';
    }
}

//도면 Title 부분 MouseOver 시 도면 Title Full Text를 힌트 형태로 표시
var hintcontainer = null;   
function showhint(obj, txt) {   
   if (hintcontainer == null) {   
      hintcontainer = document.createElement("div");   
      hintcontainer.className = "hintstyle";   
      document.body.appendChild(hintcontainer);   
   }   
   obj.onmouseout = hidehint;   
   obj.onmousemove = movehint;   
   hintcontainer.innerHTML = txt;   
}   
function movehint(e) {   
    if (!e) e = event; // line for IE compatibility   
    hintcontainer.style.top =  (e.clientY + document.documentElement.scrollTop + 2) + "px";   
    hintcontainer.style.left = (e.clientX + document.documentElement.scrollLeft + 10) + "px";   
    hintcontainer.style.display = "";   
}   
function hidehint() {   
   hintcontainer.style.display = "none";   
}

//날짜  유효성 체크: Action 일자 변경 처리 용
function fn_dateLimitOptionCheck(checkDate){
	if(checkDate != null && checkDate.trim() != ""){
		// 오늘 기준 -(lockDate 0 ~ +1 일 이내 날짜만 입력 가능(체크)
		if(application_form.isAdmin.value != "Y"){
			var today = new Date();
			var dateStrs = checkDate.split("-");
			var lockDate = application_form.lockDate.value;
			
			if(lockDate != ""){
				if(lockDate.indexOf("-") == 0) lockDate = lockDate.substring(1);
				// 선택일에 +(lockDate)일 한 일자(오늘날짜보다 같거나 커야함) 
				 var targetDate = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "+" + lockDate)); 
				 if (targetDate < today) {
					alert( "입력 가능 일자가 아닙니다. 자세한 사항은\n\n\n" +
                            "조선 -> 기술기획팀-기술계획P에 문의 바랍니다.\n\n" + 
                            "해양 -> 해양설계관리팀으로 문의 바랍니다.");
					return false;
				 }
			}
			// 선택일에 -1일 한 일자(오늘날짜보다 작거나 같아야함)
			var targetDate2 = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "-1")); 
			if (targetDate2 > today) {
			    alert("오늘날짜 기준 +1일 이내의 날짜만 입력할 수 있습니다!");
			    return false;
			}
		}
	}
	return true;
}
//부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
function departmentSelChanged(sabunTagName,obj) 
{
    var dept_code = $(obj).val();
    if(dept_code == "") return;
    departmentPerson(sabunTagName,dept_code);
    
}

//부서 인원 쿼리
/* A.EMPLOYEE_NUM,
		       A.NAME,
		       A.WORK_TELEPHONE */
function departmentPerson(sabunTagName,dept_code){
	var sabunTagObj = $("select[name="+sabunTagName+"]");
	if(dept_code == "all"){
		sabunTagObj.empty();
		return;
	}
    $.ajax({
    	url:'<c:url value="getPartPersonsForDPProgress.do"/>',
    	type:'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"dept_code" : dept_code},
    	success : function(data){
    		var jsonData = JSON.parse(data);
    		sabunTagObj.empty();
    		sabunTagObj.append("<option value=''>&nbsp;</option>");
    		for(var i=0; i<jsonData.rows.length; i++){
    			var rows = jsonData.rows[i];
    			sabunTagObj.append("<option value='"+rows.employee_num+"'>"+rows.employee_num+" : "+rows.name+"("+rows.work_telephone+")</option>");
    		}
    	}, 
    	error : function(e){
    		alert(e);
    	}
    });
}
//부서 인원 쿼리 Dalian
/* SELECT A.SAWON_ID as EMPLOYEE_NO,
		       A.SAWON_NAME as EMPLOYEE_NAME,
		       '' AS PHONE as PHONE */
function departmentPerson_Dalian(sabunTagName,dept_code){
	var sabunTagObj = $("select[name="+sabunTagName+"]");
    $.ajax({
    	url:'<c:url value="getPartPersonsForDPProgress.do"/>',
    	type:'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"dept_code" : dept_code},
    	success : function(data){
    		var jsonData = JSON.parse(data);
    		sabunTagObj.empty();
    		sabunTagObj.append("<option value=''>&nbsp;</option>");
    		for(var i=0; i<jsonData.rows.length; i++){
    			var rows = jsonData.rows[i];
    			sabunTagObj.append("<option value='"+rows.employee_no+"'>"+rows.employee_no+" : "+rows.employee_name+"("+rows.phone+")</option>");
    		}
    	}, 
    	error : function(e){
    		alert(e);
    	}
    });
}
//부서 인원외 인원
/* A.EMPLOYEE_NUM,
		       A.NAME,
		       A.WORK_TELEPHONE */
function departmentOutPerson(sabunTagName,dept_code){
	var sabunTagObj = $("select[name="+sabunTagName+"]");
    $.ajax({
    	//url:'<c:url value="getPartOutsidePersonsForDPProgress.do"/>',
    	url:'<c:url value="getPartPersonsForDPProgress.do"/>',
    	type:'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"dept_code" : dept_code},
    	success : function(data){
    		var jsonData = JSON.parse(data);
    		sabunTagObj.empty();
    		sabunTagObj.append("<option value=''>&nbsp;</option>");
    		for(var i=0; i<jsonData.rows.length; i++){
    			var rows = jsonData.rows[i];
    			sabunTagObj.append("<option value='"+rows.employee_num+"'>"+rows.employee_num+" : "+rows.name+"("+rows.work_telephone+")</option>");
    		}
    	}, 
    	error : function(e){
    		alert(e);
    	}
    });
}


//그리드 내의 데이터 피커
function fn_normalDatePicker(targetObj,projectNo,activity_code,start_finish_code,limitOption){
	
	var rowId = $(targetObj).closest("tr").index();
	var colId = $(targetObj).closest("td").index();
	
	var changeAbleDataDp = false;
	$.ajax({
		url:'<c:url value="getChangableDateDPList.do"/>',
    	type:'POST',
    	async : false,
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"project_no" : projectNo,
    			"activity_code" : activity_code.toUpperCase(),
    			"start_finish_code" : start_finish_code.toUpperCase()},
    	success : function(data){
    		var jsonData = JSON.parse(data);
    		if(jsonData.rows.length == 0 ) 
    		{
    			// 입력제한 대상이 없을 경우
    			changeAbleDataDp = true;
    		} else {
	    		for(var i=0; i<jsonData.rows.length; i++)
	    		{
	    			var rows = jsonData.rows[i];
	    			// 입력 제한 대상중에 예외 체크
	    			if(rows.checkflag == "Y")
	    			{
	    				changeAbleDataDp = true;
	    				break;
	    			}
	    		}    			
    		}     			
    	}, 
    	error : function(e){
    		alert("error 발생");
    		return;
    	}		
	}); 

	if(!changeAbleDataDp && application_form.isAdmin.value != "Y")
	{
		return;
	}
	
	//admin이 아니고 입력된 데이터가 있을 경우 리턴
	if($.trim($(targetObj).text()) != "" &&  application_form.isAdmin.value != "Y") return;
	
	
	fn_toggleDivPopUp($("#datePickerDiv"),$(targetObj));
	$("#targetRowId").val('').val(rowId);
	$("#targetColId").val('').val(colId);
	$("#limitOption").val('').val(limitOption);
	$("#normalDatePicker").css("width",$(targetObj).outerWidth());
	$("#normalDatePicker").css("height",$(targetObj).outerHeight());
	$("#normalDatePicker").val($(targetObj).text());
	$("#normalDatePicker").focus().click();
	
}

//선택 영역 안 전체 input type text 들 값 제거 
function clearData(obj){
	var parent = $(obj).closest("td");
	parent.find("input[type=text]").val("");
}
//호선 검색 값 변경
function fn_projectChanged(obj){
	$("#projectNo").val($(obj).val());
	fn_hideProjectSel();
}
//호선 검색view show
function fn_showProjectSel(obj){
	var activeDivObj = $("#projectListDiv");
	var activeSelectBox = $("#projectList");
	activeDivObj.css("left",$(obj).prev().offset().left);
	activeDivObj.css("top",$(obj).prev().offset().top);
	activeDivObj.css("display","");
	if($("#projectNo").val() != '')activeSelectBox.val($("#projectNo").val());
	else activeSelectBox.find("option:eq(0)").attr("selected","true");
	activeSelectBox.focus().click();
}
//호선 검색 view hide
function fn_hideProjectSel(){
	$("#projectListDiv").css("display","none");
}

//입력 조건 체크
function checkInputs()
{
    var str = application_form.projectInput.value.trim();

    if (application_form.projectInput.value == "") {
        alert("올바른 호선이름을 선택하십시오.");
        return false;
    }
    
    if ((application_form.dateSelected_from.value != "" || application_form.dateSelected_to.value != "") &&
    		application_form.dateCondition.value == "")
    {
        alert("검색일자에 대한 조건을 입력하십시오!");
        application_form.dateCondition.focus();
        return false;
    }

    return true;
}

//프린트(리포트 출력) - VIEW & PRINT 양식
function viewReport()
{
    var rdFileName = "stxPECDPProgressView.mrd";
    if (application_form.isAdmin.value == "Y") rdFileName = "stxPECDPProgressViewAdmin.mrd";
    viewReportProc(rdFileName);
}
    
// 프린트(리포트 출력) - EXCEL EXPORT 양식
function viewReportExcel()
{
    viewReportProc("stxPECDPProgressViewExcel.mrd");
}

// 프린트(리포트 출력) 서브 프로시저
function viewReportProc(rdFileName)
{
    if (!checkInputs()) return;
    var paramStr = application_form.projectInput.value + ":::" + 
                   (application_form.departmentList.value == "all" ? "": application_form.departmentList.value) + ":::" + 
                   application_form.designerList.value + ":::";
    
   var fromDate = application_form.dateSelected_from.value;
   var toDate = application_form.dateSelected_to.value;
    
    if (fromDate != "" && toDate != "") { // 시작-종료 순서가 반대이면 조정
        var tempStrs = fromDate.split("-");
        var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        tempStrs = toDate.split("-");
        var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        if (fromDateObj > toDateObj) {
            var temp = toDate;
            toDate = fromDate;
            fromDate = temp;
        }
    }

    var dwStartFrom = ":::";
    var dwStartTo = ":::";
    var dwFinishFrom = ":::";
    var dwFinishTo = ":::";
    var owStartFrom = ":::";
    var owStartTo = ":::";
    var owFinishFrom = ":::";
    var owFinishTo = ":::";
    var clStartFrom = ":::";
    var clStartTo = ":::";
    var clFinishFrom = ":::";
    var clFinishTo = ":::";
    var rfStartFrom = ":::";
    var rfStartTo = ":::";
    var wkStartFrom = ":::";
    var wkStartTo = ":::";
    var sortValue = ":::";
    var sortType = "";

    if ((fromDate != "" || toDate != "") && application_form.dateCondition.value != "") 
    {
        var dateCondition = application_form.dateCondition.value;
        if (dateCondition == "DW_S") {
            dwStartFrom = fromDate + ":::";
            dwStartTo = toDate +  ":::";
        }
        if (dateCondition == "DW_F") {
            dwFinishFrom = fromDate + ":::";
            dwFinishTo = toDate +  ":::";
        }
        if (dateCondition == "OW_S") {
            owStartFrom = fromDate + ":::";
            owStartTo = toDate +  ":::";
        }
        if (dateCondition == "OW_F") {
            owFinishFrom = fromDate + ":::";
            owFinishTo = toDate +  ":::";
        }
        if (dateCondition == "CL_S") {
            clStartFrom = fromDate + ":::";
            clStartTo = toDate +  ":::";
        }
        if (dateCondition == "CL_F") {
            clFinishFrom = fromDate + ":::";
            clFinishTo = toDate +  ":::";
        }
        if (dateCondition == "RF") {
            rfStartFrom = fromDate + ":::";
            rfStartTo = toDate +  ":::";
        }
        if (dateCondition == "WK") {
            wkStartFrom = fromDate + ":::";
            wkStartTo = toDate +  ":::";
        }
    }

    var sortValue2 = application_form.sortValue.value;
    var sortType2 = application_form.sortType.value;
    if (rdFileName != "stxPECDPProgressViewExcel.mrd")
    {
        if (sortValue2 != null && sortValue2 != "" && sortValue2 != "PROJECTNO" && sortValue2 != "DEPTNAME" && sortValue2 != "DWGZONE") 
        {
            if (sortValue2 == "NAME") sortValue2 = "EMPLOYEE_NAME";
            if (sortValue2 == "MAX_REV") sortValue2 = "MAX_REVISION";

            if (sortType2 == null || sortType2 == "" || sortType2 == "ascending") sortType2 = "ASC";
            else sortType2 = "DESC";

            sortValue = sortValue2 + ":::";
            sortType = sortType2;
        }
    }
    else
    {
        if (sortValue2 != null && sortValue2 != "" && sortValue2 != "DWGZONE") 
        {
            if (sortValue2 == "NAME") sortValue2 = "EMPLOYEE_NAME";
            if (sortValue2 == "MAX_REV") sortValue2 = "MAX_REVISION";

            if (sortType2 == null || sortType2 == "" || sortType2 == "ascending") sortType2 = "ASC";
            else sortType2 = "DESC";

            sortValue = sortValue2 + ":::";
            sortType = sortType2;
        }
    }

    paramStr += dwStartFrom + dwStartTo + dwFinishFrom + dwFinishTo + owStartFrom + owStartTo + owFinishFrom + owFinishTo + 
                clStartFrom + clStartTo + clFinishFrom + clFinishTo + rfStartFrom + rfStartTo + wkStartFrom + wkStartTo;

    var dwgCode = "";
    for (var i = 0; i < 8; i++) {
        var str = $("#drawingNo"+i).val();
        
        if (str == "" || str == undefined) dwgCode += "_";
        else dwgCode += str;
    }

    paramStr += dwgCode + ":::";
    paramStr += application_form.drawingTitle.value + ":::";
    paramStr += sortValue + sortType;
    paramStr = encodeURIComponent(paramStr);

    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/" + rdFileName 
                 + "&param=" + paramStr;
    
    window.open(urlStr, "", "");
}

//1차 담당자 선택
function fn_checkEmpAll(AllEmpInput)
{
	if(application_form.isAdmin.value != "Y" && application_form.departmentList.value != application_form.insaDepartmentCode.value)
	{
		var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
                     "조회된 도면을 확인 바랍니다.";
		alert(msgStr);
		$(AllEmpInput).prop("checked",false);
		return;
	}
	departmentPerson("allempList", application_form.departmentList.value);
	if(AllEmpInput.checked)
	{
		application_form.allempList.style.display = "";
	}
	else application_form.allempList.style.display = "none";
		 
	if(AllEmpInput.checked)
	{
		application_form.ApplyButton.style.display = "";
	}
	else application_form.ApplyButton.style.display = "none";
	
	AllEmpInput = null;
}
//1차 담당자 전체 적용
function fn_applyAllEmp()
{
	if (application_form.allempList.value == "")
	{
		var msgStr = "일괄 입력 할 담당자를 선택하시기 바랍니다.";
		alert(msgStr);
		return;
	}
	
	var confirmgubun = "CANCEL";  // YES, NO, CANCEL
	
	var selectedOption = application_form.allempList.options[application_form.allempList.selectedIndex];

	// 일괄입력 방법 선정(기 입력 data 변경 여부 확인) 기존 confirm 창 두번 뜨던것을 팝업으로 변경
	var rs = window.showModalDialog( "popUpProgressPersonConfirmMsg.do",
			window,
			"dialogWidth:270px; dialogHeight:170px; center:on; scroll:off; status:off" );
	
	if( rs != null ) {		
		confirmgubun = rs;
	}	
	
	if(confirmgubun == "CANCEL") return;
	else {
		var mtr = mst_table.find("tr");
		if(mtr.length == 0){
			alert("데이터가 없습니다.");
			return;
		}
		var breakCheck = false;
		for(var i = 0; i < mtr.length; i++){
			var oper = $(mtr[i]).find("input[name=oper]");
			var deptcode = $(mtr[i]).find("input[name=deptcode]");
			var _1st = $(mtr[i]).find("td:eq(9)");
			var _1st_sabun = $(mtr[i]).find("input[name=sabun]");
			if(application_form.isAdmin.value == 'Y' || deptcode.val() == application_form.dwgDepartmentCode.value){
				if (confirmgubun == "YES"){
					var name = $.trim((selectedOption.text.split(":")[1]).substring(0,(selectedOption.text.split(":")[1]).indexOf("(")));
					oper.val("U");
					_1st.text(name);
					_1st_sabun.val(selectedOption.value);
				}else if (confirmgubun == "NO"){
					if($.trim(_1st.text()) != "") continue;
					var name = $.trim((selectedOption.text.split(":")[1]).substring(0,(selectedOption.text.split(":")[1]).indexOf("(")));
					oper.val("U");
					_1st.text(name);
					_1st_sabun.val(selectedOption.value);
				}
			} else {
				var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
	            "조회된 도면을 확인 바랍니다.";                            
				alert(msgStr);
				breakCheck = true;
				break;
			}
		}
		if(breakCheck) return;
	}
}
//2차 담당자 선택
function fn_checkEmpAll_sub(AllEmpInput_sub)
{
	if(application_form.isAdmin.value != "Y" && application_form.departmentList.value != application_form.insaDepartmentCode.value)
	{
		var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
                     "조회된 도면을 확인 바랍니다.";
		alert(msgStr);
		$(AllEmpInput_sub).prop("checked",false);
		return;
	}
	departmentOutPerson("allempList_sub", application_form.departmentList.value);
	if(AllEmpInput_sub.checked)
	{
		application_form.allempList_sub.style.display = "";
	}
	else application_form.allempList_sub.style.display = "none";
		 
	if(AllEmpInput_sub.checked)
	{
		application_form.ApplyButton_sub.style.display = "";
	}
	else application_form.ApplyButton_sub.style.display = "none";
	
	AllEmpInput_sub = null;
}
//2차 담당자 전체 적용
function fn_applyAllEmp_sub()
{
	if (application_form.allempList_sub.value == "")
	{
		var msgStr = "일괄 입력 할 담당자를 선택하시기 바랍니다.";
		alert(msgStr);
		return;
	}
	
	var confirmgubun = "CANCEL";  // YES, NO, CANCEL
	
	var selectedOption = application_form.allempList_sub.options[application_form.allempList_sub.selectedIndex];
	
	// 일괄입력 방법 선정(기 입력 data 변경 여부 확인) 기존 confirm 창 두번 뜨던것을 팝업으로 변경
	var rs = window.showModalDialog( "popUpProgressPersonConfirmMsg.do",
			window,
			"dialogWidth:270px; dialogHeight:170px; center:on; scroll:off; status:off" );
	
	if( rs != null ) {		
		confirmgubun = rs;
	}	
	
	if(confirmgubun == "CANCEL") return;
	else {
		var mtr = mst_table.find("tr");
		if(mtr.length == 0){
			alert("데이터가 없습니다.");
			return;
		}
		var breakCheck = false;
		for(var i = 0; i < mtr.length; i++){
			var oper = $(mtr[i]).find("input[name=oper]");
			var deptcode = $(mtr[i]).find("input[name=deptcode]");
			var _2nd = $(mtr[i]).find("td:eq(10)");
			var _2nd_sabun = $(mtr[i]).find("input[name=sub_sabun]");
			if(application_form.isAdmin.value == 'Y' || deptcode.val() == application_form.dwgDepartmentCode.value){
				if (confirmgubun == "YES"){
					var name = $.trim((selectedOption.text.split(":")[1]).substring(0,(selectedOption.text.split(":")[1]).indexOf("(")));
					oper.val("U");
					_2nd.text(name);
					_2nd_sabun.val(selectedOption.value);
				}else if (confirmgubun == "NO"){
					if($.trim(_2nd.text()) != "") continue;
					var name = $.trim((selectedOption.text.split(":")[1]).substring(0,(selectedOption.text.split(":")[1]).indexOf("(")));
					oper.val("U");
					_2nd.text(name);
					_2nd_sabun.val(selectedOption.value);
				}
			} else {
				var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
	            "조회된 도면을 확인 바랍니다.";                            
				alert(msgStr);
				breakCheck = true;
				break;
			}
		}
		if(breakCheck) return;
	}
}	

//1st담당자 조회 및 팝업 호출
function fn_selectPartPerson(targetObj)
{
	var deptcode = $(targetObj).closest("tr").find("input[name=deptcode]").val();	
	if(application_form.isAdmin.value != "Y" && application_form.dwgDepartmentCode.value != deptcode) return;
	
	fn_toggleDivPopUp($("#personsListDiv"),$(targetObj));
	
	
	var rowId = $(targetObj).closest("tr").index();
	var colId = $(targetObj).closest("td").index();

	$("#personsListDiv .rowid").val(rowId);
	$("#personsListDiv .colid").val(colId);
	
	var sabun = mst_table.find("tr:eq("+rowId+")").find("input[name=sabun]").val();
	
	var personSelect = $("#personsListDiv [name=personsList]");
    for (var i = 0; i < personSelect.find("option").size(); i++) {
        var str = personSelect.find("option:eq("+i+")").val();
        if (str == sabun) {
        	personSelect.find("option:eq("+i+")").prop("selected","true");
        	personSelect.focus().click();
        	return;
        } else {
        	personSelect.find("option:eq(0)").prop("selected","true");
        	personSelect.focus().click();
        }
    }
}
//1st담당자 선택(입력) 처리
function fn_personsSelChanged()
{
	var selectRow = $("#personsListDiv .rowid").val();
	var selectCol = $("#personsListDiv .colid").val();
	var personSelectValue = $("#personsListDiv [name=personsList]").val();
	var personSelectText = $("#personsListDiv [name=personsList] option:selected").text();
	if($.trim(personSelectText) == ""){personSelectText = ":"}
	var name = $.trim((personSelectText.split(":")[1]).substring(0,(personSelectText.split(":")[1]).indexOf("(")));

	mst_table.find("tr:eq("+selectRow+")").find("td:eq("+selectCol+")").text(name);
	mst_table.find("tr:eq("+selectRow+")").find("input[name=sabun]").val(personSelectValue);
	mst_table.find("tr:eq("+selectRow+")").find("input[name=oper]").val("U");
    fn_toggleDivPopUp();
}

//2st담당자
function fn_selectOutPartPerson(targetObj,rowId,colId)
{
	var deptcode = $(targetObj).closest("tr").find("input[name=deptcode]").val();	
	if(application_form.isAdmin.value != "Y" && application_form.dwgDepartmentCode.value != deptcode) return;
	
	fn_toggleDivPopUp($("#outsidePersonsListDiv"),$(targetObj));
	
	var rowId = $(targetObj).closest("tr").index();
	var colId = $(targetObj).closest("td").index();
	
	$("#outsidePersonsListDiv .rowid").val(rowId);
	$("#outsidePersonsListDiv .colid").val(colId);
	
	var sabun = mst_table.find("tr:eq("+rowId+")").find("input[name=sub_sabun]").val();
	
	var personSelect = $("#outsidePersonsListDiv [name=outsidePersonsList]");
    for (var i = 0; i < personSelect.find("option").size(); i++) {
        var str = personSelect.find("option:eq("+i+")").val();
        if (str == sabun) {
        	personSelect.find("option:eq("+i+")").prop("selected","true");
        	personSelect.focus().click();
        	return;
        } else {
        	personSelect.find("option:eq(0)").prop("selected","true");
        	personSelect.focus().click();
        }
    }
}
//2st담당자 선택(입력) 처리
function fn_outsidePersonsSelChanged()
{
	var selectRow = $("#outsidePersonsListDiv .rowid").val();
	var selectCol = $("#outsidePersonsListDiv .colid").val();
	var personSelectValue = $("#outsidePersonsListDiv [name=outsidePersonsList]").val();
	var personSelectText = $("#outsidePersonsListDiv [name=outsidePersonsList] option:selected").text();	
	if($.trim(personSelectText) == ""){personSelectText = ":"}
	var name = $.trim((personSelectText.split(":")[1]).substring(0,(personSelectText.split(":")[1]).indexOf("(")));
	
	mst_table.find("tr:eq("+selectRow+")").find("td:eq("+selectCol+")").text(name);
	mst_table.find("tr:eq("+selectRow+")").find("input[name=sub_sabun]").val(personSelectValue);
	mst_table.find("tr:eq("+selectRow+")").find("input[name=oper]").val("U");
	
    fn_toggleDivPopUp();
}

//도면 개정정보화면 POPUP
function fn_showDeployRevInfo(dwgCode)
{
    var sProperties = 'dialogHeight:400px;dialogWidth:800px;scroll=no;center:yes;status=no;';
    var paramStr ="projectNo=" + application_form.projectInput.value;
    	paramStr += "&dwgNo=" + dwgCode;
    	
    var rs = window.showModalDialog("popUpProgressDwgRevisionHistoryView.do?" + paramStr, "", sProperties);
}

//lock date 정보 가져오기
function fn_setLockDate(){
	if(application_form.dwgDepartmentCode.value != ""){
		application_form.lockDate.value = "";
		$.ajax({
			url:'<c:url value="getDPProgressLockDate.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"dwg_deptcode" : application_form.dwgDepartmentCode.value},
	    	success : function(data){
	    		application_form.lockDate.value = data;
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}		
		});	
	}
}
//key event text 표시
function fn_setKeyEventText(){
	if(application_form.projectInput.value != ''){
		$.ajax({
			url:'<c:url value="getKeyEventDates.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"project_no" : application_form.projectInput.value},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		if(data != null && data != '')
	    		{
	    			application_form.keyeventCT.value = jsonData.ct == undefined ? "": jsonData.ct;
		            application_form.keyeventSC.value = jsonData.sc == undefined ? "": jsonData.sc;
		            application_form.keyeventKL.value = jsonData.kl == undefined ? "": jsonData.kl;
		            application_form.keyeventLC.value = jsonData.lc == undefined ? "": jsonData.lc;
		            application_form.keyeventDL.value = jsonData.dl == undefined ? "": jsonData.dl;	
	    		}
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}		
		});	
	}
}
//div팝업 선택 화면 Hidden
function fn_toggleDivPopUp(activeDivObj,targetObj)
{
		$(".div_popup").css("display","none");
		if(activeDivObj != null && activeDivObj != undefined){
			activeDivObj.css("left",targetObj.offset().left);
			activeDivObj.css("top",targetObj.offset().top);
			activeDivObj.css("display","");
		}
}
</script>
<script type="text/javascript">
$(document).ready(function(){
	fn_all_text_upper();
	
	$(".div_popup").focusout(function(){
		fn_toggleDivPopUp();
	});
	// 조회가능 호선관리 창을 Show
	$("#btn_project_serach_able").click(function(){
		var sProperties = 'dialogHeight:500px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
	    var paramStr = "loginID=" + application_form.loginID.value;
	    paramStr += "&category=PROGRESS";
	    
	    var rs = window.showModalDialog("popUpProgressProjectSelectMng.do?" + paramStr, "", sProperties);
	    
	    if(rs != null && rs != undefined){
	    	 var changedList = rs.split(",");
	    	 var projectListSelect = $("#projectList");
	    	 projectListSelect.empty();
	    	 projectListSelect.append("<option value=''>&nbsp;</option>");
	    	 var check = false;
	    	 for(var i = 0; i< changedList.length; i++){
	    		 var valueAry = changedList[i].split("|");
	    		 if($("#projectNo").val() == valueAry[0] && valueAry[1] != "CLOSED") check = true;
	    		 if(valueAry[1] != "CLOSED")projectListSelect.append("<option value='"+valueAry[0]+"'>"+valueAry[0]+"</option>");
	    	 }
	    	 if(!check)$("#projectNo").val("");
	    }
	});
	//실적 입력관리
	$("#btn_data_change_possible").click(function(){
		var sProperties = 'dialogHeight:550px;dialogWidth:550px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + application_form.loginID.value;
        var rs = window.showModalDialog("popUpProgressProjectDateChange.do?" + paramStr, "", sProperties);
	});
	//메뉴바 호선 선택 focus out시에 div 숨김처리
	$("#projectListDiv").focusout(function(e){
		e.preventDefault();
		e.stopPropagation();
		fn_hideProjectSel();
	});
	
	// 입력제한 관리 창을 Show
	$("#btn_input_lock").click(function(){
		var sProperties = 'dialogHeight:350px;dialogWidth:400px;scroll=no;center:yes;status=no;';
        var paramStr = "loginID=" + application_form.loginID.value;
        var rs = window.showModalDialog("popUpProgressLockControl.do?" + paramStr, "", sProperties);
	});
	var lodingBox = null;
	$("#btn_save").click(function(){
		fn_toggleDivPopUp();
		
		if($("#list_left input[name=oper][value=U]").length == 0){
			alert("저장할 데이터가 없습니다.");
			return;
		}
		
		var resultData = [];
		var url = 'progressInputMainGridSave.do';
		//form 데이터 직렬화
		var formData = fn_getFormData( '#application_form1' );
		//MST 데이터 수정된 항목 수집
		$.each($("#list_left input[name=oper][value=U]"),function(modKey,modVal){
			//MST Key Index 얻어옴
            var keyIdx = $(modVal).closest("tr").index();
			//MST 데이터 수정된 ROW 정보를 얻어옴
            var mst_tableList = $(modVal).closest("tr").find("[class*=_save_]");
			//MST ROW INDEX와 매칭되는 SUB 데이터의 ROW를 얻어옴
            var sub_tableList = $("#list_right tr:eq("+$(modVal).closest("tr").index()+")").find("[class*=_save_]");
            //Parameter를 담을 Map 및 Key Value 변수 선언
            var map = {};
            var t_key = "";
            var t_value ="";
            $.each(mst_tableList,function(mstKey,mstVal){
              //Key, Value 재 초기화
              t_key = "";
              t_value ="";
              //Key로 삼음 _save_key 에서 _save_ 제거
              t_key = $(mstVal).attr('class').replace(/.*_save_/gi,"");
               if(mstVal.tagName == 'INPUT'){
                  t_value = $(mstVal).val();
               } else{
                  t_value = $(mstVal).text();
               }
              map[t_key] = t_value;
            });
			 $.each(sub_tableList,function(mstKey,mstVal){
			  //Key, Value 재 초기화
              t_key = "";
              t_value ="";
              //Key로 삼음 _save_key 에서 _save_ 제거
              t_key = $(mstVal).attr('class').replace(/.*_save_/gi,"");
               if(mstVal.tagName == 'INPUT'){
                  t_value = $(mstVal).val();
               } else{
                  t_value = $(mstVal).text();
               }
              map[t_key] = t_value;
            });
			 //최종 데이터리스트에 추가
			 resultData.push(map);
      	});
		var dataList = { chmResultList : JSON.stringify( resultData ) };
		var parameters = $.extend( {}, dataList, formData );
		lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		$.post( url, parameters, function( data ) {
			if(lodingBox != null)lodingBox.remove();
			alert(data.resultMsg);
			if ( data.result == 'success' ) {
				$('#btn_search').click();
			}
		}, 'json' ).error( function() {
			alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
			if(lodingBox != null)lodingBox.remove();
		} );
	});
	
	
	//조회
	$("#btn_search").click(function(){
		if(application_form.projectInput.value == ""){
			alert("올바른 호선이름을 선택하십시오.");
			return;
		}
		if ((application_form.dateSelected_from.value != "" || application_form.dateSelected_to.value != "") &&
				application_form.dateCondition.value == "")
        {
            alert("검색일자에 대한 조건을 입력하십시오!");
            application_form.dateCondition.focus();
            return false;
        }
		
		if(application_form.sortType.value==null || application_form.sortType.value == "" || application_form.sortType.value == "descending"){
        	application_form.sortType.value = "ascending";
        }else if( application_form.sortType.value == "ascending"){
        	application_form.sortType.value = "descending";
        }
		//조회시 초기화
		mst_table.find("tbody").remove();
		mst_table.append("<tbody></tbody>");
		sub_table.find("tbody").remove();
		sub_table.append("<tbody></tbody>");
		
		lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
		//예외 호선
		var allDepartEditableProjects = "F1003";
		input_date = "";
		/* var currentTimeMillis = new Date().getTime(); */
		//데이터 호출 및 정리
		$.ajax({
	    	url:'<c:url value="progressInputSearch.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : $("#application_form").serialize(),
	    	dataType :'json',
	    	success : function(data){
	    		var mstRowStr = "";
	    		var subRowStr = "";
	    		// 숫자, 알파벳 확인 정규식 처리
	    		var num_check=/^[0-9]*$/;
	            var alphabat_check=/^[a-zA-Z]*$/;
	    		for(var i=0; i<data.length; i++){
	    			var rows = data[i];
	    			var isEditable = (application_form.isAdmin.value == "Y" || application_form.dwgDepartmentCode.value == rows.deptcode)? true : false;
	    			var isEditable2 = (allDepartEditableProjects.indexOf(rows.projectno) >= 0) ? true : false;
	    			mstRowStr = mstRowStr + "<tr bgcolor=\"#ffffff\"  onmouseover=\"trOnMouseOver(\'"+rows.dwgcode+"\')\">"
	    								  	+ "<td width='44' bgcolor='#eeeeee' class='_save_index'  nowrap >"+(i+1)
							    			+ "<input type='hidden' class='_save_oper' name='oper' value='R'>"
							    			+ "<input type='hidden' name='deptcode' value='"+rows.deptcode+"'>"
							    			+ "<input type='hidden' class='_save_sabun' name='sabun' value='"+rows.sabun+"'>"
							    			+ "<input type='hidden' class='_save_sub_sabun' name='sub_sabun' value='"+rows.sub_sabun+"'></td>"
							    			+ "<td width=\"50\" class='projectno _save_projectno' nowrap >"+rows.projectno+"</td>"
							    			+ "<td width=\"90\" class='deptname' nowrap >"
							    			+ "<nobr style=\"display:block; width:80; overflow:hidden; text-overflow:ellipsis; \">"+rows.deptname+"</nobr></td>"
							    			+ "<td width=\"70\" class='dwgcode _save_dwgcode' nowrap >"+rows.dwgcode+"</td>"
							    			+ "<td width=\"40\" class='dwgzone' nowrap>"+rows.dwgzone+"</td>"
							    			+ "<td width=\"27\" class='outsourcing' nowrap>"+rows.outsourcingyn+"</td>"
							    			+ "<td width=\"26\" class='outsourcing' nowrap>"+rows.outsourcing1+"</td>"
							    			+ "<td width=\"26\" class='outsourcing' nowrap>"+rows.outsourcing2+"</td>"
							    			+ "<td width=\"256\" class='dwgtitle' style=\"text-align:left;\" onmouseover=\"showhint(this, \'"+rows.dwgtitlehint+"\');\"  nowrap>"
							    			+ "<nobr style=\"display:block; width:250px; overflow:hidden; text-overflow:ellipsis;\" >"+rows.dwgtitle+"</nobr></td>";
	    			if(isEditable){
	    				mstRowStr = mstRowStr + "<td class=\"td_smallYellowBack name\" width=\"50\" onclick=\"fn_selectPartPerson(this)\" nowrap >"+rows.sabun_name+"</td>";
	    				mstRowStr = mstRowStr + "<td class=\"td_smallYellowBack name\" width=\"50\" onclick=\"fn_selectOutPartPerson(this)\" nowrap >"+rows.sub_sabun_name+"</td>";
	    			} else {
	    				mstRowStr = mstRowStr + "<td width=\"50\" class='name' nowrap >"+rows.sabun_name+"</td>";
	    				mstRowStr = mstRowStr + "<td width=\"50\" class='name' nowrap >"+rows.sub_sabun_name+"</td>";
	    			}
	    			mstRowStr = mstRowStr + "</tr>";
	    			
	    			var dtsDeployRev = "";
	                var dtsDeployDate = "";
	    			if(rows.dts_result != ""){
	    				dtsDeployRev = rows.dts_result.substring(0, rows.dts_result.indexOf(":"));
	    				if (startsWith(dtsDeployRev,"0")) dtsDeployRev = dtsDeployRev.substring(1);
	    				dtsDeployDate = rows.dts_result.substring(rows.dts_result.indexOf(":") + 1);
	    			}
	    			var dtsSelectedCase = false;
	    			if (rows.max_revision == "") dtsSelectedCase = true; 
					else if (dtsDeployRev != "") {
						if (alphabat_check.test(rows.max_revision)) {
							if (num_check.test(dtsDeployRev)) dtsSelectedCase = true;
							else if (dtsDeployRev.charAt(0) >= rows.max_revision.charAt(0)) dtsSelectedCase = true;
						}
						else if (num_check.test(rows.max_revision)) {
							var dtsDeployRevInt = isNaN(parseInt(dtsDeployRev)) ? 0 : isNaN(parseInt(dtsDeployRev));
							var deployRevInt = isNaN(parseInt(rows.max_revision)) ? 0 : isNaN(parseInt(rows.max_revision));
							if (num_check.test(dtsDeployRev) && dtsDeployRevInt >= deployRevInt) dtsSelectedCase = true;
					    }
					}
	    			if (dtsSelectedCase) { rows.max_revision = dtsDeployRev; rows.deploy_date = dtsDeployDate; }
	    			
	    			var owStartFinishEqual = rows.ow_plan_s != "" && rows.ow_plan_s == rows.ow_plan_f ? true : false;
	                var clStartFinishEqual = rows.cl_plan_s != "" && rows.cl_plan_s == rows.cl_plan_f ? true : false;
	                
	                var dwActionStartBGColor  =  isEditable == true ? "#ffffe0" : "#ffffff";
                    var dwActionFinishBGColor =  isEditable == true ? "#ffffe0" : "#ffffff";
                    var owActionStartBGColor  =  isEditable == true ? "#ffffe0" : "#ffffff";
                    var owActionFinishBGColor =  isEditable == true ? "#ffffe0" : "#ffffff";
                    var clActionStartBGColor  =  isEditable == true || isEditable2 == true ? "#ffffe0" : "#ffffff";
                    var clActionFinishBGColor =  isEditable == true || isEditable2 == true ? "#ffffe0" : "#ffffff";
                    var rfActionStartBGColor  =  isEditable == true ? "#ffffe0" : "#ffffff";
                    var wkActionStartBGColor  =  isEditable == true ? "#ffffe0" : "#ffffff";
                    
                    if (rows.dw_plan_s_o  == "Y" && rows.dw_act_s  == "") dwActionStartBGColor = "#ff0000";
                    if (rows.dw_plan_f_o == "Y" && rows.dw_act_f == "") dwActionFinishBGColor = "#ff0000";
                    if (rows.ow_plan_s_o  == "Y" && rows.ow_act_s  == "") owActionStartBGColor = "#ff0000";
                    if (rows.ow_plan_f_o == "Y" && rows.ow_act_f == "") owActionFinishBGColor = "#ff0000";
                    if (rows.cl_plan_s_o  == "Y" && rows.cl_act_s  == "") clActionStartBGColor = "#ff0000";
                    if (rows.cl_plan_f_o == "Y" && rows.cl_act_f == "") clActionFinishBGColor = "#ff0000";
                    if (rows.rf_plan_s_o  == "Y" && rows.rf_act_s  == "") rfActionStartBGColor = "#ff0000";
                    if (rows.wk_plan_s_o  == "Y" && rows.wk_act_s  == "") wkActionStartBGColor = "#ff0000";

                    
                    var STYLE_INTERFACE = "font-weight:bold;font-size:12px;";
                    
                    var dwAttr4Style = rows.dw_attribute4 == "" ? "" : STYLE_INTERFACE;
                    var dwAttr5Style = rows.dw_attribute5 == "" ? "" : STYLE_INTERFACE; 
                    var owAttr4Style = rows.ow_attribute4 == "" ? "" : STYLE_INTERFACE; 
                    var owAttr5Style = rows.ow_attribute5 == "" ? "" : STYLE_INTERFACE; 
                    var clAttr4Style = rows.cl_attribute4 == "" ? "" : STYLE_INTERFACE; 
                    var clAttr5Style = rows.cl_attribute5 == "" ? "" : STYLE_INTERFACE; 
                    var rfAttr4Style = rows.rf_attribute4 == "" ? "" : STYLE_INTERFACE; 
                    var rfAttr5Style = rows.rf_attribute5 == "" ? "" : STYLE_INTERFACE; 
                    var wkAttr4Style = rows.wk_attribute4 == "" ? "" : STYLE_INTERFACE; 
                    var wkAttr5Style = rows.wk_attribute5 == "" ? "" : STYLE_INTERFACE; 
                    
                    var activityDescBGColor1 = "#ffffff"; if ( rows.new_activity_desc1 != rows.old_activity_desc1) activityDescBGColor1 = "#33cc33";
                    var activityDescBGColor2 = "#ffffff"; if ( rows.new_activity_desc2 != rows.old_activity_desc2) activityDescBGColor2 = "#33cc33";
                    var diffDateColor = "#ffffff"; if ( rows.diff_date != "" ){
                    	var diff_dateInt = isNaN(parseInt(rows.diff_date)) ? 0 : isNaN(parseInt(rows.diff_date))
                    	if ( diff_dateInt < 0 ) diffDateColor = "#ff0000";
                    }
                    subRowStr = subRowStr + "<tr onmouseover=\"trOnMouseOver(\'"+rows.dwgcode+"\')\">"
                    			+ "<td width=\"40\" nowrap style=\"cursor:hand;\" onclick=\"fn_showDeployRevInfo(\'"+rows.dwgcode+"\');\">"+rows.max_revision+"</td>"
                    			+ "<td width=\"70\" nowrap style=\"cursor:hand;\" onclick=\"fn_showDeployRevInfo(\'"+rows.dwgcode+"\');\">"+rows.deploy_date+"</td>"
                    			+ "<td width=\"70\" class='dw_plan_s' nowrap >"+rows.dw_plan_s+"</td>";
                	if(isEditable && rows.dw_plan_s != ""){
                		subRowStr = subRowStr + "<td width=\"70\" class='dw_plan_s _save_dw_act_s' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"DW\',\'S\',\'Y\')\""
                					+ "style=\"background-color:"+dwActionStartBGColor+";"+dwAttr4Style+"\">"+rows.dw_act_s+"</td>";
                	} else {
                		 if (dwActionStartBGColor == "#ffffe0") dwActionStartBGColor = "#ffffff";
                		 subRowStr = subRowStr + "<td width=\"70\" class='dw_plan_s _save_dw_act_s' nowrap style=\"background-color:"+dwActionStartBGColor+";"+dwAttr4Style+"\">"+rows.dw_act_s+"</td>";
                	}
                	
                	subRowStr = subRowStr + "<td width=\"70\" class='dw_plan_f' nowrap >"+rows.dw_plan_f+"</td>";
                	if(isEditable && rows.dw_plan_f != ""){
                		subRowStr = subRowStr + "<td width=\"70\" class='dw_plan_f _save_dw_act_f' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"DW\',\'F\',\'Y\')\""
    								+ "style=\"background-color:"+dwActionFinishBGColor+";"+dwAttr5Style+"\">"+rows.dw_act_f+"</td>";
                	} else {
                		if (dwActionFinishBGColor == "#ffffe0") dwActionFinishBGColor = "#ffffff";
               		 	subRowStr = subRowStr + "<td width=\"70\" class='dw_plan_f _save_dw_act_f' nowrap style=\"background-color:"+dwActionFinishBGColor+";"+dwAttr5Style+"\">"+rows.dw_act_f+"</td>";
                	}
                	
                	subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_s' nowrap >"+rows.ow_plan_s+"</td>";
                	if(isEditable && rows.ow_plan_s != ""){
                		subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_s  _save_ow_act_s' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"OW\',\'S\',\'Y\')\""
						+ "style=\"background-color:"+owActionStartBGColor+";"+owAttr4Style+"\">"+rows.ow_act_s+"</td>";
                	} else {
                		if (owActionStartBGColor == "#ffffe0") owActionStartBGColor = "#ffffff";
               		 	subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_s  _save_ow_act_s' nowrap style=\"background-color:"+owActionStartBGColor+";"+owAttr4Style+"\">"+rows.ow_act_s+"</td>";
                	}
                	
                	if(owStartFinishEqual == false){
                		subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_f' nowrap >"+rows.ow_plan_f+"</td>";
                		if(isEditable && rows.ow_plan_f != ""){
                			subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_f  _save_ow_act_f' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"OW\',\'F\',\'Y\')\""
    						+ "style=\"background-color:"+owActionFinishBGColor+";"+owAttr5Style+"\">"+rows.ow_act_f+"</td>";
                		} else {
                			if (owActionFinishBGColor == "#ffffe0") owActionFinishBGColor = "#ffffff";
                   		 	subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_f  _save_ow_act_f' nowrap style=\"background-color:"+owActionFinishBGColor+";"+owAttr5Style+"\">"+rows.ow_act_f+"</td>";	
                		}
                	} else {
                		subRowStr = subRowStr + "<td width=\"70\" class='ow_plan_f  _save_ow_act_f' nowrap style=\"background-color:#dddddd;"+owAttr5Style+"\"></td>"
                		+ "<td width=\"70\" class='ow_plan_f' nowrap style=\"background-color:#dddddd;"+owAttr5Style+"\"></td>";
                	}
                	
                	subRowStr = subRowStr + "<td width=\"70\" class='cl_plan_s' nowrap >"+rows.cl_plan_s+"</td>";
                	if((isEditable || isEditable2) && rows.cl_plan_s != ""){
                		subRowStr = subRowStr + "<td width=\"70\"  class='cl_plan_s  _save_cl_act_s' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"CL\',\'S\',\'Y\')\""
						+ "style=\"background-color:"+clActionStartBGColor+";"+clAttr4Style+"\">"+rows.cl_act_s+"</td>";
                	} else {
                		if (clActionStartBGColor == "#ffffe0") clActionStartBGColor = "#ffffff";
                		subRowStr = subRowStr + "<td width=\"70\"  class='cl_plan_s  _save_cl_act_s' nowrap style=\"background-color:"+clActionStartBGColor+";"+clAttr4Style+"\">"+rows.cl_act_s+"</td>";
                	}
                	
                	if(clStartFinishEqual == false){
                		subRowStr = subRowStr + "<td width=\"70\"  class='cl_plan_f' nowrap >"+rows.cl_plan_f+"</td>";
                		if((isEditable || isEditable2) && rows.cl_plan_f != ""){
                			subRowStr = subRowStr + "<td width=\"70\" class='cl_plan_f _save_cl_act_f' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"CL\',\'F\',\'Y\')\""
    						+ "style=\"background-color:"+clActionFinishBGColor+";"+clAttr5Style+"\">"+rows.cl_act_f+"</td>";
                		} else {
                			if (clActionFinishBGColor == "#ffffe0")  clActionFinishBGColor = "#ffffff";
                			subRowStr = subRowStr + "<td width=\"70\" class='cl_plan_f _save_cl_act_f' nowrap style=\"background-color:"+clActionFinishBGColor+";"+clAttr5Style+"\">"+rows.cl_act_f+"</td>";
                		}
                	} else {
                		subRowStr = subRowStr + "<td width=\"70\" class='cl_plan_f _save_cl_act_f' nowrap style=\"background-color:#dddddd;"+owAttr5Style+"\"></td>"
                		+ "<td width=\"70\" class='cl_plan_f' nowrap style=\"background-color:#dddddd;"+owAttr5Style+"\"></td>";
                	}
                	
                	subRowStr = subRowStr + "<td width=\"70\" class='rf_plan_s' nowrap >"+rows.rf_plan_s+"</td>";
                	if(isEditable && rows.rf_plan_s != ""){
                		subRowStr = subRowStr + "<td width=\"70\" class='rf_plan_s _save_rf_act_s' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"RF\',\'S\',\'Y\')\""
						+ "style=\"background-color:"+rfActionStartBGColor+";"+rfAttr4Style+"\">"+rows.rf_act_s+"</td>";
                	} else {
                		if (rfActionStartBGColor == "#ffffe0")  rfActionStartBGColor = "#ffffff";
                		subRowStr = subRowStr + "<td width=\"70\" class='rf_plan_s _save_rf_act_s' nowrap style=\"background-color:"+rfActionStartBGColor+";"+rfAttr4Style+"\">"+rows.rf_act_s+"</td>";
                	}
                	
                	subRowStr = subRowStr + "<td width=\"70\" class='wk_plan_s' nowrap >"+rows.wk_plan_s+"</td>";
                	if(isEditable && rows.wk_plan_s != ""){
                		subRowStr = subRowStr + "<td width=\"70\"  class='wk_plan_s _save_wk_act_s' nowrap onclick=\"fn_normalDatePicker(this,\'"+rows.projectno+"\',\'"+rows.dwgcode+"WK\',\'S\',\'Y\')\""
						+ "style=\"background-color:"+wkActionStartBGColor+";"+wkAttr4Style+"\">"+rows.wk_act_s+"</td>";
                	} else {
                		if (wkActionStartBGColor == "#ffffe0")  wkActionStartBGColor = "#ffffff";
                		subRowStr = subRowStr + "<td width=\"70\"  class='wk_plan_s _save_wk_act_s' nowrap style=\"background-color:"+wkActionStartBGColor+";"+wkAttr4Style+"\">"+rows.wk_act_s+"</td>";
                	}
                	
                	subRowStr = subRowStr + "<td width=\"120\" style=\"text-align:center;\" nowrap>"
                	+ "<nobr style=\"display:block; width:110px; overflow:hidden; text-overflow:ellipsis;\" >"+rows.activitydesc1+"</nobr></td>"
                	+ "<td width=\"120\" style=\"text-align:center;\" nowrap>"
                	+ "<nobr style=\"display:block; width:110px; overflow:hidden; text-overflow:ellipsis;\" >"+rows.activitydesc2+"</nobr></td>"
                	+ "<td width=\"50\" nowrap>"+rows.plan_std+"</td>"
                	+ "<td width=\"55\" nowrap>"+rows.plan_followup+"</td>"
                	+ "<td width=\"50\" nowrap>"+rows.internal_std+"</td>"
                	+ "<td width=\"55\" nowrap>"+rows.internal_followup+"</td>"
                	+ "<td width=\"50\" nowrap>"+rows.out_std+"</td>"
                	+ "<td width=\"55\" nowrap>"+rows.out_followup+"</td>"
                	+ "<td width=\"50\" nowrap>"+rows.std_total+"</td>"
                	+ "<td width=\"55\" nowrap>"+rows.followup_total+"</td>"
                	+ "</tr>";
	    		}
	    		mst_table.append(mstRowStr);
    			sub_table.append(subRowStr);
    			
    			
    			
    			$("input[name=projectTotal]").val(data.length);
    			
    			initSetting();
	    		/* var currentTimeMillis2 = new Date().getTime();
	    		
	    		alert((currentTimeMillis2- currentTimeMillis)/1000); */
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	},
	    	complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
	    		if(lodingBox != null)lodingBox.remove();		
	    	}
	    });
	});
	initSetting();
	
	// 화면 리사즈에 따른 자동 크기 조정. data 퍼포먼스 문제로 자동 리사이즈 제거
	//$(window).bind('resize', function() {
	//	fn_contentResizeHeight();
	//});
});

function fn_tab(obj){
	$(obj).next().focus();
}

//검색시 초기화
function initSetting(){
	columnDisplay();
	fn_contentResizeHeight();
	fn_setLockDate();
	fn_setKeyEventText();
	
	if (startsWith("Z",application_form.departmentList.value))departmentPerson_Dalian("personsList", application_form.departmentList.value); 
	else { 
    	departmentPerson("personsList", application_form.departmentList.value);
    	departmentOutPerson("outsidePersonsList", application_form.departmentList.value);
   	}
}

//전체 컨텐츠 높이 리사이징
function fn_contentResizeHeight(){
	var screenWidth = $(window).width();
	var screenHeight = $(window).height()*0.7;
	/* var screenWidth = window.document.body.clientWidth;
	var screenHeight = window.document.body.clientHeight; */
	
	document.getElementById("list").height = screenHeight*0.88 + "px";
	
	if(screenWidth>2375) screenWidth = 2375;
	
	var header_left_width = parseInt(document.getElementById("td_header_no").width);
	if(document.getElementById("td_header_project").style.display 			!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_project").width);}
	if(document.getElementById("td_header_part").style.display 				!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_part").width);}
	if(document.getElementById("td_header_drawingno").style.display 		!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_drawingno").width);}
	if(document.getElementById("td_header_zone").style.display 				!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_zone").width);}
	if(document.getElementById("td_header_outsourcingplan").style.display 	!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_outsourcingplan").width);}
	if(document.getElementById("td_header_task").style.display 				!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_task").width);}
	if(document.getElementById("td_header_user").style.display 				!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_user").width);}
	if(document.getElementById("td_header_user1").style.display 				!= "none"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_user").width);}
	
	var right_width = parseInt(screenWidth) - parseInt(header_left_width);
	
	document.getElementById("header_left").style.width = parseInt(header_left_width) +"px";
	document.getElementById("header_right").style.width = (right_width - 40)+"px";
	document.getElementById("header_right").style.left 	= (parseInt(header_left_width)) + "px";
	
	document.getElementById("list_left").style.width = parseInt(header_left_width)+"px"
	document.getElementById("list_left").style.height = screenHeight*0.88 + "px";
	
	document.getElementById("list_right").style.width = (right_width - 40)+"px";
	document.getElementById("list_right").style.height	= screenHeight*0.88 + "px";
	document.getElementById("list_right").style.left 	= (parseInt(header_left_width)) + "px";
	
	var header_right_width = 0;
	for(var i = 1; i <= 27; i++){
		if(document.getElementById("area"+i).style.display 			!= "none"){header_right_width = parseInt(header_right_width) + parseInt(document.getElementById("area"+i).width);}
	}
	document.getElementById("table_header2").style.width = (header_right_width+100)+"px";
	document.getElementById("table_data2").style.width = (header_right_width+100)+"px";
	
}

function onlyUpperCase(obj) {
	obj.value = obj.value.toUpperCase();	
}

//스크롤 처리
function onScrollHandler() 
{
	header_right.scrollLeft = list_right.scrollLeft;
	list_left.scrollTop = list_right.scrollTop;
	return;
}

// 스크롤 처리
function onScrollHandler2() 
{
	header_left.scrollLeft = list_left.scrollLeft;
	list_right.scrollTop = list_left.scrollTop;
	return;
}
//검색일자 초기화
function fn_search_date_init(){
	application_form.dateSelected_from.value = '';
	application_form.dateSelected_to.value = '';
}

function startsWith(targetStr,str){
	return str.indexOf(targetStr) == 0 ? true : false;
}

function alertMsg(){
	if($("#message").val().length > 0){
		alert($("#message").val());
	}
}
//컬럼 표시 설정
function columnDisplay(){
	var temp = $("input[name=colShowCheck]");
	$.each(temp,function(key,value){
		var displayColumn = $(value).val();
		if($(value).is(":checked"))$("."+displayColumn).css("display","none");
		else $("."+displayColumn).css("display","");
	});
}

</script>
</body>
</html>
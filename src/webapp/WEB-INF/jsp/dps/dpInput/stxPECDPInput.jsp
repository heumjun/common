<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>시수입력</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		시수입력
		<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="loginID" value="${loginUser.user_id}" />
		<input type="hidden" name="isAdmin" value="${loginUserInfo.is_admin}" />
		<input type="hidden" name="isManager" value="${loginUserInfo.is_manager}" />
		<input type="hidden" name="workdaysGap" value="" />
		<input type="hidden" name="invaildProjectno" value="<c:forEach var="item" items="${invalidSelectedProjectList }" varStatus="status">
							${item.projectno }<c:if test="${!status.last }">,</c:if>
						</c:forEach>"/>
		<input type="hidden" name="inputDoneYN">
		
		<div id="searchDiv">
			<table class="searchArea conSearch" style="table-layout: auto;">
				<col width="2%"/>
				<col width="10%"/>
				<col width="2%"/>
				<col width="5%"/>
				<col width="2%"/>
				<col width="10%"/>
				<col width="2%"/>
				<col width="13%"/>
				<col width="10%"/>
				<col width="*"/>
				<tr>
					<th>부서</th>
					<td>
						<select id="departmentList" name="departmentList" onchange="fn_departmentSelChanged();">
							<c:choose>
								<c:when test="${loginUserInfo.is_admin eq 'Y' }">
									<c:forEach var="item" items="${departmentList }">
										<option value="${item.dept_code}" <c:if test="${loginUserInfo.dept_code eq item.dept_code }">selected="selected"</c:if>>${item.dept_code} ${item.dept_name}</option>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<option value="${loginUserInfo.dept_code}">${loginUserInfo.dept_code} ${loginUserInfo.dept_name}</option>
								</c:otherwise>
							</c:choose>
						</select>
					</td>
					<th>사번</th>
					<td>
						<select id="designerList" name="designerList" style="width: 130px;" onchange="fn_designerSelChanged();">
							<c:choose>
								<c:when test="${loginUserInfo.is_admin eq 'Y' }">
									<c:forEach var="item" items="${personList }">
										<option value="${item.employee_no}" <c:if test="${loginUser.user_id eq item.employee_no }">selected="selected"</c:if>>${item.employee_no} ${item.employee_name}</option>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<option value="${loginUser.user_id}" selected="selected">${loginUser.user_id} ${loginUserInfo.name}</option>
								</c:otherwise>
							</c:choose>
						</select>
					</td>
					<th>일자</th>
					<td>
						<input type="text" id="p_created_date" value="" name="dateselected" class="datepicker" style="width: 50%; text-align: center;"  readonly="readonly"/>
						<input type="text" name="workingdayYn" value="" readonly="readonly" style="background: #c8c8c4; font-weight: bold; width: 30%; text-align: center;" />
					</td>
					<th>옵션</th>
					<td> 
						호선 추가 <input type="button" name="projectsbutton" value="검 색" class="btn_gray2" style="width: 60px;" id="btn_project_no"/>
						<input type="hidden" name="projectlist" value="<c:forEach var="item" items="${selectedProjectList }" varStatus="status">
							<c:if test="${item.dl_effective eq null or item.dl_effective ne 'Y' }">Z</c:if>${item.projectno }<c:if test="${!status.last }">,</c:if>
						</c:forEach>" id="p_project_no"/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						결재 유무 <input type="text" name="mhconfirmYn" value="" readonly="readonly" style="background: #c8c8c4; font-weight: bold;" />
					</td>
					<td style="text-align: right;">
						<input type="button" value="시수체크" class="btn_gray2" id="btn_dh_view"/>
						<input type="button" value="결재체크" class="btn_gray2" id="btn_approval_view"/>
						<c:if test="${loginUserInfo.is_admin eq 'Y' }">
							<input type="button" value="시수입력LOCK" class="btn_gray2" id="btn_input_lock"/>
						</c:if>
					</td>
				</tr>
				<tr>
					<th>시수<BR>담당자 </th>
					<td colspan="7">
						한경훈 과장 (T.3220) &nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp; 김준호 과장 (T.3464) &nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp; 이재덕 과장 (T.1221)
					</td>
					<td style="text-align: right;">
						<input type="button" value="조 회" class="btn_gray2" style="width: 60px;" id="btn_search"/>
						<input type="button" value="저 장" class="btn_gray2" style="width: 60px;" id="btn_save"/>
						<input type="button" value="전체삭제" class="btn_gray2" id="btn_delete"/>
						<input type="button" value="출력 &엑셀" class="btn_gray2" onclick="printPage();"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="content" style="width: 15%; float: left; min-width: 180px;">
			<table class="insertArea">
				<tr>
					<th>A.M</th>
					<th>P.M</th>
					<th>연장</th>
				</tr>
				<tr>
					<td><input type="button" value='08:00' class="btn_gray2" style="width: 60px;" name="time0800" onclick=""/></td>
					<td><input type="button" value='13:00' class="btn_gray2" style="width: 60px;" name="time1300" onclick="timeSelected('1300');" /></td>
					<td><input type="button" value='18:30' class="btn_gray2" style="width: 60px;" name="time1830" onclick="timeSelected('1830');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='08:30' class="btn_gray2" style="width: 60px;" name="time0830" onclick="timeSelected('0830');" /></td>
					<td><input type="button" value='13:30' class="btn_gray2" style="width: 60px;" name="time1330" onclick="timeSelected('1330');" /></td>
					<td><input type="button" value='19:00' class="btn_gray2" style="width: 60px;" name="time1900" onclick="timeSelected('1900');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='09:00' class="btn_gray2" style="width: 60px;" name="time0900" onclick="timeSelected('0900');" /></td>
					<td><input type="button" value='14:00' class="btn_gray2" style="width: 60px;" name="time1400" onclick="timeSelected('1400');" /></td>
					<td><input type="button" value='19:30' class="btn_gray2" style="width: 60px;" name="time1930" onclick="timeSelected('1930');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='09:30' class="btn_gray2" style="width: 60px;" name="time0930" onclick="timeSelected('0930');" /></td>
					<td><input type="button" value='14:30' class="btn_gray2" style="width: 60px;" name="time1430" onclick="timeSelected('1430');" /></td>
					<td><input type="button" value='20:00' class="btn_gray2" style="width: 60px;" name="time2000" onclick="timeSelected('2000');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='10:00' class="btn_gray2" style="width: 60px;" name="time1000" onclick="timeSelected('1000');" /></td>
					<td><input type="button" value='15:00' class="btn_gray2" style="width: 60px;" name="time1500" onclick="timeSelected('1500');" /></td>
					<td><input type="button" value='20:30' class="btn_gray2" style="width: 60px;" name="time2030" onclick="timeSelected('2030');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='10:30' class="btn_gray2" style="width: 60px;" name="time1030" onclick="timeSelected('1030');" /></td>
					<td><input type="button" value='15:30' class="btn_gray2" style="width: 60px;" name="time1530" onclick="timeSelected('1530');" /></td>
					<td><input type="button" value='21:00' class="btn_gray2" style="width: 60px;" name="time2100" onclick="timeSelected('2100');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='11:00' class="btn_gray2" style="width: 60px;" name="time1100" onclick="timeSelected('1100');" /></td>
					<td><input type="button" value='16:00' class="btn_gray2" style="width: 60px;" name="time1600" onclick="timeSelected('1600');" /></td>
					<td><input type="button" value='21:30' class="btn_gray2" style="width: 60px;" name="time2130" onclick="timeSelected('2130');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='11:30' class="btn_gray2" style="width: 60px;" name="time1130" onclick="timeSelected('1130');" /></td>
					<td><input type="button" value='16:30' class="btn_gray2" style="width: 60px;" name="time1630" onclick="timeSelected('1630');" /></td>
					<td><input type="button" value='22:00' class="btn_gray2" style="width: 60px;" name="time2200" onclick="timeSelected('2200');" /></td>
				</tr>
				<tr>
					<td><input type="button" value='12:00' class="btn_gray2" style="width: 60px;" name="time1200" onclick="timeSelected('1200');" /></td>
					<td><input type="button" value='17:00' class="btn_gray2" style="width: 60px;" name="time1700" onclick="timeSelected('1700');" /></td>
					<td><input type="button" value='22:30' class="btn_gray2" style="width: 60px;" name="time2230" onclick="timeSelected('2230');" /></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="button" value='17:30' class="btn_gray2" style="width: 60px;" name="time1730" onclick="timeSelected('1730');" /></td>
					<td><input type="button" value='23:00' class="btn_gray2" style="width: 60px;" name="time2300" onclick="timeSelected('2300');" /></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="button" value='18:00' class="btn_gray2" style="width: 60px;" name="time1800" onclick="timeSelected('1800');" /></td>
					<td><input type="button" value='23:30' class="btn_gray2" style="width: 60px;" name="time2330" onclick="timeSelected('2330');" /></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td><input type="button" value='24:00' class="btn_gray2" style="width: 60px;" name="time2400" onclick="timeSelected('2400');" /></td>
				</tr>
				</tbody>
			</table>
			<div id="scrollDiv" style="overflow:auto; margin-top:5px;">
				<table class="insertArea" style="">
					<tr>
						<th> 1 일 이상 <font style="font-size:8pt;">[미래 일자 입력 가능]</font></th>
					</tr>
					<tr>
						<td style="text-align: center">
							<input type="button" value='년차' class="btn_blue" style="width: 100px; margin-top: 5px;" onclick="saveAsVacationOrMilitaryTraining('D17');" /> 
							<input type="button" value='특별휴가' class="btn_blue" style="width: 100px; margin-top: 5px;" onclick="saveAsVacationOrMilitaryTraining('D14');" /> 
							<input type="button" value='유급휴가' class="btn_blue" style="width: 100px; margin-top: 5px;" onclick="saveAsVacationOrMilitaryTraining('D1A');" />
							<input type="button" value='사외 협의 검토(공사관련 출장)' class="btn_blue" style="margin-top: 5px; width: 203px;" onclick="saveAsOneDayOverJobWithProject('B46');" /> 
							<input type="button" value='기술회의 및 교육(사내외)' class="btn_blue" style="margin-top: 5px; width: 203px;" onclick="saveAsOneDayOverJob('C22');;" /> 
							<input type="button" value='일반출장(기술소위원회, 세미나)' class="btn_blue" style="margin-top: 5px; width: 203px;" onclick="saveAsOneDayOverJob('C31');" /> 
							<input type="button" value='시운전' class="btn_blue" style="margin-top: 5px; width: 100px;" onclick="saveAsSeaTrial();" /> 
							<input type="button" value='예비군 훈련(9H)'class="btn_blue" style="margin: 5px 0 5px 0;width: 100px;" onclick="saveAsVacationOrMilitaryTraining('D13');" />
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="content" style="width: 85%; float: left; text-align: right;" id="dataListDiv">
				<div style="text-align: left; float: left;">
					<span id="mainHeaderText" >헤더 텍스트 들어갈 자리 </span>
					<span style="color: red;">시수 입력 해제 요청 방법 : (팀장 전결 - 유선 요청 절대 불가) EP 전자결재 -> 새기안 -> 기술부문 -> 시수입력제한해제요청서 작성</span>
				</div>
				<div><%-- <%=dateSelected%><br><%=deptName%>&nbsp;<%=designerName%>&nbsp;(결재:<%=MHConfirmYN%>) --%>
					<input type="button" value='퇴 근' class="btn_red"  onclick="finishWork();" style="width: 60px; cursor: pointer;"/>
					<input type="button" value='조 퇴' class="btn_red"  onclick="finishWorkEarly();" style="width: 60px; cursor: pointer;"/>
					<input type="button" value='시운전/숙직 후 조기퇴근(평일)' class="btn_red" onclick="finishWorkEarlyAfterSeaTrial();" style="cursor: pointer;"/>
				</div>
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
		<div class="content" style="clear: both;">
			<input type="hidden" name="drawingNo" value="" />
			<table style="margin-top:3px">
				<tr>
					<td><span style="font-size: 11pt; font-family: 돋움; font-weight: bold;"> ※ DP 공정 ※ </span>
						<table class="insertArea">
							<tr>
								<td bgcolor="deepskyblue">계획</td>
								<td><input name="dwPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="dwPlanFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owPlanFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clPlanFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="rfPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="wkPlanStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td class="td_standardBold"><input name="planMH" value="" readonly
									style="background-color: #D8D8D8; width: 80px; border: 0; color: #ff0000; font-weight: bold; text-align: center;" />
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan="2" align="center"><img src="/AddOn/DP/images/stxTemp1.jpg" /><br> <font size="2"
									face="돋움"><b>착수일</b></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font size="2" face="돋움"><b>완료일</b></font></td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp2.jpg" /><br> <font size="2" face="돋움"><b>선주승인발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp3.jpg" /><br> <font size="2" face="돋움"><b>선주승인접수</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp4.jpg" /><br> <font size="2" face="돋움"><b>선급승인발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp5.jpg" /><br> <font size="2" face="돋움"><b>선급승인접수</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp6.jpg" /><br> <font size="2" face="돋움"><b>참고용발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp7.jpg" /><br> <font size="2" face="돋움"><b>작업용발송</b></font>
								</td>
								<td align="center">
									<img src="/AddOn/DP/images/stxTemp8.jpg" /><br> <font size="2" face="돋움"><b>시수</b></font>
								</td>
							</tr>
							<tr>
								<td bgcolor="deepskyblue">실적</td>
								<td><input name="dwActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="dwActualFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="owActualFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="clActualFinish" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="rfActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td><input name="wkActualStart" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0;" /></td>
								<td class="td_standardBold">
									<input name="actualMH" value="" readonly style="background-color: #D8D8D8; width: 80px; border: 0; color: #ff0000; font-weight: bold; text-align: center;" />
								</td>
							</tr>
						</table></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div id="projectListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
    	<input type="hidden" id="targetRowId">
        <select name="projectList" id="projectList" style="width:150px;background-color:#fff0f5" onchange="fn_projectChanged(this);">
            <option value="&nbsp;"></option>
            <option value="S000">S000</option>
            <c:forEach var="item" items="${selectedProjectList }">
            	<option value="<c:if test="${item.dl_effective eq null or item.dl_effective eq 'N'}">Z</c:if>${item.projectno }">
								<c:if test="${item.dl_effective eq null or item.dl_effective eq 'N'}">Z</c:if>${item.projectno }</option>
            </c:forEach>
        </select>
    </td></tr>
    </table>
</div>
<div id="causeDepartListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="causeDepartList" id="causeDepartList" style="background-color:#fff0f5" onchange="fn_causeDepartChanged(this);">
            <option value="&nbsp;"></option>
            <c:forEach var="item" items="${causeDepartmentList }">
            	<option value="${item.dept_code }">${item.dept_code } ${item.dept_name } </option>
            </c:forEach>
        </select>
    </td></tr>
    </table>
</div>
<div id="dwgTypeListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="dwgTypeList" id="dwgTypeList" style="background-color:#fff0f5" onchange="fn_dwgTypeChanged(this);">
            <option value="&nbsp;"></option>
        </select>
    </td></tr>
    </table>
</div>
<div id="dwgCodeListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="dwgCodeList" id="dwgCodeList" style="background-color:#fff0f5" onchange="fn_dwgCodeChanged(this);">
            <option value="&nbsp;"></option>
        </select>
    </td></tr>
    </table>
</div>
<div id="shipTypeListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="shipTypeList" id="shipTypeList" style="background-color:#fff0f5" onchange="fn_shipTypeChanged(this);">
            <option value="&nbsp;"></option>
        </select>
    </td></tr>
    </table>
</div>
<div id="eventTypeListDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
	<input type="hidden" id="eventType" value=""/>
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="eventTypeList" id="eventTypeList" style="background-color:#fff0f5" onchange="fn_eventTypeChanged(this);">
            <option value="&nbsp;"></option>
        </select>
    </td></tr>
    </table>
</div>
<div id="inputDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <input type="text" id="inputText" value="" onblur="fn_inputDivOnblur(this);">
    </td></tr>
    </table>
</div>
<div id="inputWorkDescDiv" style="position:absolute;display:none; z-index: 9;" class="div_popup">
    <table cellpadding="0" cellspacing="0" style="width:100%; border-style:solid;border-width:1px;">
    <tr><td>
        <input type="text" id="inputWorkDesc" value="" onblur="fn_inputWorkDescOnblur(this);" style="width:100%;">
    </td></tr>
    </table>
</div>
<script type="text/javascript">
var prevDate = "";
var timeKeys = new Array("0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", 
		 "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", 
		 "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400");
$(document).ready(function(){
	fn_toDate("p_created_date");
	
	$( "#p_created_date" ).datepicker( {
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
		changeMonth : true,
		changeYear : true, //년변경가능
		onSelect: function( selectedDate,i) {
			prevDate = i.lastVal;
			
			fn_dateChanged();
		}
	} );
	
	$("#btn_save").click(function(){
		if (checkInputs() == false) return;

        var msg = application_form.dateselected.value + "\n\n입력한 시수를 저장하시겠습니까?";        
        if (confirm(msg)) {
        	// 결재완료 여부 체크
            if (application_form.mhconfirmYn.value == "Y") {
                alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
                return false;
            }
        	var search_date = $("#p_created_date").val().replace(/-/gi,"");
        	
			var date = new Date();
			var year  = date.getFullYear();
			var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
			var day   = date.getDate();
			if (("" + month).length == 1) { month = "0" + month; }
		    if (("" + day).length   == 1) { day   = "0" + day;   }
    
        	var sys_date =  ""+year+month+day;
        	if(parseInt(search_date) > parseInt(sys_date)){
        		alert("오늘 날짜 또는 이전 날짜를 선택하십시오.");
        		return;
        	}
            saveDPInputsProc("N");
        }
	});
	// 선택된 날짜의 입력시수를 전체삭제
	$("#btn_delete").click(function(){
		fn_toggleDivPopUp();
		 var msg = application_form.dateselected.value + "\n\n입력시수를 일괄 삭제하시겠습니까?";        
		 if (confirm(msg)) {
			// 결재완료 여부 체크
		    if (application_form.mhconfirmYn.value == "Y") {
		        alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
		        return false;
		    }
		    var dateStr = application_form.dateselected.value;
            var dateStrs = dateStr.split("-");
            var selectedDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
            var strs = application_form.workdaysGap.value.split("-");
            var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]); 
            if(application_form.isAdmin.value != 'Y'){
	            if ((selectedDate - dpInputLockDate < 0)) {
	                //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
	                
	                var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
	                alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
	                alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
	                alert(alertMsg);
	               
	                return;
	            }
            }
            /* xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=DeleteDPInputs&designerID=" + DPInputMain.designerID.value + 
                    "&dateStr=" + DPInputMain.dateSelected.value, false); */
                    
            $.ajax({
		    	url:'<c:url value="deleteDPInputs.do"/>',
		    	type:'POST',
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : {"employee_id" : application_form.designerList.value,
		    			"dateStr":application_form.dateselected.value},
		    	success : function(data){
		    		if ( data.result == 'success' ) {
						alert(data.resultMsg);
						searchGrid();
					} else {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}
		    	}, 
		    	error : function(e){
		    		alert(e);
		    	}
		    });
		 }
	});
	//조회 처리
	$("#btn_search").click(function(){
		if(searchVaildation()){
			searchGrid();	
		} else {
			return;
		}
	});
	
	//호선 검색 팝업 호출
	$("#btn_project_no").click(function() {
		if (application_form.designerList.value == "") {
			alert("설계자를 먼저 선택하십시오.");
			return;
		}
		var paramStr = "employee_id=" + application_form.designerList.value;
        
		var rs = window.showModalDialog("popUpInputProjectNModelSelectWin.do?"+paramStr, 
				window, "dialogHeight:500px;dialogWidth:500px; center:on; scroll:off; status:off");

		if(rs != null && rs != undefined){
			//호선 검색 팝업 호출이후 결과 호선 값
			$("#p_project_no").val(rs);
			application_form.invaildProjectno.value ="";
			
			$.ajax({
		    	url:'<c:url value="getInvalidSelectedProjectList.do"/>',
		    	type:'POST',
		    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		    	data : {"employee_id" : application_form.designerList.value},
		    	success : function(data){
		    		var jsonData = JSON.parse(data);
		    		for(var i=0; i<jsonData.rows.length; i++){
		    			var rows = jsonData.rows[i];
		    			application_form.invaildProjectno.value +=rows.project_no;
		    			application_form.invaildProjectno.value +=",";
		    		}
		    	}, 
		    	error : function(e){
		    		alert(e);
		    	}
		    });
		}
	});
	// 시수입력 LOCk 관리화면 팝업
	$("#btn_input_lock").click(function(){
		var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;status=no;';
		var rs = window.showModalDialog("popUpInputLockControlView.do",window, sProperties);
	});
	$(".div_popup").focusout(function(){
		fn_toggleDivPopUp();
	});
	//결재 체크
	$("#btn_approval_view").click(function(){
		if (application_form.designerList.value == "") {
			alert("조회할 설계자를 먼저 선택하십시오.");
			return;
		}
		
		var sProperties = 'dialogHeight:540px;dialogWidth:500px;scroll=no;center:yes;resizable=no;status=no;';
		var designerSplit = $.trim($("#designerList option:selected").text()).split(" ")
		
		var paramObj = new function() {
			this.window = window;
            this.designerId = designerSplit[0];
            this.designerName = designerSplit[1];
            this.startDate = "none";
            this.endDate = "none";
        }
		var rs = window.showModalDialog("popUpDesignApprovalViewWin.do",paramObj, sProperties);

		if(rs != null && rs != undefined){
		}
	});
	//시수체크 
	$("#btn_dh_view").click(function(){
		if (application_form.departmentList.value == "" || application_form.designerList.value == "") {
			alert("조회할 부서와 설계자를 먼저 선택하십시오.");
			return;
		}
		var sProperties = 'dialogHeight:600px;dialogWidth:1200px;scroll=no;center:yes;resizable=no;status=no;';
		var rs = window.showModalDialog("popUpDesignHoursViewWin.do",window, sProperties);

		if(rs != null && rs != undefined){
		}
	});
});
</script>
<script type="text/javascript">
//프린트(리포트 출력)
function printPage()
{
	// TEST는 STXDPDEV/WebReport.jsp로 잡아줘야할듯. 141219 KSJ
    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInput.mrd&param="+application_form.designerList.value +":::"+application_form.dateselected.value;
    //var urlStr = "http://172.16.2.13:7777/j2ee/STXDPDEV/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDPDPDEV/mrd/stxPECDPInput.mrd&param="+application_form.designerList.value +":::"+application_form.dateselected.value+";";
    window.open(urlStr, "", "");
}
//1 일 이상(호선선택 없음) - 년차, 특별휴가, 예비군훈련
function saveAsVacationOrMilitaryTraining(opCode) {
	var sProperties = 'dialogHeight:300px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
	var paramStr = "opCode="+opCode;
	var rs = window.showModalDialog("popUpInputVacationPeriodSelect.do?"+paramStr,window, sProperties);
	if(rs != null && rs != undefined){
		// TODO 과거 또는 오늘 날짜인 경우 다른 입력항목과의 충돌 여부
        //      미래인 경우에도 시운전, 기 입력된 특별휴가 등 다른 입력항목과의 충돌 여부
        // 시작일이 일주일 이내에 해당하는지 체크
        var tempStrs = rs.split("~");
        var fromDateStr = tempStrs[0];
        var toDateStr = tempStrs[1];
        var jobDescStr = "";
        if (opCode == "D13") jobDescStr = "예비군훈련";
        else if (opCode =="D14") jobDescStr = "특별휴가";
        else if (opCode == "D17") jobDescStr = "년차";
        else if (opCode == "D1A") jobDescStr = "유급휴가";
        
        var today = new Date();
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2] - 30); // 시작일에서 7을 뺀 날짜(7일 전)
        if (fromDate - today > 0) {
            alert(jobDescStr + " 시작일자는 오늘로부터 한달 이내여야 합니다!");
            return;
        }
     	// 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
        fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
        var strs = application_form.workdaysGap.value.split("-");
        var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
        if(application_form.isAdmin.value != 'Y'){
        	if ((fromDate - dpInputLockDate < 0)) {
        		 var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                 alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                 alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                 alert(alertMsg);

                 return;
        	}
        }
     	// 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = '';
       	$.ajax({
	       	url:'<c:url value="getDesignMHConfirmExist.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"employee_id" : application_form.designerList.value,
	       			"from_date":fromDateStr,
	       			"to_date":toDateStr},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		confirmExist = jsonData.confirm_exist;
	       	}, 
	       	error : function(e){
	       		alert(e);
	       	}
        });
        if (confirmExist == "Y") {
            alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
            return;
        }
     	// 저장여부 확인 & 저장
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "을(를) 적용하시겠습니까?";        
        if (confirm(msg)) 
        {
        	$.ajax({
            	url:'<c:url value="saveAsOneDayOverJobDPInputs.do"/>',
            	type:'POST',
            	async: false,
            	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            	data : {"employee_id" : application_form.designerList.value,
            			"from_date":fromDateStr,
            			"to_date":toDateStr,
            			"workContent":jobDescStr,
            			"opCode":opCode},
            	success : function(data){
            		if (data == "0") alert("적용된 일자가 없습니다!");
                    else alert("정상적으로 적용되었습니다!");
            		$("#btn_search").click();
            	}, 
            	error : function(e){
            		alert(e);
            	}
            });
        }
	}
}
// 1 일 이상(호선선택 없음) - 기술회의 및 교육, 일반출장 
function saveAsOneDayOverJob(opCode) {
	//메인구현됨
	var sProperties = 'dialogHeight:250px;dialogWidth:430px;scroll=no;center:yes;resizable=no;status=no;';
	var paramStr = "opCode="+opCode;
	var rs = window.showModalDialog("popUpInputOneDayOverJobPeriodSelect.do?"+paramStr,window, sProperties);
	if(rs != null && rs != undefined){
		// TODO 과거 또는 오늘 날짜인 경우 다른 입력항목과의 충돌 여부
        //      미래인 경우에도 시운전, 기 입력된 특별휴가 등 다른 입력항목과의 충돌 여부

        // 시작일이 일주일 이내에 해당하는지 체크
        var tempStrs = rs.split("¸");
        var fromDateStr = tempStrs[0];
        var toDateStr = tempStrs[1];
        var workContentStr = tempStrs[2];
        
     	// 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
     	// 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
        var strs = application_form.workdaysGap.value.split("-");
        var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
        if(application_form.isAdmin.value != 'Y'){
        	if ((fromDate - dpInputLockDate < 0)) {
        		 var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                 alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                 alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                 alert(alertMsg);

                 return;
        	}
        }
     	// 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = '';
       	$.ajax({
	       	url:'<c:url value="getDesignMHConfirmExist.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"employee_id" : application_form.designerList.value,
	       			"from_date":fromDateStr,
	       			"to_date":toDateStr},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		confirmExist = jsonData.confirm_exist;
	       	}, 
	       	error : function(e){
	       		alert(e);
	       	}
        });
        if (confirmExist == "Y") {
            alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
            return;
        }

        var jobDescStr = "?????";
        if (opCode == "C22") jobDescStr = "기술회의 및 교육(사내외)";
        else if (opCode == "C31") jobDescStr = "일반출장(기술소위원회, 세미나)";
     	
        // 저장여부 확인 & 저장
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "을(를) 적용하시겠습니까?"; 
        if (confirm(msg)) 
        {
	        $.ajax({
	        	url:'<c:url value="saveAsOneDayOverJobDPInputs.do"/>',
	        	type:'POST',
	        	async: false,
	        	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	        	data : {"employee_id" : application_form.designerList.value,
	        			"from_date":fromDateStr,
	        			"to_date":toDateStr,
	        			"workContent":workContentStr,
	        			"opCode":opCode},
	        	success : function(data){
	        		if (data == "0") alert("적용된 일자가 없습니다!");
	                else alert("정상적으로 적용되었습니다!");
	        		$("#btn_search").click();
	        	}, 
	        	error : function(e){
	        		alert(e);
	        	}
	        });
        }
	}
	
}

// 1 일 이상(호선선택 포함) - 사외 협의 검토
function saveAsOneDayOverJobWithProject(opCode) {
	//메인구현됨
	 var sProperties = 'dialogHeight:250px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
	 var paramStr = "employee_id=" + application_form.designerList.value;
	 paramStr += "&opCode=" + opCode;
	 var rs = window.showModalDialog("popUpInputOneDayOverJobPeriodSelectPjt.do?"+paramStr,window, sProperties);
	 if(rs != null && rs != undefined){
		// 시작일이 일주일 이내에 해당하는지 체크
        var tempStrs = rs.split("¸");
        var projectNo = tempStrs[0];
        var fromDateStr = tempStrs[1];
        var toDateStr = tempStrs[2];
        var workContentStr = tempStrs[3];
        
     	// 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
        var strs = application_form.workdaysGap.value.split("-");
        var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
        
        if(application_form.isAdmin.value != 'Y'){
        	if ((fromDate - dpInputLockDate < 0)) {
        		 var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                 alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                 alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                 alert(alertMsg);

                 return;
        	}
        }
     	// 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = '';
       	$.ajax({
	       	url:'<c:url value="getDesignMHConfirmExist.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"employee_id" : application_form.designerList.value,
	       			"from_date":fromDateStr,
	       			"to_date":toDateStr},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		confirmExist = jsonData.confirm_exist;
	       	}, 
	       	error : function(e){
	       		alert(e);
	       	}
        });
        if (confirmExist == "Y") {
            alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
            return;
        }
        
        var jobDescStr = "?????";
        if (opCode == "B46") jobDescStr = "사외 협의 검토(공사관련 출장)";

        // 저장여부 확인 & 저장
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "을(를) 적용하시겠습니까?";        
        if (confirm(msg)) 
        {
	        $.ajax({
	        	url:'<c:url value="saveAsOneDayOverJobWithProjectDPInputs.do"/>',
	        	type:'POST',
	        	async: false,
	        	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	        	data : {"employee_id" : application_form.designerList.value,
	        			"projectNo" : projectNo,
	        			"from_date":fromDateStr,
	        			"to_date":toDateStr,
	        			"workContent":workContentStr,
	        			"opCode":opCode},
	        	success : function(data){
	        		if (data == "0") alert("적용된 일자가 없습니다!");
	                else alert("정상적으로 적용되었습니다!");
	        		$("#btn_search").click();
	        	}, 
	        	error : function(e){
	        		alert(e);
	        	}
	        });
        }
        
	 }
}

// 퇴근
function finishWork() {
	if (!isInvalidConditions()) {
		var rows = $( "#dataList" ).getDataIDs();
		if(rows.length == 1){
			alert("08:00 에는 퇴근코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
			return;
		}
		var lastRowData = $('#dataList').jqGrid('getRowData', rows[rows.length-1]);
		var lastRowDataTime = parseInt(lastRowData.start_time.replace(":",''));
		
		if(lastRowDataTime < 1800 && application_form.workingdayYn.value == '평일'){
			alert("18:00 전에는 퇴근코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
            return;
		}
		if(lastRowDataTime < 1200 && application_form.workingdayYn.value == '4H'){
			alert("12:00 전에는 퇴근코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
            return;
		}
		
		var inputExist = false;
		if(lastRowData.project_no == '') lastRowData.project_no = 'S000';
		if(lastRowData.project_no != '' && lastRowData.project_no != 'S000')inputExist = true;
		if(!inputExist && lastRowData.op_code != '' && lastRowData.op_code != 'D1Z') inputExist = true;
		if (inputExist) {
            alert("퇴근 시각을 먼저 선택한 후 퇴근을 적용하십시오.");
            return;
        } else {
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'project_no', 'S000');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'dwg_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'dwg_code', '*****');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'op_code', 'D1Z');//90 : 퇴근
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'cause_depart', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'basis', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'basis_display', '&nbsp;');
        	if(lastRowData.work_desc == '')$('#dataList').jqGrid('setCell',rows[rows.length-1], 'work_desc', '퇴근');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event1', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event2', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event3', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'ship_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'oper', 'U');
        }
		
		if (checkInputs() == false) return;
		
		// 저장여부 확인 & 저장
        var msg = application_form.dateselected.value + "\n\n시수를 저장 & 확정하시겠습니까?";        
        if (confirm(msg)) {
			var search_date = $("#p_created_date").val().replace(/-/gi,"");
        	
			var date = new Date();
			var year  = date.getFullYear();
			var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
			var day   = date.getDate();
			if (("" + month).length == 1) { month = "0" + month; }
		    if (("" + day).length   == 1) { day   = "0" + day;   }
    
        	var sys_date =  ""+year+month+day;
        	if(parseInt(search_date) > parseInt(sys_date)){
        		alert("오늘 날짜 또는 이전 날짜를 선택하십시오.");
        		return;
        	}
            saveDPInputsProc("Y");
        }
	}
}
//시수입력 사항의 Validation Check...
function checkInputs()
{
	// 결재완료 여부 체크
    if (application_form.mhconfirmYn.value == "Y") {
        alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
        return false;
    }
 // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
    var dateStr = application_form.dateselected.value;
    var dateStrs = dateStr.split("-");
    var selectedDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
    var strs = application_form.workdaysGap.value.split("-");
    var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
    
    if(application_form.isAdmin.value != 'Y'){
    	if ((selectedDate - dpInputLockDate < 0)) {
    		 var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
             alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
             alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
             alert(alertMsg);

             return false;
    	}
    }
    // 필수입력 항목 입력 여부 체크
    var rows = $( "#dataList" ).getDataIDs();
    for(var i = 0; i < rows.length; i++){
    	var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
    	
    	var pjt = rowData.project_no;
        var drwNo = rowData.dwg_code;
        var op = rowData.op_code
        var workContent = rowData.work_desc;
        var event1Value = rowData.event1;
        var event2Value = rowData.event2;
        var event3Value = rowData.event3;
        
        var errKey = "";
        var idx = $("#"+rows[i]+" td:first-child").text();

        if (pjt == '') errKey = "공사번호";
        if (errKey == '' && drwNo == '')  errKey = "도면번호";
        if (errKey == '' && op == '') errKey = "OP 코드";
        if (errKey == '' && (op == '20' || op.substring(0, 2) == 'A2')) { 
            var depart = rowData.cause_depart;
            var basis = rowData.basis;

            if (op != '20' && depart == '') errKey = "원인부서";
            if (errKey == '' && basis == '') errKey = "근거";
        }
        //if (errKey == '' && workContent == '') errKey = "업무내용";
        // Multi 공사번호(호선)이 선택된 경우도 EVENT1 체크안함
        if (errKey == '' && pjt != 'S000' && pjt != 'PS0000' && pjt != 'V0000' && drwNo != "*****" && drwNo != "#####" 
            && op != "B53" && op != "D15" && (!pjt.indexOf(",") > -1) && event1Value == "") errKey = "Event1";

        if (errKey != "") {
            alert("No." + idx + "번째 항의 " + errKey + "이(가) 입력되지 않았습니다.\n\n입력사항을 다시 한번 확인해 주시기 바랍니다.");
            return false;
        }
        
        if (event1Value == '(선택안함)') event1Value = '';
        if ((event1Value == "" && (event2Value != "" || event3Value != "")) || (event2Value == "" && event3Value != "")) {
            alert("No." + idx + "번째 항의 Event 입력 위치가 올바르지 않습니다!\n\nEvent1, 2, 3 순서로 입력해 주십시오.");
            return false;
        }

        if (event1Value != "" && (event1Value == event2Value || event1Value == event3Value || (event2Value != "" 
                                                                                               && (event2Value == event3Value)))) {
            alert("No." + idx + "번째 항의 Event 입력 값이 중복되었습니다!\n\n입력사항을 다시 한번 확인해 주시기 바랍니다.");
            return false;
        }
        // op code가 도면시수(A type)인데 도면 번호가 없거나 '*****' 이면 에러            
        if(op.substring(0, 1) == 'A' && (drwNo == '' || drwNo == '*****') && pjt != 'S000' && pjt != 'PS0000')
        {
            alert("No." + idx + "번째 항의 도면 번호가 없습니다!\n\nOP CODE가 도면시수(A type)일 경우 도면번호가 필수입니다.");
            return false;            
        }
    }
    return true;
}
// 조퇴
function finishWorkEarly() {
	if (!isInvalidConditions()) {
		if (application_form.workingdayYn.value == "휴일") {
			alert("조퇴 등록은 평일인 경우에만 가능합니다.");
			return;
		}
		
		//메인구현됨
		var rows = $( "#dataList" ).getDataIDs();
		if(rows.length == 1){
			alert("08:00 에는  조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
			return;
		}
		var lastRowData = $('#dataList').jqGrid('getRowData', rows[rows.length-1]);
		var lastRowDataTime = parseInt(lastRowData.start_time.replace(":",''));
		
		if(lastRowDataTime > 1800 && application_form.workingdayYn.value == '평일'){
			alert("18:00 이후에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
            return;
		}
		if(lastRowDataTime > 1200 && application_form.workingdayYn.value == '4H'){
			 alert("12:00 이후에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
            return;
		}
		if(lastRowDataTime < 1000){
			alert("10:00 전에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
           return;
		}
		var inputExist = false;
		if(lastRowData.project_no == '') lastRowData.project_no = 'S000';
		if(lastRowData.project_no != '' && lastRowData.project_no != 'S000')inputExist = true;
		if(!inputExist && lastRowData.op_code != '' && lastRowData.op_code != 'D16') inputExist = true;
		if (inputExist) {
			alert("조퇴 시각을 먼저 선택한 후 조퇴를 적용하십시오.");
            return;
        }else {
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'project_no', 'S000');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'dwg_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'dwg_code', '*****');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'op_code', 'D16');//90 : 퇴근
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'cause_depart', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'basis', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'basis_display', '&nbsp;');
        	if(lastRowData.work_desc == '')$('#dataList').jqGrid('setCell',rows[rows.length-1], 'work_desc', '조퇴');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event1', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event2', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event3', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'ship_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'oper', 'U');
        }
		if (checkInputs() == false) return;
		
		// 저장여부 확인 & 저장
        var msg = application_form.dateselected.value + "\n\n시수를 저장 & 확정하시겠습니까?";        
        if (confirm(msg)) {
			var search_date = $("#p_created_date").val().replace(/-/gi,"");
        	
			var date = new Date();
			var year  = date.getFullYear();
			var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
			var day   = date.getDate();
			if (("" + month).length == 1) { month = "0" + month; }
		    if (("" + day).length   == 1) { day   = "0" + day;   }
    
        	var sys_date =  ""+year+month+day;
        	if(parseInt(search_date) > parseInt(sys_date)){
        		alert("오늘 날짜 또는 이전 날짜를 선택하십시오.");
        		return;
        	}
            saveDPInputsProc("Y");
        }
	}
}

// 시운전
function saveAsSeaTrial() {
	//메인구현됨
	// 시운전은 DP_MAIN 부분 코드에서 제약조건 체크함
	
	var sProperties = 'dialogHeight:250px;dialogWidth:500px;scroll=no;center:yes;resizable=yes;status=no;';
	var paramStr = "employee_id="+application_form.designerList.value;
    var rs = window.showModalDialog("popUpInputSeaTrialPeriodSelect.do?"+paramStr, window, sProperties);
	
    if(rs != null && rs != undefined){
    	var tempStrs = rs.split("~");
        var projectNo = tempStrs[0];
        var tempStrs2 = tempStrs[1].split("|");
        var fromDate = tempStrs2[0];
        var fromTime = tempStrs2[1];
        tempStrs2 = tempStrs[2].split("|");
        var toDate = tempStrs2[0];
        var toTime = tempStrs2[1];
        var fromTimeStr = fromTime.substring(0, 2) + ":" + fromTime.substring(2, 4);
        var toTimeStr = toTime.substring(0, 2) + ":" + toTime.substring(2, 4);
        
        var strs = application_form.workdaysGap.value.split("-");
        var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
        strs = fromDate.split("-");
        var seaTrialFromDate = new Date(strs[0], strs[1] - 1, strs[2]);
        
        if(application_form.isAdmin.value != 'Y'){
        	 if ((seaTrialFromDate - dpInputLockDate < 0)) {
        		 var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                 alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                 alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                 alert(alertMsg);
                
                 return;
        	}
        }
     	// 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = '';
       	$.ajax({
	       	url:'<c:url value="getDesignMHConfirmExist.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"employee_id" : application_form.designerList.value,
	       			"from_date":fromDate,
	       			"to_date":toDate},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		confirmExist = jsonData.confirm_exist;
	       	}, 
	       	error : function(e){
	       		alert(e);
	       	}
        });
        if (confirmExist == "Y") {
            alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
            return;
        }
     	// TODO 시운전 해당일(들)이 과거인 경우에 대한 처리를 추가(+ 특별휴가 부분의 to-do 리스트도 참고)
        //      시운전 해당일(들)의 유효한 범위 설정 필요: 예, 오늘 +/- 몇일 이내 


        // [시운전일 기준시수]
        // 평일 - 21:00 이전 종료: Overtime 3 시간으로 처리 
        // 평일 - 21:00 후 종료: 해당 시각까지 Overtime 처리
        // 휴일 - 17:00 이전 종료: Special-time 8 시간으로 처리
        // 휴일 - 17:00 후 종료: 해당 시각까지 Special-time 처리
        // 4H   - 16:00 이전 종료: Overtime 3 시간으로 처리
        // 4H   - 16:00 후 종료: 해당 시각까지 Overtime 처리


        // 시운전 시작일자가 화면 표시일자와 동일하면 화면에 입력된 사항과 충돌되는 것이 없는지 체크
        if (application_form.dateselected.value == fromDate) 
        {
        	// 시운전 시작시간 이후 시간대에 입력항목이 있는지 체크... 있으면 오류 => TODO Warning 출력 후 사용자가 선택하도록 변경할 것
            var b = true;
            var rows = $( "#dataList" ).getDataIDs();
        	for(var i = 0; i < rows.length; i++){
        		var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
        		if(parseInt(fromTime) < parseInt(rowData.start_time.replace(":",""))){
        			b = true;
        			break;
        		} else {
        			b = false;
        		}
        	}
            if (b) {
                var msg = "시운전 시작시간 이후 시간대에 입력사항이 있습니다.\n\n" + 
                          "해당 입력사항들을 제거한 후 시운전을 선택하십시오.";
                alert(msg);
                return;
            }
         	// 시운전 시작일이 화면 표시일자와 동일하면 화면을 업데이트 후 화면입력사항을 기준으로 시수를 저장(시운전 시작시간에 시운전코드 적용)
         	var addRowId = $.jgrid.randId();
            if (fromTime != "0800"){
            	var addTime = fromTime.substring(0,2)+":"+fromTime.substring(2,4);
            	var addData = {"start_time" : addTime, "oper" : 'U','event1':' ' };
        		$("#dataList").jqGrid('addRowData', addRowId, addData, 'last');
            } else {
            	addRowId = rows[0]; 
            	var addTime = fromTime.substring(0,2)+":"+fromTime.substring(2,4);
            }
            $('#dataList').jqGrid('setCell',addRowId, 'project_no', projectNo);     
        	$('#dataList').jqGrid('setCell',addRowId, 'dwg_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'dwg_code', '*****');
        	$('#dataList').jqGrid('setCell',addRowId, 'op_code', 'B53');//45 : 시운전
        	$('#dataList').jqGrid('setCell',addRowId, 'cause_depart', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'basis', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'work_desc', '시운전');
        	$('#dataList').jqGrid('setCell',addRowId, 'event1', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'event2', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'event3', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'ship_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',addRowId, 'oper', 'U');
        	
        	
        	// 시작일의 평일, 휴일, 4H 구분
            var workingDayYN = application_form.workingdayYn.value; 
            if (workingDayYN == '평일') workingDayYN = 'Y'; 
            else if (workingDayYN == '4H') workingDayYN = '4H'; 
            else workingDayYN = 'N';
            
         	// 시운전 시작일이 화면 표시일자와 동일하고, 시운전 시작일 == 종료일이면 종료관련 항목도 화면에 추가한다 
            // 종료시각이 시운전 기준시수 이내이면 '시운전'으로 시수 적용, 기준시수를 넘으면 종료시각에 퇴근코드 적용
            
            if (fromDate == toDate) {
                var index;
                for (var i = 0; i < timeKeys.length; i++) {
                    if (timeKeys[i] == toTime) {
                        index = i; 
                        break;
                    }
                }
                if ((workingDayYN == "Y" && index > 26) || (workingDayYN == "N" && index > 18) || (workingDayYN == "4H" && index > 16)) {
                	addRowId = $.jgrid.randId();
                	var addTime = toTime.substring(0,2)+":"+toTime.substring(2,4);
                	var addData = {"start_time" : addTime, "oper" : 'U','event1':' ' };
            		$("#dataList").jqGrid('addRowData', addRowId, addData, 'last');
            		$('#dataList').jqGrid('setCell',addRowId, 'project_no', 'S000');     
                	$('#dataList').jqGrid('setCell',addRowId, 'dwg_type', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'dwg_code', '*****');
                	$('#dataList').jqGrid('setCell',addRowId, 'op_code', 'D1Z');//90 : 퇴근
                	$('#dataList').jqGrid('setCell',addRowId, 'cause_depart', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'basis', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'basis_display', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'work_desc', '퇴근');
                	$('#dataList').jqGrid('setCell',addRowId, 'event1', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'event2', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'event3', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'ship_type', '&nbsp;');
                	$('#dataList').jqGrid('setCell',addRowId, 'oper', 'U');
                }
            }
         	// 입력 누락사항 체크
            if (checkInputs() == false) return;

            // 저장여부 확인
            var msg = "[" + fromDate + "] " + fromTimeStr + " ~ [" + toDate + "] " + toTimeStr + "\n\n시운전을 저장 & 확정하시겠습니까?";        
            if (!confirm(msg)) return;
          
            saveDPInputsProc("Y");
        }
        // 시운전 시작일자가 화면 표시일자와 동일하지 않으면 해당일 시수를 무조건 Clear 후 시운전 시수를 저장
        else {
        	 // 시운전 시작일자가 화면 표시일자와 동일하지 않으면 시작시간을 08:00로 제한
            if (fromTime != "0800") {
                var msg = "시운전 시작일자가 화면에 표시된 현재 일자와 다른 경우에는\n\n" + 
                          "시운전 시작시간을 08:00로 지정하시기 바랍니다.";
                alert(msg);
                return;
            }
            $.ajax({
            	url:'<c:url value="saveSeaTrialDPInputs.do"/>',
            	type:'POST',
            	async: false,
            	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            	data : {"employee_id" : application_form.designerList.value,
            			"dateStr": fromDate,
            			"project_no":projectNo},
            	success : function(data){
            	}, 
            	error : function(e){
            		alert(e);
            		return;
            	}
            }); 	
        }
     	// 시운전 시작일 <> 종료일: 시작일과 종료일 사이의 일자들 - 시운전 기준시수의 '시운전 코드'로 처리
     	var check_return = false;
        if (fromDate != toDate) {
        	 var dateString = fromDate;
        	 while (true) {
       		 	var strs = dateString.split("-");
                var dateObject = new Date(strs[0], eval(strs[1] + "-1"), eval(strs[2] + " +1"));
                
                var y = dateObject.getFullYear().toString();
                var m = (dateObject.getMonth() + 1).toString();
                if (m.length == 1) m = 0 + m;
                var d = dateObject.getDate().toString();
                if (d.length == 1) d = 0 + d;
                
                var nextDate = y + "-" + m + "-" + d;
                if (nextDate == toDate) break;
                var check = false; 
                $.ajax({
                 	url:'<c:url value="saveSeaTrialDPInputs.do"/>',
                 	type:'POST',
                 	async: false,
                 	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                 	data : {"employee_id" : application_form.designerList.value,
                 			"dateStr": nextDate,
                 			"project_no":projectNo},
                 	success : function(data){
                 		check = true;
                 	}, 
                 	error : function(e){
                 		alert(e);
                 		alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                 		check = false;
                 	}
                 });
                 if(!check) break;
                 dateString = nextDate;
                 check_return = check;
        	 }
        	 if(!check_return) return;
        	 // 시운전 시작일 <> 종료일: 종료일 
             //      - 평일: 종료시각이 18:00 이전이면 '시운전 후 조기퇴근'(9H)으로 처리
             //      - 평일: 종료시각이 18:00 후이면 시운전 + 퇴근으로 처리(해당 시각까지)
             //      - 4H: 종료시각이 12:00 이전이면 '시운전 후 조기퇴근'(4H)으로 처리
             //      - 4H: 종료시각이 12:00 후이면 시운전 + 퇴근으로 처리(해당 시각까지)
             //      - 휴일: 시운전 + 퇴근으로 처리(종료시각까지 특근 처리)
              if (fromDate != toDate) {
            	  
            	  $.ajax({
                 	url:'<c:url value="getDateHolidayInfo.do"/>',
                 	type:'POST',
                 	async: false,
                 	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                 	data : {"selectDate" : toDate},
                 	success : function(data){
                 		workingDayYN = data;
                 	}, 
                 	error : function(e){
                 		alert(e);
                 		return;
                 	}
                 }); // 해당일(종료일)의 평일,휴일,4H 여부 쿼리
                 
                 var timeIndex;
                 for (var i = 0; i < timeKeys.length; i++) { 
                     if (timeKeys[i] == toTime) { timeIndex = i;  break; }
                 }
                 var finishEarlyYN = true;
                 if (workingDayYN == "Y" && timeIndex > 20) finishEarlyYN = false; // 평일 18:00 후는 Overtime (시운전 후 조기퇴근 대상 X)
                 else if (workingDayYN == "4H" && timeIndex > 8) finishEarlyYN = false; // 4H 12:00 후는 Overtime (시운전 후 조기퇴근 대상 X)
                 else if (workingDayYN == "N") finishEarlyYN = false; // 휴일은 모든 경우에 시운전 후 조기퇴근 대상 X
                 
                 // 08:00 시각에 시운전 코드 적용
                 var paramAry = [];
                 var params = {};
                 params["employee_id"] = application_form.designerList.value;
                 params["dateStr"] = toDate;
                 params["timeKey"] = '0800';
                 params["projectNo"] = projectNo;
                 params["dwgType"] = '';
                 params["dwgCode"] = '*****';
                 params["opCode"] = 'B53';
                 params["causeDepart"] = '';
                 params["basis"] = '';
                 params["workDesc"] = '시운전';
                 params["event1"] = '';
                 params["event2"] = '';
                 params["event3"] = '';
                 params["inputDoneYN"] = 'Y';

                 var worktimeTotal = 0;
                 for (var i = 1; i <= timeIndex; i++) {
                     if (timeKeys[i] == "1230" || timeKeys[i] == "1300") continue; 
                     worktimeTotal += 0.5;
                 }
                 
              	// 시운전 후 조기퇴근에 해당이 아니면 종료시각에 퇴근 코드 적용
                 if (!finishEarlyYN) 
                 {
                     if (workingDayYN == "N" && timeIndex == 0) {  } // 휴일이고 08:00에 종료되었으면 Skip
                     else 
                     {
                 
                         var normalTime = 0;
                         var overtime = 0;
                         var specialTime = 0;

                         if (workingDayYN == "Y") {
                             normalTime = 9;
                             overtime = worktimeTotal - 9;
                         }
                         else if (workingDayYN == "4H") {
                             normalTime = 4;
                             overtime = worktimeTotal - 4;
                         }
                         else specialTime = worktimeTotal;
						
                         params["normalTime"] = normalTime+'';
                         params["overtime"] = overtime+'';
                         params["specialTime"] = specialTime+'';
                         paramAry.push(params);
                         
                         params = {};
                         
                         params["employee_id"] = application_form.designerList.value;
                         params["dateStr"] = toDate;
                         params["timeKey"] = toTime;
                         params["projectNo"] = 'S000';
                         params["dwgType"] = '';
                         params["dwgCode"] = '*****';
                         params["opCode"] = 'D1Z';
                         params["causeDepart"] = '';
                         params["basis"] = '';
                         params["workDesc"] = '퇴근';
                         params["event1"] = '';
                         params["event2"] = '';
                         params["event3"] = '';
                         params["normalTime"] = '0';
                         params["overtime"] = '0';
                         params["specialTime"] = '0';
                         params["inputDoneYN"] = 'Y';
                         
                         paramAry.push(params);
                         
                         $.ajax({
                          	url:'<c:url value="saveDPInputs.do"/>',
                          	type:'POST',
                          	async: false,
                          	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                          	data : {"param":JSON.stringify(paramAry)},
                          	success : function(data){
                          		alert("저장성공");
                          		return;
                          	}, 
                          	error : function(e){
                          		alert("저장에 실패하였습니다.");
                          		return;
                          	}
                          });
                     }
                 }
              	// 시운전 후 조기퇴근으로 적용
                 else {
                	 var normalTime = 0;

                     if (timeIndex != 0) {
                         if (workingDayYN == "Y") normalTime = worktimeTotal;
                         else if (workingDayYN == "4H") normalTime = worktimeTotal;
                         
                         params["normalTime"] = normalTime+'';
                         params["overtime"] = '0';
                         params["specialTime"] = '0';
                         paramAry.push(params);
                         
                         params = {};

                         if (workingDayYN == "Y") normalTime = 9 - worktimeTotal;
                         else if (workingDayYN == "4H") normalTime = 4 - worktimeTotal;
                         
                         params["employee_id"] = application_form.designerList.value;
                         params["dateStr"] = toDate;
                         params["timeKey"] = toTime;
                         params["projectNo"] = 'S000';
                         params["dwgType"] = '';
                         params["dwgCode"] = '*****';
                         params["opCode"] = 'D15';
                         params["causeDepart"] = '';
                         params["basis"] = '';
                         params["workDesc"] = '시운전 후 조기퇴근';
                         params["event1"] = '';
                         params["event2"] = '';
                         params["event3"] = '';
                         params["normalTime"] = normalTime+'';
                         params["overtime"] = '0';
                         params["specialTime"] = '0';
                         params["inputDoneYN"] = 'Y';
                         
                         paramAry.push(params);
                     }
                     else {
                         if (workingDayYN == "Y") normalTime = 9;
                         else if (workingDayYN == "4H") normalTime = 4;
                         
                         paramAry = [];
                         params = {};
                         params["employee_id"] = application_form.designerList.value;
                         params["dateStr"] = toDate;
                         params["timeKey"] = '0800';
                         params["projectNo"] = 'S000';
                         params["dwgType"] = '';
                         params["dwgCode"] = '*****';
                         params["opCode"] = 'D15';
                         params["causeDepart"] = '';
                         params["basis"] = '';
                         params["workDesc"] = '시운전 후 조기퇴근';
                         params["event1"] = '';
                         params["event2"] = '';
                         params["event3"] = '';
                         params["normalTime"] = normalTime+'';
                         params["overtime"] = '0';
                         params["specialTime"] = '0';
                         params["inputDoneYN"] = 'Y';
                         
                         paramAry.push(params);
                         
                     }

                     $.ajax({
                       	url:'<c:url value="saveDPInputs.do"/>',
                       	type:'POST',
                       	async: false,
                       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                       	data : {"param":JSON.stringify(paramAry)},
                       	success : function(data){
                       		alert("저장성공");
                       		return;
                       	}, 
                       	error : function(e){
                       		alert("저장에 실패하였습니다.");
                       		return;
                       	}
                       });
                 }
              }
        } 
        
    }
    $("#btn_search").click();
}

// 시운전 후 조기퇴근(평일)
function finishWorkEarlyAfterSeaTrial() {
	if (!isInvalidConditions()) {
		if (application_form.workingdayYn.value == "휴일") {
			alert("'시운전 후 조기퇴근' 등록은 평일인 경우에만 가능합니다.");
			return;
		}
		//메인구현됨
		
		var rows = $( "#dataList" ).getDataIDs();		
		var lastRowData = $('#dataList').jqGrid('getRowData', rows[rows.length-1]);
		var lastRowDataTime = parseInt(lastRowData.start_time.replace(":",''));
		
		if(lastRowDataTime > 1800 && application_form.workingdayYn.value == '평일'){
			alert("18:00 이후에는 '시운전 후 조기퇴근' 코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
            return;
		}
		if(lastRowDataTime > 1200 && application_form.workingdayYn.value == '4H'){
			alert("12:00 이후에는 '시운전 후 조기퇴근' 코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
            return;
		}
        
        var inputExist = false;
		if(lastRowData.project_no == '') lastRowData.project_no = 'S000';
		if(lastRowData.project_no != '' && lastRowData.project_no != 'S000')inputExist = true;
		if(!inputExist && lastRowData.op_code != '' && lastRowData.op_code != 'D15') inputExist = true;
		if (inputExist) {
			alert("적용할 시각을 먼저 선택한 후 '시운전 후 조기퇴근'을 적용하십시오.");
            return;
        }else {
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'project_no', 'S000');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'dwg_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'dwg_code', '*****');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'op_code', 'D15');//90 : 퇴근
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'cause_depart', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'basis', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'basis_display', '&nbsp;');
        	if(lastRowData.work_desc == '')$('#dataList').jqGrid('setCell',rows[rows.length-1], 'work_desc', '시운전 후 조기퇴근');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event1', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event2', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'event3', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'ship_type', '&nbsp;');
        	$('#dataList').jqGrid('setCell',rows[rows.length-1], 'oper', 'U');
        }
		if (checkInputs() == false) return;
		
		// 저장여부 확인 & 저장
        var msg = application_form.dateselected.value + "\n\n시수를 저장 & 확정하시겠습니까?";        
        if (confirm(msg)) {
			var search_date = $("#p_created_date").val().replace(/-/gi,"");
        	
			var date = new Date();
			var year  = date.getFullYear();
			var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
			var day   = date.getDate();
			if (("" + month).length == 1) { month = "0" + month; }
		    if (("" + day).length   == 1) { day   = "0" + day;   }
    
        	var sys_date =  ""+year+month+day;
        	if(parseInt(search_date) > parseInt(sys_date)){
        		alert("오늘 날짜 또는 이전 날짜를 선택하십시오.");
        		return;
        	}
            saveDPInputsProc("Y");
        }
	}
}
//시수 저장 전에 결재여부 체크
function checkMHConfirmYN() {
	if (application_form.isAdmin.value != "Y" && application_form.mhconfirmYn.value == "Y") {
		alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
		return true;
	}
	return false;
}
//시수입력이 가능한 상태인지 체크
function isInvalidConditions() {
	var b;
	b = checkMHConfirmYN();
	return b;
}
function approvalViewCallBack(dateStr){
	var prevVal = application_form.dateselected.value;
	if(!searchVaildation()){
		return;
	}
	application_form.dateselected.value = dateStr;
	fn_dateChanged("Y");
}
function searchVaildation(){
	if(application_form.invaildProjectno.value != ''){
		alert("유효하지 않은 호선이름이 있습니다.\n호선추가 창을 실행하여 수정한 후 작업(조회)하시기 바랍니다!\n※유효하지 않은 호선이름:"+application_form.invaildProjectno.value);
		return false;
	}
	if (application_form.designerList.value == "") {
		alert("조회할 설계자를 먼저 선택하십시오.");
		return false;
	}
	if(fn_checkGridModifyNoAlt("#dataList")){
		var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 조회를 실행하시겠습니까?";
		if (!confirm(msg)){
			return false;
		}
	}
	return true;
}
function searchGrid(){
	$("#mainHeaderText").text(application_form.dateselected.value+" "
			+$("#departmentList option:selected").text().split(" ")[1] +" "
			+$("#designerList option:selected").text().split(" ")[1]
			+" (결재:"+application_form.mhconfirmYn.value+")");
	//그리드 갱신을 위한 작업
	$( '#dataList' ).jqGrid( 'clearGridData' );
	//그리드 postdata 초기화 후 그리드 로드 
	$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
	$( '#dataList' ).jqGrid( 'setGridParam', {
		mtype : 'POST',
		url : '<c:url value="dpInputMainGrid.do"/>',
		datatype : 'json',
		page : 1,
		postData :fn_getFormData($('#application_form'))
	} ).trigger( 'reloadGrid' );
}
//div팝업 선택 화면 Hidden
function fn_toggleDivPopUp(activeDivObj,targetObj)
{
		$(".div_popup").css("display","none");
		if(activeDivObj != null && activeDivObj != undefined){
			activeDivObj.css("left",targetObj.offset().left);
			activeDivObj.css("top",targetObj.offset().top);
			activeDivObj.css("width",targetObj.width());
			activeDivObj.css("height",targetObj.height());
			activeDivObj.css("display","");
		}
}
//숫자 영어 및 구분자(,)를 제외한 기타의 입력 방지
function checkInputAZ09(obj){
	var num_check=/^[A-Za-z0-9,]*$/;
	$(obj).val($(obj).val().toUpperCase());
	if(!num_check.test($(obj).val())){
		alert("Invalid Text. Ex.F9999;F9998 !");
		$(obj).val($(obj).val().substr(0,$(obj).val().length-1));
		return;
	}
}
//관리자 모드에서 부서가 변경되면 사번과 관련된 항목들을 모두 초기화
function fn_departmentSelChanged(){
	var sabunTagObj = $("#designerList");
    sabunTagObj.empty();
    
    application_form.mhconfirmYn.value = "";
    
    $.ajax({
    	url:'<c:url value="getPartPersons.do"/>',
    	type:'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"dept_code" : application_form.departmentList.value},
    	success : function(data){
    		var jsonData = JSON.parse(data);
    		for(var i=0; i<jsonData.rows.length; i++){
    			var rows = jsonData.rows[i];
    			
    			sabunTagObj.append("<option value='"+rows.employee_no+"'>"+rows.employee_no+" "+rows.employee_name+"</option>");
    		}
    		fn_designerSelChanged();
    	}, 
    	error : function(e){
    		alert(e);
    	}
    });
}
//관리자 모드에서, 사번(설계자) 선택이 변경된 경우 변경된 사번의 데이터를 쿼리
function fn_designerSelChanged(){
	if (application_form.designerList.value == "") {
		application_form.mhconfirmYn.value = "";
	} else {
		// 해당 사번 + 날짜의 시수결재 여부를 쿼리하여 표시
		$.ajax({
	    	url:'<c:url value="getMHInputConfirmYN.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"id" : application_form.designerList.value,
	    			"selectDate" : application_form.dateselected.value},
	    	success : function(data){
	    		application_form.mhconfirmYn.value = data;
	    		fn_dateChanged();
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
}
function fn_dateChanged(check){
	// 선택 일자 변경 시 처리, 특히 해당 일자의 평일/휴일 여부와 결재여부를 쿼리
	$.ajax({
    	url:'<c:url value="getDateDPInfo.do"/>',
    	type:'POST',
    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    	data : {"id" : application_form.designerList.value,
				"selectDate" : $( "#p_created_date" ).val()},
    	success : function(data){
    		// 해당 일자 + Work Day 2일이 경과되었으면 오류, 일자를 Rollback
    		var jsonData = JSON.parse(data);
    		
    		if (jsonData.holydaycheck == 'Y')
    			application_form.workingdayYn.value = "평일";
			else if (jsonData.holydaycheck == 'N')
				application_form.workingdayYn.value = "휴일";
			else
				application_form.workingdayYn.value = jsonData.holydaycheck;
    		application_form.workdaysGap.value = jsonData.inputlockdate;
    		application_form.mhconfirmYn.value = jsonData.mhinputstring;
    		
    		if(check == undefined || check == null){
    			if(!searchVaildation()){
    				return;
    			}
    		}
    		//그리드 로드부분
    		searchGrid();
    	}, 
    	error : function(e){
    		$( "#p_created_date" ).val(prevDate);
    		application_form.workingdayYn.value = "ERROR";
    		application_form.mhconfirmYn.value = "ERROR";
    	}
	});
}
function fn_toDate( to_date ) {
	var url = 'selectWeekList.do';

	$.post( url, "", function( data ) {
		$( "#" + to_date ).val( data.created_date_end );
		fn_dateChanged();
	}, "json" );
}

//Time Select 창에서 특정 Time(시각) 항목이 선택되면, 해당 항목에 해당하는 Table Row(TR 개체)를 보이거나 숨긴다
function timeSelected(timeKey)
{
    // 결재완료된 경우에는 동작 X => 결재완료 여부는 TimeSelect 창에서 先 체크함
    if(application_form.mhconfirmYn.value == 'Y'){
    	alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
        return;
    }
    if (!checkBeforeTimeAdding(timeKey)) return;

    var rows = $( "#dataList" ).getDataIDs();
    var duplicateCheck = false;
    var idx = -1;
    var timeKeyBeforeIdx = -1;
    var timeKeyInt = parseInt(timeKey);
    var timeKeyStr = timeKey.substring(0,2)+":"+timeKey.substring(2,4);
	for(var i = 0; i < rows.length; i++){
		var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
		
		if(timeKeyInt > parseInt(rowData.start_time.replace(":",""))){
			timeKeyBeforeIdx = rows[i];
		}
		if(rowData.start_time == timeKeyStr){
			duplicateCheck = true;
			idx = rows[i];
			break;
		}	
	}
	if(!duplicateCheck){
		var addData = {"start_time" : timeKeyStr, "oper" : 'U','event1':' ' };
		$("#dataList").jqGrid('addRowData', $.jgrid.randId(), addData, 'after',timeKeyBeforeIdx);
	} else {
		if($('#dataList').jqGrid('getRowData', idx).oper == 'R'){
			$('#dataList').jqGrid('setRowData',idx,'',{color:'#FF0000;'});
			$('#dataList').jqGrid('setCell',idx, 'oper', 'D');
		}else {
			$("#dataList").jqGrid('delRowData',idx);			
		}

	}
}

//시수항목 추가 전에 항목 추가가 가능한 상태인지 체크
function checkBeforeTimeAdding(timeKey)
{
	var rows = $( "#dataList" ).getDataIDs();
	var rowData = $('#dataList').jqGrid('getRowData', rows[0]);
    var opCode = rowData.op_code;
    if (opCode == "D17") {
        alert("'월차'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'월차' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
        return false;
    }
    else if (opCode == "D14") {
        alert("'특별휴가'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'특별휴가' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
        return false;
    }
    else if (opCode == "D13") {
        alert("'예비군훈련(9H)'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'예비군훈련(9H)' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
        return false;
    }
    else if (opCode == "D1A") {
        alert("'유급휴가'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'유급휴가' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
        return false;
    }  
    
    for(var i = rows.length; i >= 0; i--){
    	var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
    	var opCode = rowData.op_code;
    	if (opCode == 'D1Z') {
            alert("'퇴근코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'퇴근' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
            return false;
        }
        else if (opCode == 'D16') {
            alert("'조퇴코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'조퇴' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
            return false;
        }
        else if (opCode == 'B53' && pjtNo != 'V0000') {
            alert("'시운전 코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'시운전' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
            return false;
        }
        else if (opCode == 'D15') { 
            alert("'시운전 후 조기퇴근(평일) 코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'시운전 후 조기퇴근' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
            return false;
        }
        break;
    }
    return true;
}
</script>
<script type="text/javascript">
	//메인 컨테르 jqgrid작업 시작
	//마스터 그리드
	$(document).ready( function() {
		fn_all_text_upper();
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['시각','공사번호*','OP*','구분','도면번호*','원인부서','근거','근거text','업무내용',
			            'Event1*','Event2','Event3','선종','normalTime','overTime','specialTime','oper'],
			colModel : [
			            	{name : 'start_time', index : 'start_time', width: 10, align : "center"},
							{name : 'project_no', index : 'project_no', width: 25, align : "center",formatter:projectFmatter, unformat:projectUnFmatter},
							{name : 'op_code', index : 'op_code', width: 10, align : "center", formatter:opCodeFmatter, unformat:opCodeUnFmatter},
							{name : 'dwg_type', index : 'dwg_type', width: 5, align : "center"},
							{name : 'dwg_code', index : 'dwg_code', width: 10, align : "center"},
							{name : 'cause_depart', index : 'cause_depart', width: 20, align : "center"},
							{name : 'basis_display', index : 'basis_display', width: 5, align : "center"},
							{name : 'basis', index : 'basis', width: 5, align : "center",hidden:true},
							{name : 'work_desc', index : 'work_desc', width: 50, align : "left"},
							{name : 'event1', index : 'event1', width: 10, align : "center"},
							{name : 'event2', index : 'event2', width: 10, align : "center"},
							{name : 'event3', index : 'event3', width: 10, align : "center"},
							{name : 'ship_type', index : 'ship_type', width: 10, align : "center",hidden:true},
							{name : 'overTime', index : 'overTime', width: 20, align : "center",hidden:true},
							{name : 'normalTime', index : 'normalTime', width: 20, align : "center",hidden:true},
							{name : 'specialTime', index : 'specialTime', width: 20, align : "center",hidden:true},
							{name : 'oper', index : 'oper', width: 20, align : "center",hidden:true}
			           ],
	        gridview : true,
	   		cmTemplate: { title: true,sortable: false},
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true,
	   		height : objectHeight,	   		
	   		rowNum : -1,
	   		rownumbers: true,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pDataList'),
	   		cellEdit : false, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
			loadComplete: function (data) {
			},
			onCellSelect : function(rowid, iCol,  cellcontent,e){
				fn_setSelectionRow(rowid);
				fn_toggleDivPopUp();
				var rowData = jQuery(this).getRowData(rowid);
				var cm = jQuery("#dataList").jqGrid("getGridParam", "colModel");
				
				updateDrawingInfo(rowData.project_no, rowData.dwg_code);
				
				if(cm[iCol].name == "basis_display"){
					if (rowData.op_code == "20" || rowData.op_code.substring(0, 2) == 'A2') { // OP CODE가 선주 Extra(20) 또는 도면수정(5A~5R) 인 경우에만 입력컨트롤을 표시한다
						fn_toggleDivPopUp($("#inputDiv"),$(this).find("tr#"+rowid).find("td:eq("+iCol+")"));
						var inputText = $("#inputText");
						inputText.val(rowData.basis).focus();
			        }
				}
				if(cm[iCol].name == "work_desc"){
						var editable = fn_eidtable();
						if(editable == "")
						{
							fn_toggleDivPopUp($("#inputWorkDescDiv"),$(this).find("tr#"+rowid).find("td:eq("+iCol+")"));
							var inputText = $("#inputWorkDesc");
							inputText.val(rowData.work_desc).focus();
						}
				}
				var cellObj = $(this).find("tr#"+rowid).find("td:eq("+iCol+")");
				if(cm[iCol].name == "dwg_type")fn_dwgTypeSel(cellObj);
				if(cm[iCol].name == "dwg_code")fn_dwgCodeSel(cellObj);
				if(cm[iCol].name == "cause_depart")fn_causeDepartSel(cellObj);
				if(cm[iCol].name == "event1" || cm[iCol].name == "event2" || cm[iCol].name == "event3")fn_eventTypeSel(cellObj,cm[iCol].name);
				if(cm[iCol].name == "ship_type")fn_shipTypeSel(cellObj);
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				for(var i=0; i<rows.length; i++){
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					if(rowData.project_no != '' && rowData.project_no != 'S000' && rowData.project_no != 'PS0000' && rowData.project_no != 'V0000'
						&& rowData.op_code != '#####' && rowData.op_code != 'B53' && rowData.op_code != 'D15' && rowData.event1 == ''){
						$('#dataList').jqGrid('setCell',rows[i], 'event1', '(선택안함)');
					}
					
					if(rowData.basis != "") $('#dataList').jqGrid('setCell',rows[i], 'basis_display', '√');
					$('#dataList').jqGrid('setCell',rows[i], 'start_time', '',{color:'#0000FF;'});
				}
				if(rows.length == 0 && application_form.mhconfirmYn.value == 'N'){
					var addData = {"start_time" : '08:00', "oper" : 'R','event1':' ' };
					$("#dataList").jqGrid('addRowData', $.jgrid.randId(), addData, 'first');
				} 
			}
		});
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 넘버링 표시
		$("#dataList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.53);
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		//fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() );
		$("#btn_approval_view").click();
	});	
	
	// 시수입력 저장 처리 서브-프로시저
    function saveDPInputsProc(inputDoneYN){
    	var workingDayYN = application_form.workingdayYn.value;
        if (workingDayYN == '평일') workingDayYN = 'Y'; 
        else if (workingDayYN == '4H') workingDayYN = '4H'; 
        else workingDayYN = 'N';
        
        var normalTimeTotal = 0;
        var overtimeTotal = 0;
        var specialTimeTotal = 0;
        
		if(fn_checkGridModify($("#dataList"))){
			var rows = $( "#dataList" ).getDataIDs();
	        
			for(var i=0; i<rows.length; i++){
				var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
				var projectNo = rowData.project_no;
	            var event1 = rowData.event1;
	            if (event1 == '(선택안함)') $('#dataList').jqGrid('setCell',rows[i], 'event1', '&nbsp;');
	            $('#dataList').jqGrid('setCell',rows[i], 'oper', 'U');
	         	// 시수계산
	            var normalTime = 0;
	            var overtime = 0;
	            var specialTime = 0;
	            
	            // 월차, 특별휴가, 예비군훈련(9H)
	            var opCode = rowData.op_code
	            if (i == 0 && (opCode == 'D17' || opCode == 'D13' || opCode == 'D14' || opCode == 'D1A')) { 
	                if (workingDayYN == '4H') normalTime = 4; 
	                else normalTime = 9;
	                inputDoneYN = 'Y'; // 월차 등이면 08:00 외 입력사항은 없으므로 시수입력 완료 (휴일에는 이 항목들 지정되는 경우 없음)
	            }
	            // 조퇴 : 정상근무 9 시간 기준으로 책정(4H일 때는 4 시간 기준)
	            else if (opCode == 'D16') {
	                if (workingDayYN == '4H') normalTime = 4 - normalTimeTotal;
	                else normalTime = 9 - normalTimeTotal;
	                inputDoneYN = 'Y'; // 조퇴 항목 후의 입력사항은 없으므로 시수입력 완료 (휴일에는 이 항목 지정되는 경우 없음)
	            }
	            // 시운전 후 조기퇴근(평일) : 정상근무 9시간(4H 는 4시간) 기준으로 책정 (시운전 후 조기퇴근은 18:00 후(4H 경우는 12:00 후) 입력되는 경우가 없음)
	            else if (opCode == 'D15') {
	                if (workingDayYN == '4H') normalTime = 4 - normalTimeTotal;
	                else normalTime = 9 - normalTimeTotal;
	                inputDoneYN = 'Y';
	            }
	         	// 일반적인 케이스 (시운전 포함)
	            else {
	            	var hasNext = false;
	            	if((i+1) < rows.length)
	            	{
	            		var rowDataNext = $('#dataList').jqGrid('getRowData', rows[i+1]);
	                    if ($.inArray(rowDataNext.start_time.replace(":",""),timeKeys) != -1) {
	                        hasNext = true;
	                    }
	            	}
	                if(hasNext){
	                	var rowDataNext = $('#dataList').jqGrid('getRowData', rows[i+1]);
	                	var arrayIndex = $.inArray(rowData.start_time.replace(":",""),timeKeys);
                		var arrayIndexNext = $.inArray(rowDataNext.start_time.replace(":",""),timeKeys);
	                	for (var j = arrayIndex + 1; j < (arrayIndexNext+1); j++) {
	                		if (arrayIndexNext == -1) break;
	                		
	                		if (timeKeys[j] == "1230" || timeKeys[j] == "1300") { // 12:00~13:00(점심시간)은 시수에 포함 X
	                        	continue;
	                        }
							if (workingDayYN == '4H') {
	                             if (j <= 8) normalTime += 0.5; // 4H인 경우 12:00 이전까지는 일반근무
	                             else overtime += 0.5; // 12:00 초과부터는 연장근무
	                        }
	                        else {
	                             if (j <= 20) normalTime += 0.5; // 18:00 이전까지는 일반근무
	                             else overtime += 0.5; // 18:00 초과부터는 연장근무
                         	}
	                	}
	                }	
	                /* if (rowData.start_time != "12:30" && rowData.start_time != "13:00") {
	                	var time =  rowData.start_time.replace(":","");
	                	alert(rowData.start_time+"|"+time);
                        if (workingDayYN == '4H') {
                            if (time <= 1200) normalTime += 0.5; // 4H인 경우 12:00 이전까지는 일반근무
                            else overtime += 0.5; // 12:00 초과부터는 연장근무
                        }
                        else {
                            if (time <= 1800) normalTime += 0.5; // 18:00 이전까지는 일반근무
                            else overtime += 0.5; // 18:00 초과부터는 연장근무
                        }
	                } */
	                else if (opCode == 'B53' && projectNo != 'V0000') { // 시운전은 뒤에 다른 항목이 있으면 위의 일반 케이스로 처리됨, 없으면 연장근무 3 시간 기준으로 처리(휴일은 특근 8시간)
	                    if (workingDayYN == 'Y') { 
	                        if (normalTime < 9) normalTime = 9 - normalTimeTotal;
	                        if (overtime < 3) overtime = 3 - overtimeTotal;
	                    }
	                    else if (workingDayYN == '4H') { 
	                        if (normalTime < 4) normalTime = 4 - normalTimeTotal;
	                        if (overtime < 3) overtime = 3 - overtimeTotal;
	                    }
	                    else { // 휴일
	                        if (normalTime < 8) normalTime = 8 - specialTimeTotal; 
	                    }

	                    inputDoneYN = 'Y'; // 시운전 뒤에 다른 항목이 없으므로 시수입력 완료
	                }
	                // 그 외에는 뒤에 다른 항목이 없으면 시수계산할 것이 없음

	                if (opCode == 'D1Z') inputDoneYN = 'Y'; // 퇴근이면 시수입력 완료
	            }
	            if (workingDayYN == 'N') {
	                specialTime = normalTime + overtime;
	                normalTime = 0;
	                overtime = 0;
	            }
	            
	            $('#dataList').jqGrid('setCell',rows[i], 'normalTime',normalTime);
	            $('#dataList').jqGrid('setCell',rows[i], 'overTime',overtime);
	            $('#dataList').jqGrid('setCell',rows[i], 'specialTime',specialTime);
	            
	            normalTimeTotal += normalTime;
	            overtimeTotal += overtime;
	            specialTimeTotal += specialTime;
			}

			application_form.inputDoneYN.value = 'N'; application_form.inputDoneYN.value = inputDoneYN;
			
			var chmResultRows = [];
			getGridChangedData($("#dataList"),function(data){
				chmResultRows = data;
				
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				
				var url = 'dpInputMainGridSave.do';
				var formData = fn_getFormData('#application_form');
				var parameters = $.extend({}, dataList, formData);
				
				lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				$.post( url, parameters, function( data2 ) {
					if ( data2.result == 'success' ) {
						alert(data2.resultMsg);
						searchGrid();
					} else {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					}
				}, "json" ).error( function() {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
					lodingBox.remove();
				} );
			});
		}
		
	}
    
	
	function projectFmatter(cellvalue, options, rowObject){
		var id = options.rowId;
		var columnName = options['colModel'].name; 
		if(cellvalue == undefined) cellvalue = '';
		var inputBox = "<input type='text' readonly='readonly' id='"+id+"_"+columnName+"' onfocus='fn_setSelectionRow(\""+id+"\")' value='"+cellvalue+"' onClick='showprojectSelect(this,\""+id+"\")' style='width:60%; padding:1px; margin:0px;'/>";
		var button = "<input type='button' class='btn_gray2' onfocus='fn_setSelectionRow(\""+id+"\")' style='width:40%; padding:1px; margin:0px;' value='다중호선' onclick='showProjectMultiSelect(\""+id+"\",this);' />";		
		return inputBox+button;
	}
	function projectUnFmatter(cellvalue, options, cell){
		var id = options['rowId'];
		var columnName = options['colModel'].name;
		return $.trim($("#"+id+"_"+columnName).val());
	}
	
	function opCodeFmatter(cellvalue, options, rowObject){
		var id = options.rowId;
		var columnName = options['colModel'].name; 
		if(cellvalue == undefined) cellvalue = '';
		var inputBox = "<input type='text' readonly='readonly' id='"+id+"_"+columnName+"' onfocus='fn_setSelectionRow(\""+id+"\")' value='"+cellvalue+"' style='width:60%; padding:1px; margin:0px;'/>";
		var button = "<input type='button' class='btn_gray2' onfocus='fn_setSelectionRow(\""+id+"\")' style='width:40%; padding:1px; margin:0px;' value='...' onclick='showOpSelectWin();'/>";
		return inputBox+button;
	}
	function opCodeUnFmatter(cellvalue, options, cell){
		var id = options['rowId'];
		var columnName = options['colModel'].name;
		return $.trim($("#"+id+"_"+columnName).val());
	}
	
	function fn_eidtable(){
		if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);

		if(rowData.dwg_code != '')return "";
		else return "readonly";
	}
	function fn_inputDivOnblur(obj){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		if($(obj).val() != '')
		$('#dataList').jqGrid('setCell',selectRow, 'basis_display',"√");
		else $('#dataList').jqGrid('setCell',selectRow, 'basis_display',"&nbsp;");
		$('#dataList').jqGrid('setCell',selectRow, 'basis',$(obj).val());
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	}
	function fn_inputWorkDescOnblur(obj){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		if($(obj).val() != '')
		$('#dataList').jqGrid('setCell',selectRow, 'work_desc',$(obj).val());
		else $('#dataList').jqGrid('setCell',selectRow, 'work_desc',"&nbsp;");
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	}
	function fn_shipTypeSel(obj){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		shipTypeQueryProc($(obj).text());
		if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
		if(rowData.project_no == ''){
			fn_toggleDivPopUp();
			return;
		}
		fn_toggleDivPopUp($("#shipTypeListDiv"),$(obj));
		var shipType = $("#shipTypeListDiv [name=shipTypeList]");
		shipType.val($(obj).text()).focus();
	}
	function fn_eventTypeSel(obj,eventTypeValue){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		if(application_form.mhconfirmYn.value == 'Y' ||( rowData.project_no == '' && rowData.op_code == '' )){
			fn_toggleDivPopUp();
			return;
		}
		
		var drwNoObj = rowData.dwg_code;
        if (drwNoObj == '' || drwNoObj == '*****' || drwNoObj == '#####'){
        	fn_toggleDivPopUp();
        	return;
        	// :도면번호의 값이 없거나 '*****'이면 입력 컨트롤 표시하지 않는다
        }
        var eventTypeSelct = $("#eventTypeList");
        eventTypeSelct.empty();
        eventTypeSelct.append("<option value=''></option>");
        if(eventTypeValue == "event1"){
        	eventTypeSelct.append("<option value='(선택안함)'>(선택안함)</option>");
        }
        var drwTypeValue = rowData.dwg_type;
        if (drwTypeValue == "V") {
        	eventTypeSelct.append("<option value='V1'>V1:P.O.S 발행</option>");
        	eventTypeSelct.append("<option value='V2'>V2:업체선정</option>");
        	eventTypeSelct.append("<option value='V3'>V3:구매오더</option>");
        	eventTypeSelct.append("<option value='V4'>V4:업체도면접수</option>");
        	eventTypeSelct.append("<option value='V5'>V5:선주승인발송</option>");
        	eventTypeSelct.append("<option value='V6'>V6:선주승인접수</option>");
        	eventTypeSelct.append("<option value='V7'>V7:업체출도일</option>");
        	eventTypeSelct.append("<option value='V8'>V8:작업용출도일</option>");
        }
        else {
        	eventTypeSelct.append("<option value='Y1'>Y1:착수일</option>");
        	eventTypeSelct.append("<option value='Y2'>Y2:완료일</option>");
        	eventTypeSelct.append("<option value='Y3'>Y3:선주승인발송</option>");
        	eventTypeSelct.append("<option value='Y4'>Y4:선주승인접수</option>");
        	eventTypeSelct.append("<option value='Y5'>Y5:선급승인발송</option>");
        	eventTypeSelct.append("<option value='Y6'>Y6:선급승인접수</option>");
        	eventTypeSelct.append("<option value='Y7'>Y7:참고용발송</option>");
            // 2016-03-11 : Y8 제거, 한경훈 과장 요청
            //DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y8:작업용발송", "Y8");
            /* document.getElementById(elemName + timeKey).options[document.getElementById(elemName + timeKey).options.length] = new Option("Y8:작업용발송", "Y8"); */
        }
        
        
		fn_toggleDivPopUp($("#eventTypeListDiv"),$(obj));
		var eventType = $("#eventTypeListDiv [name=eventTypeList]");
		var eventTypeHidden = $("#eventType").val(eventTypeValue);
		eventType.val($(obj).text()).focus();
	}
	function fn_causeDepartSel(obj){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
		if(rowData.project_no == '' && rowData.op_code == ''){
			fn_toggleDivPopUp();
			return;
		}
		var opObj = rowData.op_code;
		if (opObj.substring(0, 2) == 'A2') { // OP CODE가 도면수정(5A~5R) 인 경우에만 입력컨트롤을 표시한다
			fn_toggleDivPopUp($("#causeDepartListDiv"),$(obj));
			var causeDepart = $("#causeDepartListDiv [name=causeDepartList]");
			causeDepart.val($(obj).text()).focus();
        }
	}
	// 구분변경 처리
	function fn_causeDepartChanged()
	{
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		
		var causeDepartSel = $("#causeDepartListDiv [name=causeDepartList]").val();    	
		var causeDepartSelText = $("#causeDepartListDiv [name=causeDepartList] option:selected").text();
		
		$('#dataList').jqGrid('setCell',selectRow, 'cause_depart',causeDepartSel);
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
		
		 fn_toggleDivPopUp();
	}
	// 선종 변경처리
	function fn_shipTypeChanged(obj){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		
		var shipTypeSel = $("#shipTypeListDiv [name=shipTypeList]").val();    	
		var shipTypeText = $("#shipTypeListDiv [name=shipTypeList] option:selected").text();
		
		$('#dataList').jqGrid('setCell',selectRow, 'ship_type',shipTypeSel);
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
		
		 fn_toggleDivPopUp();
	}
	
	//'도면 구분' 필드 선택 시 입력 컨트롤 표시
	function fn_dwgTypeSel(obj)
	{
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
		if(rowData.project_no == '' && rowData.op_code == ''){
			fn_toggleDivPopUp();
			return;
		}		
		
		var pjtObj = rowData.project_no;
        if (pjtObj == '' || pjtObj == 'S000' || pjtObj == 'PS0000') return; // 공사번호(호선) 값이 없거나 S000 or PS0000 이면 입력 컨트롤 표시하지 않는다
        if (pjtObj.indexOf(",") > -1) return; // Multi 공사번호(호선)이 선택된 경우 입력 컨트롤 표시하지 않는다
        
        var opCode = rowData.op_code;

        if (opCode.substring(0, 1) != 'A') return;  // 공사번호(호선)이 1개이고, OP CODE가 'Axx' 일경우만 도면 구분 선택 가능

        var drwTypeObj = rowData.dwg_type;

        if (drwTypeObj.value != "") {
            drawingTypesForWorkQueryProc(pjtObj,$(obj).text());
        }
		
		fn_toggleDivPopUp($("#dwgTypeListDiv"),$(obj));
		var dwgType = $("#dwgTypeListDiv [name=dwgTypeList]");
		dwgType.val($(obj).text()).focus();
	}
	// 구분변경 처리
	function fn_dwgTypeChanged()
	{
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		
		var dwgTypeSel = $("#dwgTypeListDiv [name=dwgTypeList]").val();    	
		var dwgTypeSelText = $("#dwgTypeListDiv [name=dwgTypeList] option:selected").text();
		if(dwgTypeSel.length == 0) dwgTypeSel = "&nbsp;";
		$('#dataList').jqGrid('setCell',selectRow, 'dwg_type',dwgTypeSel);
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	    fn_toggleDivPopUp();
	    
	    $('#dataList').jqGrid('setCell',selectRow, 'dwg_code', '&nbsp;');
        // 업무내용 값 초기화
        $('#dataList').jqGrid('setCell',selectRow, 'work_desc', '&nbsp;');
        // EVENT1, 2, 3 값 초기화
        $('#dataList').jqGrid('setCell',selectRow, 'event1', '&nbsp;');
        $('#dataList').jqGrid('setCell',selectRow, 'event2', '&nbsp;');
        $('#dataList').jqGrid('setCell',selectRow, 'event3', '&nbsp;');
        
        updateDrawingInfo('');
     	
        // 도면구분 선택 값에 따라 해당 호선 & 부서의 작업 대상 도면 목록을 디비에서 쿼리
        if (dwgTypeSelText == '') {
        	$('#dataList').jqGrid('setCell',selectRow, 'dwg_code', '&nbsp;');
        }
        else {
            drawingListForWorkQueryProc('');
        }
	}
	// 특정 호선 + 부서에 대한 '도면구분' 값들을 DB에서 쿼리해오고 '도면구분' LOV를 채우는 서브-프로시저
    function drawingTypesForWorkQueryProc(projectNo, selectedValue)
    {
    	var dwgTypeSelct = $("#dwgTypeList");
    	if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
        var rowKey = $("#dataList").jqGrid('getGridParam',"selrow");
		var rowData = $('#dataList').jqGrid('getRowData', rowKey);
		if(projectNo == undefined || projectNo == ''){
			if(rowData.project_no != '')projectNo = rowData.project_no;
    		else return;
		}
    	$.ajax({
	    	url:'<c:url value="getDrawingTypesForWork.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"departCode" : application_form.departmentList.value,
	    			"projectNo" : projectNo},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		dwgTypeSelct.empty();
	    		dwgTypeSelct.append("<option value=''></option>");
	    		for (var i = 0; i < jsonData.rows.length; i++) {
	    			var row = jsonData.rows[i];
                    if (row.dwgtype == "") continue;
                    if (selectedValue != "" && selectedValue == row.dwgtype){
                    	//도면 구분 값 셋팅    ajax리턴 value name->dwgtype
                    	dwgTypeSelct.append("<option value='"+row.dwgtype+"' selected='selected'>"+row.dwgtype+"</option>");
                    } else {
                    	dwgTypeSelct.append("<option value='"+row.dwgtype+"'>"+row.dwgtype+"</option>");
                    }
                }
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    }); 
    }
	//도면번호 선택 화면 Show
	function fn_dwgCodeSel(obj)
	{
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
		if(rowData.project_no == '' || $.trim(rowData.dwg_type) == ''){
			fn_toggleDivPopUp();
			return;
		}
		fn_toggleDivPopUp($("#dwgCodeListDiv"),$(obj));
		var dwgCode = $("#dwgCodeListDiv [name=dwgCodeList]");
		dwgCode.val($(obj).text()).focus();
	}
	// 구분변경 처리
	function fn_dwgCodeChanged()
	{
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		
		var dwgCodeSel = $("#dwgCodeListDiv [name=dwgCodeList]").val();    	
		var dwgCodeSelText = $("#dwgCodeListDiv [name=dwgCodeList] option:selected").text();
		if(dwgCodeSel.length == 0) dwgCodeSel = "&nbsp;";
		$('#dataList').jqGrid('setCell',selectRow, 'dwg_code',dwgCodeSel);
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	    fn_toggleDivPopUp();
	    
	    if (dwgCodeSelText.indexOf(":") > 0) {
            var tempStrs = dwgCodeSelText.split(":");
            dwgCodeSelText = tempStrs[1];
        }
        if (dwgCodeSelText != "*****" && dwgCodeSelText != "#####" && dwgCodeSel != "&nbsp;") {
        	$('#dataList').jqGrid('setCell',selectRow, 'work_desc',dwgCodeSelText);
        } else if(dwgCodeSel == "&nbsp;")
       	{
        	$('#dataList').jqGrid('setCell',selectRow, 'work_desc',"&nbsp;");
       	}
        
        // EVENT1, 2, 3 값 초기화
        $('#dataList').jqGrid('setCell',selectRow, 'event1', '&nbsp;');
        $('#dataList').jqGrid('setCell',selectRow, 'event2', '&nbsp;');
        $('#dataList').jqGrid('setCell',selectRow, 'event3', '&nbsp;');
     	// OP CODE가 'A2x'가 아닌 경우 '원인부서' 입력 값을 초기화한다      
        var opCode = rowData.op_code;
        if (opCode.substring(0, 2) != 'A2') {
        	$('#dataList').jqGrid('setCell',selectRow, 'cause_depart', '&nbsp;');
        }
        // OP CODE가 '20' & 'A2x'가 아닌 경우 '근거' 입력 값을 초기화한다
        if (opCode.substring(0, 2) != 'A2' && opCode != '20') {
        	$('#dataList').jqGrid('setCell',selectRow, 'basis', '&nbsp;');
        }
     	// Bottom 의 DP 공정 정보 업데이트
        updateDrawingInfo(rowData.project_no, dwgCodeSel);
	}
	function drawingListForWorkQueryProc(selectedValue)
	{
		var dwgCodeSelct = $("#dwgCodeList");
		dwgCodeSelct.empty();
    	if (application_form.mhconfirmYn.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
        var rowKey = $("#dataList").jqGrid('getGridParam',"selrow");
		var rowData = $('#dataList').jqGrid('getRowData', rowKey);
		if(rowData.project_no == '')return;
		
		$.ajax({
	       	url:'<c:url value="getDrawingListForWork.do"/>',
	       	type:'POST',
	       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	       	async: false,
	       	data : {"depart_code" : application_form.departmentList.value,
	       			"project_no":rowData.project_no,
	       			"dwg_type" : rowData.dwg_type},
	       	success : function(data){
	       		var jsonData = JSON.parse(data);
	       		dwgCodeSelct.empty();
	       		dwgCodeSelct.append("<option value=''></option>");
	    		for (var i = 0; i < jsonData.rows.length; i++) {
	    			var row = jsonData.rows[i];
                    if (row.dwgno == "") continue;
                    
                    if (selectedValue != "" && selectedValue == row.dwgtype){
                    	//도면 구분 값 셋팅    ajax리턴 value name->dwgtype
                    	dwgCodeSelct.append("<option value='"+row.dwgno+"' selected='selected'>"+row.dwgno+":"+row.dwgtitle+"</option>");
                    } else {
                    	dwgCodeSelct.append("<option value='"+row.dwgno+"'>"+row.dwgno+":"+row.dwgtitle+"</option>");
                    }
                }
	       	}, 
	       	error : function(e){
	       		alert(e);
	       	}
        });
	}
	// 호선 복수 지정
    function showProjectMultiSelect(rowId,obj) 
    {
        if (application_form.designerList.value == "") {
            alert("설계자를 먼저 선택하십시오.");
            return;
        }
     	// 결재완료된 경우에는 동작 X => 결재완료 여부는 TimeSelect 창에서 先 체크함
	    if(application_form.mhconfirmYn.value == 'Y'){
	        return;
	    }
        var sProperties = 'dialogHeight:280px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "employee_id="+application_form.designerList.value;
        
        var selectedProjects = window.showModalDialog("popUpInputProjectMultiSelect.do?" + paramStr, "", sProperties);
       

        if (selectedProjects != null && selectedProjects != 'undefined')
        {
        	var rowData = $('#dataList').jqGrid('getRowData', rowId);
        	if(rowData.project_no != selectedProjects){
        		fn_projectChangedAction(selectedProjects);
        	}
        }       
    } 
	function showprojectSelect(obj,rowid){
		// 결재완료된 경우에는 동작 X => 결재완료 여부는 TimeSelect 창에서 先 체크함
	    if(application_form.mhconfirmYn.value == 'Y'){
	        return;
	    }
		var activeDivObj = $("#projectListDiv");
		var activeSelectBox = $("#projectList");
		$("#targetRowId").val(rowid);
		var selectedValue = $(obj).val();
		
		activeDivObj.css("left",$(obj).offset().left);
		activeDivObj.css("top",$(obj).offset().top);
		activeDivObj.css("display","");
		
		var checkExist = false;
		activeSelectBox.find('option').remove();
		
		var projectNoAry = $("#p_project_no").val().split(",");
		projectNoAry.unshift("S000");
		projectNoAry.unshift("&nbsp;");

		for(var i =0; i < projectNoAry.length; i++){
			var value = projectNoAry[i].trim();
			activeSelectBox.append("<option value='"+value+"'>"+value+"</option>");
			
			if(value.trim() == selectedValue.trim()){
				checkExist = true;
			}
		}
		
		/* for(var i=0; i < activeSelectBox.find("option").length; i++){
			var value = activeSelectBox.find("option")[i].value;
			if(value.trim() == selectedValue.trim()){
				checkExist = true;
			}
		}*/
		
		if(!checkExist && selectedValue != '') activeSelectBox.append("<option class='addOption' value='"+selectedValue+"'>"+selectedValue+"</option>");
		
		if(selectedValue =='' || selectedValue == undefined) activeSelectBox.find("option:eq(0)").prop("selected","true");
		else activeSelectBox.find("option[value='"+selectedValue+"']").prop("selected","true");
		activeSelectBox.css("width",$(obj).closest("td").width());
		activeSelectBox.css("height",$(obj).closest("td").height());
		activeSelectBox.focus().click();
	}
	//event 값 변경처리
	function fn_eventTypeChanged(obj){
		var selectRow = $("#dataList").jqGrid('getGridParam','selrow');
		var rowData = $("#dataList").jqGrid('getRowData',selectRow);
		
		var eventTypeSel = $("#eventTypeListDiv [name=eventTypeList]").val();    	
		var eventTypeSelText = $("#eventTypeListDiv [name=eventTypeList] option:selected").text();
		var eventTypeHidden = $("#eventType").val();
		if(eventTypeSel.length == 0) eventTypeSel = "&nbsp;";
		$('#dataList').jqGrid('setCell',selectRow, eventTypeHidden ,eventTypeSel);
		$('#dataList').jqGrid('setCell',selectRow, 'oper', 'U');
	    fn_toggleDivPopUp();
	    
	}
	// 공사번호(호선) 변경 시 다른 입력 항목들을 초기화하고 해당 호선에 대한 '도면구분' 값들을 DB에서 쿼리해 온다
	function fn_projectChanged(obj){
	    var pjtValue = $(obj).val();

	    if(pjtValue.substring(0, 1)=='Z')
	    {
	     	 var ConfirmMsg = "인도호선 ("+pjtValue+") 에 대한 시수입력 시\n반드시 업무내용란에 사유를 입력하여 주시길 바랍니다.\n\n";
	     	 ConfirmMsg += "인도시점 및 사유 관련 문의사항은\n기술기획팀 한경훈 과장 (T.3220) 으로 문의바랍니다.\n\n진행하시겠습니까?";
	     	 	
	     	 if(confirm(ConfirmMsg))
	     	 {
	     		fn_projectChangedAction(pjtValue);	     	 	
	     	 } else {
	     	 	return;
	     	 }
	    } else {
	    	fn_projectChangedAction(pjtValue);
	    }  
	}
	//호선 변경
	function fn_projectChangedAction(objVal){
		$("#"+$("#targetRowId").val()+"_"+"project_no").val(objVal);
		fn_toggleDivPopUp();
		var rowId = $("#targetRowId").val();
		var colmodel = $("#dataList").jqGrid('getGridParam',"colModel");
		for(var i=0; i< colmodel.length; i++){
			if(colmodel[i].name != 'rn' &&colmodel[i].name != 'project_no' && colmodel[i].name != 'start_time' && colmodel[i].name != 'oper'){
				$('#dataList').jqGrid('setCell',rowId, colmodel[i].name, '&nbsp;');
			} else if(colmodel[i].name == 'oper'){
				$('#dataList').jqGrid('setCell',rowId, colmodel[i].name, 'U');
			}
		}
		// Bottom 의 DP 공정 정보 업데이트
        updateDrawingInfo('');
		
     	// 공사번호(호선)가 'S000' or 'PS0000' or Multi 공사번호(호선)이면 도면번호를 '*****'로 설정하고, 그 외의 경우에는 해당 호선에 대한 도면구분 목록을 DB에서 쿼리...
        if (objVal == "") {
            return;
        }
        else if (objVal == 'S000' || objVal == 'PS0000') {
        	$('#dataList').jqGrid('setCell',rowId, 'dwg_code', '*****');
        }
        else if (objVal.indexOf(",") > -1) {
        	$('#dataList').jqGrid('setCell',rowId, 'dwg_code', '*****');
        }
        else {
            drawingTypesForWorkQueryProc(objVal, "");
        }
        
        // 선종 추출 및 LOV 채움
        shipTypeQueryProc("");
        
        // 호선 선택 후 Action
        projectSelChangedAfter(objVal);
		
	}
	// projectSelChanged() 실행된 후 호선이 'S000' or Multi 공사번호(호선)이면 OP CODE 창을 띄우고, 기타 호선이면 도면타입 선택 컨트롤을 Show 시킨다 
    function projectSelChangedAfter(objVal)
    {
        showOpSelectWin(objVal);
    }
 // OP CODE 선택 창을 showModalDialog로 Popup 시키고, 선택결과를 OP 입력 칸에 반영한다
    function showOpSelectWin(objVal) 
    {
		// 결재완료된 경우에는 동작 X => 결재완료 여부는 TimeSelect 창에서 先 체크함
	    if(application_form.mhconfirmYn.value == 'Y'){
	        return;
	    }
	    var rowKey = $("#dataList").jqGrid('getGridParam',"selrow");
		var rowData = $('#dataList').jqGrid('getRowData', rowKey);
    	var projectNo = objVal;
    	if(objVal == undefined || objVal == ''){
    		if(rowData.project_no != '')projectNo = rowData.project_no;
    		else return;
    	}
    	var sProperties = 'dialogHeight:440px;dialogWidth:740px;scroll=no;center:yes;resizable=no;status=no;';       
        var paramStr = "projectNo="+projectNo;
        var rs = window.showModalDialog("popUpInputOpSelect.do?"+paramStr, 
				window, sProperties);

		if(rs != null && rs != undefined){
			// 출도된 도면이면 OP CODE 선택에 제한을 둔다
			
			if(rowData.project_no != '' && rowData.project_no !='S000' && rowData.project_no != 'PS0000' && rowData.dwg_code != '*****' && rowData.dwg_code != '#####')
			{
				var workingStartDate = '';
				
				$.ajax({
			       	url:'<c:url value="getDrawingWorkStartDate.do"/>',
			       	type:'POST',
			       	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			       	async: false,
			       	data : {"dwg_code" : rowData.dwg_code,
			       			"project_no":rowData.project_no},
			       	success : function(data){
			       		workingStartDate = data;
			       	}, 
			       	error : function(e){
			       		workingStartDate = "ERROR";
			       	}
		        });
				if (workingStartDate != "" && workingStartDate != "ERROR") 
	            {
	                // 개정에 해당하지 않는 도면작업(OP CODE 21 ~ 24)은 선택 불가
	                if (rowData.op_code == "21" || rowData.op_code == "22" || rowData.op_code == "23" || rowData.op_code == "24") 
	                {
	                    var dateStr1 = application_form.dateselected.value;
	                    var dateStrs1 = dateStr1.split("-");
	                    var date1 = new Date(dateStrs1[0], dateStrs1[1] - 1, dateStrs1[2]); // 시수입력일
	                    
	                    var dateStrs2 = workingStartDate.split("-");
	                    var date2 = new Date(dateStrs2[0], dateStrs2[1] - 1, dateStrs2[2]); // 도면 출도일

	                    if (date1 - date2 > 0) {
	                        var msg = rowData.dwg_code + " 도면은 " + workingStartDate + " 에 이미 출도가 되었습니다.\n\n";
	                        msg += "출도날짜 입력 후 도면작업(OP CODE 21 ~ 24)은 모두 개정작업이므로\n\n";
	                        msg += "OP CODE 가 5로 시작하는 코드만 입력할 수 있습니다!";
	                        alert(msg);
	                        return;
	                    }
	                }
	            }
			}
			var prevOpCode = rowData.op_code;
            // OP CODE가 변경되면 기존 입력값 초기화
            if(prevOpCode != null && prevOpCode != "")
            {
		        // 도면구분 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'dwg_type', '&nbsp;');
		        $('#dataList').jqGrid('setCell',rowKey, 'dwg_code', '&nbsp;');
		        // OP 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'op_code', '&nbsp;'); 
		        // 원인부서 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'cause_depart', '&nbsp;');
		        // 근거 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'basis', '&nbsp;');
		        // 업무내용 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'work_desc', '&nbsp;');
		        // EVENT1, 2, 3 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'event1', '&nbsp;');
		        $('#dataList').jqGrid('setCell',rowKey, 'event2', '&nbsp;');
		        $('#dataList').jqGrid('setCell',rowKey, 'event3', '&nbsp;');
		        // 선종 값 초기화
		        $('#dataList').jqGrid('setCell',rowKey, 'ship_type', '&nbsp;');
		        // Bottom 의 DP 공정 정보 업데이트
		        updateDrawingInfo('');
		        
		        
		        // 공사번호(호선)가 'S000' or 'PS0000' or Multi 공사번호(호선)일때 도면번호를 '*****'로 설정하고, 그 외의 경우에는 해당 호선에 대한 도면구분 목록을 DB에서 쿼리...
		        if (projectNo == "") {
		            return;
		        }
		        else if (projectNo == 'S000' || projectNo == 'PS0000') {
		        	 $('#dataList').jqGrid('setCell',rowKey, 'dwg_code', '*****');
		        }
		        else if (projectNo.indexOf(",") > -1) {
		        	$('#dataList').jqGrid('setCell',rowKey, 'dwg_code', '*****');
		        }		        
		        else {
		            drawingTypesForWorkQueryProc(projectNo, "");
		        }
            }
            $('#dataList').jqGrid('setCell',rowKey, 'op_code', rs); 
         	// OP CODE가 도면시수(A TYPE)이 아니면 도면번호를 '*****'로 설정
	        if(rs.substring(0, 1) != 'A'){		 
	        	$('#dataList').jqGrid('setCell',rowKey, 'dwg_code', '*****');
			}
            // OP CODE가 'A2x'가 아닌 경우 '원인부서' 입력 값을 초기화한다
            if (rs.substring(0, 2) != 'A2') {
            	$('#dataList').jqGrid('setCell',rowKey, 'cause_depart', '&nbsp;');
            }
            // OP CODE가 '20' & 'A2x'가 아닌 경우 '근거' 입력 값을 초기화한다
            if (rs.substring(0, 2) != 'A2' && rs != '20') {
            	$('#dataList').jqGrid('setCell',rowKey, 'basis', '&nbsp;');
            	$('#dataList').jqGrid('setCell',rowKey, 'basis_display', '&nbsp;');
            }
            $('#dataList').jqGrid('setCell',rowKey, 'oper', 'U');
		}
    }
 	
 	
	// 선종 리스트 값들을 DB에서 쿼리해오고 '선종' LOV를 채우는 서브-프로시저
    function shipTypeQueryProc(selectedValue)
	{
    	var shipTypeSelect = $("#shipTypeList");
    	shipTypeSelect.empty();
    	shipTypeSelect.append("<option value=''></option>");
    	$.ajax({
	    	url:'<c:url value="getShipType.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		for (var i = 0; i < jsonData.rows.length; i++) {
	    			var row = jsonData.rows[i];
                    if (row.c_code == "") continue;
                    
                    if (selectedValue != "" && selectedValue == row.c_code){
                    	//도면 구분 값 셋팅    ajax리턴 value name->dwgtype
                    	shipTypeSelect.append("<option value='"+row.c_code+"' selected='selected'>"+row.c_code+"</option>");
                    } else {
                    	shipTypeSelect.append("<option value='"+row.c_code+"'>"+row.c_code+"</option>");
                    }
                }
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
	
	//custom formatter로 인한 row selection 강제 활성화처리
	function fn_setSelectionRow(id){
		var rowKey = $("#dataList").jqGrid('getGridParam',"selrow");
		if(id != rowKey){
			$("#dataList").jqGrid('resetSelection',id);
		}
		$("#dataList").jqGrid('setSelection',id);
	}
	// 해당 호선 + 도면에 대한 공정 계획일, 실적일 데이터를 쿼리하여 표시
	function updateDrawingInfo(projectNo, drawingNo) {
		if (application_form.drawingNo.value == drawingNo)
			return;
		application_form.drawingNo.value = drawingNo;

		initializeProgressDates();

		if (projectNo == '' || projectNo == 'S000' || drawingNo == '' || drawingNo == '*****' || drawingNo == '#####')
			return;
		
		$.ajax({
	    	url:'<c:url value="getDesignProgressInfo.do"/>',
	    	type:'POST',
	    	contentType: "application/x-www-form-urlencoded; charset=UTF-8",
	    	data : {"projectNo" : projectNo,
	    			"drawingNo" : drawingNo},
	    	success : function(data){
	    		var jsonData = JSON.parse(data);
	    		if(jsonData == null)return;
	    		application_form.dwPlanStart.value = jsonData.dw_plan_s 	== undefined ? "" :jsonData.dw_plan_s;
				application_form.dwPlanFinish.value = jsonData.dw_plan_f 	== undefined ? "" :jsonData.dw_plan_f;
				application_form.dwActualStart.value = jsonData.dw_act_s 	== undefined ? "" :jsonData.dw_act_s;
				application_form.dwActualFinish.value = jsonData.dw_act_f 	== undefined ? "" :jsonData.dw_act_f;
				application_form.owPlanStart.value = jsonData.ow_plan_s 	== undefined ? "" :jsonData.ow_plan_s;
				application_form.owPlanFinish.value = jsonData.ow_plan_f 	== undefined ? "" :jsonData.ow_plan_f;
				application_form.owActualStart.value = jsonData.ow_act_s 	== undefined ? "" :jsonData.ow_act_s;
				application_form.owActualFinish.value = jsonData.ow_act_f 	== undefined ? "" :jsonData.ow_act_f;
				application_form.clPlanStart.value = jsonData.cl_plan_s 	== undefined ? "" :jsonData.cl_plan_s;
				application_form.clPlanFinish.value = jsonData.cl_plan_f 	== undefined ? "" :jsonData.cl_plan_f;
				application_form.clActualStart.value = jsonData.cl_act_s 	== undefined ? "" :jsonData.cl_act_s;
				application_form.clActualFinish.value = jsonData.cl_act_f 	== undefined ? "" :jsonData.cl_act_f;
				application_form.rfPlanStart.value = jsonData.rf_plan_s 	== undefined ? "" :jsonData.rf_plan_s;
				application_form.rfActualStart.value = jsonData.rf_act_s 	== undefined ? "" :jsonData.rf_act_s;
				application_form.wkPlanStart.value = jsonData.wk_plan_s 	== undefined ? "" :jsonData.wk_plan_s;
				application_form.wkActualStart.value = jsonData.wk_act_s 	== undefined ? "" :jsonData.wk_act_s;
				application_form.planMH.value = jsonData.planmh 			== undefined ? "" :jsonData.planmh;
				application_form.actualMH.value = jsonData.actualmh 		== undefined ? "" :jsonData.actualmh;
	    	}, 
	    	error : function(e){
	    		alert(e);
	    	}
	    });
	}
	// 계획일, 실적일 전체 항목들의 표시를 ''로 초기화 
	function initializeProgressDates() {
		application_form.dwPlanStart.value = "";
		application_form.dwPlanFinish.value = "";
		application_form.owPlanStart.value = "";
		application_form.owPlanFinish.value = "";
		application_form.clPlanStart.value = "";
		application_form.clPlanFinish.value = "";
		application_form.rfPlanStart.value = "";
		application_form.wkPlanStart.value = "";
		application_form.dwActualStart.value = "";
		application_form.dwActualFinish.value = "";
		application_form.owActualStart.value = "";
		application_form.owActualFinish.value = "";
		application_form.clActualStart.value = "";
		application_form.clActualFinish.value = "";
		application_form.rfActualStart.value = "";
		application_form.wkActualStart.value = "";
		application_form.planMH.value = "";
		application_form.actualMH.value = "";
	}

</script>
</body>
</html>
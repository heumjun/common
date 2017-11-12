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
<title>호선 다중선택</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div id="mainDiv" class="mainDiv">
		<div id="contentBody" class="content">
			<form id="application_form" name="application_form" method="post">
				<input type="hidden" name="employee_id" value="${employee_id }">
				<div id="searchDiv">
					<table class="searchArea conSearch">
						<c:choose>
							<c:when test="${isNonProject eq true}">
								<col width="20%"/><col width="20%"/><col width="20%"/><col width="20%"/><col width="20%"/>
							</c:when>
							<c:when test="${isMultiProject eq true }">
								<col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="*"/>
							</c:when>
							<c:otherwise>
								<col width="8%"/><col width="8%"/><col width="8%"/><col width="15%"/><col width="8%"/>
								<col width="8%"/><col width="8%"/><col width="8%"/><col width="15%"/><col width="8%"/><col width="5%"/><col width="*"/>
							</c:otherwise>
						</c:choose>
						<tr>
							<c:choose>
								<c:when test="${isNonProject eq true}">
									<th align="center" colspan="${fn:length(opCodeListMID)}">비공사시수</th>
								</c:when>
								<c:when test="${isMultiProject eq true }">
									<th align="center" colspan="${fn:length(opCodeListMID)}">비도면시수 (도면미지정)</th>
								</c:when>
								<c:otherwise>
									<th align="center" colspan="5" style="border-right: 1px #d6ddee solid;">도면시수 (도면지정)</th>
									<th align="center" colspan="6">비도면시수 (도면미지정)</th>
								</c:otherwise>
							</c:choose>
						</tr>
						<tr>
							<c:forEach var="item" items="${opCodeListMID }">
        						<th style="cursor: pointer; border-right: 1px #d6ddee solid;<c:if test="${item.grt_code eq defaultGRT and item.mid_code eq defaultMID }">background-color:#00ffff;</c:if>" 
        						id="${item.grt_code}${item.mid_code}" class="" onclick="changeSelectedOpGroup(this)">${item.mid_desc}</th>							
        					</c:forEach>
						</tr>
					</table>
				</div>
			</form>
			<c:forEach var="item" items="${opCodeListMID }" varStatus="status">
				<c:set var="displayStr" value="display:none;"/>
				<c:if test="${item.grt_code eq defaultGRT and item.mid_code eq defaultMID }"><c:set var="displayStr" value=""/></c:if>
				<div id="opGroup_${item.grt_code}${item.mid_code}" class="displayGroup" STYLE="background-color:#ffffff; width:100%;height:300px; overflow:auto; position:relative; ${displayStr}">
					<table class="insertArea">
				        <c:forEach var="item1" items="${opCodeListSUB }" varStatus="status1">
				        	<c:if test="${status1.first }">
								<col width="25%"/><col width="*"/>
							        <tr>
							            <th>OP CODE</th>
							            <th>설 명</th>
							        </tr>
					        </c:if>
				        	<c:choose>
				        		<c:when test="${item.grt_code ne item1.grt_code or item.mid_code ne item1.mid_code }"></c:when>
				        		<c:otherwise>
				        			<tr class="dataRow" ondblclick="selectOpCodeAndClose(this,'${item1.op_code}');" onclick="selectOpCode(this, '${item1.op_code}');">
		            					<td>${item1.op_code}</td>
		            					<td style="text-align: left;">${item1.sub_desc}</td>
		        					</tr>
				        		</c:otherwise>
				        	</c:choose>
				        </c:forEach>
				        <c:if test="${item.grt_code eq 'C' and item.mid_code eq '1' }">
			        		<table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#ffffff">	    
								<tr>
									<td width="5%">&nbsp;</td>
									<td>
										<font color="red">
										S000(비공사시수) OP CODE 'C11 : 견적지원' -> PS0000(견적호선) 'B10 : 견적지원' 으로 변경됨. <br>
										확인 후 입력바랍니다.					
										</font>
									</td>
								</tr>
							</table>
				        </c:if>
					</table>
				</div>
			</c:forEach>
		</div>
		<div style="text-align: right;">
			<input type="button" value="확인"  id="btn_ok" class="btn_blue" onclick="selectSubmit()"/>
			<input type="button" value="취소"  id="btnClose" class="btn_blue" onclick="javascript:window.close();"/>
		</div>
	</div>

<script language="javascript">

var selectedOpCode = "";

function changeSelectedOpGroup(targetTD) 
{
	// OPCODEGROUP ID KEY값을 가져와 해당 ID의 STYLE 초기화 (backgroundColor, display)
	
	var opSelectGroupList = $(targetTD).closest("tr");
	var targetDivObj = $("#opGroup_"+$(targetTD).attr("id"));
	opSelectGroupList.children().css("background-color","#F7F7F7");
	$(".displayGroup").css("display","none");
	$(targetTD).css("background-color","#00ffff");
	targetDivObj.css("display","");
	selectOpCode(null,'');
}

function selectOpCode(trObj, opCode)
{
	var selectedTR = $(trObj);
    if (selectedTR != null) $(".dataRow").css("background-color","#ffffff");
    selectedOpCode = opCode;
    if (selectedTR != null) selectedTR.css("background-color","#ffff00");
}

function selectOpCodeAndClose(trObj, opCode)
{
    selectOpCode(trObj, opCode);    
    selectSubmit();
}

function selectSubmit()
{
    if (selectedOpCode == '') {
        alert('선택된 OP CODE가 없습니다!');
        return;
    }
    if (selectedOpCode == 'A13') {
        alert('직영은 외주도면작성(외주)는 선택할 수 없습니다.');
        return;
    }
    window.returnValue = selectedOpCode;
    window.close();
}

</script>
</body>
</html>
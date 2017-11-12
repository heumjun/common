<%--  
§DESCRIPTION: 설계시수결재 결재현황판 iframe
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPApprovalBoard.jsp
§CHANGING HISTORY: 
§    2015-10-05: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%--========================== JSP =========================================--%>

<%
	String deptCode = StringUtil.setEmptyExt(request.getParameter("deptCode"));
	String dateSelected = StringUtil.setEmptyExt(request.getParameter("dateSelected"));
	
	// 선택일자의 일자 정보 추출
	Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
    java.util.Date date = sdf.parse(dateSelected); 	
	cal.setTime(date);
	
	String fromDate = "";
	String toDate = "";
	
	int month = cal.get(Calendar.MONTH)+1;   // 해당 월 구하기	
	int year = cal.get(Calendar.YEAR);   // 해당 년 구하기
	int lastDay = cal.getActualMaximum(Calendar.DATE);  // 월의 마지막 일자 구하기
	
	fromDate = year + "-" + month + "-01";   //해당 월 시작일자 (ex: 2015-10-01)
	toDate = year + "-" + month + "-" + lastDay;   //해당 월 마지막일자 (ex: 2015-10-31)
	
	
	//  날짜 포맷에 맞춤 : 시작일자
	Calendar cal_fromDate = Calendar.getInstance();
    java.util.Date date1 = sdf.parse(fromDate); 	
    cal_fromDate.setTime(date1);
    fromDate = sdf.format(cal_fromDate.getTime());    
    
	//  날짜 포맷에 맞춤 : 마지막일자
	Calendar cal_toDate = Calendar.getInstance();
    java.util.Date date2 = sdf.parse(toDate); 	
    cal_toDate.setTime(date2);
    toDate = sdf.format(cal_toDate.getTime());      
	
	
	String errStr = "";
	
    ArrayList dpApprovalList = null;   
    ArrayList dpInputRateList = null;
    try {
        dpApprovalList = getPartDPConfirmsList(deptCode, fromDate, toDate);     // 결재현황
        dpInputRateList = getPartDPInputRateList(deptCode, fromDate, toDate);   // 시수입력율
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>

<%--========================== HTML HEAD ===================================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>

<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>

<%--========================== HTML BODY ===================================--%>
<body>
<font color="blue">현황 더블클릭 시 해당 일자로 조회됩니다.</font>
<form name="ApprovalBoardForm" method="post">
            	<table class="insertArea">
            		<tr height="24" bgcolor="#e5e5e5">
            			<th class="td_standard" width="70">
							<%=month %>월            				
            			</th>
            			<th class="td_standardSmall" width="30">
            				일자
            			</th>
	           			<%
				        for (int i = 0; dpApprovalList != null && i < dpApprovalList.size(); i++) 
				        {
				            Map map = (Map)dpApprovalList.get(i);
				
				            String workdayStr = (String)map.get("WORK_DAY");
				            String confirmYN = (String)map.get("CONFIRM_YN");
	           			%>
	           					<th class="td_standardSmall" width="30">	
	           						<%=i+1%>
	           					</th>
	           			<%
	           			}
	           			%>
            		</tr>
            		
            		<tr>
            			<td width="70" bgcolor="#e5e5e5">
            				입력현황            				
            			</td>
            			<td width="30"  bgcolor="#e5e5e5">
            				%
            			</td>
	           			<%
				        for (int i = 0; dpInputRateList != null && i < dpInputRateList.size(); i++) 
				        {
				            Map map = (Map)dpInputRateList.get(i);
							
				            String workdayStr = (String)map.get("WORK_DAY");
				            String isworkday = (String)map.get("ISWORKDAY");
				            String input_rate = (String)map.get("INPUT_RATE");

				            // 평일일 경우 시수입력율이 100% 미만일 때 빨간색 표시
				            if("Y".equals(isworkday))
				            {
				            	if(!"-".equals(input_rate))
				            	{
				            		if(Integer.parseInt(input_rate) < 100)
				            		{
				            			input_rate = "<font color='red'>"+input_rate+"%</font>";			            				
				            		} else {
				            			input_rate += "%";
				            		}
				            	}
				            } else {
				            	// 휴일일 경우는 입력율만 표시
				            	if(!"-".equals(input_rate))
				            	{	
				            		input_rate += "%";
				            	}				            	
				            }
	           			%>
	           					<td class="td_standardSmall" width="30" ondblclick="callViewDPApprovals('<%=workdayStr%>');">	
	           						<%=input_rate%>
	           					</td>
	           			<%
	           			}
	           			%>           			
            		</tr>  
            		
            		<tr>
            			<td width="70"  bgcolor="#e5e5e5">
            				결재현황            				
            			</td>
            			<td width="30"  bgcolor="#e5e5e5">
            				Y/N
            			</td>
				        <%
				        for (int i = 0; dpApprovalList != null && i < dpApprovalList.size(); i++) 
				        {
				            Map map = (Map)dpApprovalList.get(i);
				
				            String workdayStr = (String)map.get("WORK_DAY");
				            String confirmYN = (String)map.get("CONFIRM_YN");
				            String bgColor = "";
				            if (confirmYN.equals("N")) bgColor = "#FFB2F5";

				            %>
	           					<td width="30"  bgcolor="<%=bgColor%>" ondblclick="callViewDPApprovals('<%=workdayStr%>');">		           						
	           						<%=confirmYN%>
	           					</td>
	           			<%
	           				}
	           			%>          			
            		</tr>             		          		
            	</table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 선택된 일자의 시수입력사항을 부모창에 표시
    function callViewDPApprovals(workdayStr)
    {
        parent.callViewDPApprovals(workdayStr);
    }

</script>

</html>            	
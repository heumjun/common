<%--  
§DESCRIPTION: 설계시수입력 화면 - Bottom 부분(DP공정 정보 출력)
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInputBottom.jsp
§CHANGING HISTORY: 
§    2009-04-07: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputBottom">

<input type="hidden" name="drawingNo" value="" />

<table width="100%" cellSpacing="1" cellpadding="1" border="0">
<tr>
<td>

    <span clientWidth="180" clientHeight="20" style="background-color:#0000ff;font-size:11pt;font-family:돋움;color:white;font-weight:bold;">
        ※ DP 공정 ※
    </span>

    <table width="100%" cellSpacing="0" cellpadding="1" border="0" align="left">
        <tr height="6">
            <td colspan="5"></td>
        </tr>

        <tr height="20" >
            <td class="td_standard" bgcolor="deepskyblue">계획</td>
            <td class="td_standard"><input name="dwPlanStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="dwPlanFinish" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="owPlanStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="owPlanFinish" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="clPlanStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="clPlanFinish" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="rfPlanStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="wkPlanStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standardBold">
                <input name="planMH" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;color:#ff0000;font-weight:bold;text-align:center;" />
            </td>
        </tr>
        <tr height="20" >
            <td class="td_standard">&nbsp;</td>
            <td colspan="2" align="center">
                <img src="images/stxTemp1.jpg" /><br>
                <font size="2" face="돋움"><b>착수일</b></font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <font size="2" face="돋움"><b>완료일</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp2.jpg" /><br>
                <font size="2" face="돋움"><b>선주승인발송</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp3.jpg" /><br>
                <font size="2" face="돋움"><b>선주승인접수</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp4.jpg" /><br>
                <font size="2" face="돋움"><b>선급승인발송</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp5.jpg" /><br>
                <font size="2" face="돋움"><b>선급승인접수</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp6.jpg" /><br>
                <font size="2" face="돋움"><b>참고용발송</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp7.jpg" /><br>
                <font size="2" face="돋움"><b>작업용발송</b></font>
            </td>
            <td align="center">
                <img src="images/stxTemp8.jpg" /><br>
                <font size="2" face="돋움"><b>시수</b></font>
            </td>
        </tr>
        <tr height="20" >
            <td class="td_standard" bgcolor="deepskyblue">실적</td>
            <td class="td_standard"><input name="dwActualStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="dwActualFinish" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="owActualStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="owActualFinish" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="clActualStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="clActualFinish" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="rfActualStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standard"><input name="wkActualStart" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;" /></td>
            <td class="td_standardBold">
                <input name="actualMH" value="" readonly style="background-color:#D8D8D8;width:80px;border:0;color:#ff0000;font-weight:bold;text-align:center;" />
            </td>
        </tr>    
    </table>

</td>
</tr>
</table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // Docuemnt의 Keydown 핸들러 구현 - 백스페이스 클릭 시 History back 되는 것을 방지 등
    document.onkeydown = keydownHandler;

    // 계획일, 실적일 전체 항목들의 표시를 ''로 초기화 
    function initializeProgressDates()
    {
        DPInputBottom.dwPlanStart.value = "";
        DPInputBottom.dwPlanFinish.value = "";
        DPInputBottom.owPlanStart.value = "";
        DPInputBottom.owPlanFinish.value = "";
        DPInputBottom.clPlanStart.value = "";
        DPInputBottom.clPlanFinish.value = "";
        DPInputBottom.rfPlanStart.value = "";
        DPInputBottom.wkPlanStart.value = "";
        DPInputBottom.dwActualStart.value = "";
        DPInputBottom.dwActualFinish.value = "";
        DPInputBottom.owActualStart.value = "";
        DPInputBottom.owActualFinish.value = "";
        DPInputBottom.clActualStart.value = "";
        DPInputBottom.clActualFinish.value = "";
        DPInputBottom.rfActualStart.value = "";
        DPInputBottom.wkActualStart.value = "";
        DPInputBottom.planMH.value = "";
        DPInputBottom.actualMH.value = "";        
    }

    // 해당 호선 + 도면에 대한 공정 계획일, 실적일 데이터를 쿼리하여 표시
    function updateDrawingInfo(projectNo, drawingNo)
    {
        if (DPInputBottom.drawingNo.value == drawingNo) return;
        DPInputBottom.drawingNo.value = drawingNo;

        initializeProgressDates();

        if (projectNo == '' || projectNo == 'S000' || drawingNo == '' || drawingNo == '*****' || drawingNo == '#####') return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.onreadystatechange = function() 
		{
           if (xmlHttp.readyState == 4) {
                if (xmlHttp.status == 200) {
					var resultMsg = xmlHttp.responseText;
                    
					if (resultMsg != null)
					{
                        resultMsg = resultMsg.trim();
                        
                        if (resultMsg == "ERROR" || resultMsg == "") return;

                        var strs = resultMsg.split(",");

                        DPInputBottom.dwPlanStart.value = strs[0];
                        DPInputBottom.dwPlanFinish.value = strs[1];
                        DPInputBottom.dwActualStart.value = strs[2];
                        DPInputBottom.dwActualFinish.value = strs[3];
                        DPInputBottom.owPlanStart.value = strs[4];
                        DPInputBottom.owPlanFinish.value = strs[5];
                        DPInputBottom.owActualStart.value = strs[6];
                        DPInputBottom.owActualFinish.value = strs[7];
                        DPInputBottom.clPlanStart.value = strs[8];
                        DPInputBottom.clPlanFinish.value = strs[9];
                        DPInputBottom.clActualStart.value = strs[10];
                        DPInputBottom.clActualFinish.value = strs[11];
                        DPInputBottom.rfPlanStart.value = strs[12];
                        DPInputBottom.rfActualStart.value = strs[13];
                        DPInputBottom.wkPlanStart.value = strs[14];
                        DPInputBottom.wkActualStart.value = strs[15];
                        DPInputBottom.planMH.value = strs[16];
                        DPInputBottom.actualMH.value = strs[17];
					}
					else {
						//alert(resultMsg);
					}
				}
				else {
					//alert("Server Error...");
				}
			}		
		}

        var paramStr = "requestProc=GetDesignProgressInfo&projectNo=" + projectNo + "&drawingNo=" + drawingNo;
		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?" + paramStr, true);
		//xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
		xmlHttp.send(null);
    }

</script>

</html>
<%--  
§DESCRIPTION: 설계시수관리 - 시수 적용율(FACTOR) CASE 관리 Main 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_MHFactorCaseMain.jsp
§CHANGING HISTORY: 
§    2009-07-27: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String errStr = "";

    String loginID = emxGetParameter(request, "loginID");
    String mhFactorCase = StringUtil.setEmptyExt(emxGetParameter(request, "mhFactorCase"));
    String isActiveCase = StringUtil.setEmptyExt(emxGetParameter(request, "isActiveCase"));

    ArrayList mhFactorValues = null;
    try {
        if (!mhFactorCase.equals("") && !mhFactorCase.equals("add"))
            mhFactorValues = getMHFactorCaseValue(mhFactorCase);
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>시수 적용율(FACTOR) CASE 관리</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPMHFactorCaseMain">

    <input type="hidden" name="dataChanged" value="false" /> 
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="mhFactorCase" value="<%=mhFactorCase%>" />

<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                작업 중에 에러가 발생하였습니다. IT 담당자에게 문의하시기 바랍니다.<br>
                ※에러 메시지: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else if (mhFactorCase.equals("add"))
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="yellow">
        <tr height="20">
        <td>
            <input type="checkbox" name="defaultCaseCheck" style="background-color:yellow" />
            Default Case
        </td>
        </tr>
    </table>

    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold">NO</td>
            <td class="td_standardBold">설계경력(개월)</td>
            <td class="td_standardBold">Factor</td>
        </tr>

        <tr height="20" bgcolor="#ffffff">
            <td width="10%" class="td_standard">1</td>
            <td width="70%" class="td_standard">
                <input name="monthFrom1" value="1" class="input_noBorder2" style="width:40px;background-color:#00ff00" readonly /> 개월 이상 ~ 
                <input name="monthTo1" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" /> 개월 이하
            </td>
            <td width="20%" class="td_standard">
                <input name="factorValue1" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" />
            </td>
        </tr>
        <tr height="20" bgcolor="#ffffff">
            <td width="10%" class="td_standard">2</td>
            <td width="70%" class="td_standard">
                <input name="monthFrom2" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" /> 개월 이상 ~ 
                <input name="monthTo2" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" /> 개월 이하
            </td>
            <td width="20%" class="td_standard">
                <input name="factorValue2" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" />
            </td>
        </tr>
        <tr height="20" bgcolor="#ffffff">
            <td width="10%" class="td_standard">3</td>
            <td width="70%" class="td_standard">
                <input name="monthFrom3" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" /> 개월 이상 ~ 
                <input name="monthTo3" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" /> 개월 이하
            </td>
            <td width="20%" class="td_standard">
                <input name="factorValue3" value="" class="input_noBorder2" style="width:40px;" onchange="setDataChangedFlag();" />
            </td>
        </tr>
    </table>
<%
}
else
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="yellow">
        <tr height="20">
        <td>
            <input type="checkbox" name="defaultCaseCheck" style="background-color:yellow"
                <% if (isActiveCase.equalsIgnoreCase("true")) { %> checked disabled <% } %> 
                onchange="setDataChangedFlag();"
            />
            Default Case
        </td>
        </tr>
    </table>

    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold">NO</td>
            <td class="td_standardBold">설계경력(개월)</td>
            <td class="td_standardBold">Factor</td>
        </tr>

        <%
        for (int i = 0; mhFactorValues != null && i < mhFactorValues.size(); i++) 
        {
            Map map = (Map)mhFactorValues.get(i);
            String factorNo = (String)map.get("FACTOR_NO");
            String monthFrom = (String)map.get("CAREER_MONTH_FROM");
            String monthTo = (String)map.get("CAREER_MONTH_TO");
            String factorValue = (String)map.get("FACTOR_VALUE");
            %>
            <tr height="20" bgcolor="#ffffff">
                <td width="10%" class="td_standard"><%=factorNo%></td>
                <td width="70%" class="td_standard">
                    <input name="" value="<%=monthFrom%>" class="input_noBorder2" style="width:40px;background-color:#00ff00" readonly /> 개월 이상 ~ 
                    <input name="" value="<%=monthTo%>" class="input_noBorder2" style="width:40px;background-color:#00ff00" readonly /> 개월 이하
                </td>
                <td width="20%" class="td_standard"><%=factorValue%></td>
            </tr>
            <%
        }
        %>
    </table>
<%
}
%>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript">

    function containsCharsOnly(input, chars) 
    {
        for (var inx = 0; inx < input.length; inx++) {
           if (chars.indexOf(input.charAt(inx)) == -1)
               return false;
        }
        return true;
    }    

    // 변경사항 있음으로 설정
    function setDataChangedFlag()
    {
        DPMHFactorCaseMain.dataChanged.value = "true";
    }

    // 입력사항 유효성 체크
    function checkInputs()
    {
        if (DPMHFactorCaseMain.dataChanged.value == "false") {
            alert("적용할 추가사항이 없습니다!");
            return false;
        }

        if (DPMHFactorCaseMain.mhFactorCase.value != "add") return true;

        var chars = "0123456789";
        var chars2 = "0123456789.";

        var monthTo1 = DPMHFactorCaseMain.monthTo1.value.trim();
        if (monthTo1.length != 0 && (!containsCharsOnly(monthTo1, chars) || Number(monthTo1) < 1)) {
            alert("1 번째 항의 To 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthTo1.focus();
            return false;
        }
        var factorValue1 = DPMHFactorCaseMain.factorValue1.value.trim();
        if (factorValue1.length == 0 || !containsCharsOnly(factorValue1, chars2) || eval(factorValue1) < 0 || eval(factorValue1) > 1) {
            alert("1 번째 항의 Factor 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.factorValue1.focus();
            return false;
        }

        var monthFrom2 = DPMHFactorCaseMain.monthFrom2.value.trim();
        if (monthFrom2.length != 0 && (!containsCharsOnly(monthFrom2, chars) || Number(monthTo1) + 1 != Number(monthFrom2))) {
            alert("2 번째 항의 From 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthFrom2.focus();
            return false;
        }
        var monthTo2 = DPMHFactorCaseMain.monthTo2.value.trim();
        if ((monthFrom2.length == 0 && monthTo2.length != 0) ||
            (monthTo2.length != 0 && (!containsCharsOnly(monthTo2, chars) || Number(monthTo2) < Number(monthFrom2)))
           ) 
        {
            alert("2 번째 항의 To 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthTo2.focus();
            return false;
        }
        var factorValue2 = DPMHFactorCaseMain.factorValue2.value.trim();
        if ((monthFrom2.length == 0 && factorValue2.length != 0) ||
            (monthFrom2.length != 0 && factorValue2.length == 0) ||
            (!containsCharsOnly(factorValue2, chars2) || eval(factorValue2) < 0 || eval(factorValue2) > 1)
           ) 
        {
            alert("2 번째 항의 Factor 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.factorValue2.focus();
            return false;
        }

        var monthFrom3 = DPMHFactorCaseMain.monthFrom3.value.trim();
        if (monthFrom3.length != 0 && (!containsCharsOnly(monthFrom3, chars) || Number(monthTo2) + 1 != Number(monthFrom3))) {
            alert("3 번째 항의 From 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthFrom3.focus();
            return false;
        }
        var monthTo3 = DPMHFactorCaseMain.monthTo3.value.trim();
        if ((monthFrom3.length == 0 && monthTo3.length != 0) ||
            (monthTo3.length != 0 && (!containsCharsOnly(monthTo3, chars) || Number(monthTo3) < Number(monthFrom3)))
           ) 
        {
            alert("3 번째 항의 To 개월 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.monthTo3.focus();
            return false;
        }
        var factorValue3 = DPMHFactorCaseMain.factorValue3.value.trim();
        if ((monthFrom3.length == 0 && factorValue3.length != 0) ||
            (monthFrom3.length != 0 && factorValue3.length == 0) ||
            (!containsCharsOnly(factorValue3, chars2) || eval(factorValue3) < 0 || eval(factorValue3) > 1)
           ) 
        {
            alert("3 번째 항의 Factor 값 형식이 올바르지 않습니다.");
            DPMHFactorCaseMain.factorValue3.focus();
            return false;
        }

        if (!((monthTo1.length == 0) || 
              (monthFrom2.length != 0 && monthTo2.length == 0) ||
              (monthFrom3.length != 0 && monthTo3.length == 0)
             )) 
        {
            alert("적어도 하나의 To 개월 값은 빈(Empty) 값이어야 합니다.!");
            return false;
        }
    
        return true;
    }

    // 추가사항 저장
    function saveAddedMHFactorCase()
    {
        if (checkInputs()) 
        {
            // Default(Active) Case로 지정하는 경우
            if (DPMHFactorCaseMain.mhFactorCase.value != "add") {
                if (DPMHFactorCaseMain.defaultCaseCheck.disabled != true && 
                    DPMHFactorCaseMain.defaultCaseCheck.checked == true)
                {
                    var caseNo = DPMHFactorCaseMain.mhFactorCase.value;
                    var loginID = DPMHFactorCaseMain.loginID.value;
                    var paramStr = caseNo + "," + loginID;

                    var updateResult = callDPCommonAjaxProc("UpdateActiveMHFactorCase", "params", paramStr);
                    if (updateResult == "ERROR") alert("ERROR");
                    else {
                        alert("Default Case로 설정되었습니다!");
                        parent.DP_MHFACTOR_HEADER.location = "stxPECDPInput_MHFactorCaseHeader.jsp";
                    }
                }
            }
            // Add 경우
            else if (DPMHFactorCaseMain.mhFactorCase.value == "add") {
                var caseStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                var mhFactorCaseSelectObj = parent.DP_MHFACTOR_HEADER.DPMHFactorCaseHeader.mhFactorCaseSelect;
                var maxCase = mhFactorCaseSelectObj.options[mhFactorCaseSelectObj.options.length - 1].value;
                var maxCaseIdx = caseStr.indexOf(maxCase);

                var caseNo = caseStr.charAt(maxCaseIdx + 1);
                var monthFrom1 = DPMHFactorCaseMain.monthFrom1.value.trim();
                var monthTo1 = DPMHFactorCaseMain.monthTo1.value.trim();
                var factorValue1 = DPMHFactorCaseMain.factorValue1.value.trim();
                var monthFrom2 = DPMHFactorCaseMain.monthFrom2.value.trim();
                var monthTo2 = DPMHFactorCaseMain.monthTo2.value.trim();
                var factorValue2 = DPMHFactorCaseMain.factorValue2.value.trim();
                var monthFrom3 = DPMHFactorCaseMain.monthFrom3.value.trim();
                var monthTo3 = DPMHFactorCaseMain.monthTo3.value.trim();
                var factorValue3 = DPMHFactorCaseMain.factorValue3.value.trim();
                var loginID = DPMHFactorCaseMain.loginID.value;
                var defaultCaseCheck = DPMHFactorCaseMain.defaultCaseCheck.checked;

                var paramStr = caseNo + ",";
                paramStr += monthFrom1 + "|" + monthTo1 + "|" + factorValue1 + ",";
                paramStr += monthFrom2 + "|" + monthTo2 + "|" + factorValue2 + ",";
                paramStr += monthFrom3 + "|" + monthTo3 + "|" + factorValue3 + ",";
                paramStr += (defaultCaseCheck == true) ? "true," : "false,";
                paramStr += loginID;

                // TODO 동일한 구성의 Case가 기 존재하는지 체크하는 로직을 추가

                var updateResult = callDPCommonAjaxProc("AddActiveMHFactorCase", "params", paramStr);
                if (updateResult == "ERROR") alert("적용에 실패하였습니다!");
                else {
                    alert("저장완료!");
                    parent.DP_MHFACTOR_HEADER.location = "stxPECDPInput_MHFactorCaseHeader.jsp?selectedCaseNo=" + caseNo;
                }
            }
        }
    }

</script>


</html>

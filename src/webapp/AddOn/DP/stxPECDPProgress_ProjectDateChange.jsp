<%--  
§DESCRIPTION: 공정조회 - 조회가능 호선관리 창
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgress_ProjectSelect.jsp
§CHANGING HISTORY: 
§    2009-06-11: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
    String errStr = "";

    ArrayList allProjectList = new ArrayList();
    ArrayList slDWGTypeKind = new ArrayList();
    try {
        allProjectList = getProjectChangableDateDWGList();
        
        ArrayList mlDWGTYPEnKIND = getPLM_DATE_CHANGE_ABLE_DWG_TYPE();
    	Iterator itrDWGTypeKind = mlDWGTYPEnKIND.iterator();
    	
    	while(itrDWGTypeKind.hasNext())
    	{
    		Map mapDWGTypeKind = (Map)itrDWGTypeKind.next();
    		String DWG_KIND = (String)mapDWGTypeKind.get("DWG_KIND");
    		String DWG_TYPE = (String)mapDWGTypeKind.get("DWG_TYPE");
    		slDWGTypeKind.add(DWG_KIND+"|"+DWG_TYPE);
    	}
    }
    catch (Exception e) {
        errStr = e.toString();
    }
    System.out.println(slDWGTypeKind);
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>조회가능 호선관리</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    var changedList = new Array();
    var isCheckedChange = false;
    
    function fnCheckAll(obj,name)
    {
    	isCheckedChange=true;
    	var arrCheck = document.getElementsByName(name);
    	for(i=0;i<arrCheck.length;i++)
    	{
    		arrCheck[i].checked = obj.checked;
    	}
    } 
    
    function fnAbleAll(DWG_KIND)
    {
    	var oTbl = document.getElementById("dataList");
    	if(DWG_KIND == "기본도")
    	{
    		for(i=0;i<oTbl.rows.length;i++)
    		{
    			toggleStateStr()
    		}
    	} else if(DWG_KIND == "MAKER")
    	{
    		for(i=0;i<oTbl.rows.length;i++)
    		{
    			toggleStateStr()
    		}
    	} else if(DWG_KIND == "생설도")
    	{
    		for(i=0;i<oTbl.rows.length;i++)
    		{
    			toggleStateStr()
    		}
    	}
    }

    // 상태(Opened - Closed) 값을 Toggle
    function toggleStateStr(PROJECTNO, DWG_KIND, tdObject)
    {
        var str = tdObject.innerHTML;
        var strChange = tdObject.innerHTML;
        
        if (str == "OPENED")
        {
        	strChange = "CLOSED";
        	tdObject.innerHTML = strChange;
        	tdObject.style.backgroundColor = "#fff0f5";
        } else if (str == "CLOSED") 
        {
        	strChange = "OPENED";
        	tdObject.innerHTML = strChange;
        	tdObject.style.backgroundColor = "#ffffff";
        }

        var isExist = false;
        for (var i = 0; i < changedList.length; i++) {
            if (changedList[i].indexOf(PROJECTNO + "|" + DWG_KIND + "|") >= 0) {
                changedList[i] = PROJECTNO + "|" + DWG_KIND + "|" + strChange;
                isExist = true;
                break;
            }
        }
        if (!isExist) changedList[changedList.length] = PROJECTNO + "|" + DWG_KIND + "|" + strChange;
    }
    
    function fnCheckUrl(name)
    {
    	var param = "";
    	var arrCheck = document.getElementsByName(name);
    	for(i=0;i<arrCheck.length;i++)
    	{
    		if(arrCheck[i].checked)param += "&"+name+"="+arrCheck[i].value;
    	}
    	return param;
    }
    
    // 변경사항을 저장(DB에 적용)
    function updateSearchableProjectList()
    {
        if (!isCheckedChange && changedList.length <= 0) {
            alert("변경사항이 하나도 없습니다!");
            return;
        }
        
        var params = "";
        for (var i = 0; i < changedList.length; i++) {
            if (i > 0) params += ",";
            params += changedList[i].encodeURI();
        }
        params += fnCheckUrl('BASIC');
        params += fnCheckUrl('MAKER');
        params += fnCheckUrl('PRODUCT');

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("POST", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=setChangableDPDate&params=" + params,false);
		xmlHttp.send(null);
		if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            
            if (resultMsg != null && resultMsg.trim() == "") {
                alert("저장 완료!");
                window.close();
            }
            else alert(resultMsg.trim());
        } 
        else alert("ERROR");
    }

</script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPProjectSelect">

<table width="100%" cellSpacing="0" cellpadding="6" border="0">
	<tr>
		<td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
            B<br>A<br>S<br>I<br>C<br>
        </td>
        <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
            <input type="checkbox" name="BALL" style="width:9pt;" onclick="fnCheckAll(this,'BASIC')" />ALL<br>
            <input type="checkbox" name="BASIC" value="DWS" <%if(slDWGTypeKind.contains("기본도|DWS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Design Start<br>
            <input type="checkbox" name="BASIC" value="DWF" <%if(slDWGTypeKind.contains("기본도|DWF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Design Finish<br>
            <input type="checkbox" name="BASIC" value="OWS" <%if(slDWGTypeKind.contains("기본도|OWS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />OwnerApp.Submit<br>
            <input type="checkbox" name="BASIC" value="OWF" <%if(slDWGTypeKind.contains("기본도|OWF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />OwnerApp.Receive<br>
            <input type="checkbox" name="BASIC" value="CLS" <%if(slDWGTypeKind.contains("기본도|CLS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />ClassApp.Submit<br>
            <input type="checkbox" name="BASIC" value="CLF" <%if(slDWGTypeKind.contains("기본도|CLF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />ClassApp.Receive<br>
            <input type="checkbox" name="BASIC" value="RFS" <%if(slDWGTypeKind.contains("기본도|RFS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Issued for Working<br>
            <input type="checkbox" name="BASIC" value="WKS" <%if(slDWGTypeKind.contains("기본도|WKS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Issued for Const<br>
        </td>
        <td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
            M<br>A<br>K<br>E<br>R<br>
        </td>
        <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
            <input type="checkbox" name="MALL" style="width:9pt;" onclick="fnCheckAll(this,'MAKER')" />ALL<br>
            <input type="checkbox" name="MAKER" value="DWS" <%if(slDWGTypeKind.contains("MAKER|DWS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />P.R.<br>
            <input type="checkbox" name="MAKER" value="DWF" <%if(slDWGTypeKind.contains("MAKER|DWF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Vender Selection<br>
            <input type="checkbox" name="MAKER" value="OWS" <%if(slDWGTypeKind.contains("MAKER|OWS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />P.O.<br>
            <input type="checkbox" name="MAKER" value="OWF" <%if(slDWGTypeKind.contains("MAKER|OWF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />VenderDwg.Receive<br>
            <input type="checkbox" name="MAKER" value="CLS" <%if(slDWGTypeKind.contains("MAKER|CLS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />OwnerApp.Submit<br>
            <input type="checkbox" name="MAKER" value="CLF" <%if(slDWGTypeKind.contains("MAKER|CLF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />OwnerApp.Receive<br>
            <input type="checkbox" name="MAKER" value="RFS" <%if(slDWGTypeKind.contains("MAKER|RFS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Issued for Working<br>
            <input type="checkbox" name="MAKER" value="WKS" <%if(slDWGTypeKind.contains("MAKER|WKS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Issued for Const<br>
        </td>
        <td style="font-size:7pt;font-weight:bold;line-height:8px;background-color:#bbbbbb;padding-left:1px;width:8px;">
            P<br>R<br>O<br>D<br>U<br>C<br>T
        </td>
        <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
            <input type="checkbox" name="PALL" style="width:9pt;" onclick="fnCheckAll(this,'PRODUCT')" />ALL<br>
            <input type="checkbox" name="PRODUCT" value="DWS" <%if(slDWGTypeKind.contains("생설도|DWS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Design Start<br>
            <input type="checkbox" name="PRODUCT" value="DWF" <%if(slDWGTypeKind.contains("생설도|DWF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Design Finish<br>
            <input type="checkbox" name="PRODUCT" value="OWS" <%if(slDWGTypeKind.contains("생설도|OWS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />OwnerApp.Submit<br>
            <input type="checkbox" name="PRODUCT" value="OWF" <%if(slDWGTypeKind.contains("생설도|OWF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />OwnerApp.Receive<br>
            <input type="checkbox" name="PRODUCT" value="CLS" <%if(slDWGTypeKind.contains("생설도|CLS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />ClassApp.Submit<br>
            <input type="checkbox" name="PRODUCT" value="CLF" <%if(slDWGTypeKind.contains("생설도|CLF")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />ClassApp.Receive<br>
            <input type="checkbox" name="PRODUCT" value="RFS" <%if(slDWGTypeKind.contains("생설도|RFS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Issued for Working<br>
            <input type="checkbox" name="PRODUCT" value="WKS" <%if(slDWGTypeKind.contains("생설도|WKS")){%>checked<%}%> onclick="isCheckedChange=true;" style="width:9pt;" />Issued for Const<br>
        </td>
	</tr>
    <tr>
    <td style="vertical-align:top;" colspan="6">
        <div STYLE="height:280; overflow:auto; position:relative;">
        <table width="100%" cellSpacing="0" cellpadding="0" border="1" id="dataList" >
            <tr height="20">
                <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">호 선</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="130" ondblclick="fnAbleAll('기본도')"><font color="#ffffff" >기본도</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="130" ondblclick="fnAbleAll('MAKER')"><font color="#ffffff" >MAKER</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="130" ondblclick="fnAbleAll('생설도')"><font color="#ffffff" >생설도</font></td>
            </tr>
            
            <%
            for (int i = 0; allProjectList != null && i < allProjectList.size(); i++) 
            {
                Map map = (Map)allProjectList.get(i);
                String PROJECTNO = (String)map.get("PROJECTNO");
                String B_KIND = (String)map.get("B_KIND");
                String M_KIND = (String)map.get("M_KIND");
                String P_KIND = (String)map.get("P_KIND");
                
                String ableColor = "#fff0f5";
                String disableColor = "#ffffff";
                
                String colorB = disableColor;
                String colorM = disableColor;
                String colorP = disableColor;
                
                String textB = "OPENED";
                String textM = "OPENED";
                String textP = "OPENED";
                if(B_KIND != null && !B_KIND.equals(""))
                {
                	textB = "CLOSED";
                	colorB = ableColor;
                }
                if(M_KIND != null && !M_KIND.equals(""))
                {
                	textM = "CLOSED";
                	colorM = ableColor;
                }
                if(P_KIND != null && !P_KIND.equals(""))
                {
                	textP = "CLOSED";
                	colorP = ableColor;
                }
                %>
                <tr height="20" style="background-color:#ffffe0">
                    <td width="140" class="td_standard"><%=PROJECTNO%></td>
                    <td width="130" id="tdObj1_<%=i%>" class="td_standard" style="background-color:<%=colorB%>" 
                        ondblclick="toggleStateStr('<%=PROJECTNO%>', '기본도', this);"><%=textB%></td>
                    <td width="130" id="tdObj2_<%=i%>" class="td_standard" style="background-color:<%=colorM%>" 
                        ondblclick="toggleStateStr('<%=PROJECTNO%>', 'MAKER', this);"><%=textM%></td>
                    <td width="130" id="tdObj2_<%=i%>" class="td_standard" style="background-color:<%=colorP%>" 
                        ondblclick="toggleStateStr('<%=PROJECTNO%>', '생설도', this);"><%=textP%></td>
                </tr>
                <%
            }
            %>
        </table>
        </div>
    </td>
    </tr>

    <tr height="45">
        <td style="vertical-align:middle;text-align:right;" colspan="6">
            <hr>
            <input type="button" value="확인" class="button_simple" onclick="updateSearchableProjectList();">&nbsp;&nbsp;
            <input type="button" value="취소" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>

</table>


</form>
</body>
</html>
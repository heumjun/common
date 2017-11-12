<%--  
§DESCRIPTION: 설계시수입력 - 호선 Multi 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPInputNew_ProjectMultiSelect.jsp
§CHANGING HISTORY: 
§    2014-12-03: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String designerID = emxGetParameter(request, "designerID");
    String errStr = "";

    ArrayList allProjectList = null;
    ArrayList allModelList = null;
    ArrayList selectedProjectList = null;
    ArrayList invalidSelectedProjectList = null;
    try {
        allProjectList = getAllProjectList(designerID);
        allModelList = getAllModelList();
        selectedProjectList = getSelectedProjectList(designerID);
        invalidSelectedProjectList = getInvalidSelectedProjectList(designerID);

        // 정렬
        for (int i = 0; i < allProjectList.size(); i++) {
            Map map = (Map)allProjectList.get(i);
            String projectNo = (String)map.get("PROJECTNO");
            String dlEffective = (String)map.get("DL_EFFECTIVE");
            if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) {
                projectNo = "Z" + projectNo;
                map.put("PROJECTNO", projectNo);
            }

        }

        /*** 2015-01-21 Kang seonjung : Model 정보는 제외 (한경훈 과장 요청)
        for (int i = 0; i < allModelList.size(); i++) {
            Map map = (Map)allModelList.get(i);
            map.put("PROJECTNO", (String)map.get("MODEL_NO"));
            allProjectList.add(map);
        }
        ***/

        for (int i = 0; i < selectedProjectList.size(); i++) {
            Map map = (Map)selectedProjectList.get(i);
            String projectNo = (String)map.get("PROJECTNO");
            String dlEffective = (String)map.get("DL_EFFECTIVE");
            if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) {
                projectNo = "Z" + projectNo;
                map.put("PROJECTNO", projectNo);
            }
        }        
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>호 선 선 택</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPProjectSelect">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width=380" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>&nbsp;&nbsp;호선 선택</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="380" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">
            <td class="td_standardBold" style="background-color:#336699;" width="20%">&nbsp;</td>
            <td class="td_standardBold" style="background-color:#336699;" width="50%"><font color="#ffffff">Project</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="30%"><font color="#ffffff">대표호선</font></td>
        </tr>
    </table>

        <div STYLE="width:380; height:250; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="380" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">  
                                  
            <%
            //String sRowClass = "";
            for(int i=0; i<selectedProjectList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map selectedProjectListMap = (Map)selectedProjectList.get(i);
                String projectNo = (String)selectedProjectListMap.get("PROJECTNO");
                String dwgSeriesProjectNo = (String)selectedProjectListMap.get("DWGSERIESPROJECTNO"); // 대표호선                
                String projectNoStr = projectNo;
                String checked = "";
                //if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);
             %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="20%"><input type="checkbox" name="project" value="<%=projectNo%>" <%=checked%>></td>  
					<td class="td_standard" width="50%"><input type="hidden" name="projectNo<%=i%>" value="<%=projectNo%>"><%=projectNo%></td>    
					<td class="td_standard" width="30%"><input type="hidden" name="dwgSeriesProjectNo<%=i%>" value="<%=dwgSeriesProjectNo%>"><%=dwgSeriesProjectNo%></td>                 
                </tr>
            <%
            }
            %>
        </table>
        </div>
<br><br>
    <table width="380" cellspacing="1" cellpadding="1">
        <tr height="45">
            <td style="text-align:right;">
                <hr>
                <input type="button" value="확인" class="button_simple" onclick="javascript:selectProject();"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
	function selectProject()
	{
	    var mainForm = document.DPProjectSelect;
	    var projectListStr = "";
	    
	    var deliveryProjectStr = "";   //인도호선 리스트
	    
	    var dwgSeriesProjectNoStr = ""; //대표호선 체크용
	    var dwgSeriesProjectNoConfirmFlag = false;

	    for(var i = 0; i < mainForm.project.length; i++)
	    {
	    	if(mainForm.project[i].checked)
	    	{	
	    		var selectProject = mainForm.project[i].value;
	    		if(projectListStr=="")
	    		{
	    			projectListStr = selectProject;
	    		} else {
	    			projectListStr += ","+selectProject;	    		
	    		}
	    		
	    		// 인도호선일 경우 별도로 담아둠
	    		if(selectProject.substring(0, 1)=='Z')
	    		{
	    			if(deliveryProjectStr=="")	
	    			{
	    				deliveryProjectStr = selectProject;
	    			} else {
	    				deliveryProjectStr += ", "+selectProject;	    			
	    			}		
	    		}
	    		
				// 선택된 호선 중 다른 대표호선이 있을 경우 confirm 알림
	    		var dwgSeriesProjectNo = mainForm.elements['dwgSeriesProjectNo'+i].value;

	    		if(dwgSeriesProjectNoStr == "")
	    		{
	    			dwgSeriesProjectNoStr = dwgSeriesProjectNo;	    			
	    		} else {
	    			if(dwgSeriesProjectNo != dwgSeriesProjectNoStr)
	    			{
	    				dwgSeriesProjectNoConfirmFlag = true;	    				
	    			}
	    		}	

			}
		}
		
		if(dwgSeriesProjectNoConfirmFlag)
		{
			if(confirm("시리즈가 아닌 호선이 선택되었습니다.\n\n그대로 진행하시겠습니까?"))
			{
			} else {
				return;
			}	
		}
		
       	// 인도호선일 경우 알림 메시지 표시       	
       	if(deliveryProjectStr != "")
       	 {
       	 	var ConfirmMsg = "인도호선 ("+deliveryProjectStr+") 에 대한 시수입력 시\n반드시 업무내용란에 사유를 입력하여 주시길 바랍니다.\n\n";
       	 	ConfirmMsg += "인도시점 및 사유 관련 문의사항은\n기술기획팀 한경훈 과장 (T.3220) 으로 문의바랍니다.\n\n진행하시겠습니까?";
       	 	
       	 	if(confirm(ConfirmMsg))
       	 	{
			    window.returnValue=projectListStr;
			    window.close();		       	 	
       	 	}
       	 } else {   
		    window.returnValue=projectListStr;
		    window.close();		
		 }
	}
</script>


</html>
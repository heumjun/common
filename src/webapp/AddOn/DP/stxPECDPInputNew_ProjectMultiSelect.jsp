<%--  
��DESCRIPTION: ����ü��Է� - ȣ�� Multi ����
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECDPInputNew_ProjectMultiSelect.jsp
��CHANGING HISTORY: 
��    2014-12-03: Initiative
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

        // ����
        for (int i = 0; i < allProjectList.size(); i++) {
            Map map = (Map)allProjectList.get(i);
            String projectNo = (String)map.get("PROJECTNO");
            String dlEffective = (String)map.get("DL_EFFECTIVE");
            if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) {
                projectNo = "Z" + projectNo;
                map.put("PROJECTNO", projectNo);
            }

        }

        /*** 2015-01-21 Kang seonjung : Model ������ ���� (�Ѱ��� ���� ��û)
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
    <title>ȣ �� �� ��</title>
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
           <td><br><font color="darkblue"><b>&nbsp;&nbsp;ȣ�� ����</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="380" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">
            <td class="td_standardBold" style="background-color:#336699;" width="20%">&nbsp;</td>
            <td class="td_standardBold" style="background-color:#336699;" width="50%"><font color="#ffffff">Project</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="30%"><font color="#ffffff">��ǥȣ��</font></td>
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
                String dwgSeriesProjectNo = (String)selectedProjectListMap.get("DWGSERIESPROJECTNO"); // ��ǥȣ��                
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
                <input type="button" value="Ȯ��" class="button_simple" onclick="javascript:selectProject();"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="�ݱ�" class="button_simple" onclick="javascript:window.close();">&nbsp;
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
	    
	    var deliveryProjectStr = "";   //�ε�ȣ�� ����Ʈ
	    
	    var dwgSeriesProjectNoStr = ""; //��ǥȣ�� üũ��
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
	    		
	    		// �ε�ȣ���� ��� ������ ��Ƶ�
	    		if(selectProject.substring(0, 1)=='Z')
	    		{
	    			if(deliveryProjectStr=="")	
	    			{
	    				deliveryProjectStr = selectProject;
	    			} else {
	    				deliveryProjectStr += ", "+selectProject;	    			
	    			}		
	    		}
	    		
				// ���õ� ȣ�� �� �ٸ� ��ǥȣ���� ���� ��� confirm �˸�
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
			if(confirm("�ø�� �ƴ� ȣ���� ���õǾ����ϴ�.\n\n�״�� �����Ͻðڽ��ϱ�?"))
			{
			} else {
				return;
			}	
		}
		
       	// �ε�ȣ���� ��� �˸� �޽��� ǥ��       	
       	if(deliveryProjectStr != "")
       	 {
       	 	var ConfirmMsg = "�ε�ȣ�� ("+deliveryProjectStr+") �� ���� �ü��Է� ��\n�ݵ�� ����������� ������ �Է��Ͽ� �ֽñ� �ٶ��ϴ�.\n\n";
       	 	ConfirmMsg += "�ε����� �� ���� ���� ���ǻ�����\n�����ȹ�� �Ѱ��� ���� (T.3220) ���� ���ǹٶ��ϴ�.\n\n�����Ͻðڽ��ϱ�?";
       	 	
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
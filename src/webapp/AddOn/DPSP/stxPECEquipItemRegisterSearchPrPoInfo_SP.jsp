<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 PR, PO 세부 정보
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterSearchPrPoInfo_SP.jsp
§CHANGING HISTORY: 
§    2010-03-25: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

	private ArrayList getPrPoInfo(String projectNo, String prNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
        if (StringUtil.isNullString(prNo)) throw new Exception("Pr No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");
            StringBuffer pr_poInfoQuery = new StringBuffer();
            pr_poInfoQuery.append("SELECT PP.SEGMENT1 AS PR_PROJECT,                                                     \n");
            pr_poInfoQuery.append("       MSI.SEGMENT1 AS ITEM_CODE,                                                     \n");
            pr_poInfoQuery.append("       MSI.DESCRIPTION AS ITEM_DESC,                                                  \n");
            pr_poInfoQuery.append("       PRLA.QUANTITY AS QUANTITY,                                                     \n");
            pr_poInfoQuery.append("       PRHA.SEGMENT1 AS PR_NO,                                                        \n");
            pr_poInfoQuery.append("       PPF.LAST_NAME AS PR_REQUESTER,                                                 \n");
           // pr_poInfoQuery.append("       TO_CHAR(PRHA.CREATION_DATE, 'YYYY-MM-DD') AS PR_DATE,                          \n");
            pr_poInfoQuery.append("       TO_CHAR(CASE WHEN PRHA.AUTHORIZATION_STATUS = 'APPROVED'                       \n");
            pr_poInfoQuery.append("                     AND NVL(PRHA.CANCEL_FLAG, 'N') != 'Y'                            \n");
            pr_poInfoQuery.append("                    THEN NVL(PRHA.APPROVED_DATE,PRHA.LAST_UPDATE_DATE)                \n");
            pr_poInfoQuery.append("                    ELSE NULL                                                         \n");
            pr_poInfoQuery.append("                END, 'YYYY-MM-DD')  AS PR_DATE,  -- PR 승인일자                        \n");
            pr_poInfoQuery.append("       PV.VENDOR_NAME AS SELECTED_MAKER,                                              \n");
            pr_poInfoQuery.append("       PHA.SEGMENT1 AS PO_NO,                                                         \n");
            pr_poInfoQuery.append("       PPF1.LAST_NAME AS PO_REQUESTER,                                                \n");
            pr_poInfoQuery.append("       TO_CHAR(PHA.APPROVED_DATE, 'YYYY-MM-DD') AS PO_DATE,      --PLL.CREATION_DATE PO생성, PO 승인 차이         \n");
            pr_poInfoQuery.append("       SCIU1.DEPT_NAME         AS PO_DEPT_NAME                                        \n");
            pr_poInfoQuery.append("  FROM PO_HEADERS_ALL PHA,                                                            \n");
            pr_poInfoQuery.append("       PO_RELEASES_ALL PRA,                                                           \n");
            pr_poInfoQuery.append("       PO_LINES_ALL PLA,                                                              \n");
            pr_poInfoQuery.append("       PO_LINE_LOCATIONS_ALL PLL,                                                     \n");
            pr_poInfoQuery.append("       PO_DISTRIBUTIONS_ALL PDA,                                                      \n");
            pr_poInfoQuery.append("       PO_REQ_DISTRIBUTIONS_ALL PRDA,                                                 \n");
            pr_poInfoQuery.append("       PO_REQUISITION_LINES_ALL PRLA,                                                 \n");
            pr_poInfoQuery.append("       PO_REQUISITION_HEADERS_ALL PRHA,                                               \n");
            pr_poInfoQuery.append("       PO_VENDORS PV,                                                                 \n");
            pr_poInfoQuery.append("       MTL_SYSTEM_ITEMS_B MSI,                                                        \n");
            pr_poInfoQuery.append("       PA_PROJECTS_ALL PP,                                                            \n");
            pr_poInfoQuery.append("       PER_PEOPLE_F PPF,                                                              \n");
            pr_poInfoQuery.append("       FND_USER FU1,                                                                  \n");
            pr_poInfoQuery.append("       PER_PEOPLE_F PPF1,                                                             \n");
            pr_poInfoQuery.append("       STX_COM_INSA_USER          SCIU1,                                              \n");
            pr_poInfoQuery.append("       STX_COM_INSA_DEPT          SCID1                                               \n");
            pr_poInfoQuery.append(" WHERE 1 = 1                                                                          \n");
            pr_poInfoQuery.append("       AND PRHA.REQUISITION_HEADER_ID = PRLA.REQUISITION_HEADER_ID                    \n");
            pr_poInfoQuery.append("       AND PRLA.REQUISITION_LINE_ID = PRDA.REQUISITION_LINE_ID                        \n"); 
            pr_poInfoQuery.append("       AND PRDA.DISTRIBUTION_ID = PDA.REQ_DISTRIBUTION_ID(+)                          \n");
            pr_poInfoQuery.append("       AND PDA.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID(+)                             \n");
            pr_poInfoQuery.append("       AND PLL.PO_LINE_ID = PLA.PO_LINE_ID(+)                                         \n");
            pr_poInfoQuery.append("       AND PLA.PO_HEADER_ID = PHA.PO_HEADER_ID(+)                                     \n");
            pr_poInfoQuery.append("       AND PDA.PO_RELEASE_ID = PRA.PO_RELEASE_ID(+)                                   \n");
            pr_poInfoQuery.append("       AND PHA.VENDOR_ID = PV.VENDOR_ID(+)                                            \n");
            pr_poInfoQuery.append("       AND PRLA.ITEM_ID = MSI.INVENTORY_ITEM_ID                                       \n");
            pr_poInfoQuery.append("       AND MSI.ORGANIZATION_ID = 82                                                   \n");
            pr_poInfoQuery.append("       AND PRDA.PROJECT_ID = PP.PROJECT_ID                                            \n");
            pr_poInfoQuery.append("       AND PRHA.PREPARER_ID = PPF.PERSON_ID                                           \n");
            pr_poInfoQuery.append("       AND PLL.CREATED_BY = FU1.USER_ID(+)                                            \n");
            pr_poInfoQuery.append("       AND FU1.EMPLOYEE_ID = PPF1.PERSON_ID(+)                                        \n");
            pr_poInfoQuery.append("       AND PPF1.EMPLOYEE_NUMBER = SCIU1.EMP_NO(+)                                     \n");
            pr_poInfoQuery.append("       AND SCIU1.DEPT_CODE = SCID1.DEPT_CODE(+)                                       \n");
            pr_poInfoQuery.append("       AND PLL.CANCEL_FLAG IS NULL                                                    \n");
            pr_poInfoQuery.append("       AND PP.SEGMENT1 = '"+projectNo+"'                                              \n");
            pr_poInfoQuery.append("       AND PRHA.SEGMENT1 = '"+prNo+"'                                                 \n");

            //System.out.println("  pr_poInfoQuery  = "+pr_poInfoQuery.toString());
            stmt = conn.createStatement();
            rset = stmt.executeQuery(pr_poInfoQuery.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("PR_PROJECT", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("ITEM_CODE", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("ITEM_DESC", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("QUANTITY", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("PR_NO", rset.getString(5) == null ? "" : rset.getString(5));
                resultMap.put("PR_REQUESTER", rset.getString(6) == null ? "" : rset.getString(6));
                resultMap.put("PR_DATE", rset.getString(7) == null ? "" : rset.getString(7));
                resultMap.put("SELECTED_MAKER", rset.getString(8) == null ? "" : rset.getString(8));
                resultMap.put("PO_NO", rset.getString(9) == null ? "" : rset.getString(9));
                resultMap.put("PO_REQUESTER", rset.getString(10) == null ? "" : rset.getString(10));
                resultMap.put("PO_DATE", rset.getString(11) == null ? "" : rset.getString(11));
                resultMap.put("PO_DEPT_NAME", rset.getString(12) == null ? "" : rset.getString(12));
                resultArrayList.add(resultMap);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return resultArrayList;
    }


	private String getDrawingInfo(String projectNo, String prNo, String drawingNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
        if (StringUtil.isNullString(prNo)) throw new Exception("Pr No. is null");
        if (StringUtil.isNullString(drawingNo)) throw new Exception("drawingNo is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        String returnString = "";

        try {
			conn = DBConnect.getDBConnection("ERP_APPS");
            StringBuffer drawingInfoQuery = new StringBuffer();
            drawingInfoQuery.append("SELECT PROJECT_NUMBER,                              \n"); 
            drawingInfoQuery.append("       DRAWING_NO,                                  \n"); 
            drawingInfoQuery.append("       DRAWING_LIST                                 \n");
            drawingInfoQuery.append("  FROM STX_PO_EQUIPMENT_DP                          \n"); 
            drawingInfoQuery.append(" WHERE PROJECT_NUMBER = '"+projectNo+"'             \n");
            drawingInfoQuery.append("   AND DRAWING_NO     = '"+drawingNo+"'               \n");
            drawingInfoQuery.append("   AND PR_NO          = '"+prNo+"'                  \n");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(drawingInfoQuery.toString());

			while (rset.next())
            {
                returnString = "( "+rset.getString(1)+"  -  "+rset.getString(2)+"  :  "+rset.getString(3)+" )";
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return returnString;
    }


	private ArrayList getPrState(String prNo) throws Exception
	{
        if (StringUtil.isNullString(prNo)) throw new Exception("Pr No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

        try {
			conn = DBConnect.getDBConnection("ERP_APPS");
            StringBuffer prStateQuery = new StringBuffer();

            prStateQuery.append("SELECT PRHA.REQUISITION_HEADER_ID,            \n"); 
            prStateQuery.append("       PRHA.PREPARER_ID,                      \n"); 
            prStateQuery.append("       PRHA.SEGMENT1,                         \n"); 
            prStateQuery.append("       PRHA.AUTHORIZATION_STATUS,             \n");
            prStateQuery.append("       PPF.EMPLOYEE_NUMBER                    \n");
            prStateQuery.append("  FROM PO_REQUISITION_HEADERS_ALL PRHA,       \n"); 
            prStateQuery.append("       PER_PEOPLE_F PPF                       \n");
            prStateQuery.append(" WHERE PRHA.PREPARER_ID = PPF.PERSON_ID       \n");
            prStateQuery.append("   AND PRHA.SEGMENT1 = '"+prNo+"'             \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(prStateQuery.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("REQUISITION_HEADER_ID", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("PREPARER_ID", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("SEGMENT1", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("AUTHORIZATION_STATUS", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("EMPLOYEE_NUMBER", rset.getString(5) == null ? "" : rset.getString(5));
                resultArrayList.add(resultMap);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return resultArrayList;
    }
	
	// PR 결재자 확인 (인사상 지정된 상위 결재자)
	private String searchPRApprover(String personId) throws Exception
	{
        if (StringUtil.isNullString(personId)) throw new Exception("Pr No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String returnString = "";

        try {
			conn = DBConnect.getDBConnection("ERP_APPS");

            StringBuffer searchPRApproverQuery = new StringBuffer();
            searchPRApproverQuery.append("SELECT PPV.PERSON_ID,     -- 사원여부                                                              \n");
            searchPRApproverQuery.append("       PEC.SUPERVISOR_ID,  -- WORKFLOW 상위자설정여부                                  \n");
            searchPRApproverQuery.append("      (SELECT FULL_NAME                                            \n");
            searchPRApproverQuery.append("         FROM PER_PEOPLE_F                                         \n");
            searchPRApproverQuery.append("        WHERE PERSON_ID = PEC.SUPERVISOR_ID) AS APPROVER -- 결재자    \n");
            searchPRApproverQuery.append("  FROM FND_USER FU,                                                \n");
            searchPRApproverQuery.append("       PER_PEOPLE_V7 PPV,                                          \n");  
            searchPRApproverQuery.append("       PER_ASSIGNMENTS_V7 PAV,                                     \n"); 
            searchPRApproverQuery.append("       PER_EMPLOYEES_CURRENT_X PEC                                 \n");
            searchPRApproverQuery.append(" WHERE 1 = 1                                                       \n"); 
            searchPRApproverQuery.append("   AND FU.EMPLOYEE_ID = PPV.PERSON_ID(+)                           \n");
            searchPRApproverQuery.append("   AND PPV.PERSON_ID = PAV.PERSON_ID(+)                            \n"); 
            searchPRApproverQuery.append("   AND PAV.PERSON_ID = PEC.EMPLOYEE_ID(+)                          \n");
            searchPRApproverQuery.append("   AND NVL(FU.END_DATE,SYSDATE) >= TRUNC(SYSDATE)                  \n");
            searchPRApproverQuery.append("   AND PPV.EFFECTIVE_END_DATE > TRUNC(SYSDATE)                     \n");  
            searchPRApproverQuery.append("   AND NVL(FU.END_DATE,SYSDATE) >= TRUNC(SYSDATE)                  \n");  
            searchPRApproverQuery.append("   AND PPV.EMPLOYEE_NUMBER = '"+personId+"'                        \n");  
  

            stmt = conn.createStatement();
            rset = stmt.executeQuery(searchPRApproverQuery.toString());

			if (rset.next())
            {
				returnString = rset.getString(3) == null ? "" : rset.getString(3);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return returnString;
    }	

%>


<%--========================== JSP =========================================--%>
<%
    String projectNo = emxGetParameter(request, "projectNo");
    String prNo = emxGetParameter(request, "prNo");  
    String drawingNo = emxGetParameter(request, "drawingNo"); 

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String inputMakerListYN = StringUtil.setEmptyExt(emxGetParameter(request, "inputMakerListYN"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));

    //String personId = context.getUser();
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String personId = (String)loginUser.get("user_id");       

    String errStr = "";

    ArrayList prPoInfoList = null;
    ArrayList prStateList = null;
    String drawingInfoHeader = "";
    String prAPPROVER = "";  // 인사상 상위 결재자
    try {
        drawingInfoHeader = getDrawingInfo(projectNo, prNo, drawingNo);

        prStateList = getPrState(prNo);

        prPoInfoList = getPrPoInfo(projectNo, prNo); 
        
        prAPPROVER = searchPRApprover(personId);
        
        if("".equals(prAPPROVER))
        {
        	prAPPROVER = "미지정";
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

%>


<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE> 
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE> 


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    var isDone = false;
    function approvePR()
    {
    	var approvePRflag = frmSearchPurchasingCode.approvePRflag.value;
    	
        // PR 승인요청 중복 실행 방지
        if (approvePRflag=="TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        } 

        if(confirm("승인요청 하시겠습니까? 결과가 나올때까지 잠시만 기다려주십시오."))
        {
        	frmSearchPurchasingCode.approvePRflag.value = "TRUE";
        	frmSearchPurchasingCode.target = "HiddenFrame";
            frmSearchPurchasingCode.action = "stxPECEquipItemRegisterApprovePR_SP.jsp";
            frmSearchPurchasingCode.submit();    
        }
    }

    function deletePR()
    {

        // PR 승인요청 중복 실행 방지
        if (isDone)
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        } 

        if(confirm("취소된 PR 항목을 삭제하시겠습니까? 처리될때까지 잠시만 기다려주십시오."))
        {
            var isDone = true;
            frmSearchPurchasingCode.action = "stxPECEquipItemRegisterDeletePR_SP.jsp";
            frmSearchPurchasingCode.submit();    
        }
    }
</script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#f5f5f5">
<form name="frmSearchPurchasingCode" method="post">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="1070" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>PR - PO Specific Info.&nbsp;&nbsp;&nbsp;<%=drawingInfoHeader%></b></font> </td>
       </tr>
    </table>
    <br>

    <table width="1070" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">           
            <td class="td_standardBold" style="background-color:#336699;" width="5%"><font color="#ffffff">Project</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="10%"><font color="#ffffff">Item Code</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="21%"><font color="#ffffff">Item Description</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="6%"><font color="#ffffff">Quantity</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="6%"><font color="#ffffff">PR No.</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="6%"><font color="#ffffff">PR 요청자</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="8%"><font color="#ffffff">PR 승인일자</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="6%"><font color="#ffffff">PO No.</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="8%"><font color="#ffffff">PO 승인일자</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="9%"><font color="#ffffff">공급자</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="7%"><font color="#ffffff">구매담당자</font></td>            
            <td class="td_standardBold" style="background-color:#336699;" width="8%"><font color="#ffffff">구매담당부서</font></td>
        </tr>
    </table>

        <div STYLE="width:1070; height:270; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="1070" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">            
            <%
            //String sRowClass = "";
            for(int i=0; i<prPoInfoList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map prPoInfoMap = (Map)prPoInfoList.get(i);
                String pr_project = (String)prPoInfoMap.get("PR_PROJECT");
                String itemCode = (String)prPoInfoMap.get("ITEM_CODE");
                String itemDesc = (String)prPoInfoMap.get("ITEM_DESC");
                String quantity = (String)prPoInfoMap.get("QUANTITY");
                String pr_no = (String)prPoInfoMap.get("PR_NO");
                String pr_requester = (String)prPoInfoMap.get("PR_REQUESTER");
                String pr_date = (String)prPoInfoMap.get("PR_DATE");
                String selected_maker = (String)prPoInfoMap.get("SELECTED_MAKER");
                String po_no = (String)prPoInfoMap.get("PO_NO");
                String po_requester = (String)prPoInfoMap.get("PO_REQUESTER");
                String po_date = (String)prPoInfoMap.get("PO_DATE");
                String po_dept_name = (String)prPoInfoMap.get("PO_DEPT_NAME");
                
             %>
                <tr height="25" bgcolor="#f5f5f5">                    
                    <td class="td_standard" width="5%"><%=pr_project%></td>
                    <td class="td_standard" width="10%"><%=itemCode%></td>
                    <td class="td_standardLeft" width="21%">&nbsp;<%=itemDesc%></td>
                    <td class="td_standard" width="6%"><%=quantity%></td>
                    <td class="td_standard" width="6%"><%=pr_no%></td>
                    <td class="td_standard" width="6%"><%=pr_requester%></td>
                    <td class="td_standard" width="8%"><%=pr_date%></td>
                    <td class="td_standard" width="6%"><%=po_no%></td>
                    <td class="td_standard" width="8%"><%=po_date%></td>
                    <td class="td_standard" width="9%"><%=selected_maker%></td>
                    <td class="td_standard" width="7%"><%=po_requester%></td>
                    <td class="td_standard" width="8%"><%=po_dept_name%></td>
                </tr>
            <%
            }
            %>
        </table>
        </div>
<br><br>
<hr>   
    <table width="1070" cellspacing="1" cellpadding="1">
    <%
        Map prStateMap = (Map)prStateList.get(0);
        String pr_id = (String)prStateMap.get("REQUISITION_HEADER_ID");
        String pr_person_id = (String)prStateMap.get("PREPARER_ID");
        String pr_state = (String)prStateMap.get("AUTHORIZATION_STATUS");
        String pr_person_emp_no = (String)prStateMap.get("EMPLOYEE_NUMBER");

        boolean approve_pr_view = false;
        boolean cancel_pr_del = false;
        String pr_state_desc = "";
        if("INCOMPLETE".equals(pr_state))
        {
            pr_state_desc = pr_state + " ("+"미완료"+")";
            approve_pr_view = true;
            cancel_pr_del = true;
        } else if("PRE-APPROVED".equals(pr_state))
        {
            pr_state_desc = pr_state + " ("+"사전승인"+")";
        } else if("APPROVED".equals(pr_state))
        {
            pr_state_desc = pr_state + " ("+"승인됨"+")";
        } else if("CANCELLED".equals(pr_state))
        {
            pr_state_desc = pr_state + " ("+"취소"+")";
            cancel_pr_del = true;            
        } else if("REJECTED".equals(pr_state))
        {
            pr_state_desc = pr_state + " ("+"거절"+")";
            cancel_pr_del = true;
            approve_pr_view = true;
        } else {
            pr_state_desc = pr_state;
        }

        if(approve_pr_view && personId.equals(pr_person_emp_no))
        {
            approve_pr_view = true;
        } else {
            approve_pr_view = false;
        }  

        if(cancel_pr_del && personId.equals(pr_person_emp_no))
        {
            cancel_pr_del = true;
        } else {
            cancel_pr_del = false;
        }  

    %>
        <tr height="45">
            <td width="500" style="text-align:left;">
                <table cellspacing="1" cellpadding="0">
                    <tr height="25">
                        <td class="td_standardBold" style="background-color:#336699;" width="50"><font color="#ffffff">
                        PR
                        </td>
                        <td class="td_standardBold" style="background-color:#ffffff;" width="70"><font color="black">
                        <%=prNo%>
                        </td>
                        <td class="td_standardBold" style="background-color:#336699;" width="50"><font color="#ffffff">
                        상태
                        </td>
                        <td class="td_standardBold" style="background-color:#ffffff;" width="200"><font color="#000000">
                        <%=pr_state_desc%>
                        </td>
                        <td width="170" align="center">
                        <%
                        if(approve_pr_view)
                        {
                        %>
                            <input type="button" value="승인요청" class="button_simple" onclick="javascript:approvePR();">&nbsp;
                        <%
                        }
                        %>

                        <%
                        if(cancel_pr_del)
                        {
                        %>
                            <input type="button" value="PR 삭제" class="button_simple" onclick="javascript:deletePR();">&nbsp;
                        <%
                        }
                        %>
                        </td>
                    </tr>
                </table>
            </td>    
            <td style="text-align:right;">             
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
        <tr height="35">
            <td width="750" style="text-align:left;"><font color="darkblue">
            	&nbsp;&nbsp;&nbsp;* 인사 상 상위 결재자 : <b><%=prAPPROVER%></b> <BR>
            	&nbsp;&nbsp;&nbsp;* 상위 결재자 신규 설정이나 변경 시, 조선 인사팀(김정우 주임)으로 문의바랍니다.
            	</font>
            </td>
        </tr>         
    </table>
</td>
</tr>
</table>

<input type="hidden" name="projectNo" value="<%=projectNo%>">
<input type="hidden" name="prNo" value="<%=prNo%>">
<input type="hidden" name="drawingNo" value="<%=drawingNo%>">
<input type="hidden" name="loginID" value="<%=loginID%>">
<input type="hidden" name="deptCode" value="<%=deptCode%>">
<input type="hidden" name="inputMakerListYN" value="<%=inputMakerListYN%>">
<input type="hidden" name="approvePRflag" value="FALSE">
</form>
</body>


</html>
<iframe id="HiddenFrame" name="HiddenFrame" style="display:none"></iframe>
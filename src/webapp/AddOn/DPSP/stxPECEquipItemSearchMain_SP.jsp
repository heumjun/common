<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 조회 Main
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemSearchMain_SP.jsp
§CHANGING HISTORY: 
§    2010-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

    // DPS에서 호선, 부서별 도면 정보 가져옴.
	private ArrayList getDeptDrawingList(String projectNo, String deptCode, String prCreator, String poOwner, String reviewRequest, String reviewComplete, String deviationCheck) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		deptCode = StringUtil.setEmptyExt(deptCode);
        prCreator = StringUtil.setEmptyExt(prCreator);
        poOwner = StringUtil.setEmptyExt(poOwner);
        reviewRequest = StringUtil.setEmptyExt(reviewRequest);
        reviewComplete = StringUtil.setEmptyExt(reviewComplete);
        deviationCheck = StringUtil.setEmptyExt(deviationCheck);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPSP");
			StringBuffer queryStr = new StringBuffer();

            queryStr.append("SELECT PROJECTNO                                      \n");
            queryStr.append("      ,DWGDEPTNM                                      \n"); 
            queryStr.append("      ,DWGCODE                                        \n");
            queryStr.append("      ,DWGTITLE                                       \n");
            queryStr.append("      ,DR_DATE                                        \n"); 
            queryStr.append("      ,PR_PLAN_DATE                                   \n");
            queryStr.append("      ,PO_PLAN_DATE                                   \n");
            queryStr.append("      ,RECEIVE_ACT_DATE                               \n");
            queryStr.append("      ,CATALOGS                                       \n");
            queryStr.append("      ,PR_ID                                          \n");
            queryStr.append("      ,PR_NO                                          \n");
            queryStr.append("      ,DRAWING_LIST                                   \n"); 
            queryStr.append("      ,MAKER_LIST                                     \n");
            queryStr.append("      ,REQUEST_DATE                                   \n"); 
            queryStr.append("      ,COMPLETE_DATE                                  \n"); 
            queryStr.append("      ,PR_DATE                                        \n");
            queryStr.append("      ,AUTHORIZATION_STATUS                           \n");
            queryStr.append("      ,PND_DATE                                       \n"); 
            queryStr.append("      ,ITEM_CODE                                      \n"); 
            queryStr.append("      ,PR_REQUESTER                                   \n");
            queryStr.append("      ,SELECTED_MAKER                                 \n");
            queryStr.append("      ,PO_NO                                          \n");
            queryStr.append("      ,PO_REQUESTER                                   \n");
            queryStr.append("      ,PO_DEPT_NAME                                   \n");
            queryStr.append("      ,PO_DATE                                        \n");
            queryStr.append("      ,PR_REQUESTER_EMP_NO                            \n");
            queryStr.append("      ,PO_REQUESTER_EMP_NO                            \n");
            queryStr.append("  FROM PLM_PR_VENDOR_SEARCH_MAIN_V                    \n");
            queryStr.append(" WHERE 1=1                                            \n");
            queryStr.append("   AND PROJECTNO = '"+projectNo+"'                    \n");
            if(!"".equals(deptCode))
            {
                queryStr.append("   AND DEPTCODE  = '"+deptCode+"'                 \n");
            }
            if(!"".equals(prCreator))
            {
                queryStr.append("   AND PR_REQUESTER_EMP_NO  = '"+prCreator+"'     \n");
            }
            if(!"".equals(poOwner))
            {
                queryStr.append("   AND PO_REQUESTER_EMP_NO  = '"+poOwner+"'     \n");
            }
            if("Y".equals(reviewRequest))
            {
                queryStr.append("   AND REQUEST_DATE  IS NOT NULL                  \n");
            }
            if("N".equals(reviewRequest))
            {
                queryStr.append("   AND REQUEST_DATE  IS NULL                      \n");
            }
            if("Y".equals(reviewComplete))
            {
                queryStr.append("   AND COMPLETE_DATE  IS NOT NULL                 \n");
            }
            if("N".equals(reviewComplete))
            {
                queryStr.append("   AND COMPLETE_DATE  IS NULL                     \n");
            }
            if("true".equals(deviationCheck))
            {   
                queryStr.append("   AND PLANFINISHDATE < NVL(ACTUALFINISHDATE, SYSDATE)  \n");
            }
            queryStr.append(" GROUP BY  PROJECTNO                                  \n");  
            queryStr.append("          ,DWGDEPTNM                                  \n");
            queryStr.append("          ,DWGCODE                                    \n"); 
            queryStr.append("          ,DWGTITLE                                   \n"); 
            queryStr.append("          ,DR_DATE              --도면 접수 계획일    \n");
            queryStr.append("          ,PR_PLAN_DATE         --PR발행 계획일       \n"); 
            queryStr.append("          ,PO_PLAN_DATE         --PO발행 계획일       \n");
            queryStr.append("          ,RECEIVE_ACT_DATE     --승인도 접수일자     \n");
            queryStr.append("          ,CATALOGS                                   \n");
            queryStr.append("          ,PR_ID                                      \n");
            queryStr.append("          ,PR_NO                                      \n");
            queryStr.append("          ,DRAWING_LIST                               \n");
            queryStr.append("          ,MAKER_LIST                                 \n");
            queryStr.append("          ,REQUEST_DATE         --설계검토요청일자    \n");
            queryStr.append("          ,COMPLETE_DATE        --설계검토완료일자    \n");
            queryStr.append("          ,PR_DATE              --PR승인일자          \n"); 
            queryStr.append("          ,AUTHORIZATION_STATUS --PR상태              \n");
            queryStr.append("          ,PND_DATE                                   \n");
            queryStr.append("          ,ITEM_CODE                                  \n");
            queryStr.append("          ,PR_REQUESTER                               \n");
            queryStr.append("          ,SELECTED_MAKER                             \n");
            queryStr.append("          ,PO_NO                                      \n");
            queryStr.append("          ,PO_REQUESTER                               \n");  
            queryStr.append("          ,PO_DEPT_NAME                               \n");
            queryStr.append("          ,PO_DATE                                    \n");
            queryStr.append("          ,PR_REQUESTER_EMP_NO                        \n");
            queryStr.append("          ,PO_REQUESTER_EMP_NO                        \n");
            queryStr.append(" ORDER BY DWGCODE                                     \n"); 
            
            //System.out.println("  queryStr  = "+queryStr.toString());
            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());            

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("DWGDEPTNM", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("DWGCODE", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("DWGTITLE", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("DR_DATE", rset.getString(5) == null ? "" : rset.getString(5));
                resultMap.put("PR_PLAN_DATE", rset.getString(6) == null ? "" : rset.getString(6));
                resultMap.put("PO_PLAN_DATE", rset.getString(7) == null ? "" : rset.getString(7));
                resultMap.put("RECEIVE_ACT_DATE", rset.getString(8) == null ? "" : rset.getString(8));
                resultMap.put("CATALOGS", rset.getString(9) == null ? "" : rset.getString(9));
                resultMap.put("PR_ID", rset.getString(10) == null ? "" : rset.getString(10));
                resultMap.put("PR_NO", rset.getString(11) == null ? "" : rset.getString(11));
                resultMap.put("DRAWING_LIST", rset.getString(12) == null ? "" : rset.getString(12));
                resultMap.put("MAKER_LIST", rset.getString(13) == null ? "" : rset.getString(13));
                resultMap.put("REQUEST_DATE", rset.getString(14) == null ? "" : rset.getString(14));
                resultMap.put("COMPLETE_DATE", rset.getString(15) == null ? "" : rset.getString(15));
                resultMap.put("PR_DATE", rset.getString(16) == null ? "" : rset.getString(16));
                resultMap.put("AUTHORIZATION_STATUS", rset.getString(17) == null ? "" : rset.getString(17));
                resultMap.put("PND_DATE", rset.getString(18) == null ? "" : rset.getString(18));
                resultMap.put("ITEM_CODE", rset.getString(19) == null ? "" : rset.getString(19));
                resultMap.put("PR_REQUESTER", rset.getString(20) == null ? "" : rset.getString(20));
                resultMap.put("SELECTED_MAKER", rset.getString(21) == null ? "" : rset.getString(21));
                resultMap.put("PO_NO", rset.getString(22) == null ? "" : rset.getString(22));
                resultMap.put("PO_REQUESTER", rset.getString(23) == null ? "" : rset.getString(23));
                resultMap.put("PO_DEPT_NAME", rset.getString(24) == null ? "" : rset.getString(24));
                resultMap.put("PO_DATE", rset.getString(25) == null ? "" : rset.getString(25));
                resultMap.put("PR_REQUESTER_EMP_NO", rset.getString(26) == null ? "" : rset.getString(26));
                resultMap.put("PO_REQUESTER_EMP_NO", rset.getString(27) == null ? "" : rset.getString(27));
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
        //System.out.println("~~~ resultArrayList = "+resultArrayList.toString());
        return resultArrayList;
        
    }
%>
<%
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String prCreator = StringUtil.setEmptyExt(emxGetParameter(request, "prCreator"));
    String reviewRequest = StringUtil.setEmptyExt(emxGetParameter(request, "reviewRequest"));
    String selectedMaker = StringUtil.setEmptyExt(emxGetParameter(request, "selectedMaker"));
    String poOwner = StringUtil.setEmptyExt(emxGetParameter(request, "poOwner"));
    String reviewComplete = StringUtil.setEmptyExt(emxGetParameter(request, "reviewComplete"));    
    String deviationCheck = StringUtil.setEmptyExt(emxGetParameter(request, "deviationCheck")); //true or false

    ArrayList deptDrawingList = null;
    Map keyEventMap = null;
    if (!projectNo.equals(""))
    {
        deptDrawingList = getDeptDrawingList(projectNo,deptCode,prCreator,poOwner,reviewRequest,reviewComplete,deviationCheck);   
        keyEventMap = getKeyEventDates(projectNo);
    }

    HashMap tempMap = new java.util.HashMap();
    String tempLastDwgCode = "";

    for(int h=0; h < deptDrawingList.size(); h++)
    {
        Map tMap = (Map)deptDrawingList.get(h);
        String tempDwgCode = (String)tMap.get("DWGCODE");
        if(!tempLastDwgCode.equals(tempDwgCode))
        {
            tempLastDwgCode = tempDwgCode;
            tempMap.put(tempDwgCode, "1");
        } else {
            int tempDwgCnt = Integer.parseInt((String)tempMap.get(tempLastDwgCode));
            tempDwgCnt++;
            tempMap.put(tempLastDwgCode,Integer.toString(tempDwgCnt));
        }
    }
//    System.out.println("~~ tempMap = "+tempMap.toString());


%>

<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE>   
    .hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
    } 
    
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE>  


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript">
<% if(keyEventMap != null)
{ 
    %>
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventCT.value = '<%=(String)keyEventMap.get("CT")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventSC.value = '<%=(String)keyEventMap.get("SC")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventKL.value = '<%=(String)keyEventMap.get("KL")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventLC.value = '<%=(String)keyEventMap.get("LC")%>';
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.keyeventDL.value = '<%=(String)keyEventMap.get("DL")%>';
    <%
} 
%>

// 첨부SPEC 파일 VIEW
function fileView(prId)
{
    var attURL = "stxPECEquipItemFileView_SP.jsp?";
    attURL += "prId="+prId;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

    //window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}

// 설계검토 요청 파일 VIEW
function fileView_1(project, drawingNo)
{
    var attURL = "stxPECEquipItemFileView_1_SP.jsp?";
    attURL += "project="+project;
    attURL += "&drawingNo="+drawingNo;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

   // window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}

// 설계검토 완료 파일 VIEW
function fileView_2(project, drawingNo)
{
    var attURL = "stxPECEquipItemFileView_2_SP.jsp?";
    attURL += "project="+project;
    attURL += "&drawingNo="+drawingNo;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

   // window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}
</script>

<%--========================== HTML BODY ===================================--%>
<% // oncontextmenu : 마우스 우클립 팝업메뉴,  ondragstart : 마우스 드래그 %>
<body style="background-color:#ffffff">
<form name="frmEquipItemPurchasingManagementSearchMain" method="post">

<table border="0" cellpadding="0" cellspacing="0" width="1550" style="table-layout:fixed;" bgcolor="#ffffff">

    <tr>
        <td>
        
            <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc">
                <tr align="center" height="28" bgcolor="#e5e5e5">
                    <td width="20" class="td_standardSmall">No.
                    </td>
                    <td width="50" class="td_standardSmall">Project
                    </td>
                    <td width="50" class="td_standardSmall">부서
                    </td>
                    <td width="70" class="td_standardSmall">도면 No.
                    </td>
                    <td width="100" class="td_standardSmall">도면 Title
                    </td>
                    <td width="80" class="td_standardSmall">Item Code
                    </td>
                    <td width="80" class="td_standardSmall">Maker List
                    </td>
                    <td width="70" class="td_standardSmall">도면 접수<BR>계획일자
                    </td>              
                    <td width="70" class="td_standardSmall">PR No.
                    </td>
                    <td width="50" class="td_standardSmall">PR<BR>요청자
                    </td>
                    <td width="70" class="td_standardSmall">PR 발행<BR>계획일자
                    </td>
                    <td width="70" class="td_standardSmall">PR<BR>승인일자
                    </td>
                    <td width="70" class="td_standardSmall">첨부 Spec.
                    </td>
                    <td width="70" class="td_standardSmall">설계<BR>검토요청
                    </td>
                    <td width="70" class="td_standardSmall">설계<BR>검토완료
                    </td>
                    <td width="70" class="td_standardSmall">PO No.
                    </td>
                    <td width="70" class="td_standardSmall">PO 발행<BR>계획일자
                    </td>
                    <td width="70" class="td_standardSmall">PO<BR>승인일자
                    </td>
                    <td width="70" class="td_standardSmall">선정 Maker
                    </td>
                    <td width="70" class="td_standardSmall">구매 담당자
                    </td>
                    <td width="70" class="td_standardSmall">구매<BR>담당부서
                    </td>
                    <td width="70" class="td_standardSmall">승인도<BR>접수일자
                    </td>
                    <td width="70" class="td_standardSmall">승인도<BR>승인일자
                    </td>
                </tr>

            <%
            String sRowClass = "";
            String lastDwgCode = "";
            int cntNo = 0;
            for(int i=0; i<deptDrawingList.size(); i++)
            {
                //sRowClass = ( (cntNo % 10 ) > 4  ? "tr_blue" : "tr_white");
               // sRowClass = "tr_white";

                Map deptDrawingMap = (Map)deptDrawingList.get(i);
                String projectNoData = (String)deptDrawingMap.get("PROJECTNO");
                String deptName = (String)deptDrawingMap.get("DWGDEPTNM");                
                String dwgCode = (String)deptDrawingMap.get("DWGCODE");
                String dwgTitle = (String)deptDrawingMap.get("DWGTITLE");
                String drDate = (String)deptDrawingMap.get("DR_DATE"); 
                String prId = (String)deptDrawingMap.get("PR_ID");
                String prNo = (String)deptDrawingMap.get("PR_NO");
                String drawingList = (String)deptDrawingMap.get("DRAWING_LIST");
                String makerList = (String)deptDrawingMap.get("MAKER_LIST");
                String pndDate = (String)deptDrawingMap.get("PND_DATE"); 
                String itemCode = (String)deptDrawingMap.get("ITEM_CODE");
                String prPlanDate = (String)deptDrawingMap.get("PR_PLAN_DATE");
                String poPlanDate = (String)deptDrawingMap.get("PO_PLAN_DATE");
                String receive_act_date = (String)deptDrawingMap.get("RECEIVE_ACT_DATE");
                String request_date = (String)deptDrawingMap.get("REQUEST_DATE");
                String complete_date = (String)deptDrawingMap.get("COMPLETE_DATE");
                String pr_requester = (String)deptDrawingMap.get("PR_REQUESTER");
                String pr_requester_emp_no = (String)deptDrawingMap.get("PR_REQUESTER_EMP_NO");
                String pr_date = (String)deptDrawingMap.get("PR_DATE");
                String pr_authorization_status = (String)deptDrawingMap.get("AUTHORIZATION_STATUS");
                String po_no = (String)deptDrawingMap.get("PO_NO");
                String po_date = (String)deptDrawingMap.get("PO_DATE");
                String po_requester = (String)deptDrawingMap.get("PO_REQUESTER");    
                String po_requester_emp_no = (String)deptDrawingMap.get("PO_REQUESTER_EMP_NO");
                String po_dept_name = (String)deptDrawingMap.get("PO_DEPT_NAME");
                String selected_maker = (String)deptDrawingMap.get("SELECTED_MAKER");

                String pr_authorization_status_desc = "";
                if("INCOMPLETE".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"미완료"+")";
                } else if("PRE-APPROVED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"사전승인"+")";
                } else if("APPROVED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"승인됨"+")";
                } else if("CANCELLED".equals(pr_authorization_status))
                {
                    pr_authorization_status_desc = "("+"취소"+")";
                } else {
                    pr_authorization_status_desc = "";
                }

                if(!lastDwgCode.equals(dwgCode))
                {
                    cntNo++;
                }
                sRowClass = ( ((cntNo-1) % 10 ) > 4  ? "tr_blue" : "tr_white");

            %>
                
                <tr class="<%=sRowClass%>" align="center" height="40">
            <%
                if(!lastDwgCode.equals(dwgCode))
                {
                    lastDwgCode = dwgCode;
                    int dwgCodeCnt = Integer.parseInt((String)tempMap.get(dwgCode));   
                    
            %>
                    <td width="20" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=cntNo%></td>
                    <td width="50" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=projectNoData%></td>
                    <td width="50" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=deptName%></td>
                    <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=dwgCode%></td>
                    <td width="100" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=dwgTitle%></td>
                    <td width="80" class="td_standardSmall"><%=itemCode%></td>
                    <td width="80" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=makerList%></td>
                    <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=drDate%></td>                      
                    <td width="70" class="td_standardSmall"><%=prNo%><br><%=pr_authorization_status_desc%></td>
                    <td width="50" class="td_standardSmall"><%=pr_requester%></td>
                    <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=prPlanDate%></td>
                    <td width="70" class="td_standardSmall"><%=pr_date%></td>

                    <%
                    if(!"".equals(prId))
                    {
                    %> 
                        <td width="70" class="td_standardSmall">
                            <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView('<%=prId%>');">     
                        </td>
                    <%
                    } else {
                    %>
                        <td width="70" class="td_standardSmall"></td>
                    <%
                    }
                    %> 
                    
                    <%
                    if("".equals(request_date))
                    {
                    %>                    
                        <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"></td>
                    <%
                    } else {
                    %>
                        <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=request_date%>
                            <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView_1('<%=projectNoData%>','<%=dwgCode%>');">           
                        </td>
                    <%
                    }
                    %> 
                    <%

                    if("".equals(complete_date))
                    { 
                    %>                    
                        <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"></td>
                    <%
                    } else {
                            // 설계검토완료가 있을 땐 VIEW
                    %>
                            <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=complete_date%>
                                <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView_2('<%=projectNoData%>','<%=dwgCode%>');">           
                            </td>                        
                    <%
                    }
                    %>                  

                    <td width="70" class="td_standardSmall"><%=po_no%></td>
                    <td width="70" class="td_standardSmall"><%=poPlanDate%></td>
                    <td width="70" class="td_standardSmall"><%=po_date%></td>
                    <td width="70" class="td_standardSmall"><%=selected_maker%></td>
                    <td width="70" class="td_standardSmall"><%=po_requester%></td>
                    <td width="70" class="td_standardSmall"><%=po_dept_name%></td>
                    <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"><%=receive_act_date%></td>
                    <td width="70" class="td_standardSmall" rowspan="<%=dwgCodeCnt%>"></td>
               <%                 
                } else {
               %>
                    <td width="80" class="td_standardSmall" class="<%=sRowClass%>"><%=itemCode%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=prNo%><br><%=pr_authorization_status_desc%></td>
                    <td width="50" class="td_standardSmall" class="<%=sRowClass%>"><%=pr_requester%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=pr_date%></td>
                    <%
                    if(!"".equals(prId))
                    {
                    %> 
                        <td width="70" class="td_standardSmall">
                            <img src="images/pdf_icon.gif" border="0" style="cursor:hand;" onclick="fileView('<%=prId%>');">     
                        </td>
                    <%
                    } else {
                    %>
                        <td width="70" class="td_standardSmall"></td>
                    <%
                    }
                    %> 
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=po_no%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=poPlanDate%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=po_date%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=selected_maker%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=po_requester%></td>
                    <td width="70" class="td_standardSmall" class="<%=sRowClass%>"><%=po_dept_name%></td>
                <%
                    }
                %>

                </tr>
            <%
            }
            if(deptDrawingList.size() < 1)
            {
            %>
                <tr align="center" height="40" bgcolor="#ffffff">
                    <td colspan="23" class="td_standardSmall" >
                        no data.
                    </td>
                </tr>
            <%
            }
            %>

            </table>
         

         </td>
    </tr>

</table>
<input type="hidden" name="projectNo" value="<%=projectNo%>">
<input type="hidden" name="deptCode" value="<%=deptCode%>">
</form>

</body>
</html>
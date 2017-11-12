<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 조회 엑셀 다운로드
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemSearchExcelDownload_SP.jsp
--%>

<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %> 
<%  // 웹페이지의 내용을 엑셀로 변환하기 위한 구문
	//response.setContentType("application/msexcel");
	response.setHeader("Content-Disposition", "attachment; filename=ExcelDownload.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 

%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<% request.setCharacterEncoding("euc-kr"); %>


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
                queryStr.append("   AND PLANFINISHDATE < NVL(ACTUALFINISHDATE, SYSDATE)     \n");
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
        //System.out.println("~~~ resultArrayList = "+resultArrayList);
        return resultArrayList;
        
    }
%>
<%
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectList"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "departmentList"));
    String prCreator = StringUtil.setEmptyExt(emxGetParameter(request, "prCreator"));
    String reviewRequest = StringUtil.setEmptyExt(emxGetParameter(request, "reviewRequest"));
    String selectedMaker = StringUtil.setEmptyExt(emxGetParameter(request, "selectedMaker"));
    String poOwner = StringUtil.setEmptyExt(emxGetParameter(request, "poOwner"));
    String reviewComplete = StringUtil.setEmptyExt(emxGetParameter(request, "reviewComplete"));    
    String deviationCheck = StringUtil.setEmptyExt(emxGetParameter(request, "deviationCheck")); //true or false

    ArrayList deptDrawingList = getDeptDrawingList(projectNo,deptCode,prCreator,poOwner,reviewRequest,reviewComplete,deviationCheck);
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr"/>
</head>
<body>
<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<% // oncontextmenu : 마우스 우클립 팝업메뉴,  ondragstart : 마우스 드래그 %>
<form name="frmEquipItemPurchasingManagementSearchMain" method="post">
       
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                <tr align="center" height="28">
                    <td width="20">No.
                    </td>
                    <td width="50">Project
                    </td>
                    <td width="50">부서
                    </td>
                    <td width="70">도면 No.
                    </td>
                    <td width="100">도면 Title
                    </td>
                    <td width="80">Item Code
                    </td>
                    <td width="80">Maker List
                    </td>
                    <td width="70">도면 접수 계획일자
                    </td>              
                    <td width="70">PR No.
                    </td>
                    <td width="50">PR 요청자
                    </td>
                    <td width="70">PR 발행 계획일자
                    </td>
                    <td width="70">PR 승인일자
                    </td>
                    <td width="70">PR 상태
                    </td>
                    <td width="70">첨부 Spec.
                    </td>
                    <td width="70">설계검토요청
                    </td>
                    <td width="70">설계검토완료
                    </td>
                    <td width="70">PO No.
                    </td>
                    <td width="70">PO 발행 계획일자
                    </td>
                    <td width="70">PO 승인일자
                    </td>
                    <td width="70">선정 Maker
                    </td>
                    <td width="70">구매 담당자
                    </td>
                    <td width="70">구매 담당부서
                    </td>
                    <td width="70">승인도 제출일자
                    </td>
                    <td width="70">승인도 승인일자
                    </td>
                </tr>
            </table>
   
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
            <%

            for(int i=0; i<deptDrawingList.size(); i++)
            {
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

                String attachSpecYN = "N";
                if(!"".equals(prId)) attachSpecYN = "Y";
            %>                
                <tr align="center" height="40">
                    <td width="20" ><%=i+1%></td>
                    <td width="50"><%=projectNoData%></td>
                    <td width="50"><%=deptName%></td>
                    <td width="70" ><%=dwgCode%></td>
                    <td width="100"><%=dwgTitle%></td>
                    <td width="80"><%=itemCode%></td>
                    <td width="80"><%=makerList%></td>
                    <td width="70" ><%=drDate%></td>                      
                    <td width="70"><%=prNo%></td>
                    <td width="50" ><%=pr_requester%></td>
                    <td width="70" ><%=prPlanDate%></td>
                    <td width="70" ><%=pr_date%></td>
                    <td width="70" ><%=pr_authorization_status_desc%></td>
                    <td width="70" ><%=attachSpecYN%></td>
                    <td width="70"><%=request_date%></td>      
                    <td width="70"><%=complete_date%></td>                        
                    <td width="70"><%=po_no%></td>
                    <td width="70"><%=poPlanDate%></td>
                    <td width="70"><%=po_date%></td>
                    <td width="70" ><%=selected_maker%></td>
                    <td width="70" ><%=po_requester%></td>
                    <td width="70"><%=po_dept_name%></td>
                    <td width="70"><%=receive_act_date%></td>
                    <td width="70"></td>
                </tr>
            <%
            }
            %>
            </table>


</form>

</body>
</html>
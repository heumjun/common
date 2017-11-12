<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 PR 승인요청
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterApprovePR_SP.jsp
§CHANGING HISTORY: 
§    2011-01-13: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ page import="java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// insertLogApprovePR() : PR 승인요청 대상 저장 (승인 요청 로그 저장).....
	private void insertLogApprovePR(String projectNo, String drawingNo, String prNo, String loginID) throws Exception
	{	
		java.sql.Connection conn = DBConnect.getDBConnection("PLM");
	
	    java.sql.PreparedStatement pstmt = null;
	
		try
		{
			StringBuffer insertQuery = new StringBuffer();
			insertQuery.append("INSERT INTO STX_PO_EQUIPMENT_DP_APPROVEPR(         \n");
			insertQuery.append("	PROJECT_NO,                                    \n");
			insertQuery.append("	DRAWING_NO,                                    \n");
			insertQuery.append("	PR_NO,                                         \n");
			insertQuery.append("	PERSON_ID,                                     \n");
			insertQuery.append("	CREATE_DATE)                                   \n");
			insertQuery.append("VALUES ( ?, ?, ?, ?, SYSDATE )                     \n");
	
			pstmt = conn.prepareStatement(insertQuery.toString());
	
			pstmt.setString(1, projectNo);
			pstmt.setString(2, drawingNo);
			pstmt.setString(3, prNo);
			pstmt.setString(4, loginID);
			pstmt.executeUpdate();
	
			conn.commit();
		}
		catch (Exception e)
		{
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			throw e;
		}
		finally
		{
	        if (pstmt != null) pstmt.close();           
			DBConnect.closeConnection(conn);
		}
	}

	// approvePR() : PR 승인요청
	private void approvePR(String prNo) throws Exception
	{
        if (StringUtil.isNullString(prNo)) throw new Exception("Pr No. is null");
	
		java.sql.Connection conn = DBConnect.getDBConnection("ERP_APPS");
		java.sql.CallableStatement callPRApproveCStmt = null;

        java.sql.Statement stmt = null;
        java.sql.ResultSet rset = null;
        java.sql.Statement stmt1 = null;
        java.sql.ResultSet rset1 = null;

		try
		{
			String personId = "";
			String userId = "";
            String prId = "";
            String prState = "";

            StringBuffer prInfoQuery = new StringBuffer();
            prInfoQuery.append("SELECT PRHA.REQUISITION_HEADER_ID,      -- PR ID           \n");
            prInfoQuery.append("       PRHA.PREPARER_ID,                -- PERSON ID       \n");
            prInfoQuery.append("       PRHA.AUTHORIZATION_STATUS,       -- PR STATE        \n");
            prInfoQuery.append("       FU.USER_ID                       -- USER ID         \n");
            prInfoQuery.append("  FROM PO_REQUISITION_HEADERS_ALL PRHA,                    \n");
            prInfoQuery.append("       PER_PEOPLE_F PPF,                                   \n");
            prInfoQuery.append("       FND_USER FU                                         \n");
            prInfoQuery.append(" WHERE PRHA.PREPARER_ID = PPF.PERSON_ID                    \n");
            prInfoQuery.append("   AND FU.EMPLOYEE_ID = PPF.PERSON_ID                      \n");
			prInfoQuery.append("   AND PPF.EFFECTIVE_END_DATE > TRUNC(SYSDATE)             \n");
			prInfoQuery.append("   AND NVL(FU.END_DATE,SYSDATE) >= TRUNC(SYSDATE)          \n");
            prInfoQuery.append("   AND PRHA.SEGMENT1 = '" + prNo +"'                       \n");

			
            stmt = conn.createStatement();
            rset = stmt.executeQuery(prInfoQuery.toString());
			if (rset.next()) {
				prId     = rset.getString(1) == null ? "" : rset.getString(1);
				personId = rset.getString(2) == null ? "" : rset.getString(2);
                prState  = rset.getString(3) == null ? "" : rset.getString(3);
                userId   = rset.getString(4) == null ? "" : rset.getString(4);
			}
			if (personId.equals("")) {
                throw new Exception("PERSON is not exist in ERP!");
            }
			if (!("INCOMPLETE".equals(prState)|| "REJECTED".equals(prState))) {
                throw new Exception("PR state is not INCOMPLETE or REJECTED!");
            }

			String jobId = "";
			String supervisorId = "";  

            StringBuffer prApproveCheckQuery = new StringBuffer();
            prApproveCheckQuery.append("SELECT PPV.PERSON_ID,     --> 1.사원여부                      \n");
            prApproveCheckQuery.append("       PAV.JOB_ID,         --> 2.JOB여부(팀원,팀장,본부장...) \n");
            prApproveCheckQuery.append("       PEC.SUPERVISOR_ID  --> 3.WORKFLOW 상위자설정여부       \n");
            prApproveCheckQuery.append("  FROM FND_USER FU,                                           \n");
            prApproveCheckQuery.append("       PER_PEOPLE_V7 PPV,                                     \n");  
            prApproveCheckQuery.append("       PER_ASSIGNMENTS_V7 PAV,                                \n"); 
            prApproveCheckQuery.append("       PER_EMPLOYEES_CURRENT_X PEC                            \n");
            prApproveCheckQuery.append(" WHERE 1 = 1                                                  \n"); 
            prApproveCheckQuery.append("   AND FU.EMPLOYEE_ID = PPV.PERSON_ID(+)                      \n");
            prApproveCheckQuery.append("   AND PPV.PERSON_ID = PAV.PERSON_ID(+)                       \n"); 
            prApproveCheckQuery.append("   AND PAV.PERSON_ID = PEC.EMPLOYEE_ID(+)                     \n");
			prApproveCheckQuery.append("   AND NVL(FU.END_DATE,SYSDATE) >= TRUNC(SYSDATE)             \n");
            prApproveCheckQuery.append("   AND FU.USER_ID = '"+userId+"'                              \n");  

            stmt1 = conn.createStatement();
            rset1 = stmt1.executeQuery(prApproveCheckQuery.toString());
            
			if (rset1.next()) {
				jobId         = rset1.getString(2) == null ? "" : rset1.getString(2);
                supervisorId  = rset1.getString(3) == null ? "" : rset1.getString(3);
			}

			if (jobId.equals("")) {
                throw new Exception("JOB_ID is not exist in ERP!");   // 인사팀으로 연락해서 JOB 정보, 상위자 설정 정보를 입력해달라고 한다.
            }
			if (supervisorId.equals("")) {
                throw new Exception("SUPERVISOR_ID is not exist in ERP!"); // 인사팀으로 연락해서 JOB 정보, 상위자 설정 정보를 입력해달라고 한다.
            }

			/* CALL PR-APPROVE (SQL) */

			StringBuffer sPRApproveSql = new StringBuffer();
			sPRApproveSql.append("{CALL STX_STD_PLM_PR_APPROVE_PROC                   				            ");
			sPRApproveSql.append("      (?, ?, p_req_header_id=>?, p_pr_no=>?, p_user_id=>" + userId + ",       ");
            sPRApproveSql.append("       p_person_id=>" + personId + ", p_if_src_code=>'TPR')}                  ");
			callPRApproveCStmt = conn.prepareCall(sPRApproveSql.toString());

			/* PR 승인요청 */

            // CALL PR-IMPORT
            callPRApproveCStmt.registerOutParameter(1, 12);
            callPRApproveCStmt.registerOutParameter(2, 12);
            callPRApproveCStmt.setString(3, prId);
            callPRApproveCStmt.setString(4, prNo);
            callPRApproveCStmt.execute();

            String retMsg = callPRApproveCStmt.getObject(1).toString();
            String retCode = callPRApproveCStmt.getObject(2).toString();

            if (!retCode.equals("S")) throw new Exception(retMsg);

            DBConnect.commitJDBCTransaction(conn);

		}
		catch (Exception e)
		{
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			throw e;
		}
		finally
		{
			if (callPRApproveCStmt != null) callPRApproveCStmt.close();
            if (rset != null) rset.close();
            if (stmt != null) stmt.close();
            if (rset1 != null) rset1.close();
            if (stmt1 != null) stmt1.close();           
			DBConnect.closeConnection(conn);
		}
	}

%>


<%--========================== JSP =========================================--%>
<%
    String resultMsg = "Success";
    String projectNo = emxGetParameter(request, "projectNo");
    String prNo = emxGetParameter(request, "prNo");  
    String drawingNo = emxGetParameter(request, "drawingNo"); 

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String inputMakerListYN = StringUtil.setEmptyExt(emxGetParameter(request, "inputMakerListYN"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));

    String errStr = "";

    ArrayList prPoInfoList = null;
    ArrayList prStateList = null;
    String drawingInfoHeader = "";
    try {
    	insertLogApprovePR(projectNo, drawingNo, prNo, loginID);
        approvePR(prNo);
    }
    catch (Exception e) {
        resultMsg = e.toString();
    }

%>

<script language="javascript">

    var urlStr = "stxPECEquipItemRegisterSearchPrPoInfo_SP.jsp?projectNo=<%=projectNo%>";
    urlStr += "&prNo=<%=prNo%>";
    urlStr += "&drawingNo=<%=drawingNo%>";
    urlStr += "&deptCode=<%=deptCode%>";
    urlStr += "&inputMakerListYN=<%=inputMakerListYN%>";
    urlStr += "&loginID=<%=loginID%>";

    alert("<%=resultMsg%>");
    
    parent.document.location.href = urlStr;
</script>
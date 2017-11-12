<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 - Maker List 저장
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementRegisterMakerListSave.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
	//request.setCharacterEncoding("euc-kr");
    String projectNo = request.getParameter("projectNo");
    String drawingNo = request.getParameter("drawingNo");
    String makerList = request.getParameter("makerList");
    String loginID   = request.getParameter("loginID");
/*
    System.out.println("projectNo = "+projectNo);
    System.out.println("drawingNo = "+drawingNo);
    System.out.println("makerList = "+makerList);
    System.out.println("loginID = "+loginID);
*/
    String resultMsg = "";

    ArrayList drawingNoList = StringUtil.split(drawingNo, "|");
    ArrayList makerListList = StringUtil.split(makerList, "|");

    java.sql.Connection conn = null;
    java.sql.PreparedStatement pstmt = null;
    java.sql.PreparedStatement pstmt1 = null;
    java.sql.PreparedStatement pstmt2 = null;
    java.sql.Statement stmt  = null;
    java.sql.ResultSet rset = null;
    java.sql.ResultSet rset1 = null;

    try {
        conn = DBConnect.getDBConnection("ERP_APPS");

        StringBuffer selectQuery = new StringBuffer();
        selectQuery.append("SELECT *                  \n");
        selectQuery.append("  FROM STX_PO_MAKELIST    \n");
        selectQuery.append(" WHERE PROJECT_NUMBER = ? \n");
        selectQuery.append("   AND DRAWING_NO = ?     \n");
  


        StringBuffer insertQuery = new StringBuffer();
        insertQuery.append("INSERT INTO STX_PO_MAKELIST                \n");
        insertQuery.append("       VALUES (?,?,?,sysdate,?,sysdate,?)  \n"); 


        StringBuffer updateQuery = new StringBuffer();
        updateQuery.append("UPDATE STX_PO_MAKELIST SET          \n");
        updateQuery.append("       MAKER_LIST = ?               \n");
        updateQuery.append("      ,LAST_UPDATED_DATE = SYSDATE  \n");
        updateQuery.append("      ,LAST_UPDATED_BY = ?          \n");
        updateQuery.append(" WHERE PROJECT_NUMBER = ?           \n");
        updateQuery.append("   AND DRAWING_NO = ?               \n");
        

        String personId = "";
        String updatePersonId = "";
        StringBuffer personIdSQL = new StringBuffer();
        personIdSQL.append("select ppf.person_id ");
        personIdSQL.append("     , fu.user_id ");
        personIdSQL.append("  from per_people_f ppf ");
        personIdSQL.append("     , fnd_user fu ");
        personIdSQL.append(" where ppf.person_id = fu.employee_id ");
        personIdSQL.append("   and ppf.employee_number = '"+loginID+"' ");
        personIdSQL.append("   and ppf.effective_end_date > trunc(sysdate) ");
        personIdSQL.append("   and nvl(fu.end_date,sysdate) >= trunc(sysdate) ");
        stmt = conn.createStatement();
        rset = stmt.executeQuery(personIdSQL.toString());

        while(rset.next()){
            personId = rset.getString(1);
            updatePersonId = rset.getString(2);
        }
        
        if(updatePersonId.equals("")){
            resultMsg += "Not exist Person ID! \n";
            throw new Exception("Not exist Person ID!");
        }

        pstmt  = conn.prepareStatement(selectQuery.toString());
        pstmt1 = conn.prepareStatement(insertQuery.toString());
        pstmt2 = conn.prepareStatement(updateQuery.toString());

        for(int i=0; i<drawingNoList.size(); i++)
        {
            String prevMakerList = "";
            pstmt.setString(1, projectNo);
            pstmt.setString(2, (String)drawingNoList.get(i));
            rset1 = pstmt.executeQuery();

            if (rset1.next()) prevMakerList = rset1.getString(1);

            if("".equals(prevMakerList))
            {
                pstmt1.setString(1, projectNo);
                pstmt1.setString(2, (String)drawingNoList.get(i));
                pstmt1.setString(3, (String)makerListList.get(i));
                pstmt1.setString(4, updatePersonId);
                pstmt1.setString(5, updatePersonId);
                pstmt1.executeUpdate();
            } else {
                pstmt2.setString(1, (String)makerListList.get(i));
                pstmt2.setString(2, updatePersonId);
                pstmt2.setString(3, projectNo);
                pstmt2.setString(4, (String)drawingNoList.get(i));
                pstmt2.executeUpdate();
            }
        }

        DBConnect.commitJDBCTransaction(conn);
        resultMsg = "SUCCESS"; 

    }
    catch (Exception e) {
        DBConnect.rollbackJDBCTransaction(conn);
        resultMsg = "ERROR  :  "+e.toString();    
    }
    finally{
        try {
            if ( rset != null ) rset.close();
            if ( rset1 != null ) rset1.close();
            if ( stmt != null ) stmt.close();
            if ( pstmt != null ) pstmt.close();
            if ( pstmt1 != null ) pstmt1.close();
            DBConnect.closeConnection( conn );
        } catch( Exception ex ) { }
    }       

%>
<%=resultMsg%>

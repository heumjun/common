<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 - 설계검토완료 등록
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementRegisterCreatePR.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "javax.activation.MimetypesFileTypeMap" %>
<%@ page import="java.io.*, java.text.SimpleDateFormat, java.sql.*"  %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String resultMsg = "";
    String urlProjectNo = "";
    String urlDeptCode = "";
    String urlInputMakerListYN = "";
    String urlLoginId = "";


    // 파일 업로드 디렉토리 설정
    String sTempDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가
	//String sTempDir = context.createWorkspace();


    // 디렉토리에 저장되어 있던 기존 파일 삭제
    /*****
    java.io.File tmpDir = new java.io.File(sTempDir);
    java.io.File[] files = tmpDir.listFiles();
	for(int i= 0; i< files.length; i++) {
    	files[i].delete();
	}
	*****/
    
    // 파일 업로드
	MultipartRequest multi = new MultipartRequest(request, sTempDir, max_byte, "euc-kr");

    // 페이지 호출 인자로 줄
    urlProjectNo = multi.getParameter("projectNo");
    urlDeptCode = multi.getParameter("deptCode");
    urlInputMakerListYN = multi.getParameter("inputMakerListYN");
    urlLoginId = multi.getParameter("loginID");


    // form태그의 file 제외한 파라미터
    String sSelCheckbox = "";
    Enumeration enumParams = multi.getParameterNames();
    while (enumParams.hasMoreElements())
    {
        String paramName = (String)enumParams.nextElement();
        //System.out.println(" paramName  =  "+paramName);
        if (paramName.startsWith("checkbox"))
        {
            String paramValue = multi.getParameter(paramName);

            //System.out.println("::::::::    paramValue =  "+paramValue);
            if("".equals(sSelCheckbox))
            {
                sSelCheckbox += paramValue;
            } else {
                sSelCheckbox += "," + paramValue;
            }
        }
    }

    ArrayList resultList = new ArrayList();
    if(!"".equals(sSelCheckbox))
    {
        StringTokenizer st = new StringTokenizer(sSelCheckbox,",");
        while(st.hasMoreTokens())
        {
            String checkboxValue = st.nextToken();
            HashMap resultMap = new HashMap();
			resultMap.put("projectNo", multi.getParameter("projectNo"));
            resultMap.put("drawingNo", multi.getParameter("drawingNo"+checkboxValue));
            resultMap.put("completeFile", multi.getFilesystemName("completeFile"+checkboxValue) == null ? "" : multi.getFilesystemName("completeFile"+checkboxValue));
            resultMap.put("fileType", multi.getContentType("completeFile"+checkboxValue) == null ? "" : multi.getContentType("completeFile"+checkboxValue));

            resultList.add(resultMap);
        }
    }

    if(resultList.size() > 0)
    {        
        Connection conn = null;

        Statement stmt  = null;
        Statement stmt1 = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        PreparedStatement pstmt6 = null;
        PreparedStatement pstmt7 = null;
        PreparedStatement pstmt8 = null;
        ResultSet rset = null;
        ResultSet rset1 = null;
        ResultSet rset2 = null;
        OutputStream outstream  = null;
        FileInputStream finstream  = null;

        try
        {
            conn = DBConnect.getDBConnection("ERP_APPS");

            StringBuffer sqlSelectSeq1 = new StringBuffer();
            StringBuffer sqlSelectSeq2 = new StringBuffer();
            StringBuffer sqlSelectSeq3 = new StringBuffer();

            StringBuffer sqlSaveFile1 = new StringBuffer();
            StringBuffer sqlSaveFile2 = new StringBuffer();
            StringBuffer sqlSaveFile3 = new StringBuffer();
            StringBuffer sqlSaveFile4 = new StringBuffer();
            StringBuffer sqlSaveFile5 = new StringBuffer();
            StringBuffer sqlSaveFile6 = new StringBuffer();

            // ERP 첨부파일 테이블 시퀀스 추출
            sqlSelectSeq1.append("SELECT FND_LOBS_S.NEXTVAL                 \n");
            sqlSelectSeq1.append("  FROM DUAL                               \n");

            // ERP 첨부문서 테이블 시퀀스 추출
            sqlSelectSeq2.append("SELECT FND_DOCUMENTS_S.NEXTVAL            \n");
            sqlSelectSeq2.append("  FROM DUAL                               \n");

            // ERP 첨부파일 + 첨부문서 연계 정보 테이블 시퀀스 추출
            sqlSelectSeq3.append("SELECT FND_ATTACHED_DOCUMENTS_S.NEXTVAL   \n");
            sqlSelectSeq3.append("  FROM DUAL                               \n");

            // ERP 첨부파일 테이블에 첨부파일 정보 저장
            sqlSaveFile1.append("INSERT INTO FND_LOBS                                                                \n"); 
            sqlSaveFile1.append("       (FILE_ID, FILE_NAME, FILE_CONTENT_TYPE, UPLOAD_DATE, PROGRAM_NAME,           \n");
            sqlSaveFile1.append("        LANGUAGE, ORACLE_CHARSET, FILE_FORMAT)                                      \n");
            sqlSaveFile1.append("VALUES (?, ?, ?, sysdate, 'FNDATTCH', 'KO', 'UTF8', 'BINARY')                        \n");

            // ERP 첨부파일 테이블의 파일 저장 컬럼 비우기
            sqlSaveFile2.append("UPDATE FND_LOBS SET FILE_DATA = EMPTY_BLOB()                                        \n");
            sqlSaveFile2.append(" WHERE FILE_ID = ?                                                                  \n"); 

            sqlSaveFile3.append("SELECT FILE_DATA                           \n");
            sqlSaveFile3.append("  FROM FND_LOBS                            \n");
            sqlSaveFile3.append(" WHERE FILE_ID = ?                         \n");

            // ERP 첨부문서 테이블에 문서 정보 저장
            // CREATED_BY,LAST_UPDATED_BY,LAST_UPDATE_LOGIN는 모르겠다. 나머지는 고정
            sqlSaveFile4.append("INSERT INTO FND_DOCUMENTS                                                           \n");
            sqlSaveFile4.append("       (DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,  \n");
            sqlSaveFile4.append("        LAST_UPDATE_LOGIN, DATATYPE_ID, CATEGORY_ID, SECURITY_TYPE,                 \n");
            sqlSaveFile4.append("        SECURITY_ID, PUBLISH_FLAG, USAGE_TYPE)                                      \n");
            sqlSaveFile4.append("VALUES (?, sysdate, ?, sysdate, ?, 13920447, 6, 35, 1, 0, 'Y', 'O')           \n");

            // ERP 첨부문서 테이블에 문서 상세 정보 저장
            // CREATED_BY,LAST_UPDATED_BY,LAST_UPDATE_LOGIN는 모르겠다. 나머지는 고정
            sqlSaveFile5.append("INSERT INTO FND_DOCUMENTS_TL                                                        \n");
            sqlSaveFile5.append("       (DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,  \n");
            sqlSaveFile5.append("        LAST_UPDATE_LOGIN, LANGUAGE, DESCRIPTION, FILE_NAME, MEDIA_ID, SOURCE_LANG) \n");
            sqlSaveFile5.append("VALUES (?, sysdate, ?, sysdate, ?, 13920447, ?, '설계검토완료', ?, ?, 'KO')  \n");


            // ERP 첨부파일 + 첨부문서 테이블에 문서 및 첨부파일 연계 정보 저장
            // ENTITY_NAME은 REQ_HEADERS. PK1_VALUE는 호선, PK2_VALUE는 도면번호  : 설계검토완료 파일 저장용
            sqlSaveFile6.append("INSERT INTO FND_ATTACHED_DOCUMENTS                                                                         \n");
            sqlSaveFile6.append("       (ATTACHED_DOCUMENT_ID, DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,   \n");
            sqlSaveFile6.append("        LAST_UPDATE_LOGIN, SEQ_NUM, ENTITY_NAME, PK1_VALUE, PK2_VALUE, AUTOMATICALLY_ADDED_FLAG)                      \n");
            sqlSaveFile6.append("VALUES (?, ?, sysdate, ?, sysdate, ?, 13920447, ?, 'STX_PO_EQUIPMENT_DP', ?, ?, 'N')                    \n");

            for(int j=0; j < resultList.size(); j++)
            {
                Map resultMap = (Map)resultList.get(j);
                String projectNo = (String) resultMap.get("projectNo");
                String drawingNo = (String) resultMap.get("drawingNo");
                String completeFile =  (String) resultMap.get("completeFile");
                String fileType =  (String) resultMap.get("fileType");
                String personId = "";
                String updatePersonId = "";
                        
                StringBuffer personIdSQL = new StringBuffer();
                personIdSQL.append("select ppf.person_id ");
                personIdSQL.append("     , fu.user_id ");
                personIdSQL.append("  from per_people_f ppf ");
                personIdSQL.append("     , fnd_user fu ");
                personIdSQL.append(" where ppf.person_id = fu.employee_id ");
                personIdSQL.append("   and ppf.employee_number = '"+urlLoginId+"' ");
                personIdSQL.append("   and ppf.effective_end_date > trunc(sysdate) ");
                personIdSQL.append("   and nvl(fu.end_date,sysdate) >= trunc(sysdate) ");

                stmt = conn.createStatement();                
                rset = stmt.executeQuery(personIdSQL.toString());

                while(rset.next()){
                    personId = rset.getString(1);
                    updatePersonId = rset.getString(2);
                }
                
                if(personId.equals("")){
                    resultMsg += "Not exist Person ID!";
                    throw new Exception("Not exist Person ID!");
                }              

                stmt1 = conn.createStatement();

                pstmt1 = conn.prepareStatement(sqlSaveFile1.toString());
                pstmt2 = conn.prepareStatement(sqlSaveFile2.toString());
                pstmt3 = conn.prepareStatement(sqlSaveFile3.toString());
                pstmt4 = conn.prepareStatement(sqlSaveFile4.toString());
                pstmt5 = conn.prepareStatement(sqlSaveFile5.toString());
                pstmt6 = conn.prepareStatement(sqlSaveFile6.toString());

                //updatePersonId = "4737";


                // 파일명이 있을 경우에만 저장
                if(!"".equals(completeFile))
                {
                    File file = new File(sTempDir +  java.io.File.separator + completeFile);

                    String file_id = "";
                    String document_id = "";
                    String attached_document_id = "";

                    // 각 테이블의 시퀀스 번호 추출함.
                    rset1 = stmt1.executeQuery(sqlSelectSeq1.toString());
                    if (rset1.next()) file_id = rset1.getString(1);

                    rset1 = stmt1.executeQuery(sqlSelectSeq2.toString());
                    if (rset1.next()) document_id = rset1.getString(1);

                    rset1 = stmt1.executeQuery(sqlSelectSeq3.toString());
                    if (rset1.next()) attached_document_id = rset1.getString(1);

                    System.out.println(" ===== 설계검토 완료시퀀스 ==== ");
                    System.out.println(" file_id  =  "+file_id);
                    System.out.println(" document_id  =  "+document_id);
                    System.out.println(" attached_document_id  =  "+attached_document_id);

                    // fnd_lobs : 첨부파일 저장 테이블에 저장
                    pstmt1.setString(1, file_id);
                    pstmt1.setString(2, completeFile);
                    pstmt1.setString(3, fileType);
                    //pstmt1.setString(3, new MimetypesFileTypeMap().getContentType(file));

                    pstmt1.executeUpdate();

                    // EMPTY_BLOB() 처리
                    // : empty_blob()로 초기화되지 않은 경우 초기화 필요...
                    pstmt2.setString(1, file_id);
                    pstmt2.executeUpdate();

                    // SET BLOB FIELD
                    oracle.sql.BLOB blob  = null;
                    pstmt3.setString(1, file_id);
                    rset2 = pstmt3.executeQuery();
                    if (rset2.next()) blob = (oracle.sql.BLOB)rset2.getBlob(1);

                    outstream = blob.getBinaryOutputStream();
                    int size = blob.getBufferSize();
                    finstream = new FileInputStream(file);
                    
                    byte[] buffer = new byte[size];
                    int length = -1;
                    while ((length = finstream.read(buffer)) != -1) {
                        outstream.write(buffer, 0, length);
                    }

                    if (finstream != null) finstream.close();               
                    if (outstream != null) outstream.close(); 

                    // fnd_documents : 첨부문서 테이블에 저장
                    pstmt4.setString(1, document_id);
                    pstmt4.setString(2, updatePersonId);
                    pstmt4.setString(3, updatePersonId);
                    pstmt4.executeUpdate();

                    // fnd_documents_tl : 첨부문서 상세 정보 테이블에 저장
                    pstmt5.setString(1, document_id);
                    pstmt5.setString(2, updatePersonId);
                    pstmt5.setString(3, updatePersonId);
                    pstmt5.setString(4, "KO");
                    pstmt5.setString(5, completeFile);
                    pstmt5.setString(6, file_id);
                    pstmt5.executeUpdate();

                    // 위 Insert와 동일하고 LANGUAGE부분의 KO, US만 다름
                    pstmt5.setString(1, document_id);
                    pstmt5.setString(2, updatePersonId);
                    pstmt5.setString(3, updatePersonId);
                    pstmt5.setString(4, "US");
                    pstmt5.setString(5, completeFile);
                    pstmt5.setString(6, file_id);
                    pstmt5.executeUpdate();


                    String maxSeqNum = "";
                    StringBuffer maxSEQ_NUM = new StringBuffer();
                    maxSEQ_NUM.append("SELECT MAX(SEQ_NUM)+10                       \n");
                    maxSEQ_NUM.append("  FROM FND_ATTACHED_DOCUMENTS                \n");
                    maxSEQ_NUM.append(" WHERE ENTITY_NAME='STX_PO_EQUIPMENT_DP'     \n");
                    maxSEQ_NUM.append("   AND PK1_VALUE='"+projectNo+"'             \n");
                    maxSEQ_NUM.append("   AND PK2_VALUE='"+drawingNo+"'             \n");

                    rset1 = stmt1.executeQuery(maxSEQ_NUM.toString());
                    if (rset1.next()) maxSeqNum = rset1.getString(1);
                    if ("".equals(maxSeqNum) || maxSeqNum==null ) maxSeqNum = "10";  // seq가 없으면 10으로..

                    // fnd_attached_documents : 첨부문서 + 첨부파일 연계 정보 테이블에 저장
                    pstmt6.setString(1, attached_document_id);
                    pstmt6.setString(2, document_id);
                    pstmt6.setString(3, updatePersonId);
                    pstmt6.setString(4, updatePersonId);
                    pstmt6.setString(5, maxSeqNum);
                    pstmt6.setString(6, projectNo);
                    pstmt6.setString(7, drawingNo);
   
                    pstmt6.executeUpdate();                   

                } 
                String requisition_header_id = "";
                String revision_num = "";
                String pr_no = "";   
                String media_id = ""; 
                String file_name = ""; 
                String document_description = ""; 

                StringBuffer selectSQL = new StringBuffer();
                selectSQL.append("SELECT REQUISITION_HEADER_ID,           \n");
                selectSQL.append("       REVISION_NUM,                    \n");
                selectSQL.append("       PR_NO,                           \n");
                selectSQL.append("       DRAWING_NO                       \n");
                selectSQL.append("  FROM STX_PO_EQUIPMENT_DP              \n");
                selectSQL.append(" WHERE 1 = 1                            \n");
                selectSQL.append("   AND PROJECT_NUMBER = '"+projectNo+"' \n");
                selectSQL.append("   AND DRAWING_NO = '"+drawingNo+"'     \n");

                //System.out.println("~~~ selectSQL = "+selectSQL.toString());

                stmt = conn.createStatement();                
                rset = stmt.executeQuery(selectSQL.toString());

                while(rset.next()){
                    requisition_header_id = rset.getString(1);
                    revision_num = rset.getString(2);
                    pr_no = rset.getString(3);
                }

                StringBuffer selectSQL_1 = new StringBuffer();
                selectSQL_1.append("SELECT MEDIA_ID,                                              \n");
                selectSQL_1.append("       FILE_NAME,                                             \n");
                selectSQL_1.append("       DOCUMENT_DESCRIPTION                                   \n");
                selectSQL_1.append("  FROM FND_ATTACHED_DOCS_FORM_VL                              \n");
                selectSQL_1.append(" WHERE FUNCTION_NAME='STX_STXPO169'                           \n");
                selectSQL_1.append("   AND ENTITY_NAME= 'STX_PO_EQUIPMENT_DP'                     \n");
                selectSQL_1.append("   AND PK1_VALUE = '"+projectNo+"'                            \n");
                selectSQL_1.append("   AND PK2_VALUE = '"+drawingNo+"'                            \n");
                selectSQL_1.append("   AND SEQ_NUM IN (SELECT MAX(SEQ_NUM)                        \n");
                selectSQL_1.append("                     FROM FND_ATTACHED_DOCS_FORM_VL           \n");
                selectSQL_1.append("                    WHERE FUNCTION_NAME='STX_STXPO169'        \n");
                selectSQL_1.append("                      AND ENTITY_NAME= 'STX_PO_EQUIPMENT_DP'  \n");
                selectSQL_1.append("                      AND PK1_VALUE = '"+projectNo+"'         \n");
                selectSQL_1.append("                      AND PK2_VALUE = '"+drawingNo+"')        \n");

               // System.out.println("~~~ selectSQL_1 = "+selectSQL_1.toString());

                stmt = conn.createStatement();                
                rset = stmt.executeQuery(selectSQL_1.toString());

                while(rset.next()){
                    media_id = rset.getString(1);
                    file_name = rset.getString(2);
                    document_description = rset.getString(3);
                }

                //System.out.println("~~~ requisition_header_id = "+requisition_header_id);
                //System.out.println("~~~ revision_num = "+revision_num);
                //System.out.println("~~~ pr_no = "+pr_no);
                //System.out.println("~~~ media_id = "+media_id);
                //System.out.println("~~~ file_name = "+file_name);
                //System.out.println("~~~ document_description = "+document_description);                
                
                StringBuffer dpInsertSQL = new StringBuffer();
                dpInsertSQL.append("INSERT INTO STX_PO_EQUIPMENT_REQUEST          \n");
                dpInsertSQL.append("           ( REQUISITION_HEADER_ID,           \n");
                dpInsertSQL.append("             REVISION_NUM,                    \n");
                dpInsertSQL.append("             PROJECT_NUMBER,                  \n");
                dpInsertSQL.append("             DRAWING_NO,                      \n");
                dpInsertSQL.append("             PR_NO,                           \n");
                dpInsertSQL.append("             FILE_ID,                         \n");
                dpInsertSQL.append("             FILE_NAME,                       \n");
                dpInsertSQL.append("             DOCUMENT_DESCRIPTION,            \n");
                //dpInsertSQL.append("             DRAW_REQUEST_DATE,               \n");
                dpInsertSQL.append("             DRAW_COMPLETE_DATE,              \n");
               // dpInsertSQL.append("             DRAW_REQUEST_FLAG,              \n");
                dpInsertSQL.append("             DRAW_COMPLETE_FLAG,              \n");
                dpInsertSQL.append("             LAST_UPDATED_DATE,               \n");
                dpInsertSQL.append("             LAST_UPDATED_BY,                 \n");
                dpInsertSQL.append("             CREATION_DATE,                   \n");
                dpInsertSQL.append("             CREATED_BY )                     \n");
                dpInsertSQL.append("    VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, sysdate, 'Y', sysdate, ?, sysdate, ?) \n");

                //System.out.println("~~~ dpInsertSQL = "+dpInsertSQL.toString());

                pstmt7 = conn.prepareStatement(dpInsertSQL.toString());

                pstmt7.setString(1, requisition_header_id);
                pstmt7.setString(2, revision_num);
                pstmt7.setString(3, projectNo);
                pstmt7.setString(4, drawingNo);
                pstmt7.setString(5, pr_no);
                pstmt7.setString(6, media_id);
                pstmt7.setString(7, file_name);
                pstmt7.setString(8, document_description);
                pstmt7.setString(9, updatePersonId);
                pstmt7.setString(10, updatePersonId);
                pstmt7.executeUpdate();

                StringBuffer dpUpdateSQL = new StringBuffer();

                dpUpdateSQL.append("UPDATE STX_PO_EQUIPMENT_DP SET   \n");
                dpUpdateSQL.append("  DRAW_COMPLETE_DATE = sysdate   \n");  
                dpUpdateSQL.append(" ,DRAW_COMPLETE_FLAG = 'Y'       \n"); 
                dpUpdateSQL.append(" ,LAST_UPDATED_DATE = sysdate    \n"); 
                dpUpdateSQL.append(" ,LAST_UPDATED_BY   = ?          \n");
                dpUpdateSQL.append(" WHERE PROJECT_NUMBER = ?        \n");
                dpUpdateSQL.append("   AND DRAWING_NO = ?            \n");

                pstmt8 = conn.prepareStatement(dpUpdateSQL.toString());

                pstmt8.setString(1, updatePersonId);
                pstmt8.setString(2, projectNo);
                pstmt8.setString(3, drawingNo);
                pstmt8.executeUpdate();

                DBConnect.commitJDBCTransaction(conn);

                StringBuffer callMail = new StringBuffer("");
                callMail.append("{call STX_PO_EQUIPMENT_MAIL_PKG.DRAW_REQUEST_MAIL('"+requisition_header_id+"','"+revision_num+"','N','Y','"+updatePersonId+"')} ");             

                CallableStatement cs1 = conn.prepareCall(callMail.toString());
                //cs1.registerOutParameter(1, 12);
                //cs1.registerOutParameter(2, 12);
                cs1.execute();
            }            
            resultMsg = "Save Success!";  
          
        }
        catch (Exception e) {
            DBConnect.rollbackJDBCTransaction(conn);
            e.printStackTrace();
            if("".equals(resultMsg))
            {
                resultMsg = "Save Error!";    
            }
        }
        finally{
            try {
                if ( rset != null ) rset.close();
                if ( rset1 != null ) rset1.close();
                if ( rset2 != null ) rset2.close();
                if ( stmt != null ) stmt.close();
                if ( stmt1 != null ) stmt1.close();
                if ( pstmt1 != null ) pstmt1.close();
                if ( pstmt2 != null ) pstmt2.close();
                if ( pstmt3 != null ) pstmt3.close();
                if ( pstmt4 != null ) pstmt4.close();
                if ( pstmt5 != null ) pstmt5.close();
                if ( pstmt6 != null ) pstmt6.close();
                if ( pstmt7 != null ) pstmt7.close();
                if ( pstmt8 != null ) pstmt8.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }  

    } 
%>

<script language="javascript">

    var urlStr = "stxPECEquipItemPurchasingScheduleManagementRegisterMain.jsp?projectNo=<%=urlProjectNo%>";
    urlStr += "&deptCode=<%=urlDeptCode%>";
    urlStr += "&inputMakerListYN=<%=urlInputMakerListYN%>";
    urlStr += "&loginID=<%=urlLoginId%>";

    alert("<%=resultMsg%>");
    
    parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.location = urlStr;
</script>
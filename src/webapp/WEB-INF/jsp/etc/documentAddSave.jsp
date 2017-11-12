<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 메뉴얼 및 양식지 추가 저장 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoDocumentAddSave.jsp
--%>
<%@ page import = "javax.servlet.http.*" %>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "org.springframework.web.multipart.*" %>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%
    String resultMsg = "";
    // 파일 업로드 디렉토리 설정	
    //String sTempDir = "D:\\ematrix\\stxcentral\\temp";
    //String sTempDir = "\\DIS\\AddOn\\FILE_TEMP";
    //String sTempDir = "..\\FILE_TEMP";    

   // String sTempDir = session.getServletContext().getRealPath("FILE_TEMP");   //// C:\oracle\Middleware\workspace\DIS\build\weboutput\FILE_TEMP 
   /// System.out.println("~~~~~~ sTempDir="+sTempDir);
    String sTempDir = "C:/DIS_FILE/";    

/*
    // 디렉토리에 저장되어 있던 기존 파일 삭제
    java.io.File tmpDir = new java.io.File(sTempDir);
    java.io.File[] files = tmpDir.listFiles();
	for(int i= 0; i< files.length; i++) {
       // System.out.println("delete : "+files[i].getName());
    	files[i].delete();
	}
*/

	/* int sizeLimit = 5 * 1024 * 1024;	
    MultipartRequest multi = new MultipartRequest(request, sTempDir, sizeLimit, "euc-kr");

    String loginID = multi.getParameter("loginID");
    String fileName = multi.getFilesystemName("fileName") == null ? "" : multi.getFilesystemName("fileName");
    String fileType = multi.getContentType("fileName") == null ? "" : multi.getContentType("fileName"); */
    
    /* String loginID = request.getParameter("loginID"); */
    Map loginUser = (Map) request.getSession().getAttribute("loginUser");
	// String loginID = SessionUtils.getUserId();
	String loginID = (String) loginUser.get("user_id");
	
    MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
	Object pos_file = multipartRequest.getFile("fileName");

	// 파일 정보
	String fileName = ((MultipartFile) pos_file).getOriginalFilename();
	String fileType = ((MultipartFile) pos_file).getContentType();
	long fileSize = ((MultipartFile) pos_file).getSize();
	
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
    ResultSet rset = null;
    ResultSet rset1 = null;
    ResultSet rset2 = null;
    OutputStream outstream  = null;
    /* FileInputStream finstream  = null; */
    InputStream finstream  = null;

    try
    {
        // 파일명이 있을 경우에만 저장
        if(!"".equals(fileName))
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
            sqlSaveFile4.append("INSERT INTO FND_DOCUMENTS                                                           \n");
            sqlSaveFile4.append("       (DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,  \n");
            sqlSaveFile4.append("        DATATYPE_ID, CATEGORY_ID, SECURITY_TYPE,                                    \n");
            sqlSaveFile4.append("        SECURITY_ID, PUBLISH_FLAG, USAGE_TYPE)                                      \n");
            sqlSaveFile4.append("VALUES (?, sysdate, ?, sysdate, ?, 6, 1, 1, 0, 'Y', 'O')                            \n");

            // ERP 첨부문서 테이블에 문서 상세 정보 저장
            sqlSaveFile5.append("INSERT INTO FND_DOCUMENTS_TL                                                        \n");
            sqlSaveFile5.append("       (DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,  \n");
            sqlSaveFile5.append("        LANGUAGE, DESCRIPTION, FILE_NAME, MEDIA_ID, SOURCE_LANG)                    \n");
            sqlSaveFile5.append("VALUES (?, sysdate, ?, sysdate, ?, ?, 'EP기준정보_문서', ?, ?, 'KO')                \n");

            // ERP 첨부파일 + 첨부문서 테이블에 문서 및 첨부파일 연계 정보 저장
            sqlSaveFile6.append("INSERT INTO FND_ATTACHED_DOCUMENTS                                                  \n");
            sqlSaveFile6.append("       (ATTACHED_DOCUMENT_ID, DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,   \n");
            sqlSaveFile6.append("        SEQ_NUM, ENTITY_NAME, PK1_VALUE, AUTOMATICALLY_ADDED_FLAG)                  \n");
            sqlSaveFile6.append("VALUES (?, ?, sysdate, ?, sysdate, ?, 10, 'STX_PLM_EP_INFO_DOCUMENTS', ?, 'N')      \n");

            // 사번 ID(ERP에서 사용하는) 추출
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
                throw new Exception("Not exist Person ID!");
            }


            stmt1 = conn.createStatement();
            pstmt1 = conn.prepareStatement(sqlSaveFile1.toString());
            pstmt2 = conn.prepareStatement(sqlSaveFile2.toString());
            pstmt3 = conn.prepareStatement(sqlSaveFile3.toString());
            pstmt4 = conn.prepareStatement(sqlSaveFile4.toString());
            pstmt5 = conn.prepareStatement(sqlSaveFile5.toString());
            pstmt6 = conn.prepareStatement(sqlSaveFile6.toString());



            /* File file = new File(sTempDir +  java.io.File.separator + fileName); */

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
/*
            System.out.println(" ===== 문서 저장 시퀀스 ==== ");
            System.out.println(" file_id  =  "+file_id);
            System.out.println(" document_id  =  "+document_id);
            System.out.println(" attached_document_id  =  "+attached_document_id);
*/
            // fnd_lobs : 첨부파일 저장 테이블에 저장
            pstmt1.setString(1, file_id);
            pstmt1.setString(2, fileName);
            pstmt1.setString(3, fileType);  //new MimetypesFileTypeMap().getContentType(file)
            // System.out.println("^^  1. pstmt1 ok.......");

            pstmt1.executeUpdate();
            //System.out.println("^^  1. insert ok.......");

            // EMPTY_BLOB() 처리
            // : empty_blob()로 초기화되지 않은 경우 초기화 필요...
            pstmt2.setString(1, file_id);
            pstmt2.executeUpdate();
            //System.out.println("^^  2. empty_blob ok.......");

            // SET BLOB FIELD
            oracle.sql.BLOB blob  = null;
            pstmt3.setString(1, file_id);
            rset2 = pstmt3.executeQuery();
            if (rset2.next()) blob = (oracle.sql.BLOB)rset2.getBlob(1);

            outstream = blob.getBinaryOutputStream();
            int size = blob.getBufferSize();
            /* finstream = new FileInputStream(file); */
            finstream = ((MultipartFile) pos_file).getInputStream();
            
            byte[] buffer = new byte[size];
            int length = -1;
            while ((length = finstream.read(buffer)) != -1) {
                outstream.write(buffer, 0, length);
            }

            if (finstream != null) finstream.close();               
            if (outstream != null) outstream.close(); 

            //System.out.println("^^  4. file insert ok.......");

            // fnd_documents : 첨부문서 테이블에 저장
            pstmt4.setString(1, document_id);
            pstmt4.setString(2, updatePersonId);
            pstmt4.setString(3, updatePersonId);
            pstmt4.executeUpdate();
            //System.out.println("^^  5. document insert ok.......");

            // fnd_documents_tl : 첨부문서 상세 정보 테이블에 저장
            pstmt5.setString(1, document_id);
            pstmt5.setString(2, updatePersonId);
            pstmt5.setString(3, updatePersonId);
            pstmt5.setString(4, "KO");
            pstmt5.setString(5, fileName);
            pstmt5.setString(6, file_id);
            pstmt5.executeUpdate();
            //System.out.println("^^  6-1. document spec insert ok.......");

            // 위 Insert와 동일하고 LANGUAGE부분의 KO, US만 다름
            pstmt5.setString(1, document_id);
            pstmt5.setString(2, updatePersonId);
            pstmt5.setString(3, updatePersonId);
            pstmt5.setString(4, "US");
            pstmt5.setString(5, fileName);
            pstmt5.setString(6, file_id);
            pstmt5.executeUpdate();
            //System.out.println("^^  6-2. document spec insert ok.......");

            // fnd_attached_documents : 첨부문서 + 첨부파일 연계 정보 테이블에 저장
            pstmt6.setString(1, attached_document_id);
            pstmt6.setString(2, document_id);
            pstmt6.setString(3, updatePersonId);
            pstmt6.setString(4, updatePersonId);
            pstmt6.setString(5, file_id);
            pstmt6.executeUpdate();
            // System.out.println("^^ 7. document + file insert ok.......");


            // DOCUMENT 리스트 관리 테이블에 저장
            StringBuffer tableInsertSQL = new StringBuffer();
            tableInsertSQL.append("insert into STX_PLM_EP_INFO_DOCUMENTS( FILE_ID,                     \n");
            tableInsertSQL.append(" 									  FILE_NAME,                   \n");
            tableInsertSQL.append(" 									  ENTITY_NAME,                 \n");
            tableInsertSQL.append(" 									  CREATED_BY,                  \n");
            tableInsertSQL.append(" 									  CREATION_DATE )              \n");
            tableInsertSQL.append("                              VALUES ( ?,                           \n");
            tableInsertSQL.append("                                       ?,                           \n");
            tableInsertSQL.append("                                       'STX_PLM_EP_INFO_DOCUMENTS', \n");
            tableInsertSQL.append("                                       ?,                           \n");
            tableInsertSQL.append("                                       SYSDATE )                    \n");

            pstmt7 = conn.prepareStatement(tableInsertSQL.toString());
            pstmt7.setString(1, file_id);
            pstmt7.setString(2, fileName);
            pstmt7.setString(3, updatePersonId);
            pstmt7.executeUpdate();

            DBConnect.commitJDBCTransaction(conn);
            resultMsg = "Save Success!";


        }
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
            DBConnect.closeConnection( conn );
        } catch( Exception ex ) { }
    } 

%>


<script language="javascript">
    var urlStr = "documentView.do?loginID=<%=loginID%>";     
    opener.location = urlStr; 
    self.close();

</script>

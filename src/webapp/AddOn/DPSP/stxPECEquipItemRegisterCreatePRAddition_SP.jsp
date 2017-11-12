<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 - 추가 PR 발행
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemRegisterCreatePRAddition_SP.jsp
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

	System.out.println( "~~ CreatePR start :: stxPECEquipItemRegisterCreatePRAddition" );
    // 파일 업로드 디렉토리 설정
    String sTempDir = "C:/DIS_FILE/";
    int max_byte = 100*1024*1024;            //최대용량 100메가    
	//String sTempDir = context.createWorkspace();
    //System.out.println("~~ sTempDir = "+sTempDir); 

    // 디렉토리에 저장되어 있던 기존 파일 삭제
    /*****
    java.io.File tmpDir = new java.io.File(sTempDir);
    java.io.File[] files = tmpDir.listFiles();
	for(int i= 0; i< files.length; i++) {
       // System.out.println("delete : "+files[i].getName());
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
    ArrayList resultList = new ArrayList();

    String checkboxValue = "0";
    HashMap tempMap = new HashMap();
    tempMap.put("projectNo", multi.getParameter("projectNo"));
    tempMap.put("drawingNo", multi.getParameter("drawingNo"+checkboxValue));
    tempMap.put("drawingTitle", multi.getParameter("drawingTitle"+checkboxValue) == null ? "" : multi.getParameter("drawingTitle"+checkboxValue));
    tempMap.put("drDate", multi.getParameter("drDate"+checkboxValue) == null ? "" : multi.getParameter("drDate"+checkboxValue));
    tempMap.put("itemCode", multi.getParameter("itemCode"+checkboxValue) == null ? "" : multi.getParameter("itemCode"+checkboxValue));
    tempMap.put("fileName", multi.getFilesystemName("fileName"+checkboxValue) == null ? "" : multi.getFilesystemName("fileName"+checkboxValue));
    tempMap.put("fileType", multi.getContentType("fileName"+checkboxValue) == null ? "" : multi.getContentType("fileName"+checkboxValue));
    tempMap.put("pndDate", multi.getParameter("pndDate"+checkboxValue) == null ? "" : multi.getParameter("pndDate"+checkboxValue));

    resultList.add(tempMap);
    //System.out.println("resultList = "+resultList.toString());

    if(resultList.size() > 0)
    {
        
        Connection jhConn = null;
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
        FileInputStream finstream  = null;

        try
        {

            jhConn = DBConnect.getDBConnection("ERP_APPS");
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
            sqlSaveFile5.append("VALUES (?, sysdate, ?, sysdate, ?, 13920447, ?, '스펙첨부', ?, ?, 'KO')  \n");

            // ERP 첨부파일 + 첨부문서 테이블에 문서 및 첨부파일 연계 정보 저장
            // ENTITY_NAME은 REQ_HEADERS. PK1_VALUE는 PR_ID : 첨부spec저장용
            sqlSaveFile6.append("INSERT INTO FND_ATTACHED_DOCUMENTS                                                                         \n");
            sqlSaveFile6.append("       (ATTACHED_DOCUMENT_ID, DOCUMENT_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,   \n");
            sqlSaveFile6.append("        LAST_UPDATE_LOGIN, SEQ_NUM, ENTITY_NAME, PK1_VALUE, AUTOMATICALLY_ADDED_FLAG)                      \n");
            sqlSaveFile6.append("VALUES (?, ?, sysdate, ?, sysdate, ?, 13920447, 10, 'REQ_HEADERS', ?, 'N')                    \n");


            for(int j=0; j < resultList.size(); j++)
            {
                Map resultMap = (Map)resultList.get(j);
                String projectNo = (String) resultMap.get("projectNo");
                String drawingNo = (String) resultMap.get("drawingNo");
                String drawingTitle =  (String) resultMap.get("drawingTitle");
                String drDate =  (String) resultMap.get("drDate");
                String itemCode =  (String) resultMap.get("itemCode");
                String fileName =  (String) resultMap.get("fileName");
                String fileType =  (String) resultMap.get("fileType");
                String pndDate =  (String) resultMap.get("pndDate");
                String mailDescription = projectNo + "  ( "+drawingTitle+" )";

                System.out.println(" CreatePR start pr == "+drawingNo+"   :  "+fileName);

                String prCreator = "";
                prCreator = urlLoginId;

                String retPrNo = "";
                String retPrId = "";
                String deptId = "";
                String personId = "";
                String updatePersonId = "";

                String pndDate_ERP = "";
				String pndDate_last = "";

                try
                {
                    stmt = jhConn.createStatement();     

					// 2013-01-05 Kang seonjung : PND 일자 로직 수정 (아래 일자가 SYSDATE+7일 이후 날짜만 가능 )
					// 2012-07-02 Kang seonjung : PND 일자 로직 수정  (1순위:조달 PND 일자  2순위 : 설계PND 일자  3순위: KL-30  4순위 : SYSDATE)
                    // 2011-05-04 Kang seonjung : PND 일자를 조달 절점관리 Data로 사용함.
                    StringBuffer pndDateSQL = new StringBuffer();

				    // pndDateSQL.append("SELECT TO_CHAR(DECODE(EQUIP_DATE_1ST, NULL, DECODE(JOB_FIRST_NEED, NULL, FIRST_NEED_DATE, JOB_FIRST_NEED), EQUIP_DATE_1ST), 'YYYY-MM-DD') AS PND_DATE   ");
				    // 조달 절점일자도 현재보다 이후 DATE 만 활용
					pndDateSQL.append("SELECT TO_CHAR( CASE                                                \n");
					pndDateSQL.append("                    WHEN DECODE(EQUIP_DATE_1ST, NULL, DECODE(JOB_FIRST_NEED, NULL, FIRST_NEED_DATE, JOB_FIRST_NEED), EQUIP_DATE_1ST) > SYSDATE+7 THEN DECODE(EQUIP_DATE_1ST, NULL, DECODE(JOB_FIRST_NEED, NULL, FIRST_NEED_DATE, JOB_FIRST_NEED), EQUIP_DATE_1ST)      \n");
					pndDateSQL.append("                    ELSE NULL                                       \n");
					pndDateSQL.append("                 END , 'YYYY-MM-DD') AS PND_DATE                    \n");
                    pndDateSQL.append("  FROM STX_PO_EQUIPMENT_DP_V                                        \n");
                    pndDateSQL.append(" WHERE PROJECT_NUMBER = '"+projectNo+"'                             \n");
                    pndDateSQL.append("   AND DRAWING_NO = '"+drawingNo+"'                                 \n");
                    
                    rset = stmt.executeQuery(pndDateSQL.toString());
                    while(rset.next()){
                        pndDate_ERP = rset.getString(1) == null ? "" : rset.getString(1);
                    }
					
					if("".equals(pndDate_ERP))
					{
						Connection connDP = null;

						Statement stmtDP  = null;
						ResultSet rsetDP = null;						

						connDP = DBConnect.getDBConnection("SDPSP");
						stmtDP = connDP.createStatement(); 

						StringBuffer projectKLDateSQL = new StringBuffer();
						projectKLDateSQL.append("SELECT TO_CHAR( CASE                                          \n");                     
						projectKLDateSQL.append("                    WHEN LPM.KL-30 > SYSDATE+7 THEN LPM.KL-30   \n");
						projectKLDateSQL.append("                    ELSE SYSDATE+7                              \n");
						projectKLDateSQL.append("                 END ,'YYYY-MM-DD') AS PND_DATE               \n");
						projectKLDateSQL.append("  FROM LPM_NEWPROJECT LPM                                     \n");
						projectKLDateSQL.append(" WHERE LPM.CASENO = '1'                                       \n");
						projectKLDateSQL.append("   AND LPM.PROJECTNO = '"+projectNo+"'                        \n");

						String pndDate_DP_KL = "";

						rsetDP = stmtDP.executeQuery(projectKLDateSQL.toString());
						while(rsetDP.next()){
							pndDate_DP_KL = rsetDP.getString(1) == null ? "" : rsetDP.getString(1);
						}

						if ( rsetDP != null ) rsetDP.close();
						if ( stmtDP != null ) stmtDP.close();						
						DBConnect.closeConnection( connDP );

						if("".equals(pndDate) || pndDate==null)
						{
							pndDate_last = pndDate_DP_KL;
						} else {	
							//설계관리 PND DATE가 SYSDATE+7일 보다 이후 날짜면 사용, 이전 이면 KL-30일 적용, KL-30일도 SYSDATE+7보다 이전이면 SYSDATE+7 사용
							Calendar cal_today = Calendar.getInstance(); 
							Calendar cal_pndDate = Calendar.getInstance(); 

							cal_today.set(Calendar.DAY_OF_YEAR, cal_today.get(Calendar.DAY_OF_YEAR) + 7);  // SYSDATE +7일 대비

							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");   
							cal_pndDate.setTime(formatter.parse(pndDate));
							//System.out.println ("cal_pndDate = "+ cal_pndDate.get ( Calendar.YEAR ) + "-" + ( cal_pndDate.get ( Calendar.MONTH ) + 1 ) + "-" + cal_pndDate.get ( Calendar.DATE ));

							if(cal_pndDate.after(cal_today))
							{
								pndDate_last = pndDate;
							} else {
								pndDate_last = pndDate_DP_KL;
							}
						}
					}else {
						pndDate_last = pndDate_ERP;
					}

				    if("".equals(pndDate_last)){
						resultMsg += "PND Date not exist !!! ";
						throw new Exception("PND Date not exist !!! ");
					}	
					// END : 2012-07-02 Kang seonjung
                    
					/*
                    if("".equals(pndDate_ERP)) 
                    {
                        resultMsg += projectNo + " - "+drawingNo + "  : (Error) PND Date not exist (Tel.1718)"+"\\n";
                        continue;
                    }
					*/

                    String sSEQ = "";
                    String sqQuery = "select STX_STD_PLM_PO_REQUEST_S.NEXTVAL from DUAL";
                    rset = stmt.executeQuery(sqQuery);
                    
                    rset.next();
                    sSEQ = rset.getString("NEXTVAL");                

                   // System.out.println("1. sSEQ = "+sSEQ);
                    StringTokenizer itemCodeListToken = new StringTokenizer(itemCode , ",");  //AA|1,BB|2,CC|1 이런식
                    while(itemCodeListToken.hasMoreTokens())
                    {
                        String tempItemCodeToken = itemCodeListToken.nextToken();

                        StringTokenizer itemCodeToken = new StringTokenizer(tempItemCodeToken , "|");
                        String purchasingName = itemCodeToken.nextToken();
                        String purchasingQty = itemCodeToken.nextToken();
                        String purchasingId = "";
                        String purchasingUOM = "";

                        StringBuffer itemIdSQL = new StringBuffer();
                        itemIdSQL.append("select msib.inventory_item_id, msib.primary_uom_code ");
                        itemIdSQL.append("  from mtl_system_items_b msib ");
                        itemIdSQL.append(" where msib.segment1 = ? ");
                        itemIdSQL.append("   and msib.organization_id = 82");
                        
                        CallableStatement cstmt = jhConn.prepareCall(itemIdSQL.toString());
                        cstmt.setString(1, purchasingName);
                        rset = cstmt.executeQuery();

                        boolean erpExist = false;
                        while(rset.next()){
                            purchasingId = rset.getString(1);
                            purchasingUOM = rset.getString(2);
                            erpExist = true;
                        }
                        
                        if(purchasingId.equals("") && !erpExist){
                            throw new Exception("Not exist Item id in ERP Item Master! - ");
                        }	

						// 2012-10-18 Kang seonjung : Item의 구매담당자 확인 (상선/특수선 구분됨)
						String buyer_id = "";
						CallableStatement cstmt1 = jhConn.prepareCall( "{? = call STX_PO_BUYERID_FN(?,?)}" );      // 호선, ITEM_ID를 인자로 주어 구매담당자 ID를 받아옴.
						cstmt1.registerOutParameter(1, java.sql.Types.VARCHAR);
						cstmt1.setString(2, projectNo);
						cstmt1.setString(3 ,purchasingId);
						cstmt1.execute();

						buyer_id = cstmt1.getString(1)== null ? "" : cstmt1.getString(1) ;
						if ( cstmt != null ) cstmt.close();
						if ( cstmt1 != null ) cstmt1.close();
						// END : 2012-10-18
                
                        StringBuffer prjIdSQL = new StringBuffer();
                        prjIdSQL.append("select ppa.project_id, ppa.attribute2           ");
                        prjIdSQL.append("  from pa_projects_all ppa                      ");
                        prjIdSQL.append(" where ppa.segment1 = '"+projectNo+"'           ");
                        prjIdSQL.append("   and nvl(CLOSED_DATE,sysdate) >= sysdate      ");
                        
                        rset = stmt.executeQuery(prjIdSQL.toString());
                        String projectId = "";
                        String deliver_to_location_id = "";
                        while(rset.next()){
                            projectId = rset.getString(1);
                            deliver_to_location_id = rset.getString(2);
                        }
                        
                        if(projectId.equals("")){
                            resultMsg += "Not exist Project id!";
                            throw new Exception("Not exist Project id!");
                        }
                        
                        StringBuffer personIdSQL = new StringBuffer();
                        personIdSQL.append("select ppf.person_id ");
                        personIdSQL.append("     , fu.user_id ");
                        personIdSQL.append("  from per_people_f ppf ");
                        personIdSQL.append("     , fnd_user fu ");
                        personIdSQL.append(" where ppf.person_id = fu.employee_id ");
                        personIdSQL.append("   and ppf.employee_number = '"+prCreator+"' ");
                        personIdSQL.append("   and ppf.effective_end_date > trunc(sysdate) ");
                        personIdSQL.append("   and nvl(fu.end_date,sysdate) >= trunc(sysdate) ");
                        
                        rset = stmt.executeQuery(personIdSQL.toString());

                        while(rset.next()){
                            personId = rset.getString(1);
                            updatePersonId = rset.getString(2);
                        }
                        
                        if(personId.equals("")){
                            resultMsg += "Not exist Person ID!";
                            throw new Exception("Not exist Person ID!");
                        }
                        
                        StringBuffer deptIdSQL = new StringBuffer();
                        deptIdSQL.append("select attribute1 ");
                        deptIdSQL.append("  from per_people_f ");
                        deptIdSQL.append(" where person_id = "+personId+" ");
                        
                        rset = stmt.executeQuery(deptIdSQL.toString());
                        deptId = "";
                        while(rset.next()){
                            deptId = rset.getString(1);
                        }
                        
                        if(deptId.equals("")){
                            resultMsg += "Not exist Department ID!";
                            throw new Exception("Not exist Department ID!");
                        }
                        
                        
                        //System.out.println(" personId === "+personId);
                        //System.out.println(" updatePersonId === "+updatePersonId);
                        //personId = "2719";
                        //updatePersonId = "4737";
                        

                        StringBuffer jhInsertSQL = new StringBuffer();
                        jhInsertSQL.append("insert into po_requisitions_interface(	last_updated_by, ");
                        jhInsertSQL.append(" 										last_update_date,  ");
                        jhInsertSQL.append(" 										last_update_login,  ");
                        jhInsertSQL.append(" 										creation_date,  ");
                        jhInsertSQL.append(" 										created_by,  ");
                        jhInsertSQL.append(" 										item_id,  ");
                        jhInsertSQL.append(" 										quantity,  ");
                        jhInsertSQL.append(" 										need_by_date,  ");
                        jhInsertSQL.append(" 										interface_source_code,   ");                    
                        jhInsertSQL.append(" 										deliver_to_location_id,    ");                  
                        jhInsertSQL.append(" 										destination_type_code,    ");                   
                        jhInsertSQL.append(" 										preparer_id,    ");
                        jhInsertSQL.append(" 										source_type_code,    ");
                        jhInsertSQL.append(" 										authorization_status, ");
                        jhInsertSQL.append(" 										uom_code, ");
                        jhInsertSQL.append(" 										destination_organization_id, ");
                        jhInsertSQL.append(" 										autosource_flag, ");
                        jhInsertSQL.append(" 										org_id, ");
                        jhInsertSQL.append(" 										project_id, ");
                        jhInsertSQL.append(" 										task_id, ");
                        jhInsertSQL.append(" 										deliver_to_requestor_id, ");
                        jhInsertSQL.append(" 										unit_price, ");
                        jhInsertSQL.append(" 										charge_account_id, ");
                        jhInsertSQL.append(" 										header_description, ");
                        jhInsertSQL.append(" 										batch_id, ");
                        jhInsertSQL.append(" 										header_attribute4, ");
						jhInsertSQL.append(" 										suggested_buyer_id, ");     // 구매담당자 ID
                        jhInsertSQL.append(" 										project_accounting_context )   ");                    
                        jhInsertSQL.append(" 							values(	'"+updatePersonId+"'  ");
                        jhInsertSQL.append(" 									,sysdate   ");
                        jhInsertSQL.append(" 									,-1   ");
                        jhInsertSQL.append(" 									,sysdate   ");
                        jhInsertSQL.append(" 									,'"+updatePersonId+"'   ");
                        jhInsertSQL.append(" 									,?   "); //Item Id
                        jhInsertSQL.append(" 									,?   "); //Quantity
                        jhInsertSQL.append(" 									,to_date('"+pndDate_last+"','yyyy-mm-dd')    ");
                        jhInsertSQL.append(" 									,'TPR'   ");                    
                        jhInsertSQL.append(" 									,DECODE('"+deliver_to_location_id+"','부산',143,141)   ");                    
                        jhInsertSQL.append(" 									,'INVENTORY'   ");                    
                        jhInsertSQL.append(" 									,'"+personId+"'   ");                    
                        jhInsertSQL.append(" 									,'VENDOR'   ");
                        jhInsertSQL.append(" 									,'INCOMPLETE' ");
                        jhInsertSQL.append(" 									,? "); //UOM
                        jhInsertSQL.append(" 									,82 ");
                        jhInsertSQL.append(" 									,'P' ");
                        jhInsertSQL.append(" 									,0 ");
                        jhInsertSQL.append(" 									,? "); //Project Id
                        jhInsertSQL.append(" 									,? "); //Task id
                        jhInsertSQL.append(" 									,'"+personId+"'   ");
                        jhInsertSQL.append(" 									,0   ");
                        jhInsertSQL.append(" 									,1004   ");
                        jhInsertSQL.append("                                    ,?       ");
                        jhInsertSQL.append(" 									,'"+sSEQ+"'   ");                        
                        jhInsertSQL.append(" 									,'"+deptId+"'   ");
						jhInsertSQL.append(" 									,?   ");
                        jhInsertSQL.append(" 									,DECODE('"+projectId+"',NULL,'N','Y') )    ");

                        //System.out.println(" createPR : jhInsertSQL = "+jhInsertSQL.toString());
                       
          
                        CallableStatement jhCs = jhConn.prepareCall(jhInsertSQL.toString());
                        
                    
                        StringBuffer taskIdSQL = new StringBuffer();
                        taskIdSQL.append("SELECT PT.TASK_ID,  ");
                        taskIdSQL.append("       PT.TASK_NUMBER, ");
                        taskIdSQL.append("	     PA.SEGMENT1 AS PROJECT_NUMBER ");
                        taskIdSQL.append("  FROM PA_TASKS  PT, ");
                        taskIdSQL.append("       PA_PROJECTS_ALL PA ");
                        taskIdSQL.append(" WHERE PT.PROJECT_ID  = PA.PROJECT_ID ");
                        taskIdSQL.append("   AND PA.SEGMENT1 = '"+projectNo+"' ");
                        taskIdSQL.append("   AND TASK_NUMBER LIKE '01.01.S000' ");
                                
                        rset = stmt.executeQuery(taskIdSQL.toString());
                        boolean taskFlag = false;
                        String taskId = "";	
                        while(rset.next()){
                            if(taskFlag)
                            {
                                resultMsg += "Exist multi Task Id!";
                                throw new Exception("Exist multi Task Id! - "+projectNo);
                            }
                            taskId = rset.getString(1);
                            taskFlag = true;
                        }
                        
                        if(taskId.equals("")){
                            resultMsg += "Not exist Task id!";
                            throw new Exception("Not exist Task id! - "+projectNo);
                        }
                
                        jhCs.setString(1, purchasingId);
                        jhCs.setDouble(2, Double.parseDouble(purchasingQty));
                        jhCs.setString(3, purchasingUOM);
                        jhCs.setString(4, projectId);
                        jhCs.setString(5, taskId);
                        jhCs.setString(6, mailDescription);   
						jhCs.setString(7, buyer_id); 

                        jhCs.executeUpdate();
                    }

                    jhConn.commit();

                    System.out.println("~ CreatePR : pr commit");
                    
                    //PR Import 호출
                    StringBuffer prImportSQL = new StringBuffer("");
                    prImportSQL.append("{call stx_std_plm_pr_request_proc(? , ? , ? , ? ,p_organization_id=>82 ,p_batch_id=>'"+sSEQ+"',p_user_id=>'"+updatePersonId+"',p_source_type_code=>'TPR')} ");
                    
                    
                    System.out.println("~ CreatePR : pr import start = "+prImportSQL.toString());
                    CallableStatement cs = jhConn.prepareCall(prImportSQL.toString());
                            
                    cs.registerOutParameter(1, 12);
                    cs.registerOutParameter(2, 12);
                    cs.registerOutParameter(3, 12);
                    cs.registerOutParameter(4, 12);
                    cs.execute();
                    
                    retPrNo = cs.getObject(1).toString();
                    retPrId = cs.getObject(2).toString();
                    String retCode = cs.getObject(4).toString();   
                    String retMessage = cs.getObject(3).toString();


                    System.out.println("~ CreatePR : call stx_std_plm_pr_request_proc  :  "+retPrNo);                    
                    System.out.println("retPrNo === "+retPrNo);
                    System.out.println("retPrId === "+retPrId);
                    //System.out.println("retCode === "+retCode);
                    //System.out.println("retMessage === "+retMessage);							
                    if(!retCode.equals("S")){
                        System.out.println("Error Message : "+retMessage);
                        if(!jhConn.getAutoCommit())
                            jhConn.rollback();
                        System.out.println("rollback");
                        resultMsg += "PR Import Procedure Exception! : "+retMessage;
                        throw new Exception("PR Import Procedure Exception : "+retMessage);	
                    }else{
                        if(!jhConn.getAutoCommit()){
                            jhConn.commit();
                        }
                    }
                    
                }catch(Exception eee){
                    System.out.println("~pr rollback");
                    jhConn.rollback();
                    eee.printStackTrace();
                    throw eee;
                }finally{
                }

                stmt1 = conn.createStatement();
               // stmt2 = conn.createStatement();
               // stmt3 = conn.createStatement();

                pstmt1 = conn.prepareStatement(sqlSaveFile1.toString());
                pstmt2 = conn.prepareStatement(sqlSaveFile2.toString());
                pstmt3 = conn.prepareStatement(sqlSaveFile3.toString());
                pstmt4 = conn.prepareStatement(sqlSaveFile4.toString());
                pstmt5 = conn.prepareStatement(sqlSaveFile5.toString());
                pstmt6 = conn.prepareStatement(sqlSaveFile6.toString());


                // 파일명이 있을 경우에만 저장
                if(!"".equals(fileName))
                {
                    File file = new File(sTempDir +  java.io.File.separator + fileName);

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

                    System.out.println(" ===== pr 시퀀스 ==== ");
                    System.out.println(" file_id  =  "+file_id);
                    System.out.println(" document_id  =  "+document_id);
                    System.out.println(" attached_document_id  =  "+attached_document_id);

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
                    finstream = new FileInputStream(file);
                    
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
                    pstmt6.setString(5, retPrId);
                    pstmt6.executeUpdate();
                   // System.out.println("^^ 7. document + file insert ok.......");
                    
                   // DBConnect.commitJDBCTransaction(conn);
                }

                StringBuffer dpInsertSQL = new StringBuffer();
                dpInsertSQL.append("insert into STX_PO_EQUIPMENT_DP(	REQUISITION_HEADER_ID,               \n");
                dpInsertSQL.append(" 									PROJECT_NUMBER,                      \n");
                dpInsertSQL.append(" 									DRAWING_LIST,                        \n");
                dpInsertSQL.append(" 									DRAW_DEPT_CODE,                      \n");
                dpInsertSQL.append(" 									DRAWING_NO,                          \n");
                dpInsertSQL.append(" 									DRAWING_DATE,                        \n");
                dpInsertSQL.append(" 									PR_NO,                               \n");
                dpInsertSQL.append(" 									LAST_UPDATED_DATE,                   \n");
                dpInsertSQL.append(" 									LAST_UPDATED_BY,                     \n");
                dpInsertSQL.append(" 									CREATION_DATE,                       \n");
                dpInsertSQL.append(" 									CREATED_BY,                           \n");
                dpInsertSQL.append(" 									ORIGINAL_PR_FLAG)                    \n");
                dpInsertSQL.append("                     VALUES (       ?                                    \n");
                dpInsertSQL.append("                                   ,?                                    \n");                             
                dpInsertSQL.append("                                   ,?                                    \n");
                dpInsertSQL.append("                                   ,?                                    \n");
                dpInsertSQL.append("                                   ,?                                    \n");
                dpInsertSQL.append("                                   ,to_date('"+drDate+"','yyyy-mm-dd')   \n");
                dpInsertSQL.append("                                   ,?                                    \n");
                dpInsertSQL.append("                                   ,sysdate                              \n");
                dpInsertSQL.append("                                   ,?                                    \n");
                dpInsertSQL.append("                                   ,sysdate                              \n");
                dpInsertSQL.append("                                   ,?                                    \n");
                dpInsertSQL.append("                                   ,'N')                                 \n");
 
                pstmt7 = conn.prepareStatement(dpInsertSQL.toString());
                //System.out.println("dpInsertSQL.toString = "+dpInsertSQL.toString());

                pstmt7.setString(1, retPrId);
                pstmt7.setString(2, projectNo);
                pstmt7.setString(3, drawingTitle);
                pstmt7.setString(4, deptId);
                pstmt7.setString(5, drawingNo);
                pstmt7.setString(6, retPrNo);
                pstmt7.setString(7, updatePersonId);
                pstmt7.setString(8, updatePersonId);
                pstmt7.executeUpdate();

                DBConnect.commitJDBCTransaction(conn);
                System.out.println("~~CreatePR : file save success.......");

                // 조달 pr 담당자, pr 요청자에게 메일 발송  패키지 호출 삭제(조달에서 메일발송 스케쥴로 실행됨)
               // StringBuffer callMail = new StringBuffer("");
               // callMail.append("{call STX_PO_EQUIPMENT_MAIL_PKG.REQUISITION_MAIL('"+retPrId+"')} ");                

               // CallableStatement cs1 = conn.prepareCall(callMail.toString());
               //  cs1.execute();

               resultMsg += projectNo + " - "+drawingNo + "  :  Save Success!"+"\\n";

            }            
            //resultMsg = "Save Success!";  
            System.out.println("~~  CreatePR : commit success.......");
          
        }
        catch (Exception e) {
            DBConnect.rollbackJDBCTransaction(conn);
            System.out.println("~~~~~~~~ ERROR.......");
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
                DBConnect.closeConnection( jhConn );
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }  
    }   

    System.out.println( "~~ CreatePR end :: stxPECEquipItemRegisterCreatePRAddition" );

%>
<script language="javascript">
/*    var urlStr = "stxPECEquipItemRegisterMain_SP.jsp?projectNo=" + parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.projectList.value;
    urlStr += "&deptCode=" + parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.departmentList.value;
    urlStr += "&inputMakerListYN=" + parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader.inputMakerListYN.value;
*/
    var urlStr = "stxPECEquipItemRegisterMain_SP.jsp?projectNo=<%=urlProjectNo%>";
    urlStr += "&deptCode=<%=urlDeptCode%>";
    urlStr += "&inputMakerListYN=<%=urlInputMakerListYN%>";
    urlStr += "&loginID=<%=urlLoginId%>";

    alert("<%=resultMsg%>");
    window.close();
    opener.parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.location = urlStr;
</script>
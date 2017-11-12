package stxship.dis.buyerClass.letterFaxInput.service;

import java.sql.Connection;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.stx.common.interfaces.DBConnect;

import stxship.dis.buyerClass.letterFaxInput.dao.LetterFaxInputDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;

/**
 * @파일명 : LetterFaxInputServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * LetterFaxInput에서 사용되는 서비스
 *     </pre>
 */
@Service("letterFaxInputService")
public class LetterFaxInputServiceImpl extends CommonServiceImpl implements LetterFaxInputService {

	@Resource(name = "letterFaxInputDAO")
	private LetterFaxInputDAO letterFaxInputDAO;

	/** 
	 * @메소드명	: buyerClassLetterFaxProjectInfo
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 프로젝트 정보 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String buyerClassLetterFaxProjectInfo(CommandMap commandMap) throws Exception {
		String project = (String) commandMap.get("project");
		String drawingFlag = (String) commandMap.get("drawingFlag");
		String ownerClass = (String) commandMap.get("ownerClass");
		
		String returnString = "";
		
		String ct = "";
		String sc = "";
		String kl = "";
		String lc = "";
		String dl = "";
		
		String seriesProject = "";
		String masterProject = "";
		String ownerabbr = "";
		String shipSize = "";
		String shipType = "";
		String shipOwner = "";
		String shipClass = "";
		
		String docNum = "";
		Connection conn = null;
		Statement stmt = null;
		String receiverInfo = "";
		try {
			conn = DBConnect.getDBConnection("SDPS");
			stmt = conn.createStatement();
			
			StringBuffer selectDateSQL = new StringBuffer();
			selectDateSQL.append("select TO_CHAR(CONTRACTDATE, 'YYYY-MM-DD')CONTRACTDATE ");
			selectDateSQL.append("  	,TO_CHAR(SC, 'YYYY-MM-DD')CONTRACTDATE ");
			selectDateSQL.append("  	,TO_CHAR(KL, 'YYYY-MM-DD')CONTRACTDATE ");
			selectDateSQL.append("  	,TO_CHAR(LC, 'YYYY-MM-DD')CONTRACTDATE ");
			selectDateSQL.append("  	,TO_CHAR(DL, 'YYYY-MM-DD')CONTRACTDATE ");
			selectDateSQL.append("  	, DWGSERIESPROJECTNO ");
			if("owner".equals(ownerClass))
				selectDateSQL.append("  	, ownerabbr ");
			else if("class".equals(ownerClass))
				selectDateSQL.append("  	, class ");
			selectDateSQL.append("  	, shipsize ");
			selectDateSQL.append("  	, shiptype ");
			selectDateSQL.append("  	, owner ");
			selectDateSQL.append("  	, class ");
			selectDateSQL.append("  from lpm_newproject ");
			selectDateSQL.append(" where projectno = '"+project+"' ");
			selectDateSQL.append("   and caseno = '1' ");
			
			java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
			
			while(selectDateRset.next()){
				
				ct 				= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
				sc 				= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
				kl 				= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
				lc 				= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
				dl 				= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
				masterProject 	= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
				ownerabbr 		= (selectDateRset.getString(7)==null || selectDateRset.getString(7).equals("-"))?"":selectDateRset.getString(7);
				shipSize 		= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
				shipType 		= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
				shipOwner 		= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
				shipClass 		= (selectDateRset.getString(11)==null || selectDateRset.getString(11).equals("-"))?"":selectDateRset.getString(11);
				// class에 - 가 있을 경우 시리얼 딸때 에러가 남...
				
				
				//ct = ct.length()>10?ct.substring(0,10):ct;
				//sc = sc.length()>10?sc.substring(0,10):sc;
				//kl = kl.length()>10?kl.substring(0,10):kl;
				//lc = lc.length()>10?lc.substring(0,10):lc;
				//dl = dl.length()>10?dl.substring(0,10):dl;
			}
			
			StringBuffer selectSeriesSQL = new StringBuffer();
			selectSeriesSQL.append("select b.projectno ");
			selectSeriesSQL.append("  from LPM_NEWPROJECT a ");
			selectSeriesSQL.append("     , LPM_NEWPROJECT b ");
			selectSeriesSQL.append(" where a.CASENO = '1' ");
			selectSeriesSQL.append("   AND b.CASENO = '1' ");
			selectSeriesSQL.append("   AND a.DWGMHYN = 'Y' ");
			selectSeriesSQL.append("   AND b.DWGMHYN = 'Y' ");
			selectSeriesSQL.append("   AND a.projectno = '"+project+"' ");
			selectSeriesSQL.append("   and a.dwgseriesprojectno = b.dwgseriesprojectno ");
			selectSeriesSQL.append(" group by b.projectno ");
			
			java.sql.ResultSet selectSeriesRset = stmt.executeQuery(selectSeriesSQL.toString());
			
			while(selectSeriesRset.next()){
				
				if(seriesProject.equals(""))
					seriesProject = selectSeriesRset.getString(1)==null?"":selectSeriesRset.getString(1);
				else
					seriesProject += ","+(selectSeriesRset.getString(1)==null?"":selectSeriesRset.getString(1));
				
			}
			
			StringBuffer selectDocNumSQL = new StringBuffer();
			selectDocNumSQL.append("select to_char(nvl(max(to_number(substr(ref_no , instr(ref_no , '-' , 1 , 2)+1)))+1,1) , 'FM0000') ");
			selectDocNumSQL.append("  from stx_oc_document_list ");
			//selectDocNumSQL.append(" where project = (SELECT seriesprojectno ");
			//selectDocNumSQL.append("                    FROM LPM_NEWPROJECT a ");
			//selectDocNumSQL.append("                   WHERE a.CASENO = '1' ");
			//selectDocNumSQL.append("                     AND a.projectno = '"+project+"') ");
			//대표호선 기준 시리얼 넘버 부여
			//selectDocNumSQL.append(" where project in (select projectno ");
			//selectDocNumSQL.append("                 	 from lpm_newproject ");
			//selectDocNumSQL.append("                	where caseno = '1' ");
			//selectDocNumSQL.append("                  	  and DWGSERIESPROJECTNO = (SELECT DWGSERIESPROJECTNO ");
			//selectDocNumSQL.append("                      	                          FROM LPM_NEWPROJECT a ");
			//selectDocNumSQL.append("                          	                  	 WHERE a.CASENO = '1' ");
			//selectDocNumSQL.append("                              	                   AND a.projectno = '"+project+"')) ");
			//문서호선 기준 시리얼 넘버 부여
			selectDocNumSQL.append(" where project in (select project ");
			selectDocNumSQL.append("                 	 from stx_oc_project_send_number ");
			selectDocNumSQL.append("                 	where DOC_PROJECT = (SELECT DOC_PROJECT ");
			selectDocNumSQL.append("                 	                       FROM stx_oc_project_send_number a ");
			selectDocNumSQL.append("                 	                      WHERE a.project = '"+project+"')) ");
			selectDocNumSQL.append("   and send_receive_type = 'send' ");
			selectDocNumSQL.append("   and instr(ref_no , '-' , 1 , 2) > 0 ");
			selectDocNumSQL.append("   and owner_class_type = '"+ownerClass+"' ");
			
			java.sql.ResultSet selectDocNumRset = stmt.executeQuery(selectDocNumSQL.toString());
			
			while(selectDocNumRset.next()){
				docNum = selectDocNumRset.getString(1)==null?"":selectDocNumRset.getString(1);
			}
			
			StringBuffer selectReceiverSQL = new StringBuffer();
			selectReceiverSQL.append("select RECEIVE_TYPE , PRIORITY , RECEIVER , FAX ");
			selectReceiverSQL.append("  from stx_oc_project_receive_list ");
			selectReceiverSQL.append(" where project = '"+project+"' ");
			selectReceiverSQL.append("   and drawing_type = '"+("drawing".equals(drawingFlag)?"도면":"비도면")+"' ");
			selectReceiverSQL.append("   and receiver_flag = 'Y' ");
			selectReceiverSQL.append(" order by priority ");
			
			//System.out.println(selectReceiverSQL.toString());
			
			java.sql.ResultSet selectReceiverRset = stmt.executeQuery(selectReceiverSQL.toString());
			
			
			while(selectReceiverRset.next()){
				
				//System.out.println(selectReceiverRset.getString(1));
				//System.out.println(selectReceiverRset.getString(2));
				//System.out.println(selectReceiverRset.getString(3));
				//System.out.println(selectReceiverRset.getString(4));
				
				if(receiverInfo.equals("")){
					receiverInfo =  selectReceiverRset.getString(1)
							+ "," + selectReceiverRset.getString(2)
							+ "," + selectReceiverRset.getString(3)
							+ "," + selectReceiverRset.getString(4)
									;
				}else{
					receiverInfo += "^" + ( selectReceiverRset.getString(1)
									+ "," + selectReceiverRset.getString(2)
									+ "," + selectReceiverRset.getString(3)
									+ "," + selectReceiverRset.getString(4))
									;
				}
			}
			
			if("".equals(receiverInfo) && "noDrawing".equals(drawingFlag)){
				StringBuffer selectReceiverSQL2 = new StringBuffer();
				selectReceiverSQL2.append("select RECEIVE_TYPE , PRIORITY , RECEIVER , FAX ");
				selectReceiverSQL2.append("  from stx_oc_project_receive_list ");
				selectReceiverSQL2.append(" where project = '"+project+"' ");
				selectReceiverSQL2.append("   and drawing_type = '도면' ");
				selectReceiverSQL2.append("   and receiver_flag = 'Y' ");
				selectReceiverSQL2.append(" order by priority ");
				
				//System.out.println(selectReceiverSQL.toString());
				
				java.sql.ResultSet selectReceiverRset2 = stmt.executeQuery(selectReceiverSQL2.toString());
				
				while(selectReceiverRset2.next()){
					
					//System.out.println(selectReceiverRset2.getString(1));
					//System.out.println(selectReceiverRset2.getString(2));
					//System.out.println(selectReceiverRset2.getString(3));
					//System.out.println(selectReceiverRset2.getString(4));
					
					if(receiverInfo.equals("")){
						receiverInfo =  selectReceiverRset2.getString(1)
								+ "," + selectReceiverRset2.getString(2)
								+ "," + selectReceiverRset2.getString(3)
								+ "," + selectReceiverRset2.getString(4)
										;
					}else{
						receiverInfo += "^" + ( selectReceiverRset2.getString(1)
										+ "," + selectReceiverRset2.getString(2)
										+ "," + selectReceiverRset2.getString(3)
										+ "," + selectReceiverRset2.getString(4))
										;
					}
				}
			}
			
			if("".equals(receiverInfo)){
				receiverInfo = ",,,";
			}
		} catch (Exception e) {
			throw e;
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				DBConnect.closeConnection(conn);
			} catch (Exception ex) {
			}
		}
		//System.out.println(ct);
		//System.out.println(sc);
		//System.out.println(kl);
		//System.out.println(lc);
		//System.out.println(dl);
		
		//System.out.println(masterProject);
		
		//System.out.println(seriesProject);
		
		//System.out.println(ownerabbr);
		
		//System.out.println(shipSize+","+shipType+","+shipOwner+","+shipClass);
		
		returnString = ct +"|"+ sc +"|"+ kl +"|"+ lc +"|"+ dl +"|"+ masterProject +"|"+ seriesProject +"|"+ ownerabbr +"|"+ shipSize+" "+shipType +"|"+ shipOwner +"|"+ shipClass +"|"+ docNum +"|"+ receiverInfo;
		//System.out.println(returnString);
		return returnString;
	}

	/** 
	 * @메소드명	: buyerClassLetterFaxSerialCodeCheck
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 발신문서 번호 체크하여 사용중인 발신문서인경우 새로운 발신문서를 받아온다.
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String buyerClassLetterFaxSerialCodeCheck(CommandMap commandMap) throws Exception {
		String project = (String) commandMap.get("project");
		String ownerClass = (String) commandMap.get("ownerClass");
		
		String returnString = "";
		
		String docNum = "";
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		
		StringBuffer selectDocNumSQL = new StringBuffer();
		selectDocNumSQL.append("select to_char(nvl(max(to_number(substr(ref_no , instr(ref_no , '-' , 1 , 2)+1)))+1,1) , 'FM0000') ");
		selectDocNumSQL.append("  from stx_oc_document_list ");
		//selectDocNumSQL.append(" where project = (SELECT seriesprojectno ");
		//selectDocNumSQL.append("                    FROM LPM_NEWPROJECT a ");
		//selectDocNumSQL.append("                   WHERE a.CASENO = '1' ");
		//selectDocNumSQL.append("                     AND a.projectno = '"+project+"') ");
		//대표호선 기준 시리얼 넘버 부여
		//selectDocNumSQL.append(" where project in (select projectno ");
		//selectDocNumSQL.append("                 	 from lpm_newproject ");
		//selectDocNumSQL.append("                	where caseno = '1' ");
		//selectDocNumSQL.append("                  	  and DWGSERIESPROJECTNO = (SELECT DWGSERIESPROJECTNO ");
		//selectDocNumSQL.append("                      	                          FROM LPM_NEWPROJECT a ");
		//selectDocNumSQL.append("                          	                  	 WHERE a.CASENO = '1' ");
		//selectDocNumSQL.append("                              	                   AND a.projectno = '"+project+"')) ");
		//문서호선 기준 시리얼 넘버 부여
		selectDocNumSQL.append(" where project in (select project ");
		selectDocNumSQL.append("                 	 from stx_oc_project_send_number ");
		selectDocNumSQL.append("                 	where DOC_PROJECT = (SELECT DOC_PROJECT ");
		selectDocNumSQL.append("                 	                       FROM stx_oc_project_send_number a ");
		selectDocNumSQL.append("                 	                      WHERE a.project = '"+project+"')) ");
		selectDocNumSQL.append("   and send_receive_type = 'send' ");
		selectDocNumSQL.append("   and instr(ref_no , '-' , 1 , 2) > 0 ");
		selectDocNumSQL.append("   and owner_class_type = '"+ownerClass+"' ");
		
		java.sql.Statement stmt = conn.createStatement();
		java.sql.ResultSet selectDocNumRset = stmt.executeQuery(selectDocNumSQL.toString());
		
		while(selectDocNumRset.next()){
			docNum = selectDocNumRset.getString(1)==null?"":selectDocNumRset.getString(1);
		}
		try {
			if (stmt != null)
				stmt.close();
			DBConnect.closeConnection(conn);
		} catch (Exception ex) {
		}
		returnString = docNum;
		
		return returnString;
	}

	
	/** 
	 * @메소드명	: buyerClassLetterFaxDocumentSaveProcess
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 승인 업무 확정
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> buyerClassLetterFaxDocumentSaveProcess(CommandMap commandMap) throws Exception {
		try{
			String project 				= DisStringUtil.nullString(commandMap.get("project"));
			String sendReceiveType 		= DisStringUtil.nullString(commandMap.get("sendReceiveType"));
			String docType 				= DisStringUtil.nullString(commandMap.get("docType"));
			String refNo 				= DisStringUtil.nullString(commandMap.get("refNo"));
			String revNo 				= DisStringUtil.nullString(commandMap.get("revNo"));
			String subject 				= DisStringUtil.nullString(commandMap.get("subject"));
			String sender 				= DisStringUtil.nullString(commandMap.get("sender"));	
			/*Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
			String senderNo = (String)loginUser.get("user_id");		*/
			/*String senderNo = (String)commandMap.get(DisConstants.SET_DB_LOGIN_ID);*/
			String senderNo				= DisStringUtil.nullString(commandMap.get("senderNo"));
			String sendReceiveDate		= DisStringUtil.nullString(commandMap.get("sendReceiveDate"));
			String sendReceiveDept		= DisStringUtil.nullString(commandMap.get("sendReceiveDept"));
			String refDept				= DisStringUtil.nullString(commandMap.get("refDept"));
			String keyword				= DisStringUtil.nullString(commandMap.get("keyword"));
			String viewAccess			= DisStringUtil.nullString(commandMap.get("viewAccess"));
			
			String objectType			= DisStringUtil.nullString(commandMap.get("objectType"));
			String objectNo				= DisStringUtil.nullString(commandMap.get("objectNo"));
			String objectComment		= DisStringUtil.nullString(commandMap.get("objectComment"));
			
			String mode 				= DisStringUtil.nullString(commandMap.get("mode"));
			
			String dwgAppSubmit			= DisStringUtil.nullString(commandMap.get("dwgAppSubmit"));
			String ownerClassType		= DisStringUtil.nullString(commandMap.get("ownerClassType"));
			
			Connection conn = DBConnect.getDBConnection("SDPS");
			conn.setAutoCommit(false);

			if("doc".equals(mode)){
				StringBuffer docInsertQuery = new StringBuffer();
				docInsertQuery.append("insert into stx_oc_document_list( ");
				docInsertQuery.append("	project, ");
				docInsertQuery.append("	owner_class_type, ");
				docInsertQuery.append("	send_receive_type, ");
				docInsertQuery.append("	doc_type, ");
				docInsertQuery.append("	ref_no, ");
				docInsertQuery.append("	rev_no, ");
				docInsertQuery.append("	subject, ");
				docInsertQuery.append("	sender, ");
				docInsertQuery.append("	sender_no, ");
				docInsertQuery.append("	send_receive_date, ");
				docInsertQuery.append("	send_receive_dept, ");
				docInsertQuery.append("	ref_dept, ");
				docInsertQuery.append("	keyword, ");
				docInsertQuery.append("	view_access)");
				docInsertQuery.append("VALUES (");
				docInsertQuery.append("	'"+project+"', "); 
				docInsertQuery.append("	'"+ownerClassType+"', ");
				docInsertQuery.append("	'"+sendReceiveType+"', ");
				docInsertQuery.append("	'"+docType+"', ");
				docInsertQuery.append("	'"+refNo+"', ");
				docInsertQuery.append("	'"+revNo+"', ");
				docInsertQuery.append("	?, ");
				docInsertQuery.append("	'"+sender+"', ");
				docInsertQuery.append("	'"+senderNo+"', ");
				docInsertQuery.append("	sysdate, ");
				docInsertQuery.append("	'"+sendReceiveDept+"', ");
				docInsertQuery.append("	'"+refDept+"', ");
				docInsertQuery.append("	?, ");
				docInsertQuery.append("	'"+viewAccess+"' ) ");
				
				java.sql.CallableStatement docInsertCstmt = conn.prepareCall(docInsertQuery.toString());
		      	
				docInsertCstmt.setString(1, subject);
				docInsertCstmt.setString(2, keyword);
		      	
				docInsertCstmt.executeUpdate();
				
				//Statement stmt = conn.createStatement();
				//stmt.executeQuery(docInsertQuery.toString());
				
				conn.commit();
				
				if(docInsertCstmt!=null)
					docInsertCstmt.close();
				if(conn!=null)
					conn.close();
			}else if("receivemanagerdoc".equals(mode)){

			 
				StringBuffer docInsertQuery = new StringBuffer();
				StringBuffer docInsertQuery1 = new StringBuffer();

				// 2012-08-13 Kang seonjung : 수신문서 저장 table 수정
				docInsertQuery.append("insert into STX_OC_RECEIVE_DOCUMENT( ");
				docInsertQuery.append("	SEQ_NO, ");
				docInsertQuery.append("	project, ");
				docInsertQuery.append("	owner_class_type, ");
				docInsertQuery.append("	send_receive_type, ");
				docInsertQuery.append("	doc_type, ");
				docInsertQuery.append("	ref_no, ");
				docInsertQuery.append("	rev_no, ");
				docInsertQuery.append("	subject, ");
				docInsertQuery.append("	sender, ");
				docInsertQuery.append("	sender_no, ");
				docInsertQuery.append("	send_receive_date, ");
				docInsertQuery.append("	send_receive_dept, ");
				docInsertQuery.append("	ref_dept, ");
				docInsertQuery.append("	keyword, ");
				docInsertQuery.append("	view_access)");
				docInsertQuery.append("VALUES (");
				docInsertQuery.append("	STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL, "); 
				docInsertQuery.append("	'"+project+"', "); 
				docInsertQuery.append("	'"+ownerClassType+"', ");
				docInsertQuery.append("	'"+sendReceiveType+"', ");
				docInsertQuery.append("	'"+docType+"', ");
				docInsertQuery.append("	'"+refNo+"', ");
				docInsertQuery.append("	'"+revNo+"', ");
				docInsertQuery.append("	?, ");
				docInsertQuery.append("	'"+sender+"', ");
				docInsertQuery.append("	'"+senderNo+"', ");
				docInsertQuery.append("	to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), ");
				docInsertQuery.append("	?, ");
				docInsertQuery.append("	'"+refDept+"', ");
				docInsertQuery.append("	?, ");
				docInsertQuery.append("	'"+viewAccess+"' ) ");


				// 기존 수발신 문서 저장 table에도 수신문서 저장해줌..
				docInsertQuery1.append("insert into stx_oc_document_list( ");
				docInsertQuery1.append("	project, ");
				docInsertQuery1.append("	owner_class_type, ");
				docInsertQuery1.append("	send_receive_type, ");
				docInsertQuery1.append("	doc_type, ");
				docInsertQuery1.append("	ref_no, ");
				docInsertQuery1.append("	rev_no, ");
				docInsertQuery1.append("	subject, ");
				docInsertQuery1.append("	sender, ");
				docInsertQuery1.append("	sender_no, ");
				docInsertQuery1.append("	send_receive_date, ");
				docInsertQuery1.append("	send_receive_dept, ");
				docInsertQuery1.append("	ref_dept, ");
				docInsertQuery1.append("	keyword, ");
				docInsertQuery1.append("	view_access)");
				docInsertQuery1.append("VALUES (");
				docInsertQuery1.append("	'"+project+"', ");                                     // project             
				docInsertQuery1.append("	'"+ownerClassType+"', ");							   // owner_class_type    
				docInsertQuery1.append("	'"+sendReceiveType+"', ");							   // send_receive_type   
				docInsertQuery1.append("	'"+docType+"', ");									   // doc_type            
				docInsertQuery1.append("	'"+refNo+"', ");									   // ref_no              
				docInsertQuery1.append("	'"+revNo+"', ");									   // rev_no              
				docInsertQuery1.append("	?, ");												   // subject             
				docInsertQuery1.append("	'"+sender+"', ");									   // sender              
				docInsertQuery1.append("	'"+senderNo+"', ");									   // senderNo
				docInsertQuery1.append("	to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), ");	   // send_receive_date   
				docInsertQuery1.append("	?, ");												   // send_receive_dept   
				docInsertQuery1.append("	'"+refDept+"', ");									   // ref_dept            
				docInsertQuery1.append("	?, ");												   // keyword             
				docInsertQuery1.append("	'"+viewAccess+"' ) ");								   // view_access        

				
				java.sql.PreparedStatement docInsertCstmt = conn.prepareStatement(docInsertQuery.toString());
				java.sql.PreparedStatement docInsertCstmt1 = conn.prepareStatement(docInsertQuery1.toString());

				//System.out.println("########  sendReceiveDept  =  "+sendReceiveDept);

				// 2012-08-18 Kang seonjung : 수신부서가 여러개일 경우 부서별로 나눠서 insert해줌.
				StringTokenizer sToken = new StringTokenizer(sendReceiveDept,",");
				while(sToken.hasMoreTokens()){
					String tempSendReceiveDept = sToken.nextToken();
					String tempSendReceiveDeptTrim = tempSendReceiveDept.trim();

					if("".equals(tempSendReceiveDeptTrim)) continue;
		      	
					docInsertCstmt.setString(1, subject);
					docInsertCstmt.setString(2, tempSendReceiveDeptTrim);
					docInsertCstmt.setString(3, keyword);
					
					docInsertCstmt.executeUpdate();
				}


				// 기존 수발신 문서 저장 table에도 수신문서 저장해줌..		
				docInsertCstmt1.setString(1, subject);
				docInsertCstmt1.setString(2, sendReceiveDept);
				docInsertCstmt1.setString(3, keyword);
				
				docInsertCstmt1.executeUpdate();

				conn.commit();
				
				if(docInsertCstmt!=null)
					docInsertCstmt.close();
				if(docInsertCstmt1!=null)
					docInsertCstmt1.close();
				if(conn!=null)
					conn.close();
			}else if("refdoc".equals(mode)){
				StringBuffer docInsertQuery = new StringBuffer();
				docInsertQuery.append("insert into stx_oc_ref_object( ");
				docInsertQuery.append("	project, ");
				docInsertQuery.append("	ref_no, ");
				docInsertQuery.append("	object_type, ");
				docInsertQuery.append("	object_no, ");
				docInsertQuery.append("	object_comment)");
				docInsertQuery.append("VALUES (");
				docInsertQuery.append("	'"+project+"', "); 
				if("receive".equals(sendReceiveType)){
					docInsertQuery.append("	'"+revNo+"', ");
				}else{
					docInsertQuery.append("	'"+refNo+"', ");
				}
				docInsertQuery.append("	'"+objectType+"', ");
				docInsertQuery.append("	'"+objectNo+"', ");
				docInsertQuery.append("	'"+objectComment+"') ");
				
				//System.out.println(docInsertQuery.toString());
				
				Statement stmt = conn.createStatement();
				stmt.executeQuery(docInsertQuery.toString());
				
				conn.commit();

				//System.out.println("objectType = "+objectType);
				//System.out.println("dwgAppSubmit = "+dwgAppSubmit);
				//System.out.println("ownerClassType = "+ownerClassType);
				// 관련도면등록이고 App. Submit 값이 있고 checked인 경우(Letter/Fax Status Input 화면에서 Call 된 경우만 해당됨) DP공정실적을 업데이트
				if ("drawing".equals(objectType) && "true".equals(dwgAppSubmit))
		        {
		            StringBuffer sbSql = new StringBuffer();
		            // 선주승인 발송문서 등록인 경우 - 기본도: 선주승인발송(OW Start) / Maker도면: 선주승인발송(CL Start)
		            if ("owner".equals(ownerClassType))
		            {
		            	sbSql.append("UPDATE PLM_ACTIVITY \n");
		            	if(sendReceiveDate != null && !sendReceiveDate.equals("") && !sendReceiveDate.equals("null") && !sendReceiveDate.equals("undefine"))
		           		{
		           			sbSql.append("   SET ACTUALSTARTDATE = to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), \n");
		           		} else {
		           			sbSql.append("   SET ACTUALSTARTDATE = TRUNC(SYSDATE), \n");
		           		}
		            	sbSql.append("       ATTRIBUTE4 = 'LETTER/FAX' \n");
		            	sbSql.append(" WHERE 1 = 1   \n");
		            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
		            	sbSql.append("   AND (    (DWGCATEGORY = 'B' AND DWGTYPE <> 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'OW') OR \n");
		            	sbSql.append("            (DWGCATEGORY = 'B' AND DWGTYPE = 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'CL') \n");
		            	sbSql.append("       ) \n");
		            	sbSql.append("   AND ACTUALSTARTDATE IS NULL   \n");
		            }
		            else if ("class".equals(ownerClassType))
		            {
		            	sbSql.append("UPDATE PLM_ACTIVITY \n");
		            	if(sendReceiveDate != null && !sendReceiveDate.equals("") && !sendReceiveDate.equals("null") && !sendReceiveDate.equals("undefine"))
		           		{
		           			sbSql.append("   SET ACTUALSTARTDATE = to_date('"+sendReceiveDate+"' , 'yyyy-mm-dd'), \n");
		           		} else {
		           			sbSql.append("   SET ACTUALSTARTDATE = TRUNC(SYSDATE), \n");
		           		}
		            	sbSql.append("       ATTRIBUTE4 = 'LETTER/FAX' \n");
		            	sbSql.append(" WHERE 1 = 1 \n");
		            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
		            	sbSql.append("   AND DWGCATEGORY = 'B' \n");
		            	sbSql.append("   AND DWGTYPE <> 'V' \n");
		            	sbSql.append("   AND ACTIVITYCODE = '" + objectNo + "' || 'CL' \n");
		            	sbSql.append("   AND ACTUALSTARTDATE IS NULL \n");
		            }
					
					java.sql.Statement stmt2 = null;
					try 
		            {
						stmt2 = conn.createStatement();
						stmt2.executeUpdate(sbSql.toString());				
						conn.commit();
					} 
		            finally 
		            {
						if (stmt2 != null) stmt2.close();
					}
				}
				
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
				
			}else if("keyword".equals(mode)){
				StringBuffer docUpdateQuery = new StringBuffer();
				docUpdateQuery.append("update stx_oc_document_list ");
				docUpdateQuery.append("	  set keyword = '"+keyword+"' ");
				if("send".equals(sendReceiveType)){
					docUpdateQuery.append("	where ref_no = '"+refNo+"' ");
				}else if("receive".equals(sendReceiveType)){
					docUpdateQuery.append("	where rev_no = '"+revNo+"' ");
				}else{
					docUpdateQuery.append("	where 1=2 ");
				}
				
				Statement stmt = conn.createStatement();
				stmt.executeQuery(docUpdateQuery.toString());
				
				conn.commit();
				
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
			}else if("subject".equals(mode)){
				StringBuffer docUpdateQuery = new StringBuffer();
				docUpdateQuery.append("update stx_oc_document_list ");
				docUpdateQuery.append("	  set subject = '"+subject+"' ");
				if("send".equals(sendReceiveType)){
					docUpdateQuery.append("	where ref_no = '"+refNo+"' ");
				}else if("receive".equals(sendReceiveType)){
					docUpdateQuery.append("	where rev_no = '"+revNo+"' ");
				}else{
					docUpdateQuery.append("	where 1=2 ");
				}
				
				Statement stmt = conn.createStatement();
				stmt.executeQuery(docUpdateQuery.toString());
				
				conn.commit();
				
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
			}else if("deleteObject".equals(mode)){
				StringBuffer objDeleteQuery = new StringBuffer();
				objDeleteQuery.append("delete ");
				objDeleteQuery.append("	 from stx_oc_ref_object ");
				
				boolean isDelete = false;
				
				if("send".equals(sendReceiveType)){
					objDeleteQuery.append("	where ref_no = '"+refNo+"' ");
					isDelete = true;
				}else if("receive".equals(sendReceiveType)){
					objDeleteQuery.append("	where rev_no = '"+revNo+"' ");
					isDelete = true;
				}else{
					objDeleteQuery.append("	where 1=2 ");
				}
				objDeleteQuery.append("	  and object_no = '"+objectNo+"' ");
				
				
				Statement stmt = null;
				Statement stmt2 = null;
				try{
					stmt = conn.createStatement();
					stmt.executeQuery(objDeleteQuery.toString());
					
					if ("drawing".equals(objectType) && isDelete)
			        {
			            StringBuffer sbSql = new StringBuffer();
			            // 선주승인 발송문서 등록인 경우 - 기본도: 선주승인발송(OW Start) / Maker도면: 선주승인발송(CL Start)
			            if ("owner".equals(ownerClassType))
			            {
			            	sbSql.append("UPDATE PLM_ACTIVITY T\n");
			            	sbSql.append("   SET ACTUALSTARTDATE = '', \n");
			            	sbSql.append("       ATTRIBUTE4 = '' \n");
			            	sbSql.append(" WHERE 1 = 1   \n");
			            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
			            	sbSql.append("   AND (    (DWGCATEGORY = 'B' AND DWGTYPE <> 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'OW') OR \n");
			            	sbSql.append("            (DWGCATEGORY = 'B' AND DWGTYPE = 'V' AND ACTIVITYCODE = '" + objectNo + "' || 'CL') \n");
			            	sbSql.append("       ) \n");
			            	sbSql.append("	 AND PROJECTNO not in (SELECT SORO2.Project\n");
			            	sbSql.append("	         				 FROM STX_OC_REF_OBJECT SORO2 \n");
			            	sbSql.append("	         				WHERE SORO2.PROJECT = T.PROJECTNO \n");
			            	sbSql.append("	          				  AND SUBSTR(T.ACTIVITYCODE,1,8) = SORO2.OBJECT_NO )\n");
			            	stmt2 = conn.createStatement();
							stmt2.executeUpdate(sbSql.toString());	
			            }
			            else if ("class".equals(ownerClassType))
			            {
			            	sbSql.append("UPDATE PLM_ACTIVITY T\n");
			            	sbSql.append("   SET ACTUALSTARTDATE = '', \n");
			            	sbSql.append("       ATTRIBUTE4 = '' \n");
			            	sbSql.append(" WHERE 1 = 1 \n");
			            	sbSql.append("   AND PROJECTNO = '" + project + "' \n");
			            	sbSql.append("   AND DWGCATEGORY = 'B' \n");
			            	sbSql.append("   AND DWGTYPE <> 'V' \n");
			            	sbSql.append("   AND ACTIVITYCODE = '" + objectNo + "' || 'CL' \n");
			            	sbSql.append("	 AND PROJECTNO not in (SELECT SORO2.Project\n");
			            	sbSql.append("	         				 FROM STX_OC_REF_OBJECT SORO2 \n");
			            	sbSql.append("	         				WHERE SORO2.PROJECT = T.PROJECTNO \n");
			            	sbSql.append("	          				  AND SUBSTR(T.ACTIVITYCODE,1,8) = SORO2.OBJECT_NO )\n");
			            	stmt2 = conn.createStatement();
							stmt2.executeUpdate(sbSql.toString());	
			            }
					}
					conn.commit();
				} catch (Exception e)
				{
					e.printStackTrace();
					conn.rollback();
				} finally {
					if(stmt!=null)
						stmt.close();
					if(stmt2!=null)
						stmt2.close();
					if(conn!=null)
						conn.close();
				}
			}else if("modDoc".equals(mode)){
				StringBuffer docUpdateQuery = new StringBuffer();
				docUpdateQuery.append("update stx_oc_document_list ");
				
				if("send".equals(sendReceiveType)){
					//Subject
					docUpdateQuery.append("	  set subject = '"+subject+"' ");
					docUpdateQuery.append("	where ref_no = '"+refNo+"' ");
					
				}else if("receive".equals(sendReceiveType)){
					//Ref No , Subject , SendReceiveDept , RefDept
					docUpdateQuery.append("	  set subject = '"+subject+"' ");
					docUpdateQuery.append("	    , ref_no = '"+refNo+"' ");
					docUpdateQuery.append("	    , send_receive_dept = '"+sendReceiveDept+"' ");
					docUpdateQuery.append("	    , ref_dept = '"+refDept+"' ");
					docUpdateQuery.append("	where rev_no = '"+revNo+"' ");
					
				}
				
				Statement stmt = conn.createStatement();
				stmt.executeQuery(docUpdateQuery.toString());
				
				conn.commit();
				
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
			}
		}catch(Exception e){
			e.printStackTrace();
			throw e;
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/** 
	 * @메소드명	: buyerClassLetterFaxDrawingInfo
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 참조 도면 정보 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String buyerClassLetterFaxDrawingInfo(CommandMap commandMap) throws Exception {
		String project = (String) commandMap.get("project");
		String drawing = (String) commandMap.get("drawing");
		
		String returnString = "";
		
		String projectNo		= "";
		String drawingNo		= "";
		String drawingTitle		= "";
		String drawingRev		= "";
		String drawingPlanStart = "";
		String drawingPlanFinish= "";
		String drawingActStart	= "";
		String drawingActFinish	= "";
		String ownerPlanStart	= "";
		String ownerPlanFinish	= "";
		String ownerActStart	= "";
		String ownerActFinish	= "";
		String classPlanStart	= "";
		String classPlanFinish	= "";
		String classActStart	= "";
		String classActFinish	= "";

		boolean makerDrawing = false;

		if(!("".equals(drawing) || drawing==null))
		{
			if(drawing.startsWith("V"))
			{
				makerDrawing = true;
			}
		}	
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		Statement stmt = conn.createStatement();
		
		StringBuffer selectDateSQL = new StringBuffer();
		selectDateSQL.append("SELECT DW.PROJECTNO, ");
		selectDateSQL.append("    SUBSTR(DW.ACTIVITYCODE, 1, 8) AS DWGCODE, ");
		selectDateSQL.append("    DW.DWGTITLE, ");
		selectDateSQL.append("    CASE WHEN (HC.DEPLOY_DATE IS NULL) THEN NULL ");
		selectDateSQL.append("         ELSE (F_GET_HARDCOPY_MAX_REV(DW.PROJECTNO, SUBSTR(DW.ACTIVITYCODE, 1, 8), HC.DEPLOY_DATE)) ");
		selectDateSQL.append("    END AS MAX_REVISION, ");

	// 2012-10-10 : V ·Î ½ÃÀÛÇÏ´Â µµ¸é (Maker Drawing) ÀÏ °æ¿ì ÀÏÀÚ °¡Á®¿À´Â ºÎºÐÀÌ Æ²·ÁÁü.  (ÁÖ¼®Àº DP °øÁ¤Á¶È¸ »ó º¸¿©Áö´Â ¸íÄªÀÓ)
	if(makerDrawing)
	{
		selectDateSQL.append("    TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");         // PurchasingRequest Plan
		selectDateSQL.append("    TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");         // PurchasingOrder Plan
		selectDateSQL.append("    TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S, ");        // PurchasingRequest Action
		selectDateSQL.append("    TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_F, ");        // PurchasingOrder Action
		selectDateSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S, ");         // OwnerApp.Submit Plan  
		selectDateSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F, ");        // OwnerApp.Receive Plan
		selectDateSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S, ");        // OwnerApp.Submit Action
		selectDateSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F, ");       // OwnerApp.Receive Action
		selectDateSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S, ");         // OwnerApp.Submit Plan    (Maker DrawingÀº Owner Á¤º¸¸¸ Á¸ÀçÇÔ)
		selectDateSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F, ");        // OwnerApp.Receive Plan   (Maker DrawingÀº Owner Á¤º¸¸¸ Á¸ÀçÇÔ)
		selectDateSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S, ");        // OwnerApp.Submit Action  (Maker DrawingÀº Owner Á¤º¸¸¸ Á¸ÀçÇÔ)
		selectDateSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F ");        // OwnerApp.Receive Action (Maker DrawingÀº Owner Á¤º¸¸¸ Á¸ÀçÇÔ)
	} else {
		selectDateSQL.append("    TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S, ");         // DrawingStart Plan   
		selectDateSQL.append("    TO_CHAR(DW.PLANFINISHDATE, 'YYYY-MM-DD') AS DW_PLAN_F, ");        // DrawingFinish Plan
		selectDateSQL.append("    TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S, ");        // DrawingStart Action
		selectDateSQL.append("    TO_CHAR(DW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS DW_ACT_F, ");       // DrawingFinish Action
		selectDateSQL.append("    TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S, ");         // OwnerApp.Submit Plan
		selectDateSQL.append("    TO_CHAR(OW.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F, ");        // OwnerApp.Receive Plan
		selectDateSQL.append("    TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S, ");        // OwnerApp.Submit Action
		selectDateSQL.append("    TO_CHAR(OW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F, ");       // OwnerApp.Receive Action
		selectDateSQL.append("    TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S, ");         // ClassApp.Submit Plan
		selectDateSQL.append("    TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F, ");        // ClassApp.Receive Plan
		selectDateSQL.append("    TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S, ");        // ClassApp.Submit Action
		selectDateSQL.append("    TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F ");        // ClassApp.Receive Action
	}
		selectDateSQL.append("  FROM PLM_ACTIVITY DW, ");
		selectDateSQL.append("    DCC_DWGDEPTCODE DEPT, ");
		selectDateSQL.append("    (SELECT A.PROJECTNO, A.ACTIVITYCODE, A.PLANSTARTDATE, A.PLANFINISHDATE, ");
		selectDateSQL.append("            A.ACTUALSTARTDATE, A.ACTUALFINISHDATE, A.DWGCATEGORY ");
		selectDateSQL.append("       FROM PLM_ACTIVITY A ");
		selectDateSQL.append("      WHERE A.WORKTYPE = 'OW' ");
		selectDateSQL.append("    ) OW, ");
		selectDateSQL.append("    (SELECT B.PROJECTNO, B.ACTIVITYCODE, B.PLANSTARTDATE, B.PLANFINISHDATE, ");
		selectDateSQL.append("            B.ACTUALSTARTDATE, B.ACTUALFINISHDATE, B.DWGCATEGORY ");
		selectDateSQL.append("       FROM PLM_ACTIVITY B ");
		selectDateSQL.append("      WHERE B.WORKTYPE = 'CL' ");
		selectDateSQL.append("    ) CL, ");
		selectDateSQL.append("    (SELECT C.PROJECTNO, C.ACTIVITYCODE, C.PLANSTARTDATE, C.PLANFINISHDATE, ");
		selectDateSQL.append("            C.ACTUALSTARTDATE, C.ACTUALFINISHDATE, C.DWGCATEGORY ");
		selectDateSQL.append("       FROM PLM_ACTIVITY C ");
		selectDateSQL.append("      WHERE C.WORKTYPE = 'RF' ");
		selectDateSQL.append("    ) RF, ");
		selectDateSQL.append("    (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.PLANFINISHDATE, ");
		selectDateSQL.append("            D.ACTUALSTARTDATE, D.ACTUALFINISHDATE, D.DWGCATEGORY, D.REFEVENT2 ");
		selectDateSQL.append("       FROM PLM_ACTIVITY D ");
		selectDateSQL.append("      WHERE D.WORKTYPE = 'WK' ");
		selectDateSQL.append("    ) WK, ");
		selectDateSQL.append("    ( ");
		selectDateSQL.append("    SELECT PROJECT_NO, DWG_CODE, MAX(REQUEST_DATE) AS DEPLOY_DATE ");
		selectDateSQL.append("      FROM PLM_HARDCOPY_DWG ");
		selectDateSQL.append("     GROUP BY PROJECT_NO, DWG_CODE ");
		selectDateSQL.append("    ) HC, ");
		selectDateSQL.append("    (SELECT STATE FROM PLM_SEARCHABLE_PROJECT ");
		selectDateSQL.append("      WHERE CATEGORY = 'PROGRESS' AND PROJECTNO = '"+project+"' ");
		selectDateSQL.append("    ) PP ");
		selectDateSQL.append(" WHERE DW.PROJECTNO = '"+project+"' ");
		selectDateSQL.append("   AND DW.PROJECTNO = OW.PROJECTNO(+) ");
		selectDateSQL.append("   AND DW.PROJECTNO = CL.PROJECTNO(+) ");
		selectDateSQL.append("   AND DW.PROJECTNO = RF.PROJECTNO(+) ");
		selectDateSQL.append("   AND DW.PROJECTNO = WK.PROJECTNO(+) ");
		selectDateSQL.append("   AND DW.DWGDEPTCODE = DEPT.DWGDEPTCODE(+) ");
		selectDateSQL.append("   AND DW.WORKTYPE = 'DW' ");
		selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(OW.ACTIVITYCODE(+), 1, 8) ");
		selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(CL.ACTIVITYCODE(+), 1, 8) ");
		selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(RF.ACTIVITYCODE(+), 1, 8) ");
		selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8) ");
		selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) like '"+drawing+"' ");
		/*selectDateSQL.append("   AND (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE DW.DWGCATEGORY END) = ");
		selectDateSQL.append("       (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE PP.STATE END) ");*/
		selectDateSQL.append("   AND DW.PROJECTNO = HC.PROJECT_NO(+) ");
		selectDateSQL.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = HC.DWG_CODE(+) ");
		System.out.println(selectDateSQL.toString());
		java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
		
		while(selectDateRset.next()){
			
			projectNo			= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
			drawingNo			= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
			drawingTitle		= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
			drawingRev			= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
			drawingPlanStart 	= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
			drawingPlanFinish	= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
			drawingActStart		= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
			drawingActFinish	= selectDateRset.getString(8)==null?"":selectDateRset.getString(8);
			ownerPlanStart		= selectDateRset.getString(9)==null?"":selectDateRset.getString(9);
			ownerPlanFinish		= selectDateRset.getString(10)==null?"":selectDateRset.getString(10);
			ownerActStart		= selectDateRset.getString(11)==null?"":selectDateRset.getString(11);
			ownerActFinish		= selectDateRset.getString(12)==null?"":selectDateRset.getString(12);
			classPlanStart		= selectDateRset.getString(13)==null?"":selectDateRset.getString(13);
			classPlanFinish		= selectDateRset.getString(14)==null?"":selectDateRset.getString(14);
			classActStart		= selectDateRset.getString(15)==null?"":selectDateRset.getString(15);
			classActFinish		= selectDateRset.getString(16)==null?"":selectDateRset.getString(16);
		}
		
		//System.out.println(projectNo);
		//System.out.println(drawingNo);
		//System.out.println(drawingTitle);
		//System.out.println(drawingRev);
		//System.out.println(drawingPlanStart);
		//System.out.println(drawingPlanFinish);
		//System.out.println(drawingActStart);
		//System.out.println(drawingActFinish);
		//System.out.println(ownerPlanStart);
		//System.out.println(ownerPlanFinish);
		//System.out.println(ownerActStart);
		//System.out.println(ownerActFinish);
		//System.out.println(classPlanStart);
		//System.out.println(classPlanFinish);
		//System.out.println(classActStart);
		//System.out.println(classActFinish);
		
		returnString = projectNo 
				 +"|"+ drawingNo 
				 +"|"+ drawingTitle 
				 +"|"+ drawingRev 
				 +"|"+ drawingPlanStart 
				 +"|"+ drawingPlanFinish 
				 +"|"+ drawingActStart 
				 +"|"+ drawingActFinish
				 +"|"+ ownerPlanStart 
				 +"|"+ ownerPlanFinish 
				 +"|"+ ownerActStart 
				 +"|"+ ownerActFinish
				 +"|"+ classPlanStart 
				 +"|"+ classPlanFinish 
				 +"|"+ classActStart 
				 +"|"+ classActFinish;
		return returnString;
	}

	/** 
	 * @메소드명	: buyerClassLetterFaxDocumentInfo
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 참조 문서 정보 취득
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String buyerClassLetterFaxDocumentInfo(CommandMap commandMap) throws Exception {
		String project = (String) commandMap.get("project");
		String document = (String) commandMap.get("document");
		
		String returnString = "";
		
		String projectNo		= "";
		String documentNo		= "";
		String subject			= "";
		String docDate			= "";
		String sendReceiveDept 	= "";
		String refDept			= "";
		String sender			= "";
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		Statement stmt = conn.createStatement();
		
		StringBuffer selectDateSQL = new StringBuffer();
		selectDateSQL.append("SELECT PROJECT ");
		selectDateSQL.append("     , REF_NO ");
		selectDateSQL.append("     , SUBJECT ");
		selectDateSQL.append("     , TO_CHAR(SEND_RECEIVE_DATE , 'YYYY-MM-DD')");
		selectDateSQL.append("     , SEND_RECEIVE_DEPT ");
		selectDateSQL.append("     , REF_DEPT ");
		selectDateSQL.append("     , SENDER ");
		selectDateSQL.append("  FROM stx_oc_document_list ");
		selectDateSQL.append(" WHERE PROJECT = '"+project+"' ");
		selectDateSQL.append("   AND ref_no = '"+document+"' ");
		
		java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
		
		while(selectDateRset.next()){
			
			projectNo			= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
			documentNo			= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
			subject				= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
			docDate				= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
			sendReceiveDept 	= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
			refDept				= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
			sender				= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
		}
		
		returnString = projectNo 
				 +"|"+ documentNo 
				 +"|"+ subject 
				 +"|"+ docDate 
				 +"|"+ sendReceiveDept 
				 +"|"+ refDept 
				 +"|"+ sender;
		return returnString;
	}

	@Override
	public List<Map<String, Object>> getPartPersonsForBuyerClass(Map<String, String> dpsUserInfo) throws Exception {
		String dept_code = String.valueOf(dpsUserInfo.get("DEPT_CODE"));
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		Statement stmt = conn.createStatement();
		StringBuffer selectDateSQL = new StringBuffer();
		
		selectDateSQL.append("SELECT A.EMPLOYEE_NUM,                                   ");
		selectDateSQL.append("       A.NAME                                            ");
		selectDateSQL.append("FROM   CCC_SAWON A                                       ");
		selectDateSQL.append("WHERE  A.DEPT_CODE = '"+dept_code+"'             		   ");
		selectDateSQL.append("AND    TERMINATION_DATE IS NULL                          ");
		selectDateSQL.append("AND    (INPUT_MAN_HOUR_ENABLED = 'Y'                     ");
		selectDateSQL.append("        OR     INPUT_PROGRESS_ENABLED = 'Y')             ");
		selectDateSQL.append("ORDER BY A.EMPLOYEE_NUM                                  ");
		
		java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
		
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		
		while(selectDateRset.next()){
			Map<String,Object> temp = new HashMap<String, Object>();
			temp.put("EMPLOYEE_NUM", selectDateRset.getString(1)==null?"":selectDateRset.getString(1));
			temp.put("NAME", selectDateRset.getString(2)==null?"":selectDateRset.getString(2));
			returnList.add(temp);
		}
			
		return returnList;
	}

	@Override
	public List<Map<String, Object>> getDepartmentForBuyerClass() throws Exception {
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		Statement stmt = conn.createStatement();
		StringBuffer selectDateSQL = new StringBuffer();
		
		selectDateSQL.append("SELECT A.DEPTCODE AS TEAM_CODE,  ");
		selectDateSQL.append("       DECODE(B.DEPT_NAME, NULL, A.DEPTNM, B.DEPT_NAME) AS TEAM_NAME  ");
		selectDateSQL.append("FROM   (SELECT C.DEPTCODE,  ");
		selectDateSQL.append("               C.DEPTNM  ");
		selectDateSQL.append("        FROM   DCC_DEPTCODE C  ");
		selectDateSQL.append("        WHERE  C.DWGDEPTCODE IN (SELECT DWGDEPTCODE  ");
		selectDateSQL.append("                FROM   DCC_DWGDEPTCODE  ");
		selectDateSQL.append("                WHERE  COUNTYN = 'Y') ) A,  ");
		selectDateSQL.append("       STX_COM_INSA_DEPT@STXERP B  ");
		selectDateSQL.append("WHERE  1 = 1  ");
		selectDateSQL.append("AND    A.DEPTCODE = B.DEPT_CODE(+)  ");
		selectDateSQL.append("AND    B.USE_YN = 'Y'  ");
		selectDateSQL.append("ORDER BY DEPTCODE   ");
		
		
		System.out.println(selectDateSQL.toString());
		
		java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
		
		List<Map<String,Object>> returnList = new ArrayList<Map<String,Object>>();
		
		while(selectDateRset.next()){
			Map<String,Object> temp = new HashMap<String, Object>();
			temp.put("teamcode", selectDateRset.getString(1)==null?"":selectDateRset.getString(1));
			temp.put("teamname", selectDateRset.getString(2)==null?"":selectDateRset.getString(2));
			
			returnList.add(temp);
		}
		return returnList;
	}
}

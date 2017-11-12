package stxship.dis.buyerClass.letterFaxMgnt.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.stereotype.Service;

import com.stx.common.interfaces.DBConnect;

import stxship.dis.buyerClass.letterFaxMgnt.dao.LetterFaxMgntDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : LetterFaxMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxMgnt에서 사용되는 서비스
 *     </pre>
 */
@Service("letterFaxMgntService")
public class LetterFaxMgntServiceImpl extends CommonServiceImpl implements LetterFaxMgntService {

	@Resource(name = "letterFaxMgntDAO")
	private LetterFaxMgntDAO letterFaxMgntDAO;

	private static final String SERVER_IP = "172.16.2.90";
	private static final int PORT = 21;
	private static final String LOGIN_ID = "dcruser";
	private static final String LOGIN_PW = "dcr123";

	private FTPClient ftpClient = new FTPClient();

	private boolean login() throws Exception {
		try {
			try {
				ftpClient.connect(SERVER_IP, PORT);

				if (!FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
					ftpClient.disconnect();
					throw new Exception("Connect Error!");
				}
			} catch (Exception e) {
				if (ftpClient.isConnected()) {
					try {
						ftpClient.disconnect();
					} catch (Exception ex) {

					}
				}
				e.printStackTrace();
				throw e;
			}
			return ftpClient.login(LOGIN_ID, LOGIN_PW);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	private boolean logout() throws Exception {
		try {
			return ftpClient.logout();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * @메소드명 : buyerClassLetterFaxDocumentDeleteProcess
	 * @날짜 : 2016. 6. 27.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공문 / 첨부파일이 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> buyerClassLetterFaxDocumentDeleteProcess(CommandMap commandMap) throws Exception {

		String refNo = (String) commandMap.get("refNo");
		String ownerClassType = (String) commandMap.get("ownerClassType");
		Connection conn = null;

		Statement stmt = null;
		Statement stmt2 = null;
		Statement stmt3 = null;
		Statement stmtDelActualDate = null;
		try {
			conn = DBConnect.getDBConnection("SDPS");
			conn.setAutoCommit(false);

			StringBuffer selectDocNumSQL = new StringBuffer();
			selectDocNumSQL.append(
					"select to_char(nvl(max(to_number(substr(sodl2.ref_no , instr(sodl2.ref_no , '-' , 1 , 2)+1))),1) , 'FM0000') ");
			selectDocNumSQL.append("  from stx_oc_document_list sodl ");
			selectDocNumSQL.append("     , stx_oc_document_list sodl2 ");
			selectDocNumSQL.append(" where sodl.ref_no = '" + refNo + "' ");
			selectDocNumSQL.append("   and sodl2.project in (select project  ");
			selectDocNumSQL.append("                 	 from stx_oc_project_send_number  ");
			selectDocNumSQL.append("                 	where DOC_PROJECT = (SELECT DOC_PROJECT  ");
			selectDocNumSQL.append("                 	                       FROM stx_oc_project_send_number a  ");
			selectDocNumSQL.append("                 	                      WHERE a.project = sodl.project)) ");
			selectDocNumSQL.append("   and sodl2.send_receive_type = 'send' ");
			selectDocNumSQL.append("   and instr(sodl2.ref_no , '-' , 1 , 2) > 0 ");
			selectDocNumSQL.append("   and sodl2.OWNER_CLASS_TYPE = sodl.OWNER_CLASS_TYPE ");

			stmt3 = conn.createStatement();
			ResultSet selectDocNumRset = stmt3.executeQuery(selectDocNumSQL.toString());

			String maxDocNum = "";
			if (selectDocNumRset.next()) {
				maxDocNum = selectDocNumRset.getString(1) == null ? "" : selectDocNumRset.getString(1);
			}

			stmt = conn.createStatement();
			if (maxDocNum.equals(refNo.substring(refNo.length() - 4))) {
				StringBuffer docDeletetQuery = new StringBuffer();
				docDeletetQuery.append("delete ");
				docDeletetQuery.append("  from stx_oc_document_list ");
				docDeletetQuery.append(" where ref_no = '" + refNo + "' ");

				stmt.executeQuery(docDeletetQuery.toString());
			} else {
				StringBuffer docDeletetQuery = new StringBuffer();
				docDeletetQuery.append("update stx_oc_document_list ");
				docDeletetQuery.append("   set subject = 'DELETE' ");
				docDeletetQuery.append(" where ref_no = '" + refNo + "' ");

				stmt.executeQuery(docDeletetQuery.toString());
			}

			StringBuffer refDocDelActualDate = new StringBuffer();
			refDocDelActualDate.append(" \n");

			stmtDelActualDate = conn.createStatement();
			if ("owner".equals(ownerClassType)) {
				refDocDelActualDate.append("UPDATE PLM_ACTIVITY T SET T.ACTUALSTARTDATE = '' \n");
				refDocDelActualDate.append("	 WHERE T.ROWID IN \n");
				refDocDelActualDate.append("	       (SELECT PA.ROWID \n");
				refDocDelActualDate.append("	          FROM STX_OC_REF_OBJECT SORO \n");
				refDocDelActualDate.append("	              ,PLM_ACTIVITY      PA \n");
				refDocDelActualDate.append("	         WHERE SORO.REF_NO = '" + refNo + "' \n");
				refDocDelActualDate.append("	           AND SORO.PROJECT = PA.PROJECTNO \n");
				refDocDelActualDate.append("	           AND PA.DWGCATEGORY = 'B' \n");
				refDocDelActualDate.append("	           AND ((PA.DWGTYPE = 'V' AND \n");
				refDocDelActualDate.append("	               PA.ACTIVITYCODE = SORO.OBJECT_NO || 'CL') OR \n");
				refDocDelActualDate.append("	               (PA.DWGTYPE <> 'V' AND \n");
				refDocDelActualDate.append("	               PA.ACTIVITYCODE = SORO.OBJECT_NO || 'OW')) \n");
				refDocDelActualDate.append("			   AND 1 = (SELECT COUNT(SORO2.PROJECT) \n");
				refDocDelActualDate.append("			  			  FROM STX_OC_REF_OBJECT SORO2 \n");
				refDocDelActualDate.append("						 WHERE SORO2.PROJECT = PA.PROJECTNO \n");
				refDocDelActualDate
						.append(" 						   AND SUBSTR(PA.ACTIVITYCODE,1,8) = SORO2.OBJECT_NO \n");
				refDocDelActualDate.append("					  GROUP BY SORO2.PROJECT)) \n");

				stmtDelActualDate.executeQuery(refDocDelActualDate.toString());
			} else if ("class".equals(ownerClassType)) {
				refDocDelActualDate.append("UPDATE PLM_ACTIVITY T SET T.ACTUALSTARTDATE = '' \n");
				refDocDelActualDate.append("	 WHERE T.ROWID IN \n");
				refDocDelActualDate.append("	       (SELECT PA.ROWID \n");
				refDocDelActualDate.append("	          FROM STX_OC_REF_OBJECT SORO \n");
				refDocDelActualDate.append("	              ,PLM_ACTIVITY      PA \n");
				refDocDelActualDate.append("	         WHERE SORO.REF_NO = '" + refNo + "' \n");
				refDocDelActualDate.append("	           AND SORO.PROJECT = PA.PROJECTNO \n");
				refDocDelActualDate.append("	           AND PA.DWGCATEGORY = 'B' \n");
				refDocDelActualDate.append("	           AND PA.DWGTYPE <> 'V' \n");
				refDocDelActualDate.append("	           AND PA.ACTIVITYCODE = SORO.OBJECT_NO || 'CL' \n");
				refDocDelActualDate.append("			   AND 1 = (SELECT COUNT(SORO2.PROJECT) \n");
				refDocDelActualDate.append("			  			  FROM STX_OC_REF_OBJECT SORO2 \n");
				refDocDelActualDate.append("						 WHERE SORO2.PROJECT = PA.PROJECTNO \n");
				refDocDelActualDate
						.append(" 						   AND SUBSTR(PA.ACTIVITYCODE,1,8) = SORO2.OBJECT_NO \n");
				refDocDelActualDate.append("					  GROUP BY SORO2.PROJECT)) \n");

				stmtDelActualDate.executeQuery(refDocDelActualDate.toString());
			}

			StringBuffer refDocDeletetQuery = new StringBuffer();
			refDocDeletetQuery.append("delete ");
			refDocDeletetQuery.append("	 from stx_oc_ref_object ");
			refDocDeletetQuery.append("	where ref_no = '" + refNo + "' ");

			stmt2 = conn.createStatement();
			stmt2.executeQuery(refDocDeletetQuery.toString());

			String fileName = "";
			fileName = refNo.replace('/', '-');

			// FTP Login
			login();
			// System.out.println("FTP Login Success.");

			// Change Directory
			ftpClient.changeWorkingDirectory("\\SEND");
			// cd("\\RECEIVE");
			// System.out.println("FTP Folder Change Success.");

			FTPFile[] ftpFiles = ftpClient.listFiles();

			for (int i = 0; i < ftpFiles.length; i++) {
				if (ftpFiles[i].getName().startsWith(fileName)) {
					boolean deleteFlag = ftpClient.deleteFile(ftpFiles[i].getName());
					if (deleteFlag)
						System.out.println("FTP File Delete Success. - " + ftpFiles[i].getName());
					else
						System.out.println("FTP File Delete Fail. - " + ftpFiles[i].getName());
				}
			}

			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (stmt != null)
				stmt.close();
			if (stmt2 != null)
				stmt2.close();
			if (stmt3 != null)
				stmt3.close();
			if (stmtDelActualDate != null)
				stmtDelActualDate.close();
			if (conn != null)
				conn.close();
			// FTP Logout
			logout();
			// System.out.println("FTP Logout Success.");

			// FTP Disconnect
			ftpClient.disconnect();
			// System.out.println("FTP Disconnect Success.");
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}

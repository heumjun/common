package stxship.dis.buyerClass.buyerClassComment.service;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.util.StringUtil;

import stxship.dis.buyerClass.buyerClassComment.dao.BuyerClassCommentDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : BuyerClassCommentServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * BuyerClassComment에서 사용되는 서비스
 *     </pre>
 */
@Service("buyerClassCommentService")
public class BuyerClassCommentServiceImpl extends CommonServiceImpl implements BuyerClassCommentService {

	@Resource(name = "buyerClassCommentDAO")
	private BuyerClassCommentDAO buyerClassCommentDAO;
	private FTPClient ftpClient = new FTPClient();
	private static final String SERVER_IP = "172.16.2.90";
	private static final int PORT = 21;
	private static final String LOGIN_ID = "dcruser";
	private static final String LOGIN_PW = "dcr123";

	/** 
	 * @메소드명	: saveBuyerClassCommentProcess
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 실적등록 로직실행
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> saveBuyerClassCommentProcess(CommandMap commandMap, HttpServletRequest request)
			throws Exception {

		MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
		Object formfile = multi.getFile("fileName");
		String sSelect_seq_no = StringUtil.setEmptyExt(multi.getParameter("select_seq_no"));
		String sSelect_rev_no = StringUtil.setEmptyExt(multi.getParameter("select_rev_no"));

		String send_ref_no = StringUtil.setEmptyExt(multi.getParameter("send_ref_no"));
		String comment_count = StringUtil.setEmptyExt(multi.getParameter("comment_count"));
		String reply_count = StringUtil.setEmptyExt(multi.getParameter("reply_count"));
		String short_notice_count = StringUtil.setEmptyExt(multi.getParameter("short_notice_count"));

		String fileName = ((CommonsMultipartFile) formfile).getOriginalFilename();

		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rset = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");

			boolean completeFalg = false;
			if (comment_count.equals(reply_count)) {
				completeFalg = true;
			}

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT \n");
			// 실적 등록 일자
			queryStr.append("   SET DESIGN_PROCESS_DATE = SYSDATE    \n");
			// Commnents 건수
			queryStr.append("      ,COMMENT_COUNT = '" + comment_count + "'  \n");
			// Reply 건수
			queryStr.append("      ,REPLY_COUNT = '" + reply_count + "'       \n");
			// Short Notice 건수
			queryStr.append("      ,SHORT_NOTICE_COUNT = '" + short_notice_count + "'  \n");
			// 관련 Ref No.
			queryStr.append("      ,SEND_REF_NO = '" + send_ref_no + "'       \n");
			// 실적등록 첨부 문서명
			queryStr.append("      ,PROCESS_FILE_NAME = '" + fileName + "'    \n");
			if (completeFalg) {
				// STATUS:Closed
				queryStr.append("      ,STATUS = 'Closed'       \n");
				// 종료일자
				queryStr.append("      ,DESIGN_CLOSE_DATE = SYSDATE      \n");
			} else {
				// STATUS : Progress
				queryStr.append("      ,STATUS = 'Progress'     \n");
			}
			queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no + "' \n");
			
			stmt = conn.createStatement();
			stmt.executeUpdate(queryStr.toString());

			DBConnect.commitJDBCTransaction(conn);

		} catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
		}

		finally {
			try {
				if (rset != null)
					rset.close();
				if (stmt != null)
					stmt.close();
				if (pstmt != null)
					pstmt.close();
				DBConnect.closeConnection(conn);
			} catch (Exception ex) {
			}
		}

		if (!"".equals(fileName)) {

			String fileType = fileName.substring(fileName.lastIndexOf("."), fileName.length());

			// 실적등록 첨부 문서는 FTP 서버에 COMMNETS 폴더에 접수번호+SEQ_NO+파일형 형태로 저장됨. 예)
			// 20120905001_100.xls
			String saveFileName = "";

			saveFileName = sSelect_rev_no + "_" + sSelect_seq_no + fileType;

			try {
				// FTP Login

				ftpClient.connect(SERVER_IP, PORT);
				if (!FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
					ftpClient.disconnect();
					throw new Exception("Connect Error!");
				}
				ftpClient.login(LOGIN_ID, LOGIN_PW);

				// Change Directory
				//ftpClient.changeWorkingDirectory("\\COMMENTS");
				ftpClient.changeWorkingDirectory(DisMessageUtil.getMessage("letter.fax.ftp.folder.comments"));

				// File Type Setting
				ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

				// File Upload
				InputStream input = null;

				try {
					input = ((CommonsMultipartFile) formfile).getInputStream();
				} catch (Exception e) {
					e.printStackTrace();
					throw e;
				}

				ftpClient.storeFile(saveFileName, input);

			} finally {
				// FTP Logout
				ftpClient.logout();
				// FTP Disconnect
				ftpClient.disconnect();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/** 
	 * @메소드명	: saveBuyerClassCommentProcessAddition
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 문서 접수
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> saveBuyerClassCommentProcessAddition(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
		Object formfile = multi.getFile("fileName");
		String sSelect_seq_no = StringUtil.setEmptyExt(multi.getParameter("select_seq_no"));
		String sSelect_rev_no = StringUtil.setEmptyExt(multi.getParameter("select_rev_no"));

		String send_ref_no = StringUtil.setEmptyExt(multi.getParameter("send_ref_no"));
		String comment_count = StringUtil.setEmptyExt(multi.getParameter("comment_count"));
		String reply_count = StringUtil.setEmptyExt(multi.getParameter("reply_count"));
		String short_notice_count = StringUtil.setEmptyExt(multi.getParameter("short_notice_count"));

		String fileName = ((CommonsMultipartFile) formfile).getOriginalFilename();

		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rset = null;

		String nextSequence = "";
		try {
			conn =  DBConnect.getDBConnection("SDPS");

			// 기존 실적은 Closed 처리
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
			queryStr.append("   SET STATUS = 'Closed'                                                    \n"); // STATUS
																												// :
																												// Closed
			queryStr.append("      ,DESIGN_CLOSE_DATE = SYSDATE                                          \n"); // 종료일자
			queryStr.append(" WHERE SEQ_NO = '" + sSelect_seq_no + "'                                     \n");

			stmt = conn.createStatement();
			stmt.executeUpdate(queryStr.toString());

			DBConnect.commitJDBCTransaction(conn);

			boolean completeFalg = false;
			if (comment_count.equals(reply_count)) {
				completeFalg = true;
			}

			// SEQ_NO 추출 : STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL

			StringBuffer selectSeqQuery = new StringBuffer();
			selectSeqQuery.append("SELECT STX_OC_RECEIVE_DOCUMENT_S.NEXTVAL  \n");
			selectSeqQuery.append("  FROM DUAL                               \n");

			rset = stmt.executeQuery(selectSeqQuery.toString());
			if (rset.next())
				nextSequence = rset.getString(1);

			// 신규 실적은 새로 insert
			StringBuffer insertQuery = new StringBuffer();
			insertQuery.append("INSERT INTO STX_OC_RECEIVE_DOCUMENT(               \n");
			insertQuery.append("	SEQ_NO,                                        \n");
			insertQuery.append("	PROJECT,                                       \n");
			insertQuery.append("	OWNER_CLASS_TYPE,                              \n");
			insertQuery.append("	SEND_RECEIVE_TYPE,                             \n");
			insertQuery.append("	DOC_TYPE,                                      \n");
			insertQuery.append("	REF_NO,                                        \n");
			insertQuery.append("	REV_NO,                                        \n");
			insertQuery.append("	SUBJECT,                                       \n");
			insertQuery.append("	SENDER,                                        \n");
			insertQuery.append("	SENDER_NO,                                     \n");
			insertQuery.append("	SEND_RECEIVE_DATE,                             \n");
			insertQuery.append("	SEND_RECEIVE_DEPT,                             \n");
			insertQuery.append("	REF_DEPT,                                      \n");
			insertQuery.append("	DESIGN_RECEIVE_FLAG,                           \n");
			insertQuery.append("	DESIGN_RECEIVE_DATE,                           \n");
			insertQuery.append("	DESIGN_PROCESS_DATE,                           \n");
			insertQuery.append("	DESIGN_CLOSE_DATE,                             \n");
			insertQuery.append("	STATUS,                                        \n");
			insertQuery.append("	DESIGN_RECEIVE_PERSON,                         \n");
			insertQuery.append("	DESIGN_PROCESS_PERSON,                         \n");
			insertQuery.append("	SEND_REF_NO,                                   \n");
			insertQuery.append("	PROCESS_FILE_NAME,                             \n");
			insertQuery.append("	COMMENT_COUNT,                                 \n");
			insertQuery.append("	REPLY_COUNT,                                   \n");
			insertQuery.append("	SHORT_NOTICE_COUNT,                            \n");
			insertQuery.append("	COMMENT_MESSAGE,                               \n");
			insertQuery.append("	DESIGN_PROCESS_DEPT,                           \n");
			insertQuery.append("	DESIGN_PROCESS_PERSON_NAME,                    \n");
			insertQuery.append("	DESIGN_RECEIVE_PERSON_NAME,                    \n");
			insertQuery.append("	DESIGN_RECEIVE_ACTION)                         \n");
			insertQuery.append("SELECT                                             \n");
			insertQuery.append("   '" + nextSequence + "',                         \n"); // SEQ_NO
			insertQuery.append("	PROJECT,                                       \n"); // project
			insertQuery.append("	OWNER_CLASS_TYPE,                              \n"); // owner_class_type
			insertQuery.append("	SEND_RECEIVE_TYPE,                             \n"); // send_receive_type
			insertQuery.append("	DOC_TYPE,                                      \n"); // doc_type
			insertQuery.append("	REF_NO,                                        \n"); // ref_no
			insertQuery.append("	REV_NO,                                        \n"); // rev_no
			insertQuery.append("	SUBJECT,                                       \n"); // subject
			insertQuery.append("	SENDER,                                        \n"); // sender
			insertQuery.append("	SENDER_NO,                                     \n"); // SENDER_NO
			insertQuery.append("	SEND_RECEIVE_DATE,                             \n"); // SEND_RECEIVE_DATE
			insertQuery.append("	SEND_RECEIVE_DEPT,                             \n"); // SEND_RECEIVE_DEPT
			insertQuery.append("	REF_DEPT,                                      \n"); // REF_DEPT
			insertQuery.append("	DESIGN_RECEIVE_FLAG,                           \n"); // DESIGN_RECEIVE_FLAG
			insertQuery.append("	SYSDATE,                                       \n"); // DESIGN_RECEIVE_DATE는
																							// 최신날짜로
																							// 변경
			insertQuery.append("	SYSDATE,                                       \n"); // DESIGN_PROCESS_DATE
			if (completeFalg) {
				insertQuery.append("	SYSDATE,                                       \n"); // DESIGN_CLOSE_DATE
				insertQuery.append("	'Closed',                                      \n"); // STATUS
																								// :
																								// 'Closed'
			} else {
				insertQuery.append("	NULL,                                          \n"); // DESIGN_CLOSE_DATE
				insertQuery.append("	'Progress',                                    \n"); // STATUS
																								// :
																								// 'Progress'
			}
			insertQuery.append("	DESIGN_RECEIVE_PERSON,                         \n"); // DESIGN_RECEIVE_PERSON
			insertQuery.append("	DESIGN_PROCESS_PERSON,                         \n"); // DESIGN_PROCESS_PERSON
			insertQuery.append("	'" + send_ref_no + "',                         \n"); // SEND_REF_NO
			insertQuery.append("	'" + fileName + "',                            \n"); // PROCESS_FILE_NAME
			insertQuery.append("    '" + comment_count + "',                       \n"); // COMMENT_COUNT
			insertQuery.append("    '" + reply_count + "',                         \n"); // REPLY_COUNT
			insertQuery.append("    '" + short_notice_count + "',                  \n"); // SHORT_NOTICE_COUNT
			insertQuery.append("	COMMENT_MESSAGE,                               \n"); // COMMENT_MESSAGE
			insertQuery.append("	DESIGN_PROCESS_DEPT,                           \n"); // DESIGN_PROCESS_DEPT
			insertQuery.append("	DESIGN_PROCESS_PERSON_NAME,                    \n"); // DESIGN_PROCESS_PERSON_NAME
			insertQuery.append("	DESIGN_RECEIVE_PERSON_NAME,                    \n"); // DESIGN_RECEIVE_PERSON_NAME
			insertQuery.append("	DESIGN_RECEIVE_ACTION                          \n");
			insertQuery.append("FROM STX_OC_RECEIVE_DOCUMENT                       \n");
			insertQuery.append("WHERE SEQ_NO = '" + sSelect_seq_no + "'             \n");

			stmt.executeUpdate(insertQuery.toString());

			DBConnect.commitJDBCTransaction(conn);

		} catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
		}

		finally {
			try {
				if (rset != null)
					rset.close();
				if (stmt != null)
					stmt.close();
				if (pstmt != null)
					pstmt.close();
				DBConnect.closeConnection(conn);
			} catch (Exception ex) {
			}
		}
		if (!"".equals(fileName)) {

			String fileType = fileName.substring(fileName.lastIndexOf("."), fileName.length());

			// 실적등록 첨부 문서는 FTP 서버에 COMMNETS 폴더에 접수번호+SEQ_NO+파일형 형태로 저장됨. 예)
			// 20120905001_100.xls
			String saveFileName = "";

			saveFileName = sSelect_rev_no + "_" + nextSequence + fileType;
			try {
				// FTP Login

				ftpClient.connect(SERVER_IP, PORT);
				if (!FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
					ftpClient.disconnect();
					throw new Exception("Connect Error!");
				}
				ftpClient.login(LOGIN_ID, LOGIN_PW);

				// Change Directory
				//ftpClient.changeWorkingDirectory("\\COMMENTS");
				ftpClient.changeWorkingDirectory(DisMessageUtil.getMessage("letter.fax.ftp.folder.comments"));

				// File Type Setting
				ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

				// File Upload
				InputStream input = null;

				try {
					input = ((CommonsMultipartFile) formfile).getInputStream();
				} catch (Exception e) {
					e.printStackTrace();
					throw e;
				}

				ftpClient.storeFile(saveFileName, input);

			} finally {
				// FTP Logout
				ftpClient.logout();
				// FTP Disconnect
				ftpClient.disconnect();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/** 
	 * @메소드명	: buyerClassCommentForceClosed
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 강제 Close
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> buyerClassCommentForceClosed(CommandMap commandMap) throws Exception {
		String sSelect_seq_no = (String) commandMap.get("select_seq_no");

		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn =  DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
			queryStr.append("   SET DESIGN_CLOSE_DATE = SYSDATE                                          \n"); // Closed
																												// 일자
			queryStr.append("      ,STATUS = 'Closed(F)'                                                 \n"); // STATUS
																												// :
																												// Closed(F)
			queryStr.append(" WHERE SEQ_NO = ?                                                          \n");

			pstmt = conn.prepareStatement(queryStr.toString());

			StringTokenizer st = new StringTokenizer(sSelect_seq_no, ",");
			while (st.hasMoreTokens()) {
				String seq_no = st.nextToken();
				pstmt.setString(1, seq_no);
				pstmt.executeUpdate();
			}

			DBConnect.commitJDBCTransaction(conn);

		} catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
		}

		finally {
			try {
				if (pstmt != null)
					pstmt.close();
				DBConnect.closeConnection(conn);
			} catch (Exception ex) {
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	
}

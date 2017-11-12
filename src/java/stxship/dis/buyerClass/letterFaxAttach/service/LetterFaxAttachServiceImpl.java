package stxship.dis.buyerClass.letterFaxAttach.service;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import stxship.dis.buyerClass.letterFaxAttach.dao.LetterFaxAttachDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : LetterFaxAttachServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxAttach에서 사용되는 서비스
 * </pre>
 */
@Service("letterFaxAttachService")
public class LetterFaxAttachServiceImpl extends CommonServiceImpl implements LetterFaxAttachService {

	/** 공문서 첨부 DAO */
	@Resource(name = "letterFaxAttachDAO")
	private LetterFaxAttachDAO letterFaxAttachDAO;

	/**
	 * @메소드명 : getSerialNo
	 * @날짜 : 2016. 7. 12.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 다수의 첨부파일을 올릴경우 파일의 마지막 시리얼번호를 취득한다.
	 * </pre>
	 * @param ftpFiles
	 * @param docNo
	 * @return
	 * @throws Exception
	 */
	private int getSerialNo(FTPFile[] ftpFiles, String docNo) throws Exception {

		int maxNum = 1;

		for (int i = 0; i < ftpFiles.length; i++) {
			if (ftpFiles[i].getName().startsWith(docNo)) {
				int tempSerialNo = 0;
				try {
					tempSerialNo = Integer.parseInt(ftpFiles[i].getName().substring(docNo.length() + 1,
							docNo.length() + 3));
				} catch (Exception e) {

				}
				tempSerialNo++;
				if (maxNum < tempSerialNo)
					maxNum = tempSerialNo;
			}
		}

		return maxNum;
	}

	/**
	 * @메소드명 : upLoadFile
	 * @날짜 : 2016. 7. 12.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * FTP서버에 파일을 업로드 한다.
	 * </pre>
	 * @param pos_file
	 * @param refNo
	 * @param mode
	 * @param loginID
	 * @param excuteCnt
	 * @return
	 * @throws Exception
	 */
	private int upLoadFile(MultipartFile pos_file, String refNo, String mode, String loginID, int excuteCnt)
			throws Exception {
		// ----------------------------------------------
		// FTP에 파일 업로드
		// ----------------------------------------------
		FTPClient ftpClient = new FTPClient();
		try {
			// FTP Connect
			ftpClient.connect(DisMessageUtil.getMessage("letter.fax.ftp.server"),
					Integer.parseInt(DisMessageUtil.getMessage("letter.fax.ftp.port")));
			if (!FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
				ftpClient.disconnect();
				throw new Exception("FTP Connect Error!");
			}
			// FTP Login
			ftpClient.login(DisMessageUtil.getMessage("letter.fax.ftp.id"),
					DisMessageUtil.getMessage("letter.fax.ftp.password"));

			// Change Directory
			// LETEER FAX FTP는 테스트가 없기에 테스트 서버에서는 TEST 임시 폴더로 접근하도록 수정. 폴더는 system.property에서 관리
			if (DisMessageUtil.getMessage("letter.fax.ftp.test").equals(DisConstants.Y)) {
				//ftpClient.changeWorkingDirectory("\\TEST");
				ftpClient.changeWorkingDirectory(DisMessageUtil.getMessage("letter.fax.ftp.folder.send"));
			} else {
				//ftpClient.changeWorkingDirectory("\\SEND");
				ftpClient.changeWorkingDirectory(DisMessageUtil.getMessage("letter.fax.ftp.folder.send"));
			}
			

			// File Type Setting
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

			// File Upload
			// ----------------------------------------------
			// 파일 정보로 생성파일명 생성
			// ----------------------------------------------
			String originalFileName = pos_file.getOriginalFilename();
			String saveDocName = refNo.replace('/', '-');
			String fileType = originalFileName.substring(originalFileName.lastIndexOf("."), originalFileName.length());
			String fileName = "";
			if ("doc".equals(mode)) {
				fileName = saveDocName + fileType;
			} else if ("ref".equals(mode)) {
				if (excuteCnt == 0) {
					excuteCnt = getSerialNo(ftpClient.listFiles(), saveDocName);
				}
				String serialNo = "";
				if (excuteCnt < 10)
					serialNo = "0" + excuteCnt;
				else
					serialNo = "" + excuteCnt;

				fileName = saveDocName + "-" + serialNo + fileType;
			}
			ftpClient.storeFile(fileName, pos_file.getInputStream());

			// DB Upload
			// ----------------------------------------------
			// DB정보 업데이트
			// ----------------------------------------------
			String updateAttachInfoSQL = "update STX_OC_DOCUMENT_LIST " + "   set ATTACH_USER = '" + loginID + "' "
					+ " 	 ,ATTACH_DATE = sysdate " + " where REF_NO = '" + refNo + "' ";

			java.sql.Connection conn = null;
			java.sql.Statement stmt = null;
			try {
				conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
				stmt = conn.createStatement();
				stmt.executeUpdate(updateAttachInfoSQL);

				conn.commit();
			} finally {
				if (conn != null)
					conn.close();
				if (stmt != null)
					stmt.close();
			}

		} finally {
			// FTP Logout
			ftpClient.logout();
			// FTP Disconnect
			ftpClient.disconnect();
		}
		return excuteCnt + 1;
	};

	/**
	 * @메소드명 : buyerClassLetterFaxAttachFileToFTP
	 * @날짜 : 2016. 7. 12.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공문서 첨부 처리
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> buyerClassLetterFaxAttachFileToFTP(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		// ----------------------------------------------
		String loginID = (String) commandMap.get(DisConstants.SET_DB_LOGIN_ID);
		String refNo = request.getParameter("refNo");
		String mode = request.getParameter("mode");
		int excuteCnt = 0;
		// ----------------------------------------------
		// request File get Start
		// ----------------------------------------------
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile pos_file = multipartRequest.getFile("fileName0");
		MultipartFile pos_file1 = multipartRequest.getFile("fileName1");
		MultipartFile pos_file2 = multipartRequest.getFile("fileName2");
		MultipartFile pos_file3 = multipartRequest.getFile("fileName3");
		MultipartFile pos_file4 = multipartRequest.getFile("fileName4");
		MultipartFile pos_file5 = multipartRequest.getFile("fileName5");
		MultipartFile pos_file6 = multipartRequest.getFile("fileName6");
		MultipartFile pos_file7 = multipartRequest.getFile("fileName7");
		MultipartFile pos_file8 = multipartRequest.getFile("fileName8");
		MultipartFile pos_file9 = multipartRequest.getFile("fileName9");
		if (pos_file.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file1 != null && pos_file1.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file1, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file2 != null && pos_file2.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file2, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file3 != null && pos_file3.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file3, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file4 != null && pos_file4.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file4, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file5 != null && pos_file5.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file5, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file6 != null && pos_file6.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file6, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file7 != null && pos_file7.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file7, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file8 != null && pos_file8.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file8, refNo, mode, loginID, excuteCnt);
		}
		if (pos_file9 != null && pos_file9.getSize() != 0) {
			excuteCnt = upLoadFile(pos_file9, refNo, mode, loginID, excuteCnt);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}

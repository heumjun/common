package stxship.dis.etc.itemStandardUpload.service;

import java.io.InputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.etc.itemStandardUpload.dao.ItemStandardUploadDAO;

import com.stx.common.util.StringUtil;

/**
 * @파일명 : ItemStandardViewServiceImpl.java
 * @프로젝트 : DIMS
 * @날짜 : 2016. 9. 19.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * ItemStandardUpload에서 사용되는 서비스
 *     </pre>
 */
@Service("itemStandardUploadService")
public class ItemStandardUploadServiceImpl extends CommonServiceImpl implements ItemStandardUploadService {
	
	@Resource(name = "itemStandardUploadDAO")
	private ItemStandardUploadDAO itemStandardUploadDAO;
	
	private FTPClient ftpClient = new FTPClient();
	private static final String SERVER_IP = "172.16.2.90";

	@Override
	public String getSelectBoxDataList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = itemStandardUploadDAO.getSelectBoxDataList(commandMap.getMap());
		String rtnString = "";

		for (Map<String, Object> map : list) {
			if (!rtnString.equals("")) {
				rtnString += "|";
			}
			rtnString += map.get("object").toString();
		}
		
		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	public Map<String, Object> getDbDataOne(CommandMap commandMap) {
		String mapperSql = "";
		if (commandMap.get(DisConstants.MAPPER) == null) {
			mapperSql = "itemStandardUpload" + DisConstants.MAPPER_SEPARATION
					+ commandMap.get(DisConstants.MAPPER_NAME);
		} else {
			mapperSql = commandMap.get(DisConstants.MAPPER).toString();

		}
		return itemStandardUploadDAO.selectOne(mapperSql, commandMap.getMap());
	}
	
	@Override
	public Map<String, Object> insertFileUpLoad(CommandMap commandMap, HttpServletRequest request)
			throws Exception {

		MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
		Object formfile = multi.getFile("uploadFile");
		String sCatalog = StringUtil.setEmptyExt(multi.getParameter("catalog"));
		String sRev_no = StringUtil.setEmptyExt(multi.getParameter("revNo"));
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		String basePath = "";
		String id = "";
		String pass = "";
		String port = "";		
		
		List<Map<String, Object>> list = itemStandardUploadDAO.getServerInfoList();
		
		basePath = list.get(0).get("CODE_VALUE").toString();
		id = list.get(1).get("CODE_VALUE").toString();
		pass = list.get(3).get("CODE_VALUE").toString();
		port = list.get(4).get("CODE_VALUE").toString();

		String fileName = ((CommonsMultipartFile) formfile).getOriginalFilename();
		
		// 부품표준서 문서는 FTP 서버에 ITEMDWG 폴더의 카탈로그 폴더에 카탈로그+REV_NO+파일형 형태로 저장됨. 예)
		// 11701_001.pdf
		String fileType = fileName.substring(fileName.lastIndexOf("."), fileName.length());
		String saveFileName = "";
		saveFileName = sCatalog + "-" + LPAD(sRev_no, 3, "0") + fileType.toUpperCase();			
		
		commandMap.getMap().put("file_name", saveFileName);

		int insertResult = itemStandardUploadDAO.insertFileUpLoad(commandMap.getMap());		
		
		if (!"".equals(fileName)) {

			try {
				// FTP Login

				ftpClient.connect(SERVER_IP, Integer.parseInt(port));
				if (!FTPReply.isPositiveCompletion(ftpClient.getReplyCode())) {
					ftpClient.disconnect();
					throw new Exception("Connect Error!");
				}
				ftpClient.login(id, pass);

				// Change Directory
				if(ftpClient.changeWorkingDirectory(basePath + "/" + sCatalog) != true) {
					ftpClient.makeDirectory(basePath + "/" + sCatalog);
				}
				
				ftpClient.changeWorkingDirectory(basePath + "/" + sCatalog);

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
		if (insertResult == 0) {
			//throw new DisException();
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.fail"));
		} else {
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
		}
		return rtnMap;
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveGridList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> saveList = DisJsonUtil
				.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		
		// 결과값 최초
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
			
			// UPDATE 인경우
			if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				rowData.put(DisConstants.MAPPER_NAME, "itemStandardUpload");
				gridDataUpdate(rowData);
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);

	}
	
	/**
	 * @메소드명 : selectAutoCompleteDwgNoList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 호선, 부서 별 도면번호 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String selectCatalogList(CommandMap commandMap) {
		List<Map<String, Object>> list = itemStandardUploadDAO.selectCatalogList(commandMap.getMap());
		String rtnString = "";

		for (Map<String, Object> map : list) {
			if (!rtnString.equals("")) {
				rtnString += "|";
			}
			rtnString += map.get("object").toString();
		}

		return rtnString;
	}
	
	private String LPAD(String str, int len, String append) {
	    String rtn = str;
	    if (str.length() < len){
	    	for (int i = (len - str.length()); i > 0; i--){
	    	rtn = append + rtn;
	    	}
	    } else{
	    	rtn = str.substring(0, len);
	    }
	    return rtn;
	 }

}

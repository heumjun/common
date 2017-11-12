package stxship.dis.wps.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.MimetypesFileTypeMap;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.IOUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.stx.common.util.StringUtil;

import stxship.dis.comment.dao.CommentDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.wps.dao.WpsDAO;

/**
 * 
 * @파일명		: WpsServiceImpl.java 
 * @프로젝트	: DIMS
 * @날짜		: 2017. 10. 11. 
 * @작성자		: 이상빈
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Service("WpsService")
public class WpsServiceImpl extends CommonServiceImpl implements WpsService {

	@Resource(name = "WpsDAO")
	private WpsDAO wpsDAO;
	
	private FTPClient ftpClient = new FTPClient();
	
	@Override
	public String wpsCodeTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsCodeTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	public List<Map<String, Object>> wpsCodeTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsDAO.wpsCodeTypeSelectBoxGridList(commandMap.getMap());
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> wpsCodeManageList(CommandMap commandMap) throws Exception {

		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsCodeManageList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveWpsCodeManage(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> wpsCodeManageSaveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		try {
			for (Map<String, Object> rowData : wpsCodeManageSaveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				wpsDAO.saveWpsCodeManage(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("P_ERROR_CODE"));
				
				if (!"".equals(sErrMsg)) {
					System.out.println(sErrCode);
					throw new DisException(sErrMsg);
				}
				
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_KEY);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * 
	 * @메소드명	: wpsPlateTypeSelectBoxDataList
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *			
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String wpsPlateTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsPlateTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	/**
	 * 
	 * @메소드명	: wpsProcessTypeSelectBoxDataList
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *			
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String wpsProcessTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsProcessTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	/**
	 * 
	 * @메소드명	: wpsTypeSelectBoxDataList
	 * @날짜		: 2017. 10. 31.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *			
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String wpsTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	public List<Map<String, Object>> wpsProcessTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsDAO.wpsProcessTypeSelectBoxGridList(commandMap.getMap());
	}
	
	public List<Map<String, Object>> wpsTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsDAO.wpsTypeSelectBoxGridList(commandMap.getMap());
	}
	
	public List<Map<String, Object>> wpsPlateTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsDAO.wpsPlateTypeSelectBoxGridList(commandMap.getMap());
	}
	
	/**
	 * 
	 * @메소드명	: wpsManageList
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명 
	 * 	<pre>
	 *			
	 * 	</pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> wpsManageList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsManageList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	@Override
	public Map<String, Object> wpsPositionCodeList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsPositionCodeList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	@Override
	public Map<String, Object> wpsApprovalCodeList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsApprovalCodeList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	@Override
	public Map<String, Object> wpsMetalCodeList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsMetalCodeList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	/**
	 * 
	 * @메소드명	: wpsFileUpLoad
	 * @날짜		: 2017. 10. 31.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> wpsFileUpLoad(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String basePath = "";
		String id = "";
		String SERVER_IP = "";
		String pass = "";
		String port = "";
		
		MultipartHttpServletRequest multi = (MultipartHttpServletRequest) request;
		Object formfile = multi.getFile("uploadFile");
		String wps_no = DisStringUtil.nullString(commandMap.get("i_wps_no"));
		
		try {
			commandMap.put("i_wps_id", "");
			commandMap.put("p_oper", "I");
			wpsDAO.insertWpsManageMaster(commandMap.getMap());
			
			// 프로시저 결과 받음
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			
		} catch (Exception e) {
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		List<Map<String, Object>> list = wpsDAO.getWpsServerInfoList();
		
		basePath = list.get(0).get("CODE_VALUE").toString();
		id = list.get(1).get("CODE_VALUE").toString();
		SERVER_IP = list.get(2).get("CODE_VALUE").toString();
		pass = list.get(3).get("CODE_VALUE").toString();
		port = list.get(4).get("CODE_VALUE").toString();

		String fileName = ((CommonsMultipartFile) formfile).getOriginalFilename();
		
		// 부품표준서 문서는 FTP 서버에 /WPSDWG 폴더에 Wps_no+파일형 형태로 저장됨. 예)
		// FCAW-31.PDF
		String fileType = fileName.substring(fileName.lastIndexOf("."), fileName.length());
		String saveFileName = "";
		saveFileName = wps_no + fileType.toUpperCase();			
		
		commandMap.getMap().put("file_name", saveFileName);

		//int insertResult = itemStandardUploadDAO.insertFileUpLoad(commandMap.getMap());		
		int insertResult = 1;
		
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
				/*if(ftpClient.changeWorkingDirectory(basePath + "/" + sCatalog) != true) {
					ftpClient.makeDirectory(basePath + "" + sCatalog);
				}*/
				
				ftpClient.changeWorkingDirectory(basePath + "/");

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
	public Map<String, Object> wpsManageSaveAction(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";
		
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList 			= commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		String gridPositionDataList 	= commandMap.get("positionResultList").toString();
		String gridApprovalDataList 	= commandMap.get("approvalResultList").toString();
		String gridMetalDataList 		= commandMap.get("metalResultList").toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList 				= new ObjectMapper().readValue(gridDataList, typeRef);
		List<Map<String, Object>> savePositionList 	= new ObjectMapper().readValue(gridPositionDataList, typeRef);
		List<Map<String, Object>> saveApprovalList 	= new ObjectMapper().readValue(gridApprovalDataList, typeRef);
		List<Map<String, Object>> saveMetalList 		= new ObjectMapper().readValue(gridMetalDataList, typeRef);
		
		// 결과값 최초
		String result = DisConstants.RESULT_FAIL;
		
		try {
			
			for (Map<String, Object> rowData : saveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
	
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				wpsDAO.wpsMasterSaveAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
			}
			
			for (Map<String, Object> rowData : savePositionList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
	
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				wpsDAO.wpsPositionSaveAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
				
				commandMap.put("wps_id", pkgParam.get("p_wps_id"));
			}
			
			for (Map<String, Object> rowData : saveApprovalList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
	
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				wpsDAO.wpsApprovalSaveAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
				
				commandMap.put("wps_id", pkgParam.get("p_wps_id"));
			}
			
			for (Map<String, Object> rowData : saveMetalList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
	
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				wpsDAO.wpsMetalSaveAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
				
				commandMap.put("wps_id", pkgParam.get("p_wps_id"));
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
		
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		// 3. 결과 리턴
		return commandMap.getMap();

	}
	
	@Override
	public Map<String, Object> wpsConfirmList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsConfirmList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	@Override
	public String wpsApprovalClassTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsApprovalClassTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	public String wpsPositionTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsPositionTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	public String wpsBaseMetalTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsBaseMetalTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveWpsConfirmAction(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";
		
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {
		};
		
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList 			= commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList 				= new ObjectMapper().readValue(gridDataList, typeRef);
		
		try {
			
			for (Map<String, Object> rowData : saveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
	
				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_user_id", 	commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				wpsDAO.saveWpsConfirmAction(pkgParam);
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
		
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		// 3. 결과 리턴
		return commandMap.getMap();

	}
	
	@Override
	public Map<String, Object> wpsChangeList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		
		Map<String, Object> resultData = wpsDAO.wpsChangeList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
		
	}
	
	@Override
	public String wpsChangeTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = wpsDAO.wpsChangeTypeSelectBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		// 첫 optison 선택 파라미터
		if (vType.equals("all")) {
			rtnString = "<option value=\"ALL\">ALL</option>";
		} else if (vType.equals("sel")) {
			rtnString = "<option value=\"\">선택</option>";
		}

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected"))  + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	
	
}

package stxship.dis.ems.adminNew.service;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.ems.adminNew.dao.EmsNewAdminDAO;
import stxship.dis.ems.common.dao.EmsCommonDAO;
import stxship.dis.ems.common.service.EmsCommonServiceImpl;

@Service("emsNewAdminService")
public class EmsNewAdminServiceImpl extends EmsCommonServiceImpl implements EmsNewAdminService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "emsNewAdminDAO")
	private EmsNewAdminDAO emsAdminDAO;

	@Resource(name = "emsCommonDAO")
	private EmsCommonDAO emsCommonDAO;
	
	/**
	 * 
	 * @메소드명	: selectEmsAdminMainList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * EMS Admin MainGrid Search
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectEmsAdminMainList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsAdminDAO.selectEmsAdminMainList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		result.put("totalCnt", listRowCnt);

		return result;
	}
	/**
	 * 
	 * @메소드명	: getEmsApprovedBoxDataList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems용 승인자 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getEmsApprovedBoxDataList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = emsAdminDAO.selectEmsApprovedBoxDataList(commandMap.getMap());

		String rtnString = "";
		String vType = DisStringUtil.nullString(commandMap.get("sb_type"));

		rtnString = "<option value=\"ALL\">ALL</option>";

		for (Map<String, Object> rowData : list) {
			rtnString += "<option value=\"" + DisStringUtil.nullString(rowData.get("sb_value")) + "\""
					+ DisStringUtil.nullString(rowData.get("sb_selected")) 
					+ " name=\"" + DisStringUtil.nullString(rowData.get("ATTR")) + "\">" 
					+ rowData.get("sb_name") + "</option>";
		}

		return URLEncoder.encode(rtnString, "UTF-8");
	}
	/**
	 * 
	 * @메소드명	: selectAutoCompleteDwgNoList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems 도면 자동완성
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String selectAutoCompleteDwgNoList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> list = emsAdminDAO.emsDwgNoList(commandMap.getMap());
		String rtnString = "";

		for (Map<String, Object> map : list) {
			if (!rtnString.equals("")) {
				rtnString += "|";
			}
			rtnString += map.get("object").toString();
		}

		return rtnString;
	}
	
	/**
	 * 
	 * @메소드명	: popUpAdminPosDownloadFile
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	추가 버튼 팝업창 : 파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View popUpAdminPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		Map<String, Object> rs = emsAdminDAO.popUpAdminPosDownloadFile(commandMap.getMap());
		modelMap.put("data", (byte[]) rs.get("file_blob"));
		modelMap.put("filename", (String) rs.get("file_name"));
		return new FileDownLoad();
	}
	/**
	 * 
	 * @메소드명	: selectPosChk
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *  POS전 검색 조건에서 project 및 dwg_no 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectPosChk(CommandMap commandMap) throws Exception {
		return emsAdminDAO.selectPosChk(commandMap.getMap());
	}
	
	
	/**
	 * 
	 * @메소드명	: popUpAdminNewSpecList
	 * @날짜		: 2017. 4. 25.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> popUpAdminNewSpecList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = emsAdminDAO.popUpAdminNewSpecList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");

		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;
		if(listData.size() > 0) {
			listRowCnt = listData.size();
			listRowCnt = listData.get(0).get("ALL_CNT").toString();
		}
		
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}

		// 결과값 생성
		Map<String, Object> resultList = new HashMap<String, Object>();
		resultList.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		resultList.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		resultList.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		resultList.put(DisConstants.GRID_RESULT_DATA, listData);
		resultList.put("totalCnt", listRowCnt);
		return resultList;
	}
	
	@Override
	public List<Map<String, Object>> popUpAdminSpecDownList(CommandMap commandMap) {
		return emsAdminDAO.selectEmsAdminSpecDownList(commandMap.getMap());
	}
	
	public String getFileContentType(String fileType){
		if (fileType.equals("hwp")){
			return "application/x-hwp";
		} else if (fileType.equals("pdf")){
			return "application/pdf";
		} else if (fileType.equals("ppt") || fileType.equals("pptx")){
			return "application/vnd.ms-powerpoint";
		} else if (fileType.equals("doc") || fileType.equals("docx")){
			return "application/msword";
		} else if (fileType.equals("xls") || fileType.equals("xlsx")){
			return "application/vnd.ms-excel";
		} else {
			return "application/octet-stream";
		}
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpEmsAdminNewConfirm(CommandMap commandMap)throws Exception {
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		
		result = emsAdminDAO.emsAdminDeleteTempProc(commandMap);
		
		if (result == 0 || !"S".equals(commandMap.get("p_error_code"))) {
			throw new DisException("Confrim호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		
		
		for (Map<String, Object> rowData : itemList) {
			rowData.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("p_work_key", commandMap.get("p_work_key"));
			
			result = emsAdminDAO.emsAdminInsertTempProc(rowData);

			if (result == 0 || !"S".equals(rowData.get("p_error_code"))) {
				throw new DisException("POS호출에 실패했습니다.\nErrorMsg:"+rowData.get("p_error_msg"));
			}
		}
		
		result = emsAdminDAO.emsAdminConfrimNReturnProc(commandMap);
		if (result == 0 || !"S".equals(commandMap.get("p_error_code"))) {
			throw new DisException("Confrim호출에 실패했습니다.\nErrorMsg:"+commandMap.get("p_error_msg"));
		}
		
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);			
	}
}

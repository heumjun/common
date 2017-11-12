package stxship.dis.bom.pending.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.bom.pending.dao.PendingDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileScanner;
import stxship.dis.common.util.GenericExcelView;

@Service("pendingService")
public class PendingServiceImpl extends CommonServiceImpl implements PendingService {
	
	@Resource(name = "pendingDAO")
	private PendingDAO pendingDAO;
	
	//프로젝트에 해당하는 마스터호선 반환.
	public String pendingMasterNo(CommandMap commandMap) {
		return pendingDAO.pendingMasterNo(commandMap.getMap());
	}

	/**
	 * @메소드명 : pendingList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트 결과.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	@JsonIgnore
	public Map<String, Object> pendingMainList(CommandMap commandMap) throws Exception {
		
		String p_project_no = "";
		p_project_no = commandMap.get("p_project_no").toString();
		
		if(p_project_no.equals("S4035") || p_project_no.equals("S4036")) {
			commandMap.put("p_dept_code", "ALL");
			commandMap.put("p_user_id", "ALL");
		}
		
		if(null == commandMap.get("p_chk_series")) {
			commandMap.put("p_chk_series", "");
		} 
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = pendingDAO.pendingMainList(commandMap.getMap());
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
	 * @메소드명 : pendingExcelExport
	 * @날짜 : 2016. 09. 28.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트 결과 Excel 다운로드
	 * @param commandMap
	 * @return
	 * @throws Exception
	 * 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public View pendingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		
		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
			String colColor = commandMap.get("p_col_color").toString();
			
			// 그리드의 헤더를 콜네임으로 설정
			for (String p_col_name : p_col_names) {
				colName.add(new String(p_col_name.getBytes("ISO_8859_1"),"UTF-8"));
			}
	
			// 리스트를 취득한다.
			Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
			Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);

			//Excel출력 페이지는 단일 페이지=1, 출력은 9999999건까지 제약조건
			curPageNo = "1"; 
			pageSize = "999999";
			
			commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
			commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
			
			Map<String, Object> resultData = pendingDAO.pendingMainList(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData.get("p_refer");
			
			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();
				
				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
				}
				colValue.add(row);
			}
			
			modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
			modelMap.put("colName", colName);
			modelMap.put("colColor", colColor);
			modelMap.put("colValue", colValue);
			
		}  catch (Exception e) {
			e.printStackTrace();
		}
		return new GenericExcelView();
	}
	
	/**
	 * @메소드명 : pendingAutoCompleteDwgNoList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인화면에서 부서에 해당하는 도면리스트 
	 * 		  ARK(Auto Recommand Keyword) 반환.
	 * @param commandMap
	 * @return
	 */
	public String selectAutoCompleteDwgNoList(CommandMap commandMap) {
		
		String vDeptCode = (String) DisSessionUtil.getAuthenticatedUser().get("dwg_dept_code");
		String p_dept_code = (String) commandMap.get("p_dept_code");
		String p_sel_dept = (String) commandMap.get("p_sel_dept");
		
		if(!p_dept_code.equals("") && !p_dept_code.equals("ALL")){
			vDeptCode = p_dept_code;
		}
		
		if(!p_sel_dept.equals("") && !p_sel_dept.equals("ALL")){
			vDeptCode = p_sel_dept;
		}
		commandMap.put("p_dept_code", vDeptCode);
		
		List<Map<String, Object>> list = pendingDAO.pendingDwgNoList(commandMap.getMap());
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
	 * @메소드명 : popupPendingWorkList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트에서 WORK 클릭시 SSC-Bom 내용 리스트 반환.
	 * @param commandMap
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> popupPendingWorkList(CommandMap commandMap) {
		
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = pendingDAO.popupPendingWorkList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		listRowCnt = resultData.get("p_cnt");
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
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

		return result;
	}

	//Pending-ADD 리스트 결과.
	//pending-ADD DWG 클릭 시 Popup 화면 호출
	//popupPendingAddGetDwgno 화면에서 도면리스트 반환.
	/**
	 * @메소드명 : popupPendingAddGetDwgnoList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : popupPendingAddGetDwgno 화면에서 도면리스트 반환.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> popupPendingAddGetDwgnoList(CommandMap commandMap) throws Exception {
		
		String vDeptCode = (String) DisSessionUtil.getAuthenticatedUser().get("DWG_DEPT_CODE");
		if(!commandMap.get("p_dept_code").toString().equals("")){
			vDeptCode = commandMap.get("p_dept_code").toString();
		}
		commandMap.put("vDeptCode", vDeptCode);
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = pendingDAO.popupPendingAddGetDwgnoList(commandMap.getMap());
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
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

		return result;
	}
	
	/**
	 * @메소드명 : pendingAddWorkExcelImportAction
	 * @날짜 : 2016. 09. 28.
	 * @작성자 : Cho HeumJun
	 * @설명 : pending-ADD 메인Grid에 Excel Import 실행.
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> pendingAddWorkExcelImportAction(CommandMap commandMap) throws Exception {
		return FileScanner.DecryptExcelToList((File) commandMap.get("file"), 1, true, 0);
	}
	
	/**
	 * @메소드명 : pendingWorkInsert
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 pending_work TempTable에 Insert.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingWorkInsert(CommandMap commandMap) throws Exception {
		
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> pendingAddList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		String sErrorMsg = "";
		int vItemGroup = 0;
		
		try {
			//pending Work 테이블 비움
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			pendingDAO.pendingWorkDelete(commandMap.getMap());

			for (Map<String, Object> rowData : pendingAddList) {
				
				String[] p_chk_series = commandMap.get("p_check_series").toString().split(",");
				vItemGroup++;
				
				for (String vSeries : p_chk_series) {
					
					Map<String, Object> pkgParam = new HashMap<String, Object>();
					
					pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
					pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
					pkgParam.put("p_state_flag", "A");
					pkgParam.put("p_project_no", vSeries);
					pkgParam.put("p_ship_type", rowData.get("ship_type"));
					pkgParam.put("p_block_no", rowData.get("block_no"));
					pkgParam.put("p_str_flag", rowData.get("str_flag"));
					pkgParam.put("p_usc_job_type", rowData.get("usc_job_type"));
					pkgParam.put("p_job_catalog", rowData.get("job_catalog"));
					pkgParam.put("p_dwg_no", rowData.get("dwg_no"));
					pkgParam.put("p_stage_no", rowData.get("stage_no"));
					pkgParam.put("p_job_cd", "");
					pkgParam.put("p_mother_code", "");
					pkgParam.put("p_item_catalog", "");
					
					pendingDAO.pendingWorkInsert(pkgParam);
					
					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
					String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));
	
					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
					
					// 여기까지 Exception 없으면 성공 메시지
					commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
				}
				
			}
		}  catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : pendingNextAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 TempTable 리스트 반환.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> pendingNextAction(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		commandMap.put("p_state_flag", "A");
		Map<String, Object> resultData = pendingDAO.pendingNextAction(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		Object ng_flag = resultData.get("p_ng_flag");
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		listRowCnt = resultData.get("p_cnt");
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
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
		result.put("p_ng_flag", ng_flag);

		return result;
	}
	
	/**
	 * @메소드명 : pendingWorkDelete
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 DELETE2 클릭 시 TempTable 데이터 삭제
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@Override
	public Map<String, Object> pendingWorkDelete(CommandMap commandMap) throws Exception {

		String sErrorMsg = "";
		
		try {

			String[] p_li_seq_id = commandMap.get("p_li_seq_id").toString().split(",");
			
			for (String li_seq_id : p_li_seq_id) {
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_li_seq_id", li_seq_id);
				
				pendingDAO.pendingWorkDelete(pkgParam);
				
				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
				
				// 여기까지 Exception 없으면 성공 메시지
				commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return commandMap.getMap();
		
	}
	
	/**
	 * @메소드명 : pendingApplyAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 Apply시 Pending 생성.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@Override
	public Map<String, Object> pendingApplyAction(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		
		try {
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			
			pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam.put("p_state_flag", "A");
			
			pendingDAO.pendingApplyAction(pkgParam);
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
			String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));
			
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : pendingDelWorkInsert
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 화면에서 pending_work TempTable에 Insert.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingDelWorkInsert(CommandMap commandMap) throws Exception {
		
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> pendingAddList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		String sErrorMsg = "";
		int vItemGroup = 0;
		
		try {
			//pending Work 테이블 비움
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			pendingDAO.pendingWorkDelete(commandMap.getMap());
			
			for (Map<String, Object> rowData : pendingAddList) {
				
				String[] p_chk_series = commandMap.get("p_check_series").toString().split(",");
				vItemGroup++;
				
				for (String vSeries : p_chk_series) {
					
					Map<String, Object> pkgParam = new HashMap<String, Object>();
					
					pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
					pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
					pkgParam.put("p_state_flag", "D");
					pkgParam.put("p_project_no", vSeries);
					pkgParam.put("p_ship_type", rowData.get("ship_type"));
					pkgParam.put("p_block_no", rowData.get("block_no"));
					pkgParam.put("p_str_flag", rowData.get("str_flag"));
					pkgParam.put("p_usc_job_type", rowData.get("usc_job_type"));
					pkgParam.put("p_job_catalog", rowData.get("job_catalog"));
					pkgParam.put("p_dwg_no", rowData.get("dwg_no"));
					pkgParam.put("p_stage_no", rowData.get("stage_no"));
					pkgParam.put("p_job_cd", "");
					pkgParam.put("p_mother_code", "");
					pkgParam.put("p_item_catalog", "");
					
					pendingDAO.pendingWorkInsert(pkgParam);
					
					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
					String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));
	
					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
					
					// 여기까지 Exception 없으면 성공 메시지
					commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
				}
			}
		}  catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : pendingDelNextAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 화면에서 pending_work TempTable에 Insert.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> pendingDelNextAction(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		commandMap.put("p_state_flag", "D");
		Map<String, Object> resultData = pendingDAO.pendingNextAction(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		Object ng_flag = resultData.get("p_ng_flag");
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		listRowCnt = resultData.get("p_cnt");
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
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
		result.put("p_ng_flag", ng_flag);

		return result;
	}
	
	/**
	 * @메소드명 : pendingDelApplyAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 화면에서 Apply시 Pending 삭제.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	@Override
	public Map<String, Object> pendingDelApplyAction(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		
		try {
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			
			pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam.put("p_state_flag", "D");
			
			pendingDAO.pendingDelApplyAction(pkgParam);
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
			String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));
			
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			
		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		return commandMap.getMap();
	}

	@Override
	public Map<String, Object> pendingChekedMainList(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			Map<String, Object> resultData = pendingDAO.pendingChekedMainList(commandMap.getMap());
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(resultData.get("p_error_msg"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
			// 리스트 총 사이즈를 구한다.
			Object listRowCnt = 0;
			if(listData.size() > 0) {
				listRowCnt = listData.size();
				listRowCnt = listData.get(0).get("ALL_CNT").toString();
			}
			
			listRowCnt = resultData.get("p_cnt");
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			}
			// 라스트 페이지를 구한다.
			Object lastPageCnt = "page>total";
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
				lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
			}
			
			result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
			result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
			result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
			result.put(DisConstants.GRID_RESULT_DATA, listData);
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
			
			// 여기까지 Exception 없으면 성공 메시지
			result.put(DisConstants.RESULT_MASAGE_KEY, "");
			
			
		} catch(Exception e) {
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return result;
	}
	
	/**
	 * @메소드명 : pendingModifyValidationCheck
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		수량 변경 및 무브 로직
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingModifyValidationCheck(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_WORK에 입력

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> pendingModifyWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sWorkKey = Long.toString(System.currentTimeMillis());

		try {
			
			// 무브 및 수량 변경 결과 행 입력
			for (Map<String, Object> rowData : pendingModifyWorkList) {

				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_item_type_cd", "PD");
				pkgParam.put("p_work_flag", "MODIFY_MOVE");
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
				pkgParam.put("p_state_flag", "C");
				pkgParam.put("p_chk_series", commandMap.get("p_chk_series"));
				pkgParam.put("p_pending_id", pkgParam.get("p_pending_rowid"));
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				pendingDAO.pendingModifyWorkInsert(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}

			// 2. Validation 체크 프로시저 호출
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_work_key", sWorkKey);
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			pendingDAO.pendingModifyValidation(commandMap.getMap());

			sErrorMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
			String sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}

	/**
	 * @메소드명 : pendingWorkValidationList
	 * @날짜 : 2015. 12. 29.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	WORK 테이블 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> pendingWorkValidationList(CommandMap commandMap) throws Exception {

		String sErrorMsg = "";
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		// 페이지 전처리
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			Map<String, Object> resultData = pendingDAO.pendingWorkValidationList(commandMap.getMap());
			List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(resultData.get("p_error_msg"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			// 리스트 총 사이즈를 구한다.
			Object listRowCnt = 0;
			if(listData.size() > 0) {
				listRowCnt = listData.size();
				listRowCnt = listData.get(0).get("ALL_CNT").toString();
			}
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			}
			// 라스트 페이지를 구한다.
			Object lastPageCnt = "page>total";
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
				lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
			}

			result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
			result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
			result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
			result.put(DisConstants.GRID_RESULT_DATA, listData);
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
			
			// 여기까지 Exception 없으면 성공 메시지
			result.put(DisConstants.RESULT_MASAGE_KEY, "");

		} catch(Exception e) {
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return result;
	}

	@Override
	public Map<String, Object> pendingModifyApplyAction(CommandMap commandMap) throws Exception {
		// 1. MOTHER_CODE 채번
		String sErrMsg = "";
		String sErrCode = "";

		// MotherCode 생성
		//sscMotherCodeCreate(commandMap);

		try {
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			pendingDAO.pendingModifyApplyAction(commandMap.getMap());

			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}

	/**
	 * @메소드명 : pendingBomApplyAction
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	BOM ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingBomApplyAction(CommandMap commandMap) throws Exception {

		//commandMap.put("p_ssc_sub_id", commandMap.get("p_ssc_sub_id").toString().split(","));
		try {
			
			String sErrMsg = "";
			String sErrCode = "";

			// ECO Validation 상태 확인
			Map<String, Object> ecoMap = pendingDAO.pendingEcoInfo(commandMap.getMap());

			String vStateCode = DisStringUtil.nullString(ecoMap.get("states_code"));

			if (vStateCode.equals("")) {
				throw new DisException("ECO를 잘못 입력하였습니다.");
			} else if (!vStateCode.equals("CREATE")) {
				throw new DisException("ECO의 상태가 Review 또는 Release면 이행할 수 없습니다.");
			} 

			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			commandMap.put("p_pending_id", commandMap.get("p_pending_id").toString());
			
			// ECO가 이상 없으면 연계
			pendingDAO.updatePendingHeadEcoNo(commandMap.getMap());
			
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
		} catch (Exception e) {
			//e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		return commandMap.getMap();
	}

	/**
	 * @메소드명 : pendingCancelAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	CANCEL Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingCancelAction(CommandMap commandMap) throws Exception {
		String sErrMsg = "";
		String sErrCode = "";
		
		String[] p_pending_id = commandMap.get("p_pending_id").toString().split(",");
		
		try {
			for (String vPendingId : p_pending_id) {
				
				commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commandMap.put("p_pending_id", vPendingId);
				
				pendingDAO.pendingCancelAction(commandMap.getMap());
				
				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));
				
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
			}
			
			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			
		} catch (Exception e) {
			//e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		return commandMap.getMap();
	}

	/**
	 * @메소드명 : sscRestoreAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Restore Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingRestoreAction(CommandMap commandMap) throws Exception {
		String sErrMsg = "";
		String sErrCode = "";

		String[] p_pending_id = commandMap.get("p_pending_id").toString().split(",");

		try {
			for (String vPendingId : p_pending_id) {

				commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commandMap.put("p_ssc_sub_id", vPendingId);

				pendingDAO.pendingRestoreAction(commandMap.getMap());

				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return commandMap.getMap();
	}

	/**
	 * @메소드명 : pendingDeleteTemp
	 * @날짜 : 2016. 12. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	ADD, DELETE 버튼 클릭 시 TEMP 테이블 비움
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> pendingDeleteTemp(CommandMap commandMap) throws Exception {
		String sErrMsg = "";
		String sErrCode = "";
		try {
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pendingDAO.pendingDeleteTemp(commandMap.getMap());

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return commandMap.getMap();
	}

	@Override
	public String getDwgnoList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = pendingDAO.getDwgnoList(commandMap.getMap());
		String rtnString = "";

		for (Map<String, Object> map : list) {
			if (!rtnString.equals("")) {
				rtnString += "|";
			}
			rtnString += map.get("value").toString();
		}

		return rtnString;
		
		//return pendingDAO.getDwgnoList(commandMap.getMap());
		
	}
	
}

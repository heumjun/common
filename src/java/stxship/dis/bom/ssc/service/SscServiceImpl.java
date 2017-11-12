package stxship.dis.bom.ssc.service;

import java.io.File;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.bom.ssc.dao.SscDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileScanner;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.common.util.GenericExcelView4;
import stxship.dis.eco.eco.dao.EcoDAO;
import stxship.dis.item.createItem.dao.CreateItemDAO;

@Service("sscService")
public class SscServiceImpl extends CommonServiceImpl implements SscService {
	Logger					log	= Logger.getLogger(this.getClass());

	@Resource(name = "sscDAO")
	private SscDAO			sscDAO;

	@Resource(name = "ecoDAO")

	private EcoDAO			ecoDAO;
	@Resource(name = "createItemDAO")
	private CreateItemDAO	createItemDAO;

	/**
	 * @메소드명 : selectMainList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		그리드 메인 리스트 (페이징 처리)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, Object> selectMainList(CommandMap commandMap) throws Exception {

		String p_project_no = "";
		p_project_no = commandMap.get("p_project_no").toString();
		
		if(p_project_no.equals("S4035") || p_project_no.equals("S4036")) {
			commandMap.put("p_dept_code", "ALL");
			commandMap.put("p_user_id", "ALL");
		}
		
		// 리스트를 취득한다.
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put("p_tribon_flag", "Y");
		
		Map<String, Object> resultData = sscDAO.selectMainList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		Object totalEa = "";
		Object totalWeight = "";
		Object totalLength = "";
		int cnt = listData.size();
		if(cnt > 0){
			listRowCnt = listData.get(0).get("ALL_CNT") == null ? "" : listData.get(0).get("ALL_CNT").toString();
			totalEa = listData.get(0).get("TOTAL_EA") == null ? "" : listData.get(0).get("TOTAL_EA").toString();
			totalWeight = listData.get(0).get("TOTAL_WEIGHT") == null ? "" : listData.get(0).get("TOTAL_WEIGHT").toString();
			totalLength = listData.get(0).get("TOTAL_LENGTH") == null ? "" : listData.get(0).get("TOTAL_LENGTH").toString();
		}
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
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
		result.put("totalCnt", listRowCnt);
		result.put("totalEa", totalEa);
		result.put("totalWeight", totalWeight);
		result.put("totalLength", totalLength);

		return result;
	}

	/**
	 * @메소드명 : sscMainExcelExport
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public View sscMainExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		/*
		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			

			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");

			// 그리드의 헤더를 콜네임으로 설정
			for (String p_col_name : p_col_names) {
				colName.add(new String(p_col_name.getBytes("ISO_8859_1"),"UTF-8"));
			}

			List<Map<String, Object>> itemList = sscDAO.selectMainList(commandMap.getMap());

			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();

				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
				}
				colValue.add(row);
			}

			// 오늘 날짜 구함 시작
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
			Date currentTime = new Date();
			String dateToday = formatter.format(currentTime);
			// 오늘 날짜 구함 끝

			modelMap.put("excelName", "SSC_MAIN_" + commandMap.get("p_project_no") + "_" + DisStringUtil.nullString(commandMap.get("p_dwg_no")).replaceAll("[*]", "") + dateToday);
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		
		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
			// 그리드의 헤더를 콜네임으로 설정
			for (String p_col_name : p_col_names) {
				colName.add(new String(p_col_name.getBytes("utf-8"),"utf-8"));
			}
	
			// 리스트를 취득한다.
			Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
			Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);

			//Excel출력 페이지는 단일 페이지=1, 출력은 9999999건까지 제약조건
			curPageNo = "1"; 
			pageSize = "999999";
			
			commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
			commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
			commandMap.put("p_tribon_flag", "Y");
			
			Map<String, Object> resultData = sscDAO.selectMainList(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData.get("p_refer");
			
			int totalEa = 0;
			double totalWeight = 0;
			
			int tot_f = 0;
            int tot_a = 0;
            int tot_p = 0;
			
			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();
				
				if(commandMap.get("p_item_type_cd").equals("PI")) {
					totalEa += Integer.parseInt(rowData.get("ea").toString());
					totalWeight += Integer.parseInt(rowData.get("ea").toString()) * Double.parseDouble(DisStringUtil.nullString(rowData.get("item_weight")));
					if(rowData.get("attr6").toString().equals("F")) {
						tot_f += 1;
					} else if(rowData.get("attr6").toString().equals("A")) {
						tot_a += 1;
					} else if(rowData.get("attr6").toString().equals("P")) {
						tot_p += 1;
					}
				}
				
				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
				}
				colValue.add(row);
			}

			DecimalFormat format = new DecimalFormat("#.##");
			
			modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
			modelMap.put("totalEa", totalEa);
			modelMap.put("totalWeight", format.format(totalWeight));
			modelMap.put("tot_f", tot_f);
			modelMap.put("tot_a", tot_a);
			modelMap.put("tot_p", tot_p);
			
		}  catch (Exception e) {
			e.printStackTrace();
		}
		
		if(commandMap.get("p_item_type_cd").equals("PI")) {
			return new GenericExcelView4();
		} else {
			return new GenericExcelView();
		}
		
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
	public String selectAutoCompleteDwgNoList(CommandMap commandMap) {
		List<Map<String, Object>> list = sscDAO.sscDwgNoList(commandMap.getMap());
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
	 * @메소드명 : sscAutoCompleteUscJobTypeList
	 * @날짜 : 2017. 03. 20.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 메인 USC_JOB_TYPE Auto Complete 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public String sscAutoCompleteUscJobTypeList(CommandMap commandMap) {
		List<Map<String, Object>> list = sscDAO.sscAutoCompleteUscJobTypeList(commandMap.getMap());
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
	 * @메소드명 : sscSeriesList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 시리즈 체크 박스 Service
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> sscSeriesList(CommandMap commandMap) {

		List<Map<String, Object>> list = null;
		String p_item_type_cd = DisStringUtil.nullString(commandMap.get("p_item_type_cd"));

		if (p_item_type_cd.equals("PA")) {
			list = sscDAO.sscPaintSeriesList(commandMap.getMap());
		} else {
			list = sscDAO.sscSeriesList(commandMap.getMap());
		}

		return list;
	}

	/**
	 * @메소드명 : sscPaintDwgNo
	 * @날짜 : 2016. 2. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Paint 기본 도면 번호
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public String sscPaintDwgNo(CommandMap commandMap) {
		return sscDAO.sscPaintDwgNo(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscRevText
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * rev 텍스트 박스 값 Service
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public String sscRevText(CommandMap commandMap) {
		return sscDAO.sscRevText(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscMasterNo
	 * @날짜 : 2016. 1. 6.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PROJECT를 이용해서 MASTER를 받아옴.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public String sscMasterNo(CommandMap commandMap) {
		return sscDAO.sscMasterNo(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscJobList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	JOB 리스트 받아옴.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> sscJobList(CommandMap commandMap) {
		Map<String, Object> resultData = sscDAO.sscJobList(commandMap.getMap());
		return (List<Map<String, Object>>)resultData.get("p_refer");
	}

	/**
	 * @메소드명 : sscValidationList
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Validation 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscAddValidationCheck(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_WORK에 입력

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscAddWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sWorkKey = Long.toString(System.currentTimeMillis());
		String p_item_type_cd = DisStringUtil.nullString(commandMap.get("p_item_type_cd"));
		int vItemGroup = 0;

		try {
			for (Map<String, Object> rowData : sscAddWorkList) {
				// p_chk_series의 순대로 돌림.
				// 돌림
				vItemGroup++;
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				
				if("".equals(pkgParam.get("p_item_category_code")) || pkgParam.get("p_item_category_code") == null ){
					if(pkgParam.get("p_item_code").toString().indexOf("-") > -1 ){
						pkgParam.put("p_item_category_code", pkgParam.get("p_item_code").toString().substring(0, pkgParam.get("p_item_code").toString().indexOf("-")));
					}
				}
				
				pkgParam.put("p_master_ship", commandMap.get("p_master_no"));
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_item_type_cd", p_item_type_cd);
				pkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
				pkgParam.put("p_modify_buy_mother_code", commandMap.get("p_modify_buy_mother_code"));
				pkgParam.put("p_move_buy_buy_flag", commandMap.get("p_move_buy_buy_flag"));
				pkgParam.put("p_state_flag", "A");
				pkgParam.put("p_work_flag", "ADD");
				pkgParam.put("p_chk_series", commandMap.get("p_chk_series"));
				pkgParam.put("p_item_group", Integer.toString(vItemGroup));
				
				if(p_item_type_cd.equals("PA")) {
					pkgParam.put("p_block_no", "PA");
					pkgParam.put("p_str_flag", "PA");
					pkgParam.put("p_usc_job_type", "N/A");
				}
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscWorkInsert(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
/* 				for (String vSeries : p_chk_series) {
					Map<String, Object> pkgParam = new HashMap<String, Object>();

					// 1.1 STX_DIS_WORK 에 입력

					// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
					for (String key : rowData.keySet()) {
						pkgParam.put("p_" + key, rowData.get(key));
					}

					// 필요한 값 셋팅
					pkgParam.put("p_work_key", sWorkKey);
					pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
					pkgParam.put("p_state_flag", "A");
					pkgParam.put("p_work_flag", "ADD");
					pkgParam.put("p_project_no", vSeries);
					pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
					pkgParam.put("p_master_ship", commandMap.get("p_master_no"));
					pkgParam.put("p_item_type_cd", commandMap.get("p_item_type_cd"));
					pkgParam.put("p_rev_no", commandMap.get("p_rev_no"));
					// 아이템 코드 채번을 위한 group seq 채번
					pkgParam.put("p_item_group", Integer.toString(vItemGroup));
					
					// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
					sscDAO.sscWorkInsert(pkgParam);

					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
					String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
				}
*/
			}

			// 2. Validation 체크 프로시저 호출
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_work_key", sWorkKey);
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			sscDAO.sscAddValidation(commandMap.getMap());

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
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscAddValidationCheckStage(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_WORK에 입력

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscAddWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sWorkKey = Long.toString(System.currentTimeMillis());
		String p_item_type_cd = DisStringUtil.nullString(commandMap.get("p_item_type_cd"));
		//int vItemGroup = 0;
		
		try {
			for (Map<String, Object> rowData : sscAddWorkList) {
				// p_chk_series의 순대로 돌림.
				// 돌림
				//vItemGroup++;
				
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_master_ship", commandMap.get("p_master_no"));
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_item_type_cd", p_item_type_cd);
				pkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
				pkgParam.put("p_modify_buy_mother_code", commandMap.get("p_modify_buy_mother_code"));
				pkgParam.put("p_move_buy_buy_flag", commandMap.get("p_move_buy_buy_flag"));
				pkgParam.put("p_state_flag", "A");
				pkgParam.put("p_work_flag", "ADD");
				pkgParam.put("p_chk_series", pkgParam.get("p_project_no"));
				//pkgParam.put("p_item_group", commandMap.get("vItemGroup").toString());
				
				if("".equals(pkgParam.get("p_item_category_code")) || pkgParam.get("p_item_category_code") == null ){
					if(pkgParam.get("p_item_code").toString().indexOf("-") > -1 ){
						pkgParam.put("p_item_category_code", pkgParam.get("p_item_code").toString().substring(0, pkgParam.get("p_item_code").toString().indexOf("-")));
					}
				}
				
				if(p_item_type_cd.equals("PA")) {
					pkgParam.put("p_block_no", "PA");
					pkgParam.put("p_str_flag", "PA");
					pkgParam.put("p_usc_job_type", "N/A");
				}
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscWorkInsert(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
/* 				for (String vSeries : p_chk_series) {
					Map<String, Object> pkgParam = new HashMap<String, Object>();

					// 1.1 STX_DIS_WORK 에 입력

					// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
					for (String key : rowData.keySet()) {
						pkgParam.put("p_" + key, rowData.get(key));
					}

					// 필요한 값 셋팅
					pkgParam.put("p_work_key", sWorkKey);
					pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
					pkgParam.put("p_state_flag", "A");
					pkgParam.put("p_work_flag", "ADD");
					pkgParam.put("p_project_no", vSeries);
					pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
					pkgParam.put("p_master_ship", commandMap.get("p_master_no"));
					pkgParam.put("p_item_type_cd", commandMap.get("p_item_type_cd"));
					pkgParam.put("p_rev_no", commandMap.get("p_rev_no"));
					// 아이템 코드 채번을 위한 group seq 채번
					pkgParam.put("p_item_group", Integer.toString(vItemGroup));
					
					// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
					sscDAO.sscWorkInsert(pkgParam);

					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
					String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
				}
*/
			}

			// 2. Validation 체크 프로시저 호출
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_work_key", sWorkKey);
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			sscDAO.sscAddValidation(commandMap.getMap());

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
	 * @메소드명 : sscWorkValidationList
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
	public Map<String, Object> sscWorkValidationList(CommandMap commandMap) throws Exception {

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
			Map<String, Object> resultData = sscDAO.sscWorkValidationList(commandMap.getMap());
			List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(resultData.get("p_error_msg"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			// 리스트 총 사이즈를 구한다.
			Object listRowCnt = listData.size();
			listRowCnt = resultData.get("p_cnt");
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			}
			// 라스트 페이지를 구한다.
			Object lastPageCnt = "page>total";
			if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
				lastPageCnt = DisPageUtil.getPageCount(commandMap.get(DisConstants.SET_DB_PAGE_SIZE), listRowCnt);
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
	 * @메소드명 : sscAddBackList
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Next1 이후 BACK 버튼을 이용해서 첫 화면으로 돌아갈 때 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscAddBackList(CommandMap commandMap) throws Exception {
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		return sscDAO.sscAddBackList(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscAddItemCreate
	 * @날짜 : 2016. 1. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	1. MOTHER ITEM 채번 (ECO 이행)
	 *  2. ITEM CODE 채번
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscAddItemCreate(CommandMap commandMap) throws Exception {

		String sErrorMsg = "";
		String sErrCode = "";
		String sEcoNo = "";
		String vWorkKey = commandMap.get("p_work_key").toString();
		String vItemTypeCd = commandMap.get("p_item_type_cd").toString();
		commandMap.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		try {
			// 1.MOTHER_CODE 채번
			sscMotherCodeCreate(commandMap);

			// 1.E MOTHER CODE 채번 및 ECO 이행 끝

			// 2. ITEM CODE 채번
			// 2.2 DB에서 ITEM_CODE 채번 대상 받아옴
			List<Map<String, Object>> itemCreateList = sscDAO.sscAddItemCreateList(commandMap.getMap());

			// OU. Mark No.동일하면 같은 item code 체크를 위함.	
			int checkCount = 0;			
			List<Map<String, Object>> tempOUItemList = new ArrayList<Map<String,Object>>();
			
			// 2.3 ITEM CODE 채번 및 STX_DIS_ITEM 에 입력			
			for (Map<String, Object> rowData : itemCreateList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_key_no", rowData.get("attr01_desc"));
				pkgParam.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// TEMP 입력 사항들 아이템에 입력
				/*
				if (vItemTypeCd.equals("OU")) {
					pkgParam.put("p_detail", commandMap.get("temp01"));
				}
				*/
				// Valve의 경우 Item 복사 채번을 위해 item code를 넣는다.
				if (vItemTypeCd.equals("VA")) {
					
					String vItemCode = "";
					
					if(rowData.get("item_code") != null) {
						// 표준품이면
						vItemCode = rowData.get("item_code").toString();
						if (!vItemCode.substring(0, 1).equals("Z")) {
							pkgParam.put("p_attr_list", vItemCode);
						}
					}
					
				}
				
				// SE, TR 표준품인 경우 복사 채번을 위해 item code를 넣는다.
				if (rowData.get("paint_flag").toString().equals("Y")){
					String vItemCode = rowData.get("item_code").toString();
					pkgParam.put("p_attr_list", vItemCode);
				}

				if(!vItemTypeCd.equals("OU")){
					// 아이템 생성 프로시저 호출
					createItemDAO.insertItemCodeCreate(pkgParam);
				}else{
					
					boolean sameflag = false;
					String temp_item_code = "";
					String temp_key_no = "";					
		
					// OU일때, ADD 대상 내에 동일한 Mark NO가 있으면 동일한 코드 사용해야함 
					if(checkCount == 0)
					{
					 	createItemDAO.insertItemCodeCreate(pkgParam);
					 	
					 	temp_item_code = DisStringUtil.nullString(pkgParam.get("p_item_code"));
					 	temp_key_no = DisStringUtil.nullString(pkgParam.get("p_key_no"));
					 	
					 	Map<String, Object> tempOUMap = new HashMap<String, Object>();
					 	tempOUMap.put("temp_item_code", temp_item_code);
					 	tempOUMap.put("temp_key_no", temp_key_no);
					 	tempOUItemList.add(tempOUMap);
					} else { 
						String sKeyNo = pkgParam.get("p_key_no").toString();
						for (Map<String, Object> tempData : tempOUItemList) {
							String tempKeyNo = String.valueOf(tempData.get("temp_key_no"));
							
							// ADD 화면 대상 중 Key No가 동일한 것이 있으면 기존 채번 코드 활용
							if(sKeyNo.equals(tempKeyNo)){
								sameflag = true;
								temp_item_code = String.valueOf(tempData.get("temp_item_code"));
								pkgParam.put("p_item_code", temp_item_code);
							}							
						}
						
						// 동일한 Key No에 채번된 코드가 없으면 신규 생성
						if(!sameflag)
						{
						 	createItemDAO.insertItemCodeCreate(pkgParam);
						 	
						 	temp_item_code = DisStringUtil.nullString(pkgParam.get("p_item_code"));
						 	temp_key_no = DisStringUtil.nullString(pkgParam.get("p_key_no"));
						 	
						 	Map<String, Object> tempOUMap = new HashMap<String, Object>();
						 	tempOUMap.put("temp_item_code", temp_item_code);
						 	tempOUMap.put("temp_key_no", temp_key_no);
						 	tempOUItemList.add(tempOUMap);	
						}
					}
				}
				

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));
				String sItemCode = DisStringUtil.nullString(pkgParam.get("p_item_code"));

				// 오류가 있으면 Exception
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}

				// 3. STX_DIS_WORK 테이블에 ITEM CODE 덮어씀.
				pkgParam.put("p_item_code", sItemCode);
				pkgParam.put("p_work_key", vWorkKey);

				// WORK TABLE에 입력
				String buy_buy_flag = DisStringUtil.nullString(pkgParam.get("p_buy_buy_flag"));
				int isOk = 0;
				int isMotherOk = 0;
				if("N".equals(buy_buy_flag)){
					isOk = sscDAO.updateSscAddWorkItemCode(pkgParam);
				}
				else{
					isOk = sscDAO.updateSscBuyBuyAddWorkItemCode(pkgParam);
					isMotherOk = sscDAO.updateSscMotherBuyAddWorkItemCode(pkgParam);
				}
				
				// 오류가 있으면 Exception
				if (isOk < 1) {
					throw new DisException(sErrorMsg);
				}

				// 3. Valve의 경우 MOTHER BUY 생성 ([TEMP]아이템 코드 복사)
				if (vItemTypeCd.equals("VA")) {
					// 3.1 Valve Buy MOTHER CODE 채번한 항목 WORK TABLE에 업데이트
					sscDAO.updateSscAddValveMotherBuyCode(commandMap.getMap());
				}
				
				checkCount++;
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		} finally {
			// ITEM_CODE와 MOTHER_CODE에 오류 표시

			sscDAO.updateSscWorkItemCodeValidation(commandMap.getMap());
			sErrorMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));
		}

		// 3. 결과 리턴
		return commandMap.getMap();
	}

	/**
	 * @메소드명 : sscAddApplyAction
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC APPLY
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscAddApplyAction(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_HEAD에 입력
		String sErrorMsg = "";
		String sErrCode = "";
		String vItemTypeCd = commandMap.get("p_item_type_cd").toString();
		try {
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			// WORK KEY COMMANDMAP에 들어가있음.
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			sscDAO.procInsertSscAddHead(commandMap.getMap());

			sErrorMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}

			// VALVE 인경우 RAWMATERIAL 입력
			/*if (vItemTypeCd.equals("VA")) {
				sscDAO.procInsertSscAddRawLevel(commandMap.getMap());
				sErrorMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));
			}*/
			
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
	 * @메소드명 : sscAddExcelImportAction
	 * @날짜 : 2016. 1. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	엑셀 업로드 Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscAddExcelImportAction(CommandMap commandMap) throws Exception {
		return FileScanner.DecryptExcelToList((File) commandMap.get("file"), 1, true, 0);
		//암호화 복호화 파일업로드 적용 해지
		//return FileScanner.excelToList((MultipartFile) commandMap.get("file"), 1, true, 0);
	}

	/**
	 * @메소드명 : sscAddTribonMainList
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	TBC ADD TRIBON MAIN LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscAddTribonMainList(CommandMap commandMap) throws Exception {
		DisPageUtil.actionPageBefore(commandMap);

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = sscDAO.sscAddTribonMainList(commandMap.getMap());

			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * @메소드명 : sscAddEmsMainList
	 * @날짜 : 2016. 3. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC EMS MAIN LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscAddEmsMainList(CommandMap commandMap) throws Exception {
		DisPageUtil.actionPageBefore(commandMap);

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = sscDAO.sscAddEmsMainList(commandMap.getMap());

			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * @메소드명 : sscAddTribonTransferList
	 * @날짜 : 2016. 1. 12.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Tribon Transfer 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscAddTribonTransferList(CommandMap commandMap) throws Exception {
		commandMap.put("p_cad_sub_id", DisStringUtil.nullString(commandMap.get("p_cad_sub_id")).split(","));
		return sscDAO.sscAddTribonTransferList(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscAddEmsTransferList
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS TRANSFER LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscAddEmsTransferList(CommandMap commandMap) throws Exception {
		commandMap.put("p_ems_pur_no", DisStringUtil.nullString(commandMap.get("p_ems_pur_no")).split(","));
		return sscDAO.sscAddEmsTransferList(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscChekedMainList
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Main 체크 된 ITEM 리스트
	 *	1. Modify Main에서 사용
	 *  2. Delete Main에서 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> sscChekedMainList(CommandMap commandMap) throws Exception {
		
		String sErrorMsg = "";
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			Map<String, Object> resultData = sscDAO.sscChekedMainList(commandMap.getMap());
			// 프로시저 결과 받음
			sErrorMsg = DisStringUtil.nullString(resultData.get("p_error_msg"));
			// 오류가 있으면 스탑
			if (!"".equals(sErrorMsg)) {
				throw new DisException(sErrorMsg);
			}
			
			List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
			
			// 리스트 총 사이즈를 구한다.
			Object listRowCnt = 0;
			listRowCnt = listData.get(0).get("all_cnt").toString();
			
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
	 * @메소드명 : sscModifyEaValidationCheck
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
	public Map<String, Object> sscModifyValidationCheck(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_WORK에 입력

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscModifyWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sWorkKey = Long.toString(System.currentTimeMillis());
		String p_item_type_cd = DisStringUtil.nullString(commandMap.get("p_item_type_cd"));

		try {

			// 무브 및 수량 변경 결과 행 입력
			for (Map<String, Object> rowData : sscModifyWorkList) {

				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_item_type_cd", p_item_type_cd);
				pkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
				pkgParam.put("p_modify_buy_mother_code", commandMap.get("p_modify_buy_mother_code"));
				pkgParam.put("p_move_buy_buy_flag", commandMap.get("p_move_buy_buy_flag"));
				pkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
				pkgParam.put("p_state_flag", "C");

				if("".equals(pkgParam.get("p_item_category_code")) || pkgParam.get("p_item_category_code") == null ){
					if(pkgParam.get("p_item_code").toString().indexOf("-") > -1 ){
						pkgParam.put("p_item_category_code", pkgParam.get("p_item_code").toString().substring(0, pkgParam.get("p_item_code").toString().indexOf("-")));
					}
				}
				
				if(!p_item_type_cd.equals("PA")) {
					pkgParam.put("p_temp05", "Y");
				}
				pkgParam.put("p_chk_series", commandMap.get("p_chk_series"));
				//TR 일때
				if(p_item_type_cd.equals("TR")){
					
					//MODIFY_MOVE 이면 문자열 변환
					if(commandMap.get("p_work_flag").equals("MODIFY_MOVE")){
						
						//Tray EA = 'Y' 경우 문자열 비교하여 자르기
						commandMap.put("catalog_code", rowData.get("item_catalog"));
						commandMap.put("design_code", "TRAY EA");
						Map<String, Object> resultCnt = sscDAO.getCatalogDesign(commandMap.getMap());
						if(!resultCnt.get("cnt").toString().equals("0")){
							//문자 배열 선언
							String trayNo[] = rowData.get("key_no").toString().split(",");       //기존 TrayNo.
							String trayNoModify[] = rowData.get("temp07").toString().split(","); //입력받은 TrayNo.
							String trayNoAfter = ""; //MOVE 후에 남은 TrayNo
							
							int equalCount = 0;
							
							for(int i=0; i<trayNoModify.length; i++){
								for(int j=0; j<trayNo.length; j++){
									if(trayNoModify[i].equals(trayNo[j])){
										equalCount +=1;
										trayNo[j] = "";
										break;
									}
								}
							}
							//총 갯수와 존재하는 갯수가 일치하지 않으면 에러
							if(trayNoModify.length != equalCount){
								commandMap.put("error_ssc_sub_id", rowData.get("ssc_sub_id").toString());
								sErrorMsg = "변경 TrayNo가 기존에 존재하지 않습니다.";
								throw new DisException(sErrorMsg);
								//throw new commandMap.getMap();
							}
							
							//변경후 남은 TrayNo.값 조합
							for(int i=0; i<trayNo.length; i++){
								if(!"".equals(trayNo[i])){
									trayNoAfter += trayNo[i];
									if(i+1 != trayNo.length) trayNoAfter += ",";
								}
							}
							//마지막 값에 ','가 있으면 제거
							if(trayNoAfter.lastIndexOf(",") == trayNoAfter.length()-1 && trayNoAfter.lastIndexOf(",") != -1){
								trayNoAfter = trayNoAfter.substring(0, trayNoAfter.length()-1);
							}
							pkgParam.put("p_temp08", trayNoAfter);
						}
					}
					//MODIFY_EA 경우
					else{
						//Tray EA = 'Y' 경우 필입력 확인
						commandMap.put("catalog_code", rowData.get("item_catalog"));
						commandMap.put("design_code", "TRAY EA");
						Map<String, Object> resultCnt = sscDAO.getCatalogDesign(commandMap.getMap());
						if(!resultCnt.get("cnt").toString().equals("0")){
							String trayNoModify = rowData.get("temp07").toString(); //입력받은 TrayNo.
							if(trayNoModify.equals("")){
								commandMap.put("error_ssc_sub_id", rowData.get("ssc_sub_id").toString());
								sErrorMsg = "해당 표준품은 TrayNo 필수입력 입니다.";
								throw new DisException(sErrorMsg);
							}
						}
					}
				}
				if(p_item_type_cd.equals("PA")) {
					pkgParam.put("p_block_no", "PA");
					pkgParam.put("p_str_flag", "PA");
					pkgParam.put("p_usc_job_type", "N/A");
				}
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscWorkInsert(pkgParam);

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
			commandMap.put("p_move_dwg_no", commandMap.get("h_move_dwg_no"));

			sscDAO.sscModifyValidation(commandMap.getMap());

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
	 * @메소드명 : sscModifyApplyAction
	 * @날짜 : 2016. 1. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Modify Apply 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscModifyApplyAction(CommandMap commandMap) throws Exception {

		// 1. MOTHER_CODE 채번
		String sErrMsg = "";
		String sErrCode = "";

		// MotherCode 생성
		sscMotherCodeCreate(commandMap);

		try {
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			sscDAO.sscModifyApplyAction(commandMap.getMap());

			sErrMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

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
	 * @메소드명 : sscDeleteValidationCheck
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscDeleteValidationCheck(CommandMap commandMap) throws Exception {
		// 1. 모든 리스트 STX_DIS_WORK에 입력

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscDeleteWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";
		String sWorkKey = Long.toString(System.currentTimeMillis());

		try {

			for (Map<String, Object> rowData : sscDeleteWorkList) {
				// p_chk_series의 순대로 돌림.
				String[] p_chk_series = commandMap.get("p_chk_series").toString().split(",");

				// 체크된 시리즈가 없으면 그리드의 리스트 그대로 LOOP 진행
				if (p_chk_series[0].equals("")) {
					Map<String, Object> pkgParam = new HashMap<String, Object>();

					// 1.1 STX_DIS_WORK 에 입력

					// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
					for (String key : rowData.keySet()) {
						pkgParam.put("p_" + key, rowData.get(key));
					}
					
					// 필요한 값 셋팅
					if(rowData.get("buy_buy_flag").equals("Y")){
						pkgParam.put("p_delete_type", "R");
					}else{
						pkgParam.put("p_delete_type", "S");
					}
					pkgParam.put("p_work_key", sWorkKey);
					pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
					pkgParam.put("p_temp01", rowData.get("ssc_sub_id").toString());
					pkgParam.put("p_item_type_cd", commandMap.get("p_item_type_cd"));
					pkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
					pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
					

					// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
					sscDAO.sscWorkDelete(pkgParam);

					// 프로시저 결과 받음
					sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
					String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

					// 오류가 있으면 스탑
					if (!"".equals(sErrorMsg)) {
						throw new DisException(sErrorMsg);
					}
				} else {
					// 시리즈가 체크 되었으면 시리즈 기준으로 MODIFY 로직 실행
					for (String vSeries : p_chk_series) {
						Map<String, Object> pkgParam = new HashMap<String, Object>();

						// 1.1 STX_DIS_WORK 에 입력

						// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
						for (String key : rowData.keySet()) {
							pkgParam.put("p_" + key, rowData.get(key));
						}

						// 필요한 값 셋팅
						if(rowData.get("buy_buy_flag").equals("Y")){
							pkgParam.put("p_delete_type", "R");
						}else{
							pkgParam.put("p_delete_type", "S");
						}
						pkgParam.put("p_work_key", sWorkKey);
						pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
						pkgParam.put("p_temp01", rowData.get("ssc_sub_id").toString());
						pkgParam.put("p_project_no", vSeries);
						pkgParam.put("p_item_type_cd", commandMap.get("p_item_type_cd"));
						pkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
						pkgParam.put("p_temp05", "Y");
						pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));

						// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
						sscDAO.sscWorkDelete(pkgParam);

						// 프로시저 결과 받음
						sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
						String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

						// 오류가 있으면 스탑
						if (!"".equals(sErrorMsg)) {
							throw new DisException(sErrorMsg);
						}
					}
				}
			}

			// 2. Validation 체크 프로시저 호출 : 2016-10-05 삭제, 
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_work_key", sWorkKey);
			//commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			//sscDAO.sscDeleteValidation(commandMap.getMap());

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
	 * @메소드명 : sscDeleteApplyAction
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Delete Apply
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscDeleteApplyAction(CommandMap commandMap) throws Exception {

		// 1. MOTHER_CODE 채번
		String sErrMsg = "";
		String sErrCode = "";

		// MotherCode 생성
		sscMotherCodeCreate(commandMap);

		try {
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			sscDAO.sscDeleteApplyAction(commandMap.getMap());

			sErrMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

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
	 * @메소드명 : sscBomAction
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
	public Map<String, Object> sscBomApplyAction(CommandMap commandMap) throws Exception {

		//commandMap.put("p_ssc_sub_id", commandMap.get("p_ssc_sub_id").toString().split(","));
		try {
			
			String sErrMsg = "";
			String sErrCode = "";

			// ECO Validation 상태 확인
			Map<String, Object> ecoMap = sscDAO.sscEcoInfo(commandMap.getMap());
						
			String vStateCode = "";			
			if(ecoMap != null)
			{
				vStateCode = DisStringUtil.nullString(ecoMap.get("states_code"));
			}			

			if (vStateCode.equals("")) {
				throw new DisException("ECO를 잘못 입력하였습니다.");
			} else if (!vStateCode.equals("CREATE")) {
				throw new DisException("ECO의 상태가 Review 또는 Release면 이행할 수 없습니다.");
			} 

			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			commandMap.put("p_ssc_sub_id", commandMap.get("p_ssc_sub_id").toString());
			
			// ECO가 이상 없으면 연계
			sscDAO.updateSscHeadEcoNo(commandMap.getMap());
			
			sErrMsg = DisStringUtil.nullString(commandMap.get("P_ERR_MSG"));
			sErrCode = DisStringUtil.nullString(commandMap.get("P_ERR_CODE"));

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
	 * @메소드명 : sscAllBomApplyAction
	 * @날짜 : 2016. 11. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	ALL BOM Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscAllBomApplyAction(CommandMap commandMap) throws Exception {

		try {
			
			String sErrMsg = "";
			String sErrCode = "";
			
			// ECO Validation 상태 확인			
			Map<String, Object> ecoMap = sscDAO.sscEcoInfo(commandMap.getMap());

			String vStateCode = "";			
			if(ecoMap != null)
			{
				vStateCode = DisStringUtil.nullString(ecoMap.get("states_code"));
			}

			if (vStateCode.equals("")) {
				throw new DisException("ECO를 잘못 입력하였습니다.");
			} else if (!vStateCode.equals("CREATE")) {
				throw new DisException("ECO의 상태가 Review 또는 Release면 이행할 수 없습니다.");
			} 			

			String itemTypeCd = (String) commandMap.get("p_item_type_cd");
			commandMap.put("p_user_id", commandMap.get("loginId"));
			
			//if("PI".equals(itemTypeCd)){
				
			//}
			//else if("OU".equals(itemTypeCd)){
			sscDAO.sscAllBomApplyAction(commandMap.getMap());
			//}
			
			
			sErrMsg = DisStringUtil.nullString(commandMap.get("P_ERR_MSG"));
			sErrCode = DisStringUtil.nullString(commandMap.get("P_ERR_CODE"));

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
	 * @메소드명 : sscMotherCodeCreate
	 * @날짜 : 2016. 1. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	MOTHER CODE 채번 생성 이관
	 *     </pre>
	 * 
	 * @param commandMap
	 * @throws Exception
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void sscMotherCodeCreate(CommandMap commandMap) throws Exception {
		// 1. MOTHER_CODE 채번
		String sErrMsg = "";
		String sErrCode = "";
		String sEcoNo = "";

		String vWorkKey = commandMap.get("p_work_key").toString();

		// 1.1 채번 대상을 받는다.
		List<Map<String, Object>> motherCreateList = sscDAO.sscAddMotherCreateList(commandMap.getMap());

		// 1.2 ECO 생성 시작: Mother를 생성할 리스트가 있으면
		if (motherCreateList.size() > 0) {

			// ECO 생성
			Map<String, Object> pkgParam = new HashMap<String, Object>();
			pkgParam.put("p_permanent_temporary_flag", "7");
			pkgParam.put("p_loginid", (String) commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam.put("p_main_description", "SSC AUTO CREATE");
			ecoDAO.stxDisEcoMasterInsertProc(pkgParam);
			// 애러체크
			String err_code = DisStringUtil.nullString(pkgParam.get("p_err_code"));
			String error_msg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
			// ECO 받아옴.
			sEcoNo = DisStringUtil.nullString(pkgParam.get("p_eng_change_order_code"));
			if (!"S".equals(err_code)) {
				throw new DisException();
			}

			Map<String, Object> pkgParam2 = new HashMap<String, Object>();
			pkgParam2.put("p_eng_change_order_code", pkgParam.get("p_eng_change_order_code"));
			pkgParam2.put("p_eng_change_order_desc", "Auto Pending Mother Create");
			pkgParam2.put("p_permanent_temporary_flag", "7");
			pkgParam2.put("p_eco_cause", "F16");
			pkgParam2.put("p_design_engineer", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam2.put("p_manufacturing_engineer", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam2.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgParam2.put("p_eng_change_req_code", "");

			ecoDAO.stxDisEcoDetailInsertProc(pkgParam2);
			err_code = DisStringUtil.nullString(pkgParam2.get("p_err_code"));
			error_msg = DisStringUtil.nullString(pkgParam2.get("p_err_msg"));

			if (!"S".equals(err_code)) {
				throw new DisException(error_msg);
			}

			Map<String, Object> pkgHisParam = new HashMap<String, Object>();
			pkgHisParam.put("p_eco_name", pkgParam.get("p_eng_change_order_code"));
			pkgHisParam.put("p_action_type", "INSERT");
			pkgHisParam.put("p_insert_empno", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgHisParam.put("p_related_ecr", "");
			pkgHisParam.put("p_type", "잠정");
			pkgHisParam.put("p_eco_cause", "Auto Pending Mother Create");
			pkgHisParam.put("p_design_engineer", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgHisParam.put("p_manufacturing_engineer", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			pkgHisParam.put("p_states_code", "Create");
			pkgHisParam.put("p_eco_description", "SSC AUTO CREATE");
			ecoDAO.insertEcoHistory(pkgHisParam);

			err_code = DisStringUtil.nullString(pkgHisParam.get("p_error_code"));
			error_msg = DisStringUtil.nullString(pkgHisParam.get("p_error_msg"));

			if (!"S".equals(err_code)) {
				throw new DisException(error_msg);
			}

			// 1.2 ECO 생성 끝

			// 1.3 MOTHER CODE 채번 및 STX_DIS_ITEM
			for (Map<String, Object> rowData : motherCreateList) {
				Map<String, Object> createPkgParam = new HashMap<String, Object>();

				for (String key : rowData.keySet()) {
					createPkgParam.put("p_" + key, rowData.get(key));
				}
				createPkgParam.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				createPkgParam.put("p_weight", "0");
				createPkgParam.put("p_dept_code", commandMap.get("p_dept_code"));

				// 해당 CATALOG 속성의 DWG항목 ATTR 넘버를 찾음
				String attrDwg = sscDAO.sscAddMotherAttrDwg(rowData);
				if(attrDwg != null) createPkgParam.put("p_attr"+attrDwg+"_desc", rowData.get("dwg_no"));
				
				// 아이템 생성 프로시저 호출
				createItemDAO.insertItemCodeCreate(createPkgParam);

				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(createPkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(createPkgParam.get("p_err_code"));
				String sMotherCode = DisStringUtil.nullString(createPkgParam.get("p_item_code"));

				// 오류가 있으면 Exception
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}

				// 1.4 PENDING TABLE에 입력
				// 입력 항목 셋팅
				createPkgParam.put("p_mother_code", sMotherCode);
				createPkgParam.put("p_mail_flag", "Y");
				createPkgParam.put("p_state_flag", "A");
				createPkgParam.put("p_eco_no", sEcoNo);

				// 펜딩 마더 아이템 생성 프로시저 호출
				sscDAO.sscAddPendingMotherInsert(createPkgParam);

				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(createPkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(createPkgParam.get("p_err_code"));

				// 오류가 있으면 Exception
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}

				createPkgParam.put("p_work_key", vWorkKey);
				createPkgParam.put("p_work_flag", commandMap.get("p_work_flag"));
				createPkgParam.put("p_user_id", commandMap.get("loginId"));
				

				// 1.5 MOTHER CODE 채번한 항목 WORK TABLE에 업데이트
				sscDAO.updateSscAddWorkMotherCode(createPkgParam);

				// 프로시저 결과 받음
				sErrMsg = DisStringUtil.nullString(createPkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(createPkgParam.get("p_err_code"));
				
				// 오류가 있으면 Exception
				if (!"".equals(sErrMsg)) {
					throw new DisException(sErrMsg);
				}
			}

			// 1.6 PENDING MOTHER ECO 이행 RELEASE
			Map<String, Object> releasePkgParam = new HashMap<String, Object>();

			releasePkgParam.put("p_main_code", sEcoNo);
			releasePkgParam.put("p_eco_no", sEcoNo);
			releasePkgParam.put("p_appr_type", "PROMOTE");
			releasePkgParam.put("p_notify_msg", "");
			releasePkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			releasePkgParam.put("p_states_code", "REVIEW");
			releasePkgParam.put("p_no", "0");

			ecoDAO.stxDisEcoPromoteDemoteProc(releasePkgParam);

			// 프로시저 결과 받음
			sErrMsg = DisStringUtil.nullString(releasePkgParam.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(releasePkgParam.get("p_error_code"));

			// 오류가 있으면 Exception
			if (!"S".equals(sErrCode)) {
				throw new DisException(sErrMsg);
			}
		}
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
	public Map<String, Object> sscRestoreAction(CommandMap commandMap) throws Exception {
		String sErrMsg = "";
		String sErrCode = "";

		String[] p_ssc_sub_id = commandMap.get("p_ssc_sub_id").toString().split(",");

		try {
			for (String vSscSubId : p_ssc_sub_id) {

				commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commandMap.put("p_ssc_sub_id", vSscSubId);

				sscDAO.sscRestoreAction(commandMap.getMap());

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
	 * @메소드명 : sscCancelAction
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
	public Map<String, Object> sscCancelAction(CommandMap commandMap) throws Exception {
		String sErrMsg = "";
		String sErrCode = "";
		
		String[] p_ssc_sub_id = commandMap.get("p_ssc_sub_id").toString().split(",");
		
		try {
			for (String vSscSubId : p_ssc_sub_id) {
				
				commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commandMap.put("p_ssc_sub_id", vSscSubId);
				
				sscDAO.sscCancelAction(commandMap.getMap());
				
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
	 * @메소드명 : sscCableTypeMainList
	 * @날짜 : 2016. 2. 3.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *     sscCableTypeMainList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscCableTypeMainList(CommandMap commandMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = sscDAO.sscCableTypeMainList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @메소드명 : sscCableTypeSaveAction
	 * @날짜 : 2016. 2. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * Cable Type Save Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscCableTypeSaveAction(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscAddWorkList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : sscAddWorkList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// 1.1 STX_DIS_WORK 에 입력

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅

				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscCableTypeSaveAction(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
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
	 * @메소드명 : sscCableTypeExcelExport
	 * @날짜 : 2016. 2. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Cable Type 엑셀 Export
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	public View sscCableTypeExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {

		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");

			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");

			// 그리드의 헤더를 콜네임으로 설정
			for (String p_col_name : p_col_names) {
				colName.add(new String(p_col_name.getBytes("ISO_8859_1"),"UTF-8"));
			}
			

			List<Map<String, Object>> itemList = sscDAO.sscCableTypeMainList(commandMap.getMap());

			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();

				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
				}
				colValue.add(row);
			}

			// 오늘 날짜 구함 시작
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
			Date currentTime = new Date();
			String dateToday = formatter.format(currentTime);
			// 오늘 날짜 구함 끝

			modelMap.put("excelName", "SSC_CABLE_TYPE_" + dateToday);
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new GenericExcelView();
	}
	
	/**
	 * @메소드명 : sscCableTypeExcelImportAction
	 * @날짜 : 2016. 11. 29.
	 * @작성자 : ChoHeumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *	엑셀 업로드 Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> sscCableTypeExcelImportAction(CommandMap commandMap) throws Exception {
		return FileScanner.excelToList((MultipartFile) commandMap.get("file"), 1, true, 0);
	}
	

	/**
	 * @메소드명 : sscStructureList
	 * @날짜 : 2016. 2. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Outfitting Structure List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscStructureList(CommandMap commandMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = sscDAO.sscStructureList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @메소드명 : sscBuyBuyMotherItemDesc
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Item Code의 Description과 Buy Buy 여부 값 리턴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscBuyBuyMotherItemDesc(CommandMap commandMap) throws Exception {
		return sscDAO.sscBuyBuyMotherItemDesc(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscAfterInfoList
	 * @날짜 : 2016. 3. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *     AfterInfo
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscAfterInfoList(CommandMap commandMap) throws Exception {
		return sscDAO.sscAfterInfoList(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscAfterInfoSaveAction
	 * @날짜 : 2016. 3. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscAfterInfoSaveAction(CommandMap commandMap) throws Exception {

		String sErrMsg = "";
		String sErrCode = "";
		String p_level = DisStringUtil.nullString(commandMap.get("p_level"));
		try {

			if (p_level.equals("2")) {

				commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				int isOk = sscDAO.updateSscAfteriofoBuyBuyAction(commandMap.getMap());
				if (isOk < 1) {
					throw new DisException("변경할 수 있는 BuyBuy 항목이 없습니다.");
				}
			} else {

				Map<String, String> saveMap = new HashMap<String, String>();

				saveMap.put("100", DisStringUtil.nullString(commandMap.get("p_coat_in")));
				saveMap.put("110", DisStringUtil.nullString(commandMap.get("p_coat_out")));
				saveMap.put("120", DisStringUtil.nullString(commandMap.get("p_letter_nameplate")));
				saveMap.put("130", DisStringUtil.nullString(commandMap.get("p_type1")));
				saveMap.put("140", DisStringUtil.nullString(commandMap.get("p_type2")));
				saveMap.put("150", DisStringUtil.nullString(commandMap.get("p_position")));

				for (String key : saveMap.keySet()) {

					Map<String, Object> pkgParam = new HashMap<String, Object>();

					pkgParam.put("p_ssc_sub_id", DisStringUtil.nullString(commandMap.get("p_ssc_sub_id")));
					pkgParam.put("p_element_sequence", key);
					pkgParam.put("p_element_value", saveMap.get(key));

					sscDAO.procSscSubAction(pkgParam);

					// 프로시저 결과 받음
					sErrMsg = DisStringUtil.nullString(commandMap.get("p_err_msg"));
					sErrCode = DisStringUtil.nullString(commandMap.get("p_err_code"));

					if (!"".equals(sErrMsg)) {
						throw new DisException(sErrMsg);
					}
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
	 * @메소드명 : sscMainSaveAction
	 * @날짜 : 2016. 3. 22.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Main Save 기능
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscMainSaveAction(CommandMap commandMap) throws Exception {
		
		String sErrMsg = "";
		String sErrCode = "";

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuySaveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		try {
			for (Map<String, Object> rowData : sscBuyBuySaveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// 1.1 STX_DIS_WORK 에 입력

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.updateSscMainSave(pkgParam);

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

		// 3. 결과 리턴
		return commandMap.getMap();
	}
	
	/**
	 * @메소드명 : selectMainTotalList
	 * @날짜 : 2016. 11. 08.
	 * @작성자 : Cho HeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 *		그리드 메인 리스트 (페이징 처리)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectMainTotalList(CommandMap commandMap) throws Exception {
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		Map<String, Object> resultData = sscDAO.selectMainTotalList(commandMap.getMap());
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

	@Override
	public String dwgPopupViewList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = null;
		
		String sErrMsg = "";
		String sErrCode = "";
		String p_print_seq = "";
		String p_print_flag = "";
		String pml_Code = "";

		try {
			// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
			sscDAO.getPrintSeqH(commandMap.getMap());

			// 프로시저 결과 받음
			p_print_seq = (String) commandMap.get("p_print_seq");
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			} else {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				String iSeq = p_print_seq;
				
				StringTokenizer st = new StringTokenizer((String) commandMap.get("P_FILE_NAME"), "|");
				while(st.hasMoreTokens())
				{
					String checkFileName = st.nextToken();
					pkgParam.put("p_print_seq", iSeq);
					pkgParam.put("p_file_name", checkFileName);
					
					sscDAO.getPrintSeqD(pkgParam);
					
					sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
					sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
					
					if (!"".equals(sErrMsg)) {
						throw new DisException(sErrMsg);
					}	
				}
				
				sscDAO.getPrintSeq(pkgParam);
				
				p_print_flag = DisStringUtil.nullString(pkgParam.get("p_print_flag"));
				
				if (p_print_flag.equals("S")) {
					list = sscDAO.dwgPopupViewList(pkgParam);
					for(Map<String, Object> data : list) {
						pml_Code += data.get("pml_code").toString();
					}
				} else {
					throw new DisException(sErrMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		// 3. 결과 리턴
		return pml_Code;
	}

	@Override
	public View sscMainTotalExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		try {
			// COLNAME 설정
			List<String> colName = new ArrayList<String>();
			// 그리드에서 받아온 엑셀 헤더를 설정한다.
			String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
			// COLVALUE 설정
			List<List<String>> colValue = new ArrayList<List<String>>();
			// 그리드에서 받아온 데이터 네임을 배열로 설정
			String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
			
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
			
			Map<String, Object> resultData = sscDAO.selectMainTotalList(commandMap.getMap());
			List<Map<String, Object>> itemList = (List<Map<String, Object>>)resultData.get("p_refer");
			
			for (Map<String, Object> rowData : itemList) {
				List<String> row = new ArrayList<String>();
				
				// 데이터 네임을 이용해서 리스트에서 뽑아냄.
				for (String p_data_name : p_data_names) {
					row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
				}
				colValue.add(row);
			}

			DecimalFormat format = new DecimalFormat("#.##");
			
			modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
			
		}  catch (Exception e) {
			e.printStackTrace();
		}
		
		return new GenericExcelView();
	}

	@Override
	public Map<String, Object> sscItemAddStageGetMother(CommandMap commandMap) throws Exception {
		return sscDAO.sscItemAddStageGetMother(commandMap.getMap());
	}

	@Override
	public Map<String, Object> getCatalogDesign(CommandMap commandMap) throws Exception {
		return sscDAO.getCatalogDesign(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : sscTribonInterfaceDelete
	 * @날짜 : 2017. 1. 4.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	팝업 PI TRIBON 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscTribonInterfaceDelete(CommandMap commandMap) throws Exception {
		String sErrMsg = "";
		String sErrCode = "";

		String[] p_cad_sub_id = commandMap.get("p_cad_sub_id").toString().split(",");

		try {
			for (String vCadSubId : p_cad_sub_id) {

				commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				commandMap.put("p_cad_sub_id", vCadSubId);

				sscDAO.sscTribonInterfaceDelete(commandMap.getMap());
				sscDAO.sscTribonInterfaceAttrDelete(commandMap.getMap());

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
	 * @메소드명 : sscBuyBuyMainList
	 * @날짜 : 2017. 2. 1.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> sscBuyBuyMainList(CommandMap commandMap) throws Exception {

		// 페이지 전처리
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
		
		Map<String, Object> resultData = sscDAO.sscBuyBuyMainList(commandMap.getMap());
		List<Map<String, Object>> listData = (List<Map<String, Object>>)resultData.get("p_refer");
		
		// 페이지 후처리
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = 0;

		if(listData.size() > 0) {
			listRowCnt = listData.size();
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
	 * @메소드명 : getSscDescription
	 * @날짜 : 2017. 2. 6.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 desc, project 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> getSscDescription(CommandMap commandMap) throws Exception {
		return sscDAO.getSscDescription(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainDelete
	 * @날짜 : 2017. 2. 6.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Delete
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscBuyBuyMainDelete(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuyDeleteList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : sscBuyBuyDeleteList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscBuyBuyMainDelete(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
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
	 * @메소드명 : sscBuyBuyMainRestore
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Restore
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscBuyBuyMainRestore(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuyRestoreList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : sscBuyBuyRestoreList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscBuyBuyMainRestore(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
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
	 * @메소드명 : sscBuyBuyMainRestore
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Restore
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscBuyBuyMainCancel(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuyCancelList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : sscBuyBuyCancelList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscBuyBuyMainCancel(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
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
	 * @메소드명 : procBuyBuySaveAction
	 * @날짜 : 2016. 3. 10.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	buybuy save
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscBuyBuyMainSave(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuySaveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : sscBuyBuySaveList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// 1.1 STX_DIS_WORK 에 입력

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅

				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscBuyBuyMainSave(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
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
	 * @메소드명 : sscBuyBuyAddNext.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD NEXT
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscBuyBuyAddNext(CommandMap commandMap) throws Exception {

		String sErrorMsg = "";

		// 1. 그리드 데이터 WORK 테이블 입력
		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuyNextList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		String sWorkKey = Long.toString(System.currentTimeMillis());
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			for (Map<String, Object> rowData : sscBuyBuyNextList) {
				// p_chk_series의 순대로 돌림.
				// 돌림
				//vItemGroup++;
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}
				pkgParam.put("p_mother_code", commandMap.get("p_mother_by"));
				pkgParam.put("p_work_key", sWorkKey);
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));
				pkgParam.put("p_chk_series", commandMap.get("p_chk_series"));
				pkgParam.put("p_bom_qty", rowData.get("ea"));
				pkgParam.put("p_state_flag", "A");
				pkgParam.put("p_work_flag", "ADD");
				
				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscWorkInsert(pkgParam);
				
			}
			
			// 2. Validation 체크 프로시저 호출
			// 키 값이 되는 user_id와 work_key를 넣어준다.
			commandMap.put("p_work_key", sWorkKey);
			commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			sscDAO.sscBuyBuyAddValidation(commandMap.getMap());
			
			// 3. 결과 받아옴
			List<Map<String, Object>> resultList = sscDAO.sscBuyBuyAddList(commandMap.getMap());
			
			result.put(DisConstants.GRID_RESULT_DATA, resultList);
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
			result.put("p_work_key", sWorkKey);
			
			// 여기까지 Exception 없으면 성공 메시지
			result.put(DisConstants.RESULT_MASAGE_KEY, "");

		} catch(Exception e) {
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return result;
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddBack.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD NEXT
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscBuyBuyAddBack(CommandMap commandMap) throws Exception {

		String sErrorMsg = "";
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		List<Map<String, Object>> resultList = sscDAO.sscBuyBuyAddBack(commandMap.getMap());

		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			
			result.put(DisConstants.GRID_RESULT_DATA, resultList);
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
			
			// 여기까지 Exception 없으면 성공 메시지
			result.put(DisConstants.RESULT_MASAGE_KEY, "");

		} catch(Exception e) {
			result.put(DisConstants.RESULT_MASAGE_KEY, sErrorMsg);
		}
		
		return result;
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddApply.do
	 * @날짜 : 2016. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> sscBuyBuyAddApply(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscBuyBuyAddList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		String sErrorMsg = "";

		try {
			for (Map<String, Object> rowData : sscBuyBuyAddList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// 1.1 STX_DIS_WORK 에 입력

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_project_no", commandMap.get("p_project_no"));
				pkgParam.put("p_mother_by", commandMap.get("p_mother_by"));
				pkgParam.put("p_chk_series", commandMap.get("p_chk_series"));
				pkgParam.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_dept_code", commandMap.get("p_dept_code"));

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				sscDAO.sscBuyBuyAddApply(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
				String sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
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
	 * @메소드명 : sscBuyBuyAddExcelImportAction
	 * @날짜 : 2016. 2. 8.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *		BUY-BUY 엑셀 업로드
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscBuyBuyAddExcelImportAction(CommandMap commandMap) throws Exception {
		return FileScanner.excelToList((MultipartFile) commandMap.get("file"), 1, true, 0);
	}
	
	/**
	 * @메소드명 : sscBuyBuyDwgNoList
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드 DWG NO.칼럼 SELECT BOX
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sscBuyBuyDwgNoList(CommandMap commandMap) throws Exception {
		commandMap.put("p_user_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		return sscDAO.sscBuyBuyDwgNoList(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddGetItemDesc.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD 그리드 내 ITEM DESC 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sscBuyBuyAddGetItemDesc(CommandMap commandMap) throws Exception {
		return sscDAO.sscBuyBuyAddGetItemDesc(commandMap.getMap());
	}
	
	/**
	 * @메소드명 : getDeliverySeries.do
	 * @날짜 : 2017. 3. 22.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	해당 호선의 시리즈 중에서 Delivery 시리즈 리스트를 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getDeliverySeries(CommandMap commandMap) throws Exception {
		return sscDAO.getDeliverySeries(commandMap.getMap());
	}
}
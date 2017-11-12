package stxship.dis.ems.partList.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.View;

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
import stxship.dis.ems.partList.dao.EmsPartListDAO;

@Service("emsPartListService")
public class EmsPartListServiceImpl extends CommonServiceImpl implements EmsPartListService {

	@Resource(name = "emsPartListDAO")
	private EmsPartListDAO emsPartListDAO;

	/**
	 * @메소드명 : emsPartListList
	 * @날짜 : 2016. 3. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS Part List Main List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> emsPartListMainList(CommandMap commandMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = emsPartListDAO.emsPartListMainList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @메소드명 : emsPartListSelectOne
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Main 선택 정보 리턴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> emsPartListSelectOne(CommandMap commandMap) {
		return emsPartListDAO.emsPartListSelectOne(commandMap.getMap());
	}

	/**
	 * @메소드명 : sscMainExcelExport
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS PART LIST EXCEL EXPORT
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public View emsPartListExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

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
				colName.add(p_col_name);
			}

			List<Map<String, Object>> itemList = emsPartListDAO.emsPartListMainList(commandMap.getMap());

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

			modelMap.put("excelName", "EMS_PARTLIST_" + dateToday);
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new GenericExcelView();
	}

	/**
	 * @메소드명 : emsPartListSaveAction
	 * @날짜 : 2016. 3. 30.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Part List Save Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> emsPartListSaveAction(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscAddPartList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String sErrorMsg = "";
		String sErrCode = "";

		try {
			for (Map<String, Object> rowData : sscAddPartList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// Stage Div 화면에서는 그리드에 p_partlist_id가 없기 때문에
				// 없으면 넣어준다.
				if (DisStringUtil.nullString(pkgParam.get("p_partlist_id")).equals("")) {
					pkgParam.put("p_partlist_id", commandMap.get("p_partlist_id"));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_system", "PLM");
				pkgParam.put("p_user_code", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_organization_id", "82");
				pkgParam.put("p_bom_quantity", rowData.get("ea_plan"));
				pkgParam.put("p_source_code", "M");
				pkgParam.put("p_lock_flag", "N");
				pkgParam.put("p_bef_primary_item_code", "");

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				emsPartListDAO.procEmsPartListSaveAction(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return rtnMap;
	}

	/**
	 * @메소드명 : emsPartListJobList
	 * @날짜 : 2016. 3. 30.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	job 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsPartListJobList(CommandMap commandMap) {
		return emsPartListDAO.emsPartListJobList(commandMap.getMap());
	}

	/**
	 * @메소드명 : emsPartListBomDetail
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS PARTLIST STAGE DIV 세부 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsPartListBomDetail(CommandMap commandMap) {
		return emsPartListDAO.emsPartListBomDetail(commandMap.getMap());
	}

	/**
	 * @메소드명 : emsPartListProjectCopyNextList
	 * @날짜 : 2016. 4. 4.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Project Copy Next List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> emsPartListProjectCopyNextList(CommandMap commandMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		// 배열로 넘어온 시리즈를 java에서 인식하는 배열로 다시 랩핑
		commandMap.put("p_chk_series", DisStringUtil.nullString(commandMap.get("p_chk_series")).split(","));
		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = emsPartListDAO.emsPartListProjectCopyNextList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * @메소드명 : emsPartListProjectCopySave
	 * @날짜 : 2016. 4. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS Part List Project Copy 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> emsPartListProjectCopySave(CommandMap commandMap) throws Exception {

		// 그리드 리스트에서 받아옴
		List<Map<String, Object>> sscAddPartList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String sErrorMsg = "";
		String sErrCode = "";

		try {
			for (Map<String, Object> rowData : sscAddPartList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				// commandMap에 있는 행을 'p_'를 붙혀서 pkgParam에 넣는다.
				for (String key : rowData.keySet()) {
					pkgParam.put("p_" + key, rowData.get(key));
				}

				// 필요한 값 셋팅
				pkgParam.put("p_system", "PLM");
				pkgParam.put("p_user_code", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_organization_id", "82");
				pkgParam.put("p_source_code", "M");
				pkgParam.put("p_lock_flag", "N");
				pkgParam.put("p_bef_primary_item_code", "");

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				emsPartListDAO.procEmsPartListSaveAction(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		// 3. 결과 리턴
		return rtnMap;
	}

	/**
	 * @메소드명 : emsPartListImportAction
	 * @날짜 : 2016. 4. 7.
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
	public Map<String, Object> emsPartListImportAction(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> excelList = FileScanner.excelToList((MultipartFile) commandMap.get("file"), 1, true, 0);

		Map<String, Object> rtnMap = new HashMap<String, Object>();
		String sErrorMsg = "";
		String sErrCode = "";
		try {
			for (Map<String, Object> rowData : excelList) {
				Map<String, Object> pkgParam = new HashMap<String, Object>();

				pkgParam.put("p_project_no", rowData.get("column0"));
				pkgParam.put("p_equipment_name", rowData.get("column1"));
				pkgParam.put("p_tag_no", rowData.get("column2"));

				String vPartListId = emsPartListDAO.emsPartListId(pkgParam);

				if (vPartListId == null || vPartListId.equals("")) {
					throw new DisException("기준 ITEM 리스트가 잘못 되었습니다. - 호선 : " + rowData.get("column0") + "- Equipment : " + rowData.get("column1") + " - TAG_NO : " + rowData.get("column2"));
				}

				pkgParam.put("p_plm_item_code", rowData.get("column5"));
				pkgParam.put("p_bom_quantity", rowData.get("column6"));
				pkgParam.put("p_plm_block_no", rowData.get("column7"));
				pkgParam.put("p_plm_stage_no", rowData.get("column8"));
				pkgParam.put("p_plm_str_flag", rowData.get("column9"));
				pkgParam.put("p_plm_str_key", rowData.get("column10"));
				pkgParam.put("p_drawing_no", rowData.get("column11"));
				pkgParam.put("p_plm_mother_code", rowData.get("column12"));
				pkgParam.put("p_primary_item_code", rowData.get("column13"));

				pkgParam.put("p_plm_comment", rowData.get("column17"));

				pkgParam.put("p_oper", "A");
				pkgParam.put("p_system", "PLM");
				pkgParam.put("p_user_code", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				pkgParam.put("p_bom_id", "");

				pkgParam.put("p_organization_id", "82");
				pkgParam.put("p_source_code", "M");
				pkgParam.put("p_lock_flag", "N");
				pkgParam.put("p_bef_primary_item_code", "");

				// 필요한 값 셋팅
				pkgParam.put("p_partlist_id", vPartListId);

				// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
				emsPartListDAO.procEmsPartListSaveAction(pkgParam);

				// 프로시저 결과 받음
				sErrorMsg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
				sErrCode = DisStringUtil.nullString(pkgParam.get("p_err_code"));

				// 오류가 있으면 스탑
				if (!"".equals(sErrorMsg)) {
					throw new DisException(sErrorMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));

		} catch (Exception e) {
			e.printStackTrace();
			rtnMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}

		return rtnMap;

	}
}

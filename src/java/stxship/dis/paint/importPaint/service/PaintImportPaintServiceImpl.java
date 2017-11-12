package stxship.dis.paint.importPaint.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.importPaint.dao.PaintImportPaintDAO;

@Service("paintImportPaintService")
public class PaintImportPaintServiceImpl extends CommonServiceImpl implements PaintImportPaintService {

	@Resource(name = "paintImportPaintDAO")
	private PaintImportPaintDAO paintImportPaintDAO;

	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		if ("selectPaintImportPaintList".equals(map.get(DisConstants.MAPPER_NAME))
				|| "paintImportExcelExport".equals(map.get(DisConstants.MAPPER_NAME))) {
			//String sPaintNewRuleFlag = (String) paintImportPaintDAO.selectPaintNewRuleFlag(map);
			List<Map<String, Object>> list = null;

			if ("chkBlock".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectBlockQuantityList(map);
			} else if ("chkPrePE".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectPrePeQuantityList(map);
			} else if ("chkPE".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectPeQuantityList(map);
			} else if ("chkHull".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectHullQuantityList(map);
			} else if ("chkQuay".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectQuayQuantityList(map);
			} else if ("chkOutfit".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectOutQuantityList(map);
			} else if ("chkCosmetic".equals(map.get("checkbox_id"))) {
				list = paintImportPaintDAO.selectCosQuantityList(map);
			} else {
			    //list = paintImportPaintDAO.selectOutCosQuantityList(map);
			}

			return list;

		} else {
			return super.getGridData(map);
		}

	}

	@Override
	public Map<String, Object> selectPaintEco(CommandMap commandMap) {
		String stage_type = "";
		if ("chkBlock".equals(commandMap.get("checkbox_id"))) {
			stage_type = "BLOCK";
		} else if ("chkPrePE".equals(commandMap.get("checkbox_id"))) {
			stage_type = "PRE_PE";
		} else if ("chkPE".equals(commandMap.get("checkbox_id"))) {
			stage_type = "PE";
		} else if ("chkHull".equals(commandMap.get("checkbox_id"))) {
			stage_type = "HULL";
		} else if ("chkQuay".equals(commandMap.get("checkbox_id"))) {
			stage_type = "QUAY";
		} else if ("chkOutfit".equals(commandMap.get("checkbox_id"))) {
			stage_type = "OUT";
		} else if ("chkCosmetic".equals(commandMap.get("checkbox_id"))) {
			stage_type = "COS";
		}

		commandMap.put("stage_type", stage_type);

		return paintImportPaintDAO.selectPaintEco(commandMap.getMap());
	}

	@Override
	public List<Map<String, Object>> selectSeriesProjectNo(CommandMap commandMap) {

		List<Map<String, Object>> result = paintImportPaintDAO.selectSeriesProjectNo(commandMap.getMap());
		return result;

	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> savePaintRelease(CommandMap commandMap) throws Exception {
		Map<String, Object> pkgParam = new HashMap<String, Object>();
		pkgParam.put("p_project_no", commandMap.get("project_no"));
		pkgParam.put("p_revision_no", commandMap.get("revision"));
		pkgParam.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		paintImportPaintDAO.savePaintPlanRelease(pkgParam);

		String sMainErrorCode = (String) pkgParam.get("p_error_code");
		String sMainErrorMsg = (String) pkgParam.get("p_error_msg");

		if (!"S".equals(sMainErrorCode) && !"F".equals(sMainErrorCode)) {
			throw new Exception(sMainErrorMsg);
		}

		Map<String, Object> resultMap = new HashMap<String, Object>();

		if ("F".equals(sMainErrorCode)) {
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
			resultMap.put(DisConstants.RESULT_MASAGE_KEY,
					DisMessageUtil.getMessage("customer.message1", sMainErrorMsg));

		} else {
			resultMap.put(DisConstants.RESULT_KEY, DisConstants.RESULT_SUCCESS);
			resultMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("paint.message15"));

		}
		return resultMap;
	}

	@Override
	public List<Map<String, Object>> paintSelectEcoAddStateList(CommandMap commandMap) {

		List<Map<String, Object>> result = paintImportPaintDAO.paintSelectEcoAddStateList(commandMap.getMap());
		return result;

	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintImportCreateBom(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> paintPlanMapList = DisJsonUtil.toList(commandMap.get("paintPlanList"));

		String paint_stage_type = "";

		if ("chkBlock".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "BLOCK";
		} else if ("chkPrePE".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "PRE_PE";
		} else if ("chkPE".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "PE";
		} else if ("chkHull".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "HULL";
		} else if ("chkQuay".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "QUAY";
		} else if ("chkOutfit".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "OUT";
		} else if ("chkCosmetic".equals(commandMap.get("checkbox_id"))) {
			paint_stage_type = "COS";
		}

		// step1 >>>>>>> paint_head_insert_proc 호출
		// Import Paint 수행 이력 저장, 잠정ECO 생성
		Map<String, Object> pkgParam1 = new HashMap<String, Object>();
		pkgParam1.put("p_project_no", commandMap.get("project_no"));
		pkgParam1.put("p_revision", commandMap.get("revision"));
		pkgParam1.put("p_series_project_no", commandMap.get("seriesProject"));
		pkgParam1.put("p_paint_stage_type", paint_stage_type);
		pkgParam1.put("p_eco_no", commandMap.get("eco_main_name"));
		pkgParam1.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

		paintImportPaintDAO.insertPaintHead(pkgParam1);

		String sPaintHeadID = (String) pkgParam1.get("p_paint_head_id");
		String sErrorCode = (String) pkgParam1.get("p_error_code");
		String sErrorMsg = (String) pkgParam1.get("p_error_msg");

		if (!"S".equals(sErrorCode) && !"F".equals(sErrorCode)) {
			throw new Exception(sErrorMsg);
		}

		if ("F".equals(sErrorCode)) {
			throw new DisException(DisMessageUtil.getMessage("customer.message1", sErrorMsg));

		} else {

			String sLineErrorCode = "";
			String sLineErrorMsg = "";

			// BOM 생성완료 이전 단계에서 에러가 나서 재수행할 경우도 있기에, LINE 입력전에 기 입력된 LINE 정보 삭제
			Map<String, Object> delParam = new HashMap<String, Object>();
			delParam.put("p_paint_head_id", sPaintHeadID);

			paintImportPaintDAO.deletePaintLine(delParam);

			for (Map<String, Object> paintPlan : paintPlanMapList) {
				// step2 >>>>>>> 조회된 data만큼 paint_line_insert_proc 호출
				// PAINT BOM을 형성하기 위한 Row Data(Import Paint 화면 조회 data) 입력을 위한
				// 프로시져

				Map<String, Object> pkgParam2 = new HashMap<String, Object>();

				pkgParam2.put("p_paint_head_id", sPaintHeadID);
				pkgParam2.put("p_pe_code", paintPlan.get("pe_code"));
				pkgParam2.put("p_pre_pe_code", paintPlan.get("pre_pe_code"));
				pkgParam2.put("p_zone_code", paintPlan.get("zone_code"));
				pkgParam2.put("p_block_code", paintPlan.get("block_code"));
				pkgParam2.put("p_team_count", paintPlan.get("team_count"));
				pkgParam2.put("p_team_desc", paintPlan.get("team_desc"));
				pkgParam2.put("p_quay_code", paintPlan.get("quay_code"));
				pkgParam2.put("p_area_code", paintPlan.get("area_code"));
				pkgParam2.put("p_area", paintPlan.get("area"));
				pkgParam2.put("p_paint_count", paintPlan.get("paint_count"));
				pkgParam2.put("p_paint_item", paintPlan.get("paint_item"));
				pkgParam2.put("p_thinner_code", paintPlan.get("thinner_code"));
				pkgParam2.put("p_quantity", paintPlan.get("quantity"));
				pkgParam2.put("p_theory_quantity", paintPlan.get("theory_quantity"));
				pkgParam2.put("p_thinner_quantity", paintPlan.get("thinner_quantity"));
				pkgParam2.put("p_thinner_theory_quantity", paintPlan.get("thinner_theory_quantity"));
				pkgParam2.put("p_acd_type", paintPlan.get("acd"));

				paintImportPaintDAO.insertPaintLine(pkgParam2);

				sLineErrorCode = (String) pkgParam2.get("p_error_code");
				sLineErrorMsg = (String) pkgParam2.get("p_error_msg");

				if (!"S".equals(sLineErrorCode) && !"F".equals(sLineErrorCode)) {
					throw new Exception(sLineErrorMsg);
				}

				if ("F".equals(sLineErrorCode)) {
					throw new DisException(DisMessageUtil.getMessage("customer.message1", sLineErrorCode));
				}
			}

			// step3 >>>>>>> HEAD, LINE이 입력된 후 BOM정보를 확인해서 BOM데이타 생성 proc 호출
			Map<String, Object> pkgParam3 = new HashMap<String, Object>();
			pkgParam3.put("p_paint_head_id", sPaintHeadID);
			pkgParam3.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

			paintImportPaintDAO.savePaintMain(pkgParam3);

			String sMainErrorCode = (String) pkgParam3.get("p_error_code");
			String sMainErrorMsg = (String) pkgParam3.get("p_error_msg");

			if (!"S".equals(sMainErrorCode) && !"F".equals(sMainErrorCode)) {
				throw new Exception(sMainErrorMsg);
			}

			if ("F".equals(sMainErrorCode)) {
				throw new DisException(DisMessageUtil.getMessage("customer.message1", sMainErrorCode));
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);

	}

	@Override
	public View paintImportExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// COLNAME 설정

		List<String> colName = new ArrayList<String>();
		// 그리드에서 받아온 엑셀 헤더를 설정한다.
		String[] p_col_names = commandMap.get("p_col_name").toString().split(",");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();
		// 그리드에서 받아온 데이터 네임을 배열로 설정
		String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
		List<Map<String, Object>> itemList = this.getGridData(commandMap.getMap());
		boolean startFlag = true;
		for (Map<String, Object> rowData : itemList) {
			Set<String> set = rowData.keySet();
			// 그리드의 헤더를 콜네임으로 설정
			List<String> row = new ArrayList<String>();
			boolean dataFlag = false;
			for (int i = 0; i < p_col_names.length; i++) {
				if(p_data_names[i].equals("area")){
					dataFlag = true;
				}
				if(p_data_names[i].equals("quantity")){
					dataFlag = true;
				}
				if(p_data_names[i].equals("theory_quantity")){
					dataFlag = true;
				}
				if(p_data_names[i].equals("acd")){
					dataFlag = true;
				}
				if(p_data_names[i].equals("thinner_code")){
					dataFlag = false;
					break;
				}
				if (set.contains(p_data_names[i])) {
					dataFlag = true;
				}
				if(dataFlag) {
					if (startFlag) {
						colName.add(p_col_names[i]);
					}
					row.add(DisStringUtil.nullString(rowData.get(p_data_names[i])));
				}
				dataFlag = false;
			}
			
			
			colValue.add(row);
			if (startFlag) {
				startFlag = false;
			}
		}

		// 오늘 날짜 구함 시작
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);
		// 오늘 날짜 구함 끝

		modelMap.put("excelName",
				"PAINT_IMPORT_" + commandMap.get("project_no") + "_" + commandMap.get("revision") + dateToday);
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();
	}
	
	/** 
	 * @메소드명	: paintAdminCheck
	 * @날짜		: 2017. 03. 22.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * PAINT 관리자 구분
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> paintAdminCheck(CommandMap commandMap) throws Exception {
		Map<String, Object> loginGubun = new HashMap<String, Object>();
		loginGubun = paintImportPaintDAO.paintAdminCheck(commandMap.getMap());
		return loginGubun;
	}	


}

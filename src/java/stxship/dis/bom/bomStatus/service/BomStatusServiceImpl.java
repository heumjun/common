package stxship.dis.bom.bomStatus.service;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.bom.bomStatus.dao.BomStatusDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.eco.eco.dao.EcoDAO;

/**
 * @파일명 : BomStatusServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Bom현황 에서 사용되는 서비스
 *     </pre>
 */
@Service("bomStatusService")
public class BomStatusServiceImpl extends CommonServiceImpl implements BomStatusService {

	@Resource(name = "bomStatusDAO")
	private BomStatusDAO bomStatusDAO;

	@Resource(name = "ecoDAO")
	private EcoDAO ecoDAO;

	/**
	 * @메소드명 : getSpstShipTypeList
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Ship Type리스트를 가져오는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getSpstShipTypeList(CommandMap commandMap) {
		return bomStatusDAO.infoSpstShipType(commandMap.getMap());
	}

	/**
	 * @메소드명 : getJobDeptCode
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DPS부서를 가져오는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, String> getJobDeptCode(CommandMap commandMap) {
		// 세션에서 유저정보를 가져온다.
		commandMap.put("dwgdeptcode", DisSessionUtil.getAuthenticatedUser().get("DWG_DEPT_CODE"));
		return bomStatusDAO.selectJobDeptCode(commandMap.getMap());
	}

	/**
	 * @메소드명 : saveBomJobItem
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 채번 및 BOM생성시 사용되는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveBomJobItem(CommandMap commandMap) throws Exception {

		// 사용될 파라미타 정의
		Map<String, Object> itemCreateParam = new HashMap<String, Object>();
		Map<String, Object> pkgParam1 = new HashMap<String, Object>();
		// 입력된 데이터 취득
		List<Map<String, Object>> resultList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		for (Map<String, Object> rowData : resultList) {
			String item_code;
			// 아이템 코드가 입력되어 있지 않은경우
			if (rowData.get("item_code") == null || rowData.get("item_code") == "") {
				itemCreateParam.put("p_catalog_code", rowData.get("item_catalog"));
				itemCreateParam.put("p_ship_type", commandMap.get("p_ship_type"));
				itemCreateParam.put("p_weight", rowData.get("weight"));
				itemCreateParam.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				// ITEM DESC가 입력된경우는 "PAINT_DESC"를 넣어준다.->입력된 ITEM DESC로 ITEM 생성
				if (rowData.get("item_desc") == null || "".equals(rowData.get("item_desc"))) {
					itemCreateParam.put("p_old_item_code", "");
				} else {
					itemCreateParam.put("p_old_item_code", "PAINT_DESC");
				}
				itemCreateParam.put("p_attr00_code", "");
				itemCreateParam.put("p_attr00_desc", rowData.get("item_desc"));

				for (int i = 1; i <= 15; i++) {
					String no;
					if (i < 10) {
						no = "0" + i;
					} else {
						no = i + "";
					}
					itemCreateParam.put("p_attr" + no + "_code",
							DisStringUtil.nullString(rowData.get("attr" + i + "_code")));
					itemCreateParam.put("p_attr" + no + "_desc", DisStringUtil.nullString(rowData.get("attr" + i)));
				}
				itemCreateParam.put("p_paint_code1", "");
				itemCreateParam.put("p_paint_code2", "");
				for (int i = 1; i <= 15; i++) {
					String no;
					if (i < 10) {
						no = "0" + i;
					} else {
						no = i + "";
					}
					itemCreateParam.put("p_add_attr" + no + "_desc",
							DisStringUtil.nullString(rowData.get("add_attr" + i)));
				}
				itemCreateParam.put("p_excel_upload_flag", "");
				bomStatusDAO.insertItemCodeCreate(itemCreateParam);
				String error_code = DisStringUtil.nullString(itemCreateParam.get("p_err_code"));
				String error_msg = DisStringUtil.nullString(itemCreateParam.get("p_err_msg"));
				item_code = DisStringUtil.nullString(itemCreateParam.get("p_item_code"));
				if (!"S".equals(error_code) && !"F".equals(error_code)) {
					throw new Exception(error_msg);
				}
				if ("F".equals(error_code)) {
					throw new DisException(DisMessageUtil.getMessage("customer.message1", new String[] { error_msg }));
				}
			} else {
				item_code = DisStringUtil.nullString(rowData.get("item_code"));
			}

			pkgParam1.put("mother_code", rowData.get("mother_code"));
			pkgParam1.put("item_code", item_code);
			pkgParam1.put("project_no", commandMap.get("p_project_no"));
			pkgParam1.put("p_eco_no", commandMap.get("p_eng_change_order_code"));
			pkgParam1.put("qty", rowData.get("qty"));
			pkgParam1.put("bom1", DisStringUtil.nullString(rowData.get("bom1")));
			pkgParam1.put("bom2", DisStringUtil.nullString(rowData.get("bom2")));
			pkgParam1.put("bom3", DisStringUtil.nullString(rowData.get("bom3")));
			pkgParam1.put("bom4", DisStringUtil.nullString(rowData.get("bom4")));
			pkgParam1.put("bom5", DisStringUtil.nullString(rowData.get("bom5")));
			pkgParam1.put("bom6", DisStringUtil.nullString(rowData.get("bom6")));
			pkgParam1.put("bom7", DisStringUtil.nullString(rowData.get("bom7")));
			pkgParam1.put("bom8", DisStringUtil.nullString(rowData.get("bom8")));
			pkgParam1.put("bom9", DisStringUtil.nullString(rowData.get("bom9")));
			pkgParam1.put("bom10", DisStringUtil.nullString(rowData.get("bom10")));
			pkgParam1.put("bom11", DisStringUtil.nullString(rowData.get("bom11")));
			pkgParam1.put("bom12", DisStringUtil.nullString(rowData.get("bom12")));
			pkgParam1.put("bom13", DisStringUtil.nullString(rowData.get("bom13")));
			pkgParam1.put("bom14", DisStringUtil.nullString(rowData.get("bom14")));
			pkgParam1.put("bom15", DisStringUtil.nullString(rowData.get("bom15")));
			pkgParam1.put("item_catalog", rowData.get("item_catalog"));
			pkgParam1.put("states_flag", rowData.get("states_flag"));
			pkgParam1.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			System.out.println("pkgParam1::" + pkgParam1.toString());
			int result = bomStatusDAO.insertBomFromJobItem(pkgParam1);
			if (result == 0) {
				throw new DisException();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveJobItem
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM현황의 저장을 선택했을때의 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveJobItem(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> itemList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		Map<String, Object> duplicationBom = null;
		Map<String, Object> duplicationBomWork = null;
		for (Map<String, Object> rowData : itemList) {
			rowData.put("loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("eco_no", commandMap.get("p_eng_change_order_code"));
			rowData.put("project_no", commandMap.get("p_project_no"));
			// 삭제인경우
			if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// BOM의 중복
				duplicationBom = bomStatusDAO.duplicateBom(rowData);
				// BOMWork의 중복
				duplicationBomWork = bomStatusDAO.duplicateBomWork(rowData);

				// 1. BOM & BOMWork의 중복일때(양쪽 다 중복) -> 추가,수정,삭제가 이루어져 있는 BOM
				if (duplicationBom != null && duplicationBomWork != null) {
					// BOMWork를 삭제
					result = bomStatusDAO.deleteBomWork(rowData);
				}
				// BOM은 중복 BOMWork는 중복이 아닐때 -> ECO이행이 완료된 BOM
				else if (duplicationBom != null && duplicationBomWork == null) {
					// BOM을 복사해서 BOMWork에 카피
					result = bomStatusDAO.copyToBomWorkFromBom(rowData);
				}
				// BOM은 중복이 아니고 BOMWork는 중복일때 -> 추가,수정,삭제가 이루어져 있는 BOM(ECO이행이
				// 한번도 이루어지지 않은 BOM)
				else if (duplicationBom == null && duplicationBomWork != null) {
					// BOMWork를 삭제
					result = bomStatusDAO.deleteBomWork(rowData);
				} else {
					throw new DisException("[" + rowData.get("item_code") + "] BOM ITEM이 아닙니다.");
				}
				if (result == 0) {
					throw new DisException();
				}
			}
			// 변경인경우
			else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// BOM의 중복
				duplicationBom = bomStatusDAO.duplicateBom(rowData);
				// BOMWork의 중복
				duplicationBomWork = bomStatusDAO.duplicateBomWork(rowData);

				// 1. BOM & BOMWork의 중복일때(양쪽 다 중복) -> 추가,수정,삭제가 이루어져 있는 BOM
				if (duplicationBom != null && duplicationBomWork != null) {
					// BOMWork를 수정
					result = bomStatusDAO.updateBomWork(rowData);
				}
				// BOM은 중복 BOMWork는 중복이 아닐때 -> ECO이행이 완료된 BOM
				else if (duplicationBom != null && duplicationBomWork == null) {
					// BOM을 복사해서 BOMWork에 카피
					result = bomStatusDAO.copyToBomWorkFromBom(rowData);
					result = bomStatusDAO.updateBomWork(rowData);
				}
				// BOM은 중복이 아니고 BOMWork는 중복일때 -> 추가만 되어 있고, ECO 이행이 없는 상태.. 이경우는 계속 'A' 상태여야한다.
				// 한번도 이루어지지 않은 BOM)
				else if (duplicationBom == null && duplicationBomWork != null) {
					// BOMWork를 삭제
					result = bomStatusDAO.updateBomWork_A_state(rowData);
				} else {
					throw new DisException("[" + rowData.get("item_code") + "] BOM ITEM이 아닙니다.");
				}
				/*
				 * duplicationBomWork = bomStatusDAO.duplicateBomWork(rowData);
				 * if (duplicationBomWork != null) { result =
				 * bomStatusDAO.updateDwgNoToJobItem(rowData); if (result == 0)
				 * { throw new DisException(); } } else { throw new
				 * DisException("추가,삭제,수정 BOM이 아닌경우 변경 불가합니다."); }
				 */
				if (result == 0) {
					throw new DisException();
				}
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : deleteSpstSubItem
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수구조관리에서 삭제를 선택했을때의 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> deleteSpstSubItem(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> wbsSubList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		for (Map<String, Object> rowData : wbsSubList) {
			result = bomStatusDAO.deleteSpstBomTemp(rowData);
			if (result == 0) {
				throw new DisException();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveSpstSubBom
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수구조관리에서 저장이 되었을때의 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveSpstSubBom(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> wbsSubList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		int result = 0;
		for (Map<String, Object> rowData : wbsSubList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = bomStatusDAO.insertSpstBomTemp(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = bomStatusDAO.updateSpstBomTemp(rowData);
			}
			if (result == 0) {
				throw new DisException();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : addSpecificStructure
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수 구조 추가를 선택했을때의 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> addSpecificStructure(CommandMap commandMap) throws Exception {

		// 프로젝트의 shipType를 취득
		Map<String, String> sShipType = bomStatusDAO.selectProjectShipType(commandMap.getMap());

		// 프로젝트의 BOM리스트를 취득
		List<Map<String, Object>> bomListFormProject = bomStatusDAO.selectBomListFormProject(commandMap.getMap());
		Iterator<Map<String, Object>> bomListIt = bomListFormProject.iterator();
		Map<String, Object> bomItem = null;

		// 특수구조리스트를 취득
		List<Map<String, Object>> spstItemList = bomStatusDAO.specificStructureList(commandMap.getMap());
		Iterator<Map<String, Object>> stspListIt = null;
		Map<String, Object> spstItem = null;

		Map<String, Object> pkgParam = null;
		Map<String, Object> pkgParam1 = null;

		while (bomListIt.hasNext()) {
			bomItem = bomListIt.next();

			String bomItemCatalog = (String) bomItem.get("item_catalog");
			if (bomItemCatalog == null) {
				bomItemCatalog = "";
			}
			stspListIt = spstItemList.iterator();
			while (stspListIt.hasNext()) {
				spstItem = stspListIt.next();

				// 특수구조의 모품목과 BomList의 ItemCatalog를 비교
				String spstItemMotherCatalog = (String) spstItem.get("mother_catalog");

				if (bomItemCatalog.equals(spstItemMotherCatalog)) {
					pkgParam = new HashMap<String, Object>();
					// 특수구조의 자품목을 기준으로 ItemCode를 채번
					pkgParam.put("p_catalog_code", spstItem.get("item_catalog"));
					pkgParam.put("p_ship_type", sShipType.get("ship_type"));
					pkgParam.put("p_weight", "0");
					pkgParam.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
					pkgParam.put("p_old_item_code", "");

					pkgParam.put("p_attr00_code", "");
					pkgParam.put("p_attr00_desc", "");

					pkgParam.put("p_attr01_code", bomItem.get("bom10"));
					pkgParam.put("p_attr01_desc", "");
					pkgParam.put("p_attr02_code", bomItem.get("bom11"));
					pkgParam.put("p_attr02_desc", "");

					commandMap.put("item_catalog", spstItem.get("item_catalog"));
					Map<String, String> typeMap = bomStatusDAO.selectJobType(commandMap.getMap());
					String jobType = "";
					if (typeMap != null) {
						jobType = typeMap.get("job_type");
					}

					if (jobType.equals("01")) {
						commandMap.put("item_catalog", bomItem.get("item_catalog"));
						String spstCnt = (String) bomStatusDAO
								.selectSubItemListWithSpstItemCatalogCnt(commandMap.getMap());
						if (Integer.parseInt(spstCnt) > 0) {
							break;
						} else {
							pkgParam.put("p_attr03_code", "");
						}
					} else if (jobType.equals("02")) {
						pkgParam.put("p_attr03_code", jobType);
					} else if (jobType.equals("03")) {
						pkgParam.put("p_attr03_code", commandMap.get("p_dwg_no"));
					}

					pkgParam.put("p_attr03_desc", "");
					pkgParam.put("p_attr04_code", "");
					pkgParam.put("p_attr04_desc", "");
					pkgParam.put("p_attr05_code", "");
					pkgParam.put("p_attr05_desc", "");
					pkgParam.put("p_attr06_code", "");
					pkgParam.put("p_attr06_desc", "");
					pkgParam.put("p_attr07_code", "");
					pkgParam.put("p_attr07_desc", "");
					pkgParam.put("p_attr08_code", "");
					pkgParam.put("p_attr08_desc", "");
					pkgParam.put("p_attr09_code", "");
					pkgParam.put("p_attr09_desc", "");
					pkgParam.put("p_attr10_code", "");
					pkgParam.put("p_attr10_desc", "");
					pkgParam.put("p_attr11_code", "");
					pkgParam.put("p_attr11_desc", "");
					pkgParam.put("p_attr12_code", "");
					pkgParam.put("p_attr12_desc", "");
					pkgParam.put("p_attr13_code", "");
					pkgParam.put("p_attr13_desc", "");
					pkgParam.put("p_attr14_code", "");
					pkgParam.put("p_attr14_desc", "");
					pkgParam.put("p_attr15_code", "");
					pkgParam.put("p_attr15_desc", "");

					pkgParam.put("p_paint_code1", "");
					pkgParam.put("p_paint_code2", "");

					pkgParam.put("p_add_attr01_desc", "");
					pkgParam.put("p_add_attr02_desc", "");
					pkgParam.put("p_add_attr03_desc", "");
					pkgParam.put("p_add_attr04_desc", "");
					pkgParam.put("p_add_attr05_desc", "");
					pkgParam.put("p_add_attr06_desc", "");
					pkgParam.put("p_add_attr07_desc", "");
					pkgParam.put("p_add_attr08_desc", "");
					pkgParam.put("p_add_attr09_desc", "");

					pkgParam.put("p_excel_upload_flag", "");

					bomStatusDAO.insertItemCodeCreate(pkgParam);

					String error_code = DisStringUtil.nullString(pkgParam.get("p_err_code"));
					String error_msg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
					String item_code = DisStringUtil.nullString(pkgParam.get("p_item_code"));

					if (!"S".equals(error_code) && !"F".equals(error_code)) {
						throw new DisException(error_msg);
					}

					if ("F".equals(error_code)) {
						throw new DisException("customer.message1", error_msg);
					}
					pkgParam1 = new HashMap<String, Object>();
					pkgParam1.put("mother_code", bomItem.get("item_code"));
					pkgParam1.put("item_code", item_code);
					pkgParam1.put("p_eco_no", commandMap.get("p_eco_no"));
					pkgParam1.put("qty", bomItem.get("qty"));
					pkgParam1.put("bom10", bomItem.get("bom10"));
					pkgParam1.put("bom11", bomItem.get("bom11"));
					pkgParam1.put("bom12", "");
					pkgParam1.put("dwg_no", "");

					if (jobType.equals("01")) {
						pkgParam1.put("bom12", "");
					} else if (jobType.equals("02")) {
						pkgParam1.put("bom12", jobType);
					} else if (jobType.equals("03")) {
						pkgParam1.put("bom12", commandMap.get("p_dwg_no"));
						pkgParam1.put("dwg_no", commandMap.get("p_dwg_no"));
					}
					pkgParam1.put("item_catalog", spstItem.get("item_catalog"));
					pkgParam1.put("states_flag", "A");
					pkgParam1.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));

					int result = bomStatusDAO.insertBomFromJobItem(pkgParam1);
					if (result == 0) {
						throw new DisException();
					}
				}
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveDwgEcoCreate
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO버튼을 선택했을때의 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveDwgEcoCreate(CommandMap commandMap) throws Exception {

		// ECO 생성
		Map<String, Object> pkgParam = new HashMap<String, Object>();
		pkgParam.put("p_permanent_temporary_flag", "5");
		pkgParam.put("p_loginid", (String) commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		pkgParam.put("p_main_description", "BOM현황에서 생성");
		ecoDAO.stxDisEcoMasterInsertProc(pkgParam);
		// 애러체크
		String err_code = DisStringUtil.nullString(pkgParam.get("p_err_code"));
		String error_msg = DisStringUtil.nullString(pkgParam.get("p_err_msg"));
		if (!"S".equals(err_code)) {
			throw new DisException();
		}

		Map<String, Object> pkgParam2 = new HashMap<String, Object>();
		pkgParam2.put("p_eng_change_order_code", pkgParam.get("p_eng_change_order_code"));
		pkgParam2.put("p_eng_change_order_desc", "BOM현황에서 생성");
		pkgParam2.put("p_permanent_temporary_flag", "5");
		pkgParam2.put("p_eco_cause", commandMap.get("p_eco_reason_code"));
		pkgParam2.put("p_design_engineer", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		pkgParam2.put("p_manufacturing_engineer", commandMap.get("p_created_by"));
		pkgParam2.put("p_loginid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		pkgParam2.put("p_eng_change_req_code", "");
		ecoDAO.stxDisEcoDetailInsertProc(pkgParam2);
		err_code = DisStringUtil.nullString(pkgParam2.get("p_err_code"));
		error_msg = DisStringUtil.nullString(pkgParam2.get("p_error_msg"));

		if (!"S".equals(err_code)) {
			throw new DisException(error_msg);
		}

		Map<String, Object> pkgHisParam = new HashMap<String, Object>();
		pkgHisParam.put("p_eco_name", pkgParam.get("p_eng_change_order_code"));
		pkgHisParam.put("p_action_type", "INSERT");
		pkgHisParam.put("p_insert_empno", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		pkgHisParam.put("p_related_ecr", "");
		pkgHisParam.put("p_type", "영구");
		pkgHisParam.put("p_eco_cause", commandMap.get("p_eco_reason_code"));
		pkgHisParam.put("p_design_engineer", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		pkgHisParam.put("p_manufacturing_engineer", commandMap.get("p_created_by"));
		pkgHisParam.put("p_states_code", "Create");
		pkgHisParam.put("p_eco_description", "BOM현황에서 생성");
		ecoDAO.insertEcoHistory(pkgHisParam);

		err_code = DisStringUtil.nullString(pkgHisParam.get("p_error_code"));
		error_msg = DisStringUtil.nullString(pkgHisParam.get("p_error_msg"));

		if (!"S".equals(err_code)) {
			throw new DisException(error_msg);
		}

		Map<String, String> returnMap = DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		returnMap.put("eco_no", (String) pkgParam.get("p_eng_change_order_code"));
		return returnMap;
	}

}

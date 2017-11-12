package stxship.dis.ems.dbMaster.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.ems.common.dao.EmsCommonDAO;
import stxship.dis.ems.common.service.EmsCommonServiceImpl;
import stxship.dis.ems.dbMaster.dao.EmsDbMasterDAO;
import stxship.dis.item.createItem.dao.CreateItemDAO;

@Service("emsDbMasterService")
public class EmsDbMasterServiceImpl extends EmsCommonServiceImpl implements EmsDbMasterService {

	@Resource(name = "emsDbMasterDAO")
	private EmsDbMasterDAO emsDbMasterDAO;

	@Resource(name = "emsCommonDAO")
	private EmsCommonDAO emsCommonDAO;
	
	@Resource(name = "createItemDAO")
	private CreateItemDAO createItemDAO;
	
	/** 
	 * @메소드명	: emsDbMasterLoginGubun
	 * @날짜		: 2016. 04. 18. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 접속 권한정보를 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> emsDbMasterLoginGubun(CommandMap commandMap) throws Exception {
		Map<String, Object> loginGubun = new HashMap<String, Object>();
		loginGubun = emsDbMasterDAO.emsDbMasterLoginGubun(commandMap.getMap());
		return loginGubun;
	}
	
	/**
	 * @메소드명 : emsDbMasterExcelExport
	 * @날짜 : 2015. 02. 22.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View emsDbMasterExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {

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

		List<Map<String, Object>> list = emsDbMasterDAO.emsDbMasterExcelExport(commandMap.getMap());

		for (Map<String, Object> rowData : list) {

			List<String> row = new ArrayList<String>();

			// 데이터 네임을 이용해서 리스트에서 뽑아냄.
			for (String p_data_name : p_data_names) {
				row.add(DisStringUtil.nullString(rowData.get(p_data_name)));
			}
			colValue.add(row);

		}
		modelMap.put("excelName", "EmsDbMaster");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();

	}

	/**
	 * @메소드명 : popUpEmsDbMasterItemApprove
	 * @날짜 : 2016. 02. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청/승인/반려 작업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpEmsDbMasterItemApprove(CommandMap commandMap) throws Exception {

		// 메일 전송 프로시져 에러 체크 결과 값
		String sErrMsg = "";
//		String sErrCode = "";
		
		int result = 0;
		String stt = "";

		String item_code_all = "";

		String p_status = commandMap.get("p_status").toString();
		String p_flag = commandMap.get("p_flag").toString();
		String loginGubun = commandMap.get("loginGubun").toString();
		String user_id = commandMap.get("user_id").toString();

		String[] item_codes = commandMap.get("p_itemCodes").toString().split(",");

		//S인 상태일때 ----------------현재는 사용하고 있지 않음
		if (p_status.equals("S")) {
			if (loginGubun.equals("plan")) {
				stt = "RAP";
			} else {
				stt = "RAD";
			}
			System.out.println("item_codes : " + item_codes.length);
			for (int i = 0; i < item_codes.length; i++) {
				String itemCode = item_codes[i].replaceAll("'", "");

				Map<String, Object> rowData = new HashMap<String, Object>();

				rowData.put("stt", stt);
				rowData.put("user_id", user_id);
				rowData.put("itemCode", itemCode);

				result = emsDbMasterDAO.popUpEmsDbMasterItemApproveModFlag(rowData);
				if (result == 0) {
					throw new DisException("요청에 실패했습니다.");
				}
			}
		} 
		//S인 상태일때
		else if (p_status.equals("C")) {
			if (loginGubun.equals("plan")) {
				stt = "RCP";
			} else {
				stt = "RCD";
			}
			for (int i = 0; i < item_codes.length; i++) {
				String itemCode = item_codes[i].replaceAll("'", "");

				Map<String, Object> rowData = new HashMap<String, Object>();

				rowData.put("stt", stt);
				rowData.put("user_id", user_id);
				rowData.put("itemCode", itemCode);

				result = emsDbMasterDAO.popUpEmsDbMasterItemApproveModFlag(rowData);
				if (result == 0) {
					throw new DisException("삭제요청에 실패했습니다.");
				}

				item_code_all = item_code_all + itemCode + ",";
			}
			item_code_all = item_code_all + ",";

			if (loginGubun.equals("plan")) {
//				/* 메일링 서비스 */
//				
//				// 사용자 정보를 가져옴
//				Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//
//				// 담당자 정보를 가져옴
//				commandMap.put("catalog_code", commandMap.get("p_catalog_code"));
//				Map<String, Object> getObtApprover = emsDbMasterDAO.popUpEmsDbMasterItemGetObtApprover(commandMap.getMap());
//				Map<String, Object> rowData1 = new HashMap<>();
//				rowData1.put("loginId", getObtApprover.get("obt_approver"));
//				Map<String, Object> userInfo1 = getUserInfo(rowData1); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//				
//				// 메일전송
//				Map<String, Object> rowData2 = new HashMap<>();
//				rowData2.put("p_itemcode", item_code_all);
//				rowData2.put("p_flag", "Item삭제");
//				rowData2.put("p_action", "");
//				rowData2.put("p_from", userInfo.get("user_name"));
//				rowData2.put("p_to", userInfo.get("ep_mail") + "@onestx.com");
//				rowData2.put("p_from_name", userInfo.get("user_name"));
//				rowData2.put("p_to_name", userInfo1.get("user_name"));
//				
//				emsCommonDAO.dbMasterSendEmail(rowData2);
//				
//				sErrMsg = DisStringUtil.nullString(rowData2.get("errbuf"));
////				sErrCode = DisStringUtil.nullString(rowData2.get("retcode"));
//				
//				// 오류가 있으면 스탑
//				if (!"".equals(sErrMsg)) {
//					throw new DisException(sErrMsg);
//				}
		
			} else {
//				/* 메일링 서비스 */
//				
//				// 사용자 정보를 가져옴
//				Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//
//				// 담당자 정보를 가져옴
//				Map<String, Object> rowData1 = emsDbMasterDAO.popUpEmsDbMasterItemGetDwgApprover(commandMap.getMap());
//				rowData1.put("loginId", rowData1.get("emp_no"));
//				Map<String, Object> userInfo1 = getUserInfo(rowData1); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//				
//				// 메일전송
//				Map<String, Object> rowData2 = new HashMap<>();
//				rowData2.put("p_itemcode", item_code_all);
//				rowData2.put("p_flag", "Item삭제");
//				rowData2.put("p_action", "");
//				rowData2.put("p_from", userInfo.get("user_name"));
//				rowData2.put("p_to", userInfo.get("ep_mail") + "@onestx.com");
//				rowData2.put("p_from_name", userInfo.get("user_name"));
//				rowData2.put("p_to_name", userInfo1.get("user_name"));
//				
//				emsCommonDAO.dbMasterSendEmail(rowData2);
//				
//				sErrMsg = DisStringUtil.nullString(rowData2.get("errbuf"));
////				sErrCode = DisStringUtil.nullString(rowData2.get("retcode"));
//				
//				// 오류가 있으면 스탑
//				if (!"".equals(sErrMsg)) {
//					throw new DisException(sErrMsg);
//				}
			}
		} 
		//승인 또는 반려를 선택할 경우
		else {
			// 승인
			if (p_flag.equals("APP")) {

				
				for (int i = 0; i < item_codes.length; i++) {
					String itemCode = item_codes[i].replaceAll("'", "");

					Map<String, Object> rowData = new HashMap<String, Object>();
					if (p_status.equals("RCD") || p_status.equals("RCP")) {
						stt = "C";
					} else {
						stt = "S";
					}
					rowData.put("stt", stt);
					rowData.put("user_id", user_id);
					rowData.put("itemCode", itemCode);
					result = emsDbMasterDAO.popUpEmsDbMasterItemApproveModFlag(rowData);
					if (result == 0) {
						throw new DisException("승인요청에 실패했습니다.");
					}

					// 추가 승인일 경우 ERP에 입력
					String sErrCode = "S";
					if (p_status.equals("RAD") || p_status.equals("RAP")) {
						// PLM 및 ERP ITEM INTERFACE
						sErrCode = itemInterface(itemCode, commandMap);
					}
					if (!"S".equals(sErrCode)) {
						throw new DisException("추가 승인에 실패했습니다.");
					}
				}

			} else if (p_flag.equals("REJ")) {
				// 반려
				if (p_status.equals("RAD") || p_status.equals("RAP")) {

					for (int i = 0; i < item_codes.length; i++) {
						String itemCode = item_codes[i].replaceAll("'", "");

						Map<String, Object> rowData1 = new HashMap<String, Object>();
						rowData1.put("catalog_code", itemCode.substring(0, 5));
						rowData1.put("item_code", itemCode.substring(6, 10));
						result = emsDbMasterDAO.popUpEmsDbMasterItemApproveDelItem(rowData1);
						if (result == 0) {
							throw new DisException("반려요청에 실패했습니다.");
						}

						Map<String, Object> rowData2 = new HashMap<String, Object>();
						rowData2.put("catalog_code", itemCode.substring(0, 5));
						rowData2.put("item_code", itemCode.substring(6, 10));
						rowData2.put("spec_code", itemCode.substring(10));
						result = emsDbMasterDAO.popUpEmsDbMasterItemApproveDelSpec(rowData2);
						if (result == 0) {
							throw new DisException("반려요청에 실패했습니다.");
						}

						Map<String, Object> rowData3 = new HashMap<String, Object>();
						rowData3.put("item_code", itemCode);
						result = emsDbMasterDAO.popUpEmsDbMasterItemApproveDelMaster(rowData3);
						if (result == 0) {
							throw new DisException("반려요청에 실패했습니다.");
						}
					}

				} else {
					for (int i = 0; i < item_codes.length; i++) {
						String itemCode = item_codes[i].replaceAll("'", "");

						Map<String, Object> rowData = new HashMap<String, Object>();
						rowData.put("stt", "S");
						rowData.put("user_id", user_id);
						rowData.put("itemCode", itemCode);
						result = emsDbMasterDAO.popUpEmsDbMasterItemApproveModFlag(rowData);
						if (result == 0) {
							throw new DisException("반려요청에 실패했습니다.");
						}
					}
				}
			}
		}

		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	// PLM, ERP, TBC Item 생성.
	private String itemInterface(String p_item_code, CommandMap commandMap) throws Exception {

		//Map<String, Object> result = new HashMap<String, Object>();
		
		String p_weight = "1";
		String p_user_id = (String) commandMap.get("user_id");
		
		Map<String, Object> dbox = emsDbMasterDAO.popUpEmsDbMasterItemApproveCreateItemList(p_item_code);

		dbox.put("p_catalog_code", dbox.get("catalog"));
		dbox.put("p_ship_type", "");
		dbox.put("p_weight", p_weight);
		dbox.put("p_loginid", p_user_id);
		
		dbox.put("p_old_item_code", "EMS");      // OLD CODE를 EMS로 주면, ATTR00_DESC를 DESCRIPTION으로 활용함 
		dbox.put("p_attr00_code", "");
		dbox.put("p_attr00_desc", dbox.get("item_desc"));
		dbox.put("p_attr01_code", "");
		dbox.put("p_attr01_desc", "");
		dbox.put("p_attr02_code", "");
		dbox.put("p_attr02_desc", "");
		dbox.put("p_attr03_code", "");
		dbox.put("p_attr03_desc", "");
		dbox.put("p_attr04_code", "");
		dbox.put("p_attr04_desc", "");
		dbox.put("p_attr05_code", "");
		dbox.put("p_attr05_desc", "");
		dbox.put("p_attr06_code", "");
		dbox.put("p_attr06_desc", "");
		dbox.put("p_attr07_code", "");
		dbox.put("p_attr07_desc", "");
		dbox.put("p_attr08_code", "");
		dbox.put("p_attr08_desc", "");
		dbox.put("p_attr09_code", "");
		dbox.put("p_attr09_desc", "");
		dbox.put("p_attr10_code", "");
		dbox.put("p_attr10_desc", "");
		dbox.put("p_attr11_code", "");
		dbox.put("p_attr11_desc", "");
		dbox.put("p_attr12_code", "");
		dbox.put("p_attr12_desc", "");
		dbox.put("p_attr13_code", "");
		dbox.put("p_attr13_desc", "");
		dbox.put("p_attr14_code", "");
		dbox.put("p_attr14_desc", "");
		dbox.put("p_attr15_code", "");
		dbox.put("p_attr15_desc", "");
		dbox.put("p_paint_code1", "");
		dbox.put("p_paint_code2", "");
		dbox.put("p_add_attr01_desc", "");
		dbox.put("p_add_attr02_desc", "");
		dbox.put("p_add_attr03_desc", "");
		dbox.put("p_add_attr04_desc", "");
		dbox.put("p_add_attr05_desc", "");
		dbox.put("p_add_attr06_desc", "");
		dbox.put("p_add_attr07_desc", "");
		dbox.put("p_add_attr08_desc", "");
		dbox.put("p_add_attr09_desc", "");
		dbox.put("p_excel_upload_flag", "");
		dbox.put("p_attr_list", p_item_code);

		// 프로시저 실행
		//emsDbMasterDAO.popUpEmsDbMasterItemApproveCreateItemInsert(dbox);
		createItemDAO.insertItemCodeCreate(dbox);
		
		// 프로시저 결과 받음
		String sErrMsg = DisStringUtil.nullString(dbox.get("p_err_msg"));
		String sErrCode = DisStringUtil.nullString(dbox.get("p_err_code"));
		String sItemCode = DisStringUtil.nullString(dbox.get("p_item_code"));

		// 오류가 있으면
		if (!"".equals(sErrMsg)) {
			throw new Exception(sErrMsg);
		}

		return sErrCode;
	}

	/**
	 * @메소드명 : popUpEmsDbMasterItemSave
	 * @날짜 : 2016. 02. 24.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Master Item 저장 작업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpEmsDbMasterItemSave(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		// 결과값 최초
		int result = 0;

		// 설계 권한으로 저장 시
		if (commandMap.get("loginGubun").equals("plan")) {
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("mother_buy", saveList.get(i).get("mother_buy"));
				rowData.put("sub_dwg_code", saveList.get(i).get("sub_dwg_code"));
				rowData.put("remark", saveList.get(i).get("remark"));

				rowData.put("user_id", commandMap.get("user_id"));
				rowData.put("item_code", saveList.get(i).get("item_code"));

				result = emsDbMasterDAO.popUpEmsDbMasterItemSavePlan(rowData);
			}
		}
		// 구매 권한으로 저장 시
		else if (commandMap.get("loginGubun").equals("obtain")) {
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("use_ssc_type", saveList.get(i).get("use_ssc_type"));
				rowData.put("voyage_no", saveList.get(i).get("voyage_no"));
				rowData.put("importance", saveList.get(i).get("importance"));
				rowData.put("main_accessaries", saveList.get(i).get("main_accessaries"));
				rowData.put("equip", saveList.get(i).get("equip"));
				rowData.put("unitcost_contract", saveList.get(i).get("unitcost_contract"));
				rowData.put("price_breakdown", saveList.get(i).get("price_breakdown"));
				rowData.put("remark", saveList.get(i).get("remark"));
				rowData.put("is_direct_input", saveList.get(i).get("is_direct_input"));
				rowData.put("is_owner_item", saveList.get(i).get("is_owner_item"));

				rowData.put("user_id", commandMap.get("user_id"));
				rowData.put("item_code", saveList.get(i).get("item_code"));

				result = emsDbMasterDAO.popUpEmsDbMasterItemSaveObtain(rowData);
			}
		}

		if (result == 0) {
			throw new DisException("반려요청에 실패했습니다.");
		}
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpEmsDbMasterAddSave(CommandMap commandMap) throws Exception {
		
		// 메일 전송 프로시져 에러 체크 결과 값
		String sErrMsg = "";
//		String sErrCode = "";
		
		//jqGrid로 부터 받아온 리스트를 List<Map<String, Object>> 형태로 변환
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		// 결과값 최초
		int result = 0;
    	
		String p_process = (String) commandMap.get("p_process");
		
		String		catalog_code    = "";
		String planPart = "440300"; //기술기획으로 강제 셋팅
		String item_code_all = "";
		
		String loginGubun = (String) commandMap.get("loginGubun");
		String user_id    = (String) commandMap.get("loginId");
		
		if(p_process.equals("add_item")) {
		
			catalog_code    = (String) commandMap.get("p_catalog_code");

			//입력한 품목 리스트 INSERT
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("catalog_code", catalog_code);
				rowData.put("i_item_code", saveList.get(i).get("i_item_code"));
				rowData.put("i_item_desc", saveList.get(i).get("i_item_desc"));
				rowData.put("user_id", user_id);

				result = emsDbMasterDAO.popUpEmsDbMasterItemInsertItem(rowData);
				if (result == 0) {
					throw new DisException("등록에 실패했습니다.");
				}
			}
			
			//품목 하나 당 사양테이블 '00001' 번 INSERT
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("catalog_code", catalog_code);
				rowData.put("i_item_code", saveList.get(i).get("i_item_code"));
				rowData.put("i_item_desc", saveList.get(i).get("i_item_desc"));
				rowData.put("spec_code", "00001");
				rowData.put("spec_name1", "");
				rowData.put("spec_name2", "");
				rowData.put("spec_name3", "");
				rowData.put("user_id", user_id);

				result = emsDbMasterDAO.popUpEmsDbMasterItemInsertSpec(rowData);
				if (result == 0) {
					throw new DisException("등록에 실패했습니다.");
				}
			}
			
			Map<String, Object> addMaster = new HashMap<String, Object>();
			addMaster.put("catalog_code", commandMap.get("p_catalog_code"));
			
			Map<String, Object> getEquipment = emsDbMasterDAO.popUpEmsDbMasterItemGetEquipment(addMaster);
			Map<String, Object> getMiddle = emsDbMasterDAO.popUpEmsDbMasterItemGetMiddle(addMaster);
			Map<String, Object> getDwg = emsDbMasterDAO.popUpEmsDbMasterItemGetDwg(addMaster);
			Map<String, Object> getObtainLt = emsDbMasterDAO.popUpEmsDbMasterItemGetObtainLt(addMaster);
			Map<String, Object> getObtApprover = emsDbMasterDAO.popUpEmsDbMasterItemGetObtApprover(addMaster);
			
			//품목 하나 당 STX_EMS_DB_MASTER 에 INSERT
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("catalog_code", catalog_code);
				rowData.put("item_code", catalog_code + "-" + saveList.get(i).get("i_item_code") + "00001");
				if(loginGubun.equals("plan")){
					rowData.put("stt", "RAP");
				} else {
					rowData.put("stt", "RAD");
				}
				rowData.put("catalog_name", "");
				rowData.put("equip_name", getEquipment.get("value_name"));
				rowData.put("dwg_code", getDwg.get("dwg_code"));
				rowData.put("dwg_name", "");
				rowData.put("middle_code", getMiddle.get("middle_code"));
				rowData.put("middle_name", "");
				rowData.put("plan_part", planPart);
				rowData.put("obtain_lt", getObtainLt.get("obtain_lt"));
				rowData.put("buyer", getObtApprover.get("obt_approver"));
				rowData.put("user_id", user_id);
				
				result = emsDbMasterDAO.popUpEmsDbMasterItemInsertMaster(rowData);
				if (result == 0) {
					throw new DisException("등록에 실패했습니다.");
				}
				item_code_all = item_code_all + (catalog_code + "-" + saveList.get(i).get("i_item_code") + "00001") + ",";
			}
			item_code_all = item_code_all + ",";
			item_code_all = item_code_all.replaceAll(",,", "");

			if(loginGubun.equals("plan")) {
//				/* 메일링 서비스 */
//				
//				// 사용자 정보를 가져옴
//				Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//
//				// 담당자 정보를 가져옴
//				Map<String, Object> rowData1 = new HashMap<>();
//				rowData1.put("loginId", getObtApprover.get("obt_approver"));
//				Map<String, Object> userInfo1 = getUserInfo(rowData1); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//				
//				// 메일전송
//				Map<String, Object> rowData2 = new HashMap<>();
//				rowData2.put("p_itemcode", item_code_all);
//				rowData2.put("p_flag", "품목추가");
//				rowData2.put("p_action", "");
//				rowData2.put("p_from", userInfo.get("user_name"));
//				rowData2.put("p_to", userInfo.get("ep_mail") + "@onestx.com");
//				rowData2.put("p_from_name", userInfo.get("user_name"));
//				rowData2.put("p_to_name", userInfo1.get("user_name"));
//				
//				emsCommonDAO.dbMasterSendEmail(rowData2);
//				
//				sErrMsg = DisStringUtil.nullString(rowData2.get("errbuf"));
////				sErrCode = DisStringUtil.nullString(rowData2.get("retcode"));
//				
//				// 오류가 있으면 스탑
//				if (!"".equals(sErrMsg)) {
//					throw new DisException(sErrMsg);
//				}
				
			} else {
//				/* 메일링 서비스 */
//				
//				// 사용자 정보를 가져옴
//				Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//
//				// 담당자 정보를 가져옴
//				Map<String, Object> rowData1 = emsDbMasterDAO.popUpEmsDbMasterItemGetDwgApprover(commandMap.getMap());
//				rowData1.put("loginId", rowData1.get("emp_no"));
//				Map<String, Object> userInfo1 = getUserInfo(rowData1); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//				
//				// 메일전송
//				Map<String, Object> rowData2 = new HashMap<>();
//				rowData2.put("p_itemcode", item_code_all);
//				rowData2.put("p_flag", "품목추가");
//				rowData2.put("p_action", "");
//				rowData2.put("p_from", userInfo.get("user_name"));
//				rowData2.put("p_to", userInfo.get("ep_mail") + "@onestx.com");
//				rowData2.put("p_from_name", userInfo.get("user_name"));
//				rowData2.put("p_to_name", userInfo1.get("user_name"));
//				
//				emsCommonDAO.dbMasterSendEmail(rowData2);
//				
//				sErrMsg = DisStringUtil.nullString(rowData2.get("errbuf"));
////				sErrCode = DisStringUtil.nullString(rowData2.get("retcode"));
//				
//				// 오류가 있으면 스탑
//				if (!"".equals(sErrMsg)) {
//					throw new DisException(sErrMsg);
//				}
			}
			
		} else if(p_process.equals("add_spec")) {
			
			catalog_code      = (String) commandMap.get("p_catalog_code1");
			String itemDesc  = (String) commandMap.get("p_itemname");
			String itemCode = (String) commandMap.get("p_itemcode");

			//입력한 사양 리스트 INSERT
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				
				//String itemSpecDesc = itemDesc + "-" + saveList.get(i).get("spec_name1") + "-" + saveList.get(i).get("spec_name2") + "-" + saveList.get(i).get("spec_name3");
				String itemSpecDesc = itemDesc;
				if(!"".equals(saveList.get(i).get("spec_name1")))
				{
					itemSpecDesc += "-" + saveList.get(i).get("spec_name1");
				}
				if(!"".equals(saveList.get(i).get("spec_name2")))
				{
					itemSpecDesc += "-" + saveList.get(i).get("spec_name2");
				}
				if(!"".equals(saveList.get(i).get("spec_name3")))
				{
					itemSpecDesc += "-" + saveList.get(i).get("spec_name3");
				}				
				
				
				
				rowData.put("catalog_code", catalog_code);
				rowData.put("i_item_code", itemCode);
				rowData.put("i_item_desc", itemSpecDesc);
				rowData.put("spec_code", saveList.get(i).get("spec_code"));
				rowData.put("spec_name1", saveList.get(i).get("spec_name1"));
				rowData.put("spec_name2", saveList.get(i).get("spec_name2"));
				rowData.put("spec_name3", saveList.get(i).get("spec_name3"));
				rowData.put("user_id", user_id);

				result = emsDbMasterDAO.popUpEmsDbMasterItemInsertSpec(rowData);
				if (result == 0) {
					throw new DisException("등록에 실패했습니다.");
				}
			}
			
			Map<String, Object> addMaster = new HashMap<String, Object>();
			addMaster.put("catalog_code", commandMap.get("p_catalog_code1"));
			
			Map<String, Object> getEquipment = emsDbMasterDAO.popUpEmsDbMasterItemGetEquipment(addMaster);
			Map<String, Object> getMiddle = emsDbMasterDAO.popUpEmsDbMasterItemGetMiddle(addMaster);
			Map<String, Object> getDwg = emsDbMasterDAO.popUpEmsDbMasterItemGetDwg(addMaster);
			Map<String, Object> getObtainLt = emsDbMasterDAO.popUpEmsDbMasterItemGetObtainLt(addMaster);
			Map<String, Object> getObtApprover = emsDbMasterDAO.popUpEmsDbMasterItemGetObtApprover(addMaster);
			
			//품목 하나 당 STX_EMS_DB_MASTER 에 INSERT
			for (int i = 0; i < saveList.size(); i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("catalog_code", catalog_code);
				rowData.put("item_code", catalog_code + "-" + saveList.get(i).get("item_code") + saveList.get(i).get("spec_code"));
				if(loginGubun.equals("plan")){
					rowData.put("stt", "RAP");
				} else {
					rowData.put("stt", "RAD");
				}
				rowData.put("catalog_name", "");
				rowData.put("equip_name", getEquipment.get("value_name"));
				rowData.put("dwg_code", getDwg.get("dwg_code"));
				rowData.put("dwg_name", "");
				rowData.put("middle_code", getMiddle.get("middle_code"));
				rowData.put("middle_name", "");
				rowData.put("plan_part", planPart);
				rowData.put("obtain_lt", getObtainLt.get("obtain_lt"));
				rowData.put("buyer", getObtApprover.get("obt_approver"));
				rowData.put("user_id", user_id);
				
				result = emsDbMasterDAO.popUpEmsDbMasterItemInsertMaster(rowData);
				if (result == 0) {
					throw new DisException("등록에 실패했습니다.");
				}
				item_code_all = item_code_all + (catalog_code + "-" + saveList.get(i).get("item_code") + saveList.get(i).get("spec_code")) + ",";
			}
			item_code_all = item_code_all + ",";
			
			if(loginGubun.equals("plan")) {
//				/* 메일링 서비스 */
//				
//				// 사용자 정보를 가져옴
//				Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//
//				// 담당자 정보를 가져옴
//				Map<String, Object> rowData1 = new HashMap<>();
//				rowData1.put("loginId", getObtApprover.get("obt_approver"));
//				Map<String, Object> userInfo1 = getUserInfo(rowData1); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//				
//				// 메일전송
//				Map<String, Object> rowData2 = new HashMap<>();
//				rowData2.put("p_itemcode", item_code_all);
//				rowData2.put("p_flag", "사양추가");
//				rowData2.put("p_action", "");
//				rowData2.put("p_from", userInfo.get("user_name"));
//				rowData2.put("p_to", userInfo.get("ep_mail") + "@onestx.com");
//				rowData2.put("p_from_name", userInfo.get("user_name"));
//				rowData2.put("p_to_name", userInfo1.get("user_name"));
//				
//				emsCommonDAO.dbMasterSendEmail(rowData2);
//				
//				sErrMsg = DisStringUtil.nullString(rowData2.get("errbuf"));
////				sErrCode = DisStringUtil.nullString(rowData2.get("retcode"));
//				
//				// 오류가 있으면 스탑
//				if (!"".equals(sErrMsg)) {
//					throw new DisException(sErrMsg);
//				}
			} else {
//				/* 메일링 서비스 */
//				
//				// 사용자 정보를 가져옴
//				Map<String, Object> userInfo = getUserInfo(commandMap.getMap()); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//
//				// 담당자 정보를 가져옴
//				Map<String, Object> rowData1 = emsDbMasterDAO.popUpEmsDbMasterItemGetDwgApprover(commandMap.getMap());
//				rowData1.put("loginId", rowData1.get("emp_no"));
//				Map<String, Object> userInfo1 = getUserInfo(rowData1); // getUserInfo() : EmsCommonServiceImpl 로 부터 상속받아 사용
//				
//				// 메일전송
//				Map<String, Object> rowData2 = new HashMap<>();
//				rowData2.put("p_itemcode", item_code_all);
//				rowData2.put("p_flag", "사양추가");
//				rowData2.put("p_action", "");
//				rowData2.put("p_from", userInfo.get("user_name"));
//				rowData2.put("p_to", userInfo.get("ep_mail") + "@onestx.com");
//				rowData2.put("p_from_name", userInfo.get("user_name"));
//				rowData2.put("p_to_name", userInfo1.get("user_name"));
//				
//				emsCommonDAO.dbMasterSendEmail(rowData2);
//				
//				sErrMsg = DisStringUtil.nullString(rowData2.get("errbuf"));
////				sErrCode = DisStringUtil.nullString(rowData2.get("retcode"));
//				
//				// 오류가 있으면 스탑
//				if (!"".equals(sErrMsg)) {
//					throw new DisException(sErrMsg);
//				}
			}

		}
		
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	/** 
	 * @메소드명	: popUpEmsDbMasterAddGetCatalogName
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 조회 시 CATALOG NAME 정보를 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpEmsDbMasterAddGetCatalogName(CommandMap commandMap) {
		return emsDbMasterDAO.popUpEmsDbMasterAddGetCatalogName(commandMap.getMap());
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddLastNum
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 품목그리드 추가 버튼 팝업창에서 행추가시 마지막 번호 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpEmsDbMasterAddItemLastNum(CommandMap commandMap) {
		return emsDbMasterDAO.popUpEmsDbMasterAddItemLastNum(commandMap.getMap());
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddLastNum
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 사양그리드 추가 버튼 팝업창에서 행추가시 마지막 번호 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpEmsDbMasterAddSpecLastNum(CommandMap commandMap) {
		return emsDbMasterDAO.popUpEmsDbMasterAddSpecLastNum(commandMap.getMap());
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpEmsDbMasterShipAppSave(CommandMap commandMap) throws Exception {

		// 결과값 최초
		int result = 0;
		
		String user_id = commandMap.get("loginId").toString();
    	
		String[] item_codes = commandMap.get("p_itemCodes").toString().replaceAll(",''", "").split(",");  

		String[] ship_kind  = commandMap.get("p_ship_kind").toString().replaceAll(",''", "").split(",");
		String[] ship_kind1 = commandMap.get("p_ship_kind1").toString().replaceAll(",''", "").split(",");
		
		if(!ship_kind[0].equals("''")){
			for(int i = 0; i < ship_kind.length; i++) {
				String[] shipKind = ship_kind[i].replaceAll("'", "").split("_");
				for(int j = 0; j < item_codes.length; j++) {
					String itemCode = item_codes[j].replaceAll("'", "");
					
					Map<String, Object> rowData = new HashMap<String, Object>();
					rowData.put("ship_type", shipKind.length<2?"":shipKind[0]);
					rowData.put("ship_size", shipKind.length<2?"":shipKind[1]);
					rowData.put("item_code", itemCode);
					rowData.put("use_yn", "Y");
					rowData.put("user_id", user_id);
					
					result = emsDbMasterDAO.popUpEmsDbMasterShipAppSave(rowData);
					if (result == 0) {
						throw new DisException("등록에 실패했습니다.");
					}
				}					
			}
		}
		if(!ship_kind1[0].equals("''")){
			for(int i = 0; i < ship_kind1.length; i++) {
				String[] shipKind = ship_kind1[i].replaceAll("'", "").split("_");
				for(int j = 0; j < item_codes.length; j++) {
					String itemCode = item_codes[j].replaceAll("'", "");
					
					Map<String, Object> rowData = new HashMap<String, Object>();
					rowData.put("ship_type", shipKind.length<2?"":shipKind[0]);
					rowData.put("ship_size", shipKind.length<2?"":shipKind[1]);
					rowData.put("item_code", itemCode);
					rowData.put("use_yn", "N");
					rowData.put("user_id", user_id);
					
					result = emsDbMasterDAO.popUpEmsDbMasterShipAppSave(rowData);
					if (result == 0) {
						throw new DisException("등록에 실패했습니다.");
					}
				}
			}
		}
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpEmsDbMasterShipDpSave(CommandMap commandMap) throws Exception {
		
		//jqGrid로 부터 받아온 리스트를 List<Map<String, Object>> 형태로 변환
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());

		// 결과값 최초
		int result = 0;
		
		//테이블 데이터 전체 삭제
		result = emsDbMasterDAO.popUpEmsDbMasterShipDpDel();
		
		//입력 데이터 INSERT
		for (int i = 0; i < saveList.size(); i++) {
			Map<String, Object> rowData = new HashMap<String, Object>();
			rowData.put("ship_type", saveList.get(i).get("ship_type"));
			rowData.put("ship_size", saveList.get(i).get("ship_size"));
			rowData.put("ship_order", saveList.get(i).get("ship_order"));
			
			result = emsDbMasterDAO.popUpEmsDbMasterShipDpSave(rowData);
			if (result == 0) {
				throw new DisException("등록에 실패했습니다.");
			}
		}
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
	/** 
	 * @메소드명	: popUpDbMasterManagerSave
	 * @날짜		: 2016. 02. 28. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 납기관리자 팝업창 : 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> popUpDbMasterManagerSave(CommandMap commandMap) throws Exception {
		
		int result = 0;
		
		String user_nm = "";
		String user_id = "";
		String oper = "";
		
		List<Map<String, Object>> managerList = DisJsonUtil.toList(commandMap.get("chmResultList"));
		
		for (int i=0; i<managerList.size(); i++) {
			user_nm = (String) managerList.get(i).get("user_nm");
			user_id = (String) managerList.get(i).get("user_id");
			oper = (String) managerList.get(i).get("oper");
			
			Map<String, Object> rowData = new HashMap<>();
			rowData.put("user_nm", user_nm);
			rowData.put("user_id", user_id);
			rowData.put("loginId", commandMap.get("loginId"));
			
			// 추가인 경우
			if ("I".equals(oper)) {
				result = emsDbMasterDAO.insertManager(rowData);
				if (result == 0) {
					throw new DisException("등록에 실패했습니다.");
				}
			}
			// 삭제인 경우
			else if ("D".equals(oper)) {
				result = emsDbMasterDAO.deleteManager(rowData);
//				if (result == 0) {
//					throw new DisException("등록에 실패했습니다.");
//				}
			}
		}
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
}

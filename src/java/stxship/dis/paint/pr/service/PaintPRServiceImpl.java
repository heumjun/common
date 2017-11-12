package stxship.dis.paint.pr.service;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.paint.pr.dao.PaintPRDAO;

@Service("paintPRService")
public class PaintPRServiceImpl extends CommonServiceImpl implements PaintPRService {

	@Resource(name = "paintPRDAO")
	private PaintPRDAO paintPRDAO;

	/**
	 * @메소드명 : savePaintPRGruop
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR그룹 저장(PR GROUP LIST의 추가 그룹생성)
	 * 자동생성 5개 그룹제외 6번부터 생성
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> savePaintPRGruop(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> prGroupList = DisJsonUtil.toList(commandMap.get("prGroupList"));

		// Block List 삭제
		int result = 0;
		for (Map<String, Object> groupInfo : prGroupList) {
			// 저장
			groupInfo.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			groupInfo.put("project_no", commandMap.get("p_project_no"));
			groupInfo.put("revision", commandMap.get("p_revision"));
			// 자동생성된 5개 그룹은 화면에서 삭제 불가
			if (DisConstants.DELETE.equals(groupInfo.get(DisConstants.FROM_GRID_OPER))) {
				result = paintPRDAO.deletePaintPRGroup(groupInfo);
			}
			// 자동생성 5개 그룹제외 6번부터 생성
			if (DisConstants.INSERT.equals(groupInfo.get(DisConstants.FROM_GRID_OPER))) {
				result = paintPRDAO.insertManualPaintPRGroup(groupInfo);
			}

			if (result == 0) {
				throw new DisException();
			}

		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : saveCreatePaintPR
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR 생성
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	// pr생성은 erp 관련하여 트렌젝션 관리를 하지 않는다.
	// @Transactional(propagation = Propagation.REQUIRED, rollbackFor = {
	// Exception.class })
	public Map<String, String> saveCreatePaintPR(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> prGroupItemList = DisJsonUtil.toList(commandMap.get("prGroupItemList"));
		String personId = "";
		String updatePersonId = "";
		String deptId = "";
		String projectId = "";
		String deliver_to_location_id = "";
		String prNo = "";
		String errMsg = "";
		String userId = (String) commandMap.get(DisConstants.SET_DB_LOGIN_ID);
		int groupCode = Integer.parseInt((String)commandMap.get("group_code"));
		
		// 자동생성그룹이 아닌경우(그룹코드 6이상)
		if(groupCode > 5) {
			// 그룹에 저장된 아이템을 삭제 한다.
			paintPRDAO.deletePrItemList(commandMap.getMap());
		}
		
		// item check
		for (Map<String, Object> prGroupItem : prGroupItemList) {
			prGroupItem.put(DisConstants.SET_DB_LOGIN_ID, userId);
			prGroupItem.put("p_project_no", commandMap.get("p_project_no"));
			prGroupItem.put("p_revision", commandMap.get("p_revision"));
			prGroupItem.put("group_code", commandMap.get("group_code"));

			// 자동생성그룹이 아닌경우(그룹코드 6이상)
			if(groupCode > 5) {
				// PR 생성할 아이템이 중복인경우는 에러
				int cnt = paintPRDAO.selectPrItemList(prGroupItem);
				if (cnt > 0) {
					throw new DisException("중복된 PAINT ITEM이 존재 합니다.[" + prGroupItem.get("paint_item") + "]");
				}
				// PR 생성 아이템을 저장
				paintPRDAO.insertPrItemList(prGroupItem);
			}
			// erp item에서 status를 취득
			List<Map<String, Object>> itemList = paintPRDAO.selectItemStatusCode(prGroupItem);
			String childId = "";
			for (Map<String, Object> itemInfo : itemList) {
				if ("inactive".equals(itemInfo.get("inventory_item_status_code"))) {
					errMsg += ("".equals(errMsg) ? "" : "\n")
							+ DisMessageUtil.getMessage("paint.message16",
									new String[] { (String) prGroupItem.get("paint_item") });
				}

				childId = mapGetString(itemInfo, "inventory_item_id");
			}

			if ("".equals(childId)) {
				errMsg += ("".equals(errMsg) ? "" : "\n")
						+ DisMessageUtil.getMessage("paint.message17",
								new String[] { (String) prGroupItem.get("paint_item") });
			} else {
				prGroupItem.put("child_id", childId);
				prGroupItem.put("uom", paintPRDAO.selectPaintItemUom(prGroupItem));
			}
		}

		if (!"".equals(errMsg)) {
			throw new DisException(errMsg);
		}

		// Person & Dept Check
		commandMap.put("user_id", userId);

		List<Map<String, Object>> userList = paintPRDAO.selectUserInfo(commandMap.getMap());

		for (Map<String, Object> userInfo : userList) {

			personId = mapGetString(userInfo, "person_id");
			updatePersonId = mapGetString(userInfo, "user_id");
			deptId = mapGetString(userInfo, "attribute1");

		}

		if (personId.equals("")) {
			errMsg += ("".equals(errMsg) ? "" : "\n")
					+ DisMessageUtil.getMessage("paint.message18", new String[] { userId });
		}

		if (deptId.equals("")) {
			errMsg += ("".equals(errMsg) ? "" : "\n")
					+ DisMessageUtil.getMessage("paint.message19", new String[] { userId });
		}

		if (!"".equals(errMsg)) {
			throw new DisException(errMsg);
		}

		// Project Check
		List<Map<String, Object>> projectList = paintPRDAO.selectProjectInfo(commandMap.getMap());

		for (Map<String, Object> projectInfo : projectList) {
			projectId = mapGetString(projectInfo, "project_id");
			deliver_to_location_id = mapGetString(projectInfo, "deliver_to_location_id");
		}

		if (projectId.equals("")) {
			errMsg += ("".equals(errMsg) ? "" : "\n")
					+ DisMessageUtil.getMessage("paint.message20",
							new String[] { (String) commandMap.get("p_project_no") });
		}
		if (deliver_to_location_id.equals("")) {
			errMsg += ("".equals(errMsg) ? "" : "\n")
					+ DisMessageUtil.getMessage("paint.message21",
							new String[] { (String) commandMap.get("p_project_no") });
		}

		if (!"".equals(errMsg)) {
			throw new DisException(errMsg);
		}

		String batchId = paintPRDAO.selectPORequest();
		int result = 0;
		for (Map<String, Object> prGroupItem : prGroupItemList) {

			prGroupItem.put("update_person_id", updatePersonId);
			prGroupItem.put("deliver_to_location_id", deliver_to_location_id);
			prGroupItem.put("pr_date", commandMap.get("created_date"));
			prGroupItem.put("pr_desc", commandMap.get("pr_desc"));
			prGroupItem.put("batch_id", batchId);
			prGroupItem.put("person_id", personId);
			prGroupItem.put("dept_id", deptId);
			prGroupItem.put("paint_plan_name", commandMap.get("p_project_no"));
			prGroupItem.put("project_id", projectId);

			result = paintPRDAO.insertPORequisitionInterface(prGroupItem);
			if (result == 0) {
				throw new DisException("po_requisitions_interface 입력실패");
			}

		}

		prNo = insertPaintPR("82", batchId, updatePersonId, "PNT");

		commandMap.put("pr_no", prNo);
		result = paintPRDAO.updatePaintPRGroup(commandMap.getMap());

		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : mapGetString
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Map에서 String으로 취득
	 * </pre>
	 * 
	 * @param map
	 * @param colNm
	 * @return
	 */
	private String mapGetString(Map<String, Object> map, String colNm) {

		Object obj = map.get(colNm);

		if (obj == null) {
			return "";
		} else {
			if (obj instanceof String) {
				return (String) obj;
			} else if (obj instanceof BigDecimal) {
				return ((BigDecimal) map.get(colNm)).toString();
			} else if (obj instanceof Integer) {
				return ((Integer) map.get(colNm)).toString();
			} else if (obj instanceof Double) {
				double number = (Double) map.get(colNm);
				return String.format("%.0f", number);
			} else {
				return (String) obj;
			}
		}
	}

	/**
	 * @메소드명 : insertPaintPR
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR의 저장후 PR번호 취득
	 * </pre>
	 * 
	 * @param organization
	 * @param batchId
	 * @param updatePersonId
	 * @param typeCode
	 * @return
	 * @throws Exception
	 */
	private String insertPaintPR(String organization, String batchId, String updatePersonId, String typeCode)
			throws Exception {
		Map<String, Object> procedureParam = new HashMap<String, Object>();

		procedureParam.put("p_organization_id", organization);
		procedureParam.put("p_batch_id", batchId);
		procedureParam.put("p_user_id", updatePersonId);
		procedureParam.put("p_source_type_code", typeCode);
		procedureParam.put("p_requisition_header_id", "");
		procedureParam.put("p_pr_no", "a");
		procedureParam.put("p_error_msg", "");
		procedureParam.put("p_error_code", "");
		paintPRDAO.procedurePrRequestProc(procedureParam);
		if (procedureParam.get("p_error_code") == null) {
			throw new DisException("ERP로부터 PR생성에 실패하였습니다.");
		}
		if ("S".equals(procedureParam.get("p_error_code"))) {
			return (String) procedureParam.get("p_pr_no");
		} else {
			throw new DisException((String) procedureParam.get("p_error_msg"));
		}
	}

	/**
	 * @메소드명 : prBlockExcelImport
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR Block의 엑셀 취득
	 * </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@Override
	public ModelAndView prBlockExcelImport(File file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();

		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
		org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);

		Iterator<Row> rowIterator = sheet.iterator();

		List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();

		while (rowIterator.hasNext()) {

			Row row = rowIterator.next();
			System.out.println(row.getRowNum() + ">>" + row.getCell(0) + "," + row.getCell(1));
			// 첫번째는 컬럼 정보
			if (row.getRowNum() == 0) {
				System.out.println("====Excel to DB Insert====");
			} else {
				// Map에 insert 파라미트 설정한다.
				uploadList.add(toMapPrBlockExcel(row));

			}
		}
		String project_no = (String) commandMap.get("project_no");
		String revision = (String) commandMap.get("revision");
		String p_project_no = (String) commandMap.get("p_project_no");
		compareBlockList(project_no, revision, uploadList);

		//복호화 파일 삭제
		DisEGDecrypt.deleteDecryptFile(file);		
		
		mav.addObject("project_no", p_project_no);
		mav.addObject("revision", revision);
		mav.addObject("uploadList", JSONArray.fromObject(uploadList).toString());

		mav.setViewName("paint/popUp/popUpPRBlockExcelList");
		return mav;
	}

	/**
	 * @메소드명 : toMap
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Row를 Map으로 변경
	 * </pre>
	 * 
	 * @param row
	 * @return
	 */
	private Map<String, Object> toMapPrBlockExcel(Row row) {
		// 편집해야됩니다.
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("block_code", row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
		map.put("in_ex_gbn", row.getCell(1) == null ? "" : DisExcelUtil.getCellValue(row.getCell(1)));
		map.put("is_excel", "Y");
		return map;
	}

	/**
	 * @메소드명 : compareBlockList
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR블럭 리스트와 업로드된 리스트를 합친다.
	 * </pre>
	 * 
	 * @param project_no
	 * @param revision
	 * @param uploadList
	 */
	private void compareBlockList(String project_no, String revision, List<Map<String, Object>> uploadList) {

		Map<String, String> params = new HashMap<String, String>();
		params.put("project_no", project_no);
		params.put("revision", revision);

		List<Map<String, Object>> list = paintPRDAO.infoPaintPRExcelBlockList(params);

		for (Map<String, Object> blockInfo : list) {

			String sBlock = (String) blockInfo.get("block_code");
			boolean isExist = false;

			for (Map<String, Object> uploadInfo : uploadList) {
				System.out.print(mapGetString(uploadInfo, "block_code"));
				if (sBlock.equals(mapGetString(uploadInfo, "block_code"))) {
					isExist = true;
					break;
				}
			}

			if (!isExist) {
				uploadList.add(blockInfo);
			}

		}

	}

	/**
	 * @메소드명 : saveExcelPaintPRBlock
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀리스트의 Block정보를 저장
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveExcelPaintPRBlock(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> blockList = DisJsonUtil.toList(commandMap.get("blockList"));
		// Block List 삭제
		int result = paintPRDAO.deletePaintPRBlockList(commandMap.getMap());
		// Block List 저장
		for (Map<String, Object> blockInfo : blockList) {
			// 저장
			blockInfo.put("project_no", commandMap.get("project_no"));
			blockInfo.put("revision", commandMap.get("revision"));

			result = paintPRDAO.insertPaintPRBlock(blockInfo);
			if (result == 0) {
				throw new DisException("PR블럭 리스트 입력 실패하였습니다.");
			}
		}

		/*
		 * // Group 저장selectExistPaintPRGroup int cnt =
		 * paintPRDAO.selectExistPaintPRGroup(commandMap.getMap());
		 * 
		 * if (cnt == 0) {
		 */

		commandMap.put("group_code", "1");
		commandMap.put("group_desc", "YARD MAIN BLOCK PR(자동생성)");
		result = paintPRDAO.insertPaintPRGroup(commandMap.getMap());
		/*
		 * if (result == 0) { throw new DisException(
		 * "YARD MAIN BLOCK PR(자동생성) 입력 실패하였습니다."); }
		 */
		commandMap.put("group_code", "2");
		commandMap.put("group_desc", "사외제작업체 MAIN BLOCK PR(자동생성)");
		result = paintPRDAO.insertPaintPRGroup(commandMap.getMap());
		/*
		 * if (result == 0) { throw new DisException(
		 * "사외제작업체 MAIN BLOCK PR(자동생성) 입력 실패하였습니다."); }
		 */
		commandMap.put("group_code", "3");
		commandMap.put("group_desc", "DECKHOUSE 선행 PR(자동생성)");
		result = paintPRDAO.insertPaintPRGroup(commandMap.getMap());
		/*
		 * if (result == 0) { throw new DisException(
		 * "DECKHOUSE 선행 PR(자동생성) 입력 실패하였습니다."); }
		 */
		commandMap.put("group_code", "4");
		commandMap.put("group_desc", "YARD 후행 PR(자동생성)");
		result = paintPRDAO.insertPaintPRGroup(commandMap.getMap());
		/*
		 * if (result == 0) { throw new DisException(
		 * "YARD 후행 PR(자동생성) 입력 실패하였습니다."); }
		 */
		/*
		 * } else { throw new DisException("PR Group 이 존재합니다."); }
		 */
		commandMap.put("group_code", "5");
		commandMap.put("group_desc", "SHOP PRIMER PR (자동생성) ");
		result = paintPRDAO.insertPaintPRGroup(commandMap.getMap());
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : prBlockExcelExport
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR 블럭 정보를 엑셀로 취득
	 * </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View prBlockExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("BLOCK");
		colName.add("구분");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> list = paintPRDAO.selectExcelDownLoad(commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add((String) rowData.get("code"));
			row.add((String) rowData.get("gbn"));

			colValue.add(row);
		}
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);

		modelMap.put("excelName", commandMap.get("project_no") + "_" + dateToday);

		modelMap.put("colName", colName);

		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}

	/**
	 * @메소드명 : getGridData
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * getGridData의 재정의
	 * [infoGroupItemList]PR그룹 아이템 리스트를 취득할시
	 * 입력된 Block정보로 데이터를 취득한다.
	 * </pre>
	 * 
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getGridData(Map<String, Object> map) {
		if ("infoGroupItemList".equals(map.get(DisConstants.MAPPER_NAME))) {
			String mapperSql = map.get(DisConstants.MAPPER_NAME) + DisConstants.MAPPER_SEPARATION
					+ DisConstants.MAPPER_GET_LIST;
			List<Map<String, Object>> codeList = null;
			try {
				codeList = DisJsonUtil.toList(map.get("codeList"));
			} catch (Exception e) {
				e.printStackTrace();
			}
			setCodeList(map, codeList);

			return paintPRDAO.selectList(mapperSql, map);
		} else {
			return super.getGridData(map);
		}
	}

	/**
	 * @메소드명 : setCodeList
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 블럭정보를 DB 조건 구조에 맞게 설정
	 * </pre>
	 * 
	 * @param params
	 * @param codeList
	 */
	private void setCodeList(Map<String, Object> params, List<Map<String, Object>> codeList) {

		StringBuffer block = new StringBuffer("'");
		StringBuffer pe = new StringBuffer("'");
		StringBuffer hull = new StringBuffer("'");
		StringBuffer quay = new StringBuffer("'");
		StringBuffer outfitting = new StringBuffer("'");
		StringBuffer cosmetic = new StringBuffer("'");

		for (Map<String, Object> codeInfo : codeList) {

			if ("BLOCK".equals(codeInfo.get("gbn"))) {

				if (!"'".equals(block.toString()))
					block.append("','");
				// else block.append("','");

				block.append(codeInfo.get("code"));

			} else if ("PE".equals(codeInfo.get("gbn"))) {
				if (!"'".equals(pe.toString()))
					pe.append("','");
				// else pe.append("','");

				pe.append(codeInfo.get("code"));

			} else if ("HULL".equals(codeInfo.get("gbn"))) {
				if (!"'".equals(hull.toString()))
					hull.append("','");
				// else hull.append("','");

				hull.append(codeInfo.get("code"));

			} else if ("QUAY".equals(codeInfo.get("gbn"))) {
				if (!"'".equals(quay.toString()))
					quay.append("','");
				// else quay.append("','");

				quay.append(codeInfo.get("code"));

			} else if ("OUTFITTING".equals(codeInfo.get("gbn"))) {
				if (!"'".equals(outfitting.toString()))
					outfitting.append("','");
				// else outfitting.append("','");

				outfitting.append(codeInfo.get("team_count"));

			} else if ("COSMETIC".equals(codeInfo.get("gbn"))) {
				if (!"'".equals(cosmetic.toString()))
					cosmetic.append("','");
				// else cosmetic.append("','");

				cosmetic.append(codeInfo.get("team_count"));
			}

		}

		params.put("block_list", block.append("'").toString());
		params.put("pe_list", pe.append("'").toString());
		params.put("hull_list", hull.append("'").toString());
		params.put("quay_list", quay.append("'").toString());
		params.put("outfitting_list", outfitting.append("'").toString());
		params.put("cosmetic_list", cosmetic.append("'").toString());
	}

	/**
	 * @메소드명 : saveBlockList
	 * @날짜 : 2016. 7. 14.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block Stage Code 리스트를 저장한다.
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveBlockList(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> prBlockList = DisJsonUtil.toList(commandMap.get("prBlockList"));

		// Block List 삭제
		commandMap.put("project_no", commandMap.get("p_project_no"));
		int result = paintPRDAO.deletePaintPRBlockList(commandMap.getMap());
		for (Map<String, Object> blockInfo : prBlockList) {
			// 저장
			if ("BLOCK".equals(blockInfo.get("gbn"))) {
				blockInfo.put("project_no", commandMap.get("p_project_no"));
				blockInfo.put("revision", commandMap.get("p_revision"));
				blockInfo.put("in_ex_gbn", commandMap.get("in_ex_gbn"));
				blockInfo.put("block_code", blockInfo.get("code"));
				result = paintPRDAO.insertPaintPRBlock(blockInfo);
				if (result == 0) {
					throw new DisException("PR블럭 리스트 입력 실패하였습니다.");
				}
			}

		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : prItemExcelImport
	 * @날짜 : 2016. 7. 13.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * EXCEL 내용 로드하여 화면으로 반환
	 * </pre>
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> prItemExcelImport(CommonsMultipartFile file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {

		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(file.getInputStream());
		org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);

		Iterator<Row> rowIterator = sheet.iterator();

		String paintItem = "";
		double quantity = 0;
		String paintDesc = "";
		String canSize = "";
		// 아이템을 추가하고 CAN BASE를 계산하는 스크립트
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\" >");
		sb.append("		function insertItem(item, itemDesc, canSize, quantity) {");
		sb.append("			var rowId = opener.addPRGroupItem('',item,itemDesc,canSize,quantity);");
		sb.append("			opener.quantityCanBase(rowId);");
		sb.append("		}");
		while (rowIterator.hasNext()) {
			Row row = rowIterator.next();
			System.out.println(row.getRowNum() + ">>" + row.getCell(0) + "," + row.getCell(1));
			// 첫번째는 컬럼 정보
			if (row.getRowNum() == 0) {
				System.out.println("====Excel to DB Insert====");
			} else {
				// 엑셀에서 아이템 코드를 취득
				paintItem = (String) (row.getCell(0) == null ? "" : DisExcelUtil.getCellValue(row.getCell(0)));
				// 퀀티티는 소수 4자리에서 반올림
				quantity = (double) DisExcelUtil.getCellValue(row.getCell(1));
				quantity = Math.round(quantity * 1000d) / 1000d;
				// 아이템 코드로 아이템명, Can사이즈를 취득
				Map<String, String> param = new HashMap<String, String>();
				param.put("paint_item", paintItem);
				Map<String, String> paintInfo = paintPRDAO.selectPaintItemInfo(param);
				// 아이템 정보가 없다면 아이템을 추가 하지 않는다.
				if (paintInfo != null) {
					paintDesc = paintInfo.get("paint_desc");
					canSize = paintInfo.get("can_size");
					// 아이템 추가 스크립트 추가
					sb.append("insertItem('" + paintItem + "','" + paintDesc + "','" + canSize + "','" + quantity
							+ "');");
				}
			}
		}
		// 아이템 추가가 완료 되면 팝업창을 닫는다.
		sb.append("window.close();");
		sb.append("</script>");
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().println(sb);
		return null;
	}
}

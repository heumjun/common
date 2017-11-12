package stxship.dis.supplyPlan.supplyManage.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView2;
import stxship.dis.supplyPlan.supplyManage.dao.SupplyManageDAO;

/**
 * @파일명 : SupplyManageServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 11.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  A/F Volume 서비스
 *     </pre>
 */
@Service("supplyManageService")
public class SupplyManageServiceImpl extends CommonServiceImpl implements SupplyManageService {

	@Resource(name = "supplyManageDAO")
	private SupplyManageDAO supplyManageDAO;

	/** 
	 * @메소드명	: supplyManageLoginGubun
	 * @날짜		: 2016. 10. 14.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 항목관리 관리자 구분
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> supplyManageLoginGubun(CommandMap commandMap) throws Exception {
		Map<String, Object> loginGubun = new HashMap<String, Object>();
		loginGubun = supplyManageDAO.supplyManageLoginGubun(commandMap.getMap());
		return loginGubun;
	}
	
	/** 
	 * @메소드명	: saveSupplyManageList
	 * @날짜		: 2016. 08. 03.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 수정사항 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, Object> saveSupplyManageList(CommandMap commandMap) throws Exception {

		List<Map<String, Object>> manageGridData = DisJsonUtil.toList(commandMap.get("manageList"));
		List<Map<String, Object>> dwgGridData = DisJsonUtil.toList(commandMap.get("dwgList"));
		List<Map<String, Object>> blockGridData = DisJsonUtil.toList(commandMap.get("blockList"));
		List<Map<String, Object>> stageGridData = DisJsonUtil.toList(commandMap.get("stageList"));
		List<Map<String, Object>> strGridData = DisJsonUtil.toList(commandMap.get("strList"));
		List<Map<String, Object>> catalogGridData = DisJsonUtil.toList(commandMap.get("catalogList"));
		
		//메인그리드 수정사항이 있는 경우
		if(!manageGridData.isEmpty()){
			for(int i=0; i<manageGridData.size(); i++){
				manageGridData.get(i).put("loginId", commandMap.get("loginId"));
				//"I" 인 경우
				if("I".equals(manageGridData.get(i).get("oper"))) {
					supplyManageDAO.insertManage(manageGridData.get(i));
				}
				//"U" 인 경우
				else if("U".equals(manageGridData.get(i).get("oper"))) {
					supplyManageDAO.updateManage(manageGridData.get(i));
				}
				//"D" 인 경우
				else if("D".equals(manageGridData.get(i).get("oper"))) {
					supplyManageDAO.deleteManage(manageGridData.get(i));
					supplyManageDAO.deleteManageDwg(manageGridData.get(i));
					supplyManageDAO.deleteManageCatalog(manageGridData.get(i));
				}
			}
		}
		
		//DWG그리드 수정사항이 있는 경우
		if(!dwgGridData.isEmpty()){
			for(int i=0; i<dwgGridData.size(); i++){
				dwgGridData.get(i).put("h_supplyId", commandMap.get("h_supplyId"));
				dwgGridData.get(i).put("loginId", commandMap.get("loginId"));
				//"I" 인 경우
				if("I".equals(dwgGridData.get(i).get("oper"))) {
					dwgGridData.get(i).put("p_supply_type", "DWG_CATEGORY");
					supplyManageDAO.insertDwg(dwgGridData.get(i));
				}
				//"U" 인 경우
				else if("U".equals(dwgGridData.get(i).get("oper"))) {
					supplyManageDAO.updateDwg(dwgGridData.get(i));
				}
				//"D" 인 경우
				else if("D".equals(dwgGridData.get(i).get("oper"))) {
					supplyManageDAO.deleteDwg(dwgGridData.get(i));
				}
			}
		}
		
		//block그리드 수정사항이 있는 경우
		if(!blockGridData.isEmpty()){
			for(int i=0; i<blockGridData.size(); i++){
				blockGridData.get(i).put("h_supplyId", commandMap.get("h_supplyId"));
				blockGridData.get(i).put("loginId", commandMap.get("loginId"));
				//"I" 인 경우
				if("I".equals(blockGridData.get(i).get("oper"))) {
					blockGridData.get(i).put("p_supply_type", "BLOCK");
					supplyManageDAO.insertDwg(blockGridData.get(i));
				}
				//"U" 인 경우
				else if("U".equals(blockGridData.get(i).get("oper"))) {
					supplyManageDAO.updateDwg(blockGridData.get(i));
				}
				//"D" 인 경우
				else if("D".equals(blockGridData.get(i).get("oper"))) {
					supplyManageDAO.deleteDwg(blockGridData.get(i));
				}
			}
		}
		
		//stage그리드 수정사항이 있는 경우
		if(!stageGridData.isEmpty()){
			for(int i=0; i<stageGridData.size(); i++){
				stageGridData.get(i).put("h_supplyId", commandMap.get("h_supplyId"));
				stageGridData.get(i).put("loginId", commandMap.get("loginId"));
				//"I" 인 경우
				if("I".equals(stageGridData.get(i).get("oper"))) {
					stageGridData.get(i).put("p_supply_type", "STAGE");
					supplyManageDAO.insertDwg(stageGridData.get(i));
				}
				//"U" 인 경우
				else if("U".equals(stageGridData.get(i).get("oper"))) {
					supplyManageDAO.updateDwg(stageGridData.get(i));
				}
				//"D" 인 경우
				else if("D".equals(stageGridData.get(i).get("oper"))) {
					supplyManageDAO.deleteDwg(stageGridData.get(i));
				}
			}
		}
		
		//str그리드 수정사항이 있는 경우
		if(!strGridData.isEmpty()){
			for(int i=0; i<strGridData.size(); i++){
				strGridData.get(i).put("h_supplyId", commandMap.get("h_supplyId"));
				strGridData.get(i).put("loginId", commandMap.get("loginId"));
				//"I" 인 경우
				if("I".equals(strGridData.get(i).get("oper"))) {
					strGridData.get(i).put("p_supply_type", "STR");
					supplyManageDAO.insertDwg(strGridData.get(i));
				}
				//"U" 인 경우
				else if("U".equals(strGridData.get(i).get("oper"))) {
					supplyManageDAO.updateDwg(strGridData.get(i));
				}
				//"D" 인 경우
				else if("D".equals(strGridData.get(i).get("oper"))) {
					supplyManageDAO.deleteDwg(strGridData.get(i));
				}
			}
		}
		
		//CATALOG그리드 수정사항이 있는 경우
		if(!catalogGridData.isEmpty()){
			for(int i=0; i<catalogGridData.size(); i++){
				catalogGridData.get(i).put("h_supplyId", commandMap.get("h_supplyId"));
				catalogGridData.get(i).put("loginId", commandMap.get("loginId"));
				//"I" 인 경우
				if("I".equals(catalogGridData.get(i).get("oper"))) {
					supplyManageDAO.insertCatalog(catalogGridData.get(i));
				}
				//"U" 인 경우
				else if("U".equals(catalogGridData.get(i).get("oper"))) {
					supplyManageDAO.updateCatalog(catalogGridData.get(i));
				}
				//"D" 인 경우
				else if("D".equals(catalogGridData.get(i).get("oper"))) {
					supplyManageDAO.deleteCatalog(catalogGridData.get(i));
				}
			}
		}
		
		// 여기까지 Exception 없으면 성공 메시지
		Map<String, Object> resultMsg = DisMessageUtil.getResultObjMessage(DisConstants.RESULT_SUCCESS);
		return resultMsg;
	}
	
	/**
	 * @메소드명 : supplyManageExcelExport
	 * @날짜 : 2016. 09. 29.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * supplyManage 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View supplyManageExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		String supply = "Supply";
		
		List<Map<String, Object>>list = supplyManageDAO.selectSupplyIdList(commandMap.getMap());	
		commandMap.put("supplyIdList", list);
		
		List<String> excelName = new ArrayList<String>();
		excelName.add(supply+"_Manage");
		/*excelName.add(supply+"_Dwg");
		excelName.add(supply+"_Block");
		excelName.add(supply+"_Stage");
		excelName.add(supply+"_Str");
		excelName.add(supply+"_Catalog");*/
		
		modelMap.put("excelName",  excelName);
		
		List<String> colName = new ArrayList<String>();
		colName.add("항목");
		colName.add("구분");
		colName.add("GROUP");
		colName.add("직종");
		colName.add("DESCRIPTION");
		colName.add("UOM1");
		colName.add("UOM2");
		colName.add("RANK");
		colName.add("견적항목");
		colName.add("DEPT");
		colName.add("RESULT");
		colName.add("견적");
		colName.add("REMARK");
		
		colName.add(" ");
		
		colName.add("항목");
		colName.add("DWG CATEGORY");
		
		colName.add(" ");
		
		colName.add("항목");
		colName.add("BLOCK");
		
		colName.add(" ");
		
		colName.add("항목");
		colName.add("STAGE");
		
		colName.add(" ");
		
		colName.add("항목");
		colName.add("STR");
		
		colName.add(" ");
		
		colName.add("항목");
		colName.add("CATALOG");
		colName.add("ATTR");
		colName.add("VALUE");
		
		modelMap.put(supply+"_Manage_colName", colName);		
				
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();
		List<List<Object>> resultColValue = new ArrayList<List<Object>>();
		
		List<Map<String, Object>> manageList = supplyManageDAO.selectSupplyManage(commandMap.getMap());	
		
		List<Object> resultRow = new ArrayList<Object>();
		Map<String, Object> resultRowData = new HashMap<String, Object>();
		
		for(Map<String, Object> rowData : manageList) {
			
			resultRowData.putAll(rowData);
			
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
			
			row.add( rowData.get("supply_id"));
			row.add( rowData.get("gbn"));
			row.add( rowData.get("group1"));
			row.add( rowData.get("group2"));
			row.add( rowData.get("description"));
			row.add( rowData.get("uom1"));
			row.add( rowData.get("uom2"));
			row.add( rowData.get("rank"));
			row.add( rowData.get("join_data"));
			row.add( rowData.get("dept_code_desc"));
			row.add( rowData.get("result_yn"));
			row.add( rowData.get("unit_yn"));
			row.add( rowData.get("remark"));
			
			colValue.add(row);
		}
		
		modelMap.put(supply+"_Manage_colValue",  colValue);

		// 2페이지
		/*List<String> colName2 = new ArrayList<String>();
		colName2.add("항목");
		colName2.add("DWG CATEGORY");
		
		modelMap.put(supply+"_Dwg_colName",    colName2);		*/

		// COLVALUE 설정
		List<List<Object>> colValue2 = new ArrayList<List<Object>>();		
		
		commandMap.put("supply_type", "DWG_CATEGORY");
		List<Map<String, Object>> dwgList = supplyManageDAO.selectSupplyType(commandMap.getMap());
		
		for(Map<String, Object> rowData : dwgList) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
					
			row.add( rowData.get("supply_id"));
			row.add( rowData.get("value"));
			
			colValue2.add(row);
		}
		
		modelMap.put(supply+"_Dwg_colValue",   colValue2);
		
		// 3페이지
		/*List<String> colName3 = new ArrayList<String>();
		colName3.add("항목");
		colName3.add("BLOCK");
		
		modelMap.put(supply+"_Block_colName",    colName3);		*/

		// COLVALUE 설정
		List<List<Object>> colValue3 = new ArrayList<List<Object>>();		
		
		commandMap.remove("supply_type");
		commandMap.put("supply_type", "BLOCK");
		List<Map<String, Object>> blockList = supplyManageDAO.selectSupplyType(commandMap.getMap());
		
		for(Map<String, Object> rowData : blockList) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
					
			row.add( rowData.get("supply_id"));
			row.add( rowData.get("value"));
			
			colValue3.add(row);
		}
		
		modelMap.put(supply+"_Block_colValue",   colValue3);		
		
		
		// 4페이지
		/*List<String> colName4 = new ArrayList<String>();
		colName4.add("항목");
		colName4.add("STAGE");
		
		modelMap.put(supply+"_Stage_colName",    colName4);		*/

		// COLVALUE 설정
		List<List<Object>> colValue4 = new ArrayList<List<Object>>();		
		
		commandMap.remove("supply_type");
		commandMap.put("supply_type", "STAGE");
		List<Map<String, Object>> stageList = supplyManageDAO.selectSupplyType(commandMap.getMap());
		
		for(Map<String, Object> rowData : stageList) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
					
			row.add( rowData.get("supply_id"));
			row.add( rowData.get("value"));
			
			colValue4.add(row);
		}
		
		modelMap.put(supply+"_Stage_colValue",   colValue4);
		
		// 5페이지
		/*List<String> colName5 = new ArrayList<String>();
		colName5.add("항목");
		colName5.add("STR");
		
		modelMap.put(supply+"_Str_colName",    colName5);		*/

		// COLVALUE 설정
		List<List<Object>> colValue5 = new ArrayList<List<Object>>();		
		
		commandMap.remove("supply_type");
		commandMap.put("supply_type", "STR");
		List<Map<String, Object>> strList = supplyManageDAO.selectSupplyType(commandMap.getMap());
		
		for(Map<String, Object> rowData : strList) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
					
			row.add( rowData.get("supply_id"));
			row.add( rowData.get("value"));
			
			colValue5.add(row);
		}
		
		modelMap.put(supply+"_Str_colValue",   colValue5);
		
		// 6페이지
		/*List<String> colName6 = new ArrayList<String>();
		colName6.add("항목");
		colName6.add("CATALOG");
		colName6.add("ATTR");
		colName6.add("VALUE");
		
		modelMap.put(supply+"_Catalog_colName",    colName6);	*/	

		// COLVALUE 설정
		List<List<Object>> colValue6 = new ArrayList<List<Object>>();		
		

		List<Map<String, Object>> catalogList = supplyManageDAO.selectSupplyCatalog(commandMap.getMap());
		
		for(Map<String, Object> rowData : catalogList) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();
					
			row.add( rowData.get("supply_id"));
			row.add( rowData.get("catalog"));
			row.add( rowData.get("attr"));
			row.add( rowData.get("value"));
			
			colValue6.add(row);
		}
		
		modelMap.put(supply+"_Catalog_colValue",   colValue6);

		return new GenericExcelView2();
	}	
	
}

package stxship.dis.etc.standardInfoTrans.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.common.util.GenericExcelView3;
import stxship.dis.etc.standardInfoTrans.dao.StandardInfoTransDAO;

/**
 * @파일명 : StandardInfoTransExcelServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * StandardInfoTrans에서 사용되는 서비스
 *     </pre>
 */
@Service("standardInfoTransExcelService")
public class StandardInfoTransExcelServiceImpl extends CommonServiceImpl implements StandardInfoTransExcelService {

	@Resource(name = "standardInfoTransDAO")
	private StandardInfoTransDAO standardInfoTransDAO;

	/**
	 * @메소드명 : standardInfoTransMainExcelPrint
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 리스트 엑셀 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View standardInfoTransMainExcelPrint(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		colName.add("작성번호");
		colName.add("유형");
		colName.add("TITLE");
		colName.add("부서");
		colName.add("요청자");
		colName.add("상태");
		colName.add("요청일");
		colName.add("조치일");

		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = standardInfoTransDAO
				.selectList("standardInfoTransDbList." + commandMap.get("p_process"), commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();

			row.add(rowData.get("list_id"));
			row.add(rowData.get("list_type_desc"));
			row.add(rowData.get("request_title"));
			row.add(rowData.get("dept_name"));
			row.add(rowData.get("user_name"));
			row.add(rowData.get("list_status_desc"));

			row.add(rowData.get("request_date"));
			row.add(rowData.get("jochi_date"));

			colValue.add(row);
		}

		modelMap.put("excelName", "standardInfoExcelData");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();
	}

	/**
	 * @메소드명 : standardInfoTransDetailExcelPrint
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 상세정보 엑셀 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View standardInfoTransDetailExcelPrint(CommandMap commandMap, Map<String, Object> modelMap)
			throws Exception {

		
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		
		if(commandMap.get("p_filename").equals("CATALOG_LIST")) {
			colName.add("Category");
			colName.add("Catalog");
			colName.add("Description");
			colName.add("UOM");
			colName.add("ATTR.1");
			colName.add("ATTR.2");
			colName.add("ATTR.3");
			colName.add("ATTR.4");
			colName.add("ATTR.5");
			colName.add("ATTR.6");
			colName.add("ATTR.7");
			colName.add("ATTR.8");
			colName.add("ATTR.9");
			colName.add("ATTR.10");
			colName.add("ATTR.11");
			colName.add("ATTR.12");
			colName.add("ATTR.13");
			colName.add("ATTR.14");
			colName.add("ATTR.15");
			colName.add("구매요청 기준");
			colName.add("구매요청 대표 품목 코드");
			colName.add("Vendor Drawing NO.");
			colName.add("BOM 구성예정");
			colName.add("대분류");
			colName.add("대중분류");
			colName.add("SALES BOM 재료비 예산 중분류");
			colName.add("특수선 여부");
			colName.add("TECH.SPEC.품목 유무");
			colName.add("선종 구분");
			colName.add("구매자");
			colName.add("공정 관리자");
			colName.add("표준 리드타임");
			colName.add("MRP 계획 대상여부");
			colName.add("페깅 여부");
			colName.add("물류 담당자");
			colName.add("F.ORDER(취소)");
			colName.add("F.ORDER(납기)");
		} else {
			colName.add("Name");
			colName.add("Description");
			colName.add("Weight");
			colName.add("ATTR.0");
			colName.add("ATTR.1");
			colName.add("ATTR.2");
			colName.add("ATTR.3");
			colName.add("ATTR.4");
			colName.add("ATTR.5");
			colName.add("ATTR.6");
			colName.add("ATTR.7");
			colName.add("ATTR.8");
			colName.add("ATTR.9");
			colName.add("ATTR.10");
			colName.add("ATTR.11");
			colName.add("ATTR.12");
			colName.add("ATTR.13");
			colName.add("ATTR.14");
			colName.add("Cable Outdia");
			colName.add("Can Size");
			colName.add("STXSVR");
			colName.add("Thinner Code");
			colName.add("Paint Code");
			colName.add("Cable Type");
			colName.add("Cable Length");
			colName.add("STXStandard");
		}
		
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = standardInfoTransDAO.selectList("standardInfoTransDbList." + commandMap.get("p_process"), commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();

			if(commandMap.get("p_filename").equals("CATALOG_LIST")) {
				row.add(rowData.get("category"));
				row.add(rowData.get("catalog"));
				row.add(rowData.get("description"));
				row.add(rowData.get("uom"));
				row.add(rowData.get("attibute_01"));
				row.add(rowData.get("attibute_02"));
				row.add(rowData.get("attibute_03"));
				row.add(rowData.get("attibute_04"));
				row.add(rowData.get("attibute_05"));
				row.add(rowData.get("attibute_06"));
				row.add(rowData.get("attibute_07"));
				row.add(rowData.get("attibute_08"));
				row.add(rowData.get("attibute_09"));
				row.add(rowData.get("attibute_10"));
				row.add(rowData.get("attibute_11"));
				row.add(rowData.get("attibute_12"));
				row.add(rowData.get("attibute_13"));
				row.add(rowData.get("attibute_14"));
				row.add(rowData.get("attibute_15"));
				row.add(rowData.get("po_request_type"));
				row.add(rowData.get("po_delegate_item"));
				row.add(rowData.get("vendor_drawing_no"));
				row.add(rowData.get("bom_create_date"));
				row.add(rowData.get("level_01"));
				row.add(rowData.get("level_02"));
				row.add(rowData.get("level_03"));
				row.add(rowData.get("n_ship_flag"));
				row.add(rowData.get("tech_spec_flag"));
				row.add(rowData.get("ship_type"));
				row.add(rowData.get("buyer_user_name"));
				row.add(rowData.get("process_user_name"));
				row.add(rowData.get("standar_lead_time"));
				row.add(rowData.get("mrp_planning_flag"));
				row.add(rowData.get("pegging_flag"));
				row.add(rowData.get("distributor_emp_no"));
				row.add(rowData.get("f_order_cancel"));
				row.add(rowData.get("f_order_open"));
			} else {
				row.add(rowData.get("part_no"));
				row.add(rowData.get("description"));
				row.add(rowData.get("weight"));
				row.add(rowData.get("attr00"));
				row.add(rowData.get("attr01"));
				row.add(rowData.get("attr02"));
				row.add(rowData.get("attr03"));
				row.add(rowData.get("attr04"));
				row.add(rowData.get("attr05"));
				row.add(rowData.get("attr06"));
				row.add(rowData.get("attr07"));
				row.add(rowData.get("attr08"));
				row.add(rowData.get("attr09"));
				row.add(rowData.get("attr10"));
				row.add(rowData.get("attr11"));
				row.add(rowData.get("attr12"));
				row.add(rowData.get("attr13"));
				row.add(rowData.get("attr14"));
				row.add(rowData.get("cable_outdia"));
				row.add(rowData.get("cable_size"));
				row.add(rowData.get("stxsvr"));
				row.add(rowData.get("thinner_code"));
				row.add(rowData.get("paint_code"));
				row.add(rowData.get("cable_type"));
				row.add(rowData.get("cable_length"));
				row.add(rowData.get("stxstandard"));
			}

			colValue.add(row);
		}

		modelMap.put("excelName", "standardInfoDetail");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();
	}
	
	/**
	 * @메소드명 : standardInfoTransDetailExcelPrintItem
	 * @날짜 : 2017. 4. 17.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 상세정보 엑셀 다운로드(ITEM 속성업데이트)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View standardInfoTransDetailExcelPrintItem(CommandMap commandMap, Map<String, Object> modelMap)
			throws Exception {

		// COLNAME 설정 (JSP단에서 컬럼헤더부분 세팅해서 넘겨줌)
		List<Map<String, Object>> colName = DisJsonUtil.toList(commandMap.get("excelHeaderName").toString());		
		
		// COLVALUE 설정
		List<List<Object>> colValue = new ArrayList<List<Object>>();

		List<Map<String, Object>> list = standardInfoTransDAO.selectList("standardInfoTransDbList." + commandMap.get("p_process"), commandMap.getMap());

		for (Map<String, Object> rowData : list) {
			// Map을 리스트로 변경
			List<Object> row = new ArrayList<Object>();

			if(commandMap.get("p_filename").equals("ITEM_LIST")) {
				row.add(rowData.get("part_no"));
				row.add(rowData.get("description"));
				row.add(rowData.get("weight"));
				row.add(rowData.get("attr00"));
				row.add(rowData.get("attr01"));
				row.add(rowData.get("attr02"));
				row.add(rowData.get("attr03"));
				row.add(rowData.get("attr04"));
				row.add(rowData.get("attr05"));
				row.add(rowData.get("attr06"));
				row.add(rowData.get("attr07"));
				row.add(rowData.get("attr08"));
				row.add(rowData.get("attr09"));
				row.add(rowData.get("attr10"));
				row.add(rowData.get("attr11"));
				row.add(rowData.get("attr12"));
				row.add(rowData.get("attr13"));
				row.add(rowData.get("attr14"));
				row.add(rowData.get("cable_outdia"));
				row.add(rowData.get("cable_size"));
				row.add(rowData.get("stxsvr"));
				row.add(rowData.get("thinner_code"));
				row.add(rowData.get("paint_code"));
				row.add(rowData.get("cable_type"));
				row.add(rowData.get("cable_length"));
				row.add(rowData.get("stxstandard"));
			}

			colValue.add(row);
		}

		modelMap.put("excelName", "standardInfoDetail");
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView3();
	}	

}

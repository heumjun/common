/**
 * 
 */
package stxship.dis.dps.dpPersonData.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.GenericExcelView3;
import stxship.dis.dps.common.service.DpsCommonService;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpPersonData.dao.DpPersonDataDAO;

/** 
 * @파일명	: DpPersonDataServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 16. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Service("dpPersonDataService")
public class DpPersonDataServiceImpl extends DpsCommonServiceImpl implements DpPersonDataService {
	@Resource(name="dpPersonDataDAO")
	private DpPersonDataDAO dpPersonDataDAO;
	
	/**
	 * 
	 * @메소드명	: getAverageOvertimeOfAll
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 기간의 전체(기술부문) 잔업 평균
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getAverageOvertimeOfAll(CommandMap commandMap) throws Exception {
		return dpPersonDataDAO.getAverageOvertimeOfAll(commandMap.getMap());
	}
	/**
	 * 
	 * @메소드명	: getAverageOvertimeOfSelectedDepts
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 기간의 선택된 부서(들)의 잔업 평균
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getAverageOvertimeOfSelectedDepts(CommandMap commandMap) throws Exception {
		return dpPersonDataDAO.getAverageOvertimeOfSelectedDepts(commandMap.getMap());
	}
	@Override
	public View dpsExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		try {
			List<Map<String, Object>> colName = DisJsonUtil.toList(commandMap.get("excelHeaderName").toString());
			List<String> colKey = Arrays.asList(commandMap.get("excelHeaderKey").toString().split(","));
			
			if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
				commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
			if(commandMap.get("projectList") != null && !"".equals(String.valueOf(commandMap.get("projectList"))))
				commandMap.put("project_no_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(","))));
			
			List<Map<String,Object>> list = dpPersonDataDAO.dpPersonDataExcelExport(commandMap);
			ArrayList<Map<String, Object>> newRows = new ArrayList<Map<String, Object>>(); 
			DecimalFormat df = new DecimalFormat("###,###.##");//시수 포맷
			DecimalFormat df1 = new DecimalFormat("#.#");//비율 포맷
			
			for(Map<String, Object> map : list){
	            
	            if (map.containsKey("erp_create_date") && !"".equals(String.valueOf(map.get("erp_create_date")))) {
	            	map.put("erpifyn", "Y");
	            } else {
	            	map.put("erpifyn", "N");
	            }
	            
	            float erp_wtime_f = !map.containsKey("erp_wtime_f") ? 0 : Float.parseFloat(String.valueOf(map.get("erp_wtime_f")));
	            float wtime = !map.containsKey("wtime") ? 0 : Float.parseFloat(String.valueOf(map.get("wtime")));
	            float wtime_f = !map.containsKey("wtime_f") ? 0 : Float.parseFloat(String.valueOf(map.get("wtime_f")));
	            map.put("emp_name", ((String)map.get("position") == null ? "":(String)map.get("position"))+((String)map.get("emp_name") == null ? "":(String)map.get("emp_name")));
	            map.put("erp_wtime_f", (erp_wtime_f == 0) ? "&nbsp;" : df.format(erp_wtime_f));
	            map.put("wtime_f", (wtime_f == 0) ? "&nbsp;" : df.format(Math.round(wtime_f*100)/100.0));
	            map.put("wtime", (wtime == 0) ? "&nbsp;" : df.format(wtime));
	            
	            newRows.add(map);
			}
			list.clear();
			list.addAll(newRows);
			
			List<List<String>> colValue = new ArrayList<List<String>>();

			for (Map<String, Object> rowData : list) {
				// Map을 리스트로 변경
				List<String> row = new ArrayList<String>();
				
				for(String key : colKey){
					if(rowData.containsKey(key)){
						row.add(String.valueOf(rowData.get(key)));
					} else {
						row.add("");
					}
				}
				
				colValue.add(row);
			}
			
			modelMap.put("excelName", "DpPerson");
			modelMap.put("colName", colName);
			modelMap.put("colValue", colValue);
			
			return new GenericExcelView3();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new DisException();
		}
	}
}

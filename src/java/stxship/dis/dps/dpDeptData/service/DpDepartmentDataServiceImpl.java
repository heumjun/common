/**
 * 
 */
package stxship.dis.dps.dpDeptData.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.GenericExcelView3;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpDeptData.dao.DpDepartmentDataDAO;

/** 
 * @파일명	: DpDepartmentDataServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 19. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Service("dpDepartmentDataService")
public class DpDepartmentDataServiceImpl extends DpsCommonServiceImpl implements DpDepartmentDataService {
	@Resource(name="dpDepartmentDataDAO")
	private DpDepartmentDataDAO dpDepartmentDataDAO;

	@SuppressWarnings("unchecked")
	@Override
	public View dpsExcelExport(CommandMap commandMap,Map<String, Object> modelMap) throws Exception {
		try {
			List<Map<String, Object>> colName = DisJsonUtil.toList(commandMap.get("excelHeaderName").toString());
			List<String> colKey = Arrays.asList(commandMap.get("excelHeaderKey").toString().split(","));
			
			if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
				commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
			if(commandMap.get("projectList") != null && !"".equals(String.valueOf(commandMap.get("projectList"))))
				commandMap.put("project_no_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(","))));
			
			List<Map<String,Object>> list = dpDepartmentDataDAO.dpDepartmentDataExcelExport(commandMap);
			
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
			
			modelMap.put("excelName", "DpDepartment");
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

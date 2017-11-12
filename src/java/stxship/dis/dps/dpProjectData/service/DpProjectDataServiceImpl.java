/**
 * 
 */
package stxship.dis.dps.dpProjectData.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.GenericExcelView3;
import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dpProjectData.dao.DpProjectDataDAO;

/** 
 * @파일명	: DpProjectDataServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 17. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Service("dpProjectDataService")
public class DpProjectDataServiceImpl extends DpsCommonServiceImpl implements DpProjectDataService {
	
	@Resource(name="dpProjectDataDAO")
	private DpProjectDataDAO dpProjectDataDAO;
	/**
	 * 
	 * @메소드명	: popUpProjectDataMainGridSave
	 * @날짜		: 2016. 8. 18.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *ERP INTERFACE POP UP GRID SAVE
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> popUpProjectDataERPIFFSMainGridSave(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString());
		DecimalFormat df = new DecimalFormat("#.#");
		try{
			for (Map<String, Object> rowData : saveList) {
				// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
				rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));
				rowData.put("targetSelect", commandMap.get("targetSelect"));
				rowData.put("dateFrom", commandMap.get("dateFrom"));
				if(dpProjectDataDAO.getTargetData(rowData) == 0){
					float mhValue = Float.parseFloat(String.valueOf(rowData.get("wtime_f")).replaceAll(",", ""));
					String mhValueStr = df.format((Math.round(mhValue * 10) / 10.0));
					rowData.put("mh_value", mhValueStr);
					rowData.put("type", 1);
					String result = gridDataInsertDps(rowData);
					if(result == DisConstants.RESULT_FAIL){
						throw new DisException();
					}
				}
				if(dpProjectDataDAO.getTargetData2(rowData) == 0){
					float mhValue = Float.parseFloat(String.valueOf(rowData.get("wtime_f")).replaceAll(",", ""));
					String mhValueStr = df.format((Math.round(mhValue * 10) / 10.0));
					rowData.put("mh_value", mhValueStr);
					rowData.put("type", 2);
					String result = gridDataInsertDps(rowData);
					if(result == DisConstants.RESULT_FAIL){
						throw new DisException();
					}
				}
			}
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		} catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
		
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
			
			List<Map<String,Object>> list = dpProjectDataDAO.dpProjectDataExcelExport(commandMap);
			ArrayList<Map<String, Object>> newRows = new ArrayList<Map<String, Object>>(); 
			DecimalFormat df = new DecimalFormat("###,###.##");
			for(Map<String, Object> map : list){
	            
	            if (map.containsKey("erp_create_date") && !"".equals(String.valueOf(map.get("erp_create_date")))) {
	            	map.put("erpifyn", "Y");
	            } else {
	            	map.put("erpifyn", "N");
	            }
	            
	            float erp_wtime_f = !map.containsKey("erp_wtime_f") ? 0 : Float.parseFloat(String.valueOf(map.get("erp_wtime_f")));
	            float wtime = !map.containsKey("wtime") ? 0 : Float.parseFloat(String.valueOf(map.get("wtime")));
	            float wtime_f = !map.containsKey("wtime_f") ? 0 : Float.parseFloat(String.valueOf(map.get("wtime_f")));
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
			
			modelMap.put("excelName", "DpProject");
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

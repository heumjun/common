/**
 * 
 */
package stxship.dis.dps.dpPersonData.dao;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.dao.DpsCommonDAO;

/** 
 * @파일명	: DpPersonDataDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 16. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Repository("dpPersonDataDAO")
public class DpPersonDataDAO extends DpsCommonDAO {
	
	/**
	 * 
	 * @메소드명	: getAverageOvertimeOfAll
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 기간의 전체(기술부문) 잔업 평균
	 * </pre>
	 * @param map
	 * @return
	 */
	public String getAverageOvertimeOfAll(Map<String, Object> map) {
		return selectOneDps("dpPersonData.selectAverageOvertimeOfAll", map);
	}
	/**
	 * 
	 * @메소드명	: getAverageOvertimeOfSelectedDepts
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 기간의 선택된 부서(들)의 잔업 평균
	 * </pre>
	 * @param map
	 * @return
	 */
	public String getAverageOvertimeOfSelectedDepts(Map<String, Object> map) {
		if(map.get("departmentList") != null && !"".equals(String.valueOf(map.get("departmentList"))))
			map.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(map.get("departmentList")).split(","))));
		return selectOneDps("dpPersonData.selectAverageOvertimeOfSelectedDepts", map);
	}
	
	public List<Map<String, Object>> dpPersonDataExcelExport(CommandMap commandMap)  throws Exception{
		return selectListDps("dpPersonDataExcelExport.list", commandMap.getMap());
	}

}

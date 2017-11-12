/**
 * 
 */
package stxship.dis.dps.dpDeptData.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.dao.DpsCommonDAO;

/** 
 * @파일명	: DpDepartmentDataDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 19. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Repository("dpDepartmentDataDAO")
public class DpDepartmentDataDAO extends DpsCommonDAO {
	
	public List<Map<String, Object>> dpDepartmentDataExcelExport(CommandMap commandMap)  throws Exception{
		return selectListDps("dpDepartmentDataExcelExport.list", commandMap.getMap());
	}
}

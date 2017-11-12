/**
 * 
 */
package stxship.dis.dps.dpProjectData.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.dao.DpsCommonDAO;

/** 
 * @파일명	: DpProjectDataDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 17. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Repository("dpProjectDataDAO")
public class DpProjectDataDAO extends DpsCommonDAO {
	
	/**
	 * 
	 * @메소드명	: getTargetData
	 * @날짜		: 2016. 8. 18.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 타겟이 저장하기에 적합한 항목인지 확인 
	 * </pre>
	 * @param rowData
	 * @return
	 */
	public int getTargetData(Map<String, Object> rowData) {
		return selectOneDps("popUpProjectDataERPIFFSMainGridSave.selectTargetData", rowData);
	}
	/**
	 * 
	 * @메소드명	: getTargetData2
	 * @날짜		: 2016. 10. 13.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 추가요청 원가팀 시수테이블 확인
	 * 해당 타겟이 저장하기에 적합한 항목인지 확인 
	 * </pre>
	 * @param rowData
	 * @return
	 */
	public int getTargetData2(Map<String, Object> rowData) {
		return selectOneDps("popUpProjectDataERPIFFSMainGridSave.selectTargetData2", rowData);
	}
	
	public List<Map<String, Object>> dpProjectDataExcelExport(CommandMap commandMap)  throws Exception{
		return selectListDps("dpProjectDataExcelExport.list", commandMap.getMap());
	}
}

package stxship.dis.dwg.dwgApprove.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : DwgApproveDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgApprove에서 사용되는 DAO
 *     </pre>
 */
@Repository("dwgApproveDAO")
public class DwgApproveDAO extends CommonDAO {

	public List<Map<String, Object>> selectDwgRequestList(Map<String, Object> rowData) {
		return selectList("dwgApprove.selectDwgRequestList", rowData);
	}

	public int updateDwgReturnTransDetail(Map<String, Object> rowData) {
		return update("dwgApprove.updateDwgReturnTransDetail", rowData);
	}
	
	public List<Map<String, Object>> dwgApproveExcelExport(Map<String, Object> map) {
		return selectList("dwgCompleteList.list", map);
	}

}

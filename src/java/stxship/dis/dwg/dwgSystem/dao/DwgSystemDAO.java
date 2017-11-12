package stxship.dis.dwg.dwgSystem.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : DwgSystemDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgSystem에서 사용되는 DAO
 *     </pre>
 */
@Repository("dwgSystemDAO")
public class DwgSystemDAO extends CommonDAO {

	public Map<String, Object> getDwgMailSendSeq(Map<String, Object> map) {
		return selectOne("requiredDWG.getDwgMailSendSeq", map);
	}

	public Map<String, Object> select_grantor_epMail(Map<String, Object> map) {
		return selectOne("requiredDWG.select_grantor_epMail", map);
	}

	public List<Map<String, Object>> selectMailContent(String dwgMailSendSeq) {
		return selectList("requiredDWG.selectMailContent",dwgMailSendSeq);
	}
	
	public int dwgRevisionCancelItem(Map<String, Object> map) {
		return delete("requiredDWG.dwgRevisionCancelItem", map);
	}
	
	public int dwgRevisionCancelMarkno(Map<String, Object> map) {
		return delete("requiredDWG.dwgRevisionCancelMarkno", map);
	}
	
	public int dwgRevisionCancelSymbol(Map<String, Object> map) {
		return delete("requiredDWG.dwgRevisionCancelSymbol", map);
	}
	
	public int dwgRevisionCancelMain(Map<String, Object> map) {
		return delete("requiredDWG.dwgRevisionCancelMain", map);
	}
	
	public List<Map<String, Object>> selectDpDpspFlag(Map<String, Object> map) {
		return selectList("requiredDWG.selectDpDpspFlag", map);
	}
	
	public List<Map<String, Object>> selectDwgDeptCode(Map<String, Object> map) {
		return selectList("requiredDWG.selectDwgDeptCode", map);
	}
}

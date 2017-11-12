package stxship.dis.dps.dpInput.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : DpInputDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * DpInput에서 사용되는 DAO
 * </pre>
 */
@Repository("dpInputDAO")
public class DpInputDAO extends CommonDAO {

	public void deletePlmDesignMH(Map<String, Object> map) throws  Exception{
		deleteDps("dpInputCommon.deletePlmDesignMH", map);
	}

	public List<Map<String, Object>> getInsedeWorkTimeTarget(Map<String, Object> map) throws  Exception{
		return selectListDps("dpInputCommon.selectInsedeWorkTimeTarget", map);
	}

	public void insertPlmDesignMH(Map<String, Object> map) throws  Exception{
		insertDps("dpInputCommon.insertPlmDesignMH", map);
	}

	public void insertPlmDesignMHProject(Map<String, Object> map) throws  Exception{
		insertDps("dpInputCommon.insertPlmDesignMHProject", map);
	}

	public void deletePlmDesignMHTrial(Map<String, Object> map) throws  Exception {
		deleteDps("dpInputCommon.deletePlmDesignMHTrial", map);
	}

	public Map<String, Object> getInsedeWorkTimeTargetTrial(Map<String, Object> map) throws Exception{
		return selectOneDps("dpInputCommon.selectInsedeWorkTimeTargetTrial", map);
	}

	public int insertPlmDesignMHProjectInput(Map<String, Object> map) throws Exception{
		return insertDps("dpInputCommon.insertPlmDesignMHProjectInsert", map);
	}

	public int insertPlmDesignMHProjectTrial(Map<String, Object> map) {
		return insertDps("dpInputCommon.insertPlmDesignMHProjectTrial", map);
	}

	public List<Map<String, Object>> getOpCodeListGRT(Map<String, Object> map) {
		return selectListDps("dpInputCommon.selectOpCodeListGRT", map);
	}

	public List<Map<String, Object>> getOpCodeListMID(Map<String, Object> map) {
		return selectListDps("dpInputCommon.selectOpCodeListMID", map);
	}

	public List<Map<String, Object>> getOpCodeListSUB(Map<String, Object> map) {
		return selectListDps("dpInputCommon.selectOpCodeListSUB", map);
	}

	public List<Map<String, Object>> getDrawingListForWorkNormal(Map<String, Object> param) {
		return selectListDps("dpInputCommon.selectDrawingListForWorkNormal", param);
	}

	public List<Map<String, Object>> getDrawingListForWorkNotDp1(Map<String, Object> param) {
		return selectListDps("dpInputCommon.selectDrawingListForWorkNotDp1", param);
	}

	public List<Map<String, Object>> getDrawingListForWorkNotDp2(Map<String, Object> param) {
		return selectListDps("dpInputCommon.selectDrawingListForWorkNotDp2", param);
	}

	public List<Map<String, Object>> getDrawingListForWorkNotDp3(Map<String, Object> param) {
		return selectListDps("dpInputCommon.selectDrawingListForWorkNotDp3", param);
	}

}

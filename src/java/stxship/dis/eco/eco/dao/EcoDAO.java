package stxship.dis.eco.eco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.dao.CommonDAO;

@Repository("ecoDAO")
public class EcoDAO extends CommonDAO {
	
	/** DIS */
	@Autowired
	private SqlSessionTemplate disSession;

	public void stxDisEcoMasterInsertProc(Map<String, Object> pkgParam) {
		selectOne("saveEco.stxDisEcoMasterInsertProc", pkgParam);
	}

	public void stxDisEcoDetailInsertProc(Map<String, Object> pkgParam2) {
		selectOne("saveEco.stxDisEcoDetailInsertProc", pkgParam2);
	}

	public void updateEco(Map<String, Object> pkgParam2) {
		selectOne("saveEco.updateEco", pkgParam2);
	}

	public void insertEcoHistory(Map<String, Object> pkgHisParam) {
		selectOne("saveEco.insertEcoHistory", pkgHisParam);
	}

	public int ecrDuplicateCheck(Map<String, Object> rowData) {
		return selectOne("saveEcrResult.duplicate", rowData);
	}

	public int insertEngRel(Map<String, Object> rowData) {
		return insert("saveEcrResult.insertEngRel", rowData);
	}

	public int deleteEngRel(Map<String, Object> rowData) {
		return insert("saveEcrResult.deleteEngRel", rowData);
	}

	public List<Map<String, Object>> infoEcoExcelList(Map<String, Object> map) {
		return selectList("infoEcoExcelList.list", map);
	}

	public void stxDisEcoPromoteDemoteProc(Map<String, Object> param) {
		selectOne("promoteDemote.stxDisEcoPromoteDemoteProc", param);
	}
	
	public String getLastEcoStatesDesc(Map<String, Object> param) {
		return selectOne("promoteDemote.getLastEcoStatesDesc", param);
	}	
	
	/**
	 * 
	 * @메소드명	: uscCodeNameList
	 * @날짜		: 2016. 10. 4.
	 * @작성자	: 황성준
	 * @설명		: 
	 * <pre>
	 *  uscCodeNameList 패키지 호출 
	 * </pre>
	 * @param map
	 * @return
	 */
	public Map<String, Object> ecoRegisterInfo(Map<String, Object> map) {
		// TODO Auto-generated method stub
		disSession.selectList("ecoList.ecoRegisterInfo", map);
		return map;
	}

	public int updateEngineerRegister(Map<String, Object> map) {
		return update("saveEco.engineerRegisterUpdate", map);
		
	}

}

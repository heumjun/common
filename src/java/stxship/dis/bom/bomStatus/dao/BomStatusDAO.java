package stxship.dis.bom.bomStatus.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : BomStatusDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * BomStatus에서 사용되는 DAO
 *     </pre>
 */
@Repository("bomStatusDAO")
public class BomStatusDAO extends CommonDAO {

	public List<Map<String, Object>> infoSpstShipType(Map<String, Object> map) {
		return selectList("infoSpstShipType.list", map);
	}

	public Map<String, String> selectJobDeptCode(Map<String, Object> map) {
		return selectOne("infoJobDeptCode.selectJobDeptCode", map);
	}

	public Map<String, String> selectProjectShipType(Map<String, Object> shipSearchParam) {
		return selectOne("infoProjectShipType.select", shipSearchParam);
	}

	public int insertItemCodeCreate(Map<String, Object> pkgParam) {
		return insert("saveBomFromJobItem.insertItemCodeCreate", pkgParam);
	}

	public int insertBomFromJobItem(Map<String, Object> pkgParam1) {
		return insert("saveBomFromJobItem.insertBomFromJobItem", pkgParam1);
	}

	public Map<String, Object> duplicateBom(Map<String, Object> rowData) {
		return selectOne("saveJobItem.duplicateBom", rowData);
	}

	public Map<String, Object> duplicateBomWork(Map<String, Object> rowData) {
		return selectOne("saveJobItem.duplicateBomWork", rowData);
	}

	public int deleteBomWork(Map<String, Object> rowData) {
		return delete("saveJobItem.deleteBomWork", rowData);
	}

	public int copyToBomWorkFromBom(Map<String, Object> rowData) {
		return insert("saveJobItem.copyToBomWorkFromBom", rowData);
	}

	/*public int updateDwgNoToJobItem(Map<String, Object> rowData) {
		return update("saveJobItem.updateDwgNoToJobItem", rowData);
	}*/

	public int deleteSpstBomTemp(Map<String, Object> rowData) {
		return delete("saveSpstSubBom.deleteSpstBomTemp", rowData);
	}

	public int insertSpstBomTemp(Map<String, Object> rowData) {
		return insert("saveSpstSubBom.insertSpstBomTemp", rowData);
	}

	public int updateSpstBomTemp(Map<String, Object> rowData) {
		return update("saveSpstSubBom.updateSpstBomTemp", rowData);
	}

	public List<Map<String, Object>> selectBomListFormProject(Map<String, Object> map) {
		return selectList("addSpecificStructure.selectBomListFormProject", map);
	}

	public List<Map<String, Object>> specificStructureList(Map<String, Object> map) {
		return selectList("infoManageSpecificStructure.list", map);
	}

	public Map<String, String> selectJobType(Map<String, Object> map) {
		return selectOne("selectJobType.select", map);
	}

	public String selectSubItemListWithSpstItemCatalogCnt(Map<String, Object> map) {
		return selectOne("addSpecificStructure.selectSubItemListWithSpstItemCatalogCnt", map);
	}

	public Map<String, String> insertEcoHead(Map<String, Object> pkgParam) {
		return selectOne("saveDwgEcoCreate.insertEcoHead", pkgParam);

	}

	public int updateBomWork(Map<String, Object> rowData) {
		return update("saveJobItem.updateBomWork", rowData);
	}
	
	public int updateBomWork_A_state(Map<String, Object> rowData) {
		return update("saveJobItem.updateBomWork_A_state", rowData);
	}	

}

package stxship.dis.paint.pr.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintPRDAO")
public class PaintPRDAO extends CommonDAO {
	
	public int deletePaintPRGroup(Map<String, Object> groupInfo) {
		return delete("savePaintPRGruop.deletePaintPRGroup", groupInfo);
	}

	public int insertManualPaintPRGroup(Map<String, Object> groupInfo) {
		return insert("savePaintPRGruop.insertManualPaintPRGroup", groupInfo);
	}

	public List<Map<String, Object>> selectItemStatusCode(Map<String, Object> prGroupItem) {
		return selectList("saveCreatePaintPR.selectItemStatusCode", prGroupItem);
	}

	public String selectPaintItemUom(Map<String, Object> prGroupItem) {
		return selectOne("saveCreatePaintPR.selectPaintItemUom", prGroupItem);
	}

	public List<Map<String, Object>> selectUserInfo(Map<String, Object> map) {
		return selectList("saveCreatePaintPR.selectUserInfo", map);
	}

	public List<Map<String, Object>> selectProjectInfo(Map<String, Object> map) {
		return selectList("saveCreatePaintPR.selectProjectInfo", map);
	}

	public String selectPORequest() {
		return selectOne("saveCreatePaintPR.selectPORequest", "");
	}

	public int insertPORequisitionInterface(Map<String, Object> prGroupItem) {
		return insert("saveCreatePaintPR.insertPORequisitionInterface", prGroupItem);
	}

	public int updatePaintPRGroup(Map<String, Object> map) {
		return update("saveCreatePaintPR.updatePaintPRGroup", map);
	}

	public void procedurePrRequestProc(Map<String, Object> procedureParam) {
		selectOneErp("saveCreatePaintPR.procedurePrRequestProc", procedureParam);
	}

	public List<Map<String, Object>> infoPaintPRExcelBlockList(Map<String, String> params) {
		return selectList("infoPaintPRExcelBlockList.list", params);
	}

	public int deletePaintPRBlockList(Map<String, Object> map) {
		return delete("saveExcelPaintPRBlock.deletePaintPRBlockList", map);
	}

	public int insertPaintPRBlock(Map<String, Object> blockInfo) {
		return insert("saveExcelPaintPRBlock.insertPaintPRBlock", blockInfo);
	}

	public int selectExistPaintPRGroup(Map<String, Object> map) {
		return selectOne("saveExcelPaintPRBlock.selectExistPaintPRGroup", map);
	}

	public int insertPaintPRGroup(Map<String, Object> map) {
		return insert("saveExcelPaintPRBlock.insertPaintPRGroup", map);
	}

	public List<Map<String, Object>> selectExcelDownLoad(Map<String, Object> map) {
		return selectList("infoPaintPRExcelBlockList.selectExcelDownLoad", map);
	}

	public int deletePaintPRBlock(Map<String, Object> rowData) {
		return delete("saveExcelPaintPRBlock.deletePaintPRBlock", rowData);
	}

	public Map<String, String> selectPaintItemInfo(Map<String, String> param) {
		return selectOne("saveCreatePaintPR.selectPaintItemInfo", param);
	}

	public void deletePrItemList(Map<String, Object> map) {
		delete("saveCreatePaintPR.deletePrItemList", map);
	}

	public int selectPrItemList(Map<String, Object> prGroupItem) {
		return selectOne("saveCreatePaintPR.selectPrItemList", prGroupItem);
	}

	public int insertPrItemList(Map<String, Object> prGroupItem) {
		return insert("saveCreatePaintPR.insertPrItemList", prGroupItem);
	}

}

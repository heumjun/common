package stxship.dis.paint.importPaint.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintImportPaintDAO")
public class PaintImportPaintDAO extends CommonDAO {

	public String selectPaintNewRuleFlag(Map<String, Object> map) {
		return selectOne("selectPaintImportPaintList.selectPaintNewRuleFlag", map);
	}

	public List<Map<String, Object>> selectBlockQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectBlockQuantityList", map);
	}

	public List<Map<String, Object>> selectPrePeQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectPrePeQuantityList", map);
	}

	public List<Map<String, Object>> selectPeQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectPeQuantityList", map);
	}

	public List<Map<String, Object>> selectHullQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectHullQuantityList", map);
	}

	public List<Map<String, Object>> selectHullQuantityList2(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectHullQuantityList2", map);
	}

	public List<Map<String, Object>> selectQuayQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectQuayQuantityList", map);
	}

	public List<Map<String, Object>> selectQuayQuantityList2(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectQuayQuantityList2", map);
	}

	public List<Map<String, Object>> selectOutQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectOutQuantityList", map);
	}

	public List<Map<String, Object>> selectCosQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectCosQuantityList", map);
	}

	public List<Map<String, Object>> selectOutCosQuantityList(Map<String, Object> map) {
		return selectList("selectPaintImportPaintList.selectOutCosQuantityList", map);
	}

	public Map<String, Object> selectPaintEco(Map<String, Object> map) {
		return selectOne("selectPaintEco.selectPaintEco", map);
	}

	public List<Map<String, Object>> selectSeriesProjectNo(Map<String, Object> map) {
		return selectList("selectSeriesProjectNo.selectSeriesProjectNo", map);
	}

	public void savePaintPlanRelease(Map<String, Object> pkgParam) {
		selectOne("savePaintPlanRelease.savePaintPlanRelease", pkgParam);		
	}

	public List<Map<String, Object>> paintSelectEcoAddStateList(Map<String, Object> map) {
		return selectList("paintSelectEcoAddStateList.paintSelectEcoAddStateList", map);
	}

	public void insertPaintHead(Map<String, Object> pkgParam1) {
		selectOne("savePaintImportCreateBom.insertPaintHead", pkgParam1);		
		
	}

	public void deletePaintLine(Map<String, Object> delParam) {
		delete("savePaintImportCreateBom.deletePaintLine", delParam);	
		
	}

	public void insertPaintLine(Map<String, Object> pkgParam2) {
		selectOne("savePaintImportCreateBom.insertPaintLine", pkgParam2);
		
	}

	public void savePaintMain(Map<String, Object> pkgParam3) {
		selectOne("savePaintImportCreateBom.savePaintMain", pkgParam3);
		
	}
	
	public Map<String, Object> paintAdminCheck(Map<String, Object> map) {
		return selectOne("selectPaintImportPaintList.paintAdminCheck", map);
	}	

}

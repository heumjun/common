package stxship.dis.paint.cosmetic.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintCosmeticDAO")
public class PaintCosmeticDAO extends CommonDAO {
	public int selectExistCosmeticArea(Map<String, Object> map) {
		return selectOne("saveCosmeticArea.selectExistCosmeticArea", map);
	}

	public int updateCosmeticArea(Map<String, Object> map) {
		return update("saveCosmeticArea.updateCosmeticArea", map);
	}

	public int insertCosmeticArea(Map<String, Object> map) {
		return insert("saveCosmeticArea.insertCosmeticArea", map);
	}

	public int selectExistCosmeticPaintItem(Map<String, Object> rowData) {
		return selectOne("saveCosmetic.selectExistCosmeticPaintItem", rowData);
	}

	public int insertCosmeticPaintItem(Map<String, Object> rowData) {
		return insert("saveCosmetic.insertCosmeticPaintItem", rowData);
	}

	public int deleteCosmeticPaintItem(Map<String, Object> rowData) {
		return insert("saveCosmetic.deleteCosmeticPaintItem", rowData);
	}

	public List<Map<String, Object>> selectCosmeticExport(Map<String, Object> map) {
		return selectList("paintCosmeticExport.selectCosmeticExport", map);
	}
}

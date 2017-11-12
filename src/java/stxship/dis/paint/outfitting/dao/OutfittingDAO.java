package stxship.dis.paint.outfitting.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : OutfittingDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Outfitting의 DAO
 *     </pre>
 */
@Repository("outfittingDAO")
public class OutfittingDAO extends CommonDAO {

	public int selectExistOutfittingArea(Map<String, Object> map) {
		return selectOne("saveOutfittingArea.selectExistOutfittingArea", map);
	}

	public int updateOutfittingArea(Map<String, Object> map) {
		return update("saveOutfittingArea.updateOutfittingArea", map);
	}

	public int insertOutfittingArea(Map<String, Object> map) {
		return insert("saveOutfittingArea.insertOutfittingArea", map);
	}

	public int selectExistOutfittingPaintItem(Map<String, Object> rowData) {
		return selectOne("saveOutfitting.selectExistOutfittingPaintItem", rowData);
	}

	public int insertOutfittingPaintItem(Map<String, Object> rowData) {
		return insert("saveOutfitting.insertOutfittingPaintItem", rowData);
	}

	public int deleteOutfittingPaintItem(Map<String, Object> rowData) {
		return insert("saveOutfitting.deleteOutfittingPaintItem", rowData);
	}

	public List<Map<String, Object>> selectOutfittingExport(Map<String, Object> map) {
		return selectList("paintOutfittingExport.selectOutfittingExport", map);
	}

}

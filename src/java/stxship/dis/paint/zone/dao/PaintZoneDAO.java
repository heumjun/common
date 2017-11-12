package stxship.dis.paint.zone.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintZoneDAO")
public class PaintZoneDAO extends CommonDAO {
	public String selectExistPatternCode(Map<String, Object> rowData) {
		return selectOne("savePaintBlock.selectExistPatternCode", rowData);
	}

	public List<Map<String, Object>> selectZoneAreaGroupValidCheck(Map<String, Object> map) {
		return selectList("savePaintZone.selectZoneAreaGroupValidCheck", map);
	}	

	public Map<String, Object> checkExistPaintZone(Map<String, Object> map) {
		return selectOne("checkExistPaintZone.checkExistPaintZone", map);
	}

	public List<Map<String, Object>> selectZoneQuayValidCheck(Map<String, Object> map) {
		return selectList("savePaintZone.selectZoneQuayValidCheck", map);
	}	
}

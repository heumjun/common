package stxship.dis.paint.stage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintStageDAO")
public class PaintStageDAO extends CommonDAO {

	public List<Map<String, Object>> selectStageExport(Map<String, Object> map) {
		return selectList("selectStageExport.list", map);
	}

	public int duplicateCheck(Map<String, Object> rowData) {
		return selectOne("savePaintStage.duplicate", rowData);
	}

	public int paintStageInsert(Map<String, Object> rowData) {
		return insert("savePaintStage.insert", rowData);
	}

}

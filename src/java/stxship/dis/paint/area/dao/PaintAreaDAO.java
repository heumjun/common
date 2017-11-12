package stxship.dis.paint.area.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintAreaDAO")
public class PaintAreaDAO extends CommonDAO {

	public List<Map<String, Object>> paintAreaExcelExport(Map<String, Object> map) {
		return selectList("paintAreaExcelExport.list", map);
	}

	public int duplicateCheck(Map<String, Object> rowData) {
		return selectOne("savePaintArea.duplicate", rowData);
	}

	public int selectExistLossCodeCnt(Map<String, Object> rowData) {
		return selectOne("savePaintArea.selectExistLossCodeCnt", rowData);
	}

	public int selectExistAreaDescCnt(Map<String, Object> rowData) {
		return selectOne("savePaintArea.selectExistAreaDescCnt", rowData);
	}

	public int selectExistUsingAreaCnt(Map<String, Object> rowData) {
		return selectOne("savePaintArea.selectExistUsingAreaCnt", rowData);
	}

	public int paintAreaInsert(Map<String, Object> rowData) {
		return insert("savePaintArea.insert", rowData);
	}
}

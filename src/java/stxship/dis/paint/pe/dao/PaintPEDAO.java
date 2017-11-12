package stxship.dis.paint.pe.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintPEDAO")
public class PaintPEDAO extends CommonDAO {

	public int duplicateCheck(Map<String, Object> rowData) {
		return selectOne("savePaintPE.duplicate", rowData);
	}

	public int selectExistBlockCodeCnt(Map<String, Object> rowData) {
		return selectOne("saveExcelPaintPE.selectExistBlockCodeCnt", rowData);
	}

	public int paintPEInsert(Map<String, Object> rowData) {
		return insert("savePaintPE.insert", rowData);
	}

}

package stxship.dis.paint.block.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintBlockDAO")
public class PaintBlockDAO extends CommonDAO {

	public int selectExistAreaCodeFromBlock(Map<String, Object> rowData) {
		return selectOne("savePaintBlock.selectExistAreaCodeFromBlock", rowData);
	}

	public String selectExistPatternCode(Map<String, Object> rowData) {
		return selectOne("savePaintBlock.selectExistPatternCode", rowData);
	}

	public int deletePaintPatternArea(Map<String, Object> rowData) {
		return delete("savePaintBlock.deletePaintPatternArea", rowData);
	}

	public int duplicateCheck(Map<String, Object> rowData) {
		return selectOne("savePaintBlock.duplicate", rowData);
	}

	public int selectExistAreaCodeCnt(Map<String, Object> rowData) {
		return selectOne("saveExcelPaintBlock.selectExistAreaCodeCnt", rowData);
	}

	public int paintBlockInsert(Map<String, Object> rowData) {
		return insert("savePaintBlock.insert", rowData);
	}

	public List<Map<String, Object>> selectBlockExport(Map<String, Object> map) {
		return selectList("selectBlockExport.list", map);
	}

}

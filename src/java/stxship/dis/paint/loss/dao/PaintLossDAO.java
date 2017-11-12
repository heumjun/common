package stxship.dis.paint.loss.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintLossDAO")
public class PaintLossDAO extends CommonDAO {

	public int selectMaxOrderSeq() {
		return selectOne("savePaintLoss.selectMaxOrderSeq", "");
	}

	public String selectExistOrderSeq(Map<String, Object> map) {
		return selectOne("savePaintLoss.selectExistOrderSeq", map);
	}

	public int selectExistLossCodeCnt(Map<String, Object> map) {
		return selectOne("savePaintLoss.selectExistLossCodeCnt", map);
	}

	public int updatePaintLossDesc(Map<String, Object> map) {
		return update("savePaintLoss.updatePaintLossDesc", map);
	}

	public int selectExistLossSetPaintCnt(Map<String, Object> rowData) {
		return selectOne("savePaintLoss.selectExistLossSetPaintCnt", rowData);
	}

	public int deletePaintLoss(Map<String, Object> rowData) {
		return delete("savePaintLoss.deletePaintLoss", rowData);
	}

	public int insertPaintLoss(Map<String, Object> rowData) {
		return insert("savePaintLoss.insertPaintLoss", rowData);
	}

	public int updatePaintLoss(Map<String, Object> rowData) {
		return update("savePaintLoss.updatePaintLoss", rowData);
	}

}

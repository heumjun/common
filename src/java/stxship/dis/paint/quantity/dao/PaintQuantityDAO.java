package stxship.dis.paint.quantity.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintQuantityDAO")
public class PaintQuantityDAO extends CommonDAO {

	public void updatePaintQuantityBlockDefineFlag(Map<String, Object> map) {
		update("savePaintQuantity.updatePaintQuantityBlockDefineFlag", map);
		
	}

	public void updatePaintQuantityPEDefineFlag(Map<String, Object> map) {
		update("savePaintQuantity.updatePaintQuantityPEDefineFlag", map);
		
	}

	public void updatePaintQuantityPrePEDefineFlag(Map<String, Object> map) {
		update("savePaintQuantity.updatePaintQuantityPrePEDefineFlag", map);
		
	}

	public void updatePaintQuantityHullDefineFlag(Map<String, Object> map) {
		update("savePaintQuantity.updatePaintQuantityHullDefineFlag", map);
		
	}

	public void updatePaintQuantityQuayDefineFlag(Map<String, Object> map) {
		update("savePaintQuantity.updatePaintQuantityQuayDefineFlag", map);
		
	}

	public List<Map<String, Object>> selectBlockSeasonCodeCnt(Map<String, Object> map) {
		return selectList("savePaintQuantity.selectBlockSeasonCodeCnt", map);
	}

	public List<Map<String, Object>> selectAllQuantityListExport(Map<String, Object> map) {
		return selectList("allQuantityExcelExport.selectAllQuantityListExport", map);
	}

	public List<Map<String, Object>> selectAllQuantityListExport2(Map<String, Object> map) {
		return selectList("allQuantityExcelExport.selectAllQuantityListExport2", map);
	}

	public void updatePrePEQuantityHalfTransfer(Map<String, Object> map) {
		update("savePaintQuantityTransfer.updatePrePEQuantityHalfTransfer", map);		
	}

	public void updatePrePEQuantityAllTransfer(Map<String, Object> map) {
		update("savePaintQuantityTransfer.updatePrePEQuantityAllTransfer", map);
		
	}

	public void updateHullQuantityAllTransfer(Map<String, Object> map) {
		update("savePaintQuantityTransfer.updateHullQuantityAllTransfer", map);
		
	}

	public void updateBlockQuantityAllTransfer(Map<String, Object> map) {
		update("savePaintQuantityTransfer.updateBlockQuantityAllTransfer", map);
		
	}

	
	public void updateBlockQuantityAllAutoTransfer(Map<String, Object> map) {
		update("savePaintQuantityAutoTransfer.updateBlockQuantityAllAutoTransfer", map);
		
	}

	public void updateHullorQuayQuantityAutoTransfer(Map<String, Object> map) {
		update("savePaintQuantityAutoTransfer.updateHullorQuayQuantityAutoTransfer", map);
		
	}

	public void updatePrePEQuantityHalfAutoTransfer(Map<String, Object> map) {
		update("savePaintQuantityAutoTransfer.updatePrePEQuantityHalfAutoTransfer", map);
		
	}

	public void updatePrePEQuantityAllAutoTransfer(Map<String, Object> map) {
		update("savePaintQuantityAutoTransfer.updatePrePEQuantityAllAutoTransfer", map);		
	}	
}

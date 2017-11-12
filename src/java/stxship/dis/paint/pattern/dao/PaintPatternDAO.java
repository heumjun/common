package stxship.dis.paint.pattern.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintPatternDAO")
public class PaintPatternDAO extends CommonDAO {

	public List<Map<String, Object>> selectPaintCodeList(Map<String, Object> map) {		
		return selectList("searchSelectBoxList.selectPaintCodeList",map);
	}

	public int selectExistPatternCodeCnt(Map<String, Object> map) {
		return selectOne("savePaintPattern.selectExistPatternCodeCnt",map);
	}

	public int selectExistPatternPaintCodeCnt(Map<String, Object> map) {
	
		return selectOne("savePaintPattern.selectExistPatternPaintCodeCnt",map);
	}

	public String selectIsItemModified(Map<String, Object> rowData) {
		return selectOne("savePaintPattern.selectIsItemModified", rowData);
	}

	public int selectExistItemCodeCnt(Map<String, Object> rowData) {
		return selectOne("savePaintPattern.selectExistItemCodeCnt", rowData);
	}

	public int selectExistStageCodeCnt(Map<String, Object> rowData) {
		return selectOne("savePaintPattern.selectExistStageCodeCnt", rowData);
	}

	public int selectExistPatternAreaCodeCnt(Map<String, Object> rowData) {
		return selectOne("savePaintPattern.selectExistPatternAreaCodeCnt", rowData);
	}

	public int selectIsAreaModified(Map<String, Object> rowData) {
		return selectOne("savePaintPattern.selectIsAreaModified", rowData);
	}

	public int selectExistAreaCodeCnt(Map<String, Object> rowData) {
		return selectOne("savePaintPattern.selectExistAreaCodeCnt", rowData);
	}

	public int insertPaintPatternCode(Map<String, Object> map) {
		return insert("savePaintPattern.insertPaintPatternCode", map);
	}

	public int deletePaintPatternItem(Map<String, Object> rowData) {
		return delete("savePaintPattern.deletePaintPatternItem", rowData);		
	}

	public int insertPaintPatternItem(Map<String, Object> rowData) {
		return insert("savePaintPattern.insertPaintPatternItem", rowData);
	}

	public int updatePaintPatternItem(Map<String, Object> rowData) {
		return update("savePaintPattern.updatePaintPatternItem", rowData);
	}

	public void deletePaintPatternWinterItem(Map<String, Object> map) {
		delete("savePaintPattern.deletePaintPatternWinterItem", map);		
	}

	public void insertPaintPatternWinterItem(Map<String, Object> map) {
		insert("savePaintPattern.insertPaintPatternWinterItem", map);		
	}

	public int deletePaintPatternArea(Map<String, Object> rowData) {
		return delete("savePaintPattern.deletePaintPatternArea", rowData);
	}

	public int insertPaintPatternArea(Map<String, Object> rowData) {
		return insert("savePaintPattern.insertPaintPatternArea", rowData);
	}

	public int updatePaintPatternArea(Map<String, Object> rowData) {
		return update("savePaintPattern.updatePaintPatternArea", rowData);
	}

	public int selectCountPatternItem(Map<String, Object> map) {
		return selectOne("savePaintPattern.selectCountPatternItem",map);
	}

	public int selectCountPatternArea(Map<String, Object> map) {
		return selectOne("savePaintPattern.selectCountPatternArea",map);
	}

	public int deletePaintPattern(Map<String, Object> map) {
		return delete("savePaintPattern.deletePaintPattern", map);		
	}

	public String selectPatternDefineFlag(Map<String, Object> rowData) {
		return selectOne("deletePatternList.selectPatternDefineFlag", rowData);
	}

	public void deletePaintPatternCode(Map<String, Object> deleteRow) {
		delete("deletePatternList.deletePaintPatternCode", deleteRow);
	}

	public void deletePaintPatternItemList(Map<String, Object> deleteRow) {
		delete("deletePatternList.deletePaintPatternItemList", deleteRow);		
	}

	public void deletePaintPatternAreaList(Map<String, Object> deleteRow) {
		delete("deletePatternList.deletePaintPatternAreaList", deleteRow);		
	}

	public List<Map<String, Object>> selectAllPatternList(Map<String, Object> map) {
		return selectList("savePatternConfirm.selectAllPatternList",map);
	}

	public int selectExistPatternScheme(Map<String, Object> rowData) {		
		return selectOne("savePatternConfirm.selectExistPatternScheme", rowData);
	}

	public int deletePatternScheme(Map<String, Object> rowData) {
		return delete("savePatternConfirm.deletePatternScheme", rowData);		
	}

	public List<Map<String, Object>> searchPatternPaintCodeTsr(Map<String, Object> rowData) {
		return selectList("savePatternConfirm.searchPatternPaintCodeTsr",rowData);
	}

	public List<Map<String, Object>> searchPatternPaintArea(Map<String, Object> rowData) {		
		return selectList("searchPatternPaintArea.list",rowData);
	}

	public List<Map<String, Object>> selectBlockCodeFromAreaCode(Map<String, Object> areaRow) {
		return selectList("savePatternConfirm.selectBlockCodeFromAreaCode",areaRow);
	}

	public void insertPaintPatternScheme(Map<String, Object> blockRow) {
		insert("savePatternConfirm.insertPaintPatternScheme", blockRow);
		
	}

	public void updatePatternCodeConfirm(Map<String, Object> rowData) {
		update("savePatternConfirm.updatePatternCodeConfirm", rowData);
		
	}

	public int updatePatternCodeUndefine(Map<String, Object> rowData) {
		return update("savePatternUndefine.updatePatternCodeUndefine", rowData);
		
	}

	public List<Map<String, Object>> selectPatternExport(Map<String, Object> map) {
		return selectList("patternExcelExport.selectPatternExport", map);
	}

	public List<Map<String, Object>> selectPatternExport2(Map<String, Object> map) {
		return selectList("patternExcelExport.selectPatternExport2", map);
	}

	public int deletePaintPatternAllItem(Map<String, Object> rowData) {
		return delete("savePaintPattern.deletePaintPatternAllItem", rowData);
	}

}

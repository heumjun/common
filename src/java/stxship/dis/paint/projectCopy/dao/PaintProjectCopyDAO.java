package stxship.dis.paint.projectCopy.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("paintProjectCopyDAO")
public class PaintProjectCopyDAO extends CommonDAO {

	public int selectExistToBlock(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistToBlock", rowData);
	}

	public int insertCopyBlock(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyBlock", rowData);
	}

	public int selectExistToPE(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistToPE", rowData);
	}

	public int selectExistBlockFromToPE(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistBlockFromToPE", rowData);
	}

	public int insertCopyPE(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyPE", rowData);
	}

	public int selectExistToZone(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistToZone", rowData);
	}

	public int selectExistAreaFromToZone(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistAreaFromToZone", rowData);
	}

	public int insertCopyZone(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyZone", rowData);
	}

	public int selectExistToPattern(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistToPattern", rowData);
	}

	public int insertCopyPatternCode(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyPatternCode", rowData);
	}

	public int insertCopyPatternItem(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyPatternItem", rowData);
	}

	public int insertCopyPatternArea(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyPatternArea", rowData);
	}

	public int selectExistToOutfitting(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistToOutfitting", rowData);
	}

	public int insertCopyOutfitting(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyOutfitting", rowData);
	}

	public int insertCopyOutfittingArea(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyOutfittingArea", rowData);
	}

	public int selectExistToCosmetic(Map<String, Object> rowData) {
		return selectOne("saveProjectCopyConfirm.selectExistToCosmetic", rowData);
	}

	public int insertCopyCosmetic(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyCosmetic", rowData);
	}

	public int insertCopyCosmeticArea(Map<String, Object> rowData) {
		return insert("saveProjectCopyConfirm.insertCopyCosmeticArea", rowData);
	}

}

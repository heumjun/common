package stxship.dis.baseInfo.updateItemsAttr.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : UpdateItemsAttrDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Update Item Attr 메뉴가 선택되었을때 사용되는 DAO
 *     </pre>
 */
@Repository("updateItemsAttrDAO")
public class UpdateItemsAttrDAO extends CommonDAO {
	
	public int updatePlmItemAttribute(Map<String, Object> rowData) {
		return update("updatePlmErpDB.updatePlmItemAttribute", rowData);
	}

	public int updatePlmFlag(Map<String, Object> rowData) {
		return update("updatePlmErpDB.updatePlmFlag", rowData);
	}

	public int updateErpItemAttribute(Map<String, Object> pkgParam) {
		return updateErp("updatePlmErpDB.updateErpItemAttribute", pkgParam);
	}

	public int updateErpFlag(Map<String, Object> rowData) {
		return update("updatePlmErpDB.updateErpFlag", rowData);
	}

	public int deleteItemAttributeUpdateList(Map<String, Object> rowData) {
		return delete("itemAttributeExcelImport.deleteItemAttributeUpdateList", rowData);
	}
	
	public int insertItemAttributeUpdateHistoryList(Map<String, Object> rowData) {
		return insert("itemAttributeExcelImport.insertItemAttributeUpdateHistoryList", rowData);
	}	

	public int insertItemAttributeUpdateList(Map<String, Object> rowData) {
		return insert("itemAttributeExcelImport.insertItemAttributeUpdateList", rowData);
	}

	public Map<String, Object> getUploadedFormFile(Map<String, Object> map) {
		return selectOne("FormFile.getUploadedFormFile", map);
	}

}

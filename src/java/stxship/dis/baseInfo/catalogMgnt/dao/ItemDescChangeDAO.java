package stxship.dis.baseInfo.catalogMgnt.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * @파일명 : ItemDescChangeDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 Text Fileter가 선택되어졌을때 사용되는 DAO
 * CatalogMgntDAO와 중복되는 처리가 있으므로 CatalogMgntDAO를 상속
 *     </pre>
 */
@Repository("itemDescChangeDAO")
public class ItemDescChangeDAO extends CatalogMgntDAO {

	public int insertCommonAttributeName() {
		return insert("saveCommonAttributeName.insertCommonAttributeName", null);
	}

	public String selectCatalogAttrHisRevNo(Map<String, Object> rowData) {
		return super.selectCatalogAttrHisRevNo(rowData);
	}

	public int insertCatalogAttributeNameHis(Map<String, Object> rowData) {
		return insert("saveChangeCatalogItemAttr.insertCatalogAttributeNameHis", rowData);
	}

	public int updateCatalogAttributeName(Map<String, Object> rowData) {
		return update("saveChangeCatalogItemAttr.updateCatalogAttributeName", rowData);
	}

	public String selectItemCatalogGroupId(Map<String, Object> rowData) {
		return super.selectItemCatalogGroupId(rowData);
	}

	public int updateDescriptiveElements2(Map<String, Object> rowData) {
		return update("saveChangeCatalogItemAttr.updateDescriptiveElements2", rowData);
	}

}

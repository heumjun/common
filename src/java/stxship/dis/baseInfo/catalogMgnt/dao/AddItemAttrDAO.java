package stxship.dis.baseInfo.catalogMgnt.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : AddItemAttrDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 부가속성이 선택되었을때 사용되는 DAO
 *     </pre>
 */
@Repository("addItemAttrDAO")
public class AddItemAttrDAO extends CommonDAO {

	public int deleteAddItemAttributeBase(Map<String, Object> rowData) {
		return delete("saveItemAddAttribute.deleteAddItemAttributeBase", rowData);
	}

	public int insertAddItemAttributeBase(Map<String, Object> rowData) {
		return insert("saveItemAddAttribute.insertAddItemAttributeBase", rowData);
	}

	public int updateAddItemAttributeBase(Map<String, Object> rowData) {
		return update("saveItemAddAttribute.updateAddItemAttributeBase", rowData);
	}

	public int deleteAddItemValue(Map<String, Object> rowData) {
		return delete("saveItemAddAttribute.deleteAddItemValue", rowData);
	}

	public int insertAddItemValue(Map<String, Object> rowData) {
		return insert("saveItemAddAttribute.insertAddItemValue", rowData);
	}

}

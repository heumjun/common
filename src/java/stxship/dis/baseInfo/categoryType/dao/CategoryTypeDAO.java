package stxship.dis.baseInfo.categoryType.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : CategoryTypeDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatagoryType의 DAO
 *     </pre>
 */
@Repository("categoryTypeDAO")
public class CategoryTypeDAO extends CommonDAO {

	public int insertFndFlexValues(Map<String, Object> rowData) {
		return insert("saveCategoryType.insertFndFlexValues", rowData);
	}

	public int insertFndFlexValuesTl(Map<String, Object> rowData) {
		return insert("saveCategoryType.insertFndFlexValuesTl", rowData);
	}

	public Object selectFndFlexValues(Map<String, Object> rowData) {
		return selectOne("saveCategoryType.selectFndFlexValues", rowData);
	}

	public int updateFndFlexValues(Map<String, Object> rowData) {
		return update("saveCategoryType.updateFndFlexValues", rowData);
	}

	public int updateFndFlexValuesTl(Map<String, Object> rowData) {
		return update("saveCategoryType.updateFndFlexValuesTl", rowData);
	}

}

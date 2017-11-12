package stxship.dis.baseInfo.categoryMgnt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : CategoryMgntDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CategotyMgnt의 DAO
 *     </pre>
 */
@Repository("categoryMgntDAO")
public class CategoryMgntDAO extends CommonDAO {
	public int insertCategoryMgnt(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertCategoryMgnt", rowData);
	}

	public int insertCategoryMgntMTL_CATEGORIES_B(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertCategoryMgntMTL_CATEGORIES_B", rowData);
	}

	public List<Map<String, Object>> selectCategoryMgntDivFlex_value_id(Map<String, Object> rowData) {
		return selectList("saveCategoryMgnt.selectCategoryMgntDivFlex_value_id", rowData);
	}

	public int insertCategoryMgntFND_FLEX_VALUES(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertCategoryMgntFND_FLEX_VALUES", rowData);
	}

	public int insertCategoryMgntFND_FLEX_VALUES_TL(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertCategoryMgntFND_FLEX_VALUES_TL", rowData);
	}

	public int insertCategoryMgntMTL_CATEGORIES_TL_Cost(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertCategoryMgntMTL_CATEGORIES_TL_Cost", rowData);
	}

	public int insertCategoryMgntMTL_CATEGORIES_TL_Invetory(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertCategoryMgntMTL_CATEGORIES_TL_Invetory", rowData);
	}

	public int insertFndFlexValuesTl(Map<String, Object> rowData) {
		return insert("saveCategoryMgnt.insertFndFlexValuesTl", rowData);
	}

	public List<Map<String, Object>> selectChangeUpdate(Map<String, Object> rowData) {
		return selectList("saveCategoryMgnt.selectChangeUpdate", rowData);
	}

	public int updateCategoryMgntSTX_DIS_SD_CATEGORY(Map<String, Object> rowData) {
		return update("saveCategoryMgnt.updateCategoryMgntSTX_DIS_SD_CATEGORY", rowData);
	}

	public int updateCategoryMgntMTL_CATEGORIES_B(Map<String, Object> rowData) {
		return update("saveCategoryMgnt.updateCategoryMgntMTL_CATEGORIES_B", rowData);
	}

	public int updateCategoryMgntMTL_CATEGORIES_TL(Map<String, Object> rowData) {
		return update("saveCategoryMgnt.updateCategoryMgntMTL_CATEGORIES_TL", rowData);
	}

	public int updateCategoryMgntFND_FLEX_VALUES(Map<String, Object> rowData) {
		return update("saveCategoryMgnt.updateCategoryMgntFND_FLEX_VALUES", rowData);
	}

	public int updateCategoryMgntFND_FLEX_VALUES_TL(Map<String, Object> rowData) {
		return update("saveCategoryMgnt.updateCategoryMgntFND_FLEX_VALUES_TL", rowData);
	}

}

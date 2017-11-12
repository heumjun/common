package stxship.dis.etc.itemCategoryView.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

/**
 * @파일명 : ItemCategoryViewDAO.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ItemCategoryView에서 사용되는 DAO
 *     </pre>
 */
@Repository("itemCategoryViewDAO")
public class ItemCategoryViewDAO extends CommonDAO {

	public List<Map<String, Object>> selectItemCategoryViewCatalog(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemCategoryView.selectItemCategoryViewCatalog",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemCategoryViewCategory(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemCategoryView.selectItemCategoryViewCategory",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemCategoryViewType(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemCategoryView.selectItemCategoryViewType",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemCategoryViewTemplate(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemCategoryView.selectItemCategoryViewTemplate",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemCategoryViewTemplateCode(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemCategoryView.selectItemCategoryViewTemplateCode",commandMap.getMap());
	}

	public List<Map<String, Object>> selectItemCategoryViewList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return selectListErp("itemCategoryView.selectItemCategoryViewList",commandMap.getMap());
	}


}

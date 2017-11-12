package stxship.dis.etc.itemCategoryView.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : ItemCategoryViewService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ItemCategoryView에서 사용되는 서비스
 *     </pre>
 */
public interface ItemCategoryViewService extends CommonService {

	List<Map<String, Object>> selectItemCategoryViewCatalog(CommandMap commandMap);

	List<Map<String, Object>> selectItemCategoryViewCategory(CommandMap commandMap);

	List<Map<String, Object>> selectItemCategoryViewType(CommandMap commandMap);

	List<Map<String, Object>> selectItemCategoryViewTemplate(CommandMap commandMap);

	List<Map<String, Object>> selectItemCategoryViewTemplateCode(CommandMap commandMap);

	List<Map<String, Object>> selectItemCategoryViewList(CommandMap commandMap);
}

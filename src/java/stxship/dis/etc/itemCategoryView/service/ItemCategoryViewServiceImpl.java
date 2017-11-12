package stxship.dis.etc.itemCategoryView.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.etc.itemCategoryView.dao.ItemCategoryViewDAO;

/**
 * @파일명 : ItemCategoryViewServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ItemCategoryView에서 사용되는 서비스
 *     </pre>
 */
@Service("itemCategoryViewService")
public class ItemCategoryViewServiceImpl extends CommonServiceImpl implements ItemCategoryViewService {

	@Resource(name = "itemCategoryViewDAO")
	private ItemCategoryViewDAO itemCategoryViewDAO;

	/**
	 * 
	 * @메소드명	: selectItemCategoryViewCatalog
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Catalog 데이터 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemCategoryViewCatalog(CommandMap commandMap) {
		// TODO Auto-generated method stub
		if( "".equals(commandMap.get("sort_type")) || commandMap.get("sort_type") == null){
			commandMap.put("sort_type", "S");
		}
		if( "".equals(commandMap.get("catalog_name")) || commandMap.get("catalog_name") == null){
			commandMap.put("catalog_name", "");
		}
		return itemCategoryViewDAO.selectItemCategoryViewCatalog(commandMap);
	}

	/**
	 * 
	 * @메소드명	: selectItemCategoryViewCategory
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Category 데이터 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemCategoryViewCategory(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return itemCategoryViewDAO.selectItemCategoryViewCategory(commandMap);
	}

	/**
	 * 
	 * @메소드명	: itemCategoryViewType
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: STX_User
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Type 데이터 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemCategoryViewType(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return itemCategoryViewDAO.selectItemCategoryViewType(commandMap);
	}

	/**
	 * 
	 * @메소드명	: selectItemCategoryViewTemplate
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	품목분류표 Template 데이터 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemCategoryViewTemplate(CommandMap commandMap) {
		// TODO Auto-generated method stub
		if( "".equals(commandMap.get("template_name")) || commandMap.get("template_name") == null){
			commandMap.put("template_name", "");
		}
		return itemCategoryViewDAO.selectItemCategoryViewTemplate(commandMap);
	}

	/**
	 * 
	 * @메소드명	: selectItemCategoryViewTemplateCode
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Template 코드 데이터 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemCategoryViewTemplateCode(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return itemCategoryViewDAO.selectItemCategoryViewTemplateCode(commandMap);
	}

	/**
	 * 
	 * @메소드명	: selectItemCategoryViewList
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: STX_User
	 * @설명		: 
	 * <pre>
	 *	품목분류표 구매요청/비용성품목/BSI/GSI 화면 데이터 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@Override
	public List<Map<String, Object>> selectItemCategoryViewList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		if( "".equals(commandMap.get("select_type")) || commandMap.get("select_type") == null){
			commandMap.put("select_type", "PRDP");
		}
		return itemCategoryViewDAO.selectItemCategoryViewList(commandMap);
	}



}

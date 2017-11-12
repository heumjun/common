package stxship.dis.etc.itemCategoryView.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.etc.itemCategoryView.service.ItemCategoryViewService;

/**
 * @파일명 : ItemCategoryViewController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class ItemCategoryViewController extends CommonController {
	@Resource(name = "itemCategoryViewService")
	private ItemCategoryViewService itemCategoryViewService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ItemCategoryView 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCategoryView.do")
	public ModelAndView itemCategoryViewAction(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	
	/**
	 * 
	 * @메소드명	: itemCategoryViewCatalog
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Catalog 탭 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCategoryViewCatalog.do")
	public ModelAndView itemCategoryViewCatalog(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> list = null;
		
		// 조회 버튼 누른 경우만 data 조회
		if (null != commandMap.get("mode") && "search".equals(commandMap.get("mode")))
		{
			list = itemCategoryViewService.selectItemCategoryViewCatalog(commandMap);
		} else {
			// 최초화면 로딩시 default checkbox
			if( "".equals(commandMap.get("sort_type")) || commandMap.get("sort_type") == null){
				commandMap.put("sort_type", "S");
			}
		}
		mav.addObject("list", list);
		
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemCategoryViewCatalogExcelDownload
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Catalog 엑셀 다운로드
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCategoryViewCatalogExcelDownload.do")
	public ModelAndView itemCategoryViewCatalogExcelDownload(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> list = itemCategoryViewService.selectItemCategoryViewCatalog(commandMap);
		mav.addObject("list", list);
		
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemCategoryViewCategory
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 Category 탭 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCategoryViewCategory.do")
	public ModelAndView itemCategoryViewCategory(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> list = itemCategoryViewService.selectItemCategoryViewCategory(commandMap);
		mav.addObject("list", list);
		
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemCategoryViewCategory
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	품목분류표 Type 탭 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCategoryViewType.do")
	public ModelAndView itemCategoryViewType(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> list = itemCategoryViewService.selectItemCategoryViewType(commandMap);
		mav.addObject("list", list);
		
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemCategoryViewTemplate
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	품목분류표 Template 탭 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCategoryViewTemplate.do")
	public ModelAndView itemCategoryViewTemplate(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> codeList = itemCategoryViewService.selectItemCategoryViewTemplateCode(commandMap);
		mav.addObject("codeList", codeList);
		
		List<Map<String, Object>> list = itemCategoryViewService.selectItemCategoryViewTemplate(commandMap);
		mav.addObject("list", list);
		
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemCategoryViewList
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 품목분류표 구매요청/비용성품목/BSI/GSI 탭 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value =  "itemCategoryViewList.do")
	public ModelAndView itemCategoryViewList(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		
		List<Map<String, Object>> list = null;
		
		// 조회 버튼 누른 경우만 data 조회
		if (null != commandMap.get("mode") && "search".equals(commandMap.get("mode")))
		{
			list = itemCategoryViewService.selectItemCategoryViewList(commandMap);
		} else {
			// 최초화면 로딩시 default checkbox
			if( "".equals(commandMap.get("select_type")) || commandMap.get("select_type") == null){
				commandMap.put("select_type", "PRDP");
			}
		}		

		mav.addObject("list", list);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemCategoryViewListExcelDownload
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: STX_User
	 * @설명		: 
	 * <pre>
	 *	품목분류표 구매요청/비용성품목/BSI/GSI 엑셀 다운로드
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value =  "itemCategoryViewListExcelDownload.do")
	public ModelAndView itemCategoryViewListExcelDownload(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView();
		List<Map<String, Object>> list = itemCategoryViewService.selectItemCategoryViewList(commandMap);
		mav.addObject("list", list);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

}

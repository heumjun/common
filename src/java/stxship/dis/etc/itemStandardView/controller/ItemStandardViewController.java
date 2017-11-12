package stxship.dis.etc.itemStandardView.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.etc.itemStandardView.service.ItemStandardViewService;

/**
 * @파일명 : ItemStandardViewController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class ItemStandardViewController extends CommonController {
	@Resource(name = "itemStandardViewService")
	private ItemStandardViewService itemStandardViewService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ItemStandardView 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardView.do")
	public ModelAndView itemStandardView(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: itemStandardViewLevel1
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	부품표준서 대분류 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardViewLevel1.do")
	public ModelAndView itemStandardViewLevel1(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		List<Map<String, Object>> list = itemStandardViewService.selectItemStandardViewLevel1(commandMap);
		mav.addObject("list", list);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemStandardViewLevel1
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	부품표준서 중분류 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardViewLevel2.do")
	public ModelAndView itemStandardViewLevel2(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		List<Map<String, Object>> list = itemStandardViewService.selectItemStandardViewLevel2(commandMap);
		mav.addObject("list", list);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemStandardViewLevel1
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	부품표준서 소분류 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardViewLevel3.do")
	public ModelAndView itemStandardViewLevel3(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		List<Map<String, Object>> list = itemStandardViewService.selectItemStandardViewLevel3(commandMap);
		mav.addObject("list", list);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: itemStandardViewLevel1
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 *	부품표준서 검색 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardViewSearch.do")
	public ModelAndView itemStandardViewSearch(CommandMap commandMap) {

		ModelAndView mav = getUserRoleAndLink(commandMap);
		List<Map<String, Object>> list = null;
		
		// 조회 버튼 누른 경우만 data 조회
		if (null != commandMap.get("mode") && "search".equals(commandMap.get("mode")))
		{		
			list = itemStandardViewService.itemStandardViewSearch(commandMap);
		}
		mav.addObject("list", list);
		mav.addAllObjects(commandMap.getMap());
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
}

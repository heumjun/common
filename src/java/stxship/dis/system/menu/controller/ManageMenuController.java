package stxship.dis.system.menu.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.menu.service.ManageMenuService;
import stxship.dis.system.notice.service.NoticeService;

@Controller
public class ManageMenuController extends CommonController {
	@Resource(name = "manageMenuService")
	private ManageMenuService manageMenuService;
	
	@Resource(name = "noticeService")
	private NoticeService noticeService;
	

	@RequestMapping(value = "menu.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "menuTree.do")
	public ModelAndView menuTree(CommandMap commandMap) {
		ModelAndView mv = getUserRoleAndLink(commandMap);
		mv.addObject(DisConstants.VIEW_TREE_MENU_LIST, manageMenuService.getTreeMenuList(commandMap));
		return mv;
	}

	@RequestMapping(value = "manageMenu.do")
	public ModelAndView manageMenu(CommandMap commandMap) {
		ModelAndView mv = getUserRoleAndLink(commandMap);
		mv.addObject(DisConstants.MENU_UP_MENU_ID_KEY, commandMap.get(DisConstants.MENU_UP_MENU_ID_KEY));
		return mv;
	}

	@RequestMapping(value = "manageMenuList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return manageMenuService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveManageMenu.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return manageMenuService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : layoutMenu2
	 * @날짜 : 2015. 11. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 좌측 메뉴 컨트롤 : 트리메뉴 리스트를 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "layoutLeftMenu.do")
	public ModelAndView layoutLeftMenu(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		mav.addObject(DisConstants.VIEW_TREE_MENU_LIST, manageMenuService.getTreeMenuList(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : layoutMenu3
	 * @날짜 : 2015. 11. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 메뉴와 컨텐츠의 경계설정 페이지 이동
	 *     </pre>
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "layoutSeparation.do")
	public ModelAndView layoutSeparation(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * Header 화면
	 */
	/**
	 * @메소드명 : layoutHeader
	 * @날짜 : 2015. 11. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상단 메뉴의 페이지이동
	 *     </pre>
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "layoutHeader.do")
	public ModelAndView layoutHeader(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : mainContents
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 메인 화면에서 필요한 정보를 취득하여 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "layoutMainContents.do")
	public ModelAndView layoutMainContents(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		mav.addAllObjects(manageMenuService.getApproveAndNoticeList(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : getMenuRole
	 * @날짜 : 2016. 4. 25.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 입력된 메뉴의 권한정보를 취득한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "getMenuRole.do")
	public @ResponseBody Map<String, Object> getMenuRole(CommandMap commandMap) {
		return manageMenuService.getUserRole(commandMap);
	}
	
	/**
	 * @메소드명 : evenPopupTest
	 * @날짜 : 2017. 03. 29.
	 * @작성자 : Cho Heum Jun
	 * @설명 :
	 * 
	 *     <pre>
	 * evenPopupTest
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "eventPopup.do")
	public ModelAndView sscAddMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + "/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		commandMap.put("mapperName", "popUpNotice");
		mav.addObject("notice", noticeService.getDbDataOne(commandMap));
		return mav;
	}
	
	@RequestMapping(value = "menuId.do")
	public @ResponseBody Map<String, Object> getMenuId(CommandMap commandMap) {
		return manageMenuService.getMenuId(commandMap);
	}
	
}

package stxship.dis.system.user.controller;

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
import stxship.dis.system.user.service.ManageUserService;

@Controller
public class ManageUserController extends CommonController {
	@Resource(name = "manageUserService")
	private ManageUserService manageUserService;
	
	@Resource(name = "manageMenuService")
	private ManageMenuService manageMenuService;

	@RequestMapping(value = "manageUser.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "manageUserList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return manageUserService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveManageUser.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return manageUserService.saveGridList(commandMap);
	}

	@RequestMapping(value = "popUpUserInfo.do")
	public ModelAndView popUpUserInfoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("system/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "infoUserList.do")
	public @ResponseBody Map<String, Object> infoUserListAction(CommandMap commandMap) {
		return manageUserService.getGridList(commandMap);

	}

	@RequestMapping(value = "infoManageUserList.do")
	public @ResponseBody Map<String, Object> infoManageUserListAction(CommandMap commandMap) {
		return manageUserService.getGridList(commandMap);

	}

	@RequestMapping(value = "popUpUserInfoUpdate.do")
	public ModelAndView popUpUserInfoUpdate(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	@RequestMapping(value = "savePopUpUserInfo.do")
	public ModelAndView savePopupUserInfo(CommandMap commandMap) throws Exception {
		ModelAndView mav = manageUserService.savePopUpUserInfo(commandMap);
		mav.setViewName(DisConstants.MENU + "/popUpUserInfoUpdate");
		return mav;
	}
	
	@RequestMapping(value = "popUpBookmarkUpdate.do")
	public ModelAndView popUpBookmarkUpdate(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		commandMap.put("gridPosition", "left");
		mav.addObject("gridLeftList", manageMenuService.getBookmarkList(commandMap));
		commandMap.put("gridPosition", "right");
		mav.addObject("gridRightList", manageMenuService.getUserBookmarkList(commandMap));
		mav.addObject("roleCode", commandMap.get("roleCode"));
		return mav;
	}
	
	@RequestMapping(value = "saveBookmarkEdit.do")
	public @ResponseBody Map<String, Object> saveBookmarkEdit(CommandMap commandMap) throws Exception {
		return manageUserService.saveBookmarkEdit(commandMap);
	}

}

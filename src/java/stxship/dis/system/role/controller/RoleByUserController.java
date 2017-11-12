package stxship.dis.system.role.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.role.service.RoleByUserService;

@Controller
public class RoleByUserController extends CommonController {

	@Resource(name = "roleByUserService")
	private RoleByUserService roleByUserService;

	@RequestMapping(value = "roleByUser.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "roleByUserList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return roleByUserService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveRoleByUser.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return roleByUserService.saveGridList(commandMap);
	}
	
	@RequestMapping(value = "roleCopy.do")
	public @ResponseBody Map<String, String> roleCopyAction(CommandMap commandMap) throws Exception {
		return roleByUserService.roleCopy(commandMap);
	}
	
}

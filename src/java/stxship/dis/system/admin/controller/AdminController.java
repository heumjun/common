package stxship.dis.system.admin.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.admin.service.AdminService;

@Controller
public class AdminController extends CommonController {
	@Resource(name = "adminService")
	private AdminService adminService;

	@RequestMapping(value = "admin.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "adminList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return adminService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveAdmin.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return adminService.saveGridList(commandMap);
	}

}

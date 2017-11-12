package stxship.dis.system.contactUs.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.contactUs.service.PersonInChargeService;

@Controller
public class PersonInChargeController extends CommonController {
	@Resource(name = "personInChargeService")
	private PersonInChargeService personInChargeService;

	@RequestMapping(value = "personInCharge.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "personInChargeList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return personInChargeService.getGridList(commandMap);
	}

	@RequestMapping(value = "savePersonInCharge.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return personInChargeService.saveGridList(commandMap);
	}
	
	@RequestMapping(value = "popUpPersonInCharge.do")
	public ModelAndView popUpPersonInCharge(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.MENU + commandMap.get(DisConstants.JSP_NAME));
		mav.addObject("list", personInChargeService.getDbDataList(commandMap));
		return mav;
	}
}

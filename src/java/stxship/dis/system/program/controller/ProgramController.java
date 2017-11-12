package stxship.dis.system.program.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.program.service.ProgramService;

@Controller
public class ProgramController extends CommonController {
	@Resource(name = "programService")
	private ProgramService programService;

	@RequestMapping(value = "program.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "programList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return programService.getGridList(commandMap);
	}

	@RequestMapping(value = "saveProgram.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return programService.saveGridList(commandMap);
	}

	@RequestMapping(value = "popUpProgramInfo.do")
	public ModelAndView popUpSystemInfoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("system/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
}

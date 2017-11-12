package stxship.dis.bom.unit.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.bom.unit.service.UnitService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;

@Controller
public class UnitController extends CommonController {
	Logger				log	= Logger.getLogger(this.getClass());

	@Resource(name = "unitService")
	private UnitService	unitService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 4. 12.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Unit Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "unitMain.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : unitMainList
	 * @날짜 : 2016. 4. 12.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Unit Main List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "unitMainList.do")
	public @ResponseBody Map<String, Object> unitMainList(CommandMap commandMap) throws Exception {
		return unitService.unitMainList(commandMap);
	}

}

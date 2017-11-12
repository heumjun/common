package stxship.dis.eco.eco.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.eco.eco.service.EcoService;

@Controller
public class EcoLifeCycleController extends CommonController {
	@Resource(name = "ecoService")
	private EcoService ecoService;

	/**
	 * @메소드명 : ecoLifeCycleAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * eco의 LifeCycle이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecoLifeCycle.do")
	public ModelAndView ecoLifeCycleAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.ECO + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : ecoLifeCycleListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LifeCycle리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoLifeCycleList.do")
	public @ResponseBody Map<String, Object> ecoLifeCycleListAction(CommandMap commandMap) {
		return ecoService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectEcoPartCountAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     EcoPartCount취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectEcoPartCount.do")
	public @ResponseBody Map<String, Object> selectEcoPartCountAction(CommandMap commandMap) {
		return commonService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : promoteDemoteAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인 반려 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "promoteDemote.do")
	public @ResponseBody Map<String, String> promoteDemoteAction(CommandMap commandMap) throws Exception {
		return ecoService.promoteDemote(commandMap);
	}

}

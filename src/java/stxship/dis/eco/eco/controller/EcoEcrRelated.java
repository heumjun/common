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
public class EcoEcrRelated extends CommonController {
	@Resource(name = "ecoService")
	private EcoService ecoService;

	/**
	 * @메소드명 : popUpECRAction
	 * @날짜 : 2015. 12. 16.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1. ECO화면의 리스트에서 ECR팝업
	 * 2. ECO화면의 Re_ECRs탭에서  ECR팝업
	 * 3. ECR Interface에서 ECR팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpECR.do")
	public ModelAndView popUpECRAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoEcoAddEcrRinkPopupListAction
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR팝업의 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoEcoAddEcrRinkPopupList.do")
	public @ResponseBody Map<String, Object> infoEcoAddEcrRinkPopupListAction(CommandMap commandMap) {
		return ecoService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveEcrResultAction
	 * @날짜 : 2015. 12. 17.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR팝업의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEcrResult.do")
	public @ResponseBody Map<String, String> saveEcrResultAction(CommandMap commandMap) throws Exception {
		return ecoService.saveEcrResult(commandMap);
	}

}

package stxship.dis.baseInfo.catalogMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.catalogMgnt.service.TechnicalSpecService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

@Controller
public class TechnicalSpecController extends CommonController {

	@Resource(name = "technicalSpecService")
	private TechnicalSpecService technicalSpecService;

	/**
	 * @메소드명 : popUpCatalogTechnicalSpecAction
	 * @날짜 : 2015. 12. 2.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 비용성 코드 생성 버튼을 눌렀을때 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogTechnicalSpec.do")
	public ModelAndView popUpCatalogTechnicalSpecAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : saveTechnicalSpecAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 비용성 코드 생성을 생성했을때 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveTechnicalSpec.do")
	public @ResponseBody Map<String, String> saveTechnicalSpecAction(CommandMap commandMap) throws Exception {
		return technicalSpecService.saveTechnicalSpec(commandMap);
	}
}

package stxship.dis.baseInfo.ecrBasedOn.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.baseInfo.ecrBasedOn.service.EcrBasedOnService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : EcrBasedOnController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ECR ECO Mapping 메뉴 선택시 사용되는 컨트롤러
 *     </pre>
 */
@Controller
public class EcrBasedOnController extends CommonController {
	@Resource(name = "ecrBasedOnService")
	private EcrBasedOnService ecrBasedOnService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR ECO Mapping 메뉴 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrBasedOn.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR ECO Mapping 정보 리스트를 출ㄹ력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ecrBasedOnList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return ecrBasedOnService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR ECO Mapping 정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEcrBasedOn.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return ecrBasedOnService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpEcrEcoCodeMappingAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECR ECO Mapping 팝업창으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEcrEcoCodeMapping.do")
	public ModelAndView popUpEcrEcoCodeMappingAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	@RequestMapping(value = "ecrEcoMappingExcelExport.do")
	public View ecrEcoMappingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return ecrBasedOnService.excelExport(commandMap, modelMap);
	}
}

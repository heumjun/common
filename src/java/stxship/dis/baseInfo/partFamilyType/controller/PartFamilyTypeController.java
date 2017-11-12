package stxship.dis.baseInfo.partFamilyType.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.baseInfo.partFamilyType.service.PartFamilyTypeService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : PartFamilyTypeController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Part Family Type 메뉴 선택시 사용되는 컨트롤러
 *     </pre>
 */
@Controller
public class PartFamilyTypeController extends CommonController {
	@Resource(name = "partFamilyTypeService")
	private PartFamilyTypeService partFamilyTypeService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Part Family Type 메뉴 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "partFamilyType.do")
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
	 * Part Family Type 정보 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "partFamilyTypeList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return partFamilyTypeService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Part Family Type 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePartFamilyType.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return partFamilyTypeService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpItemValueRuleAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Item 채변 규칙 팝업창이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemValueRule.do")
	public ModelAndView popUpItemValueRuleAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("baseInfo/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoItemValueRuleAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Item 채변 규칙 리스트를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemValueRule.do")
	public @ResponseBody Map<String, Object> infoItemValueRuleAction(CommandMap commandMap) {
		return partFamilyTypeService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : PartFamilyTypeExcelExport
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Excel 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "partFamilyTypeExcelExport.do")
	public View PartFamilyTypeExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return partFamilyTypeService.excelExport(commandMap, modelMap);
	}
}

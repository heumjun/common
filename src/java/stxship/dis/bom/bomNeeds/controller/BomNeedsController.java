package stxship.dis.bom.bomNeeds.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.bom.bomNeeds.service.BomNeedsService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : BomNeedsController.java
 * @프로젝트 : DIS
 * @날짜 : 2017. 1. 15.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * BOM Needs의 컨트롤러
 *     </pre>
 */
@Controller
public class BomNeedsController extends CommonController {
	@Resource(name = "bomNeedsService")
	private BomNeedsService bomNeedsService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2017. 1. 15.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM NEEDS 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomNeeds.do")
	public ModelAndView bomNeeds(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		return mav;
	}

	/**
	 * @메소드명 : bomNeedsList
	 * @날짜 : 2017. 1. 15.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * bomNeedsList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomNeedsList.do")
	public @ResponseBody Map<String, Object> bomNeedsList(CommandMap commandMap) throws Exception {		
		return bomNeedsService.bomNeedsList(commandMap);
	}
	
	
	/**
	 * @메소드명 : bomNeedsBomList
	 * @날짜 : 2017. 1. 15.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * bomNeedsBomList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomNeedsBomList.do")
	public @ResponseBody Map<String, Object> bomNeedsBomList(CommandMap commandMap) {		
		return bomNeedsService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : bomNeedsWipData
	 * @날짜 : 2017. 04. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * bomNeedsWipData
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomNeedsWipData.do")
	public @ResponseBody Map<String, Object> bomNeedsWipData(CommandMap commandMap) throws Exception {		
		return bomNeedsService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : bomNeedsErpData
	 * @날짜 : 2017. 1. 15.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * bomNeedsErpData
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomNeedsErpData.do")
	public @ResponseBody Map<String, Object> bomNeedsErpData(CommandMap commandMap) throws Exception {		
		return bomNeedsService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : bomNeedsExcelList
	 * @날짜 : 2017. 1. 15.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * bomNeedsExcelList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomNeedsExcelList.do")
	public @ResponseBody View bomNeedsExcelList(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return bomNeedsService.bomNeedsExcelList(commandMap, modelMap);
	}

}

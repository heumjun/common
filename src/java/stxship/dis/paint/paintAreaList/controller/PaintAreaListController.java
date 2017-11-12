package stxship.dis.paint.paintAreaList.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.paintAreaList.service.PaintAreaListService;

/**
 * @파일명 : PaintAreaListController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Paint Area List 의 컨트롤러
 *     </pre>
 */
@Controller
public class PaintAreaListController extends CommonController {
	@Resource(name = "paintAreaListService")
	private PaintAreaListService paintAreaListService;

	/**
	 * @메소드명 : paintPaintAreaList
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Area List 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPaintAreaList.do")
	public ModelAndView paintPaintAreaList(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintAreaListBlock
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block TAB 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAreaListBlock.do")
	public ModelAndView paintAreaListBlock(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintAreaListPe
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE TAB 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAreaListPe.do")
	public ModelAndView paintAreaListPe(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintAreaListHull
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * HULL TAB 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAreaListHull.do")
	public ModelAndView paintAreaListHull(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintAreaListQuay
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Quay TAB 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAreaListQuay.do")
	public ModelAndView paintAreaListQuay(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : selectBlockPaintAreaList
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectBlockPaintAreaList.do")
	public @ResponseBody Map<String, Object> selectBlockPaintAreaList(CommandMap commandMap) {
		return paintAreaListService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectHullPaintAreaList
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 	 HULL 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectHullPaintAreaList.do")
	public @ResponseBody Map<String, Object> selectHullPaintAreaList(CommandMap commandMap) {
		return paintAreaListService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectPEPaintAreaList
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPEPaintAreaList.do")
	public @ResponseBody Map<String, Object> selectPEPaintAreaList(CommandMap commandMap) {
		return paintAreaListService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectQuayPaintAreaList
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Quay 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectQuayPaintAreaList.do")
	public @ResponseBody Map<String, Object> selectQuayPaintAreaList(CommandMap commandMap) {
		return paintAreaListService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : paintAreaListExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Area 의 Excel 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "paintAreaListExcelExport.do")
	public View paintAreaListExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		return paintAreaListService.paintAreaListExcelExport(commandMap, modelMap);
	}
}

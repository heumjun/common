package stxship.dis.paint.printPaint.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.printPaint.service.PaintPrintPaintService;

/**
 * @파일명 : PaintPrintPaintController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint Print 컨트롤러
 *     </pre>
 */
@Controller
public class PaintPrintPaintController extends CommonController {
	@Resource(name = "paintPrintPaintService")
	private PaintPrintPaintService paintPrintPaintService;

	/**
	 * @메소드명 : paintPrintPaint
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint  Print 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPrintPaint.do")
	public ModelAndView paintPrintPaint(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintPrintTabBlock
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block Tab 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPrintTabBlock.do")
	public ModelAndView paintPrintTabBlock(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintPrintTabPe
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE Tab 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPrintTabPe.do")
	public ModelAndView paintPrintTabPe(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintPrintTabHull
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Hull Tab 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPrintTabHull.do")
	public ModelAndView paintPrintTabHull(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintPrintTabQuay
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Quay Tab 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPrintTabQuay.do")
	public ModelAndView paintPrintTabQuay(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : selectPaintPlanCodeListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PlanCodeList 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintPlanCodeList.do")
	public @ResponseBody Map<String, Object> selectPaintPlanCodeListAction(CommandMap commandMap) {
		return paintPrintPaintService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectBlockPaintPlanListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  Block 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectBlockPaintPlanList.do")
	public @ResponseBody Map<String, Object> selectBlockPaintPlanListAction(CommandMap commandMap) {
		return paintPrintPaintService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectHullPaintPlanListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  Hull 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectHullPaintPlanList.do")
	public @ResponseBody Map<String, Object> selectHullPaintPlanListAction(CommandMap commandMap) {
		return paintPrintPaintService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectPEPaintPlanListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  PE 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPEPaintPlanList.do")
	public @ResponseBody Map<String, Object> selectPEPaintPlanListAction(CommandMap commandMap) {
		return paintPrintPaintService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectQuayPaintPlanListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  Quay 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectQuayPaintPlanList.do")
	public @ResponseBody Map<String, Object> selectQuayPaintPlanListAction(CommandMap commandMap) {
		return paintPrintPaintService.getGridListNoPaging(commandMap);
	}
}

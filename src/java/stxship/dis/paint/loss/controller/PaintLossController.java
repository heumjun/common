package stxship.dis.paint.loss.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.loss.service.PaintLossService;

/**
 * @파일명 : PaintLossController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Paint Loss 컨트롤러
 *     </pre>
 */
@Controller
public class PaintLossController extends CommonController {
	@Resource(name = "paintLossService")
	private PaintLossService paintLossService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintLoss.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : popUpPaintLossEditAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss Edit 팝업화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPaintLossEdit.do")
	public ModelAndView popUpPaintLossEditAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));

		return mav;
	}

	/**
	 * @메소드명 : searchPaintLossAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss 리스트 를 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPaintLossList.do")
	public @ResponseBody Map<String, Object> infoPaintLossListAction(CommandMap commandMap) {
		return paintLossService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : infoPaintLossCodeAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss Code 내용을 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPaintLossCode.do")
	public @ResponseBody Map<String, Object> infoPaintLossCodeAction(CommandMap commandMap) {
		return paintLossService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : savePaintLossAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss Code 의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintLoss.do")
	public @ResponseBody Map<String, String> savePaintLossAction(CommandMap commandMap) throws Exception {
		return paintLossService.savePaintLoss(commandMap);
	}

	/**
	 * @메소드명 : lossExcelExportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Loss 정보를 엑셀로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "lossExcelExport.do")
	public View lossExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintLossService.lossExcelExport(commandMap, modelMap);
	}

	@RequestMapping(value = "updateLoseCodeOnOff.do")
	public @ResponseBody int updateUserControlAction(CommandMap commandMap) {
		return commonService.updateDbData(commandMap);
	}

	@RequestMapping(value = "selectLoseCodeOnOff.do")
	public @ResponseBody Map<String, Object> selectLoseCodeOnOffAction(CommandMap commandMap) {
		return commonService.getDbDataOne(commandMap);
	}

}

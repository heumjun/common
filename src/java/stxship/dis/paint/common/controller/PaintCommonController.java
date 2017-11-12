package stxship.dis.paint.common.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.common.service.PaintCommonService;

/**
 * @파일명 : PaintCommonController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 7.
 * @작성자 : 강선중
 * @설명
 * 
 * 	<pre>
 * Paint 공통 컨트롤러
 *     </pre>
 */
@Controller
public class PaintCommonController extends CommonController {
	@Resource(name = "paintCommonService")
	private PaintCommonService paintCommonService;

	/**
	 * @메소드명 : popupPaintPlanProjectNoAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint 모듈에서 그리드나 화면에서 Paint Plan 호선 리스트 조회 팝업화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupPaintPlanProjectNo.do")
	public ModelAndView popupPaintPlanProjectNoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : selectPaintPlanProjectNoAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Plan 호선 리스트 조회 팝업화면 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintPlanProjectNo.do")
	public @ResponseBody Map<String, Object> selectPaintPlanProjectNoAction(CommandMap commandMap) {
		return paintCommonService.getGridList(commandMap);

	}

	/**
	 * @메소드명 : paintPlanProjectNoCheckAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Plan 호선의 최신리비전, 상태 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPlanProjectNoCheck.do")
	public @ResponseBody Map<String, Object> paintPlanProjectNoCheckAction(CommandMap commandMap) {
		Map<String, Object> result = paintCommonService.paintPlanProjectNoCheck(commandMap);
		return result;
	}

	/**
	 * @메소드명 : popupPaintCodeAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 Paint Item 연계 그리드 - Paint Item 리스트 조회 팝업 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupPaintCode.do")
	public ModelAndView popupPaintCodeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : selectPaintCodeListAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 Paint Item 연계 그리드 - Paint Item 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintItemCodeList.do")
	public @ResponseBody Map<String, Object> selectPaintItemCodeListAction(CommandMap commandMap) {
		return paintCommonService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpExcelUploadAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 업로드 팝업창 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpExcelUpload.do")
	public ModelAndView popUpExcelUploadAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * @메소드명 : selectPaintNewRuleFlagAction
	 * @날짜 : 2016. 03. 17.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Project - DIS Rule 체크 여부 확인 (DIS 적용호선 or Mig 대상호선)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "selectPaintNewRuleFlag.do")
	public @ResponseBody Map<String, Object> selectPaintNewRuleFlagAction(CommandMap commandMap) throws Exception {		
		return paintCommonService.selectPaintNewRuleFlag(commandMap);		
	}	
}

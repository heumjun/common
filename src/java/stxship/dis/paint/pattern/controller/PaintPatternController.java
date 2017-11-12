package stxship.dis.paint.pattern.controller;

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
import stxship.dis.paint.pattern.service.PaintPatternService;

/**
 * @파일명 : PaintPatternController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 5.
 * @작성자 : 강선중
 * @설명
 * 
 * 	<pre>
 * Paint Pattern 컨트롤러
 *     </pre>
 */
@Controller
public class PaintPatternController extends CommonController {
	/** Paint Pattern 서비스정의 */
	@Resource(name = "paintPatternService")
	private PaintPatternService paintPatternService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Pattern 모듈로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPattern.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Pattern 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPatternList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return paintPatternService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Pattern Edit 화면 - 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintPattern.do")
	public @ResponseBody Map<String, String> savePaintPatternAction(CommandMap commandMap) throws Exception {
		return paintPatternService.savePaintPattern(commandMap);

	}

	/**
	 * @메소드명 : deletePatternListAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Pattern - 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deletePatternList.do")
	public @ResponseBody Map<String, String> deletePatternListAction(CommandMap commandMap) throws Exception {
		return paintPatternService.deletePatternList(commandMap);

	}

	/**
	 * @메소드명 : savePatternConfirmAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Pattern - 확정
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePatternConfirm.do")
	public @ResponseBody Map<String, String> savePatternConfirmAction(CommandMap commandMap) throws Exception {
		return paintPatternService.savePatternConfirm(commandMap);

	}

	/**
	 * @메소드명 : savePatternUndefineAction
	 * @날짜 : 2015. 12. 7.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Pattern - 확정해제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePatternUndefine.do")
	public @ResponseBody Map<String, String> savePatternUndefineAction(CommandMap commandMap) throws Exception {
		return paintPatternService.savePatternUndefine(commandMap);

	}

	/**
	 * @메소드명 : searchPaintSeasonCodeListAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint 동하절기 코드 (S/W) 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintSeasonCodeList.do")
	public ModelAndView searchPaintSeasonCodeListAction(CommandMap commandMap) {
		ModelAndView mav = paintPatternService.searchPaintSeasonCodeList(commandMap);
		mav.setViewName("paint/" + "selectBoxList");
		return mav;
	}

	/**
	 * @메소드명 : paintPatternEditAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 신규, 수정 버튼 선택 시 Pattern 생성 및 수정 팝업화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPatternEdit.do")
	public ModelAndView paintPatternEditAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.addAllObjects(commandMap.getMap());
		mav.setViewName("paint/" + "paintPatternEdit");
		return mav;
	}

	/**
	 * @메소드명 : searchPatternPaintItemAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 연계된 Paint Item 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPatternPaintItem.do")
	public @ResponseBody Map<String, Object> searchPatternPaintItemAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : searchPatternPaintAreaAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 연계된 Area Code 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPatternPaintArea.do")
	public @ResponseBody Map<String, Object> searchPatternPaintAreaAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : searchAreaCodeFromBlockAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 연계 가능한 Area Code 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchAreaCodeFromBlock.do")
	public @ResponseBody Map<String, Object> searchAreaCodeFromBlockAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : searchLossCodeSetNameAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Loss Code의 Set 정보 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchLossCodeSetName.do")
	public @ResponseBody Map<String, Object> searchLossCodeSetNameAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : searchCopyItemListFromPatternAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - 복사 버튼 클릭 시 복사 대상 Pattern의 연계된 Item 목록 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchCopyItemListFromPattern.do")
	public @ResponseBody Map<String, Object> searchCopyItemListFromPatternAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popupAreaCodeFromBlockAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 Area 연계 그리드 - 연계 가능한 Area 목록 조회 팝업 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupAreaCodeFromBlock.do")
	public ModelAndView popupAreaCodeFromBlockAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("paint/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : selectPaintPlanProjectNoAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 Area 연계 그리드 - 연계 가능한 Area 목록 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintAreaCodeListFromBlock.do")
	public @ResponseBody Map<String, Object> selectPaintPlanProjectNoAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : popupStageCodeAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 Paint Item 연계 그리드 - STAGE 조회 팝업 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupStageCode.do")
	public ModelAndView popupStageCodeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("paint/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : selectPaintStageCodeListAction
	 * @날짜 : 2015. 12. 5.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 생성 및 수정 팝업화면 - Pattern에 Paint Item 연계 그리드 - STAGE 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintStageCodeList.do")
	public @ResponseBody Map<String, Object> selectPaintStageCodeListAction(CommandMap commandMap) {
		return paintPatternService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : patternExcelExport
	 * @날짜 : 2015. 12. 9.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Pattern 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "patternExcelExport.do")
	public View patternExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintPatternService.patternExcelExport(commandMap, modelMap);
	}

}

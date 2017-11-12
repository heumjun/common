package stxship.dis.paint.outfitting.controller;

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
import stxship.dis.paint.outfitting.service.OutfittingService;

/**
 * @파일명 : OutfittingController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Outfitting의 컨트롤러
 *     </pre>
 */
@Controller
public class OutfittingController extends CommonController {
	@Resource(name = "outfittingService")
	private OutfittingService outfittingService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintOutfitting.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		// Paint Team 리스트를 취득
		mav.addObject("teamList", outfittingService.getDbDataList(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : infoOutfittingTeam
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting Paint Team별 TAB 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintOutfittingTab.do")
	public ModelAndView infoOutfittingTeam(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + commandMap.get(DisConstants.JSP_NAME));
		// Paint Team 별 구분 리스트를 취득
		mav.addObject("gbnList", outfittingService.getDbDataList(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : infoOutfittingItemGroupListAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting 화면의 하단 OutfittingItemGroup리스트를 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoOutfittingItemGroupList.do")
	public @ResponseBody Map<String, Object> infoOutfittingItemGroupListAction(CommandMap commandMap) {
		return outfittingService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : selectOutfittingListAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 선택된 팀별 구분을 선택했을때의 해당하는 쿼리를 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectOutfittingList.do")
	public @ResponseBody Map<String, Object> selectOutfittingListAction(CommandMap commandMap) {
		return outfittingService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoOutfittingAreaAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 하단의 면적 값을 가져오는 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoOutfittingArea.do")
	public @ResponseBody Map<String, Object> infoOutfittingAreaAction(CommandMap commandMap) {
		return outfittingService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : saveOutfittingAreaAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 입력된 하단의 면적 값을 저장하는 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveOutfittingArea.do")
	public @ResponseBody Map<String, String> saveOutfittingAreaAction(CommandMap commandMap) throws Exception {
		return outfittingService.saveOutfittingArea(commandMap);
	}

	/**
	 * @메소드명 : saveAddOutfittingAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 선택된 구분을 추가하는 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveAddOutfitting.do")
	public @ResponseBody Map<String, String> saveAddOutfittingAction(CommandMap commandMap) throws Exception {
		return outfittingService.saveAddOutfitting(commandMap);
	}

	/**
	 * @메소드명 : saveMinusOutfittingAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Paint Team별 TAB화면에서 선택된 구분을 삭제하는 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveMinusOutfitting.do")
	public @ResponseBody Map<String, String> saveMinusOutfittingAction(CommandMap commandMap) throws Exception {
		return outfittingService.saveMinusOutfitting(commandMap);
	}

	/**
	 * @메소드명 : outfittingExcelExportAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting의 Excel을 출력하는 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "outfittingExcelExport.do")
	public View outfittingExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return outfittingService.outfittingExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : infoOutfittingItemGroupDetailAction
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Outfitting 상세 데이터 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoOutfittingItemGroupDetail.do")
	public @ResponseBody Map<String, Object> infoOutfittingItemGroupDetailAction(CommandMap commandMap) {
		return outfittingService.getGridListNoPaging(commandMap);
	}

}

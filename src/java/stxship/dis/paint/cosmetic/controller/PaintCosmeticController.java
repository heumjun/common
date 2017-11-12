package stxship.dis.paint.cosmetic.controller;

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
import stxship.dis.paint.cosmetic.service.PaintCosmeticService;

/**
 * @파일명 : PaintCosmeticController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint Cosmetic 컨트롤러
 *     </pre>
 */
@Controller
public class PaintCosmeticController extends CommonController {
	@Resource(name = "paintCosmeticService")
	private PaintCosmeticService paintCosmeticService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Cosmetic 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintCosmetic.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		// Paint Team 리스트를 취득
		mav.addObject("teamList", paintCosmeticService.getDbDataList(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : infoCosmeticTeam
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Cosmetic Tab 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintCosmeticTab.do")
	public ModelAndView infoCosmeticTeam(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + commandMap.get(DisConstants.JSP_NAME));
		// Paint Team 별 구분 리스트를 취득
		mav.addObject("gbnList", paintCosmeticService.getDbDataList(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : infoCosmeticItemGroupListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Cosmetic ItemGroupList취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCosmeticItemGroupList.do")
	public @ResponseBody Map<String, Object> infoCosmeticItemGroupListAction(CommandMap commandMap) {
		return paintCosmeticService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : selectCosmeticListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택 팀별 Cosmetic을 선택하면 해당하는 SQL로 리스트를 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectCosmeticList.do")
	public @ResponseBody Map<String, Object> selectCosmeticListAction(CommandMap commandMap) {
		return paintCosmeticService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectCosmeticAreaAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 팀별 Cosmetic Area정보를 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCosmeticArea.do")
	public @ResponseBody Map<String, Object> selectCosmeticAreaAction(CommandMap commandMap) {
		return paintCosmeticService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : saveCosmeticAreaAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 입력된 Cosmetic Area정보를 저장한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveCosmeticArea.do")
	public @ResponseBody Map<String, String> saveCosmeticAreaAction(CommandMap commandMap) throws Exception {
		return paintCosmeticService.saveCosmeticArea(commandMap);
	}

	/**
	 * @메소드명 : saveAddCosmeticAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택된 Cosmetic에서 [+]버튼을 선택했을때 Cosmetic 정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveAddCosmetic.do")
	public @ResponseBody Map<String, String> saveAddCosmeticAction(CommandMap commandMap) throws Exception {
		return paintCosmeticService.saveAddCosmetic(commandMap);
	}

	/**
	 * @메소드명 : saveMinusCosmeticAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택된 Cosmetic에서 [-]버튼을 선택했을때 Cosmetic 정보를 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveMinusCosmetic.do")
	public @ResponseBody Map<String, String> saveMinusCosmeticAction(CommandMap commandMap) throws Exception {
		return paintCosmeticService.saveMinusCosmetic(commandMap);
	}

	/**
	 * @메소드명 : cosmeticExcelExport
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * cosmetic정보를 엑셀로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "cosmeticExcelExport.do")
	public View cosmeticExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintCosmeticService.cosmeticExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : infoCosmeticItemGroupDetailAction
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * cosmetic 상세정보취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCosmeticItemGroupDetail.do")
	public @ResponseBody Map<String, Object> infoCosmeticItemGroupDetailAction(CommandMap commandMap) {
		return paintCosmeticService.getGridListNoPaging(commandMap);
	}
}

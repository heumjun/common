package stxship.dis.paint.usc.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.usc.service.PaintUscService;

/**
 * @파일명 : PaintUscController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 22.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Paint USC 컨트롤러
 *     </pre>
 */
@Controller
public class PaintUscController extends CommonController {
	@Resource(name = "paintUscService")
	private PaintUscService paintUscService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * paint USC 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintUsc.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * paint USC 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPaintUscList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return paintUscService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : insertPaintWbsReCreateAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  USC화면에서 WBS분리를 선택했을때의 엑션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "insertPaintWbsReCreate.do")
	public @ResponseBody Map<String, String> insertPaintWbsReCreateAction(CommandMap commandMap) throws Exception {
		return paintUscService.insertPaintWbsReCreate(commandMap);
	}

	/**
	 * @메소드명 : popUpPaintJobEditAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPaintJobEdit.do")
	public ModelAndView popUpPaintJobEditAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : infoPaintJobEditListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면의 JOB리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPaintJobEditList.do")
	public @ResponseBody Map<String, Object> infoPaintJobEditListAction(CommandMap commandMap) {
		return paintUscService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : deletePaintUscAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면에서 선택된 JOB의 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deletePaintUsc.do")
	public @ResponseBody Map<String, String> deletePaintUscAction(CommandMap commandMap) throws Exception {
		return paintUscService.deletePaintUsc(commandMap);
	}

	/**
	 * @메소드명 : savePaintUscJobItemCreateAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면에서 추가된 품목의 채번
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintUscJobItemCreate.do")
	public @ResponseBody Map<String, String> savePaintUscJobItemCreateAction(CommandMap commandMap) throws Exception {
		return paintUscService.savePaintUscJobItemCreate(commandMap);
	}

	/**
	 * @메소드명 : savePaintUscBomAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면에서 BOM 및 ECO연계를 선택했을때
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintUscBom.do")
	public @ResponseBody Map<String, String> savePaintUscBomAction(CommandMap commandMap) throws Exception {
		return paintUscService.savePaintUscBom(commandMap);
	}

	/**
	 * @메소드명 : popUpPaintCountCatalogSearchAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *  JOB편집 화면에서 추가된 품목의 자 Catalog를 선택하는 화면 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPaintCountCatalogSearch.do")
	public ModelAndView popUpPaintCountCatalogSearchAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : infoPaintCountCatalogCodeListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * JOB편집 화면에서 추가된 품목의 자 Catalog의 정보리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPaintCountCatalogCodeList.do")
	public @ResponseBody Map<String, Object> infoPaintCountCatalogCodeListAction(CommandMap commandMap) {
		return paintUscService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : savePaintWbsEcoAddAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO추가 버튼을 선택했을때 선택된 ECO를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintWbsEcoAdd.do")
	public @ResponseBody Map<String, String> savePaintWbsEcoAddAction(CommandMap commandMap) throws Exception {
		return paintUscService.savePaintWbsEcoAdd(commandMap);
	}

}

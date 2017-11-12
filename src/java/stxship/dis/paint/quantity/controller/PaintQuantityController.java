package stxship.dis.paint.quantity.controller;

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
import stxship.dis.paint.quantity.service.PaintQuantityService;

/** 
 * @파일명	: PaintQuantityController.java 
 * @프로젝트	: DIS
 * @날짜		: 2015. 12. 10. 
 * @작성자	: 강선중 
 * @설명
 * <pre>
 * Paint Quantity 컨트롤러
 * </pre>
 */
@Controller
public class PaintQuantityController extends CommonController {
	@Resource(name = "paintQuantityService")
	private PaintQuantityService paintQuantityService;
	
	/** 
	 * @메소드명	: linkSelectedMenu
	 * @날짜		: 2015. 12. 10.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Quantity 모듈로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintQuantity.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	
	/** 
	 * @메소드명	: paintAllQuantityAction
	 * @날짜		: 2015. 12. 15.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Quantity 조회 tab 화면 호출
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAllQuantity.do")
	public ModelAndView paintAllQuantityAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("paint/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());		
		return mav;
	}
	
	/** 
	 * @메소드명	: searchPaintAllQuantityAction
	 * @날짜		: 2015. 12. 15.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Quantity 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintAllQuantity.do")
	public @ResponseBody Map<String, Object> searchPaintAllQuantityAction(CommandMap commandMap) {
		return paintQuantityService.getGridList(commandMap);
	}	
	
	/** 
	 * @메소드명	: paintEditQuantityAction
	 * @날짜		: 2015. 12. 15.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Paint Quantity 수정사항 조회 tab2 호출 (미구현)
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintEditQuantity.do")
	public ModelAndView paintEditQuantityAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("paint/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());		
		return mav;
	}

	
	/** 
	 * @메소드명	: popupQuantityBlockCodeAction
	 * @날짜		: 2015. 12. 10.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 메인에서 조회 클릭 시(Block선택) 조회할 Block 리스트 선택창으로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupQuantityBlockCode.do")	
	public ModelAndView popupQuantityBlockCodeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("paint/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}	
	
	/** 
	 * @메소드명	: selectPaintQuantityBlockCodeListAction
	 * @날짜		: 2015. 12. 10.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 조회 팝업 - BLOCK 리스트 추출
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintQuantityBlockCodeList.do")
	public @ResponseBody Map<String, Object> selectPaintQuantityBlockCodeListAction(CommandMap commandMap) {
		return paintQuantityService.getGridListNoPaging(commandMap);
	}
	
	/** 
	 * @메소드명	: popupQuantityAreaCodeAction
	 * @날짜		: 2015. 12. 10.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 메인에서 조회 클릭 시(Area선택) 조회할 Area 리스트 선택창으로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupQuantityAreaCode.do")	
	public ModelAndView popupQuantityAreaCodeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("paint/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}	
	
	/** 
	 * @메소드명	: selectPaintQuantityAreaCodeListAction
	 * @날짜		: 2015. 12. 10.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 조회 팝업 - Area 리스트 추출
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintQuantityAreaCodeList.do")
	public @ResponseBody Map<String, Object> selectPaintQuantityAreaCodeListAction(CommandMap commandMap) {
		return paintQuantityService.getGridListNoPaging(commandMap);
	}		
	
	
	/** 
	 * @메소드명	: savePaintQuantityAction
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 확정
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintQuantity.do")
	public @ResponseBody Map<String, String> savePaintQuantityAction(CommandMap commandMap) throws Exception {		
		return paintQuantityService.savePaintQuantity(commandMap);
		
	}	
	
	/** 
	 * @메소드명	: undefinePaintQuantityAction
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 확정 해제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "undefinePaintQuantity.do")
	public @ResponseBody Map<String, String> undefinePaintQuantityAction(CommandMap commandMap) throws Exception {		
		return paintQuantityService.undefinePaintQuantity(commandMap);
		
	}
	
	
	/** 
	 * @메소드명	: savePaintQuantityTransferAction
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity PE 물량 이관
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintQuantityTransfer.do")
	public @ResponseBody Map<String, String> savePaintQuantityTransferAction(CommandMap commandMap) throws Exception {		
		return paintQuantityService.savePaintQuantityTransfer(commandMap);
		
	}		
	
	/** 
	 * @메소드명	: allQuantityExcelExport
	 * @날짜		: 2015. 12. 17.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity 엑셀 Export
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "allQuantityExcelExport.do")
	public View allQuantityExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintQuantityService.allQuantityExcelExport(commandMap, modelMap);
	}
	
	
	/** 
	 * @메소드명	: savePaintQuantityTransferAction
	 * @날짜		: 2016. 03. 18.
	 * @작성자	: 강선중
	 * @설명		: 
	 * <pre>
	 * Quantity PE 물량 자동 이관
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintQuantityAutoTransfer.do")
	public @ResponseBody Map<String, String> savePaintQuantityAutoTransferAction(CommandMap commandMap) throws Exception {		
		return paintQuantityService.savePaintQuantityAutoTransfer(commandMap);
		
	}	
	
	
	
}

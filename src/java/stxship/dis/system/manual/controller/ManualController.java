package stxship.dis.system.manual.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.system.manual.service.ManualService;

@Controller
public class ManualController extends CommonController {
	@Resource(name = "manualService")
	private ManualService manualService;

	@RequestMapping(value = "manual.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : manualList
	 * @날짜 : 2017. 01. 13.
	 * @작성자 : Cho heumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *	메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "manualList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return manualService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : manualDetailList
	 * @날짜 : 2017. 01. 13.
	 * @작성자 : Cho heumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *	메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "manualDetailList.do")
	public @ResponseBody Map<String, Object> manualDetailList(CommandMap commandMap) {
		return manualService.getGridList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: manualFileView
	 * @날짜 : 2017. 01. 13.
	 * @작성자 : Cho heumjun
	 * @설명		: 
	 * <pre>
	 * 파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "manualFileView.do", method=RequestMethod.GET, produces="application/text; charset=utf8")
	public View manualFileView(CommandMap commandMap, Map<String, Object> modelMap, @RequestParam("p_pgm_id") String p_pgm_id, @RequestParam("p_revision_no") String p_revision_no) throws Exception {

		return manualService.manualFileDownload(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : stxEPInfoDocumentAdd
	 * @날짜 : 2017. 01. 13.
	 * @작성자 : Cho heumjun
	 * @설명 :
	 * 
	 *     <pre>
	 * Document 추가 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpManualAttachAdd.do")
	public ModelAndView popUpManualAttachAdd(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/system/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : stxEPInfoDocumentAddSave
	 * @날짜 : 2016. 8. 31.
	 * @작성자 : 정재동
	 * @설명 :
	 * 
	 *     <pre>
	 * Document 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "manualAddSave.do")
	public @ResponseBody Map<String, Object> manualAddSave(HttpServletResponse response,
			HttpServletRequest request, CommandMap commandMap) throws Exception {
		return manualService.manualAddSave(response, request, commandMap);
	}
	
	@RequestMapping(value = "saveManual.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return manualService.saveManualGridList(commandMap);
	}
	
	/**
	 * @메소드명 : manualList
	 * @날짜 : 2017. 01. 13.
	 * @작성자 : Cho heumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *	메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "manualEtcList.do")
	public @ResponseBody Map<String, Object> manualEtcList(CommandMap commandMap) {
		return manualService.getGridList(commandMap);
	}
	
	@RequestMapping(value = "manualFileDelete.do")
	public @ResponseBody Map<String, String> manualFileDelete(CommandMap commandMap) throws Exception {
		return manualService.manualFileDelete(commandMap);
	}
	
}

package stxship.dis.etc.documentView.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.etc.documentView.service.DocumentViewService;

/**
 * @파일명 : DocumentViewController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 정재동
 * @설명
 * 
 *     <pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class DocumentViewController extends CommonController {
	@Resource(name = "documentViewService")
	private DocumentViewService documentViewService;
	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 8. 31.
	 * @작성자 : 정재동
	 * @설명 :
	 * 
	 *     <pre>
	 * DocumentView 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "documentView.do")
	public ModelAndView documentViewAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		//List<Map<String, Object>> list = documentViewService.selectDocumentView(commandMap);
		//mav.addObject("list", list);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : stxEPInfoDocumentAdd
	 * @날짜 : 2016. 8. 31.
	 * @작성자 : 정재동
	 * @설명 :
	 * 
	 *     <pre>
	 * Document 추가 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpDocumentAdd.do")
	public ModelAndView stxEPInfoDocumentAdd(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/etc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : stxEPInfoDocumentDelete
	 * @날짜 : 2016. 8. 31.
	 * @작성자 : 정재동
	 * @설명 :
	 * 
	 *     <pre>
	 * Document 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "documentDelete.do")
	public @ResponseBody Map<String, Object> documentDelete(HttpServletResponse response,
			HttpServletRequest request, CommandMap commandMap) throws Exception {
		return documentViewService.documentDelete(response, request, commandMap);
	}
//	@RequestMapping(value = "documentDelete.do")
//	public ModelAndView stxEPInfoDocumentDelete(CommandMap commandMap) {
//		ModelAndView mav = getUserRoleAndLink(commandMap);
//		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
//		return mav;
//	}

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
	@RequestMapping(value = "documentAddSave.do")
	public @ResponseBody Map<String, Object> documentAddSave(HttpServletResponse response,
			HttpServletRequest request, CommandMap commandMap) throws Exception {
		return documentViewService.documentAddSave(response, request, commandMap);
	}



	
	/**
	 * 
	 * @메소드명	: documentFileView
	 * @날짜		: 2016. 8. 31.
	 * @작성자	: 정재동
	 * @설명		: 
	 * <pre>
	 * 파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "documentFileView.do")
	public View documentFileView(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return documentViewService.documentFileDownload(commandMap, modelMap);
	}

}

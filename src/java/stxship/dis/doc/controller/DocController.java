package stxship.dis.doc.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.doc.service.DocService;

/**
 * @파일명 : DocController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *     doc컨터롤러
 *     </pre>
 */
@Controller
public class DocController extends CommonController {
	@Resource(name = "docService")
	private DocService docService;

	/**
	 * @메소드명 : ecrDoc
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Doc화면으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "doc.do")
	public ModelAndView docAction(CommandMap commandMap) {
		return new ModelAndView(DisConstants.DOC + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : ecoListAction
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "docList.do")
	public @ResponseBody Map<String, Object> ecoListAction(CommandMap commandMap) {
		return docService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpDocAddAction
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC 추가 팝업 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpDocAdd.do")
	public ModelAndView popUpDocAddAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				(DisConstants.DOC + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME)));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : saveDocAction
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC 저장
	 *     </pre>
	 * 
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveDoc.do")
	public @ResponseBody String saveDocAction(HttpServletRequest request, CommandMap commandMap)
			throws Exception {
		return docService.saveDoc(request, commandMap);
	}

	/**
	 * @메소드명 : delDocAction
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC 삭제
	 *     </pre>
	 * 
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "delDoc.do")
	public @ResponseBody Map<String, String> delDocAction(HttpServletRequest request, CommandMap commandMap)
			throws Exception {
		return docService.delDoc(request, commandMap);
	}

	/**
	 * @메소드명 : docDownloadFile
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC 파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "docDownloadFile.do")
	public View docDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return docService.docDownloadFile(commandMap, modelMap);
	}
}

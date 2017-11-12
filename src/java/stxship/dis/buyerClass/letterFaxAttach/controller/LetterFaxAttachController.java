package stxship.dis.buyerClass.letterFaxAttach.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.buyerClass.letterFaxAttach.service.LetterFaxAttachService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : LetterFaxAttachController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxAttach의 컨트롤러
 *     </pre>
 */
@Controller
public class LetterFaxAttachController extends CommonController {
	@Resource(name = "letterFaxAttachService")
	private LetterFaxAttachService letterFaxAttachService;

	/**
	 * @메소드명 : letterFaxAttach
	 * @날짜 : 2016. 06. 15.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LetterFaxAttach 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxAttach.do")
	public ModelAndView buyerClassLetterFaxAttach(CommandMap commandMap) {
		Map<String,String> dpsUserInfo = letterFaxAttachService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
			if(dpsUserInfo.get("adminYN").equals("Y")) {
				ModelAndView mv = new ModelAndView("/buyerClass/letterFaxAttach" + commandMap.get(DisConstants.JSP_NAME));
				// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
				mv.addAllObjects(commandMap.getMap());
				mv.addObject("dpsUserInfo", dpsUserInfo);
				return mv;
			} else {
				return new ModelAndView("/common/stxPECDP_LoginFailed2");	
			}
		}
	}
	@RequestMapping(value = "buyerClassLetterFaxAttachFileUpload.do")
	public ModelAndView buyerClassLetterFaxAttachFileUpload(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxAttach" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	
	@RequestMapping(value = "buyerClassLetterFaxAttachFileToFTP.do")
	public ModelAndView buyerClassLetterFaxAttachFileToFTP(CommandMap commandMap, HttpServletRequest request)
			throws Exception {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxAttach" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(letterFaxAttachService.buyerClassLetterFaxAttachFileToFTP(commandMap, request));
		return mv;
	}
}

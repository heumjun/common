package stxship.dis.buyerClass.letterFaxMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.buyerClass.letterFaxMgnt.service.LetterFaxMgntService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : LetterFaxMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxMgnt의 컨트롤러
 *     </pre>
 */
@Controller
public class LetterFaxMgntController extends CommonController {
	@Resource(name = "letterFaxMgntService")
	private LetterFaxMgntService letterFaxMgntService;

	/**
	 * @메소드명 : letterFaxMgnt
	 * @날짜 : 2016. 06. 15.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LetterFaxMgnt 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxMgnt.do")
	public ModelAndView buyerClassLetterFaxMgnt(CommandMap commandMap) {
		Map<String,String> dpsUserInfo = letterFaxMgntService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
				ModelAndView mv = new ModelAndView("/buyerClass/letterFaxMgnt" + commandMap.get(DisConstants.JSP_NAME));
				// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
				mv.addAllObjects(commandMap.getMap());
				mv.addObject("dpsUserInfo", dpsUserInfo);
				return mv;
		}
	}
	
	
	/** 
	 * @메소드명	: buyerClassLetterFaxDocumentDeleteProcess
	 * @날짜		: 2016. 6. 27.
	 * @작성자	: 황경호
	 * @설명		: 
	 * <pre>
	 * 공문 / 첨부파일이 삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassLetterFaxDocumentDeleteProcess.do")
	public @ResponseBody Map<String, String> buyerClassLetterFaxDocumentDeleteProcess(CommandMap commandMap)
			throws Exception {
		return letterFaxMgntService.buyerClassLetterFaxDocumentDeleteProcess(commandMap);
	}
}

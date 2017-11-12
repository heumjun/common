package stxship.dis.buyerClass.letterFaxReceive.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.buyerClass.letterFaxReceive.service.LetterFaxReceiveService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : LetterFaxReceiveController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxReceive의 컨트롤러
 *     </pre>
 */
@Controller
public class LetterFaxReceiveController extends CommonController {
	@Resource(name = "letterFaxReceiveService")
	private LetterFaxReceiveService letterFaxReceiveService;

	/**
	 * @메소드명 : letterFaxReceive
	 * @날짜 : 2016. 06. 15.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LetterFaxReceive 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxReceive.do")
	public ModelAndView buyerClassLetterFaxReceive(CommandMap commandMap) {
		Map<String,String> dpsUserInfo = letterFaxReceiveService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
			if(dpsUserInfo.get("adminYN").equals("Y")) {
				ModelAndView mv = new ModelAndView("/buyerClass/letterFaxReceive" + commandMap.get(DisConstants.JSP_NAME));
				// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
				mv.addAllObjects(commandMap.getMap());
				mv.addObject("dpsUserInfo", dpsUserInfo);
				return mv;
			} else {
				return new ModelAndView("/common/stxPECDP_LoginFailed2");	
			}
		}
	}
	
	@RequestMapping(value = "buyerClassLetterFaxReceiveExcelUpload.do")
	public ModelAndView buyerClassLetterFaxReceiveExcelUpload(CommandMap commandMap) {
		Map<String,String> dpsUserInfo = letterFaxReceiveService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
			if(dpsUserInfo.get("adminYN").equals("Y")) {
				ModelAndView mv = new ModelAndView("/buyerClass/letterFaxReceive/stxPECBuyerClassLetterFaxReceiveManagerExcelUploadDialogFS");
				// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
				mv.addAllObjects(commandMap.getMap());
				mv.addObject("dpsUserInfo", dpsUserInfo);
				return mv;
			} else {
				return new ModelAndView("/common/stxPECDP_LoginFailed2");	
			}
		}
	}
	@RequestMapping(value = "stxPECBuyerClassLetterFaxReceiveManagerExcelUploadDialog.do")
	public ModelAndView stxPECBuyerClassLetterFaxReceiveManagerExcelUploadDialog(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxReceive/stxPECBuyerClassLetterFaxReceiveManagerExcelUploadDialog");
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	@RequestMapping(value = "b.do")
	public ModelAndView b(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/letterFaxReceive/b");
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	
	
}
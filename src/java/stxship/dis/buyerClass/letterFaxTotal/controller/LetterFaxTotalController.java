package stxship.dis.buyerClass.letterFaxTotal.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.buyerClass.letterFaxTotal.service.LetterFaxTotalService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : LetterFaxTotalController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * LetterFaxTotal의 컨트롤러
 *     </pre>
 */
@Controller
public class LetterFaxTotalController extends CommonController {
	@Resource(name = "letterFaxTotalService")
	private LetterFaxTotalService letterFaxTotalService;

	/**
	 * @메소드명 : letterFaxTotal
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LetterFaxTotal 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassLetterFaxTotalSearch.do")
	public ModelAndView buyerClassLetterFaxTotal(CommandMap commandMap) {
		
		Map<String,String> dpsUserInfo = letterFaxTotalService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
			ModelAndView mv = new ModelAndView("/buyerClass/letterFaxTotal" + commandMap.get(DisConstants.JSP_NAME));
			// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
			mv.addAllObjects(commandMap.getMap());
			mv.addObject("dpsUserInfo", dpsUserInfo);
			return mv;
		}
	}


}

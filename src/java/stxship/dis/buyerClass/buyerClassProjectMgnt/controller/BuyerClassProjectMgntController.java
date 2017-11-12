package stxship.dis.buyerClass.buyerClassProjectMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.buyerClass.buyerClassProjectMgnt.service.BuyerClassProjectMgntService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : BuyerClassProjectMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * BuyerClassProjectMgnt의 컨트롤러
 *     </pre>
 */
@Controller
public class BuyerClassProjectMgntController extends CommonController {
	@Resource(name = "buyerClassProjectMgntService")
	private BuyerClassProjectMgntService buyerClassProjectMgntService;

	/**
	 * @메소드명 : buyerClassProjectMgnt
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BuyerClassProjectMgnt 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassProjectMgnt.do")
	public ModelAndView buyerClassBuyerClassProjectMgnt(CommandMap commandMap) {
		
		Map<String,String> dpsUserInfo = buyerClassProjectMgntService.getDpsUserInfo(commandMap);
		if(dpsUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		} else {
			if(dpsUserInfo.get("adminYN").equals("Y")) {
				ModelAndView mv = new ModelAndView("/buyerClass/projectMgnt" + commandMap.get(DisConstants.JSP_NAME));
				// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
				mv.addAllObjects(commandMap.getMap());
				mv.addObject("dpsUserInfo", dpsUserInfo);
				return mv;
			} else {
				return new ModelAndView("/common/stxPECDP_LoginFailed2");	
			}
		}
	}

	/**
	 * @메소드명 : buyerClassProjectMgntBody
	 * @날짜 : 2016. 7. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 호선 관리 리스트 출력 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "buyerClassProjectMgntBody.do")
	public ModelAndView buyerClassProjectMgntBody(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/buyerClass/projectMgnt" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		// 권한정보
		return mv;
	}

	/**
	 * @메소드명 : buyerClassProjectMgntProcess
	 * @날짜 : 2016. 7. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 호선 관리 정보 저장 프로세스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassProjectMgntProcess.do")
	public @ResponseBody Map<String, String> buyerClassProjectMgntProcess(CommandMap commandMap) throws Exception {
		return buyerClassProjectMgntService.buyerClassProjectMgntProcess(commandMap);
	}

	/**
	 * @메소드명 : buyerClassProjectUpdateProcess
	 * @날짜 : 2016. 7. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 호선 관리 업데이트 프로세스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "buyerClassProjectUpdateProcess.do")
	public @ResponseBody Map<String, String> buyerClassProjectUpdateProcess(CommandMap commandMap) throws Exception {
		return buyerClassProjectMgntService.buyerClassProjectUpdateProcess(commandMap);
	}

}

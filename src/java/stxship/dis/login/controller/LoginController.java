package stxship.dis.login.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.login.service.LoginService;

/**
 * @파일명 : LoginAction.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 17.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  로그인 컨트롤러
 *     </pre>
 */
@Controller
public class LoginController extends CommonController {
	@Resource(name = "loginService")
	private LoginService loginService;

	/**
	 * @메소드명 : login
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 로그인 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "disLogin.do")
	public ModelAndView login(CommandMap commandMap) throws Exception {
		return new ModelAndView(DisConstants.LOGIN_LINK);
	}
	/**
	 * @메소드명 : loginCheck
	 * @날짜 : 2015. 11. 17.
	 * @작성자 : 황경호
	 * @설명 :
	
	 * 
	 *     <pre>
	 * 로그인 체크 : 유저인경우 메인페이지 이동 유저가 아닌경우 에러 메시지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "loginCheck.do")
	public ModelAndView loginCheck(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mav = new ModelAndView();
		if (loginService.isUser(commandMap)) {
			mav.addObject("loginID",commandMap.get("loginID"));
			mav.addObject(DisConstants.VIEW_PARENT_URL, DisConstants.MENU_URL);
			mav.addObject("popupList", loginService.popupList(commandMap));
			mav.setViewName(DisConstants.MENU_URL + DisConstants.JSP_MAINFRAME);
		} else {
			mav.addObject("errMessage", "로그인 정보가 틀립니다. 확인후 다시 시도해 주세요.");
			mav.setViewName(DisConstants.LOGIN_LINK);
		}
		return mav;
	}
	
	/**
	 * @메소드명 : disLogout
	 * @날짜 : 2015. 11. 17.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "disLogout.do")
	public ModelAndView disLogout(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.getSession().setAttribute(DisConstants.SESSION_LOGIN_USER_OBJ, null);
		return new ModelAndView(DisConstants.LOGIN_LINK);
	}
}

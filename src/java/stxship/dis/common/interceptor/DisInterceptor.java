package stxship.dis.common.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisCodeUtil;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.login.dao.LoginDAO;

/**
 * @파일명 : DisInterceptor.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 처리 로그를 남기기 위한 인터셉터
 *     </pre>
 */
public class DisInterceptor extends HandlerInterceptorAdapter {
	protected Log log = LogFactory.getLog(DisInterceptor.class);

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		if (log.isDebugEnabled()) {
			log.debug(
					"======================================          START         ======================================");
			log.debug(" Request URI \t:  " + request.getRequestURI());
		}
		/*
		 * 세션 체크 로직 1. SESSION_LOGIN_USER_OBJ가 없으면 로그인 화면으로 보냄.
		 */
		if (!request.getRequestURI().equals("/") && !request.getRequestURI().equals("/disLogin.do")) {
		//if (false) {
			HttpSession session = request.getSession();

			if ((session.getAttribute(DisConstants.SESSION_LOGIN_USER_OBJ) == null) || (session.getAttribute(DisConstants.SESSION_LOGIN_USER_OBJ).toString().equals(""))) {
				if (request.getParameter("adminid") == null && request.getParameter("loginID") == null && request.getParameter("plmLoginID") == null) {
					
					if(!"/manualFileView.do".equals(request.getRequestURI())){
						response.sendRedirect(request.getContextPath() + "/");
						return true;	
					}
					
				}else{
					//로그인페이지가 아니면 실행
					//파라미터로 자동 로그인 세션 생성
					//loginID로 넘겨준다.
					//EP에서 받을경우 해당 경로로 바로 이동
					if(!request.getRequestURI().equals("/loginCheck.do")){
						CommandMap commandMap = new CommandMap();
						commandMap.put("plmLoginID", DisCodeUtil.decrypt(request.getParameter("plmLoginID")));
//						
						Object loginUser = loginDAO.selectLogin(commandMap.getMap());
						if (loginUser != null) {
							// 유저정보가 있는경우 유저정보를 세션에 설정
							DisSessionUtil.setLoginUserObject(loginUser);
						}else{
							System.out.println(request.getRequestURI());
							response.sendRedirect(request.getContextPath() + "/");
							return false;
						}
					}
				}
			}
		}
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug(
					"======================================           END          ======================================\n");
		}
	}
}

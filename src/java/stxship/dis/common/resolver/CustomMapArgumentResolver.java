package stxship.dis.common.resolver;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.interceptor.DisInterceptor;
import stxship.dis.common.util.DisSessionUtil;

/**
 * @파일명 : CustomMapArgumentResolver.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 리졸버 클래스
 *     </pre>
 */
public class CustomMapArgumentResolver implements HandlerMethodArgumentResolver {
	protected Log log = LogFactory.getLog(DisInterceptor.class);

	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		return CommandMap.class.isAssignableFrom(parameter.getParameterType());
	}

	/**
	 * @메소드명 : resolveArgument
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param parameter
	 * @param mavContainer
	 * @param webRequest
	 * @param binderFactory
	 * @return
	 * @throws Exception
	 */
	@Override
	public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
			NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {

		CommandMap commandMap = new CommandMap();
		HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
		request.setCharacterEncoding("utf-8");
		Enumeration<?> enumeration = request.getParameterNames();

		// 모든 파라미터를 commandMap에 담는다.
		String key = null;
		String[] values = null;
		while (enumeration.hasMoreElements()) {
			key = (String) enumeration.nextElement();
			values = request.getParameterValues(key);
			if (values != null) {
				commandMap.put(key, (values.length > 1) ? values : values[0]);
			}
		}
		for (String key2 : commandMap.keySet()) {
			log.debug(" CommandMap Data \t:  " + key2 + " = " + commandMap.get(key2));
		}
		// 로그인되어 있는 유저아이디를 취득하여 CommandMap에 설정한다.
		// SET_DB_LOGIN_ID : [loginId] 는 사용자 설정에서 자주 사용되므로 주의
		commandMap.put(DisConstants.SET_DB_LOGIN_ID, DisSessionUtil.getUserId());

		// NEXT_VIEW_LINK 에 이동할 페이지를 미리 구현한다. 각 로직별로 페이지 이동 설정을 할 필요없음.
		// 단 호출되는 서블릿명령어와 뷰단의JSP파일명은 동일해야함.
		// ex) login.do -> login.jsp
		String jspUrl = request.getServletPath().replaceFirst(DisConstants.SERVLET_TAIL_PATH, "");
		Object parentUrlObj = commandMap.get(DisConstants.VIEW_PARENT_URL);
		String parentUrl = "";
		if (parentUrlObj != null) {
			parentUrl = parentUrlObj.toString();
			DisSessionUtil.setObject(DisConstants.VIEW_PARENT_URL, parentUrl);
		}
		commandMap.put(DisConstants.NEXT_VIEW_LINK, parentUrl + jspUrl);

		// 사용되어질 맵퍼를 미리 설정한다. 로직별로 맵퍼설정을 할 필요없음.
		// 단 호출되는 서블릿명령어와 맵퍼의 네임스페이스(NAMESPASE)는 동일해야함
		// ex)login.do -> namespace="testList"
		String mapperName = jspUrl.replaceFirst(DisConstants.SERVLET_PRE_PATH, "");
		commandMap.put(DisConstants.MAPPER_NAME, mapperName);
		// 페이지이동시 JSP명을 활용한다.
		commandMap.put(DisConstants.JSP_NAME, jspUrl);

		commandMap.put(DisConstants.SERVLET_PATH,
				request.getServletPath().replaceFirst(DisConstants.SERVLET_PRE_PATH, ""));

		return commandMap;
	}
}
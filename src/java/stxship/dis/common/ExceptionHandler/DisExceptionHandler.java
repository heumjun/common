package stxship.dis.common.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : DisExceptionHandler.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DIS에서 사용되는 예외처리 핸들러
 *     </pre>
 */
@ControllerAdvice
public class DisExceptionHandler {

	@Resource(name = "commonService")
	private CommonService commonService;

	/**
	 * @메소드명 : handleDisException
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DisException인 경우 에러메시지 반환
	 *     </pre>
	 * 
	 * @param e
	 * @param request
	 * @return
	 */
	@ExceptionHandler(DisException.class)
	public @ResponseBody Map<String, String> handleDisException(Exception e, HttpServletRequest request) {
		Map<String, String> resut = new HashMap<String, String>();
		resut.put(DisConstants.RESULT_KEY, DisConstants.RESULT_FAIL);
		resut.put(DisConstants.RESULT_MASAGE_KEY, e.getMessage());
		return resut;
	}

	/**
	 * @메소드명 : handleException
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Exception인경우 에러서비스를 실행후 에러메시지 반환
	 *     </pre>
	 * 
	 * @param e
	 * @param request
	 * @return
	 */
	@ExceptionHandler(Exception.class)
	public @ResponseBody Map<String, String> handleException(Exception e, HttpServletRequest request) {
		commonService.errorService(e, request);
		return handleDisException(e, request);
	}

	/**
	 * @메소드명 : handleRuntimeException
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * RuntimeException인경우 에러서비스를 실행후 에러메시지 반환
	 *     </pre>
	 * 
	 * @param e
	 * @param request
	 * @return
	 */
	@ExceptionHandler(RuntimeException.class)
	public @ResponseBody Map<String, String> handleRuntimeException(RuntimeException e, HttpServletRequest request) {
		commonService.errorService(e, request);
		return handleDisException(e, request);
	}
}
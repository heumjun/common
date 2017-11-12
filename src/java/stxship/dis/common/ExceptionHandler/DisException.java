package stxship.dis.common.ExceptionHandler;

import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : DisException.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DIS에서 사용되는 예외처리 클레스
 *     </pre>
 */
public class DisException extends Exception {

	/**
	 * 키값으로 에러메시지를 찾거나 없으면 입력된 문자열이 에러 메시지
	 * 
	 * @param message
	 */
	public DisException(String message) {
		super(DisMessageUtil.getMessage(message));
	}

	/**
	 * 키값으로 에러메시지를 찾거나 없으면 입력된 문자열이 에러 메시지
	 * 
	 * @param message
	 * @param subMsg
	 */
	public DisException(String message, String subMsg) {
		super(DisMessageUtil.getMessage(message, subMsg));
	}

	/**
	 * 키값으로 에러메시지를 찾거나 없으면 입력된 문자열이 에러 메시지
	 * 
	 * @param message
	 * @param subMsg
	 */
	public DisException(String message, Object subMsg[]) {
		super(DisMessageUtil.getMessage(message, subMsg));
	}

	/**
	 * 지정된 메시지가 없을시에는 디폴트 실패 메시지를 지정
	 */
	public DisException() {
		super(DisMessageUtil.getMessage("common.default.fail", ""));
	}

	/** serialVersionUID */
	private static final long serialVersionUID = -6880204166571853388L;

}
package stxship.dis.buyerClass.letterFaxAttach.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : LetterFaxAttachService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * LetterFaxAttach에서 사용되는 서비스
 *     </pre>
 */
public interface LetterFaxAttachService extends CommonService {

	Map<String, String> buyerClassLetterFaxAttachFileToFTP(CommandMap commandMap, HttpServletRequest request) throws Exception;

}

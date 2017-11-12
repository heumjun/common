package stxship.dis.buyerClass.letterFaxMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : LetterFaxMgntService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 06. 15.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * LetterFaxMgnt에서 사용되는 서비스
 *     </pre>
 */
public interface LetterFaxMgntService extends CommonService {

	Map<String, String> buyerClassLetterFaxDocumentDeleteProcess(CommandMap commandMap) throws Exception ;
}

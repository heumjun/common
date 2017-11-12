package stxship.dis.buyerClass.letterFaxInput.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : LetterFaxInputService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * LetterFaxInput에서 사용되는 서비스
 *     </pre>
 */
public interface LetterFaxInputService extends CommonService {

	String buyerClassLetterFaxProjectInfo(CommandMap commandMap)  throws Exception ;

	String buyerClassLetterFaxSerialCodeCheck(CommandMap commandMap)  throws Exception ;

	Map<String, String> buyerClassLetterFaxDocumentSaveProcess(CommandMap commandMap)  throws Exception ;

	String buyerClassLetterFaxDrawingInfo(CommandMap commandMap)  throws Exception ;

	String buyerClassLetterFaxDocumentInfo(CommandMap commandMap)  throws Exception ;

	List<Map<String, Object>> getPartPersonsForBuyerClass(Map<String, String> dpsUserInfo) throws Exception ;
	
	List<Map<String, Object>> getDepartmentForBuyerClass() throws Exception ;
	
}

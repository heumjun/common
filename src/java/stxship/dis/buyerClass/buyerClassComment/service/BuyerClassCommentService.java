package stxship.dis.buyerClass.buyerClassComment.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : BuyerClassCommentService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * BuyerClassComment에서 사용되는 서비스
 *     </pre>
 */
public interface BuyerClassCommentService extends CommonService {

	Map<String, String> saveBuyerClassCommentProcess(CommandMap commandMap, HttpServletRequest request)
			throws Exception;

	Map<String, String> saveBuyerClassCommentProcessAddition(CommandMap commandMap, HttpServletRequest request)
			throws Exception;

	Map<String, String> buyerClassCommentForceClosed(CommandMap commandMap) throws Exception;
	
}

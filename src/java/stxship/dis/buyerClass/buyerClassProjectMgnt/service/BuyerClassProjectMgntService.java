package stxship.dis.buyerClass.buyerClassProjectMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : BuyerClassProjectMgntService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * BuyerClassProjectMgnt에서 사용되는 서비스
 *     </pre>
 */
public interface BuyerClassProjectMgntService extends CommonService {

	Map<String, String> buyerClassProjectMgntProcess(CommandMap commandMap) throws Exception;

	Map<String, String> buyerClassProjectUpdateProcess(CommandMap commandMap) throws Exception;

}

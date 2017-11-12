package stxship.dis.dwg.dwgSystem.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : DwgSystemService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DwgSystem에서 사용되는 서비스
 *     </pre>
 */
public interface DwgSystemService extends CommonService {

	Map<String, Object> dwgReceiverCheck(CommandMap commandMap) throws Exception;

	Map<String, String> requiredDWG(CommandMap commandMap) throws Exception;

	String selectView(CommandMap commandMap) throws Exception;

	List<Map<String, Object>> modifyMailReceiver(CommandMap commandMap) throws Exception;

	Map<String, String> delDWGReceiverGroup(CommandMap commandMap) throws Exception;

	Map<String, String> saveDWGMailReceiver(CommandMap commandMap) throws Exception;

	Map<String, String> saveMailReceiverGroup(CommandMap commandMap) throws Exception;
	
	Map<String, String> dwgRevisionCancel(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> selectDpDpspFlag(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> selectDwgDeptCode(CommandMap commandMap) throws Exception;
}

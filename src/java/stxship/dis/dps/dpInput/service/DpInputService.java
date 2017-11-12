package stxship.dis.dps.dpInput.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/**
 * @파일명 : DpInputService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpInput에서 사용되는 서비스
 *     </pre>
 */
public interface DpInputService extends DpsCommonService {

	Map<String, String> saveInputProjectSelect(CommandMap commandMap)  throws Exception;

	int saveAsOneDayOverJobDPInputsAction(CommandMap commandMap)  throws Exception;

	int saveAsOneDayOverJobWithProjectDPInputsAction(CommandMap commandMap)  throws Exception;

	int saveSeaTrialDPInputsAction(CommandMap commandMap)  throws Exception;

	int saveDPInputsAction(CommandMap commandMap)  throws Exception;

	List<Map<String,Object>> getOpCodeListGRT(Map<String, Object> map) throws Exception;

	List<Map<String,Object>> getOpCodeListMID(Map<String, Object> map) throws Exception;

	List<Map<String,Object>> getOpCodeListSUB(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> getDrawingListForWork(CommandMap commandMap) throws Exception;

	Map<String, String> dpInputMainGridSave(CommandMap commandMap) throws Exception;

	Map<String, String> deleteDPInputs(CommandMap commandMap) throws Exception;


}

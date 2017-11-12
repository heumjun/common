package stxship.dis.dps.progressInput.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/**
 * @파일명 : ProgressInputService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * ProgressInput에서 사용되는 서비스
 *     </pre>
 */
public interface ProgressInputService extends DpsCommonService {
	List<Map<String,Object>> getPLM_DATE_CHANGE_ABLE_DWG_TYPE() throws Exception;
	
	void addPLM_DATE_CHANGE_ABLE_DWG_TYPE(String dwg_kind,String dwg_type) throws Exception;

	void delPLM_DATE_CHANGE_ABLE_DWG_TYPE(Map<String, Object> map) throws Exception;

	Map<String, String> progressProjectDateChangeMainGridSave(CommandMap commandMap) throws Exception;

	List<Map<String, Object>> getChangableDateDPList(Map<String, Object> map)throws Exception;
	
	public Map<String, String> progressInputMainGridSave(CommandMap commandMap) throws Exception;

	List<Map<String, Object>> getDpsProgressInputSearchList(CommandMap commandMap) throws Exception;
}

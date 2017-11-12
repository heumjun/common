package stxship.dis.dps.progressDeviation.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/** 
 * @파일명	: ProgressDeviationService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 7. 7. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * ProgressDeviation Header File 변경 Service interface 
 * </pre>
 */
public interface ProgressDeviationService  extends DpsCommonService {
	
	
	
	public List<Map<String, Object>> getPartPersons_Dalian(Map<String, Object> param) throws Exception;
	
	public Map<String,Object> getPLMActivityDeviationDesc(CommandMap commandMap) throws Exception;
	
	public void savePLMActivityDeviationDesc(Map<String, Object> param) throws Exception;
	
	public void updateProgressSearchableProjectList(Map<String, Object> param) throws Exception;
	
	public void deleteSaveProjectList(CommandMap commandMap) throws Exception;
	
	public Map<String, String> projectSaveSearchAbleItem(CommandMap commandMap,List<String> externalGridParamKeyList) throws Exception;
	
	public Map<String, String> progressDeviationMainGridSave(CommandMap commandMap) throws Exception;
	
}

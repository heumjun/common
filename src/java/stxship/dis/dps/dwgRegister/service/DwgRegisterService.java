package stxship.dis.dps.dwgRegister.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/**
 * 
 * @파일명	: DwgRegisterService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 7. 27. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * Drawing Distribution History Search and Register interface
 * </pre>
 */
public interface DwgRegisterService extends DpsCommonService {
	
	public List<Map<String,Object>> getAllProjectList() throws Exception;
	
	public List<Map<String,Object>> getDepartmentList() throws Exception;

	public List<Map<String,Object>> getDeployReasonCodeList() throws Exception;
	
	public Map<String,Object> getDeployNoPrefix(Map<String,Object> param) throws Exception;

	public List<Map<String, Object>> getDrawingListForWork2(HashMap<String, Object> param) throws Exception;

	public Map<String, Object> getDrawingForWork3(HashMap<String, Object> param) throws Exception;

	public Map<String, String> popUpHardCopyDwgCreateGridSave(CommandMap commandMap) throws Exception;
	
}

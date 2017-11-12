package stxship.dis.usc.uscMain.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : UscService.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 12. 14.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * Usc에서 사용되는 서비스
 *     </pre>
 */
public interface UscService extends CommonService {

	//Map<String, Object> getUscActivityStdList(CommandMap commandMap);
	public Map<String, Object> getUscList(CommandMap commandMap);
	
	public List<Map<String, Object>> uscCodeNameList(CommandMap commandMap);
	
	public Map<String, Object> getUscGridData(Map<String, Object> map);
	
	public Map<String, Object> getUscExcelExport(Map<String, Object> map);

	public Map<String, String> saveUscActivityStd(CommandMap commandMap) throws Exception;
	
	public Map<String, String> saveUscMainEco(CommandMap commandMap) throws Exception;
	
	public Map<String, String> saveUscJobCreateEco(CommandMap commandMap) throws Exception;
	
	public Map<String, String> restoreUscJobCreate(CommandMap commandMap) throws Exception;
	
	public Map<String, String> cancelUscJobCreate(CommandMap commandMap) throws Exception;

	public View uscExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
	
	public List<Map<String, Object>> uscActivityStdExcelImportAction(CommandMap commandMap) throws Exception;
	
	public String uscMasterCode(Map<String, Object> map) throws Exception;
	
	public String uscAreaCodeName(Map<String, Object> map) throws Exception;
	
	public List<Map<String, Object>> uscBlockImportCheck(CommandMap commandMap) throws Exception;
	
	public String uscActivityImportCheck(CommandMap commandMap) throws Exception;
	
	public String uscVirtualBlockImportCheck(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> useActivityImport(CommandMap commandMap) throws Exception;
	
	public Map<String, String> useJobActAction(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> uscMainEconoCreate(Map<String, Object> map) throws Exception;
	
	public Map<String, Object> uscJobCreateEconoCreate(Map<String, Object> map) throws Exception;
	
	public List<Map<String, Object>> jobCreateAddCheck(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> jobCreateMoveCheck(Map<String, Object> map) throws Exception;

}

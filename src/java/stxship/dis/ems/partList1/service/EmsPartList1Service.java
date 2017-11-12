package stxship.dis.ems.partList1.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EmsPartList1Service extends CommonService {
	
	public Map<String, Object> getEmsPartList1List(CommandMap commandMap);
	
	public Map<String, Object> getEmsPartList1GridData(Map<String, Object> map);
	
	public Map<String, String> savePartListGridData(CommandMap commandMap) throws Exception;
	
	public Map<String, String> savePartListCopy(CommandMap commandMap) throws Exception;
	
	public Map<String, String> savePartListSsc(CommandMap commandMap) throws Exception;
	
	public Map<String, String> deletePartList(CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> uscCodeNameList(CommandMap commandMap);
	
	public View partListExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
	
	public Map<String, Object> getPartListExcelExport(Map<String, Object> map);

}


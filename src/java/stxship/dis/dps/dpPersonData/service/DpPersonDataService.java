/**
 * 
 */
package stxship.dis.dps.dpPersonData.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/** 
 * @파일명	: DpPersonDataService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 16. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
public interface DpPersonDataService extends DpsCommonService {
	
	public String getAverageOvertimeOfAll(CommandMap commandMap) throws Exception;
	
	public String getAverageOvertimeOfSelectedDepts(CommandMap commandMap) throws Exception;

	public View dpsExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}

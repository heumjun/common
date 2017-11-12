/**
 * 
 */
package stxship.dis.dps.dpProjectData.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/** 
 * @파일명	: DpProjectDataService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 17. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
public interface DpProjectDataService extends DpsCommonService {

	public Map<String, String> popUpProjectDataERPIFFSMainGridSave(CommandMap commandMap) throws Exception;

	public View dpsExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

}

/**
 * 
 */
package stxship.dis.dps.dpDeptData.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/** 
 * @파일명	: DpDepartmentDataService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 19. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
public interface DpDepartmentDataService extends DpsCommonService {

	View dpsExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}

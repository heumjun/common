/**
 * 
 */
package stxship.dis.dps.dpDataMgmtOld.service;

import java.util.HashMap;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/** 
 * @파일명	: DataMgmtService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 10. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 설계시수 data 관리 service
 * </pre>
 */
public interface DataMgmtOldService extends DpsCommonService {

	View dataMgmtExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}

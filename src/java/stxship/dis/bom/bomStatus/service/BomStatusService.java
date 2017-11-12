package stxship.dis.bom.bomStatus.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : BomStatusService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Bom현황에서 사용되는 서비스
 *     </pre>
 */
public interface BomStatusService extends CommonService {

	List<Map<String, Object>> getSpstShipTypeList(CommandMap commandMap);

	Map<String, String> getJobDeptCode(CommandMap commandMap);

	Map<String, String> saveBomJobItem(CommandMap commandMap) throws Exception;

	Map<String, String> saveJobItem(CommandMap commandMap) throws Exception;

	Map<String, String> deleteSpstSubItem(CommandMap commandMap) throws Exception;

	Map<String, String> saveSpstSubBom(CommandMap commandMap) throws Exception;

	Map<String, String> addSpecificStructure(CommandMap commandMap) throws Exception;

	Map<String, String> saveDwgEcoCreate(CommandMap commandMap) throws Exception;
}

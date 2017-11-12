package stxship.dis.dps.dpApproval.service;

import java.util.List;
import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;

/**
 * @파일명 : DpApprovalService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpApproval에서 사용되는 서비스
 *     </pre>
 */
public interface DpApprovalService extends DpsCommonService {

	List getPartDPConfirmsList(CommandMap commandMap) throws Exception;

	List getPartDPInputRateList(CommandMap commandMap) throws Exception;

	String getDwgDeptGubun(CommandMap commandMap) throws Exception;

	Map<String, String> dpApprovalMainGridSave(CommandMap commandMap) throws Exception;
	
	List getDwgMH_Overtime(Map param) throws Exception;
}

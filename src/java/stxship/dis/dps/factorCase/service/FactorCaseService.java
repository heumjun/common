package stxship.dis.dps.factorCase.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.dps.common.service.DpsCommonService;
/**
 * 
 * @파일명	: FactorCaseService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 9. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 시수 적용율 Case 관리
 * </pre>
 */
public interface FactorCaseService extends DpsCommonService {

	public Map<String, String> dwgRegisterMainGridSave(CommandMap commandMap) throws Exception;
	
	public void updateDefaultCase(Map<String,Object> param) throws Exception;

}

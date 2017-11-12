package stxship.dis.supplyPlan.supplyManage.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface SupplyManageService extends CommonService {
	
	/** 
	 * @메소드명	: supplyManageLoginGubun
	 * @날짜		: 2016. 10. 14.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 항목관리 관리자 구분
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> supplyManageLoginGubun(CommandMap commandMap) throws Exception;
	
	/** 
	 * @메소드명	: saveSupplyManageList
	 * @날짜		: 2016. 08. 03.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 수정사항 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> saveSupplyManageList(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : supplyManageExcelExport
	 * @날짜 : 2016. 09. 29.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * supplyManage 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	View supplyManageExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}

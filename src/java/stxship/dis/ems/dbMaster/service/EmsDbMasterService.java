package stxship.dis.ems.dbMaster.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.ems.common.service.EmsCommonService;

public interface EmsDbMasterService extends EmsCommonService {

	/** 
	 * @메소드명	: emsDbMasterLoginGubun
	 * @날짜		: 2016. 04. 18. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 접속 권한정보를 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> emsDbMasterLoginGubun(CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : emsDbMasterExcelExport
	 * @날짜 : 2016. 02. 22.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	View emsDbMasterExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	/**
	 * @메소드명 : popUpEmsDbMasterItemApprove
	 * @날짜 : 2016. 02. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청/승인/반려 작업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> popUpEmsDbMasterItemApprove(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : popUpEmsDbMasterItemSave
	 * @날짜 : 2016. 02. 24.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Master Item 저장 작업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> popUpEmsDbMasterItemSave(CommandMap commandMap) throws Exception;

	/** 
	 * @메소드명	: popUpEmsDbMasterAddGetCatalogName
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 조회 시 CATALOG NAME 정보를 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> popUpEmsDbMasterAddGetCatalogName(CommandMap commandMap);
	
	/**
	 * @메소드명 : popUpEmsDbMasterAddSave
	 * @날짜 : 2016. 02. 25.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창에서 등록(저장)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> popUpEmsDbMasterAddSave(CommandMap commandMap) throws Exception;
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddLastNum
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 품목그리드 추가 버튼 팝업창에서 행추가시 마지막 번호 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpEmsDbMasterAddItemLastNum(CommandMap commandMap);

	/** 
	 * @메소드명	: popUpEmsDbMasterAddLastNum
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 사양그리드 추가 버튼 팝업창에서 행추가시 마지막 번호 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpEmsDbMasterAddSpecLastNum(CommandMap commandMap);

	/** 
	 * @메소드명	: popUpEmsDbMasterShipAppSave
	 * @날짜		: 2016. 02. 29. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 적용 선종 선택 팝업창 : 등록 버튼
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> popUpEmsDbMasterShipAppSave(CommandMap commandMap) throws Exception;

	/** 
	 * @메소드명	: popUpEmsDbMasterShipDpSave
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 적용 선종 선택 팝업창 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws DisException 
	 * @throws Exception 
	 */
	Map<String, Object> popUpEmsDbMasterShipDpSave(CommandMap commandMap) throws Exception;

	/** 
	 * @메소드명	: popUpDbMasterManagerSave
	 * @날짜		: 2016. 02. 28. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 납기관리자 팝업창 : 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	Map<String, Object> popUpDbMasterManagerSave(CommandMap commandMap) throws Exception;

}

package stxship.dis.common.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;

/**
 * @파일명 : CommonService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * 공통 서비스 인터페이스 각 로직에서 상속됨
 * </pre>
 */
public interface CommonService {

	/**
	 * @메소드명 : errorService
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 Exception 처리
	 * </pre>
	 * 
	 * @param ex
	 * @param request
	 */
	void errorService(Exception ex, HttpServletRequest request);

	/**
	 * @메소드명 : getGridList
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 데이타리스트 취득 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getGridList(CommandMap commandMap);

	/**
	 * @메소드명 : saveGridList
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 변경된 데이타 처리 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveGridList(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : getUserRole
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 유저의 권한을 받아오는 처리
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> getUserRole(CommandMap commandMap);

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 입력)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String gridDataInsert(Map<String, Object> rowData);

	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 수정)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String gridDataUpdate(Map<String, Object> rowData);

	/**
	 * @메소드명 : gridDataDelete
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 삭제)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String gridDataDelete(Map<String, Object> rowData);

	/**
	 * @메소드명 : getDuplicationCnt
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 중복체크)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String getDuplicationCnt(Map<String, Object> rowData);

	/**
	 * @메소드명 : getGridData
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> getGridData(Map<String, Object> map);

	/**
	 * @메소드명 : getGridListSize
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 사이즈 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 */
	Object getGridListSize(Map<String, Object> map);

	/**
	 * @메소드명 : getGridListNoPaging
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 페이징이 없는 그리드 리스트 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getGridListNoPaging(CommandMap commandMap);

	/**
	 * @메소드명 : getDbDataOne
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드가 아닌 단일 DB정보를 받아옴
	 * 1. 맵핑 파일은 액션서블릿명과 연동된다.
	 *    EX)infoEmpNoRegister.do ->infoEmpNoRegister.xml
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	Map<String, Object> getDbDataOne(CommandMap commandMap);

	/**
	 * @메소드명 : getDbDataList
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드가 아닌 리스트 DB정보를 받아옴
	 * 1. 맵핑 파일은 액션서블릿명과 연동된다.
	 *    EX)infoEmpNoRegister.do ->infoEmpNoRegister.xml
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	List<Map<String, Object>> getDbDataList(CommandMap commandMap);

	/**
	 * @메소드명 : saveEngineerRegister
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택된 엔지니어를 저장
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveEngineerRegister(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : getSelectBoxDataList
	 * @날짜 : 2015. 12. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 AJAX 셀렉트 박스 호출
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	String getSelectBoxDataList(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : updateDbData
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 DBDATA UPDATE
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	int updateDbData(CommandMap commandMap);

	/**
	 * @메소드명 : excelExport
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 엑셀 출력
	 * </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	View excelExport(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, String> getDpsUserInfo(CommandMap commandMap);
	
	/**
	 * @메소드명 : saveGridList
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 변경된 데이타 처리 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveManualGridList(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : manualInfoList
	 * @날짜 : 2017. 02. 09.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 해당 페이지 메뉴얼 제공을 위한 공통로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> manualInfoList(CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : getErpGridList
	 * @날짜 : 2017. 3. 1.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 데이타리스트 취득 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getErpGridList(CommandMap commandMap);
	
	/**
	 * @메소드명 : getEprGridData
	 * @날짜 : 2017. 3. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> getErpGridData(Map<String, Object> map);

	/**
	 * @메소드명 : getEprGridListSize
	 * @날짜 : 2017. 3. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 사이즈 취득)
	 * </pre>
	 * 
	 * @param map
	 * @return
	 */
	Object getErpGridListSize(Map<String, Object> map);
	
	/**
	 * @메소드명 : saveErpGridList
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 그리드의 변경된 데이타 처리 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, String> saveErpGridList(CommandMap commandMap) throws Exception;

	
	/**
	 * @메소드명 : getErpDuplicationCnt
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 중복체크)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String getDuplicationCntErp(Map<String, Object> rowData);

	/**
	 * @메소드명 : gridDataInsertErp
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 입력)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String gridDataInsertErp(Map<String, Object> rowData);
	
	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 수정)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String gridDataUpdateErp(Map<String, Object> rowData);

	/**
	 * @메소드명 : gridDataDelete
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 각 로직별로 재정의 혹은 super로 이용(그리드 데이터 삭제)
	 * </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	String gridDataDeleteErp(Map<String, Object> rowData);
	
	/**
	 * @메소드명 : getErpGridListNoPaging
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 페이징이 없는 그리드 리스트 로직
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getErpGridListNoPaging(CommandMap commandMap);	

}

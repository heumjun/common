package stxship.dis.ems.purchasing.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EmsPurchasingService extends CommonService {

	/**
	 * @메소드명 : emsPurchasingGetDeptList
	 * @날짜 : 2016. 03. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 조회조건 부서 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsPurchasingSelectBoxDept(CommandMap commandMap);

	/**
	 * @메소드명 : emsPurchasingAddSelectBoxPjt
	 * @날짜 : 2016. 03. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 조회조건 선종 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsPurchasingAddSelectBoxPjt(CommandMap commandMap);

	/**
	 * @메소드명 : popUpPurchasingFosSelectBoxCauseDept
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : POS그리드 내 원인부서 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxCauseDept(CommandMap commandMap);

	/**
	 * @메소드명 : popUpPurchasingFosSelectBoxPosType
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : POS그리드 내 항목 SelectBox 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingFosSelectBoxPosType(CommandMap commandMap);

	/**
	 * @메소드명 : popUpPurchasingPosUploadFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 - UPLOAD 버튼 팝업창 : 등록한 파일 업로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpPurchasingPosUploadFile(HttpServletRequest request, CommandMap commandMap,
			HttpServletResponse response) throws Exception;

	/**
	 * @메소드명 : popUpPurchasingPosApplyFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 파일 업로드 후 APPLY
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpPurchasingPosApplyFile(HttpServletRequest request, CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : popUpPurchasingPosApprove
	 * @날짜 : 2016. 04. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : POS승인
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpPurchasingPosApprove(HttpServletRequest request, CommandMap commandMap) throws Exception;;

	/**
	 * @메소드명 : posDownloadFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	View popUpPurchasingPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	/**
	 * @메소드명 : emsPurchasingDeleteA
	 * @날짜 : 2016. 03. 15.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 상태 'A' 삭제 시 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> emsPurchasingDeleteA(CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : emsPurchasingDeleteS
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 상태 'S' 삭제 시 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> emsPurchasingDeleteS(CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : popUpPurchasingRequestListTeamLeader
	 * @날짜 : 2016. 03. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창 : 팀장 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingRequestListTeamLeader(CommandMap commandMap);

	/**
	 * @메소드명 : popUpPurchasingRequestListPartLeader
	 * @날짜 : 2016. 03. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창 : 파트장 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingRequestListPartLeader(CommandMap commandMap);

	/**
	 * @메소드명 : popUpPurchasingRequestApply
	 * @날짜 : 2016. 03. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창 : APPLY 버튼을 클릭하여 승인을 요청
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> popUpPurchasingRequestApply(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : popUpPurchasingRestore
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * A복원 버튼을 실행하여 상태를 변경
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> popUpPurchasingRestore(HttpServletRequest request, CommandMap commandMap)
			throws Exception;

	/**
	 * @메소드명 : popUpPurchasingSpecObtainList
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 조달 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingSpecObtainList(HttpServletRequest request, CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : popUpPurchasingSpecPlanList
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 설계 그리드 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> popUpPurchasingSpecPlanList(HttpServletRequest request, CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : getSelectBoxVenderName
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 그리드 내 업체명 SELECT BOX
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> getSelectBoxVenderName(HttpServletRequest request, CommandMap commandMap) throws Exception;
	
	/**
	 * @메소드명 : popUpPurchasingSpecUploadFile
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 - 업로드 버튼 팝업창 : 파일 업로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	public  Map<String, Object> popUpPurchasingSpecUploadFile(HttpServletRequest request, CommandMap commandMap, HttpServletResponse response) throws Exception;
	
	/**
	 * @메소드명 : popUpPurchasingSpecApply
	 * @날짜 : 2016. 04. 04.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 적용 기능
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> popUpPurchasingSpecApply(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	/**
	 * @메소드명 : emsPurchasingExcelExport
	 * @날짜 : 2016. 03. 16.
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
	View emsPurchasingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	/**
	 * @메소드명 : purchasingAddExcelList
	 * @날짜 : 2016. 3. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 Import list 취득
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> purchasingAddExcelList(CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception;

	/**
	 * @메소드명 : emsPurchasingDPExcelExport
	 * @날짜 : 2016. 03. 26.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * DP 팝업창 : 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	View emsPurchasingDPExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
}

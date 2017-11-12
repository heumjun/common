package stxship.dis.ems.purchasingNew.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EmsNewPurchasingService extends CommonService {

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
	 * @메소드명 : purchasingRequestApply
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
	public Map<String, Object> purchasingRequestApply(CommandMap commandMap) throws Exception;
	
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

	public Map<String, Object> selectEmsPurchasingMainList(CommandMap commandMap) throws Exception;

	public String selectAutoCompleteDwgNoList(CommandMap commandMap) throws Exception;

	public String getEmsApprovedBoxDataList(CommandMap commandMap) throws Exception;

	public Map<String,Object> selectPosChk(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingPosList(CommandMap commandMap) throws Exception;
	
	public Map<String,Object> makePosTempList(CommandMap commandMap) throws Exception;

	public Map<String, String> popUpPurchasingPosInsert(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingAddFisrtList(CommandMap commandMap) throws Exception;

	public Map<String,String> makePurTempList(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingAddSecondList(CommandMap commandMap) throws Exception;

	public Map<String, String> popUpEmsPurchasingAddApply(CommandMap commandMap) throws Exception;

	public List<Map<String, Object>> popUpPurchasingAddInstallTime(CommandMap commandMap);

	public List<Map<String, Object>> popUpPurchasingAddInstallLocation(CommandMap commandMap);

	public Map<String, Object> selectDeleteChk(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingDeleteList(CommandMap commandMap);

	public Map<String, String> popUpEmsPurchasingDeleteApply(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingModifyFirstList(CommandMap commandMap) throws Exception;

	public Map<String,Object> makeModifyTempList(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingModifySecondList(CommandMap commandMap) throws Exception;

	public Map<String, Object> selectEmsPurchasingModifyChkList(CommandMap commandMap) throws Exception;

	public Map<String, String> popUpEmsPurchasingModifyApply(CommandMap commandMap) throws Exception;

	public Map<String, Object> popUpPurchasingSpecList(HttpServletRequest request, CommandMap commandMap) throws Exception;

	public List<Map<String, Object>> popUpPurchasingSpecDownList(CommandMap commandMap);

	
}

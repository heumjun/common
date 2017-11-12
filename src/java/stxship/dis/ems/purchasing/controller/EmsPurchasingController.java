package stxship.dis.ems.purchasing.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.ems.purchasing.service.EmsPurchasingService;

/**
 * @파일명 : EmsPurchasingController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 02. 29.
 * @작성자 : 이상빈
 * @설명
 * 
 * 	<pre>
 * EmsPurchasing 컨트롤러
 *     </pre>
 */

@Controller
public class EmsPurchasingController extends CommonController {

	@Resource(name = "emsPurchasingService")
	private EmsPurchasingService emsPurchasingService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 02. 29.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * EmsPurchasing 모듈로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPurchasing.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

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
	@RequestMapping(value = "emsPurchasingSelectBoxDept.do")
	public @ResponseBody List<Map<String, Object>> emsPurchasingSelectBoxDept(CommandMap commandMap) throws Exception {
		return emsPurchasingService.emsPurchasingSelectBoxDept(commandMap);
	}

	/**
	 * @메소드명 : emsPurchasingList
	 * @날짜 : 2016. 03. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * emsPurchasing 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsPurchasingList.do")
	public @ResponseBody Map<String, Object> emsPurchasingList(CommandMap commandMap) {
		return emsPurchasingService.getErpGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingAdd
	 * @날짜 : 2016. 02. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingAdd.do")
	public ModelAndView popUpPurchasingAdd(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

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
	@RequestMapping(value = "emsPurchasingAddSelectBoxPjt.do")
	public @ResponseBody List<Map<String, Object>> emsPurchasingAddSelectBoxPjt(CommandMap commandMap)
			throws Exception {
		return emsPurchasingService.emsPurchasingAddSelectBoxPjt(commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingAddList
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : 조회 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingAddList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingAddList(CommandMap commandMap) {
		return emsPurchasingService.getGridList(commandMap);
	}

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
	@RequestMapping(value = "popUpPurchasingFosSelectBoxCauseDept.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingFosSelectBoxCauseDept(CommandMap commandMap)
			throws Exception {
		return emsPurchasingService.popUpPurchasingFosSelectBoxCauseDept(commandMap);
	}

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
	@RequestMapping(value = "popUpPurchasingFosSelectBoxPosType.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingFosSelectBoxPosType(CommandMap commandMap)
			throws Exception {
		return emsPurchasingService.popUpPurchasingFosSelectBoxPosType(commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingPosList
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : NEXT 버튼시 POS그리드 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingPosList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingPosList(CommandMap commandMap) {
		return emsPurchasingService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingPosUpload
	 * @날짜 : 2016. 03. 11.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 : UPLOAD 버튼 팝업창을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingPosUpload.do")
	public ModelAndView popUpPurchasingPosUpload(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : emsPurchasingPosUploadFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창 - UPLOAD 버튼 팝업창 : 파일 업로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingPosUploadFile.do")
	public @ResponseBody Map<String, Object> popUpPurchasingPosUploadFile(HttpServletRequest request,
			CommandMap commandMap, HttpServletResponse response) throws Exception {
		return emsPurchasingService.popUpPurchasingPosUploadFile(request, commandMap, response);
	}

	/**
	 * @메소드명 : popUpPurchasingPosApplyFile
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * POS 팝업창 : 적용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingPosApplyFile.do")
	public @ResponseBody Map<String, Object> popUpPurchasingPosApplyFile(HttpServletRequest request,
			CommandMap commandMap) throws Exception {
		return emsPurchasingService.popUpPurchasingPosApplyFile(request, commandMap);
	}
	
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
	@RequestMapping(value = "popUpPurchasingPosApprove.do")
	public @ResponseBody Map<String, Object> popUpPurchasingPosApprove(HttpServletRequest request,
			CommandMap commandMap) throws Exception {
		return emsPurchasingService.popUpPurchasingPosApprove(request, commandMap);
	}

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
	@RequestMapping(value = "popUpPurchasingPosDownloadFile.do")
	public View popUpPurchasingPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsPurchasingService.popUpPurchasingPosDownloadFile(commandMap, modelMap);
	}

	/**
	 * @메소드명 : popUpPurchasingDelete
	 * @날짜 : 2016. 03. 15.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 상태 'S' 삭제 시 팝업창 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingDelete.do")
	public ModelAndView popUpPurchasingDelete(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : popUpPurchasingDeleteList
	 * @날짜 : 2016. 03. 15.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 삭제 버튼 팝업창 : 조회 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingDeleteList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingDeleteList(CommandMap commandMap) {
		String emsPurNoArray[] = commandMap.get("p_ems_pur_no").toString().replace(",,", "").split(",");
		commandMap.put("emsPurNoArray", emsPurNoArray);
		return emsPurchasingService.getGridList(commandMap);
	}

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
	@RequestMapping(value = "emsPurchasingDeleteA.do")
	public @ResponseBody Map<String, Object> emsPurchasingDeleteA(CommandMap commandMap) throws Exception {
		return emsPurchasingService.emsPurchasingDeleteA(commandMap);
	}
	
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
	@RequestMapping(value = "emsPurchasingDeleteS.do")
	public @ResponseBody Map<String, Object> emsPurchasingDeleteS(CommandMap commandMap) throws Exception {
		return emsPurchasingService.emsPurchasingDeleteS(commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingRequest
	 * @날짜 : 2016. 02. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 승인요청 버튼 팝업창을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingRequest.do")
	public ModelAndView popUpPurchasingRequest(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

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
	@RequestMapping(value = "popUpPurchasingRequestListTeamLeader.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingRequestListTeamLeader(CommandMap commandMap)
			throws Exception {
		return emsPurchasingService.popUpPurchasingRequestListTeamLeader(commandMap);
	}

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
	@RequestMapping(value = "popUpPurchasingRequestListPartLeader.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingRequestListPartLeader(CommandMap commandMap)
			throws Exception {
		return emsPurchasingService.popUpPurchasingRequestListPartLeader(commandMap);
	}

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
	@RequestMapping(value = "popUpPurchasingRequestApply.do")
	public @ResponseBody Map<String, Object> popUpPurchasingRequestApply(CommandMap commandMap) throws Exception {
		return emsPurchasingService.popUpPurchasingRequestApply(commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingPos
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * POS 버튼 팝업창 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingPos.do")
	public ModelAndView popUpPurchasingPos(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

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
	@RequestMapping(value = "popUpPurchasingRestore.do")
	public @ResponseBody Map<String, Object> popUpPurchasingRestore(HttpServletRequest request, CommandMap commandMap)
			throws Exception {
		return emsPurchasingService.popUpPurchasingRestore(request, commandMap);
	}

	/**
	 * @메소드명 : popUpPurchasingSpec
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingSpec.do")
	public ModelAndView popUpPurchasingSpec(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
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
	@RequestMapping(value = "popUpPurchasingSpecObtainList.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingSpecObtainList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		return emsPurchasingService.popUpPurchasingSpecObtainList(request, commandMap);
	}
	
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
	@RequestMapping(value = "popUpPurchasingSpecPlanList.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingSpecPlanList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		return emsPurchasingService.popUpPurchasingSpecPlanList(request, commandMap);
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecPlanList
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
	@RequestMapping(value = "getSelectBoxVenderName.do")
	public @ResponseBody List<Map<String, Object>> getSelectBoxVenderName(HttpServletRequest request, CommandMap commandMap) throws Exception {
		return emsPurchasingService.getSelectBoxVenderName(request, commandMap);
	}
	
	/**
	 * @메소드명 : popUpPurchasingSpecUpload
	 * @날짜 : 2016. 04. 01.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양 버튼 팝업창 : 업로드 버튼 팝업창 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingSpecUpload.do")
	public ModelAndView popUpPurchasingSpecUpload(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
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
	@RequestMapping(value = "popUpPurchasingSpecUploadFile.do")
	public @ResponseBody Map<String, Object> popUpPurchasingSpecUploadFile(HttpServletRequest request,
			CommandMap commandMap, HttpServletResponse response) throws Exception {
		return emsPurchasingService.popUpPurchasingSpecUploadFile(request, commandMap, response);
	}

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
	@RequestMapping(value = "popUpPurchasingSpecApply.do")
	public @ResponseBody Map<String, Object> popUpPurchasingSpecApply(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsPurchasingService.popUpPurchasingSpecApply(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : popUpPurchasingDp
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * DP 버튼 팝업창 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingDp.do")
	public ModelAndView popUpPurchasingDp(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : emsPurchasingExcelExport
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsPurchasingExcelExport.do")
	public View emsPurchasingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsPurchasingService.emsPurchasingExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : popUpPurchasingAddExcelImport
	 * @날짜 : 2016. 3. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 Import 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingAddExcelImport.do")
	public ModelAndView popUpPurchasingAddExcelImport(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : popUpPurchasingAddExcelList
	 * @날짜 : 2016. 3. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 Import 리스트 취득
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingAddExcelList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingAddExcelList( 
			@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		return emsPurchasingService.purchasingAddExcelList(file, commandMap, response);
	}

	/**
	 * @메소드명 : popUpPurchasingDpList
	 * @날짜 : 2016. 03. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * DP 버튼 팝업창 : 조회 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingDpList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingDpList(CommandMap commandMap) {

		// 선택 호선 배열로 변환
		String projectsArray[] = commandMap.get("p_project").toString().split(",");
		commandMap.put("projectsArray", projectsArray);

		// 선택 도면번호 배열로 변환
		String dwgNosArray[] = commandMap.get("p_dwg_no").toString().split(",");
		commandMap.put("dwgNosArray", dwgNosArray);

		return emsPurchasingService.getErpGridList(commandMap);
	}
	
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
	@RequestMapping(value = "emsPurchasingDPExcelExport.do")
	public View emsPurchasingDPExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		
		// 선택 호선 배열로 변환
		String projectsArray[] = commandMap.get("p_project").toString().split(",");
		commandMap.put("projectsArray", projectsArray);

		// 선택 도면번호 배열로 변환
		String dwgNosArray[] = commandMap.get("p_dwg_no").toString().split(",");
		commandMap.put("dwgNosArray", dwgNosArray);
		
		return emsPurchasingService.emsPurchasingDPExcelExport(commandMap, modelMap);
	}
}

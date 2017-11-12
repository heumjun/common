package stxship.dis.ems.purchasingNew.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.spi.http.HttpContext;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.google.gson.Gson;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.ems.purchasing.service.EmsPurchasingService;
import stxship.dis.ems.purchasingNew.service.EmsNewPurchasingService;

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
public class EmsNewPurchasingController extends CommonController {

	@Resource(name = "emsNewPurchasingService")
	private EmsNewPurchasingService emsNewPurchasingService;

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
	@RequestMapping(value = "emsPurchasingNew.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : emsPurchasingList
	 * @날짜 : 2016. 03. 01.
	 * @작성자 : 조중호
	 * @설명 :
	 * 
	 *     <pre>
	 * emsPurchasing 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "emsNewPurchasingList.do")
	public @ResponseBody Map<String, Object> emsNewPurchasingList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.selectEmsPurchasingMainList(commandMap);
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
	@RequestMapping(value = "popUpPurchasingNewAdd.do")
	public ModelAndView popUpPurchasingNewAdd(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		String sWorkKey = Long.toString(System.currentTimeMillis());
		commandMap.put("p_session_id", sWorkKey);
		mav.addAllObjects(commandMap.getMap());
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
	@RequestMapping(value = "emsNewPurchasingAddSelectBoxPjt.do")
	public @ResponseBody List<Map<String, Object>> emsNewPurchasingAddSelectBoxPjt(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.emsPurchasingAddSelectBoxPjt(commandMap);
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
	@RequestMapping(value = "popUpPurchasingNewFosSelectBoxCauseDept.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingNewFosSelectBoxCauseDept(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingFosSelectBoxCauseDept(commandMap);
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
	@RequestMapping(value = "popUpPurchasingNewFosSelectBoxPosType.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingNewFosSelectBoxPosType(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingFosSelectBoxPosType(commandMap);
	}

	/**
	 * 
	 * @메소드명	: popUpPurchasingPosList
	 * @날짜		: 2017. 4. 6.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	popUpPurchasing PosList
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpPurchasingNewPosList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewPosList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.selectEmsPurchasingPosList(commandMap);
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
	@RequestMapping(value = "popUpPurchasingNewPosUpload.do")
	public ModelAndView popUpPurchasingNewPosUpload(CommandMap commandMap) {
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
	@RequestMapping(value = "popUpPurchasingNewPosUploadFile.do")
	public @ResponseBody void popUpPurchasingNewPosUploadFile(HttpServletRequest request,CommandMap commandMap, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write(DisJsonUtil.mapToJsonstring(emsNewPurchasingService.popUpPurchasingPosUploadFile(request, commandMap, response)));
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
	@RequestMapping(value = "popUpPurchasingNewPosDownloadFile.do")
	public View popUpPurchasingNewPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingPosDownloadFile(commandMap, modelMap);
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
	@RequestMapping(value = "popUpPurchasingNewDelete.do")
	public ModelAndView popUpPurchasingNewDelete(CommandMap commandMap) {
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
	@RequestMapping(value = "popUpPurchasingNewDeleteList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewDeleteList(CommandMap commandMap) {
		return emsNewPurchasingService.selectEmsPurchasingDeleteList(commandMap);
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
	@RequestMapping(value = "emsPurchasingNewDeleteA.do")
	public @ResponseBody Map<String, Object> emsPurchasingNewDeleteA(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.emsPurchasingDeleteA(commandMap);
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
	@RequestMapping(value = "purchasingNewRequestApply.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewRequestApply(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.purchasingRequestApply(commandMap);
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
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpPurchasingNewPos.do")
	public ModelAndView popUpPurchasingNewPos(HttpServletRequest req,CommandMap commandMap) throws Exception {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		String sWorkKey = Long.toString(System.currentTimeMillis());
		commandMap.put("p_session_id", sWorkKey);
		emsNewPurchasingService.makePosTempList(commandMap);
		mav.addAllObjects(commandMap.getMap());
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
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
	@RequestMapping(value = "popUpPurchasingNewSpec.do")
	public ModelAndView popUpPurchasingNewSpec(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingSpecList
	 * @날짜		: 2017. 4. 25.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewSpecList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewSpecList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingSpecList(request, commandMap);
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
	@RequestMapping(value = "popUpPurchasingNewSpecUpload.do")
	public ModelAndView popUpPurchasingNewSpecUpload(CommandMap commandMap) {
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
	@RequestMapping(value = "popUpPurchasingNewSpecUploadFile.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewSpecUploadFile(HttpServletRequest request,CommandMap commandMap, HttpServletResponse response) throws Exception {
		return emsNewPurchasingService.popUpPurchasingSpecUploadFile(request, commandMap, response);
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingSpecDownload
	 * @날짜		: 2017. 4. 26.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	spec downdload popUp
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPurchasingNewSpecDownload.do")
	public ModelAndView popUpPurchasingNewSpecDownload(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		List<Map<String, Object>> list = emsNewPurchasingService.popUpPurchasingSpecDownList(commandMap);
		mav.addObject("downList",list);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
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
	@RequestMapping(value = "popUpPurchasingNewSpecApply.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewSpecApply(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingSpecApply(commandMap, modelMap);
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
	@RequestMapping(value = "popUpPurchasingNewDp.do")
	public ModelAndView popUpPurchasingNewDp(CommandMap commandMap) {
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
	@RequestMapping(value = "emsPurchasingNewExcelExport.do")
	public View emsPurchasingNewExcelExport(CommandMap commandMap, Map<String, Object> modelMap, HttpServletRequest req) throws Exception {
		return emsNewPurchasingService.emsPurchasingExcelExport(commandMap, modelMap);
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
	@RequestMapping(value = "popUpPurchasingNewAddExcelImport.do")
	public ModelAndView popUpPurchasingNewAddExcelImport(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
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
	@RequestMapping(value = "popUpPurchasingNewAddExcelList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewAddExcelList( 
			@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		return emsNewPurchasingService.purchasingAddExcelList(file, commandMap, response);
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
	@RequestMapping(value = "popUpPurchasingNewDpList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewDpList(CommandMap commandMap) {

		// 선택 호선 배열로 변환
		String projectsArray[] = commandMap.get("p_project").toString().split(",");
		commandMap.put("projectsArray", projectsArray);

		// 선택 도면번호 배열로 변환
		String dwgNosArray[] = commandMap.get("p_dwg_no").toString().split(",");
		commandMap.put("dwgNosArray", dwgNosArray);

		return emsNewPurchasingService.getGridListNoPaging(commandMap);
	}
		
	/**
	 * 
	 * @메소드명	: popUpPurchasingAdd
	 * @날짜		: 2017. 3. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Modify 팝업 호출 창
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpPurchasingNewModify.do")
	public ModelAndView popUpPurchasingNewModify(CommandMap commandMap) throws Exception {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		String sWorkKey = Long.toString(System.currentTimeMillis());
		commandMap.put("p_work_key", sWorkKey);
		emsNewPurchasingService.makeModifyTempList(commandMap);
		
		mav.addAllObjects(commandMap.getMap());
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingModifyFirstList
	 * @날짜		: 2017. 4. 19.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * Modify first grid data load
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewModifyFirstList.do")
	public @ResponseBody Map<String, Object> emsPurchasingNewModifyFirstList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.selectEmsPurchasingModifyFirstList(commandMap);
	}
	/**
	 * 
	 * @메소드명	: emsPurchasingModifyChkList
	 * @날짜		: 2017. 4. 19.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * next전 값 확인 및 증명 처리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewModifyChk.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String emsPurchasingNewModifyChkList(CommandMap commandMap) throws Exception {
		return DisJsonUtil.mapToJsonstring(emsNewPurchasingService.selectEmsPurchasingModifyChkList(commandMap));
	}
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingModifySecondList
	 * @날짜		: 2017. 4. 19.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * Modify Second grid data load
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewModifySecondList.do")
	public @ResponseBody Map<String, Object> popUpPurchasingNewModifySecondList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.selectEmsPurchasingModifySecondList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpEmsPurchasingModifyApply
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	ADD APPLY
	 * </pre>
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpEmsPurchasingNewModifyApply.do")
	public @ResponseBody Map<String, String> popUpEmsPurchasingModifyApply(HttpServletRequest req,CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpEmsPurchasingModifyApply(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: sscAutoCompleteDwgNoList
	 * @날짜		: 2017. 4. 3.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	ems 도면 자동완성
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "emsNewAutoCompleteDwgNoList.do")
	public @ResponseBody String sscAutoCompleteDwgNoList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.selectAutoCompleteDwgNoList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: emsSelectBoxDataList
	 * @날짜		: 2017. 4. 4.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems 승인자 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsNewApprovedBoxDataList.do")
	public @ResponseBody String emsNewApprovedBoxDataList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.getEmsApprovedBoxDataList(commandMap);
	}
	
	
	/**
	 * 
	 * @메소드명	: emsPosChk
	 * @날짜		: 2017. 4. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	POS전 검색 조건에서 project 및 dwg_no 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsNewPosChk.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String emsNewPosChk(CommandMap commandMap) throws Exception {
		return DisJsonUtil.mapToJsonstring(emsNewPurchasingService.selectPosChk(commandMap));
	}
	/**
	 * 
	 * @메소드명	: emsPosChk
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	Ems delete전 check
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsNewDeleteChk.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String emsNewDeleteChk(CommandMap commandMap) throws Exception {
		String sWorkKey = Long.toString(System.currentTimeMillis());
		commandMap.put("p_work_key", sWorkKey);
		return DisJsonUtil.mapToJsonstring(emsNewPurchasingService.selectDeleteChk(commandMap));
	}
	
	
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingPosInsert
	 * @날짜		: 2017. 4. 11.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewPosInsert.do")
	public @ResponseBody Map<String, String> popUpPurchasingNewPosInsert(HttpServletRequest req,CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingPosInsert(commandMap);
	}
	
	/**
	 * @메소드명 : popUpEmsPurchasingAddFisrtList
	 * @날짜 : 2017. 04. 13.
	 * @작성자 : 조중호
	 * @설명 :
	 * 
	 *     <pre>
	 * EMS ADD MAIN First LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsPurchasingNewAddFisrtList.do")
	public @ResponseBody Map<String, Object> emsNewPurchasingAddFisrtList(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.selectEmsPurchasingAddFisrtList(commandMap);
	}
	
	/**
	 * @메소드명 : popUpEmsPurchasingAddSecondList
	 * @날짜 : 2017. 04. 13.
	 * @작성자 : 조중호
	 * @설명 :
	 * 
	 *     <pre>
	 * EMS ADD MAIN First LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsPurchasingNewAddSecondList.do")
	public @ResponseBody Map<String, Object> popUpEmsPurchasingNewAddSecondList(CommandMap commandMap) throws Exception {
		emsNewPurchasingService.makePurTempList(commandMap);
		return emsNewPurchasingService.selectEmsPurchasingAddSecondList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpEmsPurchasingAddApply
	 * @날짜		: 2017. 4. 14.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	ADD APPLY
	 * </pre>
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpEmsPurchasingNewAddApply.do")
	public @ResponseBody Map<String, String> popUpEmsPurchasingNewAddApply(HttpServletRequest req,CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpEmsPurchasingAddApply(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpEmsPurchasingDeleteApply
	 * @날짜		: 2017. 4. 18.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * delete apply
	 * </pre>
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpEmsPurchasingNewDeleteApply.do")
	public @ResponseBody Map<String, String> popUpEmsPurchasingNewDeleteApply(HttpServletRequest req,CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpEmsPurchasingDeleteApply(commandMap);
	}
	
	
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingAddInstallTime
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * add 설치 시점
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewAddInstallTime.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingNewAddInstallTime(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingAddInstallTime(commandMap);
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingAddInstallPosition
	 * @날짜		: 2017. 4. 17.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	설치 위치
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpPurchasingNewAddInstallLocation.do")
	public @ResponseBody List<Map<String, Object>> popUpPurchasingNewAddInstallPosition(CommandMap commandMap) throws Exception {
		return emsNewPurchasingService.popUpPurchasingAddInstallLocation(commandMap);
	}

}

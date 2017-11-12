package stxship.dis.etc.standardInfoTrans.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.etc.standardInfoTrans.service.StandardInfoTransExcelService;
import stxship.dis.etc.standardInfoTrans.service.StandardInfoTransService;

/**
 * @파일명 : StandardInfoTransController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 4. 18.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 *  기준정보등록요청 컨트롤러
 *     </pre>
 */
@Controller
public class StandardInfoTransController extends CommonController {
	/** 기준정보등록요청 서비스 */
	@Resource(name = "standardInfoTransService")
	private StandardInfoTransService standardInfoTransService;

	/** 기준정보등록요청 엑셀 서비스 */
	@Resource(name = "standardInfoTransExcelService")
	private StandardInfoTransExcelService standardInfoTransExcelService;

	/**
	 * @메소드명 : standardInfoTrans
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "standardInfoTrans.do")
	public ModelAndView standardInfoTrans(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : standardInfoTransListAction
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "standardInfoTransList.do")
	public @ResponseBody Map<String, Object> standardInfoTransListAction(CommandMap commandMap) {
		return standardInfoTransService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : standardInfoTransModifyView
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 상세화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "standardInfoTransModifyView.do")
	public ModelAndView standardInfoTransModifyView(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/etc" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : standardInfoTransDbList
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청에서 필요한 리스트정보취득
	 *     </pre>
	 * 
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "standardInfoTransDbList.do")
	public @ResponseBody List<Map<String, Object>> standardInfoTransDbList(HttpServletRequest request,
			CommandMap commandMap) throws Exception {
		return standardInfoTransService.standardInfoTransDbList(commandMap);
	}

	/**
	 * @메소드명 : standardInfoTransDbData
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 액션 로직
	 *     </pre>
	 * 
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "standardInfoTransDbData.do")
	public @ResponseBody Map<String, Object> standardInfoTransDbData(HttpServletRequest request, CommandMap commandMap)
			throws Exception {
		// 임시 저장시
		if (commandMap.get("p_process").equals("temporarystorage")) {
			return standardInfoTransService.tbcTemporaryStorage(commandMap);
		}
		// 접수시
		else if (commandMap.get("p_process").equals("itemreceive")) {
			return standardInfoTransService.itemreceive(commandMap);
		}
		// 승인시
		else if (commandMap.get("p_process").equals("updateInfoList")) {
			return standardInfoTransService.updateInfoList(commandMap);
		}
		// 반려
		else if (commandMap.get("p_process").equals("updateReturn")) {
			return standardInfoTransService.updateReturn(commandMap);
		}
		// 철회
		else if (commandMap.get("p_process").equals("updateRetract")) {
			return standardInfoTransService.updateRetract(commandMap);
		}
		// 취소 버튼 눌렀을 때
		else if (commandMap.get("p_process").equals("btnCancel")) {
			return standardInfoTransService.deleteDoc(commandMap);
		}
		// 첨부 파일 삭제
		else if (commandMap.get("p_process").equals("deleteDocList")) {
			return standardInfoTransService.deleteDocument(commandMap);
		}
		// 관리자가 삭제할 경우
		else if (commandMap.get("p_process").equals("AdminDelete")) {
			return standardInfoTransService.adminDelete(commandMap);
		} else {
			return standardInfoTransService.standardInfoTransDbData(commandMap);
		}

	}

	/**
	 * @메소드명 : standardInfoTransItemPopupDoc
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 문서첨부 팝업창
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpTransItemDoc.do")
	public ModelAndView standardInfoTransItemPopupDoc(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/etc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : itemTransFileUpload
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 파일 업로드
	 *     </pre>
	 * 
	 * @param response
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "itemTransFileUpload.do")
	public @ResponseBody Map<String, Object> itemTransFileUpload(HttpServletResponse response,
			HttpServletRequest request, CommandMap commandMap) throws Exception {
		return standardInfoTransService.itemTransFileUpload(response, request, commandMap);
	}

	/**
	 * @메소드명 : popUpItemTransUserSearch
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 관련자 추가 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemTransUserSearch.do")
	public ModelAndView popUpItemTransUserSearch(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName("/etc/popUp" + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : standardInfoTransMainExcelPrint
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "standardInfoTransMainExcelPrint.do")
	public View standardInfoTransMainExcelPrint(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return standardInfoTransExcelService.standardInfoTransMainExcelPrint(commandMap, modelMap);
	}

	/**
	 * @메소드명 : standardInfoTransDetailExcelPrint
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 상세정보 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "standardInfoTransDetailExcelPrint.do")
	public View standardInfoTransDetailExcelPrint(CommandMap commandMap, Map<String, Object> modelMap)
			throws Exception {
		return standardInfoTransExcelService.standardInfoTransDetailExcelPrint(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : standardInfoTransDetailExcelPrintItem
	 * @날짜 : 2017. 4. 17.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 상세정보 엑셀 출력(ITEM 속성 업데이트)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "standardInfoTransDetailExcelPrintItem.do")
	public View standardInfoTransDetailExcelPrintItem(CommandMap commandMap, Map<String, Object> modelMap)
			throws Exception {
		return standardInfoTransExcelService.standardInfoTransDetailExcelPrintItem(commandMap, modelMap);
	}	

	/**
	 * @메소드명 : itemTransDownload
	 * @날짜 : 2016. 4. 18.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기준정보등록요청 첨부파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "itemTransDownload.do")
	public View itemTransDownload(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return standardInfoTransService.itemTransDownload(commandMap, modelMap);
	}

}

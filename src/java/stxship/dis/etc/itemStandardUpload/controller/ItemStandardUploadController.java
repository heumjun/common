package stxship.dis.etc.itemStandardUpload.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.etc.itemStandardUpload.service.ItemStandardUploadService;

/**
 * @파일명 : ItemStandardUploadController.java
 * @프로젝트 : DIMS
 * @날짜 : 2016. 9. 19.
 * @작성자 : 황성준
 * @설명
 * 
 * 		<pre>
 * 	부품표준서 업로드 관련 컨트롤러
 *     </pre>
 */
@Controller
public class ItemStandardUploadController extends CommonController {
	@Resource(name = "itemStandardUploadService")
	private ItemStandardUploadService itemStandardUploadService;
	
	/**
	 * @메소드명 : itemStandardUploadMain
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * itemStandardUploadMain 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardUploadMain.do")
	public ModelAndView itemStandardUploadMain(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : uscSelectBoxDataList
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * uscSelectBoxDataList 셀렉트 박스 공통
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "uscSelectBoxDataList.do")
	public @ResponseBody String uscSelectBoxDataList(CommandMap commandMap) throws Exception {
		return itemStandardUploadService.getSelectBoxDataList(commandMap);
	}
	
	/**
	 * @메소드명 : selectCatalogName
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 카탈로그 명 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectCatalogName.do")
	public @ResponseBody Map<String, Object> selectCatalogName(CommandMap commandMap) {
		return itemStandardUploadService.getDbDataOne(commandMap);
	}
	
	/**
	 * @메소드명 : selectCatalogRevNo
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * REV No 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectCatalogRevNo.do")
	public @ResponseBody Map<String, Object> selectCatalogRevNo(CommandMap commandMap) {
		return itemStandardUploadService.getDbDataOne(commandMap);
	}
	
	/**
	 * @메소드명 : selectRequestInfo
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청자 정보 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectRequestInfo.do")
	public @ResponseBody Map<String, Object> selectRequestInfo(CommandMap commandMap) {
		return itemStandardUploadService.getDbDataOne(commandMap);
	}
	
	/**
	 * @메소드명 : selectSeqId
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * Seq ID 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectSeqId.do")
	public @ResponseBody Map<String, Object> selectSeqId(CommandMap commandMap) {
		return itemStandardUploadService.getDbDataOne(commandMap);
	}
	
	/**
	 * @메소드명 : selectDeptList
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 부서 리스트 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectDeptList.do")
	public @ResponseBody Map<String, Object> selectDeptList(CommandMap commandMap) {
		return itemStandardUploadService.getDbDataOne(commandMap);
	}
	
	/**
	 * @메소드명 : insertFileUpLoadAction
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 파일 업로드 실행 및 데이터 DB 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "insertFileUpLoadAction.do")
	public @ResponseBody void insertFileUpLoadAction(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		Map<String, Object> rtnMap = itemStandardUploadService.insertFileUpLoad(commandMap, request);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write(DisJsonUtil.mapToJsonstring(rtnMap));
	}
	
	/**
	 * @메소드명 : itemStandardUploadAction
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 부품표준서 리스트 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemStandardUpload.do")
	public @ResponseBody Map<String, Object> itemStandardUploadAction(CommandMap commandMap) {
		return itemStandardUploadService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2016. 12. 6.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 부품표준서 확정 여부 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveItemStandardUpload.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return itemStandardUploadService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpItemStandardUploadUserAction
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청자 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemStandardUploadUser.do")
	public ModelAndView popUpItemStandardUploadUserAction(CommandMap commandMap) {
		//ModelAndView mav = new ModelAndView(DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		//mav.addAllObjects(commandMap.getMap());
		//return mav;
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : infoItemStandardUploadUserAction
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청자 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemStandardUploadUserList.do")
	public @ResponseBody Map<String, Object> infoItemStandardUploadUserAction(CommandMap commandMap) {
		return commonService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpItemStandardUploadDept
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청부서 팝업 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemStandardUploadDept.do")
	public ModelAndView popUpItemStandardUploadAction(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : infoItemStandardUploadDeptListAction
	 * @날짜 : 2016. 9. 19.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 요청부서 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemStandardUploadDeptList.do")
	public @ResponseBody Map<String, Object> infoItemStandardUploadDeptListAction(CommandMap commandMap) {
		return commonService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : sscAutoCompleteDwgNoList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 메인 도면 Auto Complete 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectCatalogList.do")
	public @ResponseBody String selectCatalogList(CommandMap commandMap) {
		return itemStandardUploadService.selectCatalogList(commandMap);
	}
	
}

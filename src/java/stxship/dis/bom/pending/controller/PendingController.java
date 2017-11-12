package stxship.dis.bom.pending.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.annotate.JsonIgnore;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.bom.pending.service.PendingService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisPageUtil;

@Controller
public class PendingController extends CommonController {
	
	/**
	 * Pending 서비스
	 */
	@Resource(name = "pendingService")
	private PendingService pendingService;


	/**
	 * @메소드명 : pendingMain
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 페이지 호출. 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pendingMain.do")
	public ModelAndView pendingMain(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * @메소드명 : pendingList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트 결과.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingList.do")
	@JsonIgnore
	public @ResponseBody Map<String, Object> pendingMainList(CommandMap commandMap) throws Exception {
		return pendingService.pendingMainList(commandMap);
	}
	
	/**
	 * @메소드명 : pendingExcelExport
	 * @날짜 : 2016. 09. 28.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트 결과 Excel 다운로드
	 * @param commandMap
	 * @return
	 * @throws Exception
	 * 
	 */
	@RequestMapping(value = "pendingExport.do")
	public View pendingExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return pendingService.pendingExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : pendingAutoCompleteDwgNoList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인화면에서 부서에 해당하는 도면리스트 
	 * 		  ARK(Auto Recommand Keyword) 반환.
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pendingAutoCompleteDwgNoList.do")
	public @ResponseBody String pendingAutoCompleteDwgNoList(CommandMap commandMap) {
		return pendingService.selectAutoCompleteDwgNoList(commandMap);
	}
	
	/**
	 * @메소드명 : popupPendingWorkMain
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트에서 WORK 클릭시 팝업 창 호출.
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupPendingWorkMain.do")
	public ModelAndView popupPendingWorkMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("/bom/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : popupPendingWorkList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending 메인 리스트에서 WORK 클릭시 SSC-Bom 내용 리스트 반환.
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupPendingWorkList.do")
	public @ResponseBody Map<String, Object> popupPendingWorkList(CommandMap commandMap) throws Exception {
		return pendingService.popupPendingWorkList(commandMap);
	}
	
	/**
	 * @메소드명 : pendingAddMain
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 페이지 호출
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "pendingAddMain.do")
	public ModelAndView pendingAddMain(CommandMap commandMap) throws Exception {
		pendingService.pendingDeleteTemp(commandMap);
		commandMap.put("p_master_no", pendingService.pendingMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : pendingAddList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 리스트 결과.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingAddList.do")
	public @ResponseBody Map<String, Object> pendingAddList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = new ArrayList<Map<String, Object>>();
		
		if(!commandMap.get("p_arrDistinct").toString().equals("") && commandMap.get("p_arrDistinct").toString() != null) {
			
			for(int i=0; i< commandMap.get("p_arrDistinct").toString().split(",").length; i++) {
				
				Map<String, Object> temp = new HashMap<String, Object>();
				
				String attr = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[5];		
				if(attr.equals("NULL")) {
					attr = "";
				}
				
				temp.put("ship_type", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[0]);
				temp.put("project_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[1]);
				temp.put("block_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[2]);
				temp.put("str_flag", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[3]);
				temp.put("job_catalog", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[4]);
				temp.put("usc_job_type", attr);
				temp.put("mode", "D");
				temp.put("oper", "I");
				
				listData.add(temp);
			}
		}
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
	}
	
	/**
	 * @메소드명 : getDwgnoList
	 * @날짜 : 2016. 12. 27.
	 * @작성자 : HeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 * 	SELECT DWG_NO LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDwgNoList.do")
	public @ResponseBody String getDwgNoList(CommandMap commandMap) throws Exception {
		return pendingService.getDwgnoList(commandMap);
	}
	
	/**
	 * @메소드명 : pendingAddGetDwgno
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : pending-ADD DWG 클릭 시 Popup 화면 호출
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popupPendingAddGetDwgno.do")
	public ModelAndView popupPendingAddGetDwgno(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("/bom/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : popupPendingAddGetDwgnoList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : popupPendingAddGetDwgno 화면에서 도면리스트 반환.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popupPendingAddGetDwgnoList.do")
	public @ResponseBody Map<String, Object> popupPendingAddGetDwgnoList(CommandMap commandMap) throws Exception {
		return pendingService.popupPendingAddGetDwgnoList(commandMap);
	}
	
	/**
	 * @메소드명 : pendingAddWorkingExcelImport
	 * @날짜 : 2016. 09. 28.
	 * @작성자 : Cho HeumJun
	 * @설명 : Excel Import 페이지로 이동
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pendingAddWorkExcelImport.do")
	public ModelAndView pendingAddWorkingExcelImport(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				"bom/" + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : pendingAddWorkExcelImportAction
	 * @날짜 : 2016. 09. 28.
	 * @작성자 : Cho HeumJun
	 * @설명 : pending-ADD 메인Grid에 Excel Import 실행.
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pendingAddWorkExcelImportAction.do")
	public void sscAddExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
				
		commandMap.put("file", DecryptFile);
		List<Map<String, Object>> list = pendingService.pendingAddWorkExcelImportAction(commandMap);
		
		//복화화된 파일 삭제
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		response.setContentType("text/html;charset=UTF-8"); 
		//response.setCharacterEncoding("UTF-8");
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
		
	}
	
	/**
	 * @메소드명 : pendingWorkInsert
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 pending_work TempTable에 Insert.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingWorkInsert.do")
	public @ResponseBody Map<String, Object> pendingWorkInsert(CommandMap commandMap) throws Exception {
		return pendingService.pendingWorkInsert(commandMap);
	}
	
	/**
	 * @메소드명 : pendingNextAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 TempTable 리스트 반환.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingNextAction.do")
	public @ResponseBody Map<String, Object> pendingNextAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingNextAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingWorkDelete
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 DELETE2 클릭 시 TempTable 데이터 삭제
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingWorkDelete.do")
	public @ResponseBody Map<String, Object> pendingWorkDelete(CommandMap commandMap) throws Exception {
		return pendingService.pendingWorkDelete(commandMap);
	}
	
	/**
	 * @메소드명 : pendingApplyAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-ADD 화면에서 Apply시 Pending 생성.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingApplyAction.do")
	public @ResponseBody Map<String, Object> pendingApplyAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingDelMain
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 페이지 호출
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "pendingDelMain.do")
	public ModelAndView pendingDelMain(CommandMap commandMap) throws Exception {
		pendingService.pendingDeleteTemp(commandMap);
		commandMap.put("p_master_no", pendingService.pendingMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : pendingDelList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 리스트 결과.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingDelList.do")
	public @ResponseBody Map<String, Object> pendingDelList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = new ArrayList<Map<String, Object>>();
		
		if(!commandMap.get("p_arrDistinct").toString().equals("") && commandMap.get("p_arrDistinct").toString() != null) {
			
			for(int i=0; i< commandMap.get("p_arrDistinct").toString().split(",").length; i++) {
				
				Map<String, Object> temp = new HashMap<String, Object>();
				
				String attr = commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[7];		
				if(attr.equals("NULL")) {
					attr = "";
				}
				
				temp.put("ship_type", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[0]);
				temp.put("project_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[1]);
				temp.put("block_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[2]);
				temp.put("str_flag", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[3]);
				temp.put("job_catalog", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[4]);
				temp.put("dwg_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[5]);
				temp.put("stage_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[6]);
				temp.put("usc_job_type", attr);
				temp.put("mode", "D");
				temp.put("oper", "I");
				
				listData.add(temp);
			}
		}
		
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		// 라스트 페이지를 구한다.
		Object lastPageCnt = "page>total";
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			lastPageCnt = DisPageUtil.getPageCount(pageSize, listRowCnt);
		}
		
		// 결과값 생성
		Map<String, Object> result = new HashMap<String, Object>();
		result.put(DisConstants.GRID_RESULT_CUR_PAGE, curPageNo);
		result.put(DisConstants.GRID_RESULT_LAST_PAGE, lastPageCnt);
		result.put(DisConstants.GRID_RESULT_RECORDS_CNT, listRowCnt);
		result.put(DisConstants.GRID_RESULT_DATA, listData);
		
		return result;
	}
	
	/**
	 * @메소드명 : pendingDelWorkInsert
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 화면에서 pending_work TempTable에 Insert.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingDelWorkInsert.do")
	public @ResponseBody Map<String, Object> pendingDelWorkInsert(CommandMap commandMap) throws Exception {
		return pendingService.pendingDelWorkInsert(commandMap);
	}
	
	/**
	 * @메소드명 : pendingDelNextAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 화면에서 pending_work TempTable에 Insert.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingDelNextAction.do")
	public @ResponseBody Map<String, Object> pendingDelNextAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingDelNextAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingDelApplyAction
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : Pending-DELETE 화면에서 Apply시 Pending 삭제.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingDelApplyAction.do")
	public @ResponseBody Map<String, Object> pendingDelApplyAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingDelApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingModifyMain
	 * @날짜 : 2016. 12. 01.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Modify Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pendingModifyMain.do")
	public ModelAndView pendingModifyMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", pendingService.pendingMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : pendingModifyList
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * PENDING MODIFY MAIN LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingChekedMainList.do")
	public @ResponseBody Map<String, Object> pendingChekedMainList(CommandMap commandMap) throws Exception {
		return pendingService.pendingChekedMainList(commandMap);
	}
	
	/**
	 * @메소드명 : pendingModifyValidationCheck
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	pending Modify Validataion 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingModifyValidationCheck.do")
	public @ResponseBody Map<String, Object> pendingModifyValidationCheck(CommandMap commandMap) throws Exception {
		return pendingService.pendingModifyValidationCheck(commandMap);
	}
	
	/**
	 * @메소드명 : pendingWorkValidationList
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		Next 버튼 1 Validation 리스트
	 *		1. ADD 
	 *		2. Modify
	 *		3. Delete 
	 *		4. BOM 연계
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingWorkValidationList.do")
	public @ResponseBody Map<String, Object> pendingWorkValidationList(CommandMap commandMap) throws Exception {
		return pendingService.pendingWorkValidationList(commandMap);
	}
	
	/**
	 * @메소드명 : pendingModifyApplyAction
	 * @날짜 : 2016. 1. 18.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Modify Apply 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingModifyApplyAction.do")
	public @ResponseBody Map<String, Object> sscModifyApplyAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingModifyApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingBomMain
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC BOM Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pendingBomMain.do")
	public ModelAndView sscBomMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", pendingService.pendingMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : pendingBomApplyAction
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	BOM Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingBomApplyAction.do")
	public @ResponseBody Map<String, Object>pendingBomApplyAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingBomApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingCancelAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PENDING MAIN CANCEL ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingCancelAction.do")
	public @ResponseBody Map<String, Object> pendingCancelAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingCancelAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingRestoreAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	PENDING MAIN RESTORE ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingRestoreAction.do")
	public @ResponseBody Map<String, Object> pendingRestoreAction(CommandMap commandMap) throws Exception {
		return pendingService.pendingRestoreAction(commandMap);
	}
	
	/**
	 * @메소드명 : pendingDeleteTemp
	 * @날짜 : 2016. 12. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	ADD, DELETE 버튼 클릭 시 TEMP 테이블 비움
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "pendingDeleteTemp.do")
	public @ResponseBody Map<String, Object> pendingDeleteTemp(CommandMap commandMap) throws Exception {
		return pendingService.pendingDeleteTemp(commandMap);
	}		
}

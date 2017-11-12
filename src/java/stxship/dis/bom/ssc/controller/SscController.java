package stxship.dis.bom.ssc.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.google.gson.Gson;

import stxship.dis.bom.ssc.service.SscService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisPageUtil;

/**
 * @파일명 : SscController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 21.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 	TBC SSC Controller
 *     </pre>
 */
@Controller
public class SscController extends CommonController {
	Logger				log	= Logger.getLogger(this.getClass());

	@Resource(name = "sscService")
	private SscService	sscService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 		sscMain 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscMain.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {

		if (commandMap.get("p_item_type_cd").equals("PA")) {
			commandMap.put("p_dwg_no", sscService.sscPaintDwgNo(commandMap));
		}
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "dwgPopupView.do")
	public ModelAndView dwgPopupView(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		ModelAndView mav = new ModelAndView("bom/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		commandMap.put("p_file_name", commandMap.get("p_file_name"));
		
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	
	@RequestMapping(value = "dwgPopupViewList.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String dwgPopupViewList(CommandMap commandMap) throws Exception {
		return sscService.dwgPopupViewList(commandMap);
	}		

	/**
	 * @메소드명 : sscMainList
	 * @날짜 : 2015. 12. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscMainList.do")
	public @ResponseBody Map<String, Object> sscMainList(CommandMap commandMap) throws Exception {
		return sscService.selectMainList(commandMap);
	}

	/**
	 * @메소드명 : sscMainExcelExport
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 		메인 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscMainExcelExport.do", produces="text/plain;charset=UTF-8")
	public View sscMainExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return sscService.sscMainExcelExport(commandMap, modelMap);
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
	@RequestMapping(value = "sscAutoCompleteDwgNoList.do")
	public @ResponseBody String sscAutoCompleteDwgNoList(CommandMap commandMap) {
		return sscService.selectAutoCompleteDwgNoList(commandMap);
	}
	
	/**
	 * @메소드명 : sscAutoCompleteUscJobTypeList
	 * @날짜 : 2017. 03. 20.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 메인 USC_JOB_TYPE Auto Complete 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAutoCompleteUscJobTypeList.do")
	public @ResponseBody String sscAutoCompleteUscJobTypeList(CommandMap commandMap) {
		return sscService.sscAutoCompleteUscJobTypeList(commandMap);
	}

	/**
	 * @메소드명 : sscGetJobCodeList
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 	SELECT BOX JOB LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscGetJobCodeList.do")
	public @ResponseBody List<Map<String, Object>> sscGetJobCodeList(CommandMap commandMap) throws Exception {
		return sscService.sscJobList(commandMap);
	}

	/**
	 * @메소드명 : sscAddMain
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC Add Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscAddMain.do")
	public ModelAndView sscAddMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", sscService.sscMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : sscAddList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : ssc-ADD 리스트 결과.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddList.do")
	public @ResponseBody Map<String, Object> sscAddList(CommandMap commandMap) throws Exception {
		
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
				
				temp.put("master_ship", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[0]);
				temp.put("dwg_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[1]);
				temp.put("block_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[2]);
				temp.put("stage_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[3]);
				temp.put("str_flag", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[4]);
				temp.put("usc_job_type", attr);
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
	 * @메소드명 : sscCommonSeriesCheckBox
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	시리즈 호선 선택하는 페이지
	 *	1. ADD Main 화면 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscCommonSeriesCheckBox.do")
	public @ResponseBody ModelAndView sscCommonSeriesCheckBox(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/common/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addObject("seriesList", sscService.sscSeriesList(commandMap));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscCommonRevTextBox
	 * @날짜 : 2015. 12. 23.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Rev TextBox 페이지
	 *  1. ADD Main 화면 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscCommonRevTextBox.do")
	public @ResponseBody ModelAndView sscCommonRevTextBox(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/common/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addObject("revNo", sscService.sscRevText(commandMap));
		return mav;
	}

	/**
	 * @메소드명 : sscItemAddMainCheck
	 * @날짜 : 2015. 12. 28.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Next 1 : Validation 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddValidationCheck.do")
	public @ResponseBody Map<String, Object> sscAddValidationCheck(CommandMap commandMap) throws Exception {
		return sscService.sscAddValidationCheck(commandMap);
	}
	
	@RequestMapping(value = "sscAddValidationCheckStage.do")
	public @ResponseBody Map<String, Object> sscAddValidationCheckStage(CommandMap commandMap) throws Exception {
		return sscService.sscAddValidationCheckStage(commandMap);
	}

	/**
	 * @메소드명 : sscAddValidationList
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
	@RequestMapping(value = "sscWorkValidationList.do")
	public @ResponseBody Map<String, Object> sscAddValidationList(CommandMap commandMap) throws Exception {
		return sscService.sscWorkValidationList(commandMap);
	}

	/**
	 * @메소드명 : sscAddBackList
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Next1 이후 BACK 버튼을 이용해서 첫 화면으로 돌아갈 때 사용
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddBackList.do")
	public @ResponseBody List<Map<String, Object>> sscAddBackList(CommandMap commandMap) throws Exception {
		return sscService.sscAddBackList(commandMap);
	}

	/**
	 * @메소드명 : sscAddItemCreate
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		Next 버튼 2 아이템 채번
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddItemCreate.do")
	public @ResponseBody Map<String, Object> sscAddItemCreate(CommandMap commandMap) throws Exception {
		return sscService.sscAddItemCreate(commandMap);
	}

	/**
	 * @메소드명 : sscAddApplyAction
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	ADD Apply 버튼 클릭 시
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddApplyAction.do")
	public @ResponseBody Map<String, Object> sscAddApplyAction(CommandMap commandMap) throws Exception {
		return sscService.sscAddApplyAction(commandMap);
	}

	/**
	 * @메소드명 : linksscAddTribonInterfaceMain
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Tribon 클릭 시 화면 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscAddTribonInterfaceMain.do")
	public ModelAndView linksscAddTribonInterfaceMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscAddEmsInterfaceMain
	 * @날짜 : 2016. 3. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS 클릭 시 화면 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscAddEmsInterfaceMain.do")
	public ModelAndView sscAddEmsInterfaceMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscAddTribonMainList
	 * @날짜 : 2016. 1. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	TRIBON MAIN LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddTribonMainList.do")
	public @ResponseBody Map<String, Object> sscAddTribonMainList(CommandMap commandMap) throws Exception {
		return sscService.sscAddTribonMainList(commandMap);
	}

	/**
	 * @메소드명 : sscAddEmsMainList
	 * @날짜 : 2016. 3. 7.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS Main List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddEmsMainList.do")
	public @ResponseBody Map<String, Object> sscAddEmsMainList(CommandMap commandMap) throws Exception {
		return sscService.sscAddEmsMainList(commandMap);
	}

	/**
	 * @메소드명 : sscAddTribonTransferList
	 * @날짜 : 2016. 1. 12.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Tribon Transfer List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddTribonTransferList.do")
	public @ResponseBody List<Map<String, Object>> sscAddTribonTransferList(CommandMap commandMap) throws Exception {
		return sscService.sscAddTribonTransferList(commandMap);
	}

	/**
	 * @메소드명 : sscAddEmsTransferList
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EMS Transfer List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddEmsTransferList.do")
	public @ResponseBody List<Map<String, Object>> sscAddEmsTransferList(CommandMap commandMap) throws Exception {
		return sscService.sscAddEmsTransferList(commandMap);
	}

	/**
	 * @메소드명 : excelImport
	 * @날짜 : 2016. 1. 13.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EXCEL IMPORT 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpSscAddExcelImport.do")
	public ModelAndView excelImport(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/bom/popUp/popUpSscAddExcelImport");
		return mv;
	}

	/**
	 * @메소드명 : sscAddExcelImportAction
	 * @날짜 : 2016. 1. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 업로드
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAddExcelImportAction.do")
	public void sscAddExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		commandMap.put("file", DecryptFile);
		//암호화 복호화 파일업로드 적용 해지
		//commandMap.put("file", file);
		
		List<Map<String, Object>> list = sscService.sscAddExcelImportAction(commandMap);
		
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
//		String jsonArray = new Gson().toJson(list);
//		System.out.println(jsonArray);
//		String json = "{'rows':" + jsonArray + "}";
//		response.getWriter().write(json);
		
		//ITEM CODE가 입력된 경우 속성값 비활성 조치
		String itemTypeCd = (String) commandMap.get("p_item_type_cd");
		if(itemTypeCd.equals("SU")){
			for(int i=0; i<list.size(); i++){
				if(!list.get(i).get("column4").equals("")){
					list.get(i).put("column5", "");
					list.get(i).put("column7", "");
					list.get(i).put("column8", "");
					list.get(i).put("column9", "");
					list.get(i).put("column10", "");
				}
			}
		}else if(itemTypeCd.equals("OU")){
			for(int i=0; i<list.size(); i++){
				if(!list.get(i).get("column4").equals("")){
					list.get(i).put("column5", "");
					list.get(i).put("column7", "");
					list.get(i).put("column9", "");
				}
			}
		}else if(itemTypeCd.equals("SE")){
			for(int i=0; i<list.size(); i++){
				if(!list.get(i).get("column4").equals("")){
					list.get(i).put("column5", "");
					list.get(i).put("column8", "");
					list.get(i).put("column9", "");
					list.get(i).put("column11", "");
					list.get(i).put("column12", "");
				}
			}
		}else if(itemTypeCd.equals("TR")){
			for(int i=0; i<list.size(); i++){
				if(!list.get(i).get("column4").equals("")){
					list.get(i).put("column5", "");
					list.get(i).put("column8", "");
					list.get(i).put("column10", "");
					list.get(i).put("column11", "");
				}
			}
		}else if(itemTypeCd.equals("CA")){
			for(int i=0; i<list.size(); i++){
				if(!list.get(i).get("column4").equals("")){
					list.get(i).put("column5", "");
					list.get(i).put("column6", "");
					list.get(i).put("column8", "");
				}
			}
		}
		
		response.setContentType("text/html;charset=utf-8");
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}

	/**
	 * @메소드명 : sscModifyMain
	 * @날짜 : 2016. 1. 14.
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
	@RequestMapping(value = "sscModifyMain.do")
	public ModelAndView sscModifyMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", sscService.sscMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscModifyList
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC MODIFY MAIN LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscChekedMainList.do")
	public @ResponseBody Map<String, Object> sscChekedMainList(CommandMap commandMap) throws Exception {
		return sscService.sscChekedMainList(commandMap);
	}

	/**
	 * @메소드명 : sscModifyValidationCheck
	 * @날짜 : 2016. 1. 15.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	ssc Modify Validataion 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscModifyValidationCheck.do")
	public @ResponseBody Map<String, Object> sscModifyValidationCheck(CommandMap commandMap) throws Exception {
		return sscService.sscModifyValidationCheck(commandMap);
	}

	/**
	 * @메소드명 : sscModifyApplyAction
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
	@RequestMapping(value = "sscModifyApplyAction.do")
	public @ResponseBody Map<String, Object> sscModifyApplyAction(CommandMap commandMap) throws Exception {
		return sscService.sscModifyApplyAction(commandMap);
	}

	/**
	 * @메소드명 : sscDeleteMain
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC DELETE MAIN LIST
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscDeleteMain.do")
	public ModelAndView sscDeleteMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", sscService.sscMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscDeleteValidationCheck
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Delete Validation CHecked
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscDeleteValidationCheck.do")
	public @ResponseBody Map<String, Object> sscDeleteValidationCheck(CommandMap commandMap) throws Exception {
		return sscService.sscDeleteValidationCheck(commandMap);
	}

	/**
	 * @메소드명 : sscDeleteApplyAction
	 * @날짜 : 2016. 1. 19.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Delete Apply
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscDeleteApplyAction.do")
	public @ResponseBody Map<String, Object> sscDeleteApplyAction(CommandMap commandMap) throws Exception {
		return sscService.sscDeleteApplyAction(commandMap);
	}

	/**
	 * @메소드명 : sscBomMain
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
	@RequestMapping(value = "sscBomMain.do")
	public ModelAndView sscBomMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", sscService.sscMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscBomApplyAction
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
	@RequestMapping(value = "sscBomApplyAction.do")
	public @ResponseBody Map<String, Object> sscBomApplyAction(CommandMap commandMap) throws Exception {
		return sscService.sscBomApplyAction(commandMap);
	}
	
	/**
	 * @메소드명 : sscAllBomApplyAction
	 * @날짜 : 2016. 11. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	ALL BOM Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAllBomApplyAction.do")
	public @ResponseBody Map<String, Object> sscAllBomApplyAction(CommandMap commandMap) throws Exception {
		return sscService.sscAllBomApplyAction(commandMap);
	}

	/**
	 * @메소드명 : sscRestoreAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC MAIN RESTORE ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscRestoreAction.do")
	public @ResponseBody Map<String, Object> sscRestoreAction(CommandMap commandMap) throws Exception {
		return sscService.sscRestoreAction(commandMap);
	}
	
	/**
	 * @메소드명 : sscCancelAction
	 * @날짜 : 2016. 1. 20.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC MAIN CANCEL ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscCancelAction.do")
	public @ResponseBody Map<String, Object> sscCancelAction(CommandMap commandMap) throws Exception {
		return sscService.sscCancelAction(commandMap);
	}

	/**
	 * @메소드명 : sscCableTypeMain
	 * @날짜 : 2016. 2. 3.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC Cable Type Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscCableTypeMain.do")
	public ModelAndView sscCableTypeMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscCableTypeMainList
	 * @날짜 : 2016. 2. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Cable Type List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscCableTypeMainList.do")
	public @ResponseBody Map<String, Object> sscCableTypeMainList(CommandMap commandMap) throws Exception {
		return sscService.sscCableTypeMainList(commandMap);
	}

	/**
	 * @메소드명 : sscCableTypeSaveAction
	 * @날짜 : 2016. 2. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Cable Type Save
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscCableTypeSaveAction.do")
	public @ResponseBody Map<String, Object> sscCableTypeSaveAction(CommandMap commandMap) throws Exception {
		return sscService.sscCableTypeSaveAction(commandMap);
	}

	/**
	 * @메소드명 : sscCableTypeSaveAction
	 * @날짜 : 2016. 2. 5.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */

	@RequestMapping(value = "sscCableTypeExcelExport.do")
	public View sscCableTypeExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return sscService.sscCableTypeExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : popUpSscCableTypeExcelImport
	 * @날짜 : 2016. 1. 13.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EXCEL IMPORT 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpSscCableTypeExcelImport.do")
	public ModelAndView popUpSscCableTypeExcelImport(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/bom/popUp/popUpSscCableTypeExcelImport");
		return mv;
	}
	
	/**
	 * @메소드명 : sscAddExcelImportAction
	 * @날짜 : 2016. 1. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 업로드
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscCableTypeExcelImportAction.do")
	public void sscCableTypeExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		commandMap.put("file", file);
		List<Map<String, Object>> list = sscService.sscCableTypeExcelImportAction(commandMap);
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}

	/**
	 * @메소드명 : sscStructureMain
	 * @날짜 : 2016. 2. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Outfitting Structure Main List
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscStructureMain.do")
	public ModelAndView sscStructureMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscCableTypeMainList
	 * @날짜 : 2016. 2. 11.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscStructureList.do")
	public @ResponseBody Map<String, Object> sscStructureList(CommandMap commandMap) throws Exception {
		return sscService.sscStructureList(commandMap);
	}

	/**
	 * @메소드명 : sscAfterInfoMain
	 * @날짜 : 2016. 3. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	After Info Main 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscAfterInfoMain.do")
	public ModelAndView sscAfterInfoMain(CommandMap commandMap) throws Exception {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));

		commandMap.put("afterInfo", sscService.sscAfterInfoList(commandMap));

		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscAfterInfoSaveAction
	 * @날짜 : 2016. 3. 16.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	ssc After Info Save
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscAfterInfoSaveAction.do")
	public @ResponseBody Map<String, Object> sscAfterInfoSaveAction(CommandMap commandMap) throws Exception {
		return sscService.sscAfterInfoSaveAction(commandMap);
	}

	/**
	 * @메소드명 : sscMainSaveAction
	 * @날짜 : 2016. 3. 21.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscMainSaveAction.do")
	public @ResponseBody Map<String, Object> sscMainSaveAction(CommandMap commandMap) throws Exception {
		return sscService.sscMainSaveAction(commandMap);
	}

	// sscDwgNoSelectBoxDataList.do

	// @RequestMapping(value="sscMainList.do")

	// public ModelAndView sscMainList(CommandMap commandMap) throws Exception{
	// ModelAndView mv = new ModelAndView("/bom/sscMainList");
	//
	// List<Map<String,Object>> list =
	// sscService.selectMainList(commandMap.getMap());
	// mv.addObject("list", list);
	//
	// return mv;
	// }
	//
	// @RequestMapping(value="sscMainTotal.do")
	// public ModelAndView sscMainTotal(CommandMap commandMap) throws Exception{
	// return new ModelAndView("/bom/sscMainTotal");
	// }
	//
	// /*
	// * 프로시저 SELECT 호출 JSON 형태로 리턴
	// * */
	// @RequestMapping(value="sscMainTotalList.do")
	// public @ResponseBody List<Map<String,Object>> sscMainTotalList(CommandMap
	// commandMap) throws Exception{
	// Map<String,Object> map = commandMap.getMap();
	// sscService.selectMainTotalList(map);
	// return (List<Map<String,Object>>)map.get("result");
	// }
	//
	//
	// /*
	// * 일반 쿼리로 Select 호출 JSON 형태로 리턴
	// * */
	// @RequestMapping(value="/bom/sscMainTotalList.do")
	// public @ResponseBody List<Map<String,Object>> sscMainTotalList(CommandMap
	// commandMap) throws Exception{
	// return sscService.selectMainList(commandMap.getMap());
	// }
	
	
	/**
	 * @메소드명 : sscMainTotal
	 * @날짜 : 2016. 11. 08.
	 * @작성자 : Cho HeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC Main Total
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscMainTotal.do")
	public ModelAndView sscMainTotal(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : sscMainTotalList
	 * @날짜 : 2016. 11. 08.
	 * @작성자 : Cho HeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 *	SSC TOTAL 메인 리스트 호출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscMainTotalList.do")
	public @ResponseBody Map<String, Object> sscMainTotalList(CommandMap commandMap) throws Exception {
		return sscService.selectMainTotalList(commandMap);
	}
	
	/**
	 * @메소드명 : sscMainTotalExcelExport
	 * @날짜 : 2016. 11. 08.
	 * @작성자 : Cho HeumJun
	 * @설명 :
	 * 
	 *     <pre>
	 * 		SSC TOTAL 메인 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscMainTotalExcelExport.do")
	public View sscMainTotalExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return sscService.sscMainTotalExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : popUpSscAllBom
	 * @날짜 : 2016. 11. 16.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpSscAllBom 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpSscAllBom.do")
	public ModelAndView popUpDelegateProjectNo(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 11. 18.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 		ssc BOM현황 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBomStatus.do")
	public ModelAndView linkSelectedMenu1(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		return mav;
	}
	
	
	/**
	 * @메소드명 : sscItemAddStageSetting
	 * @날짜 : 2016. 11. 29.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 *	sscItemAddStageSetting 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscItemAddStageSetting.do")
	public ModelAndView sscItemAddStageSetting(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	@RequestMapping(value = "sscItemAddStageGetMother.do")
	public @ResponseBody Map<String, Object> sscItemAddStageGetMother(CommandMap commandMap) throws Exception {
		return sscService.sscItemAddStageGetMother(commandMap);
	}
	
	/**
	 * @메소드명 : sscTribonInterfaceDelete
	 * @날짜 : 2017. 1. 4.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	팝업 PI TRIBON 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscTribonInterfaceDelete.do")
	public @ResponseBody Map<String, Object> sscTribonInterfaceDelete(CommandMap commandMap) throws Exception {
		return sscService.sscTribonInterfaceDelete(commandMap);
	}
	
	/**
	 * @메소드명 : getCatalogDesign
	 * @날짜 : 2016. 12. 05.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Catalog Mgnt 설계정보 TRAY EA = Y 카운트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getCatalogDesign.do")
	public @ResponseBody Map<String, Object> getCatalogDesign(CommandMap commandMap) throws Exception {
		return sscService.getCatalogDesign(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMain
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	Buy Buy Main 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyMain.do")
	public ModelAndView sscBuyBuyMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : sscBuyBuyMainList
	 * @날짜 : 2017. 2. 1.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyMainList.do")
	public @ResponseBody Map<String, Object> sscBuyBuyMainList(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyMainList(commandMap);
	}
	
	/**
	 * @메소드명 : getSscDescription
	 * @날짜 : 2017. 2. 6.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 desc, project 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "getSscDescription.do")
	public @ResponseBody Map<String, Object> getSscDescription(CommandMap commandMap) throws Exception {
		return sscService.getSscDescription(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainDelete
	 * @날짜 : 2017. 2. 6.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Delete
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyMainDelete.do")
	public @ResponseBody Map<String, Object> sscBuyBuyMainDelete(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyMainDelete(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainRestore
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Restore
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyMainRestore.do")
	public @ResponseBody Map<String, Object> sscBuyBuyMainRestore(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyMainRestore(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainCancel
	 * @날짜 : 2017. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Buy Buy Main 화면 Cancel
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyMainCancel.do")
	public @ResponseBody Map<String, Object> sscBuyBuyMainCancel(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyMainCancel(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyMainSave
	 * @날짜 : 2016. 3. 10.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy Save Action
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyMainSave.do")
	public @ResponseBody Map<String, Object> sscBuyBuyMainSave(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyMainSave(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddMain
	 * @날짜 : 2017. 2. 1.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC BUY-BUY Add Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyAddMain.do")
	public ModelAndView sscBuyBuyAddMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", sscService.sscMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddNext.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD NE
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyAddNext.do")
	public @ResponseBody Map<String, Object> sscBuyBuyAddNext(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyAddNext(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddBack.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD Back
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyAddBack.do")
	public @ResponseBody Map<String, Object> sscBuyBuyAddBack(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyAddBack(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddApply.do
	 * @날짜 : 2016. 2. 7.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD ACTION
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyAddApply.do")
	public @ResponseBody Map<String, Object> sscBuyBuyAddApply(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyAddApply(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyBomMain
	 * @날짜 : 2017. 2. 1.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * SSC BUY-BUY Add Main
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscBuyBuyBomMain.do")
	public ModelAndView sscBuyBuyBomMain(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		commandMap.put("p_master_no", sscService.sscMasterNo(commandMap));
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.MAPPER_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : sscBuyBuyBomList
	 * @날짜 : 2016. 09. 27.
	 * @작성자 : Cho HeumJun
	 * @설명 : ssc-ADD 리스트 결과.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyBomList.do")
	public @ResponseBody Map<String, Object> sscBuyBuyBomList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		
		List<Map<String, Object>> listData = new ArrayList<Map<String, Object>>();
		
		if(!commandMap.get("p_arrDistinct").toString().equals("") && commandMap.get("p_arrDistinct").toString() != null) {
			
			for(int i=0; i< commandMap.get("p_arrDistinct").toString().split(",").length; i++) {
				
				Map<String, Object> temp = new HashMap<String, Object>();
				temp.put("ssc_sub_id", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[0]);
				temp.put("state_flag", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[1]);
				temp.put("project_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[2]);
				temp.put("dwg_no", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[3]);
				temp.put("item_code", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[4]);
				temp.put("item_desc", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[5]);
				temp.put("ea", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[6]);
				temp.put("item_weight", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[7]);
				temp.put("supply_type", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[8]);
				temp.put("modify_date", commandMap.get("p_arrDistinct").toString().split(",")[i].split("@")[9]);
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
	 * @메소드명 : popUpSscBuyBuyAddExcelImport
	 * @날짜 : 2017. 2. 8.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *	EXCEL IMPORT 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpSscBuyBuyAddExcelImport.do")
	public ModelAndView sscBuyBuyExcelImport(CommandMap commandMap) {
		ModelAndView mv = new ModelAndView("/bom/popUp/popUpSscBuyBuyAddExcelImport");
		return mv;
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddExcelImportAction
	 * @날짜 : 2017. 2. 8.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *		BUY-BUY 엑셀 업로드
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyAddExcelImportAction.do")
	public void sscBuyBuyAddExcelImportAction(@RequestParam(value = "fileName") MultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception {
		commandMap.put("file", file);
		List<Map<String, Object>> list = sscService.sscBuyBuyAddExcelImportAction(commandMap);
		response.getWriter().write(DisJsonUtil.listToJsonstring(list));
	}
	
	/**
	 * @메소드명 : sscBuyBuyDwgNoList
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 그리드 DWG NO.칼럼 SELECT BOX
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyDwgNoList.do")
	public @ResponseBody List<Map<String, Object>> sscBuyBuyDwgNoList(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyDwgNoList(commandMap);
	}
	
	/**
	 * @메소드명 : sscBuyBuyAddGetItemDesc.do
	 * @날짜 : 2017. 2. 9.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	BuyBuy ADD 그리드 내 ITEM DESC 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "sscBuyBuyAddGetItemDesc.do")
	public @ResponseBody Map<String, Object> sscBuyBuyAddGetItemDesc(CommandMap commandMap) throws Exception {
		return sscService.sscBuyBuyAddGetItemDesc(commandMap);
	}
	
	/**
	 * @메소드명 : getDeliverySeries.do
	 * @날짜 : 2017. 3. 22.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	해당 호선의 시리즈 중에서 Delivery 시리즈 리스트를 가져옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDeliverySeries.do")
	public @ResponseBody List<Map<String, Object>> getDeliverySeries(CommandMap commandMap) throws Exception {
		return sscService.getDeliverySeries(commandMap);
	}
	
	/**
	 * @메소드명 : sscHistoryMain
	 * @날짜 : 2017. 06. 07.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		sscHistoryMain 페이지
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscHistoryMain.do")
	public ModelAndView sscHistoryMain(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * @메소드명 : sscHistoryMainList
	 * @날짜 : 2017. 06. 08.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 		sscHistoryMain 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "sscHistoryMainList.do")
	public @ResponseBody Map<String, Object> sscHistoryMainList(CommandMap commandMap) throws Exception {
		return sscService.getGridList(commandMap);
	}
	
}

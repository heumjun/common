package stxship.dis.dps.dwgRegister.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.dwgRegister.service.DwgRegisterService;

/**
 * 
 * @파일명	: DwgRegistorController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 7. 27. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * Drawing Distribution History Search and Register 컨트롤러 
 * </pre>
 */
@Controller
public class DwgRegistorController extends CommonController{
	
	@Resource(name="dwgRegisterService")
	public DwgRegisterService dwgRegistorService;
	
	/**
	 * 
	 * @메소드명	: stxPECDPProgressDeviation
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	공정 지연현황 조회(DIS) 헤더
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "stxPECDPDwgRegister.do")
	public ModelAndView stxPECDPDwgRegister(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dwgRegister" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dwgRegistorService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> personsList = null;
		List<Map<String,Object>> projectList = null;
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerID", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			projectList = dwgRegistorService.getAllProjectList();
			departmentList = dwgRegistorService.getDepartmentList();
			personsList = dwgRegistorService.getPartPersons(loginUserInfo);
			
		} else {
			loginUserInfo = dwgRegistorService.getEmployeeInfoDalian(param);
			if (loginUserInfo != null) 
            {
				
				projectList = dwgRegistorService.getProgressSearchableProjectList_Dalian(param);
				departmentList = dwgRegistorService.getDepartmentList();
                personsList = dwgRegistorService.getPartPersons_Dalian(loginUserInfo);
                
                // (FOR MARITIME) 해양종합설계팀 인원의 관리자 권한 체크 (* 임시기능)
                loginUserInfo = dwgRegistorService.getEmployeeInfoMaritime(param);
            }
			else {
				return new ModelAndView("/common/stxPECDP_LoginFailed");
			}
		}
		
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		// SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
		if(loginUserInfo.get("designerid") == null || "".equals(loginUserInfo.get("designerid"))){
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		// 시수입력 가능한 사용자가 아닌 경우 Exit
		if( 
			(!"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("mh_yn"))) &&
			 !"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("progress_yn"))) ||
			 loginUserInfo.get("termination_date") != null)){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		param.clear();
		param.put("projectList", projectList);
		param.put("loginUserInfo", loginUserInfo);
		param.put("departmentList", departmentList);
		param.put("personsList", personsList);
		param.put("causeDepartmentList", dwgRegistorService.getAllDepartmentOfSTXShipList());
		
		mv.addAllObjects(param);
		
		return mv;
	}
	
	/**
	 * 
	 * @메소드명	: getPartPersons
	 * @날짜		: 2016. 7. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
	 * </pre>
	 * @param dept_code
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="getPartPersons.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartPerson(@RequestParam("dept_code")String dept_code) throws Exception{
		HashMap<String,Object> param = new HashMap<String,Object>();
		param.put("dept_code", dept_code);
		List<Map<String,Object>> partPerson = new ArrayList<Map<String,Object>>();
		partPerson = dwgRegistorService.getPartPersons(param);
		return DisJsonUtil.listToJsonstring(partPerson);
	}
	
	/**
	 * 
	 * @메소드명	: dwgRegisterMainGridAction
	 * @날짜		: 2016. 7. 13.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Main 그리드 표시 데이터
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "dwgRegisterMainGrid.do")
	public @ResponseBody Map<String, Object> dwgRegisterMainGridAction(CommandMap commandMap) throws Exception {
		String[] drawingNoList = (String[]) commandMap.get("drawingNo");
		String drawingNo = "";
		boolean drawingNoCheck = false;
		for (int i = 0; i < drawingNoList.length; i++) {
			if (!"".equals(drawingNoList[i])) {
				drawingNo +=  drawingNoList[i];
				drawingNoCheck = true;
			}
			else drawingNo +=  "_";
		}
		if(drawingNoCheck)commandMap.put("drawingNo",drawingNo);
		else commandMap.put("drawingNo","");
		
		
		Map<String,Object> returnData = dwgRegistorService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	/**
	 * 						
	 * @메소드명	: popUpHardCopyDwgCreateCodeSelect
	 * @날짜		: 2016. 8. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Category of Change 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpHardCopyDwgCreateCodeSelect.do")
	public ModelAndView popUpHardCopyDwgCreateCodeSelect(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dwgRegister"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		List<Map<String,Object>> codeList = dwgRegistorService.getDeployReasonCodeList();
		commandMap.put("reasonCodeList", codeList);
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	/**
	 * 						
	 * @메소드명	: popUpHardCopyDwgCreateRevTimingSelect
	 * @날짜		: 2016. 8. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Distribution Time 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpHardCopyDwgCreateRevTimingSelect.do")
	public ModelAndView popUpHardCopyDwgCreateRevTimingSelect(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dwgRegister"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		return mv;
	}
	
	/**
	 * 
	 * @메소드명	: dwgRegisterMainGridSaveAction
	 * @날짜		: 2016. 8. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Grid변경사항 저장 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dwgRegisterMainGridSave.do")
	public @ResponseBody Map<String, String> dwgRegisterMainGridSaveAction(CommandMap commandMap) throws Exception {
		return dwgRegistorService.saveGridListDps(commandMap);
	}
	
	
	/**
	 * 
	 * @메소드명	: popUpHardCopyDwgCreate
	 * @날짜		: 2016. 8. 2.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 등록화면 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpHardCopyDwgCreate.do")
	public ModelAndView popUpHardCopyDwgCreate(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dwgRegister"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dwgRegistorService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> projectList = null;
		
		if(loginUserInfo == null)loginUserInfo = dwgRegistorService.getEmployeeInfoDalian(param);
		if(loginUserInfo == null) {
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		
		String insaDeptName = String.valueOf(loginUserInfo.get("dept_name"));       // 부서(파트) 이름 - 인사정보의 부서명
	    String insaUpDeptName = String.valueOf(loginUserInfo.get("up_dept_name"));;     // 상위부서(팀) 이름 - 인사정보의 부서명
	    String deployNoPrefix = "";     // 배포 NO.의 Prefix 부분
		
		String searchdeployNoPrefix = String.valueOf((dwgRegistorService.getDeployNoPrefix(loginUserInfo)).get("deploy_no_prefix"));
		
		if(!"".equals(searchdeployNoPrefix)) deployNoPrefix = searchdeployNoPrefix;
        else if (insaDeptName.equals("해양설계관리팀")) deployNoPrefix = "DM";
        else if (insaDeptName.equals("해양의장설계팀-배관설계P")) deployNoPrefix = "PD"; //해양배관시스템설계팀 -> 해양의장설계팀-배관설계P
        else if (insaDeptName.equals("해양의장설계팀-기계설계P")) deployNoPrefix = "ME"; //해양기계설계팀 -> 해양의장설계팀-기계설계P
        else if (insaDeptName.equals("해양의장설계팀-선장설계P")) deployNoPrefix = "HO"; //해양선장설계팀 -> 해양의장설계팀-선장설계P
        else if (insaDeptName.equals("해양의장설계팀-전장설계P")) deployNoPrefix = "EL"; //해양전장설계팀 -> 해양의장설계팀-전장설계P
        else if (insaDeptName.equals("해양선체설계팀")) deployNoPrefix = "PH";
        else if (insaDeptName.equals("해양배관설계팀")) deployNoPrefix = "PP";
        else if (insaDeptName.equals("해양철의장설계팀")) deployNoPrefix = "PO";
        else if (insaDeptName.equals("해양전장선실설계팀")) deployNoPrefix = "PE";
        else if (insaDeptName.equals("해양의장설계팀-선실설계P")) deployNoPrefix = "AC"; //해양선실설계팀 -> 해양의장설계팀-선실설계P
        else {
            String dwgDeptCode = (String)loginUserInfo.get("dwg_deptcode");
            if (dwgDeptCode.equals("000073")) deployNoPrefix = "DP";
            else if (dwgDeptCode.equals("000074")) deployNoPrefix = "DA";
            else if (dwgDeptCode.equals("000075")) deployNoPrefix = "DH";
            else if (dwgDeptCode.equals("000076")) deployNoPrefix = "DE";
            else if (dwgDeptCode.equals("000077")) deployNoPrefix = "DO";
            else if (dwgDeptCode.equals("000106")) deployNoPrefix = "DI";
            else if (dwgDeptCode.equals("000060")) deployNoPrefix = "PP";
            else if (dwgDeptCode.equals("000061")) deployNoPrefix = "ME";
            else if (dwgDeptCode.equals("000062")) deployNoPrefix = "HO";
            else if (dwgDeptCode.equals("000138")) deployNoPrefix = "AC";
            else if (dwgDeptCode.equals("000063")) deployNoPrefix = "EL";
            else if (dwgDeptCode.equals("000058")) deployNoPrefix = "BA";
            else if (dwgDeptCode.equals("000059")) deployNoPrefix = "HU";
            else throw new Exception("Unknown Department(Team) Code! (Team Name: " + insaUpDeptName + ")");
        }
		
        Calendar c = Calendar.getInstance();
        String sYear = String.valueOf(c.get(Calendar.YEAR));
        deployNoPrefix += sYear.substring(2);		
		
		String loginID = String.valueOf(commandMap.get("loginId"));		
		// 호선목록
        // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
             projectList = dwgRegistorService.getProgressSearchableProjectList_Dalian(param);
        else projectList = dwgRegistorService.getAllProjectList();

        // (원인)부서목록
        // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
             departmentList = dwgRegistorService.getAllDepartmentOfSTXShipList_Dalian();
        else departmentList = dwgRegistorService.getAllDepartmentOfSTXShipList();
		
        param.clear();
        param.put("deployNoPrefix", deployNoPrefix);
		param.put("projectList", projectList);
		param.put("loginUserInfo", loginUserInfo);
		param.put("departmentList", departmentList);
		
		mv.addAllObjects(param);
		
		return mv;
	}
	
	/**
	 * 
	 * @메소드명	: getDrawingListForWork2
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 + 호선에 해당하는 도면들 목록을 쿼리
	 * </pre>
	 * @param dept_code
	 * @param project_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getDrawingListForWork2.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDrawingListForWork2(@RequestParam("dept_code")String dept_code,@RequestParam("project_no")String project_no) throws Exception{
		HashMap<String,Object> param = new HashMap<String,Object>();
		param.put("dept_code", dept_code);
		param.put("project_no", project_no);
		List<Map<String,Object>> drawingListForWork = dwgRegistorService.getDrawingListForWork2(param);
		return DisJsonUtil.listToJsonstring(drawingListForWork);
	}
	/**
	 * 
	 * @메소드명	: getDrawingListForWork3
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 + 호선 + 도면에 해당하는 도면정보를 쿼리
	 * </pre>
	 * @param dept_code
	 * @param project_no
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getDrawingListForWork3.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDrawingListForWork3(@RequestParam("dept_code")String dept_code,
														@RequestParam("project_no")String project_no,
														@RequestParam("dwg_no")String dwg_no) throws Exception{
		HashMap<String,Object> param = new HashMap<String,Object>();
		param.put("dept_code", dept_code);
		param.put("project_no", project_no);
		param.put("dwg_no", dwg_no);
		Map<String,Object> drawingForWork = dwgRegistorService.getDrawingForWork3(param);
		return DisJsonUtil.mapToJsonstring(drawingForWork);
	}
	/**
	 * 
	 * @메소드명	: popUpHardCopyDwgCreateGridSaveAction
	 * @날짜		: 2016. 8. 3.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 등록팝업 -그리드 데이터 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpHardCopyDwgCreateGridSave.do")
	public @ResponseBody Map<String, String> popUpHardCopyDwgCreateGridSaveAction(CommandMap commandMap) throws Exception {
		return dwgRegistorService.popUpHardCopyDwgCreateGridSave(commandMap);
	}
}

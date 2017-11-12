package stxship.dis.baseInfo.codeMaster.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.baseInfo.codeMaster.service.CodeMasterService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : CodeMasterController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 23.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 코드마스터 컨트롤러
 *     </pre>
 */
@Controller
public class CodeMasterController extends CommonController {
	/**
	 * 코드마스터 서비스
	 */
	@Resource(name = "codeMasterService")
	private CodeMasterService codeMasterService;

	/**
	 * @메소드명 : linkCodeMaster
	 * @날짜 : 2015. 11. 23.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.코드마스터페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "codeMaster.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getCodeMaster
	 * @날짜 : 2015. 11. 23.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 코드마스터 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "codeMasterList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		//commandMap.put(DisConstants.CUSTOM_SERVICE_KEY, codeMasterService);
		return codeMasterService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveCodeMaster
	 * @날짜 : 2015. 11. 23.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *	변경된 그리드 정보를 가져와서 데이타베이스에 반영한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveCodeMaster.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return codeMasterService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpCodeInfoAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 코드 정보 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "popUpCodeInfo.do")
	public ModelAndView popUpCodeInfoAction(CommandMap commandMap) throws UnsupportedEncodingException {		
		if(commandMap.containsKey("cmtypedesc"))
		{
			commandMap.put("cmtypedesc", URLDecoder.decode(commandMap.get("cmtypedesc").toString(), "UTF-8"));
		}
	
		ModelAndView mav = new ModelAndView("baseInfo/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoMainSdCodeAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Main 코드 정보리스트를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoMainSdCode.do")
	public @ResponseBody Map<String, Object> infoMainSdCodeAction(CommandMap commandMap) {
		return codeMasterService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : infoCategoryBaseAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 기본정보 코드 리스트를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCategoryBase.do")
	public @ResponseBody Map<String, Object> infoCategoryBaseAction(CommandMap commandMap) {
		return codeMasterService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : infoCategoryCodeAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CategotyType 정보 리스트를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCategoryType.do")
	public @ResponseBody Map<String, Object> infoCategoryCodeAction(CommandMap commandMap) {
		return codeMasterService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : infoCategoryMgntAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CategoryMgnt 정보리스트를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCategoryMgnt.do")
	public @ResponseBody Map<String, Object> infoCategoryMgntAction(CommandMap commandMap) {
		return codeMasterService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : codeMasterExcelExport
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CodeMaster Excel 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "codeMasterExcelExport.do")
	public View codeMasterExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return codeMasterService.excelExport(commandMap, modelMap);
	}

}

package stxship.dis.testSource.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.testSource.service.TestSourceService;

/**
 * @파일명 : TestSourceController.java
 * @프로젝트 : DIS
 * @날짜 : 2017. 08. 30.
 * @작성자 : 이상빈
 * @설명
 * 
 * 	<pre>
 *  TEST_SOURCE 컨트롤러
 *     </pre>
 */
@Controller
public class TestSourceController extends CommonController {
	/**
	 * TestSource 서비스
	 */
	@Resource(name = "testSourceService")
	private TestSourceService testSourceService;

	/**
	 * @메소드명 : testSource
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.TestSource 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "testSource.do")
	public ModelAndView testSource(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : testSourceList
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * TestSource 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "testSourceList.do")
	public @ResponseBody Map<String, Object> testSourceList(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return testSourceService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : getMasterList
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Select Box 대표호선 List 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "testSourceProjectSelectBox.do")
	public @ResponseBody List<Map<String, Object>> getMasterList(CommandMap commandMap) {
		return testSourceService.getDbDataList(commandMap);
	}

	/**
	 * @메소드명 : saveTestSource
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
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
	@RequestMapping(value = "saveTestSource.do")
	public @ResponseBody Map<String, String> saveTestSource(CommandMap commandMap) throws Exception {
		return testSourceService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpTestSource
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popupModel 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpTestSource.do")
	public ModelAndView popUpTestSource(CommandMap commandMap) {
		return new ModelAndView("/system" + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : popUpTestSourceList
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popupModel 팝업창의 리스트를 취득한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpTestSourceList.do")
	public @ResponseBody Map<String, Object> popUpTestSourceList(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return testSourceService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * @메소드명 : testSourceExcelExport
	 * @날짜 : 2017. 08. 30.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * modelMgnt Excel 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "testSourceExcelExport.do")
	public View testSourceExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return testSourceService.excelExport(commandMap, modelMap);
	}
}

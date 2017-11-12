package stxship.dis.baseInfo.catalogMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.catalogMgnt.service.CatalogMgntService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : CatalogMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 1.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt 컨트롤러
 *     </pre>
 */
@Controller
public class CatalogMgntController extends CommonController {

	/** CatalogMgnt 서비스정의 */
	@Resource(name = "catalogMgntService")
	public CatalogMgntService catalogMgntService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 모듈로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgnt.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CATALOG 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return catalogMgntService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CATALOG 정보의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveCatalogMgnt.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return catalogMgntService.saveCatalogMgnt(commandMap);
	}

	/**
	 * @메소드명 : designInfoAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 설정정보 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntDesignInfo.do")
	public @ResponseBody Map<String, Object> designInfoAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : purchaseInfoAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 구매정보 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntPurchaseInfo.do")
	public @ResponseBody Map<String, Object> purchaseInfoAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : productionInfoAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 생산정보 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntProductionInfo.do")
	public @ResponseBody Map<String, Object> productionInfoAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * @메소드명 : catalogMgntCatalogLengthInfo
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LENGTH 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntCatalogLengthInfo.do")
	public @ResponseBody Map<String, Object> catalogMgntCatalogLengthInfo(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : itemAttributeBaseAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ITEM속성 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntItemAttributeBase.do")
	public @ResponseBody Map<String, Object> itemAttributeBaseAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : bomAttributeBaseAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM속성 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntBomAttributeBase.do")
	public @ResponseBody Map<String, Object> bomAttributeBaseAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : itemValueAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ITEM속성의 Value 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntItemValue.do")
	public @ResponseBody Map<String, Object> itemValueAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : topItemValueAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ITEM속성의 상위속성 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntTopItemValue.do")
	public @ResponseBody Map<String, Object> topItemValueAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : bomValueAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM속성의 Value리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntBomValue.do")
	public @ResponseBody Map<String, Object> bomValueAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : topBomValueAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM속성의 상위속성 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogMgntTopBomValue.do")
	public @ResponseBody Map<String, Object> topBomValueAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpCatalogInfoAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CATALOG 정보(팝업용) 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogInfo.do")
	public ModelAndView popUpCatalogInfoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("baseInfo/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoCatalogCodeAction
	 * @날짜 : 2015. 12. 1.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CATALOG 정보(팝업용) 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCatalogCode.do")
	public @ResponseBody Map<String, Object> infoCatalogCodeAction(CommandMap commandMap) {

		return catalogMgntService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : additionalPurchaseInfoAction
	 * @날짜 : 2015. 12. 2.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 구매정보 하위의 계획,표준L/T, 구매담당자의 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "additionalPurchaseInfo.do")
	public @ResponseBody Map<String, Object> additionalPurchaseInfoAction(CommandMap commandMap) {
		return catalogMgntService.additionalPurchaseInfo(commandMap);
	}

	/**
	 * @메소드명 : popUpHighRankAttrInfoAction
	 * @날짜 : 2015. 12. 2.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상위속성(팝업)이 선택되어졌을때의 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpHighRankAttrInfo.do")
	public ModelAndView popUpHighRankAttrInfoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoHighRankAttrValueAction
	 * @날짜 : 2015. 12. 2.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 상위속성(팝업)이 선택되어졌을때의 리스트 구현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoHighRankAttrValue.do")
	public @ResponseBody Map<String, Object> infoHighRankAttrValueAction(CommandMap commandMap) {

		return catalogMgntService.getGridListNoPaging(commandMap);

	}

	/**
	 * @메소드명 : popUpPartFamilyInfoAction
	 * @날짜 : 2015. 12. 2.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PartFamily가 선택되어졌을때의 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPartFamilyInfo.do")
	public ModelAndView popUpPartFamilyInfoAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoPartFamilyCodeAction
	 * @날짜 : 2015. 12. 2.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PartFamily가 선택되어졌을때의 팝업 리스트 정보
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPartFamilyCode.do")
	public @ResponseBody Map<String, Object> infoPartFamilyCodeAction(CommandMap commandMap) {
		return catalogMgntService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : categoryFromPartFamilyAction
	 * @날짜 : 2015. 12. 3.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * partFamily가 입력되어졌을때 해당하는 category 를 가져온다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "categoryFromPartFamily.do")
	public @ResponseBody Map<String, String> categoryFromPartFamilyAction(CommandMap commandMap) throws Exception {
		return catalogMgntService.categoryFromPartFamily(commandMap);
	}
}

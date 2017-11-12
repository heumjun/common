package stxship.dis.item.createItem.controller;

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
import stxship.dis.item.createItem.service.CreateItemService;

/**
 * @파일명 : CreateItemController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 14.
 * @작성자 : BaekJaeHo
 * @설명
 * 
 * 	<pre>
 * 
 *     </pre>
 */
@Controller
public class CreateItemController extends CommonController {
	@Resource(name = "createItemService")
	private CreateItemService createItemService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCreate.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "goItemCreate.do")
	public ModelAndView goItemCreate(CommandMap commandMap) {
		
		ModelAndView mav = new ModelAndView("item/itemCreate");
		commandMap.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID)); 
		mav.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : getCategoryTypeList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		채번 대상 리스트 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCreateTempList.do")
	public @ResponseBody Map<String, Object> getCategoryTypeList(CommandMap commandMap) {
		
		return createItemService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpPartFamilyDesc
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Part Famliy 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPartFamilyDesc.do")
	public ModelAndView popUpPartFamilyDesc(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpPartFamilyDescList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Part Family Desc 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpPartFamilyDescList.do")
	public @ResponseBody Map<String, Object> popUpPartFamilyDescList(CommandMap commandMap) {
		
		return createItemService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpInvCategory
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - InV Category 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpInvCategory.do")
	public ModelAndView popUpInvCategory(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpInvCategoryList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Inv Category 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpInvCategoryList.do")
	public @ResponseBody Map<String, Object> popUpInvCategoryList(CommandMap commandMap) {
		
		return createItemService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpCostCategory
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Cost Category 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCostCategory.do")
	public ModelAndView popUpCostCategory(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpCostCategoryList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Cost Category 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCostCategoryList.do")
	public @ResponseBody Map<String, Object> popUpCostCategoryList(CommandMap commandMap) {
		
		return createItemService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpShipType
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Ship Type 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpShipType.do")
	public ModelAndView popUpShipType(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpShipTypeList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Ship Type 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpShipTypeList.do")
	public @ResponseBody Map<String, Object> popUpShipTypeList(CommandMap commandMap) {
		
		return createItemService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpCatalog
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Catalog 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalog.do")
	public ModelAndView popUpCatalog(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpCatalogList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Catalog 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogList.do")
	public @ResponseBody Map<String, Object> popUpCatalogList(CommandMap commandMap) {
		
		return createItemService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpCatalogCodeDesc
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Catalog Code 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogCodeDesc.do")
	public ModelAndView popUpCatalogCodeDesc(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpCatalogCodeDescList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - Catalog Code 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogCodeDescList.do")
	public @ResponseBody Map<String, Object> popUpCatalogCodeDescList(CommandMap commandMap) {
		
		return createItemService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpItemAttribute
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - ItemAttribute 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemAttribute.do")
	public ModelAndView popUpItemAttribute(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpItemAttributeList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - ItemAttribute 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemAttributeList.do")
	public @ResponseBody Map<String, Object> popUpItemAttributeList(CommandMap commandMap) {
		
		return createItemService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpCatalogDesc
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - CatalogDesc 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogDesc.do")
	public ModelAndView popUpCatalogDesc(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpCatalogDescList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - CatalogDesc 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogDescList.do")
	public @ResponseBody Map<String, Object> popUpCatalogDescList(CommandMap commandMap) {
		
		return createItemService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpItemAddAttribute
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - ItemAddAttribute 화면
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemAddAttribute.do")
	public ModelAndView popUpItemAddAttribute(CommandMap commandMap) {
		return new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : popUpItemAddAttributeList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		팝업 - ItemAddAttribute 화면 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemAddAttributeList.do")
	public @ResponseBody Map<String, Object> popUpItemAddAttributeList(CommandMap commandMap) {
		
		return createItemService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * @메소드명 : saveItemNextAction
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ITEM 채번
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveItemNextAction.do")
	public @ResponseBody Map<String, Object> saveItemNextAction(CommandMap commandMap) throws Exception {
		return createItemService.saveItemNextAction(commandMap);
	}

	/**
	 * @메소드명 : saveItemChaebeon
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ITEM 채번
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveItemCreate.do")
	public @ResponseBody Map<String, Object> saveItemChaebeon(CommandMap commandMap) throws Exception {
		return createItemService.saveItemCreate(commandMap);
	}

	/**
	 * @메소드명 : itemExcelUpload
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		ItemEXCEL 업로드 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/itemExcelUpload.do")
	public ModelAndView itemExcelUpload(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("item/" + commandMap.get(DisConstants.MAPPER_NAME));
		mv.addObject("catalog_code", commandMap.get("catalog_code"));
		return mv;
	}

	/**
	 * @메소드명 : itemExcelExport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 Export
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/itemExcelExport.do")
	public View itemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return createItemService.itemExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : tempCatalogItemExist
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		temp에 동일한 catalog code가 있는지 체크 있으면 : Y 없으면 : NULL
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/tempCatalogItemExist.do")
	public @ResponseBody String tempCatalogItemExist(CommandMap commandMap) throws Exception {
		return createItemService.selectTempCatalogItemExist(commandMap);
	}

	/**
	 * @메소드명 : itemExcelImport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		엑셀 업로드 
	 *     </pre>
	 * 
	 * @param file
	 * @param catalogCode
	 * @param delete_yn
	 * @param request
	 * @param response
	 * @param commandMap
	 * @throws Exception
	 */
	@RequestMapping(value = "/itemExcelImport.do")
	public void itemExcelImport(@RequestParam("file") CommonsMultipartFile file,
			@RequestParam("catalog_code") String catalogCode, @RequestParam("delete_yn") String delete_yn,
			HttpServletRequest request, HttpServletResponse response, CommandMap commandMap) throws Exception {

		commandMap.put("catalog_code", catalogCode);
		commandMap.put("file", file);
		commandMap.put("delete_yn", delete_yn);

		createItemService.itemExcelImport(commandMap, request, response);
	}

	/**
	 * @메소드명 : itemCreateList
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		아이템 생성 이후 팝업 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCreateList.do")
	public @ResponseBody ModelAndView itemCreateList(CommandMap commandMap) {
		return new ModelAndView("item/" + commandMap.get(DisConstants.MAPPER_NAME));
	}

	/**
	 * @메소드명 : selectItemCatalogAttribute
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		카달로그 해더 받아옴.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemCatalogAttribute.do")
	public @ResponseBody Map<String, Object> selectItemCatalogAttribute(CommandMap commandMap) {
		return createItemService.selectItemCatalogAttribute(commandMap);
	}

	/**
	 * @메소드명 : selectItemAllCatalog
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		카달로그 정보 받아옴. 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemAllCatalog.do")
	public @ResponseBody Map<String, Object> selectItemAllCatalog(CommandMap commandMap) {
		return createItemService.selectItemAllCatalog(commandMap);
	}
	
	/**
	 * @메소드명 : itemAttributeCheck
	 * @날짜 : 2017. 03. 13.
	 * @작성자 : ChoHeumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *		초기화 되는 ATTR 정보를 받아옴 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "itemAttributeCheck.do")
	public @ResponseBody String itemAttributeCheck(CommandMap commandMap) throws Exception {
		return createItemService.itemAttributeCheck(commandMap);
	}
	
	/**
	 * @메소드명 : itemCloneAction
	 * @날짜 : 2017. 03. 13.
	 * @작성자 : ChoHeumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *		초기화 되는 ATTR 정보를 받아옴 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "itemCloneAction.do")
	public @ResponseBody Map<String, Object> itemCloneAction(CommandMap commandMap) throws Exception {
		return createItemService.itemCloneAction(commandMap);
	}
	
	/**
	 * @메소드명 : itemAttributeDelete
	 * @날짜 : 2017. 03. 14.
	 * @작성자 : ChoHeumjun
	 * @설명 :
	 * 
	 *     <pre>
	 *		ATTR 정보 공유 방지를 위한 삭제
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "itemAttributeDelete.do")
	public @ResponseBody Map<String, Object> itemAttributeDelete(CommandMap commandMap) throws Exception {
		return createItemService.itemAttributeDelete(commandMap);
	}
	
	
	
	
}

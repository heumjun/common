package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.baseInfo.catalogMgnt.dao.CatalogMgntDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : CatalogMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 2.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt에서 사용되는 서비스
 *     </pre>
 */
@Service("catalogMgntService")
public class CatalogMgntServiceImpl extends CommonServiceImpl implements CatalogMgntService {

	/** CatalogMgnt DAO정의 */
	@Resource(name = "catalogMgntDAO")
	private CatalogMgntDAO catalogMgntDAO;

	/**
	 * @메소드명 : saveCatalogMgnt
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 저장을 선택했을때 호출되는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveCatalogMgnt(CommandMap commandMap) throws Exception {
		int result = 0;
		String catalog_code = (String) commandMap.get("catalog_code");
		String attribute_code = (String) commandMap.get("attribute_code");
		String value_code = (String) commandMap.get("value_code");
		String item_make_value = (String) commandMap.get("item_make_value");
		String bom_attr_code = (String) commandMap.get("bom_attr_code");
		String bom_val_code = (String) commandMap.get("bom_val_code");
		
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		// List Map 형식으로 형변환
		List<Map<String, Object>> catalogList = DisJsonUtil.toList(commandMap.get("catalogList"));
		List<Map<String, Object>> designInfoList = DisJsonUtil.toList(commandMap.get("designInfoList"));
		List<Map<String, Object>> purchaseInfoList = DisJsonUtil.toList(commandMap.get("purchaseInfoList"));
		List<Map<String, Object>> productionInfoList = DisJsonUtil.toList(commandMap.get("productionInfoList"));
		List<Map<String, Object>> catalogLengthInfoList = DisJsonUtil.toList(commandMap.get("catalogLengthInfoList"));
		List<Map<String, Object>> itemAttributeBaseList = DisJsonUtil.toList(commandMap.get("itemAttributeBaseList"));
		List<Map<String, Object>> itemValueList = DisJsonUtil.toList(commandMap.get("itemValueList"));
		List<Map<String, Object>> topItemValueList = DisJsonUtil.toList(commandMap.get("topItemValueList"));
		List<Map<String, Object>> bomAttributeBaseList = DisJsonUtil.toList(commandMap.get("bomAttributeBaseList"));
		List<Map<String, Object>> bomValueList = DisJsonUtil.toList(commandMap.get("bomValueList"));
		List<Map<String, Object>> topBomValueList = DisJsonUtil.toList(commandMap.get("topBomValueList"));

		// catalogList의 중복체크
		catalogValidationCheck(catalogList);
		catalogAttributeValidationCheck(itemAttributeBaseList, catalog_code, "ITEM");
		catalogAttributeValueValidationCheck(itemValueList, catalog_code, "ITEM", attribute_code);
		catalogAttributeValueDeValidationCheck(topItemValueList, catalog_code, "ITEM", attribute_code, value_code,
				item_make_value);

		for (Map<String, Object> rowData : catalogList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = insertMainCatalog(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = updateMainCatalog(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteCatalogMgnt(rowData);
			}
		}

		// 설게정보 저장
		for (Map<String, Object> rowData : designInfoList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// desingInfo 파라미트
			rowData.put("catalog_code", catalog_code);
			rowData.put("value_type", "CATALOG_DESIGN");
			rowData.put("value_code", rowData.get("d_code"));
			rowData.put("value_name", rowData.get("d_value"));
			rowData.put("enable_flag", rowData.get("d_flag"));

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertCatalogValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.updateCatalogValue(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteCatalogValue(rowData);
			}
		}

		// 구매정보 저장
		for (Map<String, Object> rowData : purchaseInfoList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// purchaseInfo 파라미트
			rowData.put("catalog_code", catalog_code);
			rowData.put("value_type", "CATALOG_PO");
			rowData.put("value_code", rowData.get("p_code"));
			rowData.put("value_name", rowData.get("p_value"));
			rowData.put("enable_flag", rowData.get("p_flag"));

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertCatalogValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.updateCatalogValue(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteCatalogValue(rowData);
			}
		}

		// 생산정보 저장
		for (Map<String, Object> rowData : productionInfoList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// productionInfo 파라미트 설정
			rowData.put("catalog_code", catalog_code);
			rowData.put("value_type", "CATALOG_WIP");
			rowData.put("value_code", rowData.get("t_code"));
			rowData.put("value_name", rowData.get("t_value"));
			rowData.put("enable_flag", rowData.get("t_flag"));

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertCatalogValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.updateCatalogValue(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteCatalogValue(rowData);
			}
		}
		
		// LENGTH 저장
		for (Map<String, Object> rowData : catalogLengthInfoList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// productionInfo 파라미트 설정
			rowData.put("catalog_code", catalog_code);

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertCatalogLength(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.updateCatalogLength(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteCatalogLength(rowData);
			}
		}

		// itemAttribute저장
		for (Map<String, Object> rowData : itemAttributeBaseList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// purchaseInfo 설정
			rowData.put("item_catalog_code", catalog_code);
			rowData.put("item_attribute_type", "ITEM");
			//rowData.put("item_attribute_required_flag", "Y");
			rowData.put("item_enable_flag", "Y");

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = insertCatalogAttribute(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = updateCatalogAttribute(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteItemAttributeBase(rowData);
			}
		}

		// itemValue저장
		for (Map<String, Object> rowData : itemValueList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("item_catalog_code", catalog_code);
			rowData.put("item_attribute_type", "ITEM");
			rowData.put("item_attribute_code", attribute_code);
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = insertCatalogAttributeValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = updateCatalogAttributeValue(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteItemValue(rowData);
			}
		}

		// topItemValue저장
		for (Map<String, Object> rowData : topItemValueList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("item_catalog_code", catalog_code);
			rowData.put("item_attribute_type", "ITEM");
			rowData.put("item_attribute_code", attribute_code);
			rowData.put("item_value_code", value_code);
			rowData.put("item_item_make_value", item_make_value);

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = insertCatalogAttributeValueDe(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = updateCatalogAttributeValueDe(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteTopItemValue(rowData);
			}

		}

		// bomAttribute저장
		for (Map<String, Object> rowData : bomAttributeBaseList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// purchaseInfo 설정
			rowData.put("bom_catalog_code", catalog_code);
			rowData.put("bom_attribute_type", "BOM");
			rowData.put("bom_attribute_required_flag", "Y");
			rowData.put("bom_enable_flag", "Y");

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertBomAttributeBase(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.updateBomAttributeBase(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteBomAttributeBase(rowData);
			}
		}

		// bomValue저장
		for (Map<String, Object> rowData : bomValueList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// purchaseInfo 설정
			rowData.put("bom_catalog_code", catalog_code);
			rowData.put("bom_attribute_type", "BOM");
			rowData.put("bom_attribute_code", bom_attr_code);

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertBomValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// 원래 내용 삭제한다.
				result = catalogMgntDAO.deleteBomValue(rowData);
				// 새로운 내용 저장한다.
				result = catalogMgntDAO.insertBomValue(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteBomValue(rowData);
			}
		}

		// topBomValue저장
		for (Map<String, Object> rowData : topBomValueList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put("bom_catalog_code", catalog_code);
			rowData.put("bom_attribute_type", "BOM");
			rowData.put("bom_attribute_code", bom_attr_code);
			rowData.put("bom_value_code", bom_val_code);
			rowData.put("bom_item_make_value", bom_val_code);

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.insertTopBomValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				// 원래 내용 삭제한다.
				result = catalogMgntDAO.deleteTopBomValue(rowData);
				// 새로운 내용 저장한다.
				result = catalogMgntDAO.insertTopBomValue(rowData);
			} else if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = catalogMgntDAO.deleteTopBomValue(rowData);
			}

		}
		if (result == 0) {
			throw new DisException();
		}
		// 결과값에 따른 메시지를 담아 전송
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : categoryFromPartFamily
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PartFamily가 선택되었을때 해당하는 Category를 조회하여 리턴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, String> categoryFromPartFamily(CommandMap commandMap) {
		return catalogMgntDAO.selectCategoryFromPartFamily(commandMap.getMap());
	}

	/**
	 * @메소드명 : additionalPurchaseInfo
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 구매정보의 계획,표준LT,구매 담당자를 조회하여 리턴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@Override
	public Map<String, Object> additionalPurchaseInfo(CommandMap commandMap) {
		return catalogMgntDAO.selectAdditionalPurchaseInfo(commandMap.getMap());
	}

	public void catalogValidationCheck(List<Map<String, Object>> catalogList) throws Exception {
		for (Map<String, Object> rowData : catalogList) {
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				String sExist = catalogMgntDAO.selectExistCatalog(rowData);
				if (sExist != null) {
					// 중복 데이터 메시지를 돌려준다.
					throw new DisException(DisMessageUtil.getMessage("common.default.duplication"), "CATALOG");
				}
			}
		}
	}

	public void catalogAttributeValidationCheck(List<Map<String, Object>> itemAttributeBaseList, String catalog_code,
			String attribute_type) throws Exception {
		String resultMsg = "";
		for (Map<String, Object> rowData : itemAttributeBaseList) {

			rowData.put("catalog_code", catalog_code);
			rowData.put("attribute_type", attribute_type);

			if ("ITEM".equals(attribute_type)) {
				rowData.put("attribute_code", rowData.get("item_attribute_code"));
				rowData.put("attribute_name", rowData.get("item_attribute_name"));
				rowData.put("attribute_data_type", rowData.get("item_attribute_data_type"));
				rowData.put("enable_flag", rowData.get("item_enable_flag"));
				rowData.put("assy_attribute_code", rowData.get("item_assy_attribute_code"));
				rowData.put("attribute_data_min", rowData.get("item_attribute_data_min"));
				rowData.put("attribute_data_max", rowData.get("item_attribute_data_max"));

				resultMsg = DisMessageUtil.getMessage("common.default.duplication", "ITEM");

			} else if ("BOM".equals(attribute_type)) {
				rowData.put("attribute_code", rowData.get("bom_attribute_code"));
				rowData.put("attribute_name", rowData.get("bom_attribute_name"));
				rowData.put("attribute_data_type", rowData.get("bom_attribute_data_type"));
				rowData.put("enable_flag", rowData.get("bom_enable_flag"));
				rowData.put("assy_attribute_code", rowData.get("bp,_assy_attribute_code"));
				rowData.put("attribute_data_min", "");
				rowData.put("attribute_data_max", "");

				resultMsg = DisMessageUtil.getMessage("common.default.duplication", "BOM");
			} else if ("ADDITEM".equals(attribute_type)) {
				resultMsg = DisMessageUtil.getMessage("common.message1", "ITEM부가속성");
			}

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				String sExist = catalogMgntDAO.selectExistCatalogAttribute(rowData);
				if (sExist != null) {
					// 중복 데이터 메시지를 돌려준다.
					throw new DisException(resultMsg);
				}
			}
		}
	}

	public void catalogAttributeValueValidationCheck(List<Map<String, Object>> itemValueList, String catalog_code,
			String attribute_type, String attribute_code) throws Exception {
		String resultMsg = "";
		for (Map<String, Object> rowData : itemValueList) {
			rowData.put("catalog_code", catalog_code);
			rowData.put("attribute_type", attribute_type);
			rowData.put("attribute_code", attribute_code);

			if ("ITEM".equals(attribute_type)) {
				rowData.put("value_code", rowData.get("item_value_code"));
				rowData.put("item_make_value", rowData.get("item_item_make_value"));
				resultMsg = DisMessageUtil.getMessage("common.default.duplication", "ITEM");
			} else if ("BOM".equals(attribute_type)) {
				rowData.put("value_code", rowData.get("bom_value_code"));
				rowData.put("item_make_value", rowData.get("bom_value_code"));
				resultMsg = DisMessageUtil.getMessage("common.default.duplication", "BOM");
			} else if ("ADDITEM".equals(attribute_type)) {
				rowData.put("item_make_value", "");
				resultMsg = DisMessageUtil.getMessage("common.message1", "ITEM부가속성의 물성치 VALUE");
			}
			// 업데이트는 전체삭제후 입력을 하므로 중복체크는 필요없음
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				Object mapExist = catalogMgntDAO.selectExistCatalogAttributeValue(rowData);

				if (mapExist != null) {
					// 중복 데이터 메시지를 돌려준다.
					// 중복체크는 안하는지 확인요
					throw new DisException(resultMsg);

				}
			}
		}
	}

	public void catalogAttributeValueDeValidationCheck(List<Map<String, Object>> itemValueList, String catalog_code,
			String attribute_type, String attribute_code, String value_code, String item_make_value) {
		for (Map<String, Object> rowData : itemValueList) {
			rowData.put("catalog_code", catalog_code);
			rowData.put("attribute_type", attribute_type);
			rowData.put("attribute_code", attribute_code);
			rowData.put("value_code", value_code);
			rowData.put("item_make_value", item_make_value);

			if ("ITEM".equals(attribute_type)) {
				rowData.put("assy_value_code", rowData.get("item_assy_value_code"));
				rowData.put("enable_flag", rowData.get("item_enable_flag"));
			} else if ("BOM".equals(attribute_type)) {
				rowData.put("assy_value_code", rowData.get("bom_assy_value_code"));
				rowData.put("enable_flag", rowData.get("bom_enable_flag"));
			}
		}
	}

	public int insertMainCatalog(Map<String, Object> rowData) {
		int result = 0;
		result = catalogMgntDAO.insertCatalogMgnt(rowData);

		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogHis(rowData);

		String sExist = (String) catalogMgntDAO.selectExistMtlItemCatalogGroupsB(rowData);

		if (sExist == null || !"Y".equals(sExist)) {

			// ERP Catalog Main에 저장한다.
			result = catalogMgntDAO.insertMtlItemCatalogGroupsB(rowData);

			// ERP Catalog DESC에 저장한다.
			result = catalogMgntDAO.insertMtlItemCatalogGroupsTL(rowData);
		}

		String sCategory3 = (String) catalogMgntDAO.selectVCategory(rowData);
		rowData.put("v_category", sCategory3 == null ? "" : sCategory3);

		Map<String, Object> mapCategoryId = catalogMgntDAO.selectCategoryId(rowData);

		if (mapCategoryId == null) {
			mapCategoryId = new HashMap<String, Object>();

			mapCategoryId.put("item_catalog_group_id", 0);
			mapCategoryId.put("category_id", 0);
		}

		sExist = catalogMgntDAO.selectExistCatalogCateRelation(mapCategoryId);

		if (sExist == null || !"Y".equals(sExist)) {
			mapCategoryId.put("uom_code", rowData.get("uom_code"));
			result = catalogMgntDAO.insertCatalogCateRelation(mapCategoryId);
		}
		return result;
	}

	public int updateMainCatalog(Map<String, Object> rowData) {
		int result = 0;
		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogHis(rowData);

		result = catalogMgntDAO.updateCatalogMgnt(rowData);

		String sCatalogGroupId = catalogMgntDAO.selectItemCatalogGroupId(rowData);

		rowData.put("v_item_catalog_group_id", sCatalogGroupId == null ? "" : sCatalogGroupId);

		String sCategory3 = catalogMgntDAO.selectVCategory(rowData);
		rowData.put("v_category", sCategory3 == null ? "" : sCategory3);

		String sCategoryId = catalogMgntDAO.selectCategoryId2(rowData);
		rowData.put("v_category_id", sCategoryId == null ? "" : sCategoryId);

		Map<String, Object> mapCatalog = catalogMgntDAO.selectCatalogInfo(rowData);

		if (mapCatalog == null) {
			mapCatalog = new HashMap<String, Object>();

			mapCatalog.put("catalog_desc", "");
			mapCatalog.put("category_id", 0);
			mapCatalog.put("uom_code", "");
			mapCatalog.put("enable_flag", "");

		}

		if (!rowData.get("enable_flag").equals(mapCatalog.get("enable_flag"))) {
			result = catalogMgntDAO.updateMtlItemCatalogGroupsB(rowData);
		}

		if (!rowData.get("catalog_desc").equals(mapCatalog.get("catalog_desc"))) {
			result = catalogMgntDAO.updateMtlItemCatalogGroupsTL(rowData);
		}

		if ((!rowData.get("category_id").equals(mapCatalog.get("category_id")))
				|| (!rowData.get("uom_code").equals(mapCatalog.get("uom_code")))) {
			result = catalogMgntDAO.updateCatalogCateRelation(rowData);
		}
		return result;
	}

	public int insertCatalogAttribute(Map<String, Object> rowData) {
		int result = 0;
		result = catalogMgntDAO.insertItemAttributeBase(rowData);

		// Catalog His 리비젼번호를 구한다.
		String sRevNo = catalogMgntDAO.selectCatalogAttrHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogAttributeHis(rowData);

		String sCatalogGroupId = catalogMgntDAO.selectItemCatalogGroupId(rowData);

		rowData.put("v_item_catalog_group_id", sCatalogGroupId == null ? "" : sCatalogGroupId);

		String sExist = (String) catalogMgntDAO.selectExistDescriptiveElements(rowData);

		if (sExist == null || !"Y".equals(sExist)) {
			result = catalogMgntDAO.insertDescriptiveElements(rowData);
		}
		return result;
	}

	public int updateCatalogAttribute(Map<String, Object> rowData) {
		int result = 0;
		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogAttrHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogAttributeHis(rowData);

		result = catalogMgntDAO.updateItemAttributeBase(rowData);

		String sCatalogGroupId = catalogMgntDAO.selectItemCatalogGroupId(rowData);

		rowData.put("v_item_catalog_group_id", sCatalogGroupId == null ? "" : sCatalogGroupId);

		result = catalogMgntDAO.updateDescriptiveElements(rowData);
		return result;
	}

	public int insertCatalogAttributeValue(Map<String, Object> rowData) {
		int result = 0;
		result = catalogMgntDAO.insertItemValue(rowData);

		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogAttrHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogAttributeValueHis(rowData);
		return result;
	}

	public int updateCatalogAttributeValue(Map<String, Object> rowData) {
		int result = 0;
		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogAttrHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogAttributeValueHis2(rowData);

		// 새로운 내용 저장한다.
		result = catalogMgntDAO.deleteItemValue(rowData);

		// 새로운 내용 저장한다.
		result = catalogMgntDAO.insertItemValue(rowData);

		return result;

	}

	public int insertCatalogAttributeValueDe(Map<String, Object> rowData) {
		int result = 0;
		result = catalogMgntDAO.insertTopItemValue(rowData);

		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogAttrHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogAttributeValueDeHis(rowData);
		return result;
	}

	public int updateCatalogAttributeValueDe(Map<String, Object> rowData) {
		int result = 0;
		// Catalog His 리비젼번호를 구한다.
		String sRevNo = (String) catalogMgntDAO.selectCatalogAttrHisRevNo(rowData);
		rowData.put("revision_no", sRevNo);

		// Catalog His에 저장한다.
		result = catalogMgntDAO.insertCatalogAttributeValueDeHis2(rowData);

		// 원래 내용 삭제한다.
		result = catalogMgntDAO.deleteTopItemValue(rowData);

		// 새로운 내용 저장한다.
		result = catalogMgntDAO.insertTopItemValue(rowData);
		return result;
	}
}

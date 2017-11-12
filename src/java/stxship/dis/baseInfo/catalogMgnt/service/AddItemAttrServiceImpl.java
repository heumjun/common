package stxship.dis.baseInfo.catalogMgnt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import stxship.dis.baseInfo.catalogMgnt.dao.AddItemAttrDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : AddItemAttrServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 부가속성이 선택되었을때 사용되는 서비스
 * CatalogMgnt서비스와 중복되는 처리가 있으므로 CatalogMgnt서비스상속
 *     </pre>
 */
@Service("addItemAttrService")
public class AddItemAttrServiceImpl extends CatalogMgntServiceImpl implements AddItemAttrService {

	/** CatalogMgnt DAO정의 */
	@Resource(name = "addItemAttrDAO")
	private AddItemAttrDAO addItemAttrDAO;

	/**
	 * @메소드명 : saveItemAddAttribute
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 부가속성 저장을 선택하였을때 사용되는 서비스
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveItemAddAttribute(CommandMap commandMap) throws Exception {
		int result = 0;
		String sCatalogCode = (String) commandMap.get("catalog_code");
		String sAttribute_code = (String) commandMap.get("attribute_code");
		List<Map<String, Object>> itemAttributeBaseList = DisJsonUtil.toList(commandMap.get("itemAttributeBaseList"));
		List<Map<String, Object>> itemValueList = DisJsonUtil.toList(commandMap.get("itemValueList"));

		catalogAttributeValidationCheck(itemAttributeBaseList, sCatalogCode, "ADDITEM");

		catalogAttributeValueValidationCheck(itemValueList, sCatalogCode, "ADDITEM", sAttribute_code);

		// addItemAttribute 삭제
		for (Map<String, Object> rowData : itemAttributeBaseList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = addItemAttrDAO.deleteAddItemAttributeBase(rowData);
			}
		}
		// addItemAttribute 저장
		for (Map<String, Object> rowData : itemAttributeBaseList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			/*rowData.put("attribute_required_flag", "");*/
			rowData.put("enable_flag", DisConstants.Y);

			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = addItemAttrDAO.insertAddItemAttributeBase(rowData);

			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = addItemAttrDAO.updateAddItemAttributeBase(rowData);
			}
		}
		// addItemAttribute Value 저장
		for (Map<String, Object> rowData : itemValueList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if (DisConstants.DELETE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = addItemAttrDAO.deleteAddItemValue(rowData);
			}
		}
		// addItemAttribute Value 저장
		for (Map<String, Object> rowData : itemValueList) {
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			if (DisConstants.INSERT.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = addItemAttrDAO.insertAddItemValue(rowData);
			} else if (DisConstants.UPDATE.equals(rowData.get(DisConstants.FROM_GRID_OPER))) {
				result = addItemAttrDAO.deleteAddItemValue(rowData);
				// 새로운 내용 저장한다.
				result = addItemAttrDAO.insertAddItemValue(rowData);

			}
		}
		if (result == 0) {
			throw new DisException();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);

	}

}

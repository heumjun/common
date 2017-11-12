package stxship.dis.baseInfo.categoryMgnt.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.baseInfo.categoryMgnt.dao.CategoryMgntDAO;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;

/**
 * @파일명 : CategoryMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CategoryMgnt 의 서비스
 *     </pre>
 */
@Service("categoryMgntService")
public class CategoryMgntServiceImpl extends CommonServiceImpl implements CategoryMgntService {

	@Resource(name = "categoryMgntDAO")
	private CategoryMgntDAO categoryMgntDAO;

	/**
	 * @메소드명 : gridDataInsert
	 * @날짜 : 2015. 12. 3.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CategoryMgnt에서 저장버튼을 선택하였을때 (추가)의 서비스
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataInsert(Map<String, Object> rowData) {
		// 추가생성 결과값
		int insertResult = 0;
		// category 저장
		insertResult = categoryMgntDAO.insertCategoryMgnt(rowData);
		insertResult = categoryMgntDAO.insertCategoryMgntMTL_CATEGORIES_B(rowData);

		if (insertResult != 0) {
			// FND_FLEX_VALUES table에 존재여부 검사
			List<Map<String, Object>> list = categoryMgntDAO.selectCategoryMgntDivFlex_value_id(rowData);

			String iecoNextNum = list.size() + "";
			String typeCode = (String) rowData.get("type_code");
			// COST CATEGORY 일 경우에만 반영
			if ("0".equals(iecoNextNum) && typeCode.equals("02")) {
				// FND_FLEX_VALUES table에 저장;
				insertResult = categoryMgntDAO.insertCategoryMgntFND_FLEX_VALUES(rowData);
				// FND_FLEX_VALUES_TL table에 저장;
				insertResult = categoryMgntDAO.insertCategoryMgntFND_FLEX_VALUES_TL(rowData);
			}
			if (typeCode.equals("02")) {
				// COST CATEGORY 일 경우 반영
				// FND_FLEX_VALUES table에 저장;
				insertResult = categoryMgntDAO.insertCategoryMgntMTL_CATEGORIES_TL_Cost(rowData);
			} else if (typeCode.equals("01")) {
				// INV CATEGORY 일 경우 반영
				// FND_FLEX_VALUES table에 저장;
				insertResult = categoryMgntDAO.insertCategoryMgntMTL_CATEGORIES_TL_Invetory(rowData);
			}
			insertResult = categoryMgntDAO.insertFndFlexValuesTl(rowData);
		}
		if (insertResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}

	/**
	 * @메소드명 : gridDataUpdate
	 * @날짜 : 2015. 12. 3.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CategoryMgnt에서 저장버튼을 선택하였을때(변경)의 서비스
	 *     </pre>
	 * 
	 * @param rowData
	 * @return
	 */
	@Override
	public String gridDataUpdate(Map<String, Object> rowData) {
		int updateResult = 0;
		// 수정
		String fFlex_value_id = "";
		String checkUpdate = "False";
		String attributeIdCheckUpdate = "False";
		String categoryDescCheckUpdate = "False";
		// 사용안되고있음
		// String categoryEtcCheckUpdate = "False";
		String enableCheckUpdate = "False";

		// FND_FLEX_VALUES table에 존재여부 검사
		List<Map<String, Object>> list = categoryMgntDAO.selectChangeUpdate(rowData);

		for (int i = 0; list.size() > i; i++) {
			Map<String, Object> map = list.get(i);

			if ("0".equals(map.get("attribute_id")) || "0".equals(map.get("category_desc"))
					|| "0".equals(map.get("category_etc")) || "0".equals(map.get("enable_flag"))) {
				checkUpdate = "True";
			}

			if ("0".equals(map.get("attribute_id"))) {
				attributeIdCheckUpdate = "True";
			}

			if ("0".equals(map.get("category_desc"))) {
				categoryDescCheckUpdate = "True";
			}

			if ("0".equals(map.get("category_etc"))) {
				// 사용안되고있음
				// categoryEtcCheckUpdate = "True";
			}

			if ("0".equals(map.get("enable_flag"))) {
				enableCheckUpdate = "True";
			}
		}

		if (checkUpdate.equals("True")) {

			updateResult = categoryMgntDAO.updateCategoryMgntSTX_DIS_SD_CATEGORY(rowData);

			if ("01".equals(rowData.get("type_code"))) {
				// INV CATEGORY 일 경우에만 반영
				if (attributeIdCheckUpdate.equals("True") || enableCheckUpdate.equals("True")) {
					updateResult = categoryMgntDAO.updateCategoryMgntMTL_CATEGORIES_B(rowData);
				}

				if (categoryDescCheckUpdate.equals("True")) {
					updateResult = categoryMgntDAO.updateCategoryMgntMTL_CATEGORIES_B(rowData);
					updateResult = categoryMgntDAO.updateCategoryMgntMTL_CATEGORIES_TL(rowData);
				}
 			} else {
				// COST CATEGORY 일때만 반영

				// FND_FLEX_VALUES table에 존재여부 검사
				List<Map<String, Object>> listFlexValue = categoryMgntDAO.selectCategoryMgntDivFlex_value_id(rowData);

				for (int i = 0; listFlexValue.size() > i; i++) {
					Map<String, Object> mapValue = listFlexValue.get(i);

					fFlex_value_id = mapValue.get("FLEX_VALUE_ID") + "";
				}
				// 순번
				rowData.put("flex_value_id", fFlex_value_id);

				if (categoryDescCheckUpdate.equals("True")) {
					updateResult = categoryMgntDAO.updateCategoryMgntFND_FLEX_VALUES(rowData);
				}

				if (categoryDescCheckUpdate.equals("True")) {
					updateResult = categoryMgntDAO.updateCategoryMgntFND_FLEX_VALUES_TL(rowData);
				}
			}
		}

		if (updateResult == 0) {
			return DisConstants.RESULT_FAIL;
		} else {
			return DisConstants.RESULT_SUCCESS;
		}
	}
}

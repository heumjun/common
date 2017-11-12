package stxship.dis.item.searchItem.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.item.searchItem.dao.SearchItemDAO;

/**
 * @파일명 : SearchItemServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 1. 7.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  아이템 Search 서비스
 *     </pre>
 */
@Service("searchItemService")
public class SearchItemServiceImpl extends CommonServiceImpl implements SearchItemService {

	@Resource(name = "searchItemDAO")
	private SearchItemDAO searchItemDAO;

	/**
	 * @메소드명 : searchItemExcelExport
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 아이템 Search 엑셀 출력기능
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View searchItemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();

		colName.add("Item Code");
		colName.add("Item Desc");
		colName.add("Item Type");
		colName.add("Item Catalog");
		colName.add("ShipType");
		colName.add("UOM");
		colName.add("Weight");
		colName.add("ATTR01");
		colName.add("ATTR02");
		colName.add("ATTR03");
		colName.add("ATTR04");
		colName.add("ATTR05");
		colName.add("ATTR06");
		colName.add("ATTR07");
		colName.add("ATTR08");
		colName.add("ATTR09");
		colName.add("ATTR10");
		colName.add("ATTR11");
		colName.add("ATTR12");
		colName.add("ATTR13");
		colName.add("ATTR14");
		colName.add("ATTR15");
		colName.add("Cable Length");
		colName.add("Cable Type");
		colName.add("Cable Outdia");
		colName.add("Can Size");
		colName.add("STXSVR");
		colName.add("Thinner Code");
		/*colName.add("Stx Standard");*/
		colName.add("Paint Code");
		colName.add("Item Category");
		colName.add("Modified Date");
		colName.add("Originator");
		colName.add("상태");

		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();

		List<Map<String, Object>> itemList = searchItemDAO.searchItemExcelList(commandMap.getMap());

		for (Map<String, Object> rowData : itemList) {
			// Map을 리스트로 변경
			List<String> row = new ArrayList<String>();

			row.add(DisStringUtil.nullString(rowData.get("item_code")));
			row.add(DisStringUtil.nullString(rowData.get("item_desc")));
			row.add(DisStringUtil.nullString(rowData.get("item_type")));
			row.add(DisStringUtil.nullString(rowData.get("item_catalog")));
			row.add(DisStringUtil.nullString(rowData.get("ship_type")));
			row.add(DisStringUtil.nullString(rowData.get("uom")));
			row.add(DisStringUtil.nullString(rowData.get("item_weight")));
			row.add(DisStringUtil.nullString(rowData.get("attr1")));
			row.add(DisStringUtil.nullString(rowData.get("attr2")));
			row.add(DisStringUtil.nullString(rowData.get("attr3")));
			row.add(DisStringUtil.nullString(rowData.get("attr4")));
			row.add(DisStringUtil.nullString(rowData.get("attr5")));
			row.add(DisStringUtil.nullString(rowData.get("attr6")));
			row.add(DisStringUtil.nullString(rowData.get("attr7")));
			row.add(DisStringUtil.nullString(rowData.get("attr8")));
			row.add(DisStringUtil.nullString(rowData.get("attr9")));
			row.add(DisStringUtil.nullString(rowData.get("attr10")));
			row.add(DisStringUtil.nullString(rowData.get("attr11")));
			row.add(DisStringUtil.nullString(rowData.get("attr12")));
			row.add(DisStringUtil.nullString(rowData.get("attr13")));
			row.add(DisStringUtil.nullString(rowData.get("attr14")));
			row.add(DisStringUtil.nullString(rowData.get("attr15")));
			row.add(DisStringUtil.nullString(rowData.get("cable_length")));
			row.add(DisStringUtil.nullString(rowData.get("cable_type")));
			row.add(DisStringUtil.nullString(rowData.get("cable_outdia")));
			row.add(DisStringUtil.nullString(rowData.get("can_size")));
			row.add(DisStringUtil.nullString(rowData.get("stxsvr")));
			row.add(DisStringUtil.nullString(rowData.get("thinner_code")));
			/*row.add(DisStringUtil.nullString(rowData.get("stx_standard")));*/
			row.add(DisStringUtil.nullString(rowData.get("paint_code")));
			row.add(DisStringUtil.nullString(rowData.get("item_category")));
			row.add(DisStringUtil.nullString(rowData.get("modified_date")));
			row.add(DisStringUtil.nullString(rowData.get("originator")));
			row.add(DisStringUtil.nullString(rowData.get("states")));

			colValue.add(row);
		}

		// 오늘 날짜 구함 시작
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
		Date currentTime = new Date();
		String dateToday = formatter.format(currentTime);
		// 오늘 날짜 구함 끝

		modelMap.put("excelName", "SearchItem" + "_" + dateToday);
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);

		return new GenericExcelView();

	}

	@Override
	public Map<String, Object> searchItemList(CommandMap commandMap) throws Exception {
		
		// 리스트를 취득한다.
		Object pageSize = commandMap.get(DisConstants.FROM_GRID_PAGE_SIZE);
		Object curPageNo = commandMap.get(DisConstants.FROM_GRID_CUR_PAGE_NO);
		commandMap.put(DisConstants.SET_DB_PAGE_SIZE, pageSize);
		commandMap.put(DisConstants.SET_DB_CUR_PAGE_NO, curPageNo);
		String[] item_code_arr = {};
		if(!commandMap.get("item_code").equals("") || commandMap.get("item_code") != null) {
			item_code_arr = commandMap.get("item_code").toString().split(",");
		}
		commandMap.put("item_code_arr", item_code_arr);
		
		List<Map<String, Object>> listData = searchItemDAO.searchItemList(commandMap.getMap());
	
		// 리스트 총 사이즈를 구한다.
		Object listRowCnt = listData.size();
		if (!DisConstants.NO.equals(commandMap.get(DisConstants.IS_PAGING))) {
			listRowCnt = getGridListSize(commandMap.getMap());
		}
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
	
	@Override
	public String searchItemDwgPopupViewList(CommandMap commandMap) throws Exception {
		
		List<Map<String, Object>> list = null;
		
		String sErrMsg = "";
		String sErrCode = "";
		String p_print_seq = "";
		String p_print_flag = "";
		String pml_Code = "";

		try {
			// 프로시저는 넘겨준 MAP에 결과가 리턴된다.
			searchItemDAO.getPrintSeqH(commandMap.getMap());

			// 프로시저 결과 받음
			p_print_seq = (String) commandMap.get("p_print_seq");
			sErrMsg = DisStringUtil.nullString(commandMap.get("p_error_msg"));
			sErrCode = DisStringUtil.nullString(commandMap.get("p_error_code"));
			
			if (!"".equals(sErrMsg)) {
				throw new DisException(sErrMsg);
			} else {
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				String iSeq = p_print_seq;
				
				//StringTokenizer st = new StringTokenizer((String) commandMap.get("P_FILE_NAME"), "|");
				//while(st.hasMoreTokens())
				//{
					//String checkFileName = st.nextToken();
					pkgParam.put("p_print_seq", iSeq);
					//pkgParam.put("p_file_name", checkFileName);
					pkgParam.put("p_item_code", commandMap.get("p_item_code"));
					
					searchItemDAO.getPrintSeqD(pkgParam);
					
					sErrMsg = DisStringUtil.nullString(pkgParam.get("p_error_msg"));
					sErrCode = DisStringUtil.nullString(pkgParam.get("p_error_code"));
					
					if (!"".equals(sErrMsg)) {
						throw new DisException(sErrMsg);
					}	
				//}
				
				searchItemDAO.getPrintSeq(pkgParam);
				
				p_print_flag = DisStringUtil.nullString(pkgParam.get("p_print_flag"));
				
				if (p_print_flag.equals("S")) {
					list = searchItemDAO.searchItemDwgPopupViewList(pkgParam);
					for(Map<String, Object> data : list) {
						pml_Code += data.get("pml_code").toString();
					}
				} else {
					throw new DisException(sErrMsg);
				}
			}

			// 여기까지 Exception 없으면 성공 메시지
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, DisMessageUtil.getMessage("common.default.succ"));
			
		} catch (Exception e) {
			commandMap.put(DisConstants.RESULT_MASAGE_KEY, e.getLocalizedMessage());
		}
		
		// 3. 결과 리턴
		return pml_Code;
	}

}

package stxship.dis.baseInfo.updateItemsAttr.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import stxship.dis.baseInfo.updateItemsAttr.dao.UpdateItemsAttrDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisExcelUtil;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;

/**
 * @파일명 : UpdateItemsAttrServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Update Item Attr 메뉴가 선택되었을때 사용되는 서비스
 *     </pre>
 */
@Service("updateItemsAttrService")
public class UpdateItemsAttrServiceImpl extends CommonServiceImpl implements UpdateItemsAttrService {

	@Resource(name = "updateItemsAttrDAO")
	private UpdateItemsAttrDAO updateItemsAttrDAO;

	/**
	 * @메소드명 : updatePlmErpDBcommandMap
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 인포트 된 내용을 PLM ERP DB에 업데이트 한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> updatePlmErpDBcommandMap(CommandMap commandMap) throws Exception {

		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();

		// List Map 형식으로 형변환
		List<Map<String, Object>> updateList = DisJsonUtil.toList(gridDataList);

		int updateResult = 0;
		for (Map<String, Object> rowData : updateList) {
			rowData.put("p_login_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			// update 되지 않은 건만 update한다.
			String sPlmflag = rowData.get("plmflag") == null ? "" : rowData.get("plmflag").toString();
			if ("N".equals(sPlmflag)) {
				// PLM Item Attribute Update
				updateResult = updateItemsAttrDAO.updatePlmItemAttribute(rowData);
				// PLM Flag Update
				updateResult = updateItemsAttrDAO.updatePlmFlag(rowData);
				if (updateResult == 0) {
					break;
				}
			}
			
			

			// if 되지 않은 건만 if한다.
			String sErpflag = rowData.get("erpflag") == null ? "" : rowData.get("erpflag").toString();
			if ("N".equals(sErpflag)) {
				// ERP Item Attribute Update
				Map<String, Object> pkgParam = new HashMap<String, Object>();
				pkgParam.put("p_item", rowData.get("item"));
				pkgParam.put("p_item_desc", rowData.get("item_desc"));
				pkgParam.put("p_attr0", rowData.get("attr0"));
				pkgParam.put("p_attr1", rowData.get("attr1"));
				pkgParam.put("p_attr2", rowData.get("attr2"));
				pkgParam.put("p_attr3", rowData.get("attr3"));
				pkgParam.put("p_attr4", rowData.get("attr4"));
				pkgParam.put("p_attr5", rowData.get("attr5"));
				pkgParam.put("p_attr6", rowData.get("attr6"));
				pkgParam.put("p_attr7", rowData.get("attr7"));
				pkgParam.put("p_attr8", rowData.get("attr8"));
				pkgParam.put("p_attr9", rowData.get("attr9"));
				pkgParam.put("p_attr10", rowData.get("attr10"));
				pkgParam.put("p_attr11", rowData.get("attr11"));
				pkgParam.put("p_attr12", rowData.get("attr12"));
				pkgParam.put("p_attr13", rowData.get("attr13"));
				pkgParam.put("p_attr14", rowData.get("attr14"));
				pkgParam.put("p_weight", rowData.get("weight"));
				pkgParam.put("p_cable_outdia", rowData.get("cable_outdia"));
				pkgParam.put("p_cable_length", rowData.get("cable_length"));
				pkgParam.put("p_cable_type", rowData.get("cable_type"));
				pkgParam.put("p_can_size", rowData.get("can_size"));
				pkgParam.put("p_stxsvr", rowData.get("stxsvr"));
				pkgParam.put("p_stxstandard", rowData.get("stxstandard"));
				pkgParam.put("p_paint_code", rowData.get("paint_code"));
				pkgParam.put("p_thinner_code", rowData.get("thinner_code"));

				updateResult = updateItemsAttrDAO.updateErpItemAttribute(pkgParam);

				String rtn = pkgParam.get("p_rtn") == null ? "" : pkgParam.get("p_rtn").toString();

				// ERP Flag Update
				if (updateResult != 0 && "Y".equals(rtn)) {
					updateResult = updateItemsAttrDAO.updateErpFlag(rowData);
				}
				if (updateResult == 0) {
					break;
				}
			}
			// 삭제 전에 history에 저장
			updateResult = updateItemsAttrDAO.insertItemAttributeUpdateHistoryList(rowData);
			if (updateResult == 0) {
				break;
			}			
			
			updateResult = updateItemsAttrDAO.deleteItemAttributeUpdateList(rowData);
			if (updateResult == 0) {
				break;
			}
		}
		if (updateResult == 0) {
			throw new DisException();
		} else {
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		}

	}

	private Map<String, Object> toMap(Row row) {
		Map<String, Object> map = new HashMap<String, Object>();
		int i = 0;

		map.put("item", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("item_desc", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("weight", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr0", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr1", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr2", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr3", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr4", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr5", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr6", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr7", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr8", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr9", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr10", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr11", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr12", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr13", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("attr14", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("cable_outdia", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("can_size", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("stxsvr", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("thinner_code", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("paint_code", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("cable_type", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("cable_length", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("stxstandard", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("tbc_paint_code", DisStringUtil.nullString(DisExcelUtil.getCellValue(row.getCell(i++))).trim());
		map.put("plmflag", "N");
		map.put("erpflag", "N");
		
		return map;
	}

	/**
	 * @메소드명 : itemAttributeExcelImport
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀의 내용을 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param response
	 * @throws Exception
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public void itemAttributeExcelImport(CommonsMultipartFile file, HttpServletResponse response, CommandMap commandMap) throws Exception {

		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		FileInputStream tempFile = new FileInputStream(DecryptFile);
		
		Workbook workbook = WorkbookFactory.create(tempFile);
		Sheet sheet = null;
		
		for(int i = 0; i < workbook.getNumberOfSheets(); i++) {
			if(workbook.getSheetAt(i).getRow(0) != null) {
				sheet = workbook.getSheetAt(i);
				break;
			}
		}		

		Iterator<Row> rowIterator = sheet.iterator();

		List<Map<String, Object>> uploadList = new ArrayList<Map<String, Object>>();

		int j = 0;
		while (rowIterator.hasNext()) {
			Row row = rowIterator.next();
			String cellData = DisStringUtil.nullString(row.getCell(0));
			
			if (!"".equals(cellData)) {
				if (j > 3) {
					uploadList.add(toMap(row));
				}
			}
			j++;
		}
		
		//복화화된 파일 삭제
		DisEGDecrypt.deleteDecryptFile(DecryptFile);
		
		int importResult = 0;
		
		// 결과값 최초
		StringBuffer result = resultPopUp(DisMessageUtil.getMessage("common.default.fail"));
		
		String[] mapKey = {"attr0", "attr1", "attr2", "attr3", "attr4", "attr5"
				, "attr6", "attr7", "attr8", "attr9", "attr10", "attr11", "attr12", "attr13", "attr14"};
		
		boolean checkFlag = true;
		String checkStr = ""; 
		
		for (Map<String, Object> rowData : uploadList) {
			
			for(int idx=0; idx<mapKey.length; idx++) {
				if( checkByte( (String) rowData.get(mapKey[idx]) ) > 40 ){
					checkFlag = false;
					checkStr = (String) mapKey[idx];
					break;
				}
			}
		}
		
		response.setContentType("text/html;charset=UTF-8");
		String clearFlag = (String) commandMap.get("clearFlag");
		
		if(checkFlag) {
			
			for (Map<String, Object> rowData : uploadList) {
				
				importResult = updateItemsAttrDAO.deleteItemAttributeUpdateList(rowData);				
				if(clearFlag.equals("N")) {
					importResult = updateItemsAttrDAO.insertItemAttributeUpdateList(rowData);
				}
			
			}
			
			if (importResult == 0) {
				// 실패한경우
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			} else {
				result = resultPopUp(DisMessageUtil.getMessage("common.default.succ"));
			}
		} else {
			result = resultPopUp("[" + checkStr.toUpperCase() + "] 에서 40Byte 초과 입력하였습니다.\\n최대 자릿수 40Byte 이하 입력 제약입니다.");
		}
		// 결과값에 따른 메시지를 담아 전송
		response.getWriter().println(result);
		
	}

	private StringBuffer resultPopUp(String message) {
		StringBuffer sb = new StringBuffer();
		sb.append("<script type=\"text/javascript\" >");
		sb.append("alert('" + message + "');");
		sb.append("location.href='updateItemAttribute.do?up_link=baseInfo';");
		sb.append("</script>");
		return sb;
	}
	
	private int checkByte(String str) {
		
		int strLength = 0;
		byte[] temp = str.getBytes();
		strLength = temp.length;
		
		return strLength;
	}
	
	
}

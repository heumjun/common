/*
 * @Class Name : RandomUtils.java
 * @Description : 랜덤 유틸 class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2013.12.26    배동오         최초 생성
 *
 * @author 배동오
 * @since 2013.12.26
 * @version 1.0
 * @see
 */
package com.stxdis.util.util;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;

// TODO: Auto-generated Javadoc
/**
 * 랜덤 유틸.
 */
public class ExcelUtils {

	public static Object getCellValue(Cell cell) {
		if( !"".equals( StringUtil.nullString( cell ) ) ) {
			switch (cell.getCellType()) {
			case Cell.CELL_TYPE_STRING: 
				String temp = cell.getRichStringCellValue().getString().toUpperCase();
				
				temp=temp.replace("\"", "\\\"");
				temp=temp.replaceAll("'", "\\\\u0027");
				
				return  temp.trim();
			case Cell.CELL_TYPE_NUMERIC:
				if (DateUtil.isCellDateFormatted(cell)) {
					return cell.getDateCellValue();
				} else {
					return cell.getNumericCellValue();
				}
			case Cell.CELL_TYPE_BOOLEAN:
				return cell.getBooleanCellValue();
			case Cell.CELL_TYPE_FORMULA:
				return cell.getCellFormula();
			default:
				return "";
			}
		} else {
			return "";
		}
	}

}

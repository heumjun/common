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
package stxship.dis.common.util;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;

/**
 * @파일명 : DisExcelUtil.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DIS 엑셀처리시 사용되는 유틸
 *     </pre>
 */
public class DisExcelUtil {

	/**
	 * @메소드명 : getCellValue
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀의 내용을 받아온다.
	 *     </pre>
	 * 
	 * @param cell
	 * @return
	 */
	public static Object getCellValue(Cell cell) {
		if (!"".equals(DisStringUtil.nullString(cell))) {
			switch (cell.getCellType()) {
			case Cell.CELL_TYPE_STRING:
				String temp = cell.getRichStringCellValue().getString().toUpperCase();

				temp = temp.replace("\"", "\\\"");
				temp = temp.replaceAll("'", "\\\\u0027");

				return temp.trim();
			case Cell.CELL_TYPE_NUMERIC:
				String value = Double.toString(cell.getNumericCellValue());
				if (value.indexOf(".0") > 0) {
					value = value.replace(".0", "");
				}
				return value;
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

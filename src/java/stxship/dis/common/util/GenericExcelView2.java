package stxship.dis.common.util;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class GenericExcelView2 extends AbstractExcelView {

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	protected void buildExcelDocument(Map<String, Object> modelMap, HSSFWorkbook workbook, HttpServletRequest req,
			HttpServletResponse res) throws Exception {
		// 해더부분셀에 스타일을 주기위한 인스턴스 생성
		HSSFCellStyle headerStyle = workbook.createCellStyle();
		// 스타일인스턴스의 속성
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 셀에 색깔 채우기
		headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		// 폰트 조정 인스턴스 생성
		HSSFFont font = workbook.createFont();
		font.setBoldweight((short) 700);
		headerStyle.setFont(font);

		// 얇은 테두리를 위한 스타일 인스턴스 생성
		HSSFCellStyle botyStyle = workbook.createCellStyle();
		botyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		botyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		botyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		botyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);

		Object objType = modelMap.get("excelName");

		if (objType instanceof String) {
			// 에겟 파일명
			String excelName = (String) modelMap.get("excelName");

			// 엑셀 컬럼명
			List<String> colName = (List<String>) modelMap.get("colName");

			// 엑셀 내용
			List<List> colValue = (List<List>) modelMap.get("colValue");

			res.setContentType("application/msexcel");
			res.addCookie(new Cookie("fileDownloadToken", "OK"));
			res.setHeader("Content-Disposition", "attachment; filename=" + excelName + ".xls");

			HSSFSheet sheet = workbook.createSheet(excelName);

			// 상단 메뉴명 생성
			HSSFRow headRow = sheet.createRow(0);

			for (int i = 0; i < colName.size(); i++) {

				HSSFCell cell = headRow.createCell(i);

				cell.setCellValue(new HSSFRichTextString(colName.get(i)));
				cell.setCellStyle(headerStyle);
			}

			// 내용 생성
			for (int i = 0; i < colValue.size(); i++) {

				// 메뉴 ROW가 있기때문에 +1을 해준다.
				HSSFRow row = sheet.createRow(i + 1);

				for (int j = 0; j < colValue.get(i).size(); j++) {

					HSSFCell cell = row.createCell(j);
					cell.setCellStyle(botyStyle);
					Object value = colValue.get(i).get(j);

					if (value instanceof BigDecimal) {
						cell.setCellValue(((BigDecimal) value).doubleValue());
					} else if (value instanceof Integer) {
						cell.setCellValue((Integer) value);
					} else if (value instanceof Double) {
						cell.setCellValue((Double) value);
					} else {
						cell.setCellValue(new HSSFRichTextString((String) value));
					}

				}
			}

			headRow = sheet.getRow(0);
			for (int colNum = 0; colNum < headRow.getLastCellNum(); colNum++) {
				sheet.autoSizeColumn(colNum);
				// sheet.setColumnWidth(colNum, 500);
			}

		} else if (objType instanceof List) {
			
			List<String> excelNameList = (List<String>) modelMap.get("excelName");
			
			res.setContentType("application/msexcel");
			res.addCookie(new Cookie("fileDownloadToken", "OK"));
			for (int i = 0; i < excelNameList.size(); i++) {

				String excelName = (String) excelNameList.get(i);
				
				if (i == 0) {
					res.setHeader("Content-Disposition", "attachment; filename=" + excelName + ".xls");
				}
				
				HSSFSheet sheet = workbook.createSheet(excelName);

				// 상단 메뉴명 생성
				HSSFRow headRow = sheet.createRow(0);

				// 엑셀 헤드
				List<String> colName = (List<String>) modelMap.get(excelName + "_colName");

				for (int j = 0; j < colName.size(); j++) {

					HSSFCell cell = headRow.createCell(j);
					if(j != 13 && j != 16 && j != 19 && j != 22 && j != 25) {
						cell.setCellStyle(headerStyle);
						cell.setCellValue(new HSSFRichTextString(colName.get(j)));
					}
				}
				
				
				// 엑셀 내용
				List<List<Object>> colValue = (List<List<Object>>) modelMap.get("Supply_Manage_colValue");
				List<List<Object>> colValue2 = (List<List<Object>>) modelMap.get("Supply_Dwg_colValue");
				List<List<Object>> colValue3 = (List<List<Object>>) modelMap.get("Supply_Block_colValue");
				List<List<Object>> colValue4 = (List<List<Object>>) modelMap.get("Supply_Stage_colValue");
				List<List<Object>> colValue5 = (List<List<Object>>) modelMap.get("Supply_Str_colValue");
				List<List<Object>> colValue6 = (List<List<Object>>) modelMap.get("Supply_Catalog_colValue");
				
				// 내용 생성 colvalue
				for (int j = 0; j < colValue.size(); j++) {

					// 메뉴 ROW가 있기때문에 +1을 해준다.
					HSSFRow row = sheet.createRow(j + 1);

					for (int k = 0; k < colValue.get(j).size(); k++) {

						Object value = colValue.get(j).get(k);
						HSSFCell cell = row.createCell(k);
						cell.setCellStyle(botyStyle);
						if (value instanceof BigDecimal) {
							cell.setCellValue(((BigDecimal) value).doubleValue());
						} else if (value instanceof Integer) {
							cell.setCellValue((Integer) value);
						} else if (value instanceof Double) {
							cell.setCellValue((Double) value);
						} else {
							cell.setCellValue(new HSSFRichTextString((String) value));
						}

					}
					
				}
				
				// 내용 생성 colvalue2
				for (int j = 0; j < colValue2.size(); j++) {
					
					HSSFRow row = sheet.getRow(j + 1);
					// 메뉴 ROW가 있기때문에 +1을 해준다.
					if(null == row) {
						row = sheet.createRow(j + 1);
					}

					for (int k = 0; k < colValue2.get(j).size(); k++) {

						Object value = colValue2.get(j).get(k);
						
						HSSFCell cell = row.getCell(k+14);
						if(cell == null) {
							cell = row.createCell(k + 14);
						}
						
						cell.setCellStyle(botyStyle);
						if (value instanceof BigDecimal) {
							cell.setCellValue(((BigDecimal) value).doubleValue());
						} else if (value instanceof Integer) {
							cell.setCellValue((Integer) value);
						} else if (value instanceof Double) {
							cell.setCellValue((Double) value);
						} else {
							cell.setCellValue(new HSSFRichTextString((String) value));
						}

					}
				}
				
				// 내용 생성 colvalue3
				for (int j = 0; j < colValue3.size(); j++) {
					
					HSSFRow row = sheet.getRow(j + 1);
					// 메뉴 ROW가 있기때문에 +1을 해준다.
					if(null == row) {
						row = sheet.createRow(j + 1);
					}

					for (int k = 0; k < colValue3.get(j).size(); k++) {

						Object value = colValue3.get(j).get(k);
						
						HSSFCell cell = row.getCell(k+17);
						if(cell == null) {
							cell = row.createCell(k + 17);
						}
						
						cell.setCellStyle(botyStyle);
						if (value instanceof BigDecimal) {
							cell.setCellValue(((BigDecimal) value).doubleValue());
						} else if (value instanceof Integer) {
							cell.setCellValue((Integer) value);
						} else if (value instanceof Double) {
							cell.setCellValue((Double) value);
						} else {
							cell.setCellValue(new HSSFRichTextString((String) value));
						}

					}
				}
				
				// 내용 생성 colvalue4
				for (int j = 0; j < colValue4.size(); j++) {
					
					HSSFRow row = sheet.getRow(j + 1);
					// 메뉴 ROW가 있기때문에 +1을 해준다.
					if(null == row) {
						row = sheet.createRow(j + 1);
					}

					for (int k = 0; k < colValue4.get(j).size(); k++) {

						Object value = colValue4.get(j).get(k);
						
						HSSFCell cell = row.getCell(k+20);
						if(cell == null) {
							cell = row.createCell(k + 20);
						}
						
						cell.setCellStyle(botyStyle);
						if (value instanceof BigDecimal) {
							cell.setCellValue(((BigDecimal) value).doubleValue());
						} else if (value instanceof Integer) {
							cell.setCellValue((Integer) value);
						} else if (value instanceof Double) {
							cell.setCellValue((Double) value);
						} else {
							cell.setCellValue(new HSSFRichTextString((String) value));
						}

					}
				}
				
				// 내용 생성 colvalue5
				for (int j = 0; j < colValue5.size(); j++) {
					
					HSSFRow row = sheet.getRow(j + 1);
					// 메뉴 ROW가 있기때문에 +1을 해준다.
					if(null == row) {
						row = sheet.createRow(j + 1);
					}

					for (int k = 0; k < colValue5.get(j).size(); k++) {

						Object value = colValue5.get(j).get(k);
						
						HSSFCell cell = row.getCell(k+23);
						if(cell == null) {
							cell = row.createCell(k + 23);
						}
						
						cell.setCellStyle(botyStyle);
						if (value instanceof BigDecimal) {
							cell.setCellValue(((BigDecimal) value).doubleValue());
						} else if (value instanceof Integer) {
							cell.setCellValue((Integer) value);
						} else if (value instanceof Double) {
							cell.setCellValue((Double) value);
						} else {
							cell.setCellValue(new HSSFRichTextString((String) value));
						}

					}
				}
				
				// 내용 생성 colvalue6
				for (int j = 0; j < colValue6.size(); j++) {
					
					HSSFRow row = sheet.getRow(j + 1);
					// 메뉴 ROW가 있기때문에 +1을 해준다.
					if(null == row) {
						row = sheet.createRow(j + 1);
					}

					for (int k = 0; k < colValue6.get(j).size(); k++) {

						Object value = colValue6.get(j).get(k);
						
						HSSFCell cell = row.getCell(k+26);
						if(cell == null) {
							cell = row.createCell(k + 26);
						}
						
						cell.setCellStyle(botyStyle);
						if (value instanceof BigDecimal) {
							cell.setCellValue(((BigDecimal) value).doubleValue());
						} else if (value instanceof Integer) {
							cell.setCellValue((Integer) value);
						} else if (value instanceof Double) {
							cell.setCellValue((Double) value);
						} else {
							cell.setCellValue(new HSSFRichTextString((String) value));
						}
					}
				}

				headRow = sheet.getRow(0);
				for (int colNum = 0; colNum < headRow.getLastCellNum(); colNum++) {
					if(colNum == 13 || colNum == 16 || colNum == 19 || colNum == 22 || colNum == 25) {
						// sheet.setColumnWidth(colNum, 500);
						sheet.setColumnWidth(colNum, 2000);
					} else {
						sheet.autoSizeColumn(colNum);
					}
				}

			}
		}

	}

}

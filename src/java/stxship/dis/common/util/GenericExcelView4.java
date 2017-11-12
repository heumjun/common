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

public class GenericExcelView4 extends AbstractExcelView {

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
			HSSFRow headRow = sheet.createRow(2);
			
			
			HSSFRow headRow1 = sheet.createRow(0);
			HSSFCell cell7 = headRow1.createCell(21);
			HSSFCell cell8 = headRow1.createCell(22);
			HSSFCell cell9 = headRow1.createCell(23);
			HSSFCell cell10 = headRow1.createCell(24);
			HSSFCell cell12 = headRow1.createCell(25);
			cell7.setCellValue("고정");
			cell8.setCellValue("조정");
			cell9.setCellValue("관통");
			cell10.setCellValue("Total EA");
			cell12.setCellValue("Total WT");
			cell7.setCellStyle(headerStyle);
			cell8.setCellStyle(headerStyle);
			cell9.setCellStyle(headerStyle);
			cell10.setCellStyle(headerStyle);
			cell12.setCellStyle(headerStyle);
			
			HSSFRow headRow2 = sheet.createRow(1);
			HSSFCell cell77 = headRow2.createCell(21);
			HSSFCell cell88 = headRow2.createCell(22);
			HSSFCell cell99 = headRow2.createCell(23);
			HSSFCell cell1010 = headRow2.createCell(24);
			HSSFCell cell1212 = headRow2.createCell(25);
			cell77.setCellValue((Integer) modelMap.get("tot_f"));
			cell88.setCellValue((Integer) modelMap.get("tot_a"));
			cell99.setCellValue((Integer) modelMap.get("tot_p"));
			cell1010.setCellValue((Integer) modelMap.get("totalEa"));
			cell1212.setCellValue(new HSSFRichTextString((String) modelMap.get("totalWeight") ));
			cell77.setCellStyle(botyStyle);
			cell88.setCellStyle(botyStyle);
			cell99.setCellStyle(botyStyle);
			cell1010.setCellStyle(botyStyle);
			cell1212.setCellStyle(botyStyle);
			
			for (int i = 0; i < colName.size(); i++) {

				HSSFCell cell = headRow.createCell(i);

				cell.setCellValue(new HSSFRichTextString(colName.get(i)));
				cell.setCellStyle(headerStyle);
			}
			

			// 내용 생성
			for (int i = 0; i < colValue.size(); i++) {

				// 메뉴 ROW가 있기때문에 +1을 해준다.
				HSSFRow row = sheet.createRow(i + 3);

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

			headRow = sheet.getRow(2);
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

				if (i == 0)
					res.setHeader("Content-Disposition", "attachment; filename=" + excelName + ".xls");

				HSSFSheet sheet = workbook.createSheet(excelName);

				// 상단 메뉴명 생성
				HSSFRow headRow = sheet.createRow(0);

				// 엑셀 헤드
				List<String> colName = (List<String>) modelMap.get(excelName + "_colName");

				// 엑셀 내용
				List<List<Object>> colValue = (List<List<Object>>) modelMap.get(excelName + "_colValue");

				for (int j = 0; j < colName.size(); j++) {

					HSSFCell cell = headRow.createCell(j);
					cell.setCellStyle(headerStyle);
					cell.setCellValue(new HSSFRichTextString(colName.get(j)));

				}

				// 내용 생성
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

				headRow = sheet.getRow(0);
				for (int colNum = 0; colNum < headRow.getLastCellNum(); colNum++) {
					sheet.autoSizeColumn(colNum);
					// sheet.setColumnWidth(colNum, 500);
				}

			}
		}

	}

}

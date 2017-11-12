package stxship.dis.common.util;

import java.math.BigDecimal;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.maven.wagon.observers.Debug;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.Region;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class GenericExcelView3 extends AbstractExcelView {

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
		headerStyle.setShrinkToFit(true);
		
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
			List<Map<String,Object>> colName = (List<Map<String,Object>>) modelMap.get("colName");

			// 엑셀 내용
			List<List> colValue = (List<List>) modelMap.get("colValue");

			res.setContentType("application/msexcel");
			res.addCookie(new Cookie("fileDownloadToken", "OK"));
			res.setHeader("Content-Disposition", "attachment; filename=" + excelName + ".xls");

			HSSFSheet sheet = workbook.createSheet(excelName);
			
			//전체 컬럼 맥스idx구하기
			int maxIdx = 0;
			for(int i = 0; i < colName.size(); i++){
				List<Map<String,Object>> header = (List<Map<String, Object>>) colName.get(i).get("rowvalue");
				for(Map<String,Object> row : header){
					int endIdx = (int) row.get("end_index");
					if(maxIdx <= endIdx) maxIdx = endIdx;
				}
				
			}
			//전체 셀 생성 및 스타일 적용
			for(int i = 0; i < colName.size(); i++){
				HSSFRow headRow = sheet.createRow(i);
				List<Map<String,Object>> header = (List<Map<String, Object>>) colName.get(i).get("rowvalue");
				for(int c = 0; c <= maxIdx; c++){
					HSSFCell cell = headRow.createCell(c);
					cell.setCellStyle(headerStyle);
				}
			}
			//전체 셀 헤더 명 적용
			for(int i = 0; i < colName.size(); i++){
				List<Map<String,Object>> header = (List<Map<String, Object>>) colName.get(i).get("rowvalue");
				HSSFRow excelRow = sheet.getRow(i);
				//컬럼 이름 설정				
				for(Map<String,Object> row : header){
					int startIdx = (int) row.get("start_index");
					int endIdx = (int) row.get("end_index");
					HSSFCell cell = excelRow.getCell(startIdx);
					cell.setCellValue(new HSSFRichTextString ((String)row.get("name")));
				}
			}
			//전체 셀 머지 영역 설정
			for(int i = 0; i < colName.size(); i++){
				List<Map<String,Object>> header = (List<Map<String, Object>>) colName.get(i).get("rowvalue");
				//머지 영역설정
				for(Map<String,Object> row : header){
					int rowTo = (int) row.get("row_to");
					int startIdx = (int) row.get("start_index");
					int endIdx = (int) row.get("end_index");
					/*logger.debug(rowTo+"|"+startIdx+"|"+endIdx);*/
					sheet.addMergedRegion(new Region((int)i, (short)startIdx, (int)rowTo,(short)endIdx));
				}
				
			}

			// 내용 생성
			for (int i = 0; i < colValue.size(); i++) {

				// 메뉴 ROW가 있기때문에 메뉴로우 수 만큼 더 해준다.
				HSSFRow row = sheet.createRow(i + colName.size());

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
			//컬럼 사이즈 조정
			sheet.autoSizeColumn(0);
		}
		/** list형태의 경우 추후 필요할경우 생성**/
	}

}

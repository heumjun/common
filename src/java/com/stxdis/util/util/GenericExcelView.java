package com.stxdis.util.util;


import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import org.springframework.web.servlet.view.document.AbstractExcelView;

public class GenericExcelView extends AbstractExcelView {
	
	@Override
	protected void buildExcelDocument(Map<String, Object> modelMap,
									  HSSFWorkbook 		  workbook, 
									  HttpServletRequest  req,
									  HttpServletResponse res) throws Exception 
	{

		Object objType =  modelMap.get("excelName");
		
		if (objType instanceof String) {
			// 에겟 파일명
			String excelName = (String) modelMap.get("excelName");
			
			// 엑셀 컬럼명
			List<String> colName = (List<String>) modelMap.get("colName");
			
			// 엑셀 내용
			List<List> colValue = (List<List>) modelMap.get("colValue");

			res.setContentType("application/msexcel");
			res.setHeader("Content-Disposition", "attachment; filename="+ excelName + ".xls");

			HSSFSheet sheet = workbook.createSheet(excelName);

			// 상단 메뉴명 생성
			HSSFRow headRow = sheet.createRow(0);

			for (int i = 0; i < colName.size(); i++) {

				HSSFCell cell = headRow.createCell(i);

				cell.setCellValue(new HSSFRichTextString(colName.get(i)));

			}
			
			// 내용 생성
			for (int i = 0; i < colValue.size(); i++) {

				// 메뉴 ROW가 있기때문에 +1을 해준다.
				HSSFRow row = sheet.createRow(i + 1);

				for (int j = 0; j < colValue.get(i).size(); j++) {
					
					HSSFCell   cell = row.createCell(j);
					
					Object    value = colValue.get(i).get(j);
						
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
			for(int colNum = 0; colNum<headRow.getLastCellNum();colNum++) {
				sheet.autoSizeColumn(colNum);
				//sheet.setColumnWidth(colNum, 500);
			}
			
		} else if (objType instanceof List) {
			
			List<String> excelNameList = (List<String>) modelMap.get("excelName");
			
			res.setContentType("application/msexcel");
						
			for(int i=0; i<excelNameList.size(); i++) {
				
				String excelName = (String) excelNameList.get(i);
				
				if (i==0) res.setHeader("Content-Disposition", "attachment; filename="+ excelName + ".xls");
				
				HSSFSheet sheet = workbook.createSheet(excelName);
				
				// 상단 메뉴명 생성
				HSSFRow headRow = sheet.createRow(0);
				
				// 엑셀 헤드
				List<String> 		colName = (List<String>) modelMap.get(excelName+"_colName");
				
				// 엑셀 내용
				List<List<Object>> colValue = (List<List<Object>>) modelMap.get(excelName+"_colValue");
				
				for (int j = 0; j < colName.size(); j++) {

					HSSFCell cell = headRow.createCell(j);
					

					cell.setCellValue(new HSSFRichTextString(colName.get(j)));

				}
				
				// 내용 생성
				for (int j = 0; j < colValue.size(); j++) {

					// 메뉴 ROW가 있기때문에 +1을 해준다.
					HSSFRow row = sheet.createRow(j + 1);

					for (int k = 0; k < colValue.get(j).size(); k++) {
						
						Object   value = colValue.get(j).get(k);
						HSSFCell  cell = row.createCell(k);
						
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
				for(int colNum = 0; colNum<headRow.getLastCellNum();colNum++) {
					sheet.autoSizeColumn(colNum);
					//sheet.setColumnWidth(colNum, 500);
				}
					
			}
		}

	}

}

package stxship.dis.common.util;

import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.springframework.beans.factory.annotation.Autowired;

import stxship.dis.common.command.CommandMap;

@SuppressWarnings({"unchecked", "deprecation"})
public class GenericExcelView5 extends AbstractExcelView1 {
	
	@Autowired
	@Override
	public void buildExcelDocument(Map<String, Object> modelMap, Workbook workbook, HttpServletRequest req,
			HttpServletResponse res) throws Exception {
		
		// headerStyle4 : main title font
		XSSFCellStyle headerStyle4 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 스타일인스턴스의 속성
		headerStyle4.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		headerStyle4.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		// 셀에 색깔 채우기
		headerStyle4.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.getIndex());
		headerStyle4.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle4.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle4.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle4.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle4.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		headerStyle4.setWrapText(true ); 
		
		// headerStyle1 : main sub font 정보
		XSSFCellStyle headerStyle1 = (XSSFCellStyle) workbook.createCellStyle();
		// 스타일인스턴스의 속성
		headerStyle1.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		// 셀에 색깔 채우기
		headerStyle1.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
		headerStyle1.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle1.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle1.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle1.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle1.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		// headerStyle2 : main text 정보
		XSSFCellStyle headerStyle2 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 스타일인스턴스의 속성
		headerStyle2.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		headerStyle2.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		// 셀에 색깔 채우기
		headerStyle2.setFillForegroundColor(IndexedColors.WHITE.getIndex());
		headerStyle2.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle2.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		headerStyle2.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle2.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle2.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle2.setWrapText(true);

		// HSSFCellStyle : main text  정렬 왼쪽 정보
		XSSFCellStyle headerStyle7 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 스타일인스턴스의 속성
		headerStyle7.setAlignment(XSSFCellStyle.ALIGN_LEFT);
		headerStyle7.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		// 셀에 색깔 채우기
		headerStyle7.setFillForegroundColor(IndexedColors.WHITE.getIndex());
		headerStyle7.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle7.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle7.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle7.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle7.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		headerStyle7.setWrapText(true);
		
		// headerStyle : main desc font 정보
		XSSFCellStyle headerStyle = (XSSFCellStyle) workbook.createCellStyle();
		// 스타일인스턴스의 속성
		headerStyle.setAlignment(XSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		// 셀에 색깔 채우기
		headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		headerStyle.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		
		// headerStyle : main desc font 정보
		XSSFCellStyle headerStyle6 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 셀에 색깔 채우기
		headerStyle6.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
		headerStyle6.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정
		headerStyle6.setAlignment(XSSFCellStyle.ALIGN_LEFT);
		headerStyle6.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		headerStyle6.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle6.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle6.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle6.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		headerStyle6.setWrapText(true);
		
		// headerStyle3 : subject font 정보
		XSSFCellStyle headerStyle3 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 스타일인스턴스의 속성
		headerStyle3.setAlignment(XSSFCellStyle.ALIGN_LEFT);
		// 셀에 색깔 채우기
		headerStyle3.setFillForegroundColor(IndexedColors.LIME.getIndex());
		headerStyle3.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle3.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle3.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle3.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle3.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		headerStyle3.setWrapText(true);

		// headerStyle5 : sub_desc font 정보
		XSSFCellStyle headerStyle5 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 스타일인스턴스의 속성
		headerStyle5.setAlignment(XSSFCellStyle.ALIGN_LEFT);
		headerStyle5.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		// 셀에 색깔 채우기
		headerStyle5.setFillForegroundColor(IndexedColors.LEMON_CHIFFON.getIndex());
		headerStyle5.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle5.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle5.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		headerStyle5.setBorderTop(XSSFCellStyle.BORDER_THIN);
		headerStyle5.setBorderBottom(XSSFCellStyle.BORDER_THIN);
		headerStyle5.setWrapText(true);
		
		// headerStyle8 : main text  정렬 왼쪽 정보
		XSSFCellStyle headerStyle8 = (XSSFCellStyle) workbook.createCellStyle(); 
		// 스타일인스턴스의 속성
		headerStyle8.setAlignment(XSSFCellStyle.ALIGN_LEFT);
		headerStyle8.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
		// 셀에 색깔 채우기
		headerStyle8.setFillForegroundColor(IndexedColors.WHITE.getIndex());
		headerStyle8.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
		// 테두리 설정 
		headerStyle8.setBorderRight(XSSFCellStyle.BORDER_THIN);
		headerStyle8.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		//headerStyle8.setBorderTop(HSSFCellStyle.BORDER_NONE);
		//headerStyle8.setBorderBottom(HSSFCellStyle.BORDER_NONE);
		
		// 폰트 조정 인스턴스 생성
		XSSFFont font = (XSSFFont) workbook.createFont();
		font.setBoldweight((short) 700);
		headerStyle.setFont(font);
		headerStyle1.setFont(font);

		// 얇은 테두리를 위한 스타일 인스턴스 생성
		XSSFCellStyle botyStyle = (XSSFCellStyle) workbook.createCellStyle();
		botyStyle.setBorderRight(XSSFCellStyle.BORDER_THIN);
		botyStyle.setBorderLeft(XSSFCellStyle.BORDER_THIN);
		botyStyle.setBorderTop(XSSFCellStyle.BORDER_THIN);
		botyStyle.setBorderBottom(XSSFCellStyle.BORDER_THIN);

		if (true) {
			// 에겟 파일명
			CommandMap commandMap = (CommandMap) modelMap.get("commandMap");
			String excelName = commandMap.get("p_project_no") + "-" + commandMap.get("p_dwg_no") + "-" +"pcf";
			Map<String, Object> pcfHeader = (Map<String, Object>) modelMap.get("pcfHeader");
			
			List<Map<String, Object>> pcfHistoryList = (List<Map<String, Object>>) modelMap.get("pcfHistoryList");
			
			res.setContentType("application/vnd.ms-excel");
			res.addCookie(new Cookie("fileDownloadToken", "OK"));
			res.setHeader("Content-Disposition", "attachment; filename=" + excelName + ".xlsx");

			XSSFSheet sheet = (XSSFSheet) workbook.createSheet(excelName);

			// 상단 메뉴명 생성
			XSSFRow headRow = sheet.createRow((short) 0); 
			
			//시작행번호 마지막 행번호 시작열번호 마지막열번호
			sheet.addMergedRegion (new CellRangeAddress(0,1,0,5));  //PLAN COMMENT FORM
			sheet.addMergedRegion (new CellRangeAddress(0,0,6,7));  //HULL NO
			sheet.addMergedRegion (new CellRangeAddress(0,0,8,11)); //S1514/15/16			
			sheet.addMergedRegion (new CellRangeAddress(1,1,6,11)); //11,200 DWT PRODUCT OIL/CHEMICAL TANKER (SHIP TYPE II
			
			//sheet.addMergedRegion (new Region(( int)0,(short)6,(int)0,(short)7)); //NULL. NO.
			//sheet.addMergedRegion (new Region(( int)0,(short)8,(int)0,(short)11)); //S1514/15/16
			
			for (int i = 0; i < 12; i++) { 
				XSSFCell cell = headRow.createCell((short) i);  
				if (i==0) {
					cell.setCellValue(new XSSFRichTextString("Plan Comment Form")); 
					sheet.setColumnWidth(i, 1000);     //엑셀사이즈 조정함.
				} else if(i==1){
					sheet.setColumnWidth(i, 1000);
				} else if(i==2){
					sheet.setColumnWidth(i, 3000);
				} else if(i==3){
					sheet.setColumnWidth(i, 8000);
				} else if(i==4){
					sheet.setColumnWidth(i, 8000);
				} else if(i==5){
					sheet.setColumnWidth(i, 3000);
				} else if(i==6){
					cell.setCellValue(new XSSFRichTextString("HULL. NO."));
					sheet.setColumnWidth(i, 1000);
				} else if(i==7){
					sheet.setColumnWidth(i, 6000);
				} else if(i==8){
					cell.setCellValue(new XSSFRichTextString( pcfHeader == null ? "" : (String) pcfHeader.get("HULL_NO")  ));
					sheet.setColumnWidth(i, 3500);
				} else if(i==9){
					sheet.setColumnWidth(i, 6000);
				} else if(i==10){
					sheet.setColumnWidth(i, 3000);
				} else if(i==11){
					sheet.setColumnWidth(i, 3500);
				} 
				cell.setCellStyle(headerStyle4);
			} 

			headRow = sheet.createRow((short) 1);
			for (int i = 0; i < 12; i++) { 
				XSSFCell cell = headRow.createCell((short) i);  
				if (i==6) {
					cell.setCellValue(new XSSFRichTextString( pcfHeader == null ? "" : (String) pcfHeader.get("MARKETING_TEXT") ));
				}
				cell.setCellStyle(headerStyle4);
			}
			
			sheet.addMergedRegion (new CellRangeAddress(2,2,0,2)); //Dwg. Title		
			sheet.addMergedRegion (new CellRangeAddress(2,2,3,5)); //ARR'T OF MOORING
			sheet.addMergedRegion (new CellRangeAddress(2,2,6,11)); //PCF History	
			
			headRow = sheet.createRow((short) 2);
			for (int i = 0; i < 12; i++) { 
				XSSFCell cell = headRow.createCell((short) i);  
				if (i==0) {
					cell.setCellValue(new XSSFRichTextString("Dwg. Title"));
					cell.setCellStyle(headerStyle1);
				} else if(i==3){
					cell.setCellValue(new XSSFRichTextString( pcfHeader == null ? "" : (String) pcfHeader.get("DWG_TITLE") )); //도면명
					cell.setCellStyle(headerStyle7);
				} else if(i==6){
					cell.setCellValue(new XSSFRichTextString("PCF History")); 
					cell.setCellStyle(headerStyle1);
				} else if(i >= 7 || i ==1 || i==2){
					cell.setCellStyle(headerStyle1);					
				}
			} 	
			
			sheet.addMergedRegion (new CellRangeAddress(3,3,0,2)); //Dwg. No.	
			sheet.addMergedRegion (new CellRangeAddress(3,3,3,3)); //M9999100	
			sheet.addMergedRegion (new CellRangeAddress(3,3,4,4)); //Revision No.
			sheet.addMergedRegion (new CellRangeAddress(3,3,5,5)); //A	
			sheet.addMergedRegion (new CellRangeAddress(3,3,6,7)); //Buyer’s Ref. No.
			sheet.addMergedRegion (new CellRangeAddress(3,3,8,8)); //Buyer 날짜
			sheet.addMergedRegion (new CellRangeAddress(3,3,9,10)); //Builder's Ref. No.
			sheet.addMergedRegion (new CellRangeAddress(3,3,11,11)); //Builder 날짜
			
			headRow = sheet.createRow((short) 3);
			for (int i = 0; i < 12; i++) { 
				XSSFCell cell = headRow.createCell((short) i);  
				if (i==0) {
					cell.setCellValue(new XSSFRichTextString("Dwg. No."));
					cell.setCellStyle(headerStyle1);
				} else if(i==3){
					cell.setCellValue(new XSSFRichTextString( pcfHeader == null ? "" : (String) pcfHeader.get("DWG_NO") )); //도면명
					cell.setCellStyle(headerStyle2);
				} else if(i==4){
					cell.setCellValue(new XSSFRichTextString("Revision No.")); //도면명
					cell.setCellStyle(headerStyle1);
				} else if(i==5){
					cell.setCellValue(new XSSFRichTextString("")); //도면명
					cell.setCellStyle(headerStyle2);
				} else if(i==6){
					if(commandMap.get("p_issuer").toString().equals("O")) {
						cell.setCellValue(new XSSFRichTextString("Buyer’s Ref. No."));
					} else {
						cell.setCellValue(new XSSFRichTextString("Class’s Ref. No."));
					}
					cell.setCellStyle(headerStyle1);
				} else if(i==8 || i==11){
					cell.setCellValue(new XSSFRichTextString("Date")); 
					cell.setCellStyle(headerStyle1);
				} else if(i==9){
					cell.setCellValue(new XSSFRichTextString("Builder's Ref. No.")); 
					cell.setCellStyle(headerStyle1);
				}  
			}  
			
			//기본사이즈가 8임. PCF HISTORY 전체 건수를 CNT해서 4건 이상인 건수만 최종건수로 추가 시킴.
			int k=8+2;  
			
			for (int j = 4; j < k; j++) { 
				headRow = sheet.createRow((short) j); 
				sheet.addMergedRegion (new CellRangeAddress(j,j,0,2)); //A
				sheet.addMergedRegion (new CellRangeAddress(j,j,3,3)); //Approved.
				sheet.addMergedRegion (new CellRangeAddress(j,j,4,4)); //Number of Open Comments
				sheet.addMergedRegion (new CellRangeAddress(j,j,5,5)); //0	
				sheet.addMergedRegion (new CellRangeAddress(j,j,6,7)); //
				sheet.addMergedRegion (new CellRangeAddress(j,j,8,8)); //
				sheet.addMergedRegion (new CellRangeAddress(j,j,9,10)); //
				sheet.addMergedRegion (new CellRangeAddress(j,j,11,11)); //	
				
				for (int i = 0; i < 12; i++) { 
					XSSFCell cell = headRow.createCell((short) i);  
					if (i==0) {
						if (j==4){
							cell.setCellValue(new XSSFRichTextString("Dwg. Status"));
							cell.setCellStyle(headerStyle1);
						} else if (j==5){
							cell.setCellValue(new XSSFRichTextString("A"));  
							cell.setCellStyle(headerStyle);
						} else if (j==6){
							cell.setCellValue(new XSSFRichTextString("AC"));  
							cell.setCellStyle(headerStyle);
						} else if (j==7){
							cell.setCellValue(new XSSFRichTextString("NA"));   
							cell.setCellStyle(headerStyle);
						} else if (j > 7){
							cell.setCellStyle(headerStyle2);
						} 
					} else if(i==1 || i==2){
						if (j==4){
							cell.setCellStyle(headerStyle2);
						} else if (j==5 || j==6 || j==7){ 
							cell.setCellStyle(headerStyle); 
						} else if (j > 7){
							cell.setCellStyle(headerStyle2);
						} 
					} else if(i==3){
						if (j==4){
							cell.setCellValue(new XSSFRichTextString("   "));  // DB에서 가져와서 넣어야 함. DWG STATUS 정보
							cell.setCellStyle(headerStyle2);
						} else if (j==5){
							cell.setCellValue(new XSSFRichTextString("Approved."));
							cell.setCellStyle(headerStyle6);
						} else if (j==6){
							cell.setCellValue(new XSSFRichTextString("Approved with Comment")); 
							cell.setCellStyle(headerStyle6);
						} else if (j==7){
							cell.setCellValue(new XSSFRichTextString("Not Approval")); 
							cell.setCellStyle(headerStyle6);
						} else if (j > 7){
							cell.setCellStyle(headerStyle2);
						} 
					} else if(i==4){
						if (j==4){
							cell.setCellValue(new XSSFRichTextString("Total Number of Comments")); 
							cell.setCellStyle(headerStyle1);
						} else if (j==5){
							cell.setCellValue(new XSSFRichTextString("Number of Open Comments"));  
							cell.setCellStyle(headerStyle1);
						} else if (j==6){
							cell.setCellValue(new XSSFRichTextString("Revised Plan Required"));  
							cell.setCellStyle(headerStyle1);
						} else if (j==7){
							cell.setCellValue(new XSSFRichTextString("Revised Partial Plan Required"));  
							cell.setCellStyle(headerStyle1);
						} else if (j > 7){
							cell.setCellStyle(headerStyle2);
						}  
					} else if(i==5){
						if (j==4){ 
							cell.setCellValue(new XSSFRichTextString ( pcfHeader == null ? "" : pcfHeader.get("TOTAL_COMMENT").toString() ));  //DB에서 가져와서 넣어야 함.
						} else if (j==5){
							cell.setCellValue(new XSSFRichTextString( pcfHeader == null ? "" : pcfHeader.get("OPEN_CMMENT").toString() ));  // DB에서 가져와서 넣어야 함.
						} else if (j==6){
							cell.setCellValue(new XSSFRichTextString(""));  // DB에서 가져와서 넣어야 함.
						} else if (j==7){
							cell.setCellValue(new XSSFRichTextString(""));  // DB에서 가져와서 넣어야 함.
						}  
						cell.setCellStyle(headerStyle2);
					} else if(i==6){
						
						if(j >= pcfHistoryList.size()) {
							cell.setCellValue(new XSSFRichTextString( "" ));
						} else {
							cell.setCellValue(new XSSFRichTextString( (String) pcfHistoryList.get(j).get("COM_NO") ));  //DB에서 가져와서 넣어야 함.
						}
						cell.setCellStyle(headerStyle2);
						
					} else if(i==8){ 
						
						if(j >= pcfHistoryList.size()) {
							cell.setCellValue(new XSSFRichTextString( "" ));
						} else {
							cell.setCellValue(new XSSFRichTextString( (String) pcfHistoryList.get(j).get("ISSUE_DATE") ));  //DB에서 가져와서 넣어야 함.
						}
						cell.setCellStyle(headerStyle2);
						
					} else if(i==9){ 
						
						if(j >= pcfHistoryList.size()) {
							cell.setCellValue(new XSSFRichTextString( "" ));
						} else {
							cell.setCellValue(new XSSFRichTextString( (String) pcfHistoryList.get(j).get("BUILDER_REF_NO") ));  //DB에서 가져와서 넣어야 함.
						}
						cell.setCellStyle(headerStyle2);
						
					}  else if(i==11){
						
						if(j >= pcfHistoryList.size()) {
							cell.setCellValue(new XSSFRichTextString( "" ));
						} else {
							cell.setCellValue(new XSSFRichTextString( (String) pcfHistoryList.get(j).get("BUILDER_DATE") ));  //DB에서 가져와서 넣어야 함.
						}
						cell.setCellStyle(headerStyle2);
						
					}  else if(i==7 || i==10 ){ 
						cell.setCellStyle(headerStyle2);
					}  
				} 
				
				
			}
			
			headRow = sheet.createRow((short) k); 
			sheet.addMergedRegion (new CellRangeAddress(k,k,0,11)); //A	
			for (int i = 0; i < 12; i++) { 
				XSSFCell cell = headRow.createCell((short) i);  
			    cell.setCellStyle(headerStyle2);
			}
			
			k++; //본문 내용 타이틀 출력을 위해서 1증가시킴.
			headRow = sheet.createRow((short) k);  
			//시작행번호 마지막 행번호 시작열번호 마지막열번호
			sheet.addMergedRegion (new CellRangeAddress(k,k+1,0,0)); //PLAN COMMENT FORM
			sheet.addMergedRegion (new CellRangeAddress(k,k+1,1,4)); //HULL NO
			sheet.addMergedRegion (new CellRangeAddress(k,k+1,5,5)); //S1514/15/16			
			sheet.addMergedRegion (new CellRangeAddress(k,k+1,6,9)); //11,200 DWT PRODUCT OIL/CHEMICAL TANKER (SHIP TYPE II
			sheet.addMergedRegion (new CellRangeAddress(k,k+1,10,10)); //11,200 DWT PRODUCT OIL/CHEMICAL TANKER (SHIP TYPE II
			sheet.addMergedRegion (new CellRangeAddress(k,k+1,11,11)); //11,200 DWT PRODUCT OIL/CHEMICAL TANKER (SHIP TYPE II 
			
			for (int i = 0; i < 17; i++) { 
				XSSFCell cell = headRow.createCell((short) i);  
				if (i==0) {
					cell.setCellValue(new XSSFRichTextString("No"));
				} else if(i==1){
					if(commandMap.get("p_issuer").toString().equals("O")) {
						cell.setCellValue(new XSSFRichTextString("BUYER’S COMMENT"));
					} else {
						cell.setCellValue(new XSSFRichTextString("CLASS’S COMMENT"));
					}
				} else if(i==5){
					if(commandMap.get("p_issuer").toString().equals("O")) {
						cell.setCellValue(new XSSFRichTextString("BUYER\nINITIALS"));
					} else {
						cell.setCellValue(new XSSFRichTextString("CLASS\nINITIALS"));
					}
				} else if(i==6){
					cell.setCellValue(new XSSFRichTextString("BUILDER'S REPLY"));
				} else if(i==10){
					cell.setCellValue(new XSSFRichTextString("BUILDER\nINITIALS"));
				} else if(i==11){
					if(commandMap.get("p_issuer").toString().equals("O")) {
						cell.setCellValue(new XSSFRichTextString("Buyer Status\n(Open,Closed)"));
					} else {
						cell.setCellValue(new XSSFRichTextString("Class Status\n(Open,Closed)"));
					}
				} else if(i==13){
					if(commandMap.get("p_issuer").toString().equals("O")) {
						cell.setCellValue(new XSSFRichTextString("Buyer's Ref No."));
					} else {
						cell.setCellValue(new XSSFRichTextString("Class's Ref No."));
					}
					sheet.setColumnWidth(i, 6000);
				} else if(i==14){
					cell.setCellValue(new XSSFRichTextString("Date"));
					sheet.setColumnWidth(i, 3500);
				} else if(i==15){
					cell.setCellValue(new XSSFRichTextString("Builder's Ref No."));
					sheet.setColumnWidth(i, 6000);
				} else if(i==16){
					cell.setCellValue(new XSSFRichTextString("Date"));
					sheet.setColumnWidth(i, 3500);
				}
				
				if(i==12){
					cell.setCellStyle(headerStyle8);
				} else {
					cell.setCellStyle(headerStyle4);
				}
				
			}
			
			k++; //본문 내용 타이틀이 2칸을 사용했기 때문에 1증가시킴.
			headRow = sheet.createRow((short) k);  
			for (int i = 0; i < 12; i++) { 
				XSSFCell cell = headRow.createCell((short) i);   
				cell.setCellStyle(headerStyle4);
			} 
			
			List<Map<String, Object>> pcfHeaderList = (List<Map<String, Object>>) modelMap.get("pcfHeaderList");
			List<Map<String, Object>> pcfSubList = (List<Map<String, Object>>) modelMap.get("pcfSubList");
			
			for (int j = 0; j < pcfHeaderList.size(); j++) {
                
				k = k + 1;
				headRow = sheet.createRow((short) k); 
			
				//sub sub cnt를 함.
				int idx = 0;
				for(int i=0; i < pcfSubList.size(); i++) {
					
					if(pcfSubList.get(i).get("LIST_NO").equals( pcfHeaderList.get(j).get("LIST_NO") )) {
						
						idx = Integer.parseInt(pcfSubList.get(i).get("SUB_NO").toString());
						
					}
				}
				//시작행번호 마지막 행번호 시작열번호 마지막열번호
				sheet.addMergedRegion (new CellRangeAddress(k,k+idx,0,0)); 			// NO
				sheet.addMergedRegion (new CellRangeAddress(k,k,1,10));            // SUB DESC  
				sheet.addMergedRegion (new CellRangeAddress(k,k,11,11));           // SUB STATUS  
				
				XSSFCell cell = headRow.createCell((short) 0);
				
				cell.setCellValue(new XSSFRichTextString( pcfHeaderList.get(j).get("LIST_NO") + ""));                           // SUB SELECT CNT  DB에서 가져와서 넣어야 함.
				cell.setCellStyle(headerStyle2);
				
				cell = headRow.createCell((short) 1); 
				cell.setCellValue(new XSSFRichTextString((String) pcfHeaderList.get(j).get("SUB_TITLE")));  // SUB title    DB에서 가져와서 넣어야 함.
				cell.setCellStyle(headerStyle3);  

				cell = headRow.createCell((short) 11); 
				cell.setCellValue(new XSSFRichTextString( (String) pcfHeaderList.get(j).get("STATUS") ));  // SUB title DB에서 가져와서 넣어야 함.
				cell.setCellStyle(headerStyle2);
				
				for(int i=0; i < pcfSubList.size(); i++) {
					
					if(pcfSubList.get(i).get("LIST_NO").equals( pcfHeaderList.get(j).get("LIST_NO") )) {
					
						k = k + 1;                                                 //전체 row cnt 증가시킴
						headRow = sheet.createRow((short) k); 
						headRow.setHeight((short) 700);
						
						sheet.addMergedRegion (new CellRangeAddress(k,k,1,1));      // NO
						sheet.addMergedRegion (new CellRangeAddress(k,k,2,4));      // BUYER’S COMMENT
						sheet.addMergedRegion (new CellRangeAddress(k,k,5,5));      // BUYER　INITIALS
						sheet.addMergedRegion (new CellRangeAddress(k,k,6,6));      // NO			
						sheet.addMergedRegion (new CellRangeAddress(k,k,7,9));      // BUILDER'S REPLY
						sheet.addMergedRegion (new CellRangeAddress(k,k,10,10));    // BUILDER INITIALS
						sheet.addMergedRegion (new CellRangeAddress(k,k,11,11));    //  
						
						XSSFCell cell1 = headRow.createCell((short) 1);
						
						if (pcfSubList.get(i).get("SUB_NO").toString().equals("1") ) {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "st"));    //1st  DB에서 가져와서 넣어야 함.
						} else if(pcfSubList.get(i).get("SUB_NO").toString().equals("2") ) {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "nd"));    //1st  DB에서 가져와서 넣어야 함.
						} else if(pcfSubList.get(i).get("SUB_NO").toString().equals("3") ) {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "rd"));    //1st  DB에서 가져와서 넣어야 함.
						} else {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "th"));    //1st  DB에서 가져와서 넣어야 함.
						}
						cell1.setCellStyle(headerStyle2);
						
						cell1 = headRow.createCell((short) 2);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("SUB_TITLE") ));  //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle5);
						cell1 = headRow.createCell((short) 3);  
						cell1.setCellStyle(headerStyle5);
						cell1 = headRow.createCell((short) 4);  
						cell1.setCellStyle(headerStyle5);
					    
						cell1 = headRow.createCell((short) 5);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("INITIALS") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle2);
					    
						cell1 = headRow.createCell((short) 6);  
						if (pcfSubList.get(i).get("SUB_NO").toString().equals("1")) {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "st"));    //1st  DB에서 가져와서 넣어야 함.
						} else if(pcfSubList.get(i).get("SUB_NO").toString().equals("2")) {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "nd"));    //1st  DB에서 가져와서 넣어야 함.
						} else if(pcfSubList.get(i).get("SUB_NO").toString().equals("3")) {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "rd"));    //1st  DB에서 가져와서 넣어야 함.
						} else {
							cell1.setCellValue(new XSSFRichTextString(pcfSubList.get(i).get("SUB_NO") + "th"));    //1st  DB에서 가져와서 넣어야 함.
						}
						cell1.setCellStyle(headerStyle2); 
					    
						cell1 = headRow.createCell((short) 7);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("BUILDERS_REPLY") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle5);
						cell1 = headRow.createCell((short) 8);  
						cell1.setCellStyle(headerStyle5);
						cell1 = headRow.createCell((short) 9);  
						cell1.setCellStyle(headerStyle5);
					    
						cell1 = headRow.createCell((short) 10);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("BUILDER_USER_NAME") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle2); 
	
						cell1 = headRow.createCell((short) 11);  	
						cell1.setCellStyle(headerStyle2);
						
						cell1 = headRow.createCell((short) 13);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("COM_NO") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle2);
						
						cell1 = headRow.createCell((short) 14);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("ISSUE_DATE") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle2);
						
						cell1 = headRow.createCell((short) 15);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("REF_NO") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle2);
						
						cell1 = headRow.createCell((short) 16);  	
						cell1.setCellValue(new XSSFRichTextString( (String) pcfSubList.get(i).get("BUILDER_DATE") )); //DB에서 가져와서 넣어야 함.
						cell1.setCellStyle(headerStyle2);
						
						
					} //if() end
					
				} 
			} 
			
			k = k + 1;
			headRow = sheet.createRow((short) k); 
			
			//시작행번호 마지막 행번호 시작열번호 마지막열번호
			sheet.addMergedRegion (new CellRangeAddress(k,(short)k+1,0,0)); 			// NO
			sheet.addMergedRegion (new CellRangeAddress(k,k,1,10));            // SUB DESC  
			sheet.addMergedRegion (new CellRangeAddress(k,k,11,11));           // SUB STATUS  
			
			XSSFCell cell = headRow.createCell((short) 0);
			
			cell.setCellValue( pcfHeaderList.size() + 1);                           // SUB SELECT CNT  DB에서 가져와서 넣어야 함.
			cell.setCellStyle(headerStyle2);
			
			cell = headRow.createCell((short) 1); 
			cell.setCellValue(new XSSFRichTextString( "Subtitle : " ));  // SUB title    DB에서 가져와서 넣어야 함.
			cell.setCellStyle(headerStyle3);  

			cell = headRow.createCell((short) 11); 
			cell.setCellValue(new XSSFRichTextString( "" ));  // SUB title DB에서 가져와서 넣어야 함.
			cell.setCellStyle(headerStyle2);
			
			k = k + 1;                                                 //전체 row cnt 증가시킴
			headRow = sheet.createRow((short) k); 
			headRow.setHeight((short) 700);
			
			sheet.addMergedRegion (new CellRangeAddress(k,k,1,1));      // NO
			sheet.addMergedRegion (new CellRangeAddress(k,k,2,4));      // BUYER’S COMMENT
			sheet.addMergedRegion (new CellRangeAddress(k,k,5,5));      // BUYER　INITIALS
			sheet.addMergedRegion (new CellRangeAddress(k,k,6,6));      // NO			
			sheet.addMergedRegion (new CellRangeAddress(k,k,7,9));      // BUILDER'S REPLY
			sheet.addMergedRegion (new CellRangeAddress(k,k,10,10));    // BUILDER INITIALS
			sheet.addMergedRegion (new CellRangeAddress(k,k,11,11));    //  
			
			XSSFCell cell1 = headRow.createCell((short) 1);
			
			cell1.setCellValue(new XSSFRichTextString("1st"));    //1st  DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2);
			
			cell1 = headRow.createCell((short) 2);  	
			cell1.setCellValue(new XSSFRichTextString( "" ));  //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle5);
			cell1 = headRow.createCell((short) 3);  
			cell1.setCellStyle(headerStyle5);
			cell1 = headRow.createCell((short) 4);  
			cell1.setCellStyle(headerStyle5);
		    
			cell1 = headRow.createCell((short) 5);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2);
		    
			cell1 = headRow.createCell((short) 6);  
			cell1.setCellValue(new XSSFRichTextString("1st"));    //1st  DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2); 
		    
			cell1 = headRow.createCell((short) 7);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle5);
			cell1 = headRow.createCell((short) 8);  
			cell1.setCellStyle(headerStyle5);
			cell1 = headRow.createCell((short) 9);  
			cell1.setCellStyle(headerStyle5);
		    
			cell1 = headRow.createCell((short) 10);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2); 

			cell1 = headRow.createCell((short) 11);  	
			cell1.setCellStyle(headerStyle2);
			
			cell1 = headRow.createCell((short) 13);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2);
			
			cell1 = headRow.createCell((short) 14);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2);
			
			cell1 = headRow.createCell((short) 15);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2);
			
			cell1 = headRow.createCell((short) 16);  	
			cell1.setCellValue(new XSSFRichTextString( "" )); //DB에서 가져와서 넣어야 함.
			cell1.setCellStyle(headerStyle2);
			
			
		} 

	}

}

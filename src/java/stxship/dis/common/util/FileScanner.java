package stxship.dis.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

public class FileScanner {

	/**
	 * @메소드명 : excelToDataObj_poi
	 * @날짜 : 2016. 1. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		파일 스캔하여 리스트로 변환
	 *     </pre>
	 * 
	 * @param file
	 *            MultipartFile
	 * @param request
	 *            HttpServletRequest
	 * @param startIndex
	 *            읽을 엑셀의 start row 행
	 * @param isDelete
	 *            파일 삭제 유무
	 * @param limitCnt
	 *            파일 제한 크기
	 * @return
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	public static List<Map<String, Object>> excelToList(MultipartFile multipartFile, int startIndex, boolean isDelete, int limitCnt)
					throws IOException, InvalidFormatException {

		// 업로드 파일 명
//		String fileName = multipartFile.getOriginalFilename();
//
//		// 파일명이 중복되지 않게 파일명에 시간 추가
//		String newFileName = fileName + "_" + System.currentTimeMillis();
//
//		// 파일 업로드 경로
//		String path = (request.getSession().getServletContext().getRealPath("/")).replace("\\", "/") + DisConstants.EXCEL + "\\" + newFileName;
//		
//		File f = new File(path);
//		// 파일을 업로드 경로에 넣음
//		multipartFile.transferTo(f);

		// String path = multipartFile.getName();

		//FileInputStream tempFile = new FileInputStream(new File(path));

		//File xlsFile = new File(path);
		
		List<Map<String, Object>> resultArray = new ArrayList<Map<String, Object>>();

//		Workbook workBook = WorkbookFactory.create(multipartFile.getInputStream());
		
		String fileName = multipartFile.getOriginalFilename();
		
		String FileExt = fileName.substring(fileName.lastIndexOf('.')+1);
		if(FileExt.toUpperCase().equals("XLSX")) {
			XSSFWorkbook workBook = new XSSFWorkbook(multipartFile.getInputStream());
			
			Sheet sheet = null;
			
			for(int i = 0; i < workBook.getNumberOfSheets(); i++) {
				if(workBook.getSheetAt(i).getRow(0) != null) {
					sheet = workBook.getSheetAt(i);
					break;
				}
			}
			
			int columnCnt = sheet.getRow(0).getLastCellNum(); // .getColumns();
			int rowCnt = sheet.getLastRowNum(); // getRows();
			
			System.out.println("rowCnt" + rowCnt);

			for (int i = startIndex; i <= rowCnt; i++) {
				Map<String, Object> hm = new HashMap<String, Object>();

				for (int j = 0; j < columnCnt; j++) {
					
					Cell cell = sheet.getRow(i).getCell(j);

					String key = "column" + j;
					String value = "";
					if (cell != null) {
						
						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:
							value = cell.getRichStringCellValue().getString();
							break;
						case Cell.CELL_TYPE_NUMERIC:
							value = Double.toString(cell.getNumericCellValue());
							if (value.indexOf(".0") > 0) {
								value = value.replace(".0", "");
							}
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							value = Boolean.toString(cell.getBooleanCellValue());
							break;
						case Cell.CELL_TYPE_FORMULA:
							value = cell.getCellFormula();
							break;
						}
					}
					hm.put(key, value.trim());
				}
				resultArray.add(hm);
			}
			
		} else {
			HSSFWorkbook workBook1 = new HSSFWorkbook(multipartFile.getInputStream());
			
			Sheet sheet = null;
			for(int i = 0; i < workBook1.getNumberOfSheets(); i++) {
				if(workBook1.getSheetAt(i).getRow(0) != null) {
					sheet = workBook1.getSheetAt(i);
					break;
				}
			}
			
			int columnCnt = sheet.getRow(0).getLastCellNum(); // .getColumns();
			int rowCnt = sheet.getLastRowNum(); // getRows();
			
			System.out.println("rowCnt" + rowCnt);

			for (int i = startIndex; i <= rowCnt; i++) {
				Map<String, Object> hm = new HashMap<String, Object>();

				for (int j = 0; j < columnCnt; j++) {
					
					Cell cell = sheet.getRow(i).getCell(j);

					String key = "column" + j;
					String value = "";
					if (cell != null) {
						
						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:
							value = cell.getRichStringCellValue().getString();
							break;
						case Cell.CELL_TYPE_NUMERIC:
							value = Double.toString(cell.getNumericCellValue());
							if (value.indexOf(".0") > 0) {
								value = value.replace(".0", "");
							}
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							value = Boolean.toString(cell.getBooleanCellValue());
							break;
						case Cell.CELL_TYPE_FORMULA:
							value = cell.getCellFormula();
							break;
						}
					}
					hm.put(key, value.trim());
				}
				resultArray.add(hm);
			}
			
		}

		return resultArray;
	}
	
	/**
	 * @메소드명 : excelToDataObj_poi
	 * @날짜 : 2016. 1. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		파일 스캔하여 리스트로 변환
	 *     </pre>
	 * 
	 * @param file
	 *            MultipartFile
	 * @param request
	 *            HttpServletRequest
	 * @param startIndex
	 *            읽을 엑셀의 start row 행
	 * @param isDelete
	 *            파일 삭제 유무
	 * @param limitCnt
	 *            파일 제한 크기
	 * @return
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	public static List<Map<String, Object>> excelToList1(MultipartFile multipartFile, int startIndex, boolean isDelete, int limitCnt)
					throws IOException, InvalidFormatException {
		
		List<Map<String, Object>> resultArray = new ArrayList<Map<String, Object>>();

//		Workbook workBook = WorkbookFactory.create(multipartFile.getInputStream());
		
		XSSFWorkbook workBook = new XSSFWorkbook(multipartFile.getInputStream()); 
		Sheet sheet = null;
		
		for(int i = 0; i < workBook.getNumberOfSheets(); i++) {
			if(workBook.getSheetAt(i).getRow(0) != null) {
				sheet = workBook.getSheetAt(i);
				break;
			}
		}
		
		int columnCnt = sheet.getRow(0).getLastCellNum(); // .getColumns();
		int rowCnt = sheet.getLastRowNum(); // getRows();
		
		System.out.println("rowCnt" + rowCnt);

		for (int i = startIndex; i <= rowCnt; i++) {
			Map<String, Object> hm = new HashMap<String, Object>();

			for (int j = 0; j < columnCnt; j++) {
				Cell cell = sheet.getRow(i).getCell(j);

				String key = "column" + j;
				String value = "";
				if (cell != null) {
					switch (cell.getCellType()) {
					case Cell.CELL_TYPE_STRING:
						value = cell.getRichStringCellValue().getString();
						break;
					case Cell.CELL_TYPE_NUMERIC:
						value = Double.toString(cell.getNumericCellValue());
						if (value.indexOf(".0") > 0) {
							value = value.replace(".0", "");
						}
						break;
					case Cell.CELL_TYPE_BOOLEAN:
						value = Boolean.toString(cell.getBooleanCellValue());
						break;
					case Cell.CELL_TYPE_FORMULA:
						value = cell.getCellFormula();
						break;
					}
				}
				hm.put(key, value.trim());
			}
			resultArray.add(hm);
		}

		return resultArray;
	}
	
	
	/**
	 * @메소드명 : excelToDataObj_poi
	 * @날짜 : 2016. 1. 14.
	 * @작성자 : BaekJaeHo
	 * @설명 :
	 * 
	 *     <pre>
	 *		파일 스캔하여 리스트로 변환
	 *     </pre>
	 * 
	 * @param file
	 *            MultipartFile
	 * @param request
	 *            HttpServletRequest
	 * @param startIndex
	 *            읽을 엑셀의 start row 행
	 * @param isDelete
	 *            파일 삭제 유무
	 * @param limitCnt
	 *            파일 제한 크기
	 * @return
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	public static List<Map<String, Object>> DecryptExcelToList(File file, int startIndex, boolean isDelete, int limitCnt)
					throws IOException, InvalidFormatException {

		// 업로드 파일 명
//		String fileName = multipartFile.getOriginalFilename();
//
//		// 파일명이 중복되지 않게 파일명에 시간 추가
//		String newFileName = fileName + "_" + System.currentTimeMillis();
//
//		// 파일 업로드 경로
//		String path = (request.getSession().getServletContext().getRealPath("/")).replace("\\", "/") + DisConstants.EXCEL + "\\" + newFileName;
//		
//		File f = new File(path);
//		// 파일을 업로드 경로에 넣음
//		multipartFile.transferTo(f);

		// String path = multipartFile.getName();

		//FileInputStream tempFile = new FileInputStream(new File(path));

		//File xlsFile = new File(path);
		
		List<Map<String, Object>> resultArray = new ArrayList<Map<String, Object>>();

//		Workbook workBook = WorkbookFactory.create(multipartFile.getInputStream());
		
		String fileName = file.getName();
		String FileExt = fileName.substring(fileName.lastIndexOf('.')+1);
		if(FileExt.toUpperCase().equals("XLSX")) {
			XSSFWorkbook workBook = new XSSFWorkbook(new FileInputStream(file));
			
			Sheet sheet = null;
			
			for(int i = 0; i < workBook.getNumberOfSheets(); i++) {
				if(workBook.getSheetAt(i).getRow(0) != null) {
					sheet = workBook.getSheetAt(i);
					break;
				}
			}
			
			int columnCnt = sheet.getRow(0).getLastCellNum(); // .getColumns();
			int rowCnt = sheet.getLastRowNum(); // getRows();
			
			System.out.println("rowCnt" + rowCnt);

			for (int i = startIndex; i <= rowCnt; i++) {
				Map<String, Object> hm = new HashMap<String, Object>();

				for (int j = 0; j < columnCnt; j++) {
					
					Cell cell = sheet.getRow(i).getCell(j);

					String key = "column" + j;
					String value = "";
					if (cell != null) {
						
						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:
							value = cell.getRichStringCellValue().getString();
							break;
						case Cell.CELL_TYPE_NUMERIC:
							value = Double.toString(cell.getNumericCellValue());
							if (value.indexOf(".0") > 0) {
								value = value.replace(".0", "");
							}
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							value = Boolean.toString(cell.getBooleanCellValue());
							break;
						case Cell.CELL_TYPE_FORMULA:
							value = cell.getCellFormula();
							break;
						}
					}
					hm.put(key, value.trim());
				}
				resultArray.add(hm);
			}
			
		} else {
			HSSFWorkbook workBook1 = new HSSFWorkbook(new FileInputStream(file));
			
			Sheet sheet = null;
			for(int i = 0; i < workBook1.getNumberOfSheets(); i++) {
				if(workBook1.getSheetAt(i).getRow(0) != null) {
					sheet = workBook1.getSheetAt(i);
					break;
				}
			}
			
			int columnCnt = sheet.getRow(0).getLastCellNum(); // .getColumns();
			int rowCnt = sheet.getLastRowNum(); // getRows();
			
			System.out.println("rowCnt" + rowCnt);

			for (int i = startIndex; i <= rowCnt; i++) {
				Map<String, Object> hm = new HashMap<String, Object>();

				for (int j = 0; j < columnCnt; j++) {
					
					Cell cell = sheet.getRow(i).getCell(j);

					String key = "column" + j;
					String value = "";
					if (cell != null) {
						
						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:
							value = cell.getRichStringCellValue().getString();
							break;
						case Cell.CELL_TYPE_NUMERIC:
							value = Double.toString(cell.getNumericCellValue());
							if (value.indexOf(".0") > 0) {
								value = value.replace(".0", "");
							}
							break;
						case Cell.CELL_TYPE_BOOLEAN:
							value = Boolean.toString(cell.getBooleanCellValue());
							break;
						case Cell.CELL_TYPE_FORMULA:
							value = cell.getCellFormula();
							break;
						}
					}
					hm.put(key, value.trim());
				}
				resultArray.add(hm);
			}
			
		}

		return resultArray;
	}
	
}

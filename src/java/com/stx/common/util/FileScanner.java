package com.stx.common.util;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class FileScanner {
	public static ArrayList excelToDataObj(String path, boolean isDelete) throws BiffException, IOException {
		File xlsFile = new File(path);
		int startIndex = 0;
		ArrayList resultArray = new ArrayList();

		Workbook workBook = Workbook.getWorkbook(xlsFile);
		Sheet sheet = workBook.getSheet(0);

		int columnCnt = sheet.getColumns();
		int rowCnt = sheet.getRows();

		for (int i = startIndex; i < rowCnt; i++) {
			HashMap hm = new HashMap();

			for (int j = 0; j < columnCnt; j++) {
				String key = Integer.toString(j);
				String value = sheet.getCell(j, i).getContents();
				hm.put(key, value);
			}
			resultArray.add(hm);

		}
		if (isDelete)
			xlsFile.delete();
		return resultArray;
	}

	public static ArrayList excelToDataObj(String path, int startIndex, boolean isDelete)
			throws BiffException, IOException {
		File xlsFile = new File(path);
		ArrayList resultArray = new ArrayList();

		Workbook workBook = Workbook.getWorkbook(xlsFile);
		Sheet sheet = workBook.getSheet(0);

		int columnCnt = sheet.getColumns();
		int rowCnt = sheet.getRows();
		System.out.println("rowCnt : " + rowCnt);

		for (int i = startIndex; i < rowCnt; i++) {
			HashMap hm = new HashMap();
			for (int j = 0; j < columnCnt; j++) {
				// String key = sheet.getCell(j,0).getContents();
				String key = "column" + j;
				String value = sheet.getCell(j, i).getContents();
				hm.put(key, value);
			}
			resultArray.add(hm);
		}
		if (isDelete)
			xlsFile.delete();

		return resultArray;
	}

	public static ArrayList excelToDataObj(String path, int startIndex, String columnSheet, boolean isDelete)
			throws BiffException, IOException {
		File xlsFile = new File(path);

		ArrayList resultArray = new ArrayList();

		Workbook workBook = Workbook.getWorkbook(xlsFile);
		Sheet sheet = workBook.getSheet(0);
		Sheet colSheet = workBook.getSheet(columnSheet);

		int columnCnt = colSheet.getColumns();
		int rowCnt = sheet.getRows();

		for (int i = startIndex; i < rowCnt; i++) {
			HashMap hm = new HashMap();
			for (int j = 0; j < columnCnt; j++) {
				String key = colSheet.getCell(j, 0).getContents();
				String value = sheet.getCell(j, i).getContents();
				// System.out.print(value+" | ");
				hm.put(key, value);
			}
			// System.out.println("");
			resultArray.add(hm);
		}
		if (isDelete)
			xlsFile.delete();
		return resultArray;
	}

	public static ArrayList excelToDataObj(String path, int startIndex, HashMap schema, boolean isDelete)
			throws BiffException, IOException {
		File xlsFile = new File(path);

		ArrayList resultArray = new ArrayList();

		Workbook workBook = Workbook.getWorkbook(xlsFile);
		Sheet sheet = workBook.getSheet(0);

		int columnCnt = sheet.getColumns();
		int rowCnt = sheet.getRows();

		for (int i = startIndex; i < rowCnt; i++) {
			HashMap hm = new HashMap();
			for (int j = 0; j < columnCnt; j++) {
				String alias = sheet.getCell(j, 0).getContents();
				String key = (String) schema.get(alias);
				String value = sheet.getCell(j, i).getContents();
				if (key != null)
					hm.put(key, value);
			}
			// System.out.println("");
			resultArray.add(hm);

		}
		if (isDelete)
			xlsFile.delete();
		return resultArray;
	}

	public static ArrayList excelToDataObj(String path, int startIndex, boolean isDelete, int limitCnt, int tmpParam)
			throws BiffException, IOException {
		File xlsFile = new File(path);
		ArrayList resultArray = new ArrayList();

		Workbook workBook = Workbook.getWorkbook(xlsFile);
		Sheet sheet = workBook.getSheet(0);

		int columnCnt = sheet.getColumns();
		int rowCnt = sheet.getRows();

		System.out.println("rowCnt : " + rowCnt);
		if (limitCnt > tmpParam * rowCnt) {

			for (int i = startIndex; i < rowCnt; i++) {
				HashMap hm = new HashMap();
				for (int j = 0; j < columnCnt; j++) {
					// String key = sheet.getCell(j,0).getContents();
					String key = "column" + j;
					String value = sheet.getCell(j, i).getContents();
					hm.put(key, value);
				}
				resultArray.add(hm);
			}
			if (isDelete)
				xlsFile.delete();
		}
		return resultArray;
	}

	public static ArrayList<HashMap<Object, String>> excelToDataObj_poi(String path, int startIndex, boolean isDelete,
			int limitCnt, int tmpParam) throws BiffException, IOException, InvalidFormatException {
		FileInputStream tempFile = new FileInputStream(new File(path));

		File xlsFile = new File(path);
		ArrayList<HashMap<Object, String>> resultArray = new ArrayList<HashMap<Object, String>>();

		org.apache.poi.ss.usermodel.Workbook workBook = WorkbookFactory.create(tempFile);
		org.apache.poi.ss.usermodel.Sheet sheet = workBook.getSheetAt(0);

		int columnCnt = sheet.getColumnWidth(0); // .getColumns();
		int rowCnt = sheet.getLastRowNum(); // getRows();

		System.out.println("rowCnt" + rowCnt);

		for (int i = startIndex; i <= rowCnt; i++) {
			HashMap<Object, String> hm = new HashMap<Object, String>();

			for (int j = 0; j < columnCnt; j++) { // ������
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
				hm.put(key, value);
			}
			resultArray.add(hm);
		}

		if (isDelete)
			xlsFile.delete();

		tempFile.close();

		return resultArray;
	}

	public static HashMap XMLToDataObj(String xmlFilePath) throws Exception, IOException {
		HashMap serializeDataBox = new HashMap();
		File xmlFile = new File(xmlFilePath);
		SAXBuilder builder = new SAXBuilder();
		Document doc = (Document) builder.build(xmlFile);
		Element rootNode = doc.getRootElement();
		// System.out.println(rootNode.);
		serializeDataBox = XMLToSerializeDataObj(rootNode);
		// printSerializeData((HashMap)serializeDataBox.get("table-schema"));

		return serializeDataBox;
	}

	private static HashMap XMLToSerializeDataObj(Element element) throws Exception, IOException {
		HashMap hm = new HashMap();
		List childElements = element.getChildren();
		for (int i = 0; i < childElements.size(); i++) {
			Element childElement = (Element) childElements.get(i);
			if (childElement.getChildren() == null || childElement.getChildren().size() == 0)
				hm.put(childElement.getName(), XMLToSerializeDataObj(childElement));
			else {
				// System.out.println(childElement.getName());

				hm.put(childElement.getName(), childElement.getTextTrim());

			}
		}
		return hm;
	}

	private void printSerializeData(HashMap hm) {
		// HashMap hm =(HashMap)serializeDataBox.get(pKey);
		Iterator iter = hm.keySet().iterator();
		while (iter.hasNext()) {
			String key = (String) iter.next();
			System.out.print(key + "|" + hm.get(key) + "\n");
		}

	}
}

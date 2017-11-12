/**
 * <pre>
 * ������Ʈ�� : FKL-PLM-MIGRATION
 * �ý��۸�   : MIGRATION (COMMON MODULE)
 * ����       : 1.0
 * �ۼ���     : ������
 * �ۼ�����   : 2005/06/29
 * V 1.0      : ������, 2005/06/29
 * </pre>
 * ���       : Excel ���Ͽ��� Data�� �д� Ŭ����
 * ���ó     : Migration PGM
 */
package com.stx.migration;
import java.util.*;
import java.io.*;
import jxl.*;

public class FKLDataMigrationExcelLoader implements FKLDataMigrationDataLoader
{
    protected FKLDataMigrationCommonFileManager fileManager;
    protected int titleRowNum;
    protected int dataRowStartNum;
    protected Workbook currentWorkbook;
    protected Sheet[] currentSheets;
    protected Range[] mergedCellsRanges;
    
    ////////////////////////////////////////////////////////////////////////////
    // PUBLIC METHOD (EXTERNAL INTERFACE)

    /**
     * <pre>
     * ��� : constructor
     * ���� : Excel ���Ͽ��� data�� �д� Excel Loader ��ü�� �����Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param FKLDataMigrationCommonFileManager : Excel ���ϵ鿡 ���� ������ �����ϴ� 
     *                                            File-Manager ��ü�� �Է¹޴´�.
     */
    public FKLDataMigrationExcelLoader(FKLDataMigrationCommonFileManager aFileManager) {

        fileManager = aFileManager;
    }
    
    /**
     * <pre>
     * ��� : Title Row�� �Է¹޴´�.
     * ���� : Title Row �� column ���� �ش��ϴ� excel row�� ��ġ�� �Է¹޴´�.
     *        Excel Loader�� �⺻������ �� Row�� data�� �о� Title-Data�� �� ���·�
     *        �����Ͽ� �����Ѵ�. �̸� ���� Title Row ��ġ�� �Է� ����.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Title Row�� ��ġ
     */
    public void setTitleRowNum(int rowNum) {
        
        titleRowNum = rowNum;
    }
    
    /**
     * <pre>
     * ��� : Data Row�� ���� ��ġ�� �Է¹޴´�.
     * ���� : Data Row�� ���� ��ġ�� �Է¹޴´�. 
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Data Row�� ���� ��ġ
     */
    public void setDataRowStartNum(int rowNum) {
        
        dataRowStartNum = rowNum;
    }
    
    /**
     * <pre>
     * ��� : Data Row�� ���� ��ġ�� �����Ѵ�.
     * ���� : Data Row�� ���� ��ġ�� �����Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Data Row�� ���� ��ġ
     */
    public int getDataRowStartNum() {
        
        return dataRowStartNum;
    }
    
    /**
     * <pre>
     * ��� : Excel ���� ������ ����
     * ���� : ������ ��� ���ϵ��� ������ ����
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Migration ��� Excel ���ϵ��� ����
     */
    public int getFilesCount() {

        return fileManager.getFilesCount();
    }
    
    /**
     * <pre>
     * ��� : Index �� °�� Excel ���� ��ü�� ����
     * ���� : �Ķ���ͷ� �Ѿ�� Index�� �ش��ϴ� ������ ���� ��ü�� ����
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Index�� �ش��ϴ� Excel ���� ��ü
     */
    public File getFileAt(int idx) throws ArrayIndexOutOfBoundsException {
        
        return fileManager.getFileAt(idx);
    }
    
    /**
     * <pre>
     * ��� : nextFile()�� �����ϴ� ��� ���� ����(��)�� �����ϴ��� ���θ� ����
     * ���� : nextFile()�� �����ϴ� ��� ���� ����(��)�� �����ϴ��� ���θ� ����
     * V1.0 : 2005/06/29
     * </pre>
     * @return : ���� ������ �����ϸ� true, ������ false
     */
    public boolean hasMoreFiles() {

        return fileManager.hasMoreFiles();
    }
    
    /**
     * <pre>
     * ��� : nextFile()�� �����ϴ� ��� ���������� ������ ������ ���� ���� ������ ����
     * ���� : nextFile()�� �����ϴ� ��� ���������� ������ ������ ���� ���� ������ ����
     * V1.0 : 2005/06/29
     * </pre>
     * @return : ���������� ������ ������ ���� ���� ���� ��ü
     */
    public File nextFile() {

        return fileManager.nextFile();
    }
    
    /**
     * <pre>
     * ��� : Excel ������ �Է¹޾� (Excel Workbook��) ������ open
     * ���� : Excel ������ �Է¹޾� ������ open�Ѵ�. open�� Excel ������
     *        Excel Workbook ���·� ������ �����ϴ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : void
     */
    public void openWorkbook(File file) throws Exception {

        closeWorkbook();
        
        currentWorkbook = Workbook.getWorkbook(file);
        currentSheets = currentWorkbook.getSheets();
    }
    
    /**
     * <pre>
     * ��� : open�� Excel Workbook�� close
     * ���� : open�� Excel Workbook�� close ��Ų��.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : void
     */
    public void closeWorkbook() {

        if (currentWorkbook != null) currentWorkbook.close();
    }
    
    /**
     * <pre>
     * ��� : Excel Sheet�� ������ ����
     * ���� : Open�� Excel Workbook�� Sheet ������ �����Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Sheet ����
     */
    public int getSheetCount() {

        return currentSheets.length;
    }
    
    /**
     * <pre>
     * ��� : Excel Sheet�� Row ������ ����
     * ���� : Open�� Excel Workbook�� ������ Sheet�� Row ������ �����Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Excel Sheet�� Index
     * @return : Row ����
     */
    public int getRowCount(int sheetIdx) {

        return currentSheets[sheetIdx].getRows();
    }
    
    /**
     * <pre>
     * ��� : Excel Sheet�� Row�� �߿��� Data Row�� �ش��ϴ� Row ������ ����
     * ���� : getRowCount() �޼ҵ�� ���������� Data Row�� �ش��ϴ� Row ��������
     *        ����Ͽ� �����Ѵ�. setDataRowStartNum() �޼ҵ�� ������ Data Row
     *        ���� ��ġ ���� ����Ͽ� Data Row�� �Ǵ��Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Excel Sheet�� Index
     * @return : Data Row ����
     */
    public int getDataRowCount(int sheetIdx) {

        return currentSheets[sheetIdx].getRows() - dataRowStartNum;
    }
    
    /**
     * <pre>
     * ��� : ���յ� ���鿡 ���� ���� ������ ����
     * ���� : ������ Sheet���� ���յ� ���鿡 ���� ���� ������ �����Ѵ�.
     *        ���� ���� �����ϰ� ���� ������ ���� ��Ȯ�ϰ� �б� ���ؼ� �ʿ��ϴ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Excel Sheet�� Index
     */
    public void gatterMergedCellsRanges(int sheetIdx) {
    
        currentSheets[sheetIdx].getRows(); // �� �ڵ�� �ǹ� ����, �׷��� �� �ڵ� �����ϸ� �Ʒ� �ڵ尡
                                           // ����� ������� ���� - jxl ������ ��
        mergedCellsRanges = currentSheets[sheetIdx].getMergedCells();
    }
    
    /**
     * <pre>
     * ��� : Excel ������ row data�� �д´�.
     * ���� : ������ Excel Sheet�� Row�� ���� Data�� �о HashMap ���·� �����Ѵ�.
     *        setTitleRowNum() �޼ҵ�� ������ Title Row�� �̿��ؼ� ������ Excel Row��
     *        �� Cell ���� data ���� Title-Value ������ Map���� �����Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int sheetIdx : Excel Sheet�� Index
     * @param int rowIdx : Excel Row�� Index
     */
    public HashMap getData(int sheetIdx, int rowIdx) {

        if (sheetIdx >= getSheetCount()) return null;
        
        Sheet sheet = currentSheets[sheetIdx];
        if (rowIdx >= getDataRowCount(sheetIdx) + dataRowStartNum) return null;
        Cell[] cells = sheet.getRow(rowIdx);
        if (cells == null || cells.length <= 0) return null;
        
        String[] columnTitles = getArrayFromCells(sheet.getRow(titleRowNum));

        HashMap rowDataMap = new HashMap();
        for (int i = 0; i < columnTitles.length; i++) {
            String columnTitle = columnTitles[i].trim();
            columnTitle = columnTitle.replace('\n', ' ');
            rowDataMap.put(columnTitle, getCommonCellData(cells, i));
        }
        rowDataMap.put(STXDataMigrationConstants.STR_EXCEL_SHEET_IDX, Integer.toString(sheetIdx));
        rowDataMap.put(STXDataMigrationConstants.STR_EXCEL_SHEET_NAME, sheet.getName());
        rowDataMap.put(STXDataMigrationConstants.STR_EXCEL_ROW_IDX, Integer.toString(rowIdx + 1));
        
        return rowDataMap;
    }
    
    /**
     * <pre>
     * ��� : Excel ������ row data�� �д´�.
     * ���� : getData() �޼ҵ�� �����ѵ�, ���յ� Cell�鿡 ���� ó���� �߰������� �����Ѵ�.
     *        jxl ���̺귯���� ���յ� cell���� ���� ����� ���� ���ϱ� ������,
     *        ���յ� cell�� ��� ���� cell�� ������ �ľ��Ͽ� �ش� ���� ������ ���� �е��� ��������.
     *        �� �޼ҵ带 ����ϱ� ���ؼ��� ���� gatterMergedCellsRanges() �޼ҵ尡 ȣ��Ǿ���� �Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int sheetIdx : Excel Sheet�� Index
     * @param int rowIdx : Excel Row�� Index
     * @return : ���� row data�� String �� �迭 ���·� �����Ѵ�. - Title ���� ������� ����.
     */
    public String[] getDataExt(int sheetIdx, int rowIdx) {

        if (sheetIdx >= getSheetCount()) return null;
        
        Sheet sheet = currentSheets[sheetIdx];
        if (rowIdx >= getDataRowCount(sheetIdx) + dataRowStartNum) return null;
        
        Cell[] cells = sheet.getRow(rowIdx);
        if (cells == null || cells.length <= 0) return null;
        
        int columnCount = (getArrayFromCells(sheet.getRow(titleRowNum))).length;

        String[] rowDataArray = new String[columnCount + 3];
        for (int i = 0; i < columnCount; i++) {
            rowDataArray[i] = getMergedCellData(mergedCellsRanges, sheet, cells, i);
        }
        rowDataArray[columnCount] = Integer.toString(sheetIdx);
        rowDataArray[columnCount + 1] = sheet.getName();
        rowDataArray[columnCount + 2] = Integer.toString(rowIdx + 1);
        
        return rowDataArray;
    }
    
    // PUBLIC METHOD (EXTERNAL INTERFACE)
    ////////////////////////////////////////////////////////////////////////////

    // private method: Cell���� data�� String�� �迭 ���·� �����Ͽ� �����Ѵ�
    private String[] getArrayFromCells(Cell[] cells) {
  
        String[] result = new String[cells.length];
        for (int i = 0; i < cells.length; i++){ 
            result[i] = FKLDataMigrationCommonUtil.getEfficientStringValue(cells[i].getContents());
        }
        
        return result;
    }

    // private method: Cell �迭 �߿��� Ư�� index �� ° Cell�� data�� �����Ѵ�. 
    // �� �ٲ� ���ڰ� �ִ� ��� �� �ٲ��� �������� ��ü�Ѵ�.
    private String getCommonCellData(Cell[] rowData, int cellIdx){
        
        String result = "";
        
        if (rowData.length > cellIdx) {
            result = FKLDataMigrationCommonUtil.getEfficientStringValue(rowData[cellIdx].getContents());
            result = result.replace('\n', ' ');
        }
            
        return result;
    }

    // private method: ���յ� Cell�� ����Ͽ� Ư�� Cell�� data�� �д´�.
    private String getMergedCellData(Range[] ranges, Sheet sheet, Cell[] rowData, int cellIdx){
        
        String result = "";
        
        if (rowData.length > cellIdx) {
            String str = FKLDataMigrationCommonUtil.getEfficientStringValue(rowData[cellIdx].getContents());

            if (FKLDataMigrationCommonUtil.isNullString(str)) {
                Range range = getRange(ranges, rowData[cellIdx]);

                if (range != null) {
                    Cell topLeftCell = range.getTopLeft();
                    Cell bottomRightCell = range.getBottomRight();
                    int x1 = topLeftCell.getColumn();
                    int y1 = topLeftCell.getRow();
                    int x2 = bottomRightCell.getColumn();
                    int y2 = bottomRightCell.getRow();
                    
                    for (int i = x1; i <= x2; i++) {
                        for (int j = y1; j <= y2; j++) {
                            Cell aCell = sheet.getCell(i, j);
                            str = FKLDataMigrationCommonUtil.getEfficientStringValue(aCell.getContents());
                            if (!FKLDataMigrationCommonUtil.isNullString(str)) break;
                        }
                    }
                }
            }
            result = str;
        }
            
        result = result.replace('\n', ' ');
        return result;
    }

    // private mathod: ���� Cell���� ������ �߿��� Ư�� Cell�� ���� ������ ã�� �����Ѵ�.
    private Range getRange(Range[] ranges, Cell cell) {

        int cellColumn = cell.getColumn();
        int cellRow = cell.getRow();

        for (int i = 0; i < ranges.length; i++) {
            Range range = ranges[i];
            Cell topLeftCell = range.getTopLeft();
            Cell bottomRightCell = range.getBottomRight();
            int x1 = topLeftCell.getColumn();
            int y1 = topLeftCell.getRow();
            int x2 = bottomRightCell.getColumn();
            int y2 = bottomRightCell.getRow();
            
            if ((x1 <= cellColumn) && (cellColumn <= x2) && (y1 <= cellRow) && (cellRow <= y2))
                return range;
        }      
        
        return null;  
    }
}

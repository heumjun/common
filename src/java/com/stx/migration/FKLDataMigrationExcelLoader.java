/**
 * <pre>
 * 프로젝트명 : FKL-PLM-MIGRATION
 * 시스템명   : MIGRATION (COMMON MODULE)
 * 버전       : 1.0
 * 작성자     : 김혜수
 * 작성일자   : 2005/06/29
 * V 1.0      : 김혜수, 2005/06/29
 * </pre>
 * 기능       : Excel 파일에서 Data를 읽는 클래스
 * 사용처     : Migration PGM
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
     * 기능 : constructor
     * 설명 : Excel 파일에서 data를 읽는 Excel Loader 객체를 생성한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param FKLDataMigrationCommonFileManager : Excel 파일들에 대한 접근을 제공하는 
     *                                            File-Manager 객체를 입력받는다.
     */
    public FKLDataMigrationExcelLoader(FKLDataMigrationCommonFileManager aFileManager) {

        fileManager = aFileManager;
    }
    
    /**
     * <pre>
     * 기능 : Title Row를 입력받는다.
     * 설명 : Title Row 즉 column 제목에 해당하는 excel row의 위치를 입력받는다.
     *        Excel Loader는 기본적으로 각 Row의 data를 읽어 Title-Data의 쌍 형태로
     *        가공하여 리턴한다. 이를 위해 Title Row 위치를 입력 받음.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Title Row의 위치
     */
    public void setTitleRowNum(int rowNum) {
        
        titleRowNum = rowNum;
    }
    
    /**
     * <pre>
     * 기능 : Data Row의 시작 위치를 입력받는다.
     * 설명 : Data Row의 시작 위치를 입력받는다. 
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Data Row의 시작 위치
     */
    public void setDataRowStartNum(int rowNum) {
        
        dataRowStartNum = rowNum;
    }
    
    /**
     * <pre>
     * 기능 : Data Row의 시작 위치를 리턴한다.
     * 설명 : Data Row의 시작 위치를 리턴한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Data Row의 시작 위치
     */
    public int getDataRowStartNum() {
        
        return dataRowStartNum;
    }
    
    /**
     * <pre>
     * 기능 : Excel 파일 개수를 리턴
     * 설명 : 수집된 대상 파일들의 개수를 리턴
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Migration 대상 Excel 파일들의 개수
     */
    public int getFilesCount() {

        return fileManager.getFilesCount();
    }
    
    /**
     * <pre>
     * 기능 : Index 번 째의 Excel 파일 객체를 리턴
     * 설명 : 파라미터로 넘어온 Index에 해당하는 순번의 파일 객체를 리턴
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Index에 해당하는 Excel 파일 객체
     */
    public File getFileAt(int idx) throws ArrayIndexOutOfBoundsException {
        
        return fileManager.getFileAt(idx);
    }
    
    /**
     * <pre>
     * 기능 : nextFile()로 접근하는 경우 다음 파일(들)이 존재하는지 여부를 리턴
     * 설명 : nextFile()로 접근하는 경우 다음 파일(들)이 존재하는지 여부를 리턴
     * V1.0 : 2005/06/29
     * </pre>
     * @return : 다음 파일이 존재하면 true, 없으면 false
     */
    public boolean hasMoreFiles() {

        return fileManager.hasMoreFiles();
    }
    
    /**
     * <pre>
     * 기능 : nextFile()로 접근하는 경우 마직막으로 접근한 파일의 다음 순번 파일을 리턴
     * 설명 : nextFile()로 접근하는 경우 마직막으로 접근한 파일의 다음 순번 파일을 리턴
     * V1.0 : 2005/06/29
     * </pre>
     * @return : 마직막으로 접근한 파일의 다음 순번 파일 객체
     */
    public File nextFile() {

        return fileManager.nextFile();
    }
    
    /**
     * <pre>
     * 기능 : Excel 파일을 입력받아 (Excel Workbook을) 파일을 open
     * 설명 : Excel 파일을 입력받아 파일을 open한다. open된 Excel 파일은
     *        Excel Workbook 형태로 접근이 가능하다.
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
     * 기능 : open된 Excel Workbook을 close
     * 설명 : open된 Excel Workbook을 close 시킨다.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : void
     */
    public void closeWorkbook() {

        if (currentWorkbook != null) currentWorkbook.close();
    }
    
    /**
     * <pre>
     * 기능 : Excel Sheet의 개수를 리턴
     * 설명 : Open된 Excel Workbook의 Sheet 개수를 리턴한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Sheet 개수
     */
    public int getSheetCount() {

        return currentSheets.length;
    }
    
    /**
     * <pre>
     * 기능 : Excel Sheet의 Row 개수를 리턴
     * 설명 : Open된 Excel Workbook의 지정된 Sheet의 Row 개수를 리턴한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Excel Sheet의 Index
     * @return : Row 개수
     */
    public int getRowCount(int sheetIdx) {

        return currentSheets[sheetIdx].getRows();
    }
    
    /**
     * <pre>
     * 기능 : Excel Sheet의 Row들 중에서 Data Row에 해당하는 Row 개수를 리턴
     * 설명 : getRowCount() 메소드와 유사하지만 Data Row에 해당하는 Row 개수만을
     *        계산하여 리턴한다. setDataRowStartNum() 메소드로 지정된 Data Row
     *        시작 위치 값을 사용하여 Data Row를 판단한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Excel Sheet의 Index
     * @return : Data Row 개수
     */
    public int getDataRowCount(int sheetIdx) {

        return currentSheets[sheetIdx].getRows() - dataRowStartNum;
    }
    
    /**
     * <pre>
     * 기능 : 병합된 셀들에 대한 범위 정보를 수집
     * 설명 : 지정된 Sheet에서 병합된 셀들에 대한 범위 정보를 수집한다.
     *        병합 셀이 존재하고 병합 셀에서 값을 정확하게 읽기 위해서 필요하다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int : Excel Sheet의 Index
     */
    public void gatterMergedCellsRanges(int sheetIdx) {
    
        currentSheets[sheetIdx].getRows(); // 이 코드는 의미 없음, 그러나 이 코드 생략하면 아래 코드가
                                           // 제대로 실행되지 않음 - jxl 버그인 듯
        mergedCellsRanges = currentSheets[sheetIdx].getMergedCells();
    }
    
    /**
     * <pre>
     * 기능 : Excel 파일의 row data를 읽는다.
     * 설명 : 지정된 Excel Sheet의 Row에 대한 Data를 읽어서 HashMap 형태로 리턴한다.
     *        setTitleRowNum() 메소드로 지정된 Title Row를 이용해서 지정된 Excel Row의
     *        각 Cell 들의 data 값을 Title-Value 형태의 Map으로 구성한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int sheetIdx : Excel Sheet의 Index
     * @param int rowIdx : Excel Row의 Index
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
     * 기능 : Excel 파일의 row data를 읽는다.
     * 설명 : getData() 메소드와 유사한데, 병합된 Cell들에 대한 처리를 추가적으로 수행한다.
     *        jxl 라이브러리는 병합된 cell에서 값을 제대로 읽지 못하기 때문에,
     *        병합된 cell인 경우 병합 cell의 범위를 파악하여 해당 범위 내에서 값을 읽도록 구현했음.
     *        이 메소드를 사용하기 위해서는 먼저 gatterMergedCellsRanges() 메소드가 호출되었어야 한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param int sheetIdx : Excel Sheet의 Index
     * @param int rowIdx : Excel Row의 Index
     * @return : 읽은 row data를 String 형 배열 형태로 리턴한다. - Title 값을 고려하지 않음.
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

    // private method: Cell들의 data를 String형 배열 형태로 구성하여 리턴한다
    private String[] getArrayFromCells(Cell[] cells) {
  
        String[] result = new String[cells.length];
        for (int i = 0; i < cells.length; i++){ 
            result[i] = FKLDataMigrationCommonUtil.getEfficientStringValue(cells[i].getContents());
        }
        
        return result;
    }

    // private method: Cell 배열 중에서 특정 index 번 째 Cell의 data를 리턴한다. 
    // 줄 바꿈 문자가 있는 경우 줄 바꿈을 공백으로 대체한다.
    private String getCommonCellData(Cell[] rowData, int cellIdx){
        
        String result = "";
        
        if (rowData.length > cellIdx) {
            result = FKLDataMigrationCommonUtil.getEfficientStringValue(rowData[cellIdx].getContents());
            result = result.replace('\n', ' ');
        }
            
        return result;
    }

    // private method: 병합된 Cell을 고려하여 특정 Cell의 data를 읽는다.
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

    // private mathod: 병합 Cell들의 범위들 중에서 특정 Cell이 속한 범위를 찾아 리턴한다.
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

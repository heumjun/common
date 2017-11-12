/**
 * <pre>
 * 프로젝트명 : FKL-PLM-MIGRATION
 * 시스템명   : MIGRATION (COMMON MODULE)
 * 버전       : 1.0
 * 작성자     : 김혜수
 * 작성일자   : 2005/06/29
 * V 1.0      : 김혜수, 2005/06/29
 * </pre>
 * 기능       : 파일들을 수집하고 수집된 파일들에 대한 접근을 제공하는 클래스
 * 사용처     : Migration PGM
 */
package com.stx.migration;
import java.util.*;
import java.io.*;

public class FKLDataMigrationCommonFileManager 
{
    private String directoryFullPath;
    private Vector filesList;
    private Enumeration filesEnum;
    
    ////////////////////////////////////////////////////////////////////////////
    // PUBLIC METHOD (EXTERNAL INTERFACE)

    /**
     * <pre>
     * 기능 : constructor
     * 설명 : FKLDataMigrationCommonFileManager 객체를 생성하고 파일들을 수집한다
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  fileSpec : 수집할 대상 파일들이 존재하는 경로.
     *                           순수한 경로명일 수도 있고 파일명까지 포함될 수도 있음
     * @param String  fileExt : 수집할 대상 파일들의 종류(확장자)를 지정
     */
    public FKLDataMigrationCommonFileManager(String fileSpec, String fileExt) throws FileNotFoundException {

        filesList = new Vector();
        getFiles(fileSpec, fileExt);
        filesEnum = filesList.elements();
    }
    
    /**
     * <pre>
     * 기능 : 전체 경로를 리턴
     * 설명 : 이 File-Manager가 관리하는 경로명을 리턴한다
     * V1.0 : 2005/06/29
     * </pre>
     * @return : 이 File-Manager가 관리하는 경로명(full path)
     */
    public String getDirectoryFullPath() {

        return directoryFullPath;
    }
    
    /**
     * <pre>
     * 기능 : 파일 개수를 리턴
     * 설명 : 수집된 대상 파일들의 개수를 리턴
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Migration 대상 파일들의 개수
     */
    public int getFilesCount() {

      return filesList.size();
    }
    
    /**
     * <pre>
     * 기능 : Index 번 째의 파일 객체를 리턴
     * 설명 : 파라미터로 넘어온 Index에 해당하는 순번의 파일 객체를 리턴
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Index에 해당하는 파일 객체
     */
    public File getFileAt(int idx) throws ArrayIndexOutOfBoundsException {
        
        return (File)filesList.elementAt(idx);
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

        return filesEnum.hasMoreElements();
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

        return (File)filesEnum.nextElement();
    }
    
    // PUBLIC METHOD (EXTERNAL INTERFACE)
    ////////////////////////////////////////////////////////////////////////////

    // private method: 지정된 경로에서 지정된 확장자에 해당하는 파일들을 수집한다
    private void getFiles(String fileSpec, String fileExt) throws FileNotFoundException {

        java.io.File file = new java.io.File(fileSpec);
    
        String path = file.getPath();
        if (FKLDataMigrationCommonUtil.isNullString(directoryFullPath)) {
            if (file.isDirectory()) directoryFullPath = path;
            else directoryFullPath = file.getParent();
        }
            
        if (file.isDirectory()) {
            String[] files = file.list();
            for (int i = 0; i < files.length; i++) {
                java.io.File subFile = new java.io.File(path, files[i]);
                
                if (subFile.exists()) {
                    if (!subFile.isDirectory()) {
                        if (!FKLDataMigrationCommonUtil.isNullString(fileExt)) {
                            String fnStr = subFile.getName().toUpperCase();
                            if (fnStr.endsWith(fileExt.toUpperCase())) 
                                filesList.addElement(subFile);
                        }
                        else {
                            filesList.addElement(subFile);
                        }
                    }
                    else {
                        getFiles(subFile.getPath(), fileExt);
                    }
                }
            }
        }
        else {
            if (!FKLDataMigrationCommonUtil.isNullString(fileExt)) {
                String fnStr = file.getName().toUpperCase();
                if (fnStr.endsWith(fileExt.toUpperCase())) 
                    filesList.addElement(file);
            }
            else {
                filesList.addElement(file);
            }
        }
    }
}

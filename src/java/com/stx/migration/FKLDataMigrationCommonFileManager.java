/**
 * <pre>
 * ������Ʈ�� : FKL-PLM-MIGRATION
 * �ý��۸�   : MIGRATION (COMMON MODULE)
 * ����       : 1.0
 * �ۼ���     : ������
 * �ۼ�����   : 2005/06/29
 * V 1.0      : ������, 2005/06/29
 * </pre>
 * ���       : ���ϵ��� �����ϰ� ������ ���ϵ鿡 ���� ������ �����ϴ� Ŭ����
 * ���ó     : Migration PGM
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
     * ��� : constructor
     * ���� : FKLDataMigrationCommonFileManager ��ü�� �����ϰ� ���ϵ��� �����Ѵ�
     * V1.0 : 2005/06/29
     * </pre>
     * @param String  fileSpec : ������ ��� ���ϵ��� �����ϴ� ���.
     *                           ������ ��θ��� ���� �ְ� ���ϸ���� ���Ե� ���� ����
     * @param String  fileExt : ������ ��� ���ϵ��� ����(Ȯ����)�� ����
     */
    public FKLDataMigrationCommonFileManager(String fileSpec, String fileExt) throws FileNotFoundException {

        filesList = new Vector();
        getFiles(fileSpec, fileExt);
        filesEnum = filesList.elements();
    }
    
    /**
     * <pre>
     * ��� : ��ü ��θ� ����
     * ���� : �� File-Manager�� �����ϴ� ��θ��� �����Ѵ�
     * V1.0 : 2005/06/29
     * </pre>
     * @return : �� File-Manager�� �����ϴ� ��θ�(full path)
     */
    public String getDirectoryFullPath() {

        return directoryFullPath;
    }
    
    /**
     * <pre>
     * ��� : ���� ������ ����
     * ���� : ������ ��� ���ϵ��� ������ ����
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Migration ��� ���ϵ��� ����
     */
    public int getFilesCount() {

      return filesList.size();
    }
    
    /**
     * <pre>
     * ��� : Index �� °�� ���� ��ü�� ����
     * ���� : �Ķ���ͷ� �Ѿ�� Index�� �ش��ϴ� ������ ���� ��ü�� ����
     * V1.0 : 2005/06/29
     * </pre>
     * @return : Index�� �ش��ϴ� ���� ��ü
     */
    public File getFileAt(int idx) throws ArrayIndexOutOfBoundsException {
        
        return (File)filesList.elementAt(idx);
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

        return filesEnum.hasMoreElements();
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

        return (File)filesEnum.nextElement();
    }
    
    // PUBLIC METHOD (EXTERNAL INTERFACE)
    ////////////////////////////////////////////////////////////////////////////

    // private method: ������ ��ο��� ������ Ȯ���ڿ� �ش��ϴ� ���ϵ��� �����Ѵ�
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

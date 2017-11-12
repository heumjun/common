/**
 * <pre>
 * ������Ʈ�� : FKL-PLM-MIGRATION
 * �ý��۸�   : MIGRATION (COMMON MODULE)
 * ����       : 1.0
 * �ۼ���     : ������
 * �ۼ�����   : 2005/06/29
 * V 1.0      : ������, 2005/06/29
 * </pre>
 * ���       : �α� ������ �����ϰ� �α׸� ����� �۾��� �����ϴ� Ŭ����
 * ���ó     : Migration PGM
 */
package com.stx.migration;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

public class FKLDataMigrationCommonLogger 
{
    private java.io.File logFile; 
    
    ////////////////////////////////////////////////////////////////////////////
    // PUBLIC METHOD (EXTERNAL INTERFACE)

    /**
     * <pre>
     * ��� : �ý��� �α׸� ����ϴ� static �޼ҵ�
     * ���� : �Էµ� ���ڿ��� �⺻ �����ġ�� ����Ѵ�
     * V1.0 : 2005/06/29
     * </pre>
     * @param String : ����� �޽���
     */
    public static void outputSysLog(String msg) {

        System.out.println(msg);    
    }
    
    /**
     * <pre>
     * ��� : �α� ���Ͽ� �� ���� �α� �޽����� ���
     * ���� : �α� ����(BufferedWriter)�� �� ���� �α� �޽����� ����Ѵ� 
     * V1.0 : 2005/06/29
     * </pre>
     * @param BufferedWriter : �α� ���Ͽ� ���⸦ ����ϴ� BufferedWriter ��ü
     * @param String : ����� �޽���
     */
    public static void writeLineLog(BufferedWriter logWriter, String str) throws IOException {

        if (logWriter != null) {
            logWriter.write(str);
            logWriter.newLine();
        }
    }
    
    /**
     * <pre>
     * ��� : �α� ������ ����
     * ���� : ������ ��ο� ���ϸ����� �α� ������ �����Ѵ�. 
     *        ������ ���ϸ��� �ڿ� �ð� ������ �߰��Ͽ� ���ϸ��� �����ϸ�,
     *        ������ �̸��� ������ �̹� �����ϴ� ��� ���� ������ �����ȴ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @param filePath : �α� ������ ������ ���
     * @param fileName : ������ �α� ������ �̸�
     * @param fileExt : ������ �α� ������ Ȯ����
     */
    public BufferedWriter setLogFile(String filePath, String fileName, String fileExt) throws Exception {

        java.io.File directory = new java.io.File(filePath);
        if (!directory.exists()) directory.mkdir();
        
        String dateTimeStr = getDateTimeString();
        String fn = fileName + "_" + dateTimeStr + fileExt; 
        
        logFile = new java.io.File(filePath, fn);
        if (logFile.exists()) logFile.delete();
        logFile.createNewFile();

        FileOutputStream fos = new FileOutputStream(logFile);
        OutputStreamWriter osw = new OutputStreamWriter(fos);
        return new BufferedWriter(osw);
    }
    
    /**
     * <pre>
     * ��� : �α� ������ ������ ����
     * ���� : ������ �α� ���� ��ü�� ���� ������ �����Ѵ�.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : ������ �α� ���� ��ü
     */
    public File getLogFile() {
        
        return logFile;
    }
    
    // PUBLIC METHOD (EXTERNAL INTERFACE)
    ////////////////////////////////////////////////////////////////////////////

    // private utility method: ���� �ð��� ����
    private String getDateTimeString() {

        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        return dateFormat.format(calendar.getTime());
    }
}

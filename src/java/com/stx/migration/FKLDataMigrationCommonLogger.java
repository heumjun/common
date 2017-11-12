/**
 * <pre>
 * 프로젝트명 : FKL-PLM-MIGRATION
 * 시스템명   : MIGRATION (COMMON MODULE)
 * 버전       : 1.0
 * 작성자     : 김혜수
 * 작성일자   : 2005/06/29
 * V 1.0      : 김혜수, 2005/06/29
 * </pre>
 * 기능       : 로그 파일을 생성하고 로그를 남기는 작업을 지원하는 클래스
 * 사용처     : Migration PGM
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
     * 기능 : 시스템 로그를 출력하는 static 메소드
     * 설명 : 입력된 문자열을 기본 출력장치로 출력한다
     * V1.0 : 2005/06/29
     * </pre>
     * @param String : 출력할 메시지
     */
    public static void outputSysLog(String msg) {

        System.out.println(msg);    
    }
    
    /**
     * <pre>
     * 기능 : 로그 파일에 한 줄의 로그 메시지를 출력
     * 설명 : 로그 파일(BufferedWriter)에 한 줄의 로그 메시지를 출력한다 
     * V1.0 : 2005/06/29
     * </pre>
     * @param BufferedWriter : 로그 파일에 쓰기를 담당하는 BufferedWriter 객체
     * @param String : 출력할 메시지
     */
    public static void writeLineLog(BufferedWriter logWriter, String str) throws IOException {

        if (logWriter != null) {
            logWriter.write(str);
            logWriter.newLine();
        }
    }
    
    /**
     * <pre>
     * 기능 : 로그 파일을 생성
     * 설명 : 지정된 경로와 파일명으로 로그 파일을 생성한다. 
     *        지정된 파일명의 뒤에 시간 정보를 추가하여 파일명을 결정하며,
     *        동일한 이름의 파일이 이미 존재하는 경우 기존 파일은 삭제된다.
     * V1.0 : 2005/06/29
     * </pre>
     * @param filePath : 로그 파일을 생성할 경로
     * @param fileName : 생성할 로그 파일의 이름
     * @param fileExt : 생성할 로그 파일의 확장자
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
     * 기능 : 로그 파일의 참조를 리턴
     * 설명 : 생성된 로그 파일 객체에 대한 참조를 리턴한다.
     * V1.0 : 2005/06/29
     * </pre>
     * @return : 생성된 로그 파일 객체
     */
    public File getLogFile() {
        
        return logFile;
    }
    
    // PUBLIC METHOD (EXTERNAL INTERFACE)
    ////////////////////////////////////////////////////////////////////////////

    // private utility method: 현재 시각을 리턴
    private String getDateTimeString() {

        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        return dateFormat.format(calendar.getTime());
    }
}

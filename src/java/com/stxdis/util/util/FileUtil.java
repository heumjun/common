package com.stxdis.util.util;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.Properties;
import java.util.ResourceBundle;
public class FileUtil extends HttpServlet { 
	
    /***2014 0228 최유진 파일 관련 유틸 **/
	private static final long serialVersionUID = 1122179082713735624L;
	private static boolean isDelete;
	private static ResourceBundle rb;
	private static ServletContext servletContext;
	   //삭제 자바는 폴더안에 파일이 비어있어야만 폴더가 삭제되어서 재귀호출함수로 해결
    public static void deleteDir(String path) {
    	  deleteDir(new File(path));
    	 }
    	 public static void deleteDir(File file) {

    	  if (!file.exists())
    	   return;

    	  File[] files = file.listFiles();
    	  for (int i = 0; i < files.length; i++) {
    	   if (files[i].isDirectory()) {
    	    deleteDir(files[i]);
    	   } else {
    	    files[i].delete();
    	   }
    	  }
    	  file.delete();
    	 }
    	 
     public static void copyTransferFile(String sourceFile, String targetFile) throws Exception {
    	        copyTransferFile(new File(sourceFile), new File(targetFile));
     }
    	 
    	    /**
    	     * 파일에서 파일로 복사한다.
    	     * 파일 객체로 parameter를 받은 경우 사용
    	     *
    	     * @param sourceFile 복사할 파일위치
    	     * @param targetFile 복사될 파일위치
    	     * @throws Exception
    	     */
    	    public static void copyTransferFile(File sourceFile, File targetFile) throws Exception {
    	        FileChannel inChannel = null;
    	        FileChannel outChannel = null;
    	        try {
    	            inChannel = new FileInputStream(sourceFile).getChannel();
    	            outChannel = new FileOutputStream(targetFile).getChannel();
    	            inChannel.transferTo(0, inChannel.size(), outChannel);
    	        } finally {
    	            try {
    	                if (inChannel != null) {
    	                    inChannel.close();
    	                }
    	                if (outChannel != null) {
    	                    outChannel.close();
    	                }
    	            } catch (IOException e) {
    	                e.printStackTrace();
    	            }
    	        }
    	        if (getDelete()) {
    	            deleteFile(sourceFile);
    	        }
    	    }
    	    
    	    /**
    	     * 삭제 여부 값을 리턴한다.
    	     *
    	     * @return 삭제 여부
    	     */
    	    public static boolean getDelete() {
    	        return isDelete;
    	    }
    	    
    	    /**
    	     * 지정된 위치의 파일을 삭제한다.
    	     * File 객체의 paramter를 받음.
    	     *
    	     * @param sourceDir 삭제할 위치
    	     * @throws Exception
    	     */
    	    public static void deleteFile(File sourceDir) throws Exception {
    	        boolean isDelete = sourceDir.delete();
    	        if (!isDelete) {
    	            throw new Exception("삭제에 실패했습니다.");
    	        }
    	    }
    	    
    	    /**
    		<pre>
    		properties에 정의된 임의 항목을 읽는다.
    		정의 되지 않은 경우에도 ""를 return한다.
    		</pre>

    		@param prop_name Property 명
    		@return String
    		*/

    	    /* 프로퍼티  구하기 */
    		public static String getProperties(String Prpath, String con) throws IOException {
    			  Properties joinProps = new Properties();
    			  String propsDir= Prpath;		// 프로퍼티스 파일의 경로 설정
    			  FileInputStream fis = new FileInputStream(propsDir);
    			  joinProps.load(fis);
    		  	  String dir = joinProps.getProperty(con);//뽑아올  내용
    			return dir;

    		}
}
/*
 * @Class Name : Pagination.java
 * @Description : 페이징 class
 * @Modification Information
 * @
 * @  수정일         수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2013.12.26    배동오         최초 생성
 *
 * @author 배동오
 * @since 2013.12.26
 * @version 1.0
 * @see
 */
package com.stxdis.util.page;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

// TODO: Auto-generated Javadoc
/**
 * The Class Pagination.
 */
public class Pagination {

	/** 현재 페이지 번호. */
	private int curPageNo = 1;

	/** 페이지당 리스트 수. */
	private int listRowCnt = 10;

	/** 보여줄 페이징 수. */
	private int pageSize = 10;

	/** 총 건 수. */
	private int totalCnt;

	/** 총 페이지 수. */
	private int totalPageCnt;

	/** 첫번째 페이지 번호. */
	private int firstPageNo;

	/** 마지막 페이지 번호. */
	private int lastPageNo;

	/** The start index. */
	private int startIndex;

	/** The end index. */
	private int endIndex;

	/** The logger. */
	Logger logger = LoggerFactory.getLogger(Pagination.class);

	/**
	 * Instantiates a new pagination.
	 */
	public Pagination() {
	}

	/**
	 * Instantiates a new pagination.
	 * 
	 * @param curPageNo
	 *            the cur page no
	 * @param listRowCnt
	 *            the list row cnt
	 * @param pageSize
	 *            the page size
	 */
	public Pagination(int curPageNo, int listRowCnt, int pageSize) {

		this.curPageNo = curPageNo;
		this.listRowCnt = listRowCnt;
		this.pageSize = pageSize;

	}

	/**
	 * Gets the cur page no.
	 * 
	 * @return the cur page no
	 */
	public int getCurPageNo() {
		return curPageNo;
	}

	/**
	 * Sets the cur page no.
	 * 
	 * @param curPageNo
	 *            the new cur page no
	 */
	public void setCurPageNo(int curPageNo) {
		this.curPageNo = curPageNo;
	}

	/**
	 * Gets the list row cnt.
	 * 
	 * @return the list row cnt
	 */
	public int getListRowCnt() {
		return listRowCnt;
	}

	/**
	 * Sets the list row cnt.
	 * 
	 * @param listRowCnt
	 *            the new list row cnt
	 */
	public void setListRowCnt(int listRowCnt) {
		this.listRowCnt = listRowCnt;
	}

	/**
	 * Gets the page size.
	 * 
	 * @return the page size
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * Sets the page size.
	 * 
	 * @param pageSize
	 *            the new page size
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * Gets the total cnt.
	 * 
	 * @return the total cnt
	 */
	public int getTotalCnt() {
		return totalCnt;
	}

	/**
	 * Sets the total cnt.
	 * 
	 * @param totalCnt
	 *            the new total cnt
	 */
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}

	/**
	 * Gets the total page cnt.
	 * 
	 * @return the total page cnt
	 */
	public int getTotalPageCnt() {
		this.totalPageCnt = ((getTotalCnt() - 1) / getListRowCnt()) + 1;
		logger.debug("totalPageCnt : " + Integer.toString(this.totalPageCnt));
		return this.totalPageCnt;
	}

	/**
	 * Sets the total page cnt.
	 * 
	 * @param totalPageCnt
	 *            the new total page cnt
	 */
	public void setTotalPageCnt(int totalPageCnt) {
		this.totalPageCnt = totalPageCnt;
	}

	/**
	 * Gets the first page no.
	 * 
	 * @return the first page no
	 */
	public int getFirstPageNo() {
		this.firstPageNo = ((getCurPageNo() - 1) / getPageSize() * getPageSize() + 1);
		logger.debug("firstPageNo : " + Integer.toString(this.firstPageNo));
		return this.firstPageNo;
	}

	/**
	 * Sets the first page no.
	 * 
	 * @param firstPageNo
	 *            the new first page no
	 */
	public void setFirstPageNo(int firstPageNo) {
		this.firstPageNo = firstPageNo;
	}

	/**
	 * Gets the last page no.
	 * 
	 * @return the last page no
	 */
	public int getLastPageNo() {
		this.lastPageNo = getFirstPageNo() + getPageSize() - 1;
		if (this.lastPageNo > getTotalPageCnt())
			this.lastPageNo = getTotalPageCnt();
		logger.debug("lastPageNo : " + Integer.toString(this.lastPageNo));
		return this.lastPageNo;
	}

	/**
	 * Sets the last page no.
	 * 
	 * @param lastPageNo
	 *            the new last page no
	 */
	public void setLastPageNo(int lastPageNo) {
		this.lastPageNo = lastPageNo;
	}

	/**
	 * Gets the start index.
	 * 
	 * @return the start index
	 */
	public int getStartIndex() {
		this.startIndex = (getCurPageNo() - 1) * getListRowCnt();
		logger.debug("startIndex : " + Integer.toString(this.startIndex));
		return startIndex;
	}

	/**
	 * Sets the start index.
	 * 
	 * @param startIndex
	 *            the new start index
	 */
	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	/**
	 * Gets the end index.
	 * 
	 * @return the end index
	 */
	public int getEndIndex() {
		this.endIndex = getCurPageNo() * getListRowCnt();
		logger.debug("endIndex : " + Integer.toString(this.endIndex));
		return endIndex;
	}

	/**
	 * Sets the end index.
	 * 
	 * @param endIndex
	 *            the new end index
	 */
	public void setEndIndex(int endIndex) {
		this.endIndex = endIndex;
	}

}

/**
 * 검색조건 높이
 * */
var G_TOP_MAIN = 79;

/**
 * 그리드 해더 1줄 높이
 * */
var G_HEADER_HEIGHT = 32;


/**
 * 그리드 해더 1줄 높이(줄내림)
 * */
var G_HEADER_HEIGHT_BR = 28.3;

/**
 * 그리드 높이
 * */
var G_GRID_HEIGHT = 450;

/**
 * 낮은 그리드 높이
 * */
var G_LOW_GRID_HEIGHT = 230;

/**
 * 그리드 내 SubSum 높이
 * */
var G_GRID_SUB_SUM = 22;

/**
 * 그리드 페이징 높이
 * */
var G_PAGER_HEIGHT = 26;

/**
 * 그리드 타이틀 높이
 * */
var G_GRID_TITLE_HEIGHT = 22.45;


/**
 * 그리드 해더 1줄, 페이징
 * */
var G_HEADER_PAGER = G_HEADER_HEIGHT + G_GRID_HEIGHT + G_PAGER_HEIGHT;

var G_TITLE_HEADER_PAGER = G_HEADER_HEIGHT + (G_GRID_HEIGHT - G_GRID_TITLE_HEIGHT) + G_PAGER_HEIGHT;

var G_HEADER_PAGER_BR = G_HEADER_HEIGHT_BR + G_GRID_HEIGHT + G_PAGER_HEIGHT;

var G_LOW_HEADER_PAGER = G_HEADER_HEIGHT + G_LOW_GRID_HEIGHT + G_PAGER_HEIGHT;

/**
 * 그리드 해더 1줄, 페이징, 그리드 서브섬Row
 * */
var G_HEADER_PAGER_SUB_SUM = G_HEADER_PAGER - G_GRID_SUB_SUM;

/**
 * 그리드 해더 2줄, 페이징
 * */
var G_HEADER2_PAGER = G_HEADER_PAGER - G_HEADER_HEIGHT;

/**
 * 조회조건 없음, 그리드 해더 1줄, 페이징
 * */
var G_NO_CONDITION_HEADER_PAGER = G_HEADER_PAGER + G_TOP_MAIN;

/**
 * 조회조건 없음, 그리드 해더 2줄, 페이징
 * */
var G_NO_CONDITION_HEADER2_PAGER = G_HEADER2_PAGER + G_TOP_MAIN;

/**
 * 그리드 해더 1줄, 페이징 없음
 * */
var G_HEADER = G_HEADER_PAGER + G_PAGER_HEIGHT;


function gridObjectHeight(headerSize){
	var sheight = null;
	var cheight = null; 
	if (navigator.userAgent.indexOf("MSIE 5.5")!=-1) {
		sheight = document.body.scrollHeight;
		cheight = document.body.clientHeight;
	} else {
		sheight = document.documentElement.scrollHeight;
		cheight = document.documentElement.clientHeight;
	}
	//alert("sheight::"+sheight);
	//alert("cheight::"+cheight);
	var positionTop = $( '.content' ).position().top;
	//alert("positionTop::"+positionTop);
	var objectHeight = sheight - positionTop - 50 - (32 * headerSize);
	
	return objectHeight;
}

function gridObjectWidth(){

	var swidth = null;
	var cwidth = null; 
	if (navigator.userAgent.indexOf("MSIE 5.5")!=-1) {
		swidth = document.body.scrollWidth;
		cwidth = document.body.clientWidth;
	} else {
		swidth = document.documentElement.scrollWidth;
		cwidth = document.documentElement.clientWidth;
	}
	//alert("sheight::"+sheight);
	//alert("cheight::"+cheight);
	var positionLeft = $( '.content' ).position().left;
	//alert("positionTop::"+positionTop);
	var objectHeight = swidth - positionLeft - 50;// - (32 * headerSize);
	
	return objectHeight;
}
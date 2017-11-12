package com.stx.tbc.dao.factory;

public abstract class FactoryDAO 
{
	public Idao create(String daoName)
	{
		Idao dao = createDao(daoName);
		return dao;
	}	
	protected abstract Idao createDao(String daoName);
}
public with sharing class Bike implements Vehicle{

	private String model {
		get { return model; }
		set { model = value; }
	}

	public Integer speedLimiter {
		get { return speedLimiter; }
		set { speedLimiter = value; if(speedLimiter > 200) speedLimiter = 200;}
	}

	public String getModel(){
		return this.model;
	}

	public Bike(String model, Integer speedLimiter) {
		this.model = model;
		this.speedLimiter = speedLimiter;
	}

	public Bike(){}
}
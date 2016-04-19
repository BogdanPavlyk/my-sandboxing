public with sharing class Road {

	private String name;
	private Integer distance;

	public String getName(){
		return this.name;
	}

	public void setName(String name){
		this.name = name;
	}

	public Integer getDistance(){
		return this.distance;
	}

	public void setDistance(Integer distance){
		this.distance = distance;
	}

	public Road(String name, Integer distance) {
		this.name = name;
		this.distance = distance;
	}

	public Road(){}
}
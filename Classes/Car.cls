public with sharing class Car implements Vehicle{

	private String model {
		get { return model; }
		set { model = value; }
	}

	private Integer speed {
		get { return speed; }
		set { speed = value; }
	}

	public String getModel(){
		return this.model;
	}
	
	public Car( String model, Integer speed) {
		this.speed = speed;
		this.model = model;
	}

	public Car(){}
	
	public Decimal timeSpentForRoad(Road road){

		Decimal distanceDEC = (Decimal) road.getDistance();
		return distanceDEC.Divide(this.speed, 2);
	}

}
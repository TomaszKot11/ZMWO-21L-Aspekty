package com.aspects;

public aspect ExerciseFourPolice {

	pointcut policeCall() : adviceexecution() && within(com.aspects.ExerciseFourHacker);
	
	void around() : policeCall() {
		return;
	}
}

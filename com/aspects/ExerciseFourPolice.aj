package com.aspects;

public aspect ExerciseFourPolice {

	pointcut policeCall() : adviceexecution() && within(aspects.ExerciseFourHacker);
	
	void around() : policeCall() {
		return;
	}
}

#include "TapeFollower.h"
#include "StandardCalc.h"

TapeFollower::TapeFollower(int* leftInputVar, int* rightInputVar, double* output)
{
	leftInput = leftInputVar;
	rightInput = rightInputVar;
	Output = output;

	fixedSampleRate = false;

	lastTime = millis();
	lastError = 0.0;
	error = 0.0;

	outMax = 100;
	outMin = -100;

	kp = new double(0);
	ki = new double(0);
	kd = new double(0);

}

double TapeFollower::Compute()
{
	timeChange = millis() - lastTime;

	if (fixedSampleRate == true && timeChange < SampleTime)
	{
		// Don't update the PID loop
		return *Output;
	} //Else, uses the time since last update to calculate PID


	updateOldData();

	error = calculateError();

	PTerm = *kp*(error);
	DTerm = *kd*(error - lastError) / timeChange;
	ITerm += *ki*(error)*timeChange;

	StandardCalc::boundValueBetween(&ITerm, outMin, outMax);

	*Output = PTerm + ITerm + DTerm;



	// Output is useful for testing
	return *Output;
}

void TapeFollower::updateOldData()
{
	lastError3 = lastError2;
	lastError2 = lastError;
	lastError = error;
	lastTime = millis();
}

double TapeFollower::calculateError()
{
	if (goingStraight())
	{
		error = 0.0;
	}
	else if (slightlyRight())
	{
		error = 1.0;
	}
	else if (slightlyLeft())
	{
		error = -1.0;
	}
	else if (tooMuchOnLeft())
	{
		error = -2.0;
	}
	else if (tooMuchOnRight())
	{
		error = 2.0;
	}
	return error;
}



void TapeFollower::attach_Kd_To(double* newKd) { delete kd; kd = newKd; }

void TapeFollower::attach_Kp_To(double* newKp) { delete kp;	kp = newKp; }

void TapeFollower::attach_Ki_To(double* newKi) { delete ki; ki = newKi; }

void TapeFollower::setKp(double newKp) { *kp = newKp; }

void TapeFollower::setKd(double newKd) { *kd = newKd; }

void TapeFollower::setKi(double newKi) { *ki = newKi; }

double TapeFollower::GetKp() { return *kp; }

double TapeFollower::GetKi() { return *ki; }

double TapeFollower::GetKd() { return *kd; }

double TapeFollower::GetError() { return error; }

void TapeFollower::tune(double newKp, double newKi, double newKd)
{
	*kp = newKp;
	*ki = newKi;
	*kd = newKd;
}

void TapeFollower::SetSampleTime(int sampleTimeInMilliseconds)
{
	SampleTime = sampleTimeInMilliseconds;
	fixedSampleRate = true;
}

inline void TapeFollower::AutoSample() { fixedSampleRate = false; }

void TapeFollower::setBounds(double newOutputMin, double newOutputMax)
{
	outMax = newOutputMax;
	outMin = newOutputMin;
}

bool TapeFollower::goingStraight() { return (*leftInput >= THRESHOLD) && (*rightInput >= THRESHOLD + 50); }

bool TapeFollower::slightlyLeft() { return ((*leftInput < THRESHOLD) && (*rightInput >= THRESHOLD + 50)); }

bool TapeFollower::slightlyRight() { return ((*leftInput >= THRESHOLD) && (*rightInput < THRESHOLD + 50)); }

bool TapeFollower::offTape() { return ((*leftInput < THRESHOLD) && (*rightInput < THRESHOLD + 50)); }

bool TapeFollower::tooMuchOnRight() { return offTape() && (lastError > 0 && lastError2 > 0 && lastError3 > 0); }

bool TapeFollower::tooMuchOnLeft() { return offTape() && (lastError < 0 && lastError2 < 0 && lastError3 < 0); }
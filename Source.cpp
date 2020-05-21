#include <GL/glut.h>
#include <iostream>
#include <string.h>
#include "f.hpp"
#include <cstdlib>

void keyCallback(unsigned char, int, int);
void draw();
void setText();
const int width = 640;
const int height = 480;
unsigned char* arr = 0;
const int dS = 10;
const int dA = 1;
const int dB = 1;
const int dC = 1;
const int dD = 1;
int S = 0;
int A = 0;
int B = 0;
int C = 0;
int D = 0;
enum Option {
	OS, OA, OB, OC, OD
} option = OS;


int main(int argc, char** argv) {

	arr = new unsigned char[width*height*3];
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE);
	glutInitWindowPosition(250,250);
	glutInitWindowSize(width,height);
	glutCreateWindow("IntelAssembler");
	glutSetKeyRepeat(GLUT_KEY_REPEAT_OFF);
	glutKeyboardFunc(keyCallback);
	draw();
	setText();
	glutSwapBuffers();
	glutMainLoop();
	return 0;
}

void keyCallback(unsigned char key, int x, int y) {
if(key == 'd') {
	if(option != OD)
		option = static_cast<Option>(static_cast<int>(option) + 1);
	setText();
}
else if(key == 'a') {
	if(option != OS)
		option = static_cast<Option>(static_cast<int>(option) - 1);
	setText();
} else {

switch(option) {
	case OS:
		if(key == 'w')
			S+=dS;
		else if(key == 's')
			if(S - dS >= 0)
				S-=dS;
		break;
	case OA:
		if(key == 'w')
			A+=dA;
		else if(key == 's')
			A-=dA;
		break;
	case OB:
		if(key == 'w')
			B+=dB;
		else if(key == 's')
			B-=dB;
		break;
	case OC:
		if(key == 'w')
			C+=dC;
		else if(key == 's')
			C-=dC;
		break;
	case OD:
		if(key == 'w')
			D+=dD;
		else if(key == 's')
			D-=dD;
		break;
	}
	draw();
	setText();
}
}
void draw() {
	f(arr, width, height, S, A, B, C ,D);
	glDrawPixels(width, height, GL_RGB, GL_UNSIGNED_BYTE, arr);
	glutSwapBuffers();
}

void setText() {
	system("clear");
	if(option == OS)
		std::cout<<"\033[34m";
	std::cout<< "S: ";
	std::cout<<"\033[0m";
	std::cout << S;
	if(option == OA)
		std::cout<<"\033[34m";
	std::cout<< " A: ";
	std::cout<<"\033[0m";
	std::cout << A;
	if(option == OB)
		std::cout<<"\033[34m";
	std::cout<< " B: ";
	std::cout<<"\033[0m";
	std::cout << B;
	if(option == OC)
		std::cout<<"\033[34m";
	std::cout<< " C: ";
	std::cout<<"\033[0m";
	std::cout << C;
	if(option == OD)
		std::cout<<"\033[34m";
	std::cout<< " D: ";
	std::cout<<"\033[0m";
	std::cout << D;
	std::cout<<std::endl;
}

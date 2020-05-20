#include <GL/glut.h>
#include <iostream>
#include "f.hpp"

void keyCallback(unsigned char, int, int);
void draw();
const int width = 640;
const int height = 480;
unsigned char* arr = 0;
int wysokosc = 0;

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
	glutSwapBuffers();
	glutMainLoop();
	return 0;
}

void keyCallback(unsigned char key, int x, int y) {
	if (key == 'w') {
		std::cout << "nacisk gora" << std::endl;
		wysokosc+=10;
	}
	else if (key == 's') {
		std::cout << "nacisk dol" << std::endl;
		wysokosc-=10;
	}
	draw();
}

void draw() {
	f(arr, width, height, wysokosc);
	glDrawPixels(width, height, GL_RGB, GL_UNSIGNED_BYTE, arr);
	glutSwapBuffers();
}

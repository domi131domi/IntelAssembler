#include <GLFW/glfw3.h>
#include <iostream>

void keyCallback(GLFWwindow *window, int key, int scancode, int action, int mods);
void draw();
const int width = 640;
const int height = 480;
unsigned char arr[height][width*3];
int wysokosc = 0;

int main(void)
{
	

	GLFWwindow* window;
	

	/* Initialize the library */
	if (!glfwInit())
		return -1;

	/* Create a windowed mode window and its OpenGL context */
	window = glfwCreateWindow(width, height, "ProjektIntel", NULL, NULL);
	glfwSetKeyCallback(window, keyCallback);

	if (!window)
	{
		glfwTerminate();
		return -1;
	}

	/* Make the window's context current */
	glfwMakeContextCurrent(window);
	draw();
	/* Loop until the user closes the window */
	while (!glfwWindowShouldClose(window))
	{
		
		glDrawPixels(width, height, GL_RGB, GL_UNSIGNED_BYTE, &arr);

		/* Swap front and back buffers */
		glfwSwapBuffers(window);

		/* Poll for and process events */
		glfwPollEvents();
	}

	glfwTerminate();
	return 0;
}

void keyCallback(GLFWwindow *window, int key, int scancode, int action, int mods) {

	if (key == GLFW_KEY_UP && action == GLFW_PRESS ) {
		std::cout << "nacisk gora" << std::endl;
		wysokosc+=10;
		draw();
	}
	else if (key == GLFW_KEY_DOWN && action == GLFW_PRESS) {
		std::cout << "nacisk dol" << std::endl;
		wysokosc-=10;
		draw();
	}
}

void draw() {
	for (int e = 0; e < height; e++)
		for (int i = 0; i < width * 3; i++)
			if (e == wysokosc)
				arr[e][i] = 255;
			else
				arr[e][i] = 150;
}
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>

using namespace cv;
using namespace std;

int main(int argc, char const* argv[])
{
    bool ShowFlag = false;
    int Width;
    int Height;
    if(argc == 4)
    {
	Width = atoi(argv[3]);
	Height = Width; // Default to this
    }
    if(argc == 5)
    {
	Width = atoi(argv[3]);
	Height = atoi(argv[4]);
    }
    if(argc == 6)
    {
	Width = atoi(argv[3]);
	Height = atoi(argv[4]);
	ShowFlag = true;
    }
    else if(argc > 6 || argc <= 2)
    {
	cout << "[ ERROR ]: Incorrect number of arguments. Usage is " << argv[0] << " <InputFile> <OuputFile> [<CropWidth> <CropHeight> <ShowFlag>]" << endl;
	return -1;
    }

    Mat Image, ImageGray, CropImage; // Image data
    vector<Vec3f > Discs; // The detected discs

    // Read image
    Image = imread(argv[1], 1);
    if(!Image.data)
    {
	cout << "[ ERROR ]: Cannot read input file. Check image format." << endl;
	return -1;
    }

    // Convert image to grayscale
    cvtColor(Image, ImageGray, CV_BGR2GRAY);

    // Reduce noise by smoothing
    GaussianBlur(ImageGray, ImageGray, Size(3, 3), 0);
    // imwrite("blurred.png", ImageGray);

    // // Test
    // Canny(ImageGray, CropImage, 25, 10);
    // imwrite("edge.png", CropImage);

    // Apply the Hough Transform to find the Discs
    HoughCircles(ImageGray, Discs, CV_HOUGH_GRADIENT, 1, ImageGray.rows/2, 20, 10, 0, 0);

    // Draw the Discs detected
    int NumDiscs = Discs.size();
    if(NumDiscs > 1)
    {
	std::cout << "[ WARNING ]: Number of discs is more than 1. Are there more hidden suns in the Solar System?" << std::endl;
    }
    else if(NumDiscs < 1)
    {
	std::cout << "[ ERROR ]: No discs found. Please check parameters." << std::endl;
	return -2;
    }

    // Assuming only one disc has been detected
    Point center(cvRound(Discs[0][0]), cvRound(Discs[0][1]));
    int radius = cvRound(Discs[0][2]);
    if(ShowFlag == true)
    {
	circle(Image, center, radius, Scalar(0, 0, 255), 1, 8, 0);
    }

    if((center.x - Width/2 + 1) >= 0 && (center.y - Height/2 + 1) >= 0 && (center.x + Width/2) < Image.cols && (center.y + Height/2) < Image.rows)
    {
	Rect DiscROI(center.x - Width/2 + 1, center.y - Height/2 + 1, Width, Height);
	CropImage = Image(DiscROI);
	imwrite(string(argv[2]), CropImage);
    }
    else
    {
	cout << "[ ERROR ]: Crop dimensions exceeds image extents. Check your crop dimensions." << endl;
	return -3;
    }

    // Show the final cropped result
    if(ShowFlag == true)
    {
	namedWindow("Detecting the Sun...", CV_WINDOW_AUTOSIZE);
	imshow("Detecting the Sun...", CropImage);

	waitKey(0);
    }
    return 0;
}


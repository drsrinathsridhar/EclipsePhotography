PROJECT(discdetector)
FIND_PACKAGE(OpenCV REQUIRED)
ADD_EXECUTABLE(${PROJECT_NAME} DiscDetector.cpp)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} ${OpenCV_LIBS})

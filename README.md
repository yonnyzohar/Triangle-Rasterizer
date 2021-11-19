# Triangle-Rasterizer
A snippet example of rasterising a triangle to screen
I've been picking apart BuildSucceeded's 3d engine code, trying to manage to understand it completely. Today I want to talk about the triangle rasteriser code which i extracted, documented and turned into a utility for future use.
He uses the industry standard technique of scan lines - that is iterating over the triangle line by line from top to bottom, filling each line with pixels.
The thing is, the lines of the triangle actually need to BE horizontal for this to work, and that's usually not the case. The solution? - split the triangle into two triangles, each of whom have a horizontal side.
The magic line of code is the one that figures out the intersection x point on the long side of the triangle (marked with yellow in the video). It does this by multiplying the slope of side 2 (the long side) with the height of side 3.
//
var midPointSlope2: Number = p2x - (side3Height * slope2);
//
The code for figuring out the step size of the uv mapping is also wonderful in its simplicity. It uses linear interpolation to figure out the starting and ending percentages in uv (between 0 and 1), and the required increment step from start to end values given the number of pixels to iterate over in each row.
I made a small widget that demonstrates how each triangle is formed.
